Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaFZXrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 19:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaFZXrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 19:47:08 -0400
Date: Thu, 26 Jun 2014 19:46:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: [PATCH] block: flush queued bios when the process blocks
Message-ID: <alpine.LRH.2.02.1406261927280.4570@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Would you please consider applying this patch?

Regarding your idea about merging bio and request plugging - I think this 
could be done later when it is properly designed by Kent Overstreet or 
someone else.

We need this patch to fix the deadlock in dm snapshot.

Mikulas


---------- Forwarded message ----------
Date: Tue, 27 May 2014 11:03:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
    Alasdair G. Kergon <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Subject: [PATCH] block: flush queued bios when the process blocks

The block layer uses per-process bio list to avoid recursion in
generic_make_request. When generic_make_request is called recursively, the
bio is added to current->bio_list and the function returns immediatelly.
The top-level instance of generic_make_requests takes bios from
current->bio_list and processes them.

This bio queuing can result in deadlocks. The following deadlock was
observed:

1) Process A sends one-page read bio to the dm-snapshot target. The bio
spans snapshot chunk boundary and so it is split to two bios by device
mapper.

2) Device mapper creates the first sub-bio and sends it to the snapshot
driver.

3) The function snapshot_map calls track_chunk (that allocates a structure
dm_snap_tracked_chunk and adds it to tracked_chunk_hash) and then it
remaps the bio to the underlying linear target and exits with
DM_MAPIO_REMAPPED.

4) The remapped bio is submitted with generic_make_request, but it isn't
processed - it is added to current->bio_list instead.

5) Meanwhile, process B executes pending_complete for the affected chunk,
it takes down_write(&s->lock) and then loops in
__check_for_conflicting_io, waiting for dm_snap_tracked_chunk created in
step 3) to be released.

6) Process A continues, it creates a new bio for the rest of the original
bio.

7) snapshot_map is called for this new bio, it waits on
down_write(&s->lock) that is held in step 5).

The resulting deadlock:
* bio added to current->bio_list at step 4) waits until the function in
  step 7) finishes
* the function in step 7) waits until s->lock held in step 5) is released
* the process in step 5) waits until the bio queued in step 4) finishes

The general problem is that queuing bios on current->bio_list introduces
additional lock dependencies. If a device mapper target sends a bio to
some block device, it assumes that the bio only takes locks of the target
block device or devices that are below the target device. However, if the
bio is added to queue on current->bio_list, it creates artifical locking
dependency on locks taken by other bios that are on current->bio_list. In
the above scenario, this artifical locking dependency results in
deadlock.

Kent Overstreet already created a workqueue for every bio set and there is
a code that tries to resolve some low-memory deadlocks by redirecting bios
queued on current->bio_list to the workqueue if the system is low on
memory. However, other deadlocks (as described above) may happen without
any low memory condition.

This patch generalizes Kent's concept, it redirects bios on
current->bio_list to the bio_set's workqueue on every schedule call.
Consequently, when the process blocks on a mutex, the bios queued on
current->bio_list are dispatched to independent workqueus and they can
complete without waiting for the mutex to be available.

Bios allocated with bio_kmalloc do not have bio_set, so they are not
redirected, however bio_kmalloc shouldn't be used by stacking drivers (it
is currently used by raid1.c and raid10.c, we need to change it to
bio_set).


Note to stable kernel maintainers: before backporting this patch, you also
need to backport df2cb6daa4cbc34406bc4b1ac9b9335df1083a72.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 fs/bio.c               |   84 ++++++++++++++-----------------------------------
 include/linux/blkdev.h |    7 +++-
 kernel/sched/core.c    |    7 ++++
 3 files changed, 37 insertions(+), 61 deletions(-)

Index: linux-3.15-rc5/fs/bio.c
===================================================================
--- linux-3.15-rc5.orig/fs/bio.c	2014-05-26 19:02:47.000000000 +0200
+++ linux-3.15-rc5/fs/bio.c	2014-05-27 00:00:13.000000000 +0200
@@ -342,35 +342,34 @@ static void bio_alloc_rescue(struct work
 	}
 }
 
-static void punt_bios_to_rescuer(struct bio_set *bs)
+/**
+ * blk_flush_bio_list
+ *
+ * Pop bios queued on current->bio_list and submit each of them to
+ * their rescue workqueue.
+ *
+ * If the bio doesn't have a bio_set, we leave it on current->bio_list.
+ * However, stacking drivers should use bio_set, so this shouldn't be
+ * an issue.
+ */
+void blk_flush_bio_list(void)
 {
-	struct bio_list punt, nopunt;
 	struct bio *bio;
+	struct bio_list list = *current->bio_list;
+	bio_list_init(current->bio_list);
 
-	/*
-	 * In order to guarantee forward progress we must punt only bios that
-	 * were allocated from this bio_set; otherwise, if there was a bio on
-	 * there for a stacking driver higher up in the stack, processing it
-	 * could require allocating bios from this bio_set, and doing that from
-	 * our own rescuer would be bad.
-	 *
-	 * Since bio lists are singly linked, pop them all instead of trying to
-	 * remove from the middle of the list:
-	 */
-
-	bio_list_init(&punt);
-	bio_list_init(&nopunt);
-
-	while ((bio = bio_list_pop(current->bio_list)))
-		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
-
-	*current->bio_list = nopunt;
-
-	spin_lock(&bs->rescue_lock);
-	bio_list_merge(&bs->rescue_list, &punt);
-	spin_unlock(&bs->rescue_lock);
+	while ((bio = bio_list_pop(&list))) {
+		struct bio_set *bs = bio->bi_pool;
+		if (unlikely(!bs)) {
+			bio_list_add(current->bio_list, bio);
+		} else {
+			spin_lock(&bs->rescue_lock);
+			bio_list_add(&bs->rescue_list, bio);
+			spin_unlock(&bs->rescue_lock);
 
-	queue_work(bs->rescue_workqueue, &bs->rescue_work);
+			queue_work(bs->rescue_workqueue, &bs->rescue_work);
+		}
+	}
 }
 
 /**
@@ -410,7 +409,6 @@ static void punt_bios_to_rescuer(struct 
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
-	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -428,36 +426,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 		front_pad = 0;
 		inline_vecs = nr_iovecs;
 	} else {
-		/*
-		 * generic_make_request() converts recursion to iteration; this
-		 * means if we're running beneath it, any bios we allocate and
-		 * submit will not be submitted (and thus freed) until after we
-		 * return.
-		 *
-		 * This exposes us to a potential deadlock if we allocate
-		 * multiple bios from the same bio_set() while running
-		 * underneath generic_make_request(). If we were to allocate
-		 * multiple bios (say a stacking block driver that was splitting
-		 * bios), we would deadlock if we exhausted the mempool's
-		 * reserve.
-		 *
-		 * We solve this, and guarantee forward progress, with a rescuer
-		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_WAIT; if that fails, we punt those bios we
-		 * would be blocking to the rescuer workqueue before we retry
-		 * with the original gfp_flags.
-		 */
-
-		if (current->bio_list && !bio_list_empty(current->bio_list))
-			gfp_mask &= ~__GFP_WAIT;
-
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
-		if (!p && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			p = mempool_alloc(bs->bio_pool, gfp_mask);
-		}
 
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
@@ -471,11 +440,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 
 	if (nr_iovecs > inline_vecs) {
 		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
-		if (!bvl && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
-		}
 
 		if (unlikely(!bvl))
 			goto err_free;
Index: linux-3.15-rc5/kernel/sched/core.c
===================================================================
--- linux-3.15-rc5.orig/kernel/sched/core.c	2014-05-26 19:30:51.000000000 +0200
+++ linux-3.15-rc5/kernel/sched/core.c	2014-05-27 00:23:00.000000000 +0200
@@ -2734,6 +2734,13 @@ static inline void sched_submit_work(str
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 	/*
+	 * If there are bios on the bio list, flush them to the appropriate
+	 * rescue threads.
+	 */
+	if (unlikely(current->bio_list != NULL) &&
+	    !bio_list_empty(current->bio_list))
+		blk_flush_bio_list();
+	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
 	 */
Index: linux-3.15-rc5/include/linux/blkdev.h
===================================================================
--- linux-3.15-rc5.orig/include/linux/blkdev.h	2014-05-26 23:54:48.000000000 +0200
+++ linux-3.15-rc5/include/linux/blkdev.h	2014-05-26 23:56:41.000000000 +0200
@@ -1103,6 +1103,8 @@ static inline bool blk_needs_flush_plug(
 		 !list_empty(&plug->cb_list));
 }
 
+extern void blk_flush_bio_list(void);
+
 /*
  * tag stuff
  */
@@ -1634,12 +1636,15 @@ static inline void blk_schedule_flush_pl
 {
 }
 
-
 static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 {
 	return false;
 }
 
+static inline void blk_flush_bio_list(void)
+{
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
