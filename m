Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3JNI2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:28:45 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65236 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3JNI2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:28:42 -0400
Message-ID: <525BAB32.5050901@gmail.com>
Date: Mon, 14 Oct 2013 17:28:34 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: ruby.wktk@gmail.com, mpatocka@redhat.com, devel@driverdev.osuosl.org,
        thornber@redhat.com, snitzer@redhat.com, gregkh@linuxfoundation.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org,
        m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com,
        cesarb@cesarb.net, tj@kernel.org
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52550841.5030001@gmail.com>
In-Reply-To: <52550841.5030001@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, DM Guys

I suppose I have finished the tasks to
answer Mikulas's pointing outs.
So, let me update the progress report.

The code is updated now on my Github repo.
Checkout the develop branch to avail
the latest source code.

Compilation Status
------------------
First, compilation status.
Mikulas's advised me to compile the module in
32 bit environment. and Yes, I did.
With all these kernels listed below
writeboost can compile without any error nor warning.

For 64 bit
3.2.36, 3.4.25, 3.5.7, 3.6.9, 3.7.5, 3.8.5, 3.9.8, 3.10.5, 3.11.4 and 3.12-rc1

For 32 bit
3.2.0-4-686-pae (Debian 7.1.0-i386)


Block up on error
-----------------
The most annoying thing in this update
is how to handle the I/O error.
For memory allocation error,
writeboost now makes use of mempool to avoid
the problem Mikulas's said in his last comments
but handling I/O error gracefully
when the system is running is very difficult.

My answer is 
all the daemon stop when I/O error (-EIO returned) happens
in any part of this module.
They waits on wait_queue (blockup_wait_queue)
and reactivates when sysadmin turns `blockup` variable to 0
through message interface.
When `blockup` is 1, all the incoming I/O
are returned as -EIO to the upper layer.
RETRY macro is introduced
which wraps doing I/O and
retries I/O submission if the error is -ENOMEN but
turns blockup to 1 and sleeps if the error is -EIO.
-EIO is more serious than -ENOMEM because
it may destroy the storage for some accidental problem
that we have no control in device-mapper layer
(e.g. the storage controller went crazy).
Blocking up the whole I/O is to minimize the
probable damage.

But, XFS stalls ...
-------------------
For testing,
I manually turns `blockup` to 1
when compiling Ruby is in progress
on XFS on a writeboost device.
As soon as I do it,
XFS starts to dump error message 
like "metadata I/O error: ... ("xlog_iodone") error ..."
and after few seconds it then starts to dump
like "BUG: soft lockup -CPU#3 stuck for 22s!".
The system stalls and doesn't accept the keyboard.

I think this behavior is caused by
the device always returning -EIO after turning 
the variable to 1.
But why XFS goes stalling on I/O error?
It should just suspend and starts returning
error to the upper layer as writeboost now does.
As Mikulas said the I/O error is often
due to connection failure that is usually recoverable.
Stalling the kernel will need reboot 
after recovering nevertheless writeboost
can recover just by again turning `blockup` to 0.
Any reason for this design or
existing of a option to not stall XFS on I/O error?

Thanks,
Akira

----------------------------------------------

Followed by
changes to Driver/* and Documentation

diff --git a/Driver/dm-writeboost-daemon.c b/Driver/dm-writeboost-daemon.c
index cb8febe..7a7f353 100644
--- a/Driver/dm-writeboost-daemon.c
+++ b/Driver/dm-writeboost-daemon.c
@@ -12,9 +12,11 @@
 
 int flush_proc(void *data)
 {
+	int r;
 	unsigned long flags;
 
 	struct wb_cache *cache = data;
+	struct wb_device *wb = cache->wb;
 
 	while (true) {
 		struct flush_job *job;
@@ -22,13 +24,13 @@ int flush_proc(void *data)
 		struct dm_io_request io_req;
 		struct dm_io_region region;
 
+		wait_on_blockup();
+
 		spin_lock_irqsave(&cache->flush_queue_lock, flags);
 		while (list_empty(&cache->flush_queue)) {
 			spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
-			wait_event_interruptible_timeout(
-				cache->flush_wait_queue,
-				(!list_empty(&cache->flush_queue)),
-				msecs_to_jiffies(100));
+
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));
 
 			/*
 			 * flush daemon can exit
@@ -49,6 +51,8 @@ int flush_proc(void *data)
 		list_del(&job->flush_queue);
 		spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
 
+		smp_rmb();
+
 		seg = job->seg;
 
 		io_req = (struct dm_io_request) {
@@ -65,9 +69,9 @@ int flush_proc(void *data)
 			.count = (seg->length + 1) << 3,
 		};
 
-		dm_safe_io_retry(&io_req, 1, &region, false);
+		RETRY(dm_safe_io(&io_req, 1, &region, NULL, false));
 
-		cache->last_flushed_segment_id = seg->global_id;
+		atomic64_set(&cache->last_flushed_segment_id, seg->global_id);
 
 		complete_all(&seg->flush_done);
 
@@ -78,15 +82,15 @@ int flush_proc(void *data)
 		 */
 		if (!bio_list_empty(&job->barrier_ios)) {
 			struct bio *bio;
-			blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL);
+			RETRY(blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL));
 			while ((bio = bio_list_pop(&job->barrier_ios)))
 				bio_endio(bio, 0);
 
 			mod_timer(&cache->barrier_deadline_timer,
-				  msecs_to_jiffies(cache->barrier_deadline_ms));
+				  msecs_to_jiffies(ACCESS_ONCE(cache->barrier_deadline_ms)));
 		}
 
-		kfree(job);
+		mempool_free(job, cache->flush_job_pool);
 	}
 	return 0;
 }
@@ -101,7 +105,7 @@ void queue_barrier_io(struct wb_cache *cache, struct bio *bio)
 
 	if (!timer_pending(&cache->barrier_deadline_timer))
 		mod_timer(&cache->barrier_deadline_timer,
-			  msecs_to_jiffies(cache->barrier_deadline_ms));
+			  msecs_to_jiffies(ACCESS_ONCE(cache->barrier_deadline_ms)));
 }
 
 void barrier_deadline_proc(unsigned long data)
@@ -147,6 +151,7 @@ static void migrate_endio(unsigned long error, void *context)
 static void submit_migrate_io(struct wb_cache *cache,
 			      struct segment_header *seg, size_t k)
 {
+	int r;
 	u8 i, j;
 	size_t a = cache->nr_caches_inseg * k;
 	void *p = cache->migrate_buffer + (cache->nr_caches_inseg << 12) * k;
@@ -184,7 +189,7 @@ static void submit_migrate_io(struct wb_cache *cache,
 				.sector = mb->sector,
 				.count = (1 << 3),
 			};
-			dm_safe_io_retry(&io_req_w, 1, &region_w, false);
+			RETRY(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
 		} else {
 			for (j = 0; j < 8; j++) {
 				bool b = dirty_bits & (1 << j);
@@ -205,8 +210,7 @@ static void submit_migrate_io(struct wb_cache *cache,
 					.sector = mb->sector + j,
 					.count = 1,
 				};
-				dm_safe_io_retry(
-					&io_req_w, 1, &region_w, false);
+				RETRY(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
 			}
 		}
 	}
@@ -216,7 +220,9 @@ static void memorize_dirty_state(struct wb_cache *cache,
 				 struct segment_header *seg, size_t k,
 				 size_t *migrate_io_count)
 {
+	int r;
 	u8 i, j;
+	struct wb_device *wb = cache->wb;
 	size_t a = cache->nr_caches_inseg * k;
 	void *p = cache->migrate_buffer + (cache->nr_caches_inseg << 12) * k;
 	struct metablock *mb;
@@ -233,7 +239,7 @@ static void memorize_dirty_state(struct wb_cache *cache,
 		.sector = seg->start_sector + (1 << 3),
 		.count = seg->length << 3,
 	};
-	dm_safe_io_retry(&io_req_r, 1, &region_r, false);
+	RETRY(dm_safe_io(&io_req_r, 1, &region_r, NULL, false));
 
 	/*
 	 * We take snapshot of the dirtiness in the segments.
@@ -281,6 +287,8 @@ static void cleanup_segment(struct wb_cache *cache, struct segment_header *seg)
 
 static void migrate_linked_segments(struct wb_cache *cache)
 {
+	struct wb_device *wb = cache->wb;
+	int r;
 	struct segment_header *seg;
 	size_t k, migrate_io_count = 0;
 
@@ -336,7 +344,7 @@ migrate_write:
 	 * on this issue by always
 	 * migrating those data persistently.
 	 */
-	blkdev_issue_flush(cache->wb->device->bdev, GFP_NOIO, NULL);
+	RETRY(blkdev_issue_flush(cache->wb->device->bdev, GFP_NOIO, NULL));
 
 	/*
 	 * Discarding the migrated regions
@@ -351,43 +359,46 @@ migrate_write:
 	 * will craze the cache.
 	 */
 	list_for_each_entry(seg, &cache->migrate_list, migrate_list) {
-		blkdev_issue_discard(cache->device->bdev,
-				     seg->start_sector + (1 << 3),
-				     seg->length << 3,
-				     GFP_NOIO, 0);
+		RETRY(blkdev_issue_discard(cache->device->bdev,
+					   seg->start_sector + (1 << 3),
+					   seg->length << 3,
+					   GFP_NOIO, 0));
 	}
 }
 
 int migrate_proc(void *data)
 {
 	struct wb_cache *cache = data;
+	struct wb_device *wb = cache->wb;
 
 	while (!kthread_should_stop()) {
 		bool allow_migrate;
-		size_t i, nr_mig_candidates, nr_mig, nr_max_batch;
+		u32 i, nr_mig_candidates, nr_mig, nr_max_batch;
 		struct segment_header *seg, *tmp;
 
+		wait_on_blockup();
+
 		/*
 		 * If urge_migrate is true
 		 * Migration should be immediate.
 		 */
-		allow_migrate = cache->urge_migrate ||
-				cache->allow_migrate;
+		allow_migrate = ACCESS_ONCE(cache->urge_migrate) ||
+				ACCESS_ONCE(cache->allow_migrate);
 
 		if (!allow_migrate) {
 			schedule_timeout_interruptible(msecs_to_jiffies(1000));
 			continue;
 		}
 
-		nr_mig_candidates = cache->last_flushed_segment_id -
-				    cache->last_migrated_segment_id;
+		nr_mig_candidates = atomic64_read(&cache->last_flushed_segment_id) -
+				    atomic64_read(&cache->last_migrated_segment_id);
 
 		if (!nr_mig_candidates) {
 			schedule_timeout_interruptible(msecs_to_jiffies(1000));
 			continue;
 		}
 
-		nr_max_batch = cache->nr_max_batched_migration;
+		nr_max_batch = ACCESS_ONCE(cache->nr_max_batched_migration);
 		if (cache->nr_cur_batched_migration != nr_max_batch) {
 			/*
 			 * Request buffer for nr_max_batch size.
@@ -411,10 +422,17 @@ int migrate_proc(void *data)
 		for (i = 1; i <= nr_mig; i++) {
 			seg = get_segment_header_by_id(
 					cache,
-					cache->last_migrated_segment_id + i);
+					atomic64_read(&cache->last_migrated_segment_id) + i);
 			list_add_tail(&seg->migrate_list, &cache->migrate_list);
 		}
 
+		/*
+		 * We insert write barrier here
+		 * to make sure that migrate list
+		 * is complete.
+		 */
+		smp_wmb();
+
 		migrate_linked_segments(cache);
 
 		/*
@@ -422,7 +440,7 @@ int migrate_proc(void *data)
 		 * Only line of code changes
 		 * last_migrate_segment_id during runtime.
 		 */
-		cache->last_migrated_segment_id += nr_mig;
+		atomic64_add(nr_mig, &cache->last_migrated_segment_id);
 
 		list_for_each_entry_safe(seg, tmp,
 					 &cache->migrate_list,
@@ -449,6 +467,7 @@ void wait_for_migration(struct wb_cache *cache, u64 id)
 	 * immediately.
 	 */
 	cache->urge_migrate = true;
+	wake_up_process(cache->migrate_daemon);
 	wait_for_completion(&seg->migrate_done);
 	cache->urge_migrate = false;
 }
@@ -466,14 +485,16 @@ int modulator_proc(void *data)
 
 	while (!kthread_should_stop()) {
 
+		wait_on_blockup();
+
 		new = jiffies_to_msecs(part_stat_read(hd, io_ticks));
 
-		if (!cache->enable_migration_modulator)
+		if (!ACCESS_ONCE(cache->enable_migration_modulator))
 			goto modulator_update;
 
-		util = (100 * (new - old)) / 1000;
+		util = div_u64(100 * (new - old), 1000);
 
-		if (util < wb->migrate_threshold)
+		if (util < ACCESS_ONCE(wb->migrate_threshold))
 			cache->allow_migrate = true;
 		else
 			cache->allow_migrate = false;
@@ -490,15 +511,17 @@ modulator_update:
 
 static void update_superblock_record(struct wb_cache *cache)
 {
+	int r;
+	struct wb_device *wb = cache->wb;
 	struct superblock_record_device o;
 	void *buf;
 	struct dm_io_request io_req;
 	struct dm_io_region region;
 
 	o.last_migrated_segment_id =
-		cpu_to_le64(cache->last_migrated_segment_id);
+		cpu_to_le64(atomic64_read(&cache->last_migrated_segment_id));
 
-	buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO | __GFP_ZERO);
+	buf = mempool_alloc(cache->buf_1_pool, GFP_NOIO | __GFP_ZERO);
 	memcpy(buf, &o, sizeof(o));
 
 	io_req = (struct dm_io_request) {
@@ -513,18 +536,22 @@ static void update_superblock_record(struct wb_cache *cache)
 		.sector = (1 << 11) - 1,
 		.count = 1,
 	};
-	dm_safe_io_retry(&io_req, 1, &region, true);
-	kfree(buf);
+	RETRY(dm_safe_io(&io_req, 1, &region, NULL, false));
+	mempool_free(buf, cache->buf_1_pool);
 }
 
 int recorder_proc(void *data)
 {
 	struct wb_cache *cache = data;
+	struct wb_device *wb = cache->wb;
 	unsigned long intvl;
 
 	while (!kthread_should_stop()) {
+
+		wait_on_blockup();
+
 		/* sec -> ms */
-		intvl = cache->update_record_interval * 1000;
+		intvl = ACCESS_ONCE(cache->update_record_interval) * 1000;
 
 		if (!intvl) {
 			schedule_timeout_interruptible(msecs_to_jiffies(1000));
@@ -542,12 +569,17 @@ int recorder_proc(void *data)
 
 int sync_proc(void *data)
 {
+	int r;
 	struct wb_cache *cache = data;
+	struct wb_device *wb = cache->wb;
 	unsigned long intvl;
 
 	while (!kthread_should_stop()) {
+
+		wait_on_blockup();
+
 		/* sec -> ms */
-		intvl = cache->sync_interval * 1000;
+		intvl = ACCESS_ONCE(cache->sync_interval) * 1000;
 
 		if (!intvl) {
 			schedule_timeout_interruptible(msecs_to_jiffies(1000));
@@ -555,7 +587,8 @@ int sync_proc(void *data)
 		}
 
 		flush_current_buffer(cache);
-		blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL);
+
+		RETRY(blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL));
 
 		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
 	}
diff --git a/Driver/dm-writeboost-metadata.c b/Driver/dm-writeboost-metadata.c
index 77ffb28..a6bd584 100644
--- a/Driver/dm-writeboost-metadata.c
+++ b/Driver/dm-writeboost-metadata.c
@@ -16,29 +16,31 @@ struct part {
 
 struct bigarray {
 	struct part *parts;
-	size_t nr_elems;
-	size_t elemsize;
+	u64 nr_elems;
+	u32 elemsize;
 };
 
 #define ALLOC_SIZE (1 << 16)
-static size_t nr_elems_in_part(struct bigarray *arr)
+static u32 nr_elems_in_part(struct bigarray *arr)
 {
-	return ALLOC_SIZE / arr->elemsize;
+	return div_u64(ALLOC_SIZE, arr->elemsize);
 };
 
-static size_t nr_parts(struct bigarray *arr)
+static u64 nr_parts(struct bigarray *arr)
 {
-	return dm_div_up(arr->nr_elems, nr_elems_in_part(arr));
+	u64 a = arr->nr_elems;
+	u32 b = nr_elems_in_part(arr);
+	return div_u64(a + b - 1, b);
 }
 
-static struct bigarray *make_bigarray(size_t elemsize, size_t nr_elems)
+static struct bigarray *make_bigarray(u32 elemsize, u64 nr_elems)
 {
-	size_t i, j;
+	u64 i, j;
 	struct part *part;
 
 	struct bigarray *arr = kmalloc(sizeof(*arr), GFP_KERNEL);
 	if (!arr) {
-		WBERR();
+		WBERR("failed to alloc arr");
 		return NULL;
 	}
 
@@ -46,7 +48,7 @@ static struct bigarray *make_bigarray(size_t elemsize, size_t nr_elems)
 	arr->nr_elems = nr_elems;
 	arr->parts = kmalloc(sizeof(struct part) * nr_parts(arr), GFP_KERNEL);
 	if (!arr->parts) {
-		WBERR();
+		WBERR("failed to alloc parts");
 		goto bad_alloc_parts;
 	}
 
@@ -54,7 +56,7 @@ static struct bigarray *make_bigarray(size_t elemsize, size_t nr_elems)
 		part = arr->parts + i;
 		part->memory = kmalloc(ALLOC_SIZE, GFP_KERNEL);
 		if (!part->memory) {
-			WBERR();
+			WBERR("failed to alloc part memory");
 			for (j = 0; j < i; j++) {
 				part = arr->parts + j;
 				kfree(part->memory);
@@ -82,11 +84,11 @@ static void kill_bigarray(struct bigarray *arr)
 	kfree(arr);
 }
 
-static void *bigarray_at(struct bigarray *arr, size_t i)
+static void *bigarray_at(struct bigarray *arr, u64 i)
 {
-	size_t n = nr_elems_in_part(arr);
-	size_t j = i / n;
-	size_t k = i % n;
+	u32 n = nr_elems_in_part(arr);
+	u32 k;
+	u64 j = div_u64_rem(i, n, &k);
 	struct part *part = arr->parts + j;
 	return part->memory + (arr->elemsize * k);
 }
@@ -104,18 +106,18 @@ static void *bigarray_at(struct bigarray *arr, size_t i)
 /*
  * Get the in-core metablock of the given index.
  */
-static struct metablock *mb_at(struct wb_cache *cache, cache_nr idx)
+static struct metablock *mb_at(struct wb_cache *cache, u32 idx)
 {
-	u64 seg_idx = idx / cache->nr_caches_inseg;
+	u32 idx_inseg;
+	u32 seg_idx = div_u64_rem(idx, cache->nr_caches_inseg, &idx_inseg);
 	struct segment_header *seg =
 		bigarray_at(cache->segment_header_array, seg_idx);
-	cache_nr idx_inseg = idx % cache->nr_caches_inseg;
 	return seg->mb_array + idx_inseg;
 }
 
 static void mb_array_empty_init(struct wb_cache *cache)
 {
-	size_t i;
+	u32 i;
 	for (i = 0; i < cache->nr_caches; i++) {
 		struct metablock *mb = mb_at(cache, i);
 		INIT_HLIST_NODE(&mb->ht_list);
@@ -126,34 +128,35 @@ static void mb_array_empty_init(struct wb_cache *cache)
 }
 
 static sector_t calc_segment_header_start(struct wb_cache *cache,
-					  u64 segment_idx)
+					  u32 segment_idx)
 {
 	return (1 << 11) + (1 << cache->segment_size_order) * (segment_idx);
 }
 
 static u32 calc_segment_lap(struct wb_cache *cache, u64 segment_id)
 {
-	u32 a = (segment_id - 1) / cache->nr_segments;
+	u64 a = div_u64(segment_id - 1, cache->nr_segments);
 	return a + 1;
 };
 
-static u64 calc_nr_segments(struct dm_dev *dev, struct wb_cache *cache)
+static u32 calc_nr_segments(struct dm_dev *dev, struct wb_cache *cache)
 {
 	sector_t devsize = dm_devsize(dev);
-	return (devsize - (1 << 11)) / (1 << cache->segment_size_order);
+	return div_u64(devsize - (1 << 11), 1 << cache->segment_size_order);
 }
 
 sector_t calc_mb_start_sector(struct wb_cache *cache,
 			      struct segment_header *seg,
-			      cache_nr mb_idx)
+			      u32 mb_idx)
 {
-	size_t k = 1 + (mb_idx % cache->nr_caches_inseg);
-	return seg->start_sector + (k << 3);
+	u32 idx;
+	div_u64_rem(mb_idx, cache->nr_caches_inseg, &idx);
+	return seg->start_sector + ((1 + idx) << 3);
 }
 
-bool is_on_buffer(struct wb_cache *cache, cache_nr mb_idx)
+bool is_on_buffer(struct wb_cache *cache, u32 mb_idx)
 {
-	cache_nr start = cache->current_seg->start_idx;
+	u32 start = cache->current_seg->start_idx;
 	if (mb_idx < start)
 		return false;
 
@@ -170,15 +173,14 @@ bool is_on_buffer(struct wb_cache *cache, cache_nr mb_idx)
 struct segment_header *get_segment_header_by_id(struct wb_cache *cache,
 						u64 segment_id)
 {
-	struct segment_header *r =
-		bigarray_at(cache->segment_header_array,
-		       (segment_id - 1) % cache->nr_segments);
-	return r;
+	u32 idx;
+	div_u64_rem(segment_id - 1, cache->nr_segments, &idx);
+	return bigarray_at(cache->segment_header_array, idx);
 }
 
 static int __must_check init_segment_header_array(struct wb_cache *cache)
 {
-	u64 segment_idx, nr_segments = cache->nr_segments;
+	u32 segment_idx, nr_segments = cache->nr_segments;
 	cache->segment_header_array =
 		make_bigarray(sizeof_segment_header(cache), nr_segments);
 	if (!cache->segment_header_array) {
@@ -225,9 +227,8 @@ static void free_segment_header_array(struct wb_cache *cache)
  */
 static int __must_check ht_empty_init(struct wb_cache *cache)
 {
-	cache_nr idx;
-	size_t i;
-	size_t nr_heads;
+	u32 idx;
+	size_t i, nr_heads;
 	struct bigarray *arr;
 
 	cache->htsize = cache->nr_caches;
@@ -266,7 +267,9 @@ static void free_ht(struct wb_cache *cache)
 
 struct ht_head *ht_get_head(struct wb_cache *cache, struct lookup_key *key)
 {
-	return bigarray_at(cache->htable, key->sector % cache->htsize);
+	u32 idx;
+	div_u64_rem(key->sector, cache->htsize, &idx);
+	return bigarray_at(cache->htable, idx);
 }
 
 static bool mb_hit(struct metablock *mb, struct lookup_key *key)
@@ -328,12 +331,14 @@ void discard_caches_inseg(struct wb_cache *cache, struct segment_header *seg)
 
 /*----------------------------------------------------------------*/
 
-static int read_superblock_header(struct superblock_header_device *sup,
+static int read_superblock_header(struct wb_cache *cache,
+				  struct superblock_header_device *sup,
 				  struct dm_dev *dev)
 {
 	int r = 0;
 	struct dm_io_request io_req_sup;
 	struct dm_io_region region_sup;
+	struct wb_device *wb = cache->wb;
 
 	void *buf = kmalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
 	if (!buf) {
@@ -358,7 +363,7 @@ static int read_superblock_header(struct superblock_header_device *sup,
 	kfree(buf);
 
 	if (r) {
-		WBERR();
+		WBERR("io failed in reading superblock header");
 		return r;
 	}
 
@@ -378,7 +383,7 @@ int __must_check audit_cache_device(struct dm_dev *dev, struct wb_cache *cache,
 {
 	int r = 0;
 	struct superblock_header_device sup;
-	r = read_superblock_header(&sup, dev);
+	r = read_superblock_header(cache, &sup, dev);
 	if (r) {
 		WBERR("read superblock header failed");
 		return r;
@@ -407,6 +412,7 @@ int __must_check audit_cache_device(struct dm_dev *dev, struct wb_cache *cache,
 static int format_superblock_header(struct dm_dev *dev, struct wb_cache *cache)
 {
 	int r = 0;
+	struct wb_device *wb = cache->wb;
 	struct dm_io_request io_req_sup;
 	struct dm_io_region region_sup;
 
@@ -465,7 +471,8 @@ static void format_segmd_endio(unsigned long error, void *__context)
  */
 int __must_check format_cache_device(struct dm_dev *dev, struct wb_cache *cache)
 {
-	u64 i, nr_segments = calc_nr_segments(dev, cache);
+	u32 i, nr_segments = calc_nr_segments(dev, cache);
+	struct wb_device *wb = cache->wb;
 	struct format_segmd_context context;
 	struct dm_io_request io_req_sup;
 	struct dm_io_region region_sup;
@@ -569,6 +576,7 @@ read_superblock_record(struct superblock_record_device *record,
 		       struct wb_cache *cache)
 {
 	int r = 0;
+	struct wb_device *wb = cache->wb;
 	struct dm_io_request io_req;
 	struct dm_io_region region;
 
@@ -590,7 +598,7 @@ read_superblock_record(struct superblock_record_device *record,
 		.sector = (1 << 11) - 1,
 		.count = 1,
 	};
-	r = dm_safe_io(&io_req, 1, &region, NULL, true);
+	r = dm_safe_io(&io_req, 1, &region, NULL, false);
 
 	kfree(buf);
 
@@ -606,9 +614,10 @@ read_superblock_record(struct superblock_record_device *record,
 
 static int __must_check
 read_segment_header_device(struct segment_header_device *dest,
-			   struct wb_cache *cache, size_t segment_idx)
+			   struct wb_cache *cache, u32 segment_idx)
 {
 	int r = 0;
+	struct wb_device *wb = cache->wb;
 	struct dm_io_request io_req;
 	struct dm_io_region region;
 	void *buf = kmalloc(1 << 12, GFP_KERNEL);
@@ -651,15 +660,16 @@ void prepare_segment_header_device(struct segment_header_device *dest,
 				   struct wb_cache *cache,
 				   struct segment_header *src)
 {
-	cache_nr i;
 	u8 left, right;
+	u32 i, tmp32;
 
 	dest->global_id = cpu_to_le64(src->global_id);
 	dest->length = src->length;
 	dest->lap = cpu_to_le32(calc_segment_lap(cache, src->global_id));
 
 	left = src->length - 1;
-	right = (cache->cursor) % cache->nr_caches_inseg;
+	div_u64_rem(cache->cursor, cache->nr_caches_inseg, &tmp32);
+	right = tmp32;
 	BUG_ON(left != right);
 
 	for (i = 0; i < src->length; i++) {
@@ -679,7 +689,7 @@ void prepare_segment_header_device(struct segment_header_device *dest,
 static void update_by_segment_header_device(struct wb_cache *cache,
 					    struct segment_header_device *src)
 {
-	cache_nr i;
+	u32 i;
 	struct segment_header *seg =
 		get_segment_header_by_id(cache, src->global_id);
 	seg->length = src->length;
@@ -739,10 +749,9 @@ static int __must_check recover_cache(struct wb_cache *cache)
 	int r = 0;
 	struct segment_header_device *header;
 	struct segment_header *seg;
-	u64 i, j,
-	    max_id, oldest_id, last_flushed_id, init_segment_id,
-	    oldest_idx, nr_segments = cache->nr_segments,
+	u64 max_id, oldest_id, last_flushed_id, init_segment_id,
 	    header_id, record_id;
+	u32 i, j, oldest_idx, nr_segments = cache->nr_segments;
 
 	struct superblock_record_device uninitialized_var(record);
 	r = read_superblock_record(&record, cache);
@@ -815,7 +824,7 @@ static int __must_check recover_cache(struct wb_cache *cache)
 	 *      last_flushed  init_seg  migrated  last_migrated  flushed
 	 */
 	for (i = oldest_idx; i < (nr_segments + oldest_idx); i++) {
-		j = i % nr_segments;
+		div_u64_rem(i, nr_segments, &j);
 		r = read_segment_header_device(header, cache, j);
 		if (r) {
 			WBERR();
@@ -871,14 +880,15 @@ setup_init_segment:
 	seg->global_id = init_segment_id;
 	atomic_set(&seg->nr_inflight_ios, 0);
 
-	cache->last_flushed_segment_id = seg->global_id - 1;
+	atomic64_set(&cache->last_flushed_segment_id,
+		     seg->global_id - 1);
 
-	cache->last_migrated_segment_id =
-		cache->last_flushed_segment_id > cache->nr_segments ?
-		cache->last_flushed_segment_id - cache->nr_segments : 0;
+	atomic64_set(&cache->last_migrated_segment_id,
+		atomic64_read(&cache->last_flushed_segment_id) > cache->nr_segments ?
+		atomic64_read(&cache->last_flushed_segment_id) - cache->nr_segments : 0);
 
-	if (record_id > cache->last_migrated_segment_id)
-		cache->last_migrated_segment_id = record_id;
+	if (record_id > atomic64_read(&cache->last_migrated_segment_id))
+		atomic64_set(&cache->last_migrated_segment_id, record_id);
 
 	wait_for_migration(cache, seg->global_id);
 
@@ -903,9 +913,14 @@ static int __must_check init_rambuf_pool(struct wb_cache *cache)
 	size_t i, j;
 	struct rambuffer *rambuf;
 
-	/* tmp var to avoid 80 cols */
-	size_t nr = (RAMBUF_POOL_ALLOCATED * 1000000) /
-		    (1 << (cache->segment_size_order + SECTOR_SHIFT));
+	u32 nr = div_u64(cache->rambuf_pool_amount * 1000,
+			 1 << (cache->segment_size_order + SECTOR_SHIFT));
+
+	if (!nr) {
+		WBERR("rambuf must be allocated at least one");
+		return -EINVAL;
+	}
+
 	cache->nr_rambuf_pool = nr;
 	cache->rambuf_pool = kmalloc(sizeof(struct rambuffer) * nr,
 				     GFP_KERNEL);
@@ -1024,24 +1039,44 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 	/*
 	 * (i) Harmless Initializations
 	 */
+	cache->buf_1_pool = mempool_create_kmalloc_pool(16, 1 << SECTOR_SHIFT);
+	if (!cache->buf_1_pool) {
+		r = -ENOMEM;
+		WBERR("couldn't alloc 1 sector pool");
+		goto bad_buf_1_pool;
+	}
+	cache->buf_8_pool = mempool_create_kmalloc_pool(16, 8 << SECTOR_SHIFT);
+	if (!cache->buf_8_pool) {
+		r = -ENOMEM;
+		WBERR("couldn't alloc 8 sector pool");
+		goto bad_buf_8_pool;
+	}
+
 	r = init_rambuf_pool(cache);
 	if (r) {
-		WBERR();
+		WBERR("couldn't alloc rambuf pool");
 		goto bad_init_rambuf_pool;
 	}
+	cache->flush_job_pool = mempool_create_kmalloc_pool(cache->nr_rambuf_pool,
+							    sizeof(struct flush_job));
+	if (!cache->flush_job_pool) {
+		r = -ENOMEM;
+		WBERR("couldn't alloc flush job pool");
+		goto bad_flush_job_pool;
+	}
 
 	/* Select arbitrary one as the initial rambuffer. */
 	cache->current_rambuf = cache->rambuf_pool + 0;
 
 	r = init_segment_header_array(cache);
 	if (r) {
-		WBERR();
+		WBERR("couldn't alloc segment header array");
 		goto bad_alloc_segment_header_array;
 	}
 
 	r = ht_empty_init(cache);
 	if (r) {
-		WBERR();
+		WBERR("couldn't alloc hashtable");
 		goto bad_alloc_ht;
 	}
 
@@ -1077,7 +1112,7 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 
 	r = recover_cache(cache);
 	if (r) {
-		WBERR();
+		WBERR("recovering cache metadata failed");
 		goto bad_recover;
 	}
 
@@ -1091,7 +1126,6 @@ int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev)
 	/* Flush Daemon */
 	spin_lock_init(&cache->flush_queue_lock);
 	INIT_LIST_HEAD(&cache->flush_queue);
-	init_waitqueue_head(&cache->flush_wait_queue);
 	CREATE_DAEMON(flush);
 
 	/* Deferred ACK for barrier writes */
@@ -1140,9 +1174,14 @@ bad_alloc_migrate_buffer:
 bad_alloc_ht:
 	free_segment_header_array(cache);
 bad_alloc_segment_header_array:
+	mempool_destroy(cache->flush_job_pool);
+bad_flush_job_pool:
 	free_rambuf_pool(cache);
 bad_init_rambuf_pool:
-	kfree(cache);
+	mempool_destroy(cache->buf_8_pool);
+bad_buf_8_pool:
+	mempool_destroy(cache->buf_1_pool);
+bad_buf_1_pool:
 	return r;
 }
 
diff --git a/Driver/dm-writeboost-metadata.h b/Driver/dm-writeboost-metadata.h
index 2e59041..709dfda 100644
--- a/Driver/dm-writeboost-metadata.h
+++ b/Driver/dm-writeboost-metadata.h
@@ -12,8 +12,8 @@
 struct segment_header *get_segment_header_by_id(struct wb_cache *,
 						u64 segment_id);
 sector_t calc_mb_start_sector(struct wb_cache *,
-			      struct segment_header *, cache_nr mb_idx);
-bool is_on_buffer(struct wb_cache *, cache_nr mb_idx);
+			      struct segment_header *, u32 mb_idx);
+bool is_on_buffer(struct wb_cache *, u32 mb_idx);
 
 /*----------------------------------------------------------------*/
 
diff --git a/Driver/dm-writeboost-target.c b/Driver/dm-writeboost-target.c
index 4b5b7aa..8e40f15 100644
--- a/Driver/dm-writeboost-target.c
+++ b/Driver/dm-writeboost-target.c
@@ -13,23 +13,6 @@
 
 /*----------------------------------------------------------------*/
 
-void *do_kmalloc_retry(size_t size, gfp_t flags, const char *caller)
-{
-	size_t count = 0;
-	void *p;
-
-retry_alloc:
-	p = kmalloc(size, flags);
-	if (!p) {
-		count++;
-		WBWARN("%s() allocation failed size:%lu, count:%lu",
-		       caller, size, count);
-		schedule_timeout_interruptible(msecs_to_jiffies(1));
-		goto retry_alloc;
-	}
-	return p;
-}
-
 struct safe_io {
 	struct work_struct work;
 	int err;
@@ -52,6 +35,7 @@ static void safe_io_proc(struct work_struct *work)
  * @thread run this operation in other thread to avoid deadlock.
  */
 int dm_safe_io_internal(
+		struct wb_device *wb,
 		struct dm_io_request *io_req,
 		unsigned num_regions, struct dm_io_region *regions,
 		unsigned long *err_bits, bool thread, const char *caller)
@@ -68,6 +52,11 @@ int dm_safe_io_internal(
 
 		INIT_WORK_ONSTACK(&io.work, safe_io_proc);
 
+		/*
+		 * don't go on submitting I/O
+		 * minimizes the risk of breaking the data.
+		 */
+		wait_on_blockup();
 		queue_work(safe_io_wq, &io.work);
 		flush_work(&io.work);
 
@@ -75,6 +64,7 @@ int dm_safe_io_internal(
 		if (err_bits)
 			*err_bits = io.err_bits;
 	} else {
+		wait_on_blockup();
 		err = dm_io(io_req, num_regions, regions, err_bits);
 	}
 
@@ -87,45 +77,15 @@ int dm_safe_io_internal(
 			eb = (~(unsigned long)0);
 		else
 			eb = *err_bits;
-		WBERR("%s() io error err(%d, %lu), rw(%d), sector(%lu), dev(%u:%u)",
+		WBERR("%s() I/O error err(%d, %lu), rw(%d), sector(%llu), dev(%u:%u)",
 		      caller, err, eb,
-		      io_req->bi_rw, regions->sector,
+		      io_req->bi_rw, (unsigned long long) regions->sector,
 		      MAJOR(dev), MINOR(dev));
 	}
 
 	return err;
 }
 
-void dm_safe_io_retry_internal(
-		struct dm_io_request *io_req,
-		unsigned num_regions, struct dm_io_region *regions,
-		bool thread, const char *caller)
-{
-	int err, count = 0;
-	unsigned long err_bits;
-	dev_t dev;
-
-retry_io:
-	err_bits = 0;
-	err = dm_safe_io_internal(io_req, num_regions, regions, &err_bits,
-				  thread, caller);
-
-	dev = regions->bdev->bd_dev;
-	if (err || err_bits) {
-		count++;
-		WBWARN("%s() io error count(%d)", caller, count);
-		schedule_timeout_interruptible(msecs_to_jiffies(1000));
-		goto retry_io;
-	}
-
-	if (count) {
-		WBWARN("%s() recover from io error rw(%d), sector(%lu), dev(%u:%u)",
-		       caller,
-		       io_req->bi_rw, regions->sector,
-		       MAJOR(dev), MINOR(dev));
-	}
-}
-
 sector_t dm_devsize(struct dm_dev *dev)
 {
 	return i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
@@ -165,12 +125,13 @@ static void queue_flushing(struct wb_cache *cache)
 	bool empty;
 	struct rambuffer *next_rambuf;
 	size_t n1 = 0, n2 = 0;
+	u32 tmp32;
 	u64 next_id;
 
 	while (atomic_read(&current_seg->nr_inflight_ios)) {
 		n1++;
 		if (n1 == 100)
-			WBWARN();
+			WBWARN("inflight ios remained for current seg");
 		schedule_timeout_interruptible(msecs_to_jiffies(1));
 	}
 
@@ -180,7 +141,7 @@ static void queue_flushing(struct wb_cache *cache)
 	INIT_COMPLETION(current_seg->migrate_done);
 	INIT_COMPLETION(current_seg->flush_done);
 
-	job = kmalloc_retry(sizeof(*job), GFP_NOIO);
+	job = mempool_alloc(cache->flush_job_pool, GFP_NOIO);
 	INIT_LIST_HEAD(&job->flush_queue);
 	job->seg = current_seg;
 	job->rambuf = cache->current_rambuf;
@@ -189,12 +150,21 @@ static void queue_flushing(struct wb_cache *cache)
 	bio_list_merge(&job->barrier_ios, &cache->barrier_ios);
 	bio_list_init(&cache->barrier_ios);
 
+	/*
+	 * Queuing imcomplete flush job
+	 * will let flush daemon go wild.
+	 * We put write barrier to make sure
+	 * that job is completely initizalied.
+	 */
+	smp_wmb();
+
 	spin_lock_irqsave(&cache->flush_queue_lock, flags);
 	empty = list_empty(&cache->flush_queue);
 	list_add_tail(&job->flush_queue, &cache->flush_queue);
 	spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
+
 	if (empty)
-		wake_up_interruptible(&cache->flush_wait_queue);
+		wake_up_process(cache->flush_daemon);
 
 	next_id = current_seg->global_id + 1;
 	new_seg = get_segment_header_by_id(cache, next_id);
@@ -203,7 +173,7 @@ static void queue_flushing(struct wb_cache *cache)
 	while (atomic_read(&new_seg->nr_inflight_ios)) {
 		n2++;
 		if (n2 == 100)
-			WBWARN();
+			WBWARN("inflight ios remained for new seg");
 		schedule_timeout_interruptible(msecs_to_jiffies(1));
 	}
 
@@ -217,7 +187,8 @@ static void queue_flushing(struct wb_cache *cache)
 	cache->cursor = current_seg->start_idx + (cache->nr_caches_inseg - 1);
 	new_seg->length = 0;
 
-	next_rambuf = cache->rambuf_pool + (next_id % cache->nr_rambuf_pool);
+	div_u64_rem(next_id, cache->nr_rambuf_pool, &tmp32);
+	next_rambuf = cache->rambuf_pool + tmp32;
 	wait_for_completion(&next_rambuf->done);
 	INIT_COMPLETION(next_rambuf->done);
 
@@ -255,12 +226,14 @@ static void queue_current_buffer(struct wb_cache *cache)
 void flush_current_buffer(struct wb_cache *cache)
 {
 	struct segment_header *old_seg;
+	u32 tmp32;
 
 	mutex_lock(&cache->io_lock);
 	old_seg = cache->current_seg;
 
 	queue_current_buffer(cache);
-	cache->cursor = (cache->cursor + 1) % cache->nr_caches;
+	div_u64_rem(cache->cursor + 1, cache->nr_caches, &tmp32);
+	cache->cursor = tmp32;
 	cache->current_seg->length = 1;
 	mutex_unlock(&cache->io_lock);
 
@@ -345,13 +318,14 @@ static void clear_stat(struct wb_cache *cache)
 static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 		       struct metablock *mb, u8 dirty_bits, bool thread)
 {
+	int r;
 	struct wb_device *wb = cache->wb;
 
 	if (!dirty_bits)
 		return;
 
 	if (dirty_bits == 255) {
-		void *buf = kmalloc_retry(1 << 12, GFP_NOIO);
+		void *buf = mempool_alloc(cache->buf_8_pool, GFP_NOIO);
 		struct dm_io_request io_req_r, io_req_w;
 		struct dm_io_region region_r, region_w;
 
@@ -367,8 +341,7 @@ static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 			.sector = calc_mb_start_sector(cache, seg, mb->idx),
 			.count = (1 << 3),
 		};
-
-		dm_safe_io_retry(&io_req_r, 1, &region_r, thread);
+		RETRY(dm_safe_io(&io_req_r, 1, &region_r, NULL, thread));
 
 		io_req_w = (struct dm_io_request) {
 			.client = wb_io_client,
@@ -382,11 +355,11 @@ static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 			.sector = mb->sector,
 			.count = (1 << 3),
 		};
-		dm_safe_io_retry(&io_req_w, 1, &region_w, thread);
+		RETRY(dm_safe_io(&io_req_w, 1, &region_w, NULL, thread));
 
-		kfree(buf);
+		mempool_free(buf, cache->buf_8_pool);
 	} else {
-		void *buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO);
+		void *buf = mempool_alloc(cache->buf_1_pool, GFP_NOIO);
 		size_t i;
 		for (i = 0; i < 8; i++) {
 			bool bit_on = dirty_bits & (1 << i);
@@ -411,7 +384,7 @@ static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 				.sector = src,
 				.count = 1,
 			};
-			dm_safe_io_retry(&io_req_r, 1, &region_r, thread);
+			RETRY(dm_safe_io(&io_req_r, 1, &region_r, NULL, thread));
 
 			io_req_w = (struct dm_io_request) {
 				.client = wb_io_client,
@@ -425,9 +398,9 @@ static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 				.sector = mb->sector + 1 * i,
 				.count = 1,
 			};
-			dm_safe_io_retry(&io_req_w, 1, &region_w, thread);
+			RETRY(dm_safe_io(&io_req_w, 1, &region_w, NULL, thread));
 		}
-		kfree(buf);
+		mempool_free(buf, cache->buf_1_pool);
 	}
 }
 
@@ -438,12 +411,17 @@ static void migrate_mb(struct wb_cache *cache, struct segment_header *seg,
 static void migrate_buffered_mb(struct wb_cache *cache,
 				struct metablock *mb, u8 dirty_bits)
 {
+	int r;
 	struct wb_device *wb = cache->wb;
+	u8 i;
+	sector_t offset;
+	void *buf;
 
-	u8 i, k = 1 + (mb->idx % cache->nr_caches_inseg);
-	sector_t offset = (k << 3);
+	u32 k;
+	div_u64_rem(mb->idx, cache->nr_caches_inseg, &k);
+	offset = ((k + 1) << 3);
 
-	void *buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO);
+	buf = mempool_alloc(cache->buf_1_pool, GFP_NOIO);
 	for (i = 0; i < 8; i++) {
 		struct dm_io_request io_req;
 		struct dm_io_region region;
@@ -473,9 +451,9 @@ static void migrate_buffered_mb(struct wb_cache *cache,
 			.count = 1,
 		};
 
-		dm_safe_io_retry(&io_req, 1, &region, true);
+		RETRY(dm_safe_io(&io_req, 1, &region, NULL, true));
 	}
-	kfree(buf);
+	mempool_free(buf, cache->buf_1_pool);
 }
 
 static void bio_remap(struct bio *bio, struct dm_dev *dev, sector_t sector)
@@ -487,7 +465,7 @@ static void bio_remap(struct bio *bio, struct dm_dev *dev, sector_t sector)
 static sector_t calc_cache_alignment(struct wb_cache *cache,
 				     sector_t bio_sector)
 {
-	return (bio_sector / (1 << 3)) * (1 << 3);
+	return div_u64(bio_sector, 1 << 3) * (1 << 3);
 }
 
 static int writeboost_map(struct dm_target *ti, struct bio *bio
@@ -502,13 +480,15 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
 #if LINUX_VERSION_CODE >= PER_BIO_VERSION
 	struct per_bio_data *map_context;
 #endif
-	sector_t bio_count, bio_offset, s;
+	sector_t bio_count, s;
+	u8 bio_offset;
+	u32 tmp32;
 	bool bio_fullsize, found, on_buffer,
 	     refresh_segment, b;
 	int rw;
 	struct lookup_key key;
 	struct ht_head *head;
-	cache_nr update_mb_idx, idx_inseg;
+	u32 update_mb_idx;
 	size_t start;
 	void *data;
 
@@ -516,6 +496,9 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
 	struct wb_cache *cache = wb->cache;
 	struct dm_dev *orig = wb->device;
 
+	if (ACCESS_ONCE(wb->blockup))
+		return -EIO;
+
 #if LINUX_VERSION_CODE >= PER_BIO_VERSION
 	map_context = dm_per_bio_data(bio, ti->per_bio_data_size);
 #endif
@@ -552,7 +535,8 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
 
 	bio_count = bio->bi_size >> SECTOR_SHIFT;
 	bio_fullsize = (bio_count == (1 << 3));
-	bio_offset = bio->bi_sector % (1 << 3);
+	div_u64_rem(bio->bi_sector, 1 << 3, &tmp32);
+	bio_offset = tmp32;
 
 	rw = bio_data_dir(bio);
 
@@ -580,8 +564,8 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
 	mutex_lock(&cache->io_lock);
 	mb = ht_lookup(cache, head, &key);
 	if (mb) {
-		seg = ((void *) mb) - (mb->idx % cache->nr_caches_inseg) *
-				      sizeof(struct metablock)
+		div_u64_rem(mb->idx, cache->nr_caches_inseg, &tmp32);
+		seg = ((void *) mb) - tmp32 * sizeof(struct metablock)
 				    - sizeof(struct segment_header);
 		atomic_inc(&seg->nr_inflight_ios);
 	}
@@ -723,12 +707,14 @@ write_not_found:
 	 * We must flush the current segment and
 	 * get the new one.
 	 */
-	refresh_segment = !((cache->cursor + 1) % cache->nr_caches_inseg);
+	div_u64_rem(cache->cursor + 1, cache->nr_caches_inseg, &tmp32);
+	refresh_segment = !tmp32;
 
 	if (refresh_segment)
 		queue_current_buffer(cache);
 
-	cache->cursor = (cache->cursor + 1) % cache->nr_caches;
+	div_u64_rem(cache->cursor + 1, cache->nr_caches, &tmp32);
+	cache->cursor = tmp32;
 
 	/*
 	 * update_mb_idx is the cache line index to update.
@@ -738,7 +724,8 @@ write_not_found:
 	seg = cache->current_seg;
 	atomic_inc(&seg->nr_inflight_ios);
 
-	new_mb = seg->mb_array + (update_mb_idx % cache->nr_caches_inseg);
+	div_u64_rem(update_mb_idx, cache->nr_caches_inseg, &tmp32);
+	new_mb = seg->mb_array + tmp32;
 	new_mb->dirty_bits = 0;
 	ht_register(cache, head, &key, new_mb);
 	mutex_unlock(&cache->io_lock);
@@ -747,13 +734,12 @@ write_not_found:
 
 write_on_buffer:
 	;
-	idx_inseg = update_mb_idx % cache->nr_caches_inseg;
-
 	/*
 	 * The first 4KB of the segment is
 	 * used for metadata.
 	 */
-	s = (idx_inseg + 1) << 3;
+	div_u64_rem(update_mb_idx, cache->nr_caches_inseg, &tmp32);
+	s = (tmp32 + 1) << 3;
 
 	b = false;
 	lockseg(seg, flags);
@@ -769,7 +755,7 @@ write_on_buffer:
 		u8 i;
 		u8 acc_bits = 0;
 		s += bio_offset;
-		for (i = bio_offset; i < (bio_offset+bio_count); i++)
+		for (i = bio_offset; i < (bio_offset + bio_count); i++)
 			acc_bits += (1 << i);
 
 		mb->dirty_bits |= acc_bits;
@@ -827,8 +813,15 @@ static int writeboost_end_io(struct dm_target *ti, struct bio *bio, int error
 	return 0;
 }
 
+#define ARG_EXIST(n)\
+	if (argc <= (n)) {\
+		goto exit_parse_arg;\
+	}
+
 /*
- * <backing dev> <cache dev> <segment size order>
+ * <backing dev> <cache dev>
+ * [segment size order]
+ * [rambuf pool amount]
  */
 static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -842,7 +835,7 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 6, 0)
 	r = dm_set_target_max_io_len(ti, (1 << 3));
 	if (r) {
-		WBERR();
+		WBERR("settting max io len failed");
 		return r;
 	}
 #else
@@ -862,6 +855,8 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 */
 	wb->migrate_threshold = 70;
 
+	init_waitqueue_head(&wb->blockup_wait_queue);
+	wb->blockup = false;
 
 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
 	if (!cache) {
@@ -888,6 +883,10 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_get_device_cache;
 	}
 
+	/* Optional Parameters */
+
+	cache->segment_size_order = 7;
+	ARG_EXIST(2);
 	if (kstrtoul(argv[2], 10, &tmp)) {
 		r = -EINVAL;
 		goto bad_segment_size_order;
@@ -901,6 +900,16 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	cache->segment_size_order = tmp;
 
+	cache->rambuf_pool_amount = 2048;
+	ARG_EXIST(3);
+	if (kstrtoul(argv[3], 10, &tmp)) {
+		r = -EINVAL;
+		goto bad_rambuf_pool_amount;
+	}
+	cache->rambuf_pool_amount = tmp;
+
+exit_parse_arg:
+
 	r = audit_cache_device(cachedev, cache, &need_format, &allow_format);
 	if (r) {
 		WBERR("audit cache device fails err(%d)", r);
@@ -930,7 +939,7 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	r = resume_cache(cache, cachedev);
 	if (r) {
-		WBERR("%d", r);
+		WBERR("failed to resume cache err(%d)", r);
 		goto bad_resume_cache;
 	}
 	clear_stat(cache);
@@ -957,6 +966,7 @@ static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad_resume_cache:
 bad_format_cache:
 bad_audit_cache:
+bad_rambuf_pool_amount:
 bad_segment_size_order:
 	dm_put_device(ti, cachedev);
 bad_get_device_cache:
@@ -1000,6 +1010,14 @@ static int writeboost_message(struct dm_target *ti, unsigned argc, char **argv)
 	if (kstrtoul(argv[1], 10, &tmp))
 		return -EINVAL;
 
+	if (!strcasecmp(cmd, "blockup")) {
+		if (tmp > 1)
+			return -EINVAL;
+		wb->blockup = tmp;
+		wake_up(&wb->blockup_wait_queue);
+		return 0;
+	}
+
 	if (!strcasecmp(cmd, "allow_migrate")) {
 		if (tmp > 1)
 			return -EINVAL;
@@ -1101,31 +1119,39 @@ writeboost_status(
 		DMEMIT("%llu %llu %llu %llu %llu %u ",
 		       (long long unsigned int)
 		       atomic64_read(&wb->nr_dirty_caches),
-		       (long long unsigned int) cache->nr_segments,
-		       (long long unsigned int) cache->last_migrated_segment_id,
-		       (long long unsigned int) cache->last_flushed_segment_id,
-		       (long long unsigned int) cache->current_seg->global_id,
-		       (unsigned int) cache->cursor);
+		       (long long unsigned int)
+		       cache->nr_segments,
+		       (long long unsigned int)
+		       atomic64_read(&cache->last_migrated_segment_id),
+		       (long long unsigned int)
+		       atomic64_read(&cache->last_flushed_segment_id),
+		       (long long unsigned int)
+		       cache->current_seg->global_id,
+		       (unsigned int)
+		       cache->cursor);
 
 		for (i = 0; i < STATLEN; i++) {
 			atomic64_t *v = &cache->stat[i];
-			DMEMIT("%lu ", atomic64_read(v));
+			DMEMIT("%llu ", (unsigned long long) atomic64_read(v));
 		}
 
-		DMEMIT("%d ", 7);
+		DMEMIT("%d ", 8);
 		DMEMIT("barrier_deadline_ms %lu ",
 		       cache->barrier_deadline_ms);
 		DMEMIT("allow_migrate %d ",
 		       cache->allow_migrate ? 1 : 0);
 		DMEMIT("enable_migration_modulator %d ",
 		       cache->enable_migration_modulator ? 1 : 0);
-		DMEMIT("migrate_threshold %d ", wb->migrate_threshold);
-		DMEMIT("nr_cur_batched_migration %lu ",
+		DMEMIT("migrate_threshold %d ",
+		       wb->migrate_threshold);
+		DMEMIT("nr_cur_batched_migration %u ",
 		       cache->nr_cur_batched_migration);
 		DMEMIT("sync_interval %lu ",
 		       cache->sync_interval);
-		DMEMIT("update_record_interval %lu",
+		DMEMIT("update_record_interval %lu ",
 		       cache->update_record_interval);
+		DMEMIT("blockup %d",
+		       wb->blockup);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -1169,13 +1195,13 @@ static int __init writeboost_module_init(void)
 	safe_io_wq = alloc_workqueue("safeiowq",
 				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!safe_io_wq) {
-		WBERR();
+		WBERR("failed to alloc safe_io_wq");
 		goto bad_wq;
 	}
 
 	wb_io_client = dm_io_client_create();
 	if (IS_ERR(wb_io_client)) {
-		WBERR();
+		WBERR("failed to alloc wb_io_client");
 		r = PTR_ERR(wb_io_client);
 		goto bad_io_client;
 	}
diff --git a/Driver/dm-writeboost.h b/Driver/dm-writeboost.h
index d394dfa..fdb41d0 100644
--- a/Driver/dm-writeboost.h
+++ b/Driver/dm-writeboost.h
@@ -22,22 +22,17 @@
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 
-#define wbdebug(f, args...) \
+#define wbdebug(f, args...)\
 	DMINFO("debug@%s() L.%d" f, __func__, __LINE__, ## args)
 
-#define WBERR(f, args...) \
+#define WBERR(f, args...)\
 	DMERR("err@%s() " f, __func__, ## args)
-#define WBWARN(f, args...) \
+#define WBWARN(f, args...)\
 	DMWARN("warn@%s() " f, __func__, ## args)
-#define WBINFO(f, args...) \
+#define WBINFO(f, args...)\
 	DMINFO("info@%s() " f, __func__, ## args)
 
 /*
- * The amount of RAM buffer pool to pre-allocated.
- */
-#define RAMBUF_POOL_ALLOCATED 64 /* MB */
-
-/*
  * The Detail of the Disk Format
  *
  * Whole:
@@ -81,15 +76,6 @@ struct superblock_record_device {
 } __packed;
 
 /*
- * Cache line index.
- *
- * dm-writeboost can supoort a cache device
- * with size less than 4KB * (1 << 32)
- * that is 16TB.
- */
-typedef u32 cache_nr;
-
-/*
  * Metadata of a 4KB cache line
  *
  * Dirtiness is defined for each sector
@@ -98,7 +84,7 @@ typedef u32 cache_nr;
 struct metablock {
 	sector_t sector; /* key */
 
-	cache_nr idx; /* Const */
+	u32 idx; /* Const */
 
 	struct hlist_node ht_list;
 
@@ -143,7 +129,7 @@ struct segment_header {
 	 */
 	u8 length;
 
-	cache_nr start_idx; /* Const */
+	u32 start_idx; /* Const */
 	sector_t start_sector; /* Const */
 
 	struct list_head migrate_list;
@@ -228,10 +214,14 @@ struct wb_device;
 struct wb_cache {
 	struct wb_device *wb;
 
+	mempool_t *buf_1_pool; /* 1 sector buffer pool */
+	mempool_t *buf_8_pool; /* 8 sector buffer pool */
+	mempool_t *flush_job_pool;
+
 	struct dm_dev *device;
 	struct mutex io_lock;
-	cache_nr nr_caches; /* Const */
-	u64 nr_segments; /* Const */
+	u32 nr_caches; /* Const */
+	u32 nr_segments; /* Const */
 	u8 segment_size_order; /* Const */
 	u8 nr_caches_inseg; /* Const */
 	struct bigarray *segment_header_array;
@@ -248,15 +238,16 @@ struct wb_cache {
 	size_t htsize;
 	struct ht_head *null_head;
 
-	cache_nr cursor; /* Index that has been written the most lately */
+	u32 cursor; /* Index that has been written the most lately */
 	struct segment_header *current_seg;
 
 	struct rambuffer *current_rambuf;
-	size_t nr_rambuf_pool; /* Const */
+	u32 rambuf_pool_amount; /* kB */
+	u32 nr_rambuf_pool; /* Const */
 	struct rambuffer *rambuf_pool;
 
-	u64 last_migrated_segment_id;
-	u64 last_flushed_segment_id;
+	atomic64_t last_migrated_segment_id;
+	atomic64_t last_flushed_segment_id;
 	int urge_migrate;
 
 	/*
@@ -269,7 +260,6 @@ struct wb_cache {
 	struct task_struct *flush_daemon;
 	spinlock_t flush_queue_lock;
 	struct list_head flush_queue;
-	wait_queue_head_t flush_wait_queue;
 
 	/*
 	 * Deferred ACK for barriers.
@@ -289,7 +279,7 @@ struct wb_cache {
 	 * if they are segments to migrate.
 	 */
 	struct task_struct *migrate_daemon;
-	bool allow_migrate; /* param */
+	int allow_migrate; /* param */
 
 	/*
 	 * Batched Migration
@@ -303,8 +293,8 @@ struct wb_cache {
 	struct list_head migrate_list;
 	u8 *dirtiness_snapshot;
 	void *migrate_buffer;
-	size_t nr_cur_batched_migration;
-	size_t nr_max_batched_migration; /* param */
+	u32 nr_cur_batched_migration;
+	u32 nr_max_batched_migration; /* param */
 
 	/*
 	 * Migration modulator
@@ -314,7 +304,7 @@ struct wb_cache {
 	 * according to the load of backing store.
 	 */
 	struct task_struct *modulator_daemon;
-	bool enable_migration_modulator; /* param */
+	int enable_migration_modulator; /* param */
 
 	/*
 	 * Superblock Recorder
@@ -347,6 +337,9 @@ struct wb_device {
 	u8 migrate_threshold;
 
 	atomic64_t nr_dirty_caches;
+
+	wait_queue_head_t blockup_wait_queue;
+	int blockup;
 };
 
 struct flush_job {
@@ -384,24 +377,50 @@ u8 atomic_read_mb_dirtiness(struct segment_header *, struct metablock *);
 extern struct workqueue_struct *safe_io_wq;
 extern struct dm_io_client *wb_io_client;
 
-void *do_kmalloc_retry(size_t size, gfp_t flags, const char *caller);
-#define kmalloc_retry(size, flags) \
-	do_kmalloc_retry((size), (flags), __func__)
+/*
+ * I/O error on either backing or cache
+ * should block up the whole system.
+ * Either reading or writing a device
+ * should not be done if it once returns -EIO.
+ * These devices are untrustable and
+ * we wait for sysadmin to remove the failure cause away.
+ */
+
+#define wait_on_blockup()\
+	do {\
+		BUG_ON(!wb);\
+		if (ACCESS_ONCE(wb->blockup)) {\
+			WBERR("system is blocked up on I/O error. set blockup to 0 after checkup.");\
+			wait_event_interruptible(wb->blockup_wait_queue,\
+						 !ACCESS_ONCE(wb->blockup));\
+			WBINFO("reactivated after blockup");\
+		}\
+	} while (0)
+
+#define RETRY(proc)\
+	do {\
+		BUG_ON(!wb);\
+		r = proc;\
+		if (r == -EOPNOTSUPP) {\
+			r = 0;\
+		} else if (r == -EIO) { /* I/O error is critical */\
+			wb->blockup = true;\
+			wait_on_blockup();\
+		} else if (r == -ENOMEM) {\
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));\
+		} else if (r) { \
+			WBERR("please report!! I/O failed but no retry error code %d", r);\
+			r = 0;\
+		}\
+	} while (r)
 
 int dm_safe_io_internal(
+		struct wb_device*,
 		struct dm_io_request *,
 		unsigned num_regions, struct dm_io_region *,
 		unsigned long *err_bits, bool thread, const char *caller);
-#define dm_safe_io(io_req, num_regions, regions, err_bits, thread) \
-	dm_safe_io_internal((io_req), (num_regions), (regions), \
-			    (err_bits), (thread), __func__)
-
-void dm_safe_io_retry_internal(
-		struct dm_io_request *,
-		unsigned num_regions, struct dm_io_region *,
-		bool thread, const char *caller);
-#define dm_safe_io_retry(io_req, num_regions, regions, thread) \
-	dm_safe_io_retry_internal((io_req), (num_regions), (regions), \
-				  (thread), __func__)
+#define dm_safe_io(io_req, num_regions, regions, err_bits, thread)\
+		dm_safe_io_internal(wb, (io_req), (num_regions), (regions),\
+				    (err_bits), (thread), __func__);\
 
 sector_t dm_devsize(struct dm_dev *);

diff --git a/dm-writeboost.txt b/dm-writeboost.txt
index 9acbd54..00ad6e0 100644
--- a/dm-writeboost.txt
+++ b/dm-writeboost.txt
@@ -66,12 +66,20 @@ All the operations are via dmsetup command.
 
 Constructor
 -----------
-writeboost <backing dev> <cache dev> <segment size order>
+writeboost <backing dev> <cache dev>
+           [segment size order]
+           [rambuf pool amount]
 
 backing dev        : slow device holding original data blocks.
 cache dev          : fast device holding cached data and its metadata.
 segment size order : the size of RAM buffer
                      1 << n (sectors), 4 <= n <= 11
+                     default 7
+rambuf pool amount : The amount of the RAM buffer pool (kB).
+                     Too fewer amount may cause waiting for new buffer
+                     to become available again.
+                     But too much doesn't affect the performance.
+                     default 2048
 
 Note that cache device is re-formatted
 if the first sector of the cache device is zeroed out.
