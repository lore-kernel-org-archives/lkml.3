Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaLGMfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:35:45 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53290 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaLGMfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:35:39 -0500
Message-ID: <5484498E.4000202@gmail.com>
Date: Sun, 07 Dec 2014 21:35:26 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: [PATCH] staging: writeboost: Add dm-writeboost
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dm-writeboost to staging tree.

dm-writeboost is a log-structured SSD-caching driver.
It caches data in log-structured way on the cache device
so that the performance is maximized.

The merit of putting this driver in staging tree is
to make it possible to get more feedback from users
and polish the codes.

Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
---
 MAINTAINERS                                        |    6 +
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/writeboost/Kconfig                 |    6 +
 drivers/staging/writeboost/Makefile                |    6 +
 drivers/staging/writeboost/README.txt              |  228 +++
 drivers/staging/writeboost/TODO                    |   47 +
 drivers/staging/writeboost/dm-writeboost-daemon.c  |  537 ++++++
 drivers/staging/writeboost/dm-writeboost-daemon.h  |   39 +
 .../staging/writeboost/dm-writeboost-metadata.c    | 1862 ++++++++++++++++++++
 .../staging/writeboost/dm-writeboost-metadata.h    |   52 +
 drivers/staging/writeboost/dm-writeboost-target.c  | 1770 +++++++++++++++++++
 drivers/staging/writeboost/dm-writeboost.h         |  586 ++++++
 13 files changed, 5142 insertions(+)
 create mode 100644 drivers/staging/writeboost/Kconfig
 create mode 100644 drivers/staging/writeboost/Makefile
 create mode 100644 drivers/staging/writeboost/README.txt
 create mode 100644 drivers/staging/writeboost/TODO
 create mode 100644 drivers/staging/writeboost/dm-writeboost-daemon.c
 create mode 100644 drivers/staging/writeboost/dm-writeboost-daemon.h
 create mode 100644 drivers/staging/writeboost/dm-writeboost-metadata.c
 create mode 100644 drivers/staging/writeboost/dm-writeboost-metadata.h
 create mode 100644 drivers/staging/writeboost/dm-writeboost-target.c
 create mode 100644 drivers/staging/writeboost/dm-writeboost.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c721042..40d7a68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8983,6 +8983,12 @@ M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
 F:	drivers/staging/xgifb/
 
+STAGING - LOG STRUCTURED CACHING
+M:	Akira Hayakawa <ruby.wktk@gmail.com>
+S:	Maintained
+L:	dm-devel@redhat.com
+F:	drivers/staging/writeboost
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 4690ae9..521fed7 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -108,4 +108,6 @@ source "drivers/staging/skein/Kconfig"
 
 source "drivers/staging/unisys/Kconfig"
 
+source "drivers/staging/writeboost/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index c780a0e..514a4cd 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
 obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpgaboot/
 obj-$(CONFIG_CRYPTO_SKEIN)	+= skein/
 obj-$(CONFIG_UNISYSSPAR)	+= unisys/
+obj-$(CONFIG_DM_WRITEBOOST)	+= writeboost/
diff --git a/drivers/staging/writeboost/Kconfig b/drivers/staging/writeboost/Kconfig
new file mode 100644
index 0000000..7201252
--- /dev/null
+++ b/drivers/staging/writeboost/Kconfig
@@ -0,0 +1,6 @@
+config DM_WRITEBOOST
+       tristate "Writeboost target"
+       depends on BLK_DEV_DM
+       default n
+       ---help---
+         Cache target optimised for streaming writes.
diff --git a/drivers/staging/writeboost/Makefile b/drivers/staging/writeboost/Makefile
new file mode 100644
index 0000000..d5c6826
--- /dev/null
+++ b/drivers/staging/writeboost/Makefile
@@ -0,0 +1,6 @@
+dm-writeboost-objs := \
+	dm-writeboost-target.o \
+	dm-writeboost-metadata.o \
+	dm-writeboost-daemon.o
+
+obj-$(CONFIG_DM_WRITEBOOST) += dm-writeboost.o
diff --git a/drivers/staging/writeboost/README.txt b/drivers/staging/writeboost/README.txt
new file mode 100644
index 0000000..ca2f6f9
--- /dev/null
+++ b/drivers/staging/writeboost/README.txt
@@ -0,0 +1,228 @@
+Writeboost
+==========
+Writeboost target provides block-level log-structured caching.
+Accepted bios are put into a huge "log" and the log is written to the cache
+device sequentially.
+
+
+Mechanism
+=========
+Writeboost caches only writes - reads are not cached.
+However, this doesn't necessarily mean that it doesn't improve read performance
+of the whole system. And of course, there exists read hit path if the block is
+on the cache device.
+
+For most of the storage systems, writes are more burdening than reads.
+(cf. RAID penalty)
+If the write load of the the backing device gets low then it can improve the
+read performance as the backing device can focus on processing reads.
+
+There are two mechanism to reduce the write load of the backing device:
+1. Writeboost can cut the writes to the backing device by processing them on the
+   cache device.
+2. In Writeboost's writeback, the data are sorted by the destination address and
+   then submitted in async manner. Therefore, the average write load of the
+   backing device is always lower compared to without Writeboost.
+
+Additionally, the write data cached which are typically what written back from
+the page cache are likely to be hit soon again on read. Needless to say, this
+also is capable of improving read performance.
+
+For these reasons, Writeboost can improve not only writes but also reads.
+
+The lifetime of the NAND SSD as the cache device is a great concern in real
+world operations. Caching on read
+1. shortens the lifetime of the cache device
+2. sometimes make no sence because of the data duplication between page cache.
+
+As for the performance and the lifetime of the cache device, Writeboost doesn't
+stage blocks on read and so Writeboost can be optimized as a pure write cache
+software.
+
+Basic Mechanism
+---------------
+Writeboost controls three different layers - RAM buffer (rambuf), cache device
+(cache_dev, e.g SSD) and backing device (backing_dev, e.g. HDD).
+Write data are first stored in the RAM buffer and when the buffer is full
+Writeboost adds metadata block to the RAM buffer to create a "log".
+Afterward, the log is written to the cache device as background processing in
+sequential manner and thereafter it's written back to the backing device in
+background again.
+
+Persistent Logging
+------------------
+Writeboost can enhance its functionality by specifying "type" in initialization.
+Type 0 provides only the basic mechanism and the type 1 provides additional
+"Persistent Logging" (or plog).
+Plog aims to reduce the penalty in FLUSH operation by storing the write data to
+both RAM buffer and persistent device (plog_dev).
+This extended functionality is similar to full-data journaling in filesystems.
+As of now, only block device as plog_dev is supported but other medium to use
+will be supported in the future.
+
+Log Replay
+----------
+On reboot, Writeboost replays the logs written on the cache device to restore
+the on-memory metadata.
+Logs are chronologically ordered thus it is theoritically possible to restoring
+the state of the storage system of any moment.
+
+
+Processings
+===========
+Writeboost is consist of one foreground processing and other five background
+processings.
+
+Foreground Processing
+---------------------
+A bio is accepted and the driver chooses its way as the result of cache lookup.
+All write data are stored in the RAM buffer. Later, when the buffer is full, a
+log is created and queued as a flush job.
+
+Background Processings
+----------------------
+(1) Flusher Daemon
+This daemon dequeues a flush job from the queue and writes the log to the cache
+device.
+
+(2) Writeback Daemon
+This daemon writes back the dirty data on the cache device to the backing device.
+
+If `allow_writeback" is false, then it never starts writeback unless imminent
+situation. Here, imminent situation is that there is no room to append any logs
+without writing back some segments to clean them up.
+
+There are two major optimizations in writeback:
+1. Multiple segments are written back at a time. `nr_max_batched_writeback` is
+   the maximum number of segments to write back at a time.
+2. The blocks to write back are sorted by the destination address on the backing
+   device.
+
+(3) Writeback Modulator
+Writeback should be suppressed when the backing device is in high-load.
+This daemon surveils the load of the backing device and stops writeback in
+high-load by turning `allow_writeback` to false.
+This daemon only enables when `enable_writeback_modulator` is true and the
+threshold to turn on/off the switch is determined by `writeback_threshold`.
+
+(4) Superblock Recorder
+This daemon periodically (specified by `update_record_interval`) records on
+super block the last segment ID that was written back.
+Doing this can omit unnecessary restoring in log replay and thus shorten the
+reboot time.
+
+(5) Sync Daemon
+The data on the RAM buffer is lost in case of power failure.
+Additionally, the data on the RAM cache of the cache device (typically, SSD has
+such small cache) are also lost in such failure.
+This daemon flushes them all periodically. (specified by `sync_interval`)
+
+
+Target Interfaces
+=================
+Use dmsetup command for operations.
+
+Initialization (Constructor)
+----------------------------
+
+<type>
+<essential args>
+<#optional args> <optional args>
+<#tunable args> <tunable args>
+
+- For <type>, see `Mechanism`
+- <essential args> differs by <type>
+- <optional args> and <tunable args> are unordered list of kv pairs.
+
+type 0:
+  <essential args>
+  backing_dev: A block device having original data (E.g. HDD)
+  cache_dev: A block device having caches (E.g. SSD)
+
+  <optional_args> (same in all <type>)
+  segment_size_order : Determines the size of a RAM buffer.
+                       RAM buffer size will be 1 << n (sector).
+                       4 <= n <= 10
+                       default 10
+  nr_rambuf_pool     : The number of RAM buffers to allocate
+                       default 8
+
+  <tunable args>
+  see `Messages`
+
+E.g.
+BACKING=/dev/sdb # Example
+CACHE=/dev/sdc # Example
+sz=`blockdev --getsize ${BACKING}`
+dmsetup create wbdev --table "0 $sz writeboost 0 $BACKING $CACHE"
+dmsetup create wbdev --table "0 $sz writeboost 0 $BACKING $CACHE \
+                              4 nr_rambuf_pool 32 segment_size_order 8 \
+                              2 allow_writeback 1"
+dmsetup create wbdev --table "0 $sz writeboost 0 $BACKING $CACHE \
+                              0 \
+                              2 allow_writeback 1"
+
+type 1:
+  <essential args>
+  backing_dev
+  cache_dev
+  plog_dev_desc      : A string descriptor to specify the plog device
+
+E.g.
+PLOG=/dev/sdd # Example
+dmsetup create wbdev --table "0 $sz 0 writeboost 1 $BACKING $CACHE $PLOG"
+
+Initialization (Reformatting)
+-----------------------------
+The cache device and plog are triggered reformating only if the first one sector
+of the cache device is zeroed out.
+
+Messages
+--------
+Some behavior of Writeboost device can be tuned online.
+Use dmsetup message for this purpose.
+
+(1) Tunables
+The tunables in constructor can be changed online.
+See `Background processings` for detail.
+
+allow_writeback (bool)
+  default: 0
+
+enable_writeback_modulator (bool) and writeback_threshold (%)
+  default: 0 and 70
+
+nr_max_batched_writeback
+  default: 1 << (15 - segment_size_order)
+
+update_record_interval (sec)
+  default: 0
+
+sync_interval (sec)
+  default: 0
+
+E.g.
+dmsetup message wbdev 0 enable_writeback_modulator 0
+
+(2) Others
+clear_stats
+  Clear the statistic info (see `Status`).
+drop_caches
+  Wait for all dirty data on the cache device to be written back to the backing
+  device. (Interruptible)
+
+E.g.
+dmsetup message wbdev 0 drop_caches
+
+Status
+------
+<cursor_pos>
+<nr_cache_blocks>
+<nr_segments>
+<current_id>
+<last_flushed_id>
+<last_writeback_id>
+<nr_dirty_cache_blocks>
+<stat (write?) x (hit?) x (on buffer?) x (fullsize?)>
+<nr_partial_flushed>
+<#tunable args> <tunable args>
diff --git a/drivers/staging/writeboost/TODO b/drivers/staging/writeboost/TODO
new file mode 100644
index 0000000..8ac6bf0
--- /dev/null
+++ b/drivers/staging/writeboost/TODO
@@ -0,0 +1,47 @@
+TODO:
+
+- Expose bugs and fix them.
+- Clean up the interfaces. Some input values should be limited in case user may choose too big values.
+- Wait for proper review by Mike Snitzer.
+- Fix up documents.
+
+-------------------------------------------------------------------------
+
+Project Ideas:
+
+1. Add read caching feature
+Device-Mapper maintainer Mike Snitzer said that
+a single target should provide caching for both reads and writes.
+(cf. http://www.redhat.com/archives/dm-devel/2014-January/msg00078.html)
+
+To follow Mike's guide, I will implement read-caching for Writeboost.
+The great idea is, at least conceptually,
+sending back the read data to the write entrance.
+I didn't notice this simple idea at that time of previous discussion.
+
+This should be done background and
+some threshold to determine
+which sequence of data should be staged.
+
+This feature will be implemented step-by-step.
+I don't think this feature will change then interface drastically.
+
+2. Improve initialization time
+Some user complains that the initialization is too slow.
+
+Any ideas?
+
+3. Reduce metadata footprint
+Writeboost has a hash table in RAM for cache management.
+This isn't cheap.
+
+Any ideas?
+
+-------------------------------------------------------------------------
+
+Please send any patches
+To:
+Akira Hayakawa <ruby.wktk@gmail.com>
+Cc:
+Greg Kroah-Hartman <greg@kroah.com>
+Device-Mapper ML <dm-devel@redhat.com>
diff --git a/drivers/staging/writeboost/dm-writeboost-daemon.c b/drivers/staging/writeboost/dm-writeboost-daemon.c
new file mode 100644
index 0000000..0243aed
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost-daemon.c
@@ -0,0 +1,537 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+#include <linux/rbtree.h>
+
+/*----------------------------------------------------------------*/
+
+void queue_barrier_io(struct wb_device *wb, struct bio *bio)
+{
+	mutex_lock(&wb->io_lock);
+	bio_list_add(&wb->barrier_ios, bio);
+	mutex_unlock(&wb->io_lock);
+
+	schedule_work(&wb->flush_barrier_work);
+}
+
+void flush_barrier_ios(struct work_struct *work)
+{
+	struct wb_device *wb = container_of(
+		work, struct wb_device, flush_barrier_work);
+
+	if (bio_list_empty(&wb->barrier_ios))
+		return;
+
+	atomic64_inc(&wb->count_non_full_flushed);
+	flush_current_buffer(wb);
+}
+
+/*----------------------------------------------------------------*/
+
+static void process_deferred_barriers(struct wb_device *wb, struct flush_job *job)
+{
+	int r = 0;
+	bool has_barrier = !bio_list_empty(&job->barrier_ios);
+
+	/*
+	 * Make all the data until now persistent.
+	 */
+	if (has_barrier)
+		maybe_IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+
+	/*
+	 * Ack the chained barrier requests.
+	 */
+	if (has_barrier) {
+		struct bio *bio;
+		while ((bio = bio_list_pop(&job->barrier_ios))) {
+			if (is_live(wb))
+				bio_endio(bio, 0);
+			else
+				bio_endio(bio, -EIO);
+		}
+	}
+}
+
+void flush_proc(struct work_struct *work)
+{
+	int r = 0;
+
+	struct flush_job *job = container_of(work, struct flush_job, work);
+
+	struct wb_device *wb = job->wb;
+	struct segment_header *seg = job->seg;
+
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = WRITE,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = job->rambuf->data,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+		.count = (seg->length + 1) << 3,
+	};
+
+	/*
+	 * The actual write requests to the cache device are not serialized.
+	 * They may perform in parallel.
+	 */
+	maybe_IO(dm_safe_io(&io_req, 1, &region, NULL, false));
+
+	/*
+	 * Deferred ACK for barrier requests
+	 * To serialize barrier ACK in logging we wait for the previous
+	 * segment to be persistently written (if needed).
+	 */
+	wait_for_flushing(wb, SUB_ID(seg->id, 1));
+
+	process_deferred_barriers(wb, job);
+
+	/*
+	 * We can count up the last_flushed_segment_id only after segment
+	 * is written persistently. counting up the id is serialized.
+	 */
+	atomic64_inc(&wb->last_flushed_segment_id);
+	wake_up(&wb->flush_wait_queue);
+
+	mempool_free(job, wb->flush_job_pool);
+}
+
+void wait_for_flushing(struct wb_device *wb, u64 id)
+{
+	wait_event(wb->flush_wait_queue,
+		atomic64_read(&wb->last_flushed_segment_id) >= id);
+}
+
+/*----------------------------------------------------------------*/
+
+static void writeback_endio(unsigned long error, void *context)
+{
+	struct wb_device *wb = context;
+
+	if (error)
+		atomic_inc(&wb->writeback_fail_count);
+
+	if (atomic_dec_and_test(&wb->writeback_io_count))
+		wake_up(&wb->writeback_io_wait_queue);
+}
+
+static void submit_writeback_io(struct wb_device *wb, struct writeback_io *writeback_io)
+{
+	int r;
+
+	if (!writeback_io->memorized_dirtiness)
+		return;
+
+	if (writeback_io->memorized_dirtiness == 255) {
+		struct dm_io_request io_req_w = {
+			.client = wb->io_client,
+			.bi_rw = WRITE,
+			.notify.fn = writeback_endio,
+			.notify.context = wb,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = writeback_io->data,
+		};
+		struct dm_io_region region_w = {
+			.bdev = wb->backing_dev->bdev,
+			.sector = writeback_io->sector,
+			.count = 1 << 3,
+		};
+		maybe_IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
+		if (r)
+			writeback_endio(0, wb);
+	} else {
+		u8 i;
+		for (i = 0; i < 8; i++) {
+			struct dm_io_request io_req_w;
+			struct dm_io_region region_w;
+
+			bool bit_on = writeback_io->memorized_dirtiness & (1 << i);
+			if (!bit_on)
+				continue;
+
+			io_req_w = (struct dm_io_request) {
+				.client = wb->io_client,
+				.bi_rw = WRITE,
+				.notify.fn = writeback_endio,
+				.notify.context = wb,
+				.mem.type = DM_IO_KMEM,
+				.mem.ptr.addr = writeback_io->data + (i << SECTOR_SHIFT),
+			};
+			region_w = (struct dm_io_region) {
+				.bdev = wb->backing_dev->bdev,
+				.sector = writeback_io->sector + i,
+				.count = 1,
+			};
+			maybe_IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
+			if (r)
+				writeback_endio(0, wb);
+		}
+	}
+}
+
+static void submit_writeback_ios(struct wb_device *wb)
+{
+	struct blk_plug plug;
+	struct rb_root wt = wb->writeback_tree;
+	blk_start_plug(&plug);
+	while (!RB_EMPTY_ROOT(&wt)) {
+		struct writeback_io *writeback_io = writeback_io_from_node(rb_first(&wt));
+		rb_erase(&writeback_io->rb_node, &wt);
+		submit_writeback_io(wb, writeback_io);
+	}
+	blk_finish_plug(&plug);
+}
+
+/*
+ * Compare two writeback IOs
+ * If the two have the same sector then compare them with the IDs.
+ * We process the older ID first and then overwrites with the older.
+ *
+ * (10, 3) < (11, 1)
+ * (10, 3) < (10, 4)
+ */
+static bool compare_writeback_io(struct writeback_io *a, struct writeback_io *b)
+{
+	BUG_ON(!a);
+	BUG_ON(!b);
+	if (a->sector < b->sector)
+		return true;
+	if (a->id < b->id)
+		return true;
+	return false;
+}
+
+static void inc_writeback_io_count(u8 dirty_bits, size_t *writeback_io_count)
+{
+	u8 i;
+	if (!dirty_bits)
+		return;
+
+	if (dirty_bits == 255) {
+		(*writeback_io_count)++;
+	} else {
+		for (i = 0; i < 8; i++) {
+			if (dirty_bits & (1 << i))
+				(*writeback_io_count)++;
+		}
+	}
+}
+
+/*
+ * Add writeback IO to rb-tree for sorted writeback.
+ * All writeback IOs are sorted in ascending order.
+ */
+static void add_writeback_io(struct wb_device *wb, struct writeback_io *writeback_io)
+{
+	struct rb_node **rbp, *parent;
+	rbp = &wb->writeback_tree.rb_node;
+	parent = NULL;
+	while (*rbp) {
+		struct writeback_io *parent_io;
+		parent = *rbp;
+		parent_io = writeback_io_from_node(parent);
+
+		if (compare_writeback_io(writeback_io, parent_io))
+			rbp = &(*rbp)->rb_left;
+		else
+			rbp = &(*rbp)->rb_right;
+	}
+	rb_link_node(&writeback_io->rb_node, parent, rbp);
+	rb_insert_color(&writeback_io->rb_node, &wb->writeback_tree);
+}
+
+/*
+ * Read the data to writeback IOs and add them into the rb-tree to sort.
+ */
+static void prepare_writeback_ios(struct wb_device *wb, struct writeback_segment *writeback_seg,
+				  size_t *writeback_io_count)
+{
+	int r = 0;
+	u8 i;
+
+	struct segment_header *seg = writeback_seg->seg;
+
+	struct dm_io_request io_req_r = {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = writeback_seg->buf,
+	};
+	struct dm_io_region region_r = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector + (1 << 3), /* Header excluded */
+		.count = seg->length << 3,
+	};
+
+	/*
+	 * dm_io() allows region.count = 0
+	 * so we don't need to skip here in case of seg->length = 0
+	 */
+	maybe_IO(dm_safe_io(&io_req_r, 1, &region_r, NULL, false));
+
+	for (i = 0; i < seg->length; i++) {
+		struct metablock *mb = seg->mb_array + i;
+
+		struct writeback_io *writeback_io = writeback_seg->ios + i;
+		writeback_io->sector = mb->sector;
+		writeback_io->id = seg->id;
+		/* writeback_io->data is already set */
+		writeback_io->memorized_dirtiness = read_mb_dirtiness(wb, seg, mb);
+
+		inc_writeback_io_count(writeback_io->memorized_dirtiness, writeback_io_count);
+		add_writeback_io(wb, writeback_io);
+	}
+}
+
+static void cleanup_segment(struct wb_device *wb, struct segment_header *seg)
+{
+	u8 i;
+	for (i = 0; i < seg->length; i++) {
+		struct metablock *mb = seg->mb_array + i;
+		cleanup_mb_if_dirty(wb, seg, mb);
+	}
+}
+
+static void do_writeback_segs(struct wb_device *wb)
+{
+	int r;
+	size_t k;
+	struct writeback_segment *writeback_seg;
+
+	size_t writeback_io_count = 0;
+	/*
+	 * Create rbtree
+	 */
+	wb->writeback_tree = RB_ROOT;
+	for (k = 0; k < wb->num_writeback_segs; k++) {
+		writeback_seg = *(wb->writeback_segs + k);
+		prepare_writeback_ios(wb, writeback_seg, &writeback_io_count);
+	}
+	atomic_set(&wb->writeback_io_count, writeback_io_count);
+	atomic_set(&wb->writeback_fail_count, 0);
+
+	/*
+	 * Pop rbnodes out of the tree and submit writeback I/Os
+	 */
+	submit_writeback_ios(wb);
+	wait_event(wb->writeback_io_wait_queue, !atomic_read(&wb->writeback_io_count));
+	if (atomic_read(&wb->writeback_fail_count))
+		mark_dead(wb);
+
+	for (k = 0; k < wb->num_writeback_segs; k++) {
+		writeback_seg = *(wb->writeback_segs + k);
+		cleanup_segment(wb, writeback_seg->seg);
+	}
+
+	/*
+	 * We must write back a segments if it was written persistently.
+	 * Nevertheless, we betray the upper layer.
+	 * Remembering which segment is persistent is too expensive
+	 * and furthermore meaningless.
+	 * So we consider all segments are persistent and write them back
+	 * persistently.
+	 */
+	maybe_IO(blkdev_issue_flush(wb->backing_dev->bdev, GFP_NOIO, NULL));
+
+	atomic64_add(wb->num_writeback_segs, &wb->last_writeback_segment_id);
+}
+
+/*
+ * Calculate the number of segments to write back.
+ */
+static u32 calc_nr_writeback(struct wb_device *wb)
+{
+	u32 nr_writeback_candidates, nr_max_batch;
+
+	nr_writeback_candidates = atomic64_read(&wb->last_flushed_segment_id) -
+				  atomic64_read(&wb->last_writeback_segment_id);
+	if (!nr_writeback_candidates)
+		return 0;
+
+	nr_max_batch = ACCESS_ONCE(wb->nr_max_batched_writeback);
+	if (wb->nr_cur_batched_writeback != nr_max_batch)
+		try_alloc_writeback_ios(wb, nr_max_batch);
+	return min(nr_writeback_candidates, wb->nr_cur_batched_writeback);
+}
+
+static bool should_writeback(struct wb_device *wb)
+{
+	return ACCESS_ONCE(wb->allow_writeback) ||
+	       ACCESS_ONCE(wb->urge_writeback)  ||
+	       ACCESS_ONCE(wb->force_drop);
+}
+
+static void do_writeback_proc(struct wb_device *wb)
+{
+	u32 k, nr_writeback;
+
+	if (!should_writeback(wb)) {
+		schedule_timeout_interruptible(msecs_to_jiffies(1000));
+		return;
+	}
+
+	nr_writeback = calc_nr_writeback(wb);
+	if (!nr_writeback) {
+		schedule_timeout_interruptible(msecs_to_jiffies(1000));
+		return;
+	}
+
+	/*
+	 * Store segments into writeback_segs
+	 */
+	for (k = 0; k < nr_writeback; k++) {
+		struct writeback_segment *writeback_seg = *(wb->writeback_segs + k);
+		writeback_seg->seg = get_segment_header_by_id(wb,
+			atomic64_read(&wb->last_writeback_segment_id) + 1 + k);
+	}
+	wb->num_writeback_segs = nr_writeback;
+
+	do_writeback_segs(wb);
+
+	wake_up(&wb->writeback_wait_queue);
+}
+
+int writeback_proc(void *data)
+{
+	struct wb_device *wb = data;
+	while (!kthread_should_stop())
+		do_writeback_proc(wb);
+	return 0;
+}
+
+/*
+ * Wait for a segment to be written back.
+ * After written back the metablocks in the segment are clean.
+ */
+void wait_for_writeback(struct wb_device *wb, u64 id)
+{
+	wb->urge_writeback = true;
+	wake_up_process(wb->writeback_daemon);
+	wait_event(wb->writeback_wait_queue,
+		atomic64_read(&wb->last_writeback_segment_id) >= id);
+	wb->urge_writeback = false;
+}
+
+/*----------------------------------------------------------------*/
+
+int modulator_proc(void *data)
+{
+	struct wb_device *wb = data;
+
+	struct hd_struct *hd = wb->backing_dev->bdev->bd_part;
+	unsigned long old = 0, new, util;
+	unsigned long intvl = 1000;
+
+	while (!kthread_should_stop()) {
+		new = jiffies_to_msecs(part_stat_read(hd, io_ticks));
+
+		if (!ACCESS_ONCE(wb->enable_writeback_modulator))
+			goto modulator_update;
+
+		util = div_u64(100 * (new - old), 1000);
+
+		if (util < ACCESS_ONCE(wb->writeback_threshold))
+			wb->allow_writeback = true;
+		else
+			wb->allow_writeback = false;
+
+modulator_update:
+		old = new;
+
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static void update_superblock_record(struct wb_device *wb)
+{
+	int r = 0;
+
+	struct superblock_record_device o;
+	void *buf;
+	struct dm_io_request io_req;
+	struct dm_io_region region;
+
+	o.last_writeback_segment_id =
+		cpu_to_le64(atomic64_read(&wb->last_writeback_segment_id));
+
+	buf = mempool_alloc(wb->buf_1_pool, GFP_NOIO);
+	memset(buf, 0, 1 << 9);
+	memcpy(buf, &o, sizeof(o));
+
+	io_req = (struct dm_io_request) {
+		.client = wb->io_client,
+		.bi_rw = WRITE_FUA,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = (1 << 11) - 1,
+		.count = 1,
+	};
+	maybe_IO(dm_safe_io(&io_req, 1, &region, NULL, false));
+
+	mempool_free(buf, wb->buf_1_pool);
+}
+
+int recorder_proc(void *data)
+{
+	struct wb_device *wb = data;
+
+	unsigned long intvl;
+
+	while (!kthread_should_stop()) {
+		/* sec -> ms */
+		intvl = ACCESS_ONCE(wb->update_record_interval) * 1000;
+
+		if (!intvl) {
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));
+			continue;
+		}
+
+		update_superblock_record(wb);
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+int sync_proc(void *data)
+{
+	int r = 0;
+
+	struct wb_device *wb = data;
+	unsigned long intvl;
+
+	while (!kthread_should_stop()) {
+		/* sec -> ms */
+		intvl = ACCESS_ONCE(wb->sync_interval) * 1000;
+
+		if (!intvl) {
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));
+			continue;
+		}
+
+		flush_current_buffer(wb);
+		maybe_IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
diff --git a/drivers/staging/writeboost/dm-writeboost-daemon.h b/drivers/staging/writeboost/dm-writeboost-daemon.h
new file mode 100644
index 0000000..c05489f
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost-daemon.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_DAEMON_H
+#define DM_WRITEBOOST_DAEMON_H
+
+/*----------------------------------------------------------------*/
+
+void flush_proc(struct work_struct *);
+void wait_for_flushing(struct wb_device *, u64 id);
+
+/*----------------------------------------------------------------*/
+
+void queue_barrier_io(struct wb_device *, struct bio *);
+void flush_barrier_ios(struct work_struct *);
+
+/*----------------------------------------------------------------*/
+
+int writeback_proc(void *);
+void wait_for_writeback(struct wb_device *, u64 id);
+
+/*----------------------------------------------------------------*/
+
+int modulator_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+int sync_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+int recorder_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/staging/writeboost/dm-writeboost-metadata.c b/drivers/staging/writeboost/dm-writeboost-metadata.c
new file mode 100644
index 0000000..8bf8c45
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost-metadata.c
@@ -0,0 +1,1862 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+/*----------------------------------------------------------------*/
+
+struct part {
+	void *memory;
+};
+
+struct large_array {
+	struct part *parts;
+	u64 nr_elems;
+	u32 elemsize;
+};
+
+#define ALLOC_SIZE (1 << 16)
+static u32 nr_elems_in_part(struct large_array *arr)
+{
+	return div_u64(ALLOC_SIZE, arr->elemsize);
+};
+
+static u64 nr_parts(struct large_array *arr)
+{
+	u64 a = arr->nr_elems;
+	u32 b = nr_elems_in_part(arr);
+	return div_u64(a + b - 1, b);
+}
+
+static struct large_array *large_array_alloc(u32 elemsize, u64 nr_elems)
+{
+	u64 i;
+
+	struct large_array *arr = kmalloc(sizeof(*arr), GFP_KERNEL);
+	if (!arr) {
+		DMERR("Failed to allocate arr");
+		return NULL;
+	}
+
+	arr->elemsize = elemsize;
+	arr->nr_elems = nr_elems;
+	arr->parts = kmalloc(sizeof(struct part) * nr_parts(arr), GFP_KERNEL);
+	if (!arr->parts) {
+		DMERR("Failed to allocate parts");
+		goto bad_alloc_parts;
+	}
+
+	for (i = 0; i < nr_parts(arr); i++) {
+		struct part *part = arr->parts + i;
+		part->memory = kmalloc(ALLOC_SIZE, GFP_KERNEL);
+		if (!part->memory) {
+			u8 j;
+
+			DMERR("Failed to allocate part->memory");
+			for (j = 0; j < i; j++) {
+				part = arr->parts + j;
+				kfree(part->memory);
+			}
+			goto bad_alloc_parts_memory;
+		}
+	}
+	return arr;
+
+bad_alloc_parts_memory:
+	kfree(arr->parts);
+bad_alloc_parts:
+	kfree(arr);
+	return NULL;
+}
+
+static void large_array_free(struct large_array *arr)
+{
+	size_t i;
+	for (i = 0; i < nr_parts(arr); i++) {
+		struct part *part = arr->parts + i;
+		kfree(part->memory);
+	}
+	kfree(arr->parts);
+	kfree(arr);
+}
+
+static void *large_array_at(struct large_array *arr, u64 i)
+{
+	u32 n = nr_elems_in_part(arr);
+	u32 k;
+	u64 j = div_u64_rem(i, n, &k);
+	struct part *part = arr->parts + j;
+	return part->memory + (arr->elemsize * k);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Get the in-core metablock of the given index.
+ */
+static struct metablock *mb_at(struct wb_device *wb, u32 idx)
+{
+	u32 idx_inseg;
+	u32 seg_idx = div_u64_rem(idx, wb->nr_caches_inseg, &idx_inseg);
+	struct segment_header *seg =
+		large_array_at(wb->segment_header_array, seg_idx);
+	return seg->mb_array + idx_inseg;
+}
+
+static void mb_array_empty_init(struct wb_device *wb)
+{
+	u32 i;
+	for (i = 0; i < wb->nr_caches; i++) {
+		struct metablock *mb = mb_at(wb, i);
+		INIT_HLIST_NODE(&mb->ht_list);
+
+		mb->idx = i;
+		mb->dirty_bits = 0;
+	}
+}
+
+/*
+ * Calc the starting sector of the k-th segment
+ */
+static sector_t calc_segment_header_start(struct wb_device *wb, u32 k)
+{
+	return (1 << 11) + (1 << wb->segment_size_order) * k;
+}
+
+static u32 calc_nr_segments(struct dm_dev *dev, struct wb_device *wb)
+{
+	sector_t devsize = dm_devsize(dev);
+	return div_u64(devsize - (1 << 11), 1 << wb->segment_size_order);
+}
+
+/*
+ * Get the relative index in a segment of the mb_idx-th metablock
+ */
+u8 mb_idx_inseg(struct wb_device *wb, u32 mb_idx)
+{
+	u32 tmp32;
+	div_u64_rem(mb_idx, wb->nr_caches_inseg, &tmp32);
+	return tmp32;
+}
+
+/*
+ * Calc the starting sector of the mb_idx-th cache block
+ */
+sector_t calc_mb_start_sector(struct wb_device *wb, struct segment_header *seg, u32 mb_idx)
+{
+	return seg->start_sector + ((1 + mb_idx_inseg(wb, mb_idx)) << 3);
+}
+
+/*
+ * Get the segment that contains the passed mb
+ */
+struct segment_header *mb_to_seg(struct wb_device *wb, struct metablock *mb)
+{
+	struct segment_header *seg;
+	seg = ((void *) mb)
+	      - mb_idx_inseg(wb, mb->idx) * sizeof(struct metablock)
+	      - sizeof(struct segment_header);
+	return seg;
+}
+
+bool is_on_buffer(struct wb_device *wb, u32 mb_idx)
+{
+	u32 start = wb->current_seg->start_idx;
+	if (mb_idx < start)
+		return false;
+
+	if (mb_idx >= (start + wb->nr_caches_inseg))
+		return false;
+
+	return true;
+}
+
+static u32 segment_id_to_idx(struct wb_device *wb, u64 id)
+{
+	u32 idx;
+	div_u64_rem(id - 1, wb->nr_segments, &idx);
+	return idx;
+}
+
+static struct segment_header *segment_at(struct wb_device *wb, u32 k)
+{
+	return large_array_at(wb->segment_header_array, k);
+}
+
+/*
+ * Get the segment from the segment id.
+ * The index of the segment is calculated from the segment id.
+ */
+struct segment_header *get_segment_header_by_id(struct wb_device *wb, u64 id)
+{
+	return segment_at(wb, segment_id_to_idx(wb, id));
+}
+
+/*----------------------------------------------------------------*/
+
+static int init_segment_header_array(struct wb_device *wb)
+{
+	u32 segment_idx;
+
+	wb->segment_header_array = large_array_alloc(
+			sizeof(struct segment_header) +
+			sizeof(struct metablock) * wb->nr_caches_inseg,
+			wb->nr_segments);
+	if (!wb->segment_header_array) {
+		DMERR("Failed to allocate segment_header_array");
+		return -ENOMEM;
+	}
+
+	for (segment_idx = 0; segment_idx < wb->nr_segments; segment_idx++) {
+		struct segment_header *seg = large_array_at(wb->segment_header_array, segment_idx);
+
+		seg->id = 0;
+		seg->length = 0;
+		atomic_set(&seg->nr_inflight_ios, 0);
+
+		/*
+		 * Const values
+		 */
+		seg->start_idx = wb->nr_caches_inseg * segment_idx;
+		seg->start_sector = calc_segment_header_start(wb, segment_idx);
+	}
+
+	mb_array_empty_init(wb);
+
+	return 0;
+}
+
+static void free_segment_header_array(struct wb_device *wb)
+{
+	large_array_free(wb->segment_header_array);
+}
+
+/*----------------------------------------------------------------*/
+
+struct ht_head {
+	struct hlist_head ht_list;
+};
+
+/*
+ * Initialize the hash table.
+ */
+static int ht_empty_init(struct wb_device *wb)
+{
+	u32 idx;
+	size_t i, nr_heads;
+	struct large_array *arr;
+
+	wb->htsize = wb->nr_caches;
+	nr_heads = wb->htsize + 1;
+	arr = large_array_alloc(sizeof(struct ht_head), nr_heads);
+	if (!arr) {
+		DMERR("Failed to allocate htable");
+		return -ENOMEM;
+	}
+
+	wb->htable = arr;
+
+	for (i = 0; i < nr_heads; i++) {
+		struct ht_head *hd = large_array_at(arr, i);
+		INIT_HLIST_HEAD(&hd->ht_list);
+	}
+
+	wb->null_head = large_array_at(wb->htable, wb->htsize);
+
+	for (idx = 0; idx < wb->nr_caches; idx++) {
+		struct metablock *mb = mb_at(wb, idx);
+		hlist_add_head(&mb->ht_list, &wb->null_head->ht_list);
+	}
+
+	return 0;
+}
+
+static void free_ht(struct wb_device *wb)
+{
+	large_array_free(wb->htable);
+}
+
+struct ht_head *ht_get_head(struct wb_device *wb, struct lookup_key *key)
+{
+	u32 idx;
+	div_u64_rem(key->sector, wb->htsize, &idx);
+	return large_array_at(wb->htable, idx);
+}
+
+static bool mb_hit(struct metablock *mb, struct lookup_key *key)
+{
+	return mb->sector == key->sector;
+}
+
+/*
+ * Remove the metablock from the hashtable
+ * and link the orphan to the null head.
+ */
+void ht_del(struct wb_device *wb, struct metablock *mb)
+{
+	struct ht_head *null_head;
+
+	hlist_del(&mb->ht_list);
+
+	null_head = wb->null_head;
+	hlist_add_head(&mb->ht_list, &null_head->ht_list);
+}
+
+void ht_register(struct wb_device *wb, struct ht_head *head,
+		 struct metablock *mb, struct lookup_key *key)
+{
+	hlist_del(&mb->ht_list);
+	hlist_add_head(&mb->ht_list, &head->ht_list);
+
+	mb->sector = key->sector;
+};
+
+struct metablock *ht_lookup(struct wb_device *wb, struct ht_head *head,
+			    struct lookup_key *key)
+{
+	struct metablock *mb, *found = NULL;
+	hlist_for_each_entry(mb, &head->ht_list, ht_list) {
+		if (mb_hit(mb, key)) {
+			found = mb;
+			break;
+		}
+	}
+	return found;
+}
+
+/*
+ * Remove all the metablock in the segment from the lookup table.
+ */
+void discard_caches_inseg(struct wb_device *wb, struct segment_header *seg)
+{
+	u8 i;
+	for (i = 0; i < wb->nr_caches_inseg; i++) {
+		struct metablock *mb = seg->mb_array + i;
+		ht_del(wb, mb);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
+static int read_superblock_header(struct superblock_header_device *sup,
+				  struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_io_request io_req_sup;
+	struct dm_io_region region_sup;
+
+	void *buf = mempool_alloc(wb->buf_1_pool, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	check_buffer_alignment(buf);
+
+	io_req_sup = (struct dm_io_request) {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region_sup = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = 0,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req_sup, 1, &region_sup, NULL, false);
+	if (r)
+		goto bad_io;
+
+	memcpy(sup, buf, sizeof(*sup));
+
+bad_io:
+	mempool_free(buf, wb->buf_1_pool);
+	return r;
+}
+
+/*
+ * check if the cache device is already formatted.
+ *
+ * @need_format (out): bad segment_size_order specified?
+ * @allow_format (out): is the superblock was zeroed by the user?
+ *
+ * returns 0 iff this routine runs without failure.
+ */
+static int audit_cache_device(struct wb_device *wb,
+			      bool *need_format, bool *allow_format)
+{
+	int r = 0;
+	struct superblock_header_device sup;
+	r = read_superblock_header(&sup, wb);
+	if (r) {
+		DMERR("read_superblock_header failed");
+		return r;
+	}
+
+	*need_format = true;
+	*allow_format = false;
+
+	if (le32_to_cpu(sup.magic) != WB_MAGIC) {
+		*allow_format = true;
+		DMERR("Superblock Header: Magic number invalid");
+		return 0;
+	}
+
+	if (sup.segment_size_order != wb->segment_size_order) {
+		DMERR("Superblock Header: segment_size_order not same %u != %u",
+		      sup.segment_size_order, wb->segment_size_order);
+	} else {
+		*need_format = false;
+	}
+
+	return r;
+}
+
+static int format_superblock_header(struct wb_device *wb)
+{
+	int r = 0;
+
+	struct dm_io_request io_req_sup;
+	struct dm_io_region region_sup;
+
+	struct superblock_header_device sup = {
+		.magic = cpu_to_le32(WB_MAGIC),
+		.segment_size_order = wb->segment_size_order,
+	};
+
+	void *buf = mempool_alloc(wb->buf_1_pool, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memcpy(buf, &sup, sizeof(sup));
+
+	io_req_sup = (struct dm_io_request) {
+		.client = wb->io_client,
+		.bi_rw = WRITE_FUA,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region_sup = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = 0,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req_sup, 1, &region_sup, NULL, false);
+	if (r)
+		goto bad_io;
+
+bad_io:
+	mempool_free(buf, wb->buf_1_pool);
+	return r;
+}
+
+struct format_segmd_context {
+	int err;
+	atomic64_t count;
+};
+
+static void format_segmd_endio(unsigned long error, void *__context)
+{
+	struct format_segmd_context *context = __context;
+	if (error)
+		context->err = 1;
+	atomic64_dec(&context->count);
+}
+
+struct zeroing_context {
+	int error;
+	struct completion complete;
+};
+
+static void zeroing_complete(int read_err, unsigned long write_err, void *context)
+{
+	struct zeroing_context *zc = context;
+	if (read_err || write_err)
+		zc->error = -EIO;
+	complete(&zc->complete);
+}
+
+/*
+ * Synchronously zeros out a region on a device.
+ */
+static int do_zeroing_region(struct wb_device *wb, struct dm_io_region *region)
+{
+	int r;
+	struct zeroing_context zc;
+	zc.error = 0;
+	init_completion(&zc.complete);
+	r = dm_kcopyd_zero(wb->copier, 1, region, 0, zeroing_complete, &zc);
+	if (r)
+		return r;
+	wait_for_completion(&zc.complete);
+	return zc.error;
+}
+
+static int zeroing_full_superblock(struct wb_device *wb)
+{
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = 0,
+		.count = 1 << 11,
+	};
+	return do_zeroing_region(wb, &region);
+}
+
+static int format_all_segment_headers(struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_dev *dev = wb->cache_dev;
+	u32 i, nr_segments = calc_nr_segments(dev, wb);
+
+	struct format_segmd_context context;
+
+	void *buf = mempool_alloc(wb->buf_8_pool, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memset(buf, 0, 1 << 12);
+	check_buffer_alignment(buf);
+
+	atomic64_set(&context.count, nr_segments);
+	context.err = 0;
+
+	/*
+	 * Submit all the writes asynchronously.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		struct dm_io_request io_req_seg = {
+			.client = wb->io_client,
+			.bi_rw = WRITE,
+			.notify.fn = format_segmd_endio,
+			.notify.context = &context,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+		struct dm_io_region region_seg = {
+			.bdev = dev->bdev,
+			.sector = calc_segment_header_start(wb, i),
+			.count = (1 << 3),
+		};
+		r = dm_safe_io(&io_req_seg, 1, &region_seg, NULL, false);
+		if (r)
+			break;
+	}
+
+	if (r)
+		goto bad;
+
+	/*
+	 * Wait for all the writes complete.
+	 */
+	while (atomic64_read(&context.count))
+		schedule_timeout_interruptible(msecs_to_jiffies(100));
+
+	if (context.err) {
+		DMERR("I/O failed");
+		r = -EIO;
+	}
+
+bad:
+	mempool_free(buf, wb->buf_8_pool);
+	return r;
+}
+
+/*
+ * Format superblock header and
+ * all the segment headers in a cache device
+ */
+static int format_cache_device(struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_dev *dev = wb->cache_dev;
+
+	r = zeroing_full_superblock(wb);
+	if (r) {
+		DMERR("zeroing_full_superblock failed");
+		return r;
+	}
+	r = format_superblock_header(wb); /* First 512B */
+	if (r) {
+		DMERR("format_superblock_header failed");
+		return r;
+	}
+	r = format_all_segment_headers(wb);
+	if (r) {
+		DMERR("format_all_segment_headers failed");
+		return r;
+	}
+	r = blkdev_issue_flush(dev->bdev, GFP_KERNEL, NULL);
+
+	return r;
+}
+
+/*
+ * Setup the core info relavant to the cache geometry.
+ * segment_size_order is the core factor in the cache geometry.
+ */
+static void setup_geom_info(struct wb_device *wb)
+{
+	wb->nr_segments = calc_nr_segments(wb->cache_dev, wb);
+	wb->nr_caches_inseg = (1 << (wb->segment_size_order - 3)) - 1;
+	wb->nr_caches = wb->nr_segments * wb->nr_caches_inseg;
+}
+
+/*
+ * First check if the superblock and the passed arguments
+ * are consistent and re-format the cache structure if they are not.
+ * If you want to re-format the cache device you must zeroed out
+ * the first one sector of the device.
+ *
+ * After this, the segment_size_order is fixed.
+ *
+ * @formatted (out): Was the cache device re-formatted?
+ */
+static int might_format_cache_device(struct wb_device *wb, bool *formatted)
+{
+	int r = 0;
+
+	bool need_format, allow_format;
+	r = audit_cache_device(wb, &need_format, &allow_format);
+	if (r) {
+		DMERR("audit_cache_device failed");
+		return r;
+	}
+
+	if (need_format) {
+		if (allow_format) {
+			*formatted = true;
+
+			r = format_cache_device(wb);
+			if (r) {
+				DMERR("format_cache_device failed");
+				return r;
+			}
+		} else {
+			/*
+			 * If it is needed to re-format but not allowed
+			 * the user may input bad .ctr argument although
+			 * the cache device has data to recover.
+			 * To re-format the cache device user MUST
+			 * zero out the first 1 sector of the device
+			 * INTENTIONALLY.
+			 */
+			r = -EINVAL;
+			DMERR("Cache device not allowed to format");
+			return r;
+		}
+	}
+
+	/*
+	 * segment_size_order is fixed and we can compute all the
+	 * geometry info that depends on the value.
+	 */
+	setup_geom_info(wb);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+static int init_rambuf_pool(struct wb_device *wb)
+{
+	int r = 0;
+	size_t i;
+
+	wb->rambuf_pool = kmalloc(sizeof(struct rambuffer) * wb->nr_rambuf_pool,
+				  GFP_KERNEL);
+	if (!wb->rambuf_pool)
+		return -ENOMEM;
+
+	wb->rambuf_cachep = kmem_cache_create("dmwb_rambuf",
+			1 << (wb->segment_size_order + SECTOR_SHIFT),
+			1 << (wb->segment_size_order + SECTOR_SHIFT),
+			SLAB_RED_ZONE, NULL);
+	if (!wb->rambuf_cachep) {
+		r = -ENOMEM;
+		goto bad_cachep;
+	}
+
+	for (i = 0; i < wb->nr_rambuf_pool; i++) {
+		size_t j;
+		struct rambuffer *rambuf = wb->rambuf_pool + i;
+
+		rambuf->data = kmem_cache_alloc(wb->rambuf_cachep, GFP_KERNEL);
+		if (!rambuf->data) {
+			DMERR("Failed to allocate rambuf->data");
+			for (j = 0; j < i; j++) {
+				rambuf = wb->rambuf_pool + j;
+				kmem_cache_free(wb->rambuf_cachep, rambuf->data);
+			}
+			r = -ENOMEM;
+			goto bad_alloc_data;
+		}
+		check_buffer_alignment(rambuf->data);
+	}
+
+	return r;
+
+bad_alloc_data:
+	kmem_cache_destroy(wb->rambuf_cachep);
+bad_cachep:
+	kfree(wb->rambuf_pool);
+	return r;
+}
+
+static void free_rambuf_pool(struct wb_device *wb)
+{
+	size_t i;
+	for (i = 0; i < wb->nr_rambuf_pool; i++) {
+		struct rambuffer *rambuf = wb->rambuf_pool + i;
+		kmem_cache_free(wb->rambuf_cachep, rambuf->data);
+	}
+	kmem_cache_destroy(wb->rambuf_cachep);
+	kfree(wb->rambuf_pool);
+}
+
+/*----------------------------------------------------------------*/
+
+static int do_clear_plog_dev_t1(struct wb_device *wb, u32 idx)
+{
+	struct dm_io_region region = {
+		.bdev = wb->plog_dev_t1->bdev,
+		.sector = wb->plog_seg_size * idx,
+		.count = wb->plog_seg_size,
+	};
+	return do_zeroing_region(wb, &region);
+}
+
+static int do_clear_plog_dev(struct wb_device *wb, u32 idx)
+{
+	int r = 0;
+
+	switch (wb->type) {
+	case 1:
+		r = do_clear_plog_dev_t1(wb, idx);
+		break;
+	default:
+		BUG();
+	}
+
+	return r;
+}
+
+/*
+ * Zero out the reserved region of log device
+ */
+static int clear_plog_dev(struct wb_device *wb)
+{
+	int r = 0;
+	u32 i;
+
+	for (i = 0; i < wb->nr_plog_segs; i++) {
+		r = do_clear_plog_dev(wb, i);
+		if (r)
+			return r;
+	}
+
+	return r;
+}
+
+static int do_alloc_plog_dev_t1(struct wb_device *wb)
+{
+	int r = 0;
+
+	u32 nr_max;
+
+	r = dm_get_device(wb->ti, wb->plog_dev_desc,
+			  dm_table_get_mode(wb->ti->table),
+			  &wb->plog_dev_t1);
+	if (r) {
+		DMERR("Failed to get plog_dev");
+		return -EINVAL;
+	}
+
+	nr_max = div_u64(dm_devsize(wb->plog_dev_t1), wb->plog_seg_size);
+	if (nr_max < 1) {
+		dm_put_device(wb->ti, wb->plog_dev_t1);
+		DMERR("plog_dev too small. Needs at least %llu sectors", (unsigned long long) wb->plog_seg_size);
+		return -EINVAL;
+	}
+
+	/*
+	 * The number of plogs is at most the number ram buffers
+	 * i.e. more plogs are meaningless.
+	 */
+	if (nr_max > wb->nr_rambuf_pool)
+		wb->nr_plog_segs = wb->nr_rambuf_pool;
+	else
+		wb->nr_plog_segs = min(wb->nr_plog_segs, nr_max);
+
+	return r;
+}
+
+/*
+ * Allocate the persistent device.
+ * After this funtion called all the members related to plog
+ * is complete (e.g. nr_plog_segs is set).
+ */
+static int do_alloc_plog_dev(struct wb_device *wb)
+{
+	int r = 0;
+
+	switch (wb->type) {
+	case 1:
+		r = do_alloc_plog_dev_t1(wb);
+		break;
+	default:
+		BUG();
+	}
+
+	return r;
+}
+
+static void do_free_plog_dev(struct wb_device *wb)
+{
+	switch (wb->type) {
+	case 1:
+		dm_put_device(wb->ti, wb->plog_dev_t1);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Allocate plog device and the data structures related.
+ *
+ * Clear the device if required.
+ * (We clear the device iff the cache device is formatted)
+ */
+static int alloc_plog_dev(struct wb_device *wb, bool clear)
+{
+	int r = 0;
+
+	wb->write_job_pool = mempool_create_kmalloc_pool(16, sizeof(struct write_job));
+	if (!wb->write_job_pool) {
+		r = -ENOMEM;
+		DMERR("Failed to alloc write_job_pool");
+		goto bad_write_job_pool;
+	}
+
+	if (!wb->type)
+		return 0;
+
+	init_waitqueue_head(&wb->plog_wait_queue);
+	atomic_set(&wb->nr_inflight_plog_writes, 0);
+
+	wb->plog_seg_size = (1 + 8) * wb->nr_caches_inseg;
+
+	wb->plog_buf_cachep = kmem_cache_create("dmwb_plog_buf",
+			(1 + 8) << SECTOR_SHIFT,
+			1 << SECTOR_SHIFT,
+			SLAB_RED_ZONE, NULL);
+	if (!wb->plog_buf_cachep) {
+		r = -ENOMEM;
+		DMERR("Failed to alloc plog_buf_cachep");
+		goto bad_plog_buf_cachep;
+	}
+	wb->plog_buf_pool = mempool_create_slab_pool(16, wb->plog_buf_cachep);
+	if (!wb->plog_buf_pool) {
+		r = -ENOMEM;
+		DMERR("Failed to alloc plog_buf_pool");
+		goto bad_plog_buf_pool;
+	}
+
+	wb->plog_seg_buf_cachep = kmem_cache_create("dmwb_plog_seg_buf",
+			wb->plog_seg_size << SECTOR_SHIFT,
+			1 << SECTOR_SHIFT,
+			SLAB_RED_ZONE, NULL);
+	if (!wb->plog_seg_buf_cachep) {
+		r = -ENOMEM;
+		DMERR("Failed to alloc plog_seg_buf_cachep");
+		goto bad_plog_seg_buf_cachep;
+	}
+
+	r = do_alloc_plog_dev(wb);
+	if (r) {
+		DMERR("do_alloc_plog_dev failed");
+		goto bad_alloc_plog_dev;
+	}
+
+	if (clear) {
+		r = clear_plog_dev(wb);
+		if (r) {
+			DMERR("clear_plog_device failed");
+			goto bad_clear_plog_dev;
+		}
+	}
+
+	return r;
+
+bad_clear_plog_dev:
+	do_free_plog_dev(wb);
+bad_alloc_plog_dev:
+	kmem_cache_destroy(wb->plog_seg_buf_cachep);
+bad_plog_seg_buf_cachep:
+	mempool_destroy(wb->plog_buf_pool);
+bad_plog_buf_pool:
+	kmem_cache_destroy(wb->plog_buf_cachep);
+bad_plog_buf_cachep:
+	mempool_destroy(wb->write_job_pool);
+bad_write_job_pool:
+	return r;
+}
+
+static void free_plog_dev(struct wb_device *wb)
+{
+	if (wb->type) {
+		do_free_plog_dev(wb);
+		kmem_cache_destroy(wb->plog_seg_buf_cachep);
+		mempool_destroy(wb->plog_buf_pool);
+		kmem_cache_destroy(wb->plog_buf_cachep);
+	}
+	mempool_destroy(wb->write_job_pool);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Initialize core devices
+ * - Cache device (SSD)
+ * - RAM buffers (DRAM)
+ * - Persistent log device (SSD or PRAM)
+ */
+static int init_devices(struct wb_device *wb)
+{
+	int r = 0;
+
+	bool formatted = false;
+
+	r = might_format_cache_device(wb, &formatted);
+	if (r)
+		return r;
+
+	r = init_rambuf_pool(wb);
+	if (r) {
+		DMERR("init_rambuf_pool failed");
+		return r;
+	}
+
+	r = alloc_plog_dev(wb, formatted);
+	if (r)
+		goto bad_alloc_plog;
+
+	return r;
+
+bad_alloc_plog:
+	free_rambuf_pool(wb);
+	return r;
+}
+
+static void free_devices(struct wb_device *wb)
+{
+	free_plog_dev(wb);
+	free_rambuf_pool(wb);
+}
+
+/*----------------------------------------------------------------*/
+
+static int read_plog_seg_t1(void *buf, struct wb_device *wb, u32 idx)
+{
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->plog_dev_t1->bdev,
+		.sector = wb->plog_seg_size * idx,
+		.count = wb->plog_seg_size,
+	};
+	return dm_safe_io(&io_req, 1, &region, NULL, false);
+}
+
+/*
+ * Read the idx'th plog seg on the persistent device and
+ * store it into a buffer.
+ */
+static int read_plog_seg(void *buf, struct wb_device *wb, u32 idx)
+{
+	int r = 0;
+
+	switch (wb->type) {
+	case 1:
+		r = read_plog_seg_t1(buf, wb, idx);
+		break;
+	default:
+		BUG();
+	}
+
+	return r;
+}
+
+static int find_min_id_plog(struct wb_device *wb, u64 *id, u32 *idx)
+{
+	int r = 0;
+
+	u32 i;
+	u64 min_id = SZ_MAX, id_cpu;
+
+	void *plog_seg_buf = kmem_cache_alloc(wb->plog_seg_buf_cachep, GFP_KERNEL);
+	if (r)
+		return -ENOMEM;
+
+	*id = 0; *idx = 0;
+	for (i = 0; i < wb->nr_plog_segs; i++) {
+		struct plog_meta_device meta;
+		read_plog_seg(plog_seg_buf, wb, i);
+		memcpy(&meta, plog_seg_buf, 512);
+
+		id_cpu = le64_to_cpu(meta.id);
+
+		if (!id_cpu)
+			continue;
+
+		if (id_cpu < min_id) {
+			min_id = id_cpu;
+			*id = min_id; *idx = i;
+		}
+	}
+
+	kmem_cache_free(wb->plog_seg_buf_cachep, plog_seg_buf);
+	return r;
+}
+
+static int flush_rambuf(struct wb_device *wb,
+			struct segment_header *seg, void *rambuf)
+{
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = WRITE,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = rambuf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+	};
+
+	struct segment_header_device *hd = rambuf;
+
+	region.count = (hd->length + 1) << 3;
+
+	return dm_safe_io(&io_req, 1, &region, NULL, false);
+}
+
+/*
+ * Flush a plog (stored in a buffer) to the cache device.
+ */
+static int flush_plog(struct wb_device *wb, void *plog_seg_buf, u64 log_id)
+{
+	int r = 0;
+	struct segment_header *seg;
+	void *rambuf;
+
+	rambuf = kmem_cache_alloc(wb->rambuf_cachep, GFP_KERNEL | __GFP_ZERO);
+	if (r)
+		return -ENOMEM;
+	rebuild_rambuf(rambuf, plog_seg_buf, log_id);
+
+	seg = get_segment_header_by_id(wb, log_id);
+	r = flush_rambuf(wb, seg, rambuf);
+	if (r)
+		DMERR("flush_rambuf failed");
+
+	kmem_cache_free(wb->rambuf_cachep, rambuf);
+	return r;
+}
+
+static int flush_plogs(struct wb_device *wb)
+{
+	int r = 0;
+	u64 next_id;
+	u32 i, orig_idx;
+	struct plog_meta_device meta;
+	void *plog_seg_buf;
+
+	if (!wb->type)
+		return 0;
+
+	plog_seg_buf = kmem_cache_alloc(wb->plog_seg_buf_cachep, GFP_KERNEL);
+	if (r)
+		return -ENOMEM;
+
+	r = find_min_id_plog(wb, &next_id, &orig_idx);
+	if (r) {
+		DMERR("find_min_id_plog failed");
+		goto bad;
+	}
+
+	/*
+	 * If there is no valid plog on the plog device we quit.
+	 */
+	if (!next_id) {
+		r = 0;
+		DMINFO("Couldn't find any valid plog");
+		goto bad;
+	}
+
+	for (i = 0; i < wb->nr_plog_segs; i++) {
+		u32 j;
+		u64 log_id;
+
+		div_u64_rem(orig_idx + i, wb->nr_plog_segs, &j);
+
+		read_plog_seg(plog_seg_buf, wb, j);
+		/*
+		 * The id of the head log is the log_id
+		 * that is identical within this plog.
+		 */
+		memcpy(&meta, plog_seg_buf, 512);
+		log_id = le64_to_cpu(meta.id);
+
+		if (log_id != next_id)
+			break;
+
+		/*
+		 * Now at least one log is valid in this plog.
+		 */
+		flush_plog(wb, plog_seg_buf, log_id);
+		next_id++;
+	}
+
+bad:
+	kmem_cache_free(wb->plog_seg_buf_cachep, plog_seg_buf);
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+static int read_superblock_record(struct superblock_record_device *record,
+				  struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_io_request io_req;
+	struct dm_io_region region;
+
+	void *buf = mempool_alloc(wb->buf_1_pool, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	check_buffer_alignment(buf);
+
+	io_req = (struct dm_io_request) {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = (1 << 11) - 1,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req, 1, &region, NULL, false);
+	if (r)
+		goto bad_io;
+
+	memcpy(record, buf, sizeof(*record));
+
+bad_io:
+	mempool_free(buf, wb->buf_1_pool);
+	return r;
+}
+
+/*
+ * Read out whole segment of @seg to a pre-allocated @buf
+ */
+static int read_whole_segment(void *buf, struct wb_device *wb,
+			      struct segment_header *seg)
+{
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+		.count = 1 << wb->segment_size_order,
+	};
+	return dm_safe_io(&io_req, 1, &region, NULL, false);
+}
+
+/*
+ * We make a checksum of a segment from the valid data
+ * in a segment except the first 1 sector.
+ */
+u32 calc_checksum(void *rambuffer, u8 length)
+{
+	unsigned int len = (4096 - 512) + 4096 * length;
+	return crc32c(WB_CKSUM_SEED, rambuffer + 512, len);
+}
+
+void prepare_segment_header_device(void *rambuffer,
+				   struct wb_device *wb,
+				   struct segment_header *src)
+{
+	struct segment_header_device *dest = rambuffer;
+	u32 i;
+
+	BUG_ON((src->length) != (wb->cursor - src->start_idx));
+
+	for (i = 0; i < src->length; i++) {
+		struct metablock *mb = src->mb_array + i;
+		struct metablock_device *mbdev = dest->mbarr + i;
+
+		mbdev->sector = cpu_to_le64((u64)mb->sector);
+		mbdev->dirty_bits = mb->dirty_bits;
+	}
+
+	dest->id = cpu_to_le64(src->id);
+	dest->length = src->length;
+	dest->checksum = cpu_to_le32(calc_checksum(rambuffer, src->length));
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Apply @i-th metablock in @src to @seg
+ */
+static void apply_metablock_device(struct wb_device *wb, struct segment_header *seg,
+				   struct segment_header_device *src, u8 i)
+{
+	struct lookup_key key;
+	struct ht_head *head;
+	struct metablock *found = NULL, *mb = seg->mb_array + i;
+	struct metablock_device *mbdev = src->mbarr + i;
+
+	mb->sector = le64_to_cpu(mbdev->sector);
+	mb->dirty_bits = mbdev->dirty_bits;
+	BUG_ON(!mb->dirty_bits);
+
+	key = (struct lookup_key) {
+		.sector = mb->sector,
+	};
+	head = ht_get_head(wb, &key);
+	found = ht_lookup(wb, head, &key);
+	if (found) {
+		bool overwrite_fullsize = (mb->dirty_bits == 255);
+		invalidate_previous_cache(wb, mb_to_seg(wb, found), found,
+					  overwrite_fullsize);
+	}
+
+	inc_nr_dirty_caches(wb);
+	ht_register(wb, head, mb, &key);
+}
+
+/*
+ * Read the on-disk metadata of the segment @src and
+ * update the in-core cache metadata structure of @seg
+ */
+static void apply_segment_header_device(struct wb_device *wb, struct segment_header *seg,
+					struct segment_header_device *src)
+{
+	u8 i;
+	seg->length = src->length;
+	for (i = 0; i < src->length; i++)
+		apply_metablock_device(wb, seg, src, i);
+}
+
+/*
+ * Read out only segment header (4KB) of @seg to @buf
+ */
+static int read_segment_header(void *buf, struct wb_device *wb,
+			       struct segment_header *seg)
+{
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+		.count = 8,
+	};
+	return dm_safe_io(&io_req, 1, &region, NULL, false);
+}
+
+/*
+ * Find the max id from all the segment headers
+ * @max_id (out): The max id found
+ */
+static int find_max_id(struct wb_device *wb, u64 *max_id)
+{
+	int r = 0;
+	u32 k;
+
+	void *buf = mempool_alloc(wb->buf_8_pool, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	check_buffer_alignment(buf);
+
+	*max_id = 0;
+	for (k = 0; k < wb->nr_segments; k++) {
+		struct segment_header *seg = segment_at(wb, k);
+		struct segment_header_device *header;
+		r = read_segment_header(buf, wb, seg);
+		if (r) {
+			kfree(buf);
+			return r;
+		}
+
+		header = buf;
+		if (le64_to_cpu(header->id) > *max_id)
+			*max_id = le64_to_cpu(header->id);
+	}
+	mempool_free(buf, wb->buf_8_pool);
+	return r;
+}
+
+/*
+ * Iterate over the logs on the cache device and
+ * apply (recover the cache metadata)
+ * valid (checksum is correct) segments.
+ * A segment is valid means that the segment was written
+ * without any failure typically due to unexpected power failure.
+ *
+ * @max_id (in/out)
+ *   - in : The max id found in find_max_id()
+ *   - out: The last id applied in this function
+ */
+static int apply_valid_segments(struct wb_device *wb, u64 *max_id)
+{
+	int r = 0;
+	struct segment_header *seg;
+	struct segment_header_device *header;
+	u32 i, start_idx;
+
+	void *rambuf = kmem_cache_alloc(wb->rambuf_cachep, GFP_KERNEL);
+	if (!rambuf)
+		return -ENOMEM;
+
+	/*
+	 * We are starting from the segment next to the newest which can
+	 * be the oldest. The id can be zero if the logs didn't lap at all.
+	 */
+	start_idx = segment_id_to_idx(wb, *max_id + 1);
+	*max_id = 0;
+
+	for (i = start_idx; i < (start_idx + wb->nr_segments); i++) {
+		u32 actual, expected, k;
+		div_u64_rem(i, wb->nr_segments, &k);
+		seg = segment_at(wb, k);
+
+		r = read_whole_segment(rambuf, wb, seg);
+		if (r)
+			break;
+
+		header = rambuf;
+
+		if (!le64_to_cpu(header->id))
+			continue;
+
+		/*
+		 * Compare the checksum
+		 * if they don't match we discard the subsequent logs.
+		 */
+		actual = calc_checksum(rambuf, header->length);
+		expected = le32_to_cpu(header->checksum);
+		if (actual != expected) {
+			DMWARN("Checksum incorrect id:%llu checksum: %u != %u",
+			       (long long unsigned int) le64_to_cpu(header->id),
+			       actual, expected);
+			break;
+		}
+
+		/*
+		 * This segment is correct and we apply
+		 */
+		apply_segment_header_device(wb, seg, header);
+		*max_id = le64_to_cpu(header->id);
+	}
+
+	kmem_cache_free(wb->rambuf_cachep, rambuf);
+	return r;
+}
+
+static int infer_last_writeback_id(struct wb_device *wb)
+{
+	int r = 0;
+
+	u64 record_id;
+	struct superblock_record_device uninitialized_var(record);
+	r = read_superblock_record(&record, wb);
+	if (r)
+		return r;
+
+	atomic64_set(&wb->last_writeback_segment_id,
+		atomic64_read(&wb->last_flushed_segment_id) > wb->nr_segments ?
+		atomic64_read(&wb->last_flushed_segment_id) - wb->nr_segments : 0);
+
+	/*
+	 * If last_writeback_id is recorded on the super block
+	 * We can eliminate unnecessary writeback for the segments that
+	 * were written back before.
+	 */
+	record_id = le64_to_cpu(record.last_writeback_segment_id);
+	if (record_id > atomic64_read(&wb->last_writeback_segment_id))
+		atomic64_set(&wb->last_writeback_segment_id, record_id);
+
+	return r;
+}
+
+/*
+ * Replay all the log on the cache device to reconstruct
+ * the in-memory metadata.
+ *
+ * Algorithm:
+ * 1. Find the maxium id
+ * 2. Start from the right. iterate all the log.
+ * 2. Skip if id=0 or checkum incorrect
+ * 2. Apply otherwise.
+ *
+ * This algorithm is robust for floppy SSD that may write
+ * a segment partially or lose data on its buffer on power fault.
+ *
+ * Even if number of threads flush segments in parallel and
+ * some of them loses atomicity because of power fault
+ * this robust algorithm works.
+ */
+static int replay_log_on_cache(struct wb_device *wb)
+{
+	int r = 0;
+	u64 max_id;
+
+	r = find_max_id(wb, &max_id);
+	if (r) {
+		DMERR("find_max_id failed");
+		return r;
+	}
+
+	r = apply_valid_segments(wb, &max_id);
+	if (r) {
+		DMERR("apply_valid_segments failed");
+		return r;
+	}
+
+	/*
+	 * Setup last_flushed_segment_id
+	 */
+	atomic64_set(&wb->last_flushed_segment_id, max_id);
+
+	/*
+	 * Setup last_writeback_segment_id
+	 */
+	infer_last_writeback_id(wb);
+
+	return r;
+}
+
+/*
+ * Acquire and initialize the first segment header for our caching.
+ */
+static void prepare_first_seg(struct wb_device *wb)
+{
+	u64 init_segment_id = atomic64_read(&wb->last_flushed_segment_id) + 1;
+	acquire_new_seg(wb, init_segment_id);
+	cursor_init(wb);
+}
+
+/*
+ * Recover all the cache state from the
+ * persistent devices (non-volatile RAM and SSD).
+ */
+static int recover_cache(struct wb_device *wb)
+{
+	int r = 0;
+
+	r = flush_plogs(wb);
+	if (r) {
+		DMERR("flush_plogs failed");
+		return r;
+	}
+
+	r = replay_log_on_cache(wb);
+	if (r) {
+		DMERR("replay_log_on_cache failed");
+		return r;
+	}
+
+	prepare_first_seg(wb);
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct writeback_segment *alloc_writeback_segment(struct wb_device *wb)
+{
+	u8 i;
+
+	struct writeback_segment *writeback_seg = kmalloc(sizeof(*writeback_seg), GFP_NOIO);
+	if (!writeback_seg)
+		goto bad_writeback_seg;
+
+	writeback_seg->ios = kmalloc(wb->nr_caches_inseg * sizeof(struct writeback_io), GFP_NOIO);
+	if (!writeback_seg->ios)
+		goto bad_ios;
+
+	writeback_seg->buf = kmem_cache_alloc(wb->rambuf_cachep, GFP_NOIO);
+	if (!writeback_seg->buf)
+		goto bad_buf;
+
+	for (i = 0; i < wb->nr_caches_inseg; i++) {
+		struct writeback_io *writeback_io = writeback_seg->ios + i;
+		writeback_io->data = writeback_seg->buf + (i << 12);
+	}
+
+	return writeback_seg;
+
+bad_buf:
+	kfree(writeback_seg->ios);
+bad_ios:
+	kfree(writeback_seg);
+bad_writeback_seg:
+	return NULL;
+}
+
+static void free_writeback_segment(struct wb_device *wb, struct writeback_segment *writeback_seg)
+{
+	kmem_cache_free(wb->rambuf_cachep, writeback_seg->buf);
+	kfree(writeback_seg->ios);
+	kfree(writeback_seg);
+}
+
+/*
+ * Try to allocate new writeback buffer by the @nr_batch size.
+ * On success, it frees the old buffer.
+ *
+ * Bad user may set # of batches that can hardly allocate.
+ * This function is robust in that case.
+ */
+static void free_writeback_ios(struct wb_device *wb)
+{
+	size_t i;
+	for (i = 0; i < wb->nr_cur_batched_writeback; i++)
+		free_writeback_segment(wb, *(wb->writeback_segs + i));
+	kfree(wb->writeback_segs);
+}
+
+/*
+ * Request to allocate data structures to write back @nr_batch segments.
+ * Previous structures are preserved in case of failure.
+ */
+int try_alloc_writeback_ios(struct wb_device *wb, size_t nr_batch)
+{
+	int r = 0;
+	size_t i;
+
+	struct writeback_segment **writeback_segs = kzalloc(
+			nr_batch * sizeof(struct writeback_segment *), GFP_KERNEL);
+	if (!writeback_segs)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_batch; i++) {
+		struct writeback_segment **writeback_seg = writeback_segs + i;
+		*writeback_seg = alloc_writeback_segment(wb);
+		if (!writeback_seg) {
+			int j;
+			for (j = 0; j < i; j++)
+				free_writeback_segment(wb, *(writeback_segs + j));
+			kfree(writeback_segs);
+
+			DMERR("Failed to allocate writeback_segs");
+			return -ENOMEM;
+		}
+	}
+
+	/*
+	 * Free old buffers if exists.
+	 * wb->writeback_segs is firstly NULL under constructor .ctr.
+	 */
+	if (wb->writeback_segs)
+		free_writeback_ios(wb);
+
+	/*
+	 * Swap by new values
+	 */
+	wb->writeback_segs = writeback_segs;
+	wb->nr_cur_batched_writeback = nr_batch;
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+#define CREATE_DAEMON(name) \
+	do { \
+		wb->name##_daemon = kthread_create( \
+				name##_proc, wb,  #name "_daemon"); \
+		if (IS_ERR(wb->name##_daemon)) { \
+			r = PTR_ERR(wb->name##_daemon); \
+			wb->name##_daemon = NULL; \
+			DMERR("couldn't spawn " #name " daemon"); \
+			goto bad_##name##_daemon; \
+		} \
+		wake_up_process(wb->name##_daemon); \
+	} while (0)
+
+/*
+ * Alloc and then setup the initial state of the metadata
+ *
+ * Metadata:
+ * - Segment header array
+ * - Metablocks
+ * - Hash table
+ */
+static int init_metadata(struct wb_device *wb)
+{
+	int r = 0;
+
+	r = init_segment_header_array(wb);
+	if (r) {
+		DMERR("init_segment_header_array failed");
+		goto bad_alloc_segment_header_array;
+	}
+
+	r = ht_empty_init(wb);
+	if (r) {
+		DMERR("ht_empty_init failed");
+		goto bad_alloc_ht;
+	}
+
+	return r;
+
+bad_alloc_ht:
+	free_segment_header_array(wb);
+bad_alloc_segment_header_array:
+	return r;
+}
+
+static void free_metadata(struct wb_device *wb)
+{
+	free_ht(wb);
+	free_segment_header_array(wb);
+}
+
+static int init_writeback_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	size_t nr_batch;
+
+	atomic_set(&wb->writeback_fail_count, 0);
+	atomic_set(&wb->writeback_io_count, 0);
+
+	nr_batch = 1 << (15 - wb->segment_size_order); /* 16MB */
+	wb->nr_max_batched_writeback = nr_batch;
+	if (try_alloc_writeback_ios(wb, nr_batch))
+		return -ENOMEM;
+
+	init_waitqueue_head(&wb->writeback_wait_queue);
+	init_waitqueue_head(&wb->wait_drop_caches);
+	init_waitqueue_head(&wb->writeback_io_wait_queue);
+
+	wb->allow_writeback = false;
+	wb->urge_writeback = false;
+	wb->force_drop = false;
+	CREATE_DAEMON(writeback);
+
+	return r;
+
+bad_writeback_daemon:
+	free_writeback_ios(wb);
+	return r;
+}
+
+static int init_flusher(struct wb_device *wb)
+{
+	int r = 0;
+
+	/*
+	 * Flusher's max_active is set to 1
+	 * we did not see notable performance improvement
+	 * when more than one worker is activated.
+	 * To avoid unexpected failure when more than
+	 * one workers are working (e.g. deadlock)
+	 * We fix max_active to 1.
+	 *
+	 * Tuning the max_active of this wq online
+	 * can be implemented by adding WQ_SYSFS flag
+	 * but for the reason explained above
+	 * this workqueue should not be tunable.
+	 *
+	 * If you want to do so
+	 * must place this in module-level.
+	 * Otherwise name conflict occurs when more than
+	 * one devices are created.
+	 */
+	wb->flusher_wq = alloc_workqueue(
+		"dmwb_flusher", WQ_MEM_RECLAIM, 1);
+	if (!wb->flusher_wq) {
+		DMERR("Failed to allocate flusher");
+		return -ENOMEM;
+	}
+
+	wb->flush_job_pool = mempool_create_kmalloc_pool(
+		wb->nr_rambuf_pool, sizeof(struct flush_job));
+	if (!wb->flush_job_pool) {
+		r = -ENOMEM;
+		DMERR("Failed to allocate flush_job_pool");
+		goto bad_flush_job_pool;
+	}
+
+	init_waitqueue_head(&wb->flush_wait_queue);
+	return r;
+
+bad_flush_job_pool:
+	destroy_workqueue(wb->flusher_wq);
+	return r;
+}
+
+static void init_flush_barrier_work(struct wb_device *wb)
+{
+	bio_list_init(&wb->barrier_ios);
+	INIT_WORK(&wb->flush_barrier_work, flush_barrier_ios);
+}
+
+static int init_writeback_modulator(struct wb_device *wb)
+{
+	int r = 0;
+	/*
+	 * EMC's textbook on storage system teaches us
+	 * storage should keep its load no more than 70%.
+	 */
+	wb->writeback_threshold = 70;
+	wb->enable_writeback_modulator = false;
+	CREATE_DAEMON(modulator);
+	return r;
+
+bad_modulator_daemon:
+	return r;
+}
+
+static int init_recorder_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	wb->update_record_interval = 0;
+	CREATE_DAEMON(recorder);
+	return r;
+
+bad_recorder_daemon:
+	return r;
+}
+
+static int init_sync_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	wb->sync_interval = 0;
+	CREATE_DAEMON(sync);
+	return r;
+
+bad_sync_daemon:
+	return r;
+}
+
+int resume_cache(struct wb_device *wb)
+{
+	int r = 0;
+
+	r = init_devices(wb);
+	if (r)
+		goto bad_devices;
+
+	r = init_metadata(wb);
+	if (r)
+		goto bad_metadata;
+
+	r = init_writeback_daemon(wb);
+	if (r) {
+		DMERR("init_writeback_daemon failed");
+		goto bad_writeback_daemon;
+	}
+
+	r = recover_cache(wb);
+	if (r) {
+		DMERR("recover_cache failed");
+		goto bad_recover;
+	}
+
+	r = init_flusher(wb);
+	if (r) {
+		DMERR("init_flusher failed");
+		goto bad_flusher;
+	}
+
+	init_flush_barrier_work(wb);
+
+	r = init_writeback_modulator(wb);
+	if (r) {
+		DMERR("init_writeback_modulator failed");
+		goto bad_writeback_modulator;
+	}
+
+	r = init_recorder_daemon(wb);
+	if (r) {
+		DMERR("init_recorder_daemon failed");
+		goto bad_recorder_daemon;
+	}
+
+	r = init_sync_daemon(wb);
+	if (r) {
+		DMERR("init_sync_daemon failed");
+		goto bad_sync_daemon;
+	}
+
+	return r;
+
+bad_sync_daemon:
+	kthread_stop(wb->recorder_daemon);
+bad_recorder_daemon:
+	kthread_stop(wb->modulator_daemon);
+bad_writeback_modulator:
+	cancel_work_sync(&wb->flush_barrier_work);
+
+	mempool_destroy(wb->flush_job_pool);
+	destroy_workqueue(wb->flusher_wq);
+bad_flusher:
+bad_recover:
+	kthread_stop(wb->writeback_daemon);
+	free_writeback_ios(wb);
+bad_writeback_daemon:
+	free_metadata(wb);
+bad_metadata:
+	free_devices(wb);
+bad_devices:
+	return r;
+}
+
+void free_cache(struct wb_device *wb)
+{
+	/*
+	 * kthread_stop() wakes up the thread.
+	 * We don't need to wake them up in our code.
+	 */
+	kthread_stop(wb->sync_daemon);
+	kthread_stop(wb->recorder_daemon);
+	kthread_stop(wb->modulator_daemon);
+
+	cancel_work_sync(&wb->flush_barrier_work);
+
+	mempool_destroy(wb->flush_job_pool);
+	destroy_workqueue(wb->flusher_wq);
+
+	kthread_stop(wb->writeback_daemon);
+	free_writeback_ios(wb);
+
+	free_metadata(wb);
+
+	free_devices(wb);
+}
diff --git a/drivers/staging/writeboost/dm-writeboost-metadata.h b/drivers/staging/writeboost/dm-writeboost-metadata.h
new file mode 100644
index 0000000..14eb4ce
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost-metadata.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_METADATA_H
+#define DM_WRITEBOOST_METADATA_H
+
+/*----------------------------------------------------------------*/
+
+struct segment_header *
+get_segment_header_by_id(struct wb_device *, u64 segment_id);
+sector_t calc_mb_start_sector(struct wb_device *, struct segment_header *,
+			      u32 mb_idx);
+u8 mb_idx_inseg(struct wb_device *, u32 mb_idx);
+struct segment_header *mb_to_seg(struct wb_device *, struct metablock *);
+bool is_on_buffer(struct wb_device *, u32 mb_idx);
+
+/*----------------------------------------------------------------*/
+
+struct lookup_key {
+	sector_t sector;
+};
+
+struct ht_head;
+struct ht_head *ht_get_head(struct wb_device *, struct lookup_key *);
+struct metablock *ht_lookup(struct wb_device *,
+			    struct ht_head *, struct lookup_key *);
+void ht_register(struct wb_device *, struct ht_head *,
+		 struct metablock *, struct lookup_key *);
+void ht_del(struct wb_device *, struct metablock *);
+void discard_caches_inseg(struct wb_device *, struct segment_header *);
+
+/*----------------------------------------------------------------*/
+
+void prepare_segment_header_device(void *rambuffer, struct wb_device *,
+				   struct segment_header *src);
+u32 calc_checksum(void *rambuffer, u8 length);
+
+/*----------------------------------------------------------------*/
+
+int try_alloc_writeback_ios(struct wb_device *, size_t nr_batch);
+
+/*----------------------------------------------------------------*/
+
+int resume_cache(struct wb_device *);
+void free_cache(struct wb_device *);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/staging/writeboost/dm-writeboost-target.c b/drivers/staging/writeboost/dm-writeboost-target.c
new file mode 100644
index 0000000..01349a5
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost-target.c
@@ -0,0 +1,1770 @@
+/*
+ * Writeboost
+ * Log-structured Caching for Linux
+ *
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+/*----------------------------------------------------------------*/
+
+void do_check_buffer_alignment(void *buf, const char *name, const char *caller)
+{
+	unsigned long addr = (unsigned long) buf;
+
+	if (!IS_ALIGNED(addr, 1 << SECTOR_SHIFT)) {
+		DMCRIT("@%s in %s is not sector-aligned. I/O buffer must be sector-aligned.", name, caller);
+		BUG();
+	}
+}
+
+struct safe_io {
+	struct work_struct work;
+	int err;
+	unsigned long err_bits;
+	struct dm_io_request *io_req;
+	unsigned num_regions;
+	struct dm_io_region *regions;
+};
+
+static void safe_io_proc(struct work_struct *work)
+{
+	struct safe_io *io = container_of(work, struct safe_io, work);
+	io->err_bits = 0;
+	io->err = dm_io(io->io_req, io->num_regions, io->regions, &io->err_bits);
+}
+
+int dm_safe_io_internal(struct wb_device *wb, struct dm_io_request *io_req,
+			unsigned num_regions, struct dm_io_region *regions,
+			unsigned long *err_bits, bool thread, const char *caller)
+{
+	int err = 0;
+
+	if (thread) {
+		struct safe_io io = {
+			.io_req = io_req,
+			.regions = regions,
+			.num_regions = num_regions,
+		};
+
+		INIT_WORK_ONSTACK(&io.work, safe_io_proc);
+		queue_work(wb->io_wq, &io.work);
+		flush_work(&io.work);
+		destroy_work_on_stack(&io.work); /* Pair with INIT_WORK_ONSTACK */
+
+		err = io.err;
+		if (err_bits)
+			*err_bits = io.err_bits;
+	} else {
+		err = dm_io(io_req, num_regions, regions, err_bits);
+	}
+
+	/*
+	 * err_bits can be NULL.
+	 */
+	if (err || (err_bits && *err_bits)) {
+		char buf[BDEVNAME_SIZE];
+		dev_t dev = regions->bdev->bd_dev;
+
+		unsigned long eb;
+		if (!err_bits)
+			eb = (~(unsigned long)0);
+		else
+			eb = *err_bits;
+
+		format_dev_t(buf, dev);
+		DMERR("%s() I/O error(%d), bits(%lu), dev(%s), sector(%llu), rw(%d)",
+		      caller, err, eb,
+		      buf, (unsigned long long) regions->sector, io_req->bi_rw);
+	}
+
+	return err;
+}
+
+sector_t dm_devsize(struct dm_dev *dev)
+{
+	return i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
+}
+
+/*----------------------------------------------------------------*/
+
+static void bio_remap(struct bio *bio, struct dm_dev *dev, sector_t sector)
+{
+	bio->bi_bdev = dev->bdev;
+	bio->bi_iter.bi_sector = sector;
+}
+
+static u8 do_io_offset(sector_t sector)
+{
+	u32 tmp32;
+	div_u64_rem(sector, 1 << 3, &tmp32);
+	return tmp32;
+}
+
+static u8 io_offset(struct bio *bio)
+{
+	return do_io_offset(bio->bi_iter.bi_sector);
+}
+
+static bool io_fullsize(struct bio *bio)
+{
+	return bio_sectors(bio) == (1 << 3);
+}
+
+static bool io_write(struct bio *bio)
+{
+	return bio_data_dir(bio) == WRITE;
+}
+
+/*
+ * We use 4KB alignment address of original request the as the lookup key.
+ */
+static sector_t calc_cache_alignment(sector_t bio_sector)
+{
+	return div_u64(bio_sector, 1 << 3) * (1 << 3);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Wake up the processes on the wq if the wq is active.
+ * (At least a process is waiting on it)
+ * This function should only used for wq that is rarely active.
+ * Otherwise ordinary wake_up() should be used instead.
+ */
+static void wake_up_active_wq(wait_queue_head_t *wq)
+{
+	if (unlikely(waitqueue_active(wq)))
+		wake_up(wq);
+}
+
+static void plog_write_endio(unsigned long error, void *context)
+{
+	struct write_job *job = context;
+	struct wb_device *wb = job->wb;
+
+	if (error)
+		mark_dead(wb);
+
+	if (atomic_dec_and_test(&wb->nr_inflight_plog_writes))
+		wake_up_active_wq(&wb->plog_wait_queue);
+
+	mempool_free(job->plog_buf, wb->plog_buf_pool);
+	mempool_free(job, wb->write_job_pool);
+}
+
+static void do_append_plog_t1(struct wb_device *wb, struct bio *bio,
+			      struct write_job *job)
+{
+	int r;
+	struct dm_io_request io_req = {
+		.client = wb->io_client,
+		.bi_rw = WRITE,
+		.notify.fn = plog_write_endio,
+		.notify.context = job,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = job->plog_buf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->plog_dev_t1->bdev,
+		.sector = wb->plog_seg_start_sector + job->plog_head,
+		.count = 1 + bio_sectors(bio),
+	};
+
+	/*
+	 * We need to submit this plog write in background otherwise
+	 * causes serious deadlock. Although this is not a sync write
+	 * the process is waiting for all async plog writes complete.
+	 * Thus, essentially sync.
+	 */
+	maybe_IO(dm_safe_io(&io_req, 1, &region, NULL, true));
+	if (r)
+		plog_write_endio(0, job);
+}
+
+static void do_append_plog(struct wb_device *wb, struct bio *bio,
+			   struct write_job *job)
+{
+	u32 cksum = crc32c(WB_CKSUM_SEED, bio_data(bio), bio->bi_iter.bi_size);
+	struct plog_meta_device meta = {
+		.id = cpu_to_le64(wb->current_seg->id),
+		.sector = cpu_to_le64((u64)bio->bi_iter.bi_sector),
+		.checksum = cpu_to_le32(cksum),
+		.idx = mb_idx_inseg(wb, job->mb->idx),
+		.len = bio_sectors(bio),
+	};
+	memcpy(job->plog_buf, &meta, 512);
+	memcpy(job->plog_buf + 512, bio_data(bio), bio->bi_iter.bi_size);
+
+	switch (wb->type) {
+	case 1:
+		do_append_plog_t1(wb, bio, job);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Submit sync flush request to @dev
+ */
+static void submit_flush_request(struct wb_device *wb, struct dm_dev *dev, bool thread)
+{
+	int r = 0;
+	struct dm_io_request io_req = {
+		.bi_rw = WRITE_FLUSH,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = NULL,
+		.client = wb->io_client,
+	};
+	struct dm_io_region io_region = {
+		.bdev = dev->bdev,
+		.sector = 0,
+		.count = 0,
+	};
+	maybe_IO(dm_safe_io(&io_req, 1, &io_region, NULL, thread));
+}
+
+static void wait_plog_writes_complete(struct wb_device *wb)
+{
+	wait_event(wb->plog_wait_queue,
+		   !atomic_read(&wb->nr_inflight_plog_writes));
+}
+
+/*
+ * Wait for all the plog writes complete
+ * and then make all the predecessor writes persistent.
+ */
+static void barrier_plog_writes(struct wb_device *wb)
+{
+	wait_plog_writes_complete(wb);
+
+	/*
+	 * TODO
+	 * Can be optimized by avoid unnecessary flush requests.
+	 * If we have flushed before while holding the current segment
+	 * (i.e. we flushed the segments before the current segment)
+	 * We need not to flush them any more.
+	 * Adding some flag to segment_header can be thought however,
+	 * immature optimiazation is always harmful. So, did not.
+	 */
+	submit_flush_request(wb, wb->cache_dev, true);
+	switch (wb->type) {
+	case 1:
+		submit_flush_request(wb, wb->plog_dev_t1, true);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Submit a serialized plog write.
+ * If the bio is REQ_FUA all the predeessor writes are all persistent
+ *
+ * @job and the held resources should be freed under this function.
+ */
+static void append_plog(struct wb_device *wb, struct bio *bio,
+			struct write_job *job)
+{
+	if (!wb->type) {
+		/*
+		 * Without plog no endio frees the job
+		 * so we need to free it.
+		 */
+		mempool_free(job, wb->write_job_pool);
+		return;
+	}
+
+	/*
+	 * For type 1, resources are freed in endio.
+	 */
+	do_append_plog(wb, bio, job);
+
+	if (wb->type && (bio->bi_rw & REQ_FUA))
+		barrier_plog_writes(wb);
+}
+
+/*
+ * Rebuild a RAM buffer (metadata and data) from a plog.
+ * All valid logs are of id "log_id".
+ */
+void rebuild_rambuf(void *rambuffer, void *plog_seg_buf, u64 log_id)
+{
+	struct segment_header_device *seg = rambuffer;
+	struct metablock_device *mb;
+
+	void *cur_plog_buf = plog_seg_buf;
+	while (true) {
+		u8 i;
+		u32 actual, expected;
+		sector_t sector_cpu;
+		size_t bytes;
+		void *addr;
+
+		struct plog_meta_device meta;
+		memcpy(&meta, cur_plog_buf, 512);
+		sector_cpu = le64_to_cpu(meta.sector);
+
+		actual = crc32c(WB_CKSUM_SEED, cur_plog_buf + 512, meta.len << SECTOR_SHIFT);
+		expected = le32_to_cpu(meta.checksum);
+
+		if (actual != expected)
+			break;
+
+		if (le64_to_cpu(meta.id) != log_id)
+			break;
+
+		/* Update header data */
+		seg->id = meta.id;
+		if ((meta.idx + 1) > seg->length)
+			seg->length = meta.idx + 1;
+
+		/* Metadata */
+		mb = seg->mbarr + meta.idx;
+		mb->sector = cpu_to_le64((u64)calc_cache_alignment(sector_cpu));
+		for (i = 0; i < meta.len; i++)
+			mb->dirty_bits |= (1 << (do_io_offset(sector_cpu) + i));
+
+		/* Data */
+		bytes = do_io_offset(sector_cpu) << SECTOR_SHIFT;
+		addr = rambuffer + ((1 + meta.idx) * (1 << 12) + bytes);
+		memcpy(addr, cur_plog_buf + 512, meta.len << SECTOR_SHIFT);
+
+		/* Shift to the next "possible" plog */
+		cur_plog_buf += ((1 + meta.len) << SECTOR_SHIFT);
+	}
+
+	/* Checksum */
+	seg->checksum = cpu_to_le32(calc_checksum(rambuffer, seg->length));
+}
+
+/*
+ * Advance the current head for newer logs.
+ * Returns the "current" head as the address for current appending.
+ * After returned, nr_inflight_plog_writes increments.
+ */
+static sector_t advance_plog_head(struct wb_device *wb, struct bio *bio)
+{
+	sector_t old;
+	if (!wb->type)
+		return 0;
+
+	old = wb->alloc_plog_head;
+	wb->alloc_plog_head += (1 + bio_sectors(bio));
+	atomic_inc(&wb->nr_inflight_plog_writes);
+	return old;
+}
+
+static void acquire_new_plog_seg(struct wb_device *wb, u64 id)
+{
+	u32 tmp32;
+
+	if (!wb->type)
+		return;
+
+	wait_for_flushing(wb, SUB_ID(id, wb->nr_plog_segs));
+
+	wait_plog_writes_complete(wb);
+
+	div_u64_rem(id - 1, wb->nr_plog_segs, &tmp32);
+	wb->plog_seg_start_sector = wb->plog_seg_size * tmp32;
+	wb->alloc_plog_head = 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static u8 count_dirty_caches_remained(struct segment_header *seg)
+{
+	u8 i, count = 0;
+	struct metablock *mb;
+	for (i = 0; i < seg->length; i++) {
+		mb = seg->mb_array + i;
+		if (mb->dirty_bits)
+			count++;
+	}
+	return count;
+}
+
+/*
+ * Prepare the kmalloc-ed RAM buffer for segment write.
+ *
+ * dm_io routine requires RAM buffer for its I/O buffer.
+ * Even if we uses non-volatile RAM we have to copy the
+ * data to the volatile buffer when we come to submit I/O.
+ */
+static void prepare_rambuffer(struct rambuffer *rambuf,
+			      struct wb_device *wb,
+			      struct segment_header *seg)
+{
+	prepare_segment_header_device(rambuf->data, wb, seg);
+}
+
+static void init_rambuffer(struct wb_device *wb)
+{
+	memset(wb->current_rambuf->data, 0, 1 << 12);
+}
+
+/*
+ * Acquire a new RAM buffer for the new segment.
+ */
+static void acquire_new_rambuffer(struct wb_device *wb, u64 id)
+{
+	struct rambuffer *next_rambuf;
+	u32 tmp32;
+
+	wait_for_flushing(wb, SUB_ID(id, wb->nr_rambuf_pool));
+
+	div_u64_rem(id - 1, wb->nr_rambuf_pool, &tmp32);
+	next_rambuf = wb->rambuf_pool + tmp32;
+
+	wb->current_rambuf = next_rambuf;
+
+	init_rambuffer(wb);
+}
+
+/*
+ * Acquire the new segment and RAM buffer for the following writes.
+ * Gurantees all dirty caches in the segments are written back and
+ * all metablocks in it are invalidated (Linked to null head).
+ */
+void acquire_new_seg(struct wb_device *wb, u64 id)
+{
+	struct segment_header *new_seg = get_segment_header_by_id(wb, id);
+
+	/*
+	 * We wait for all requests to the new segment is consumed.
+	 * Mutex taken gurantees that no new I/O to this segment is coming in.
+	 */
+	wait_event(wb->inflight_ios_wq,
+		!atomic_read(&new_seg->nr_inflight_ios));
+
+	wait_for_writeback(wb, SUB_ID(id, wb->nr_segments));
+	if (count_dirty_caches_remained(new_seg)) {
+		DMERR("%u dirty caches remained. id:%llu",
+		      count_dirty_caches_remained(new_seg), id);
+		BUG();
+	}
+	discard_caches_inseg(wb, new_seg);
+
+	/*
+	 * We must not set new id to the new segment before
+	 * all wait_* events are done since they uses those id for waiting.
+	 */
+	new_seg->id = id;
+	wb->current_seg = new_seg;
+
+	acquire_new_rambuffer(wb, id);
+	acquire_new_plog_seg(wb, id);
+}
+
+static void prepare_new_seg(struct wb_device *wb)
+{
+	u64 next_id = wb->current_seg->id + 1;
+	acquire_new_seg(wb, next_id);
+	cursor_init(wb);
+}
+
+/*----------------------------------------------------------------*/
+
+static void copy_barrier_requests(struct flush_job *job, struct wb_device *wb)
+{
+	bio_list_init(&job->barrier_ios);
+	bio_list_merge(&job->barrier_ios, &wb->barrier_ios);
+	bio_list_init(&wb->barrier_ios);
+}
+
+static void init_flush_job(struct flush_job *job, struct wb_device *wb)
+{
+	job->wb = wb;
+	job->seg = wb->current_seg;
+	job->rambuf = wb->current_rambuf;
+
+	copy_barrier_requests(job, wb);
+}
+
+static void queue_flush_job(struct wb_device *wb)
+{
+	struct flush_job *job;
+
+	wait_event(wb->inflight_ios_wq,
+		!atomic_read(&wb->current_seg->nr_inflight_ios));
+
+	prepare_rambuffer(wb->current_rambuf, wb, wb->current_seg);
+
+	job = mempool_alloc(wb->flush_job_pool, GFP_NOIO);
+	init_flush_job(job, wb);
+	INIT_WORK(&job->work, flush_proc);
+	queue_work(wb->flusher_wq, &job->work);
+}
+
+static void queue_current_buffer(struct wb_device *wb)
+{
+	queue_flush_job(wb);
+	prepare_new_seg(wb);
+}
+
+void cursor_init(struct wb_device *wb)
+{
+	wb->cursor = wb->current_seg->start_idx;
+	wb->current_seg->length = 0;
+}
+
+/*
+ * Flush out all the transient data at a moment but _NOT_ persistently.
+ * Clean up the writes before termination is an example of the use case.
+ */
+void flush_current_buffer(struct wb_device *wb)
+{
+	struct segment_header *old_seg;
+
+	mutex_lock(&wb->io_lock);
+	old_seg = wb->current_seg;
+
+	queue_current_buffer(wb);
+
+	cursor_init(wb);
+	mutex_unlock(&wb->io_lock);
+
+	wait_for_flushing(wb, old_seg->id);
+}
+
+/*----------------------------------------------------------------*/
+
+static void inc_stat(struct wb_device *wb,
+		     int rw, bool found, bool on_buffer, bool fullsize)
+{
+	atomic64_t *v;
+
+	int i = 0;
+	if (rw)
+		i |= (1 << STAT_WRITE);
+	if (found)
+		i |= (1 << STAT_HIT);
+	if (on_buffer)
+		i |= (1 << STAT_ON_BUFFER);
+	if (fullsize)
+		i |= (1 << STAT_FULLSIZE);
+
+	v = &wb->stat[i];
+	atomic64_inc(v);
+}
+
+static void clear_stat(struct wb_device *wb)
+{
+	size_t i;
+	for (i = 0; i < STATLEN; i++) {
+		atomic64_t *v = &wb->stat[i];
+		atomic64_set(v, 0);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
+void inc_nr_dirty_caches(struct wb_device *wb)
+{
+	BUG_ON(!wb);
+	atomic64_inc(&wb->nr_dirty_caches);
+}
+
+static void dec_nr_dirty_caches(struct wb_device *wb)
+{
+	BUG_ON(!wb);
+	if (atomic64_dec_and_test(&wb->nr_dirty_caches))
+		wake_up_interruptible(&wb->wait_drop_caches);
+}
+
+static void increase_dirtiness(struct wb_device *wb, struct segment_header *seg,
+			       struct metablock *mb, struct bio *bio)
+{
+	unsigned long flags;
+
+	bool was_clean = false;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	if (!mb->dirty_bits) {
+		seg->length++;
+		BUG_ON(seg->length > wb->nr_caches_inseg);
+		was_clean = true;
+	}
+	if (likely(io_fullsize(bio))) {
+		mb->dirty_bits = 255;
+	} else {
+		u8 i;
+		u8 acc_bits = 0;
+		/* TODO i = 0; ... */
+		for (i = io_offset(bio); i < (io_offset(bio) + bio_sectors(bio)); i++)
+			acc_bits += (1 << i);
+
+		mb->dirty_bits |= acc_bits;
+	}
+	BUG_ON(!bio_sectors(bio));
+	BUG_ON(!mb->dirty_bits);
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	if (was_clean)
+		inc_nr_dirty_caches(wb);
+}
+
+/*
+ * Drop the dirtiness of the on-memory metablock to 0.
+ * This only means the data of the metablock will never be written back and
+ * omitting this only results in double writeback which is only a matter
+ * of performance.
+ */
+void cleanup_mb_if_dirty(struct wb_device *wb, struct segment_header *seg,
+			 struct metablock *mb)
+{
+	unsigned long flags;
+
+	bool was_dirty = false;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	if (mb->dirty_bits) {
+		mb->dirty_bits = 0;
+		was_dirty = true;
+	}
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	if (was_dirty)
+		dec_nr_dirty_caches(wb);
+}
+
+/*
+ * Read the dirtiness of a metablock at the moment.
+ *
+ * In fact, I don't know if we should have the read statement surrounded
+ * by spinlock. Why I do this is that I worry about reading the
+ * intermediate value (neither the value of before-write nor after-write).
+ * Intel CPU guarantees it but other CPU may not.
+ * If any other CPU guarantees it we can remove the spinlock held.
+ */
+u8 read_mb_dirtiness(struct wb_device *wb, struct segment_header *seg,
+		     struct metablock *mb)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	val = mb->dirty_bits;
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	return val;
+}
+
+/*----------------------------------------------------------------*/
+
+struct writeback_mb_context {
+	struct wb_device *wb;
+	atomic_t count;
+	int err;
+};
+
+static void writeback_mb_complete(int read_err, unsigned long write_err, void *__context)
+{
+	struct writeback_mb_context *context = __context;
+
+	if (read_err || write_err)
+		context->err = 1;
+
+	if (atomic_dec_and_test(&context->count))
+		wake_up_active_wq(&context->wb->writeback_mb_wait_queue);
+}
+
+/*
+ * Write back caches in cache device (SSD) to the backnig device (HDD).
+ * We don't need to make the data written back persistent because this segment will be
+ * reused only after writeback daemon writes back this segment.
+ */
+static void writeback_mb(struct wb_device *wb, struct segment_header *seg,
+			 struct metablock *mb, u8 dirty_bits, bool thread)
+{
+	int r = 0;
+
+	struct writeback_mb_context context;
+	context.wb = wb;
+	context.err = 0;
+
+	if (!dirty_bits)
+		return;
+
+	if (dirty_bits == 255) {
+		struct dm_io_region src, dest;
+
+		atomic_set(&context.count, 1);
+
+		src = (struct dm_io_region) {
+			.bdev = wb->cache_dev->bdev,
+			.sector = calc_mb_start_sector(wb, seg, mb->idx),
+			.count = (1 << 3),
+		};
+		dest = (struct dm_io_region) {
+			.bdev = wb->backing_dev->bdev,
+			.sector = mb->sector,
+			.count = (1 << 3),
+		};
+		maybe_IO(dm_kcopyd_copy(wb->copier, &src, 1, &dest, 0, writeback_mb_complete, &context));
+		if (r)
+			writeback_mb_complete(0, 0, &context);
+	} else {
+		u8 i;
+
+		u8 count = 0;
+		for (i = 0; i < 8; i++)
+			if (dirty_bits & (1 << i))
+				count++;
+
+		atomic_set(&context.count, count);
+
+		for (i = 0; i < 8; i++) {
+			struct dm_io_region src, dest;
+
+			if (!(dirty_bits & (1 << i)))
+				continue;
+
+			src = (struct dm_io_region) {
+				.bdev = wb->cache_dev->bdev,
+				.sector = calc_mb_start_sector(wb, seg, mb->idx) + i,
+				.count = 1,
+			};
+			dest = (struct dm_io_region) {
+				.bdev = wb->backing_dev->bdev,
+				.sector = mb->sector + i,
+				.count = 1,
+			};
+			maybe_IO(dm_kcopyd_copy(wb->copier, &src, 1, &dest, 0, writeback_mb_complete, &context));
+			if (r)
+				writeback_mb_complete(0, 0, &context);
+		}
+	}
+
+	wait_event(wb->writeback_mb_wait_queue, !atomic_read(&context.count));
+	if (context.err)
+		mark_dead(wb);
+}
+
+/*
+ * Write back the caches on the RAM buffer to backing device.
+ * Calling this function is really rare so the code is not optimal.
+ * There is no need to write them back with FUA flag
+ * because the caches are not flushed yet and thus not persistent.
+ */
+static void writeback_buffered_mb(struct wb_device *wb, struct metablock *mb, u8 dirty_bits)
+{
+	int r = 0;
+
+	sector_t offset = ((mb_idx_inseg(wb, mb->idx) + 1) << 3);
+	void *buf = mempool_alloc(wb->buf_1_pool, GFP_NOIO);
+
+	u8 i;
+	for (i = 0; i < 8; i++) {
+		struct dm_io_request io_req;
+		struct dm_io_region region;
+
+		void *src;
+		sector_t dest;
+
+		if (!(dirty_bits & (1 << i)))
+			continue;
+
+		src = wb->current_rambuf->data + ((offset + i) << SECTOR_SHIFT);
+		dest = mb->sector + i;
+
+		memcpy(buf, src, 1 << SECTOR_SHIFT);
+		io_req = (struct dm_io_request) {
+			.client = wb->io_client,
+			.bi_rw = WRITE,
+			.notify.fn = NULL,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+		region = (struct dm_io_region) {
+			.bdev = wb->backing_dev->bdev,
+			.sector = dest,
+			.count = 1,
+		};
+		maybe_IO(dm_safe_io(&io_req, 1, &region, NULL, true));
+	}
+	mempool_free(buf, wb->buf_1_pool);
+}
+
+void invalidate_previous_cache(struct wb_device *wb, struct segment_header *seg,
+			       struct metablock *old_mb, bool overwrite_fullsize)
+{
+	u8 dirty_bits = read_mb_dirtiness(wb, seg, old_mb);
+
+	/*
+	 * First clean up the previous cache and write back the cache if needed.
+	 */
+	bool needs_cleanup_prev_cache =
+		!overwrite_fullsize || !(dirty_bits == 255);
+
+	/*
+	 * Writeback works in background and may have cleaned up the metablock.
+	 * If the metablock is clean we need not to write back.
+	 */
+	if (!dirty_bits)
+		needs_cleanup_prev_cache = false;
+
+	if (overwrite_fullsize)
+		needs_cleanup_prev_cache = false;
+
+	if (unlikely(needs_cleanup_prev_cache)) {
+		wait_for_flushing(wb, seg->id);
+		writeback_mb(wb, seg, old_mb, dirty_bits, true);
+	}
+
+	cleanup_mb_if_dirty(wb, seg, old_mb);
+
+	ht_del(wb, old_mb);
+}
+
+/*----------------------------------------------------------------*/
+
+static void write_on_rambuffer(struct wb_device *wb, struct bio *bio,
+			       struct write_job *job)
+{
+	sector_t start_sector = ((mb_idx_inseg(wb, job->mb->idx) + 1) << 3) +
+				io_offset(bio);
+	size_t start_byte = start_sector << SECTOR_SHIFT;
+	void *data = bio_data(bio);
+
+	/*
+	 * Write data block to the volatile RAM buffer.
+	 */
+	memcpy(wb->current_rambuf->data + start_byte, data, bio->bi_iter.bi_size);
+}
+
+/*
+ * Advance the cursor and return the old cursor.
+ * After returned, nr_inflight_ios is incremented
+ * to wait for this write to complete.
+ */
+static u32 advance_cursor(struct wb_device *wb)
+{
+	u32 old;
+	/*
+	 * If cursor is out of boundary
+	 * we put it back to the origin (i.e. log rotate)
+	 */
+	if (wb->cursor == wb->nr_caches)
+		wb->cursor = 0;
+	old = wb->cursor;
+	wb->cursor++;
+	atomic_inc(&wb->current_seg->nr_inflight_ios);
+	return old;
+}
+
+static bool needs_queue_seg(struct wb_device *wb, struct bio *bio)
+{
+	bool plog_seg_no_space = false, rambuf_no_space = false;
+
+	/*
+	 * If there is no more space for appending new log
+	 * it's time to request new plog.
+	 */
+	if (wb->type)
+		plog_seg_no_space = (wb->alloc_plog_head + 1 + bio_sectors(bio)) > wb->plog_seg_size;
+
+	rambuf_no_space = !mb_idx_inseg(wb, wb->cursor);
+
+	return plog_seg_no_space || rambuf_no_space;
+}
+
+/*
+ * queue_current_buffer if the RAM buffer or plog can't make space any more.
+ */
+static void might_queue_current_buffer(struct wb_device *wb, struct bio *bio)
+{
+	if (bio_data_dir(bio) == READ)
+		return;
+
+	if (needs_queue_seg(wb, bio))
+		queue_current_buffer(wb);
+}
+
+/*
+ * Process bio with REQ_DISCARD
+ *
+ * We only discard sectors on only the backing store because blocks on
+ * cache device are unlikely to be discarded.
+ * Discarding blocks is likely to be operated long after writing;
+ * the block is likely to be written back before that.
+ *
+ * Moreover, it is very hard to implement discarding cache blocks.
+ */
+static int process_discard_bio(struct wb_device *wb, struct bio *bio)
+{
+	bio_remap(bio, wb->backing_dev, bio->bi_iter.bi_sector);
+	return DM_MAPIO_REMAPPED;
+}
+
+/*
+ * Process bio with REQ_FLUSH
+ */
+static int process_flush_bio(struct wb_device *wb, struct bio *bio)
+{
+	/*
+	 * In device-mapper bio with REQ_FLUSH is for sure to have not data.
+	 */
+	BUG_ON(bio->bi_iter.bi_size);
+
+	if (!wb->type) {
+		queue_barrier_io(wb, bio);
+	} else {
+		barrier_plog_writes(wb);
+		if (is_live(wb))
+			bio_endio(bio, 0);
+		else
+			bio_endio(bio, -EIO);
+	}
+	return DM_MAPIO_SUBMITTED;
+}
+
+struct lookup_result {
+	struct ht_head *head; /* Lookup head used */
+	struct lookup_key key; /* Lookup key used */
+
+	struct segment_header *found_seg;
+	struct metablock *found_mb;
+
+	bool found; /* Cache hit? */
+	bool on_buffer; /* Is the metablock found on the RAM buffer? */
+};
+
+/*
+ * Lookup a bio relevant cache data.
+ * In cache hit case nr_inflight_ios is incremented
+ * to protect the found segment by the refcount.
+ */
+static void cache_lookup(struct wb_device *wb, struct bio *bio,
+			 struct lookup_result *res)
+{
+	res->key = (struct lookup_key) {
+		.sector = calc_cache_alignment(bio->bi_iter.bi_sector),
+	};
+	res->head = ht_get_head(wb, &res->key);
+
+	res->found_mb = ht_lookup(wb, res->head, &res->key);
+	if (res->found_mb) {
+		res->found_seg = mb_to_seg(wb, res->found_mb);
+		atomic_inc(&res->found_seg->nr_inflight_ios);
+	}
+
+	res->found = (res->found_mb != NULL);
+
+	res->on_buffer = false;
+	if (res->found)
+		res->on_buffer = is_on_buffer(wb, res->found_mb->idx);
+
+	inc_stat(wb, io_write(bio), res->found, res->on_buffer, io_fullsize(bio));
+}
+
+/*
+ * Prepare new write position because we don't have cache block to overwrite.
+ */
+static void prepare_new_pos(struct wb_device *wb, struct bio *bio,
+			    struct lookup_result *res,
+			    struct write_job *pos)
+{
+	pos->plog_head = advance_plog_head(wb, bio);
+	pos->mb = wb->current_seg->mb_array + mb_idx_inseg(wb, advance_cursor(wb));
+	BUG_ON(pos->mb->dirty_bits);
+
+	ht_register(wb, res->head, pos->mb, &res->key);
+}
+
+static void dec_inflight_ios(struct wb_device *wb, struct segment_header *seg)
+{
+	if (atomic_dec_and_test(&seg->nr_inflight_ios))
+		wake_up_active_wq(&wb->inflight_ios_wq);
+}
+
+/*
+ * Decide where to write the data according to the result of cache lookup.
+ * After returned, refcounts (in_flight_ios and in_flight_plog_writes)
+ * are incremented.
+ */
+static void prepare_write_pos(struct wb_device *wb, struct bio *bio,
+			      struct write_job *pos)
+{
+	struct lookup_result res;
+
+	mutex_lock(&wb->io_lock);
+
+	/*
+	 * For design clarity, we insert this function here right after mutex is taken.
+	 * Making the state valid before anything else is always a good practice in the
+	 * in programming.
+	 */
+	might_queue_current_buffer(wb, bio);
+
+	cache_lookup(wb, bio, &res);
+
+	if (res.found) {
+		if (unlikely(res.on_buffer)) {
+			/*
+			 * Overwrite on the buffer
+			 */
+			pos->plog_head = advance_plog_head(wb, bio);
+			pos->mb = res.found_mb;
+			mutex_unlock(&wb->io_lock);
+			return;
+		} else {
+			/*
+			 * Cache hit on the cache device.
+			 * Since we will write new dirty data to the buffer
+			 * we need to invalidate the existing thus hit cache block
+			 * beforehand.
+			 */
+			invalidate_previous_cache(wb, res.found_seg, res.found_mb,
+						  io_fullsize(bio));
+			dec_inflight_ios(wb, res.found_seg);
+		}
+	}
+
+	prepare_new_pos(wb, bio, &res, pos);
+
+	mutex_unlock(&wb->io_lock);
+}
+
+/*
+ * Write bio data to RAM buffer and plog (if available).
+ */
+static int process_write_job(struct wb_device *wb, struct bio *bio,
+			     struct write_job *job)
+{
+	increase_dirtiness(wb, wb->current_seg, job->mb, bio);
+
+	write_on_rambuffer(wb, bio, job);
+
+	append_plog(wb, bio, job);
+
+	dec_inflight_ios(wb, wb->current_seg);
+
+	/*
+	 * Deferred ACK for FUA request
+	 *
+	 * Bio with REQ_FUA flag has data.
+	 * So, we must run through the path for usual bio.
+	 * And the data is now stored in the RAM buffer.
+	 */
+	if (!wb->type && (bio->bi_rw & REQ_FUA)) {
+		queue_barrier_io(wb, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	if (is_live(wb))
+		bio_endio(bio, 0);
+	else
+		bio_endio(bio, -EIO);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static struct write_job *alloc_write_job(struct wb_device *wb)
+{
+	struct write_job *job = mempool_alloc(wb->write_job_pool, GFP_NOIO);
+	job->wb = wb;
+
+	/*
+	 * Without plog, plog_buf need not to be allocated.
+	 */
+	if (wb->type)
+		job->plog_buf = mempool_alloc(wb->plog_buf_pool, GFP_NOIO);
+
+	return job;
+}
+
+/*
+ * (Locking) Dirtiness
+ * A cache data is placed either on RAM buffer or SSD if it was flushed.
+ * To make locking easy, simplify the rule for the dirtiness of a cache data.
+ *
+ * 1) If the data is on the RAM buffer, the dirtiness (dirty_bits of metablock)
+ *    only "increases".
+ *    The justification for this design is that
+ *    the cache on the RAM buffer is seldom written back.
+ * 2) If the data is, on the other hand, on the SSD after flushed the dirtiness
+ *    only "decreases".
+ *
+ * This simple rule can remove the possibility of dirtiness fluctuating
+ * while on the RAM buffer. Thus, simplies locking design.
+ *
+ * --------------------------------------------------------------------
+ * (Locking) Refcount
+ * Writeboost has two refcount
+ * (Only one if not using plog)
+ *
+ * The basic common idea is
+ * 1) Increment the refcount inside lock
+ * 2) Wait for decrement outside the lock
+ *
+ * process_write:
+ *   prepare_write_pos:
+ *     mutex_lock (to serialize write)
+ *       inc in_flight_ios # refcount on the dst segment
+ *       inc in_flight_plog_writes
+ *     mutex_unlock
+ *
+ *   process_write_job:
+ *     # submit async plog write
+ *     # dec in_flight_plog_writes in endio
+ *     append_plog()
+ *
+ *     # wait for all async plog writes complete
+ *     # not always. only if we need to make precedents persistent.
+ *     barrier_plog_writes()
+ *
+ *     dec in_flight_ios
+ *     bio_endio(bio)
+ */
+static int process_write(struct wb_device *wb, struct bio *bio)
+{
+	struct write_job *job = alloc_write_job(wb);
+	prepare_write_pos(wb, bio, job);
+	return process_write_job(wb, bio, job);
+}
+
+struct per_bio_data {
+	void *ptr;
+};
+
+static int process_read(struct wb_device *wb, struct bio *bio)
+{
+	struct lookup_result res;
+	u8 dirty_bits;
+
+	mutex_lock(&wb->io_lock);
+	cache_lookup(wb, bio, &res);
+	mutex_unlock(&wb->io_lock);
+
+	if (!res.found) {
+		bio_remap(bio, wb->backing_dev, bio->bi_iter.bi_sector);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	dirty_bits = read_mb_dirtiness(wb, res.found_seg, res.found_mb);
+	if (unlikely(res.on_buffer)) {
+		if (dirty_bits)
+			writeback_buffered_mb(wb, res.found_mb, dirty_bits);
+
+		dec_inflight_ios(wb, res.found_seg);
+		bio_remap(bio, wb->backing_dev, bio->bi_iter.bi_sector);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/*
+	 * We must wait for the (maybe) queued segment to be flushed
+	 * to the cache device.
+	 * Without this, we read the wrong data from the cache device.
+	 */
+	wait_for_flushing(wb, res.found_seg->id);
+
+	if (likely(dirty_bits == 255)) {
+		struct per_bio_data *map_context =
+			dm_per_bio_data(bio, wb->ti->per_bio_data_size);
+		map_context->ptr = res.found_seg;
+
+		bio_remap(bio, wb->cache_dev,
+			  calc_mb_start_sector(wb, res.found_seg, res.found_mb->idx) +
+			  io_offset(bio));
+	} else {
+		writeback_mb(wb, res.found_seg, res.found_mb, dirty_bits, true);
+		cleanup_mb_if_dirty(wb, res.found_seg, res.found_mb);
+
+		dec_inflight_ios(wb, res.found_seg);
+		bio_remap(bio, wb->backing_dev, bio->bi_iter.bi_sector);
+	}
+
+	if (!is_live(wb))
+		bio_io_error(bio);
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static int process_bio(struct wb_device *wb, struct bio *bio)
+{
+	return io_write(bio) ? process_write(wb, bio) : process_read(wb, bio);
+}
+
+static int writeboost_map(struct dm_target *ti, struct bio *bio)
+{
+	struct wb_device *wb = ti->private;
+
+	struct per_bio_data *map_context;
+	map_context = dm_per_bio_data(bio, ti->per_bio_data_size);
+	map_context->ptr = NULL;
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return process_discard_bio(wb, bio);
+
+	if (bio->bi_rw & REQ_FLUSH)
+		return process_flush_bio(wb, bio);
+
+	return process_bio(wb, bio);
+}
+
+static int writeboost_end_io(struct dm_target *ti, struct bio *bio, int error)
+{
+	struct wb_device *wb = ti->private;
+	struct per_bio_data *map_context =
+		dm_per_bio_data(bio, ti->per_bio_data_size);
+	struct segment_header *seg;
+
+	if (!map_context->ptr)
+		return 0;
+
+	seg = map_context->ptr;
+	dec_inflight_ios(wb, seg);
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static int consume_essential_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 1, "Invalid type"},
+	};
+	unsigned tmp;
+
+	r = dm_read_arg(_args, as, &tmp, &ti->error);
+	if (r) {
+		DMERR("%s", ti->error);
+		return r;
+	}
+	wb->type = tmp;
+
+	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+			  &wb->backing_dev);
+	if (r) {
+		DMERR("Failed to get backing_dev");
+		return r;
+	}
+
+	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+			  &wb->cache_dev);
+	if (r) {
+		DMERR("Failed to get cache_dev");
+		goto bad_get_cache;
+	}
+
+	/*
+	 * Plog device will be later allocated with this descriptor.
+	 */
+	if (wb->type)
+		strcpy(wb->plog_dev_desc, dm_shift_arg(as));
+
+	return r;
+
+bad_get_cache:
+	dm_put_device(ti, wb->backing_dev);
+	return r;
+}
+
+#define consume_kv(name, nr) { \
+	if (!strcasecmp(key, #name)) { \
+		if (!argc) \
+			break; \
+		r = dm_read_arg(_args + (nr), as, &tmp, &ti->error); \
+		if (r) { \
+			DMERR("%s", ti->error); \
+			break; \
+		} \
+		wb->name = tmp; \
+	 } }
+
+static int consume_optional_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 4, "Invalid optional argc"},
+		{4, 10, "Invalid segment_size_order"},
+		{1, UINT_MAX, "Invalid nr_rambuf_pool"},
+	};
+	unsigned tmp, argc = 0;
+
+	if (as->argc) {
+		r = dm_read_arg_group(_args, as, &argc, &ti->error);
+		if (r) {
+			DMERR("%s", ti->error);
+			return r;
+		}
+	}
+
+	while (argc) {
+		const char *key = dm_shift_arg(as);
+		argc--;
+
+		r = -EINVAL;
+
+		consume_kv(segment_size_order, 1);
+		consume_kv(nr_rambuf_pool, 2);
+
+		if (!r) {
+			argc--;
+		} else {
+			ti->error = "Invalid optional key";
+			break;
+		}
+	}
+
+	return r;
+}
+
+static int do_consume_tunable_argv(struct wb_device *wb,
+				   struct dm_arg_set *as, unsigned argc)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 1, "Invalid allow_writeback"},
+		{0, 1, "Invalid enable_writeback_modulator"},
+		{1, 1000, "Invalid nr_max_batched_writeback"},
+		{0, 100, "Invalid writeback_threshold"},
+		{0, 3600, "Invalid update_record_interval"},
+		{0, 3600, "Invalid sync_interval"},
+	};
+	unsigned tmp;
+
+	while (argc) {
+		const char *key = dm_shift_arg(as);
+		argc--;
+
+		r = -EINVAL;
+
+		consume_kv(allow_writeback, 0);
+		consume_kv(enable_writeback_modulator, 1);
+		consume_kv(nr_max_batched_writeback, 2);
+		consume_kv(writeback_threshold, 3);
+		consume_kv(update_record_interval, 4);
+		consume_kv(sync_interval, 5);
+
+		if (!r) {
+			argc--;
+		} else {
+			ti->error = "Invalid tunable key";
+			break;
+		}
+	}
+
+	return r;
+}
+
+static int consume_tunable_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 14, "Invalid tunable argc"},
+	};
+	unsigned argc = 0;
+
+	if (as->argc) {
+		r = dm_read_arg_group(_args, as, &argc, &ti->error);
+		if (r) {
+			DMERR("%s", ti->error);
+			return r;
+		}
+		/*
+		 * Tunables are emitted only if
+		 * they were origianlly passed.
+		 */
+		wb->should_emit_tunables = true;
+	}
+
+	return do_consume_tunable_argv(wb, as, argc);
+}
+
+DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(wb_copy_throttle,
+		"A percentage of time allocated for one-shot writeback");
+
+static int init_core_struct(struct dm_target *ti)
+{
+	int r = 0;
+	struct wb_device *wb;
+
+	r = dm_set_target_max_io_len(ti, 1 << 3);
+	if (r) {
+		DMERR("Failed to set max_io_len");
+		return r;
+	}
+
+	ti->flush_supported = true;
+	ti->num_flush_bios = 1;
+	ti->num_discard_bios = 1;
+	ti->discard_zeroes_data_unsupported = true;
+	ti->per_bio_data_size = sizeof(struct per_bio_data);
+
+	wb = kzalloc(sizeof(*wb), GFP_KERNEL);
+	if (!wb) {
+		DMERR("Failed to allocate wb");
+		return -ENOMEM;
+	}
+	ti->private = wb;
+	wb->ti = ti;
+
+	init_waitqueue_head(&wb->writeback_mb_wait_queue);
+	wb->copier = dm_kcopyd_client_create(&dm_kcopyd_throttle);
+	if (IS_ERR(wb->copier)) {
+		r = PTR_ERR(wb->copier);
+		goto bad_kcopyd_client;
+	}
+
+	wb->buf_1_cachep = kmem_cache_create("dmwb_buf_1",
+			1 << 9, 1 << SECTOR_SHIFT, SLAB_RED_ZONE, NULL);
+	if (!wb->buf_1_cachep) {
+		r = -ENOMEM;
+		goto bad_buf_1_cachep;
+	}
+	wb->buf_1_pool = mempool_create_slab_pool(16, wb->buf_1_cachep);
+	if (!wb->buf_1_pool) {
+		r = -ENOMEM;
+		goto bad_buf_1_pool;
+	}
+
+	wb->buf_8_cachep = kmem_cache_create("dmwb_buf_8",
+			1 << 12, 1 << 12, SLAB_RED_ZONE, NULL);
+	if (!wb->buf_8_cachep) {
+		r = -ENOMEM;
+		goto bad_buf_8_cachep;
+	}
+	wb->buf_8_pool = mempool_create_slab_pool(16, wb->buf_8_cachep);
+	if (!wb->buf_8_pool) {
+		r = -ENOMEM;
+		goto bad_buf_8_pool;
+	}
+
+	/*
+	 * Workqueue for generic I/O
+	 * More than one I/Os are submitted during a period
+	 * so the number of max_active workers are set to 0.
+	 */
+	wb->io_wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
+	if (!wb->io_wq) {
+		DMERR("Failed to allocate io_wq");
+		r = -ENOMEM;
+		goto bad_io_wq;
+	}
+
+	wb->io_client = dm_io_client_create();
+	if (IS_ERR(wb->io_client)) {
+		DMERR("Failed to allocate io_client");
+		r = PTR_ERR(wb->io_client);
+		goto bad_io_client;
+	}
+
+	mutex_init(&wb->io_lock);
+	init_waitqueue_head(&wb->inflight_ios_wq);
+	spin_lock_init(&wb->lock);
+	atomic64_set(&wb->nr_dirty_caches, 0);
+	clear_bit(WB_DEAD, &wb->flags);
+	wb->should_emit_tunables = false;
+
+	return r;
+
+bad_io_client:
+	destroy_workqueue(wb->io_wq);
+bad_io_wq:
+	mempool_destroy(wb->buf_8_pool);
+bad_buf_8_pool:
+	kmem_cache_destroy(wb->buf_8_cachep);
+bad_buf_8_cachep:
+	mempool_destroy(wb->buf_1_pool);
+bad_buf_1_pool:
+	kmem_cache_destroy(wb->buf_1_cachep);
+bad_buf_1_cachep:
+	dm_kcopyd_client_destroy(wb->copier);
+bad_kcopyd_client:
+	kfree(wb);
+	return r;
+}
+
+static void free_core_struct(struct wb_device *wb)
+{
+	dm_io_client_destroy(wb->io_client);
+	destroy_workqueue(wb->io_wq);
+	mempool_destroy(wb->buf_8_pool);
+	kmem_cache_destroy(wb->buf_8_cachep);
+	mempool_destroy(wb->buf_1_pool);
+	kmem_cache_destroy(wb->buf_1_cachep);
+	dm_kcopyd_client_destroy(wb->copier);
+	kfree(wb);
+}
+
+/*
+ * Create a writeboost device
+ *
+ * <type>
+ * <essential args>
+ * <#optional args> <optional args>
+ * <#tunable args> <tunable args>
+ * optionals are tunables are unordered lists of k-v pair.
+ *
+ * See doc for detail.
+  */
+static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r = 0;
+	struct wb_device *wb;
+
+	struct dm_arg_set as;
+	as.argc = argc;
+	as.argv = argv;
+
+	r = init_core_struct(ti);
+	if (r) {
+		ti->error = "init_core_struct failed";
+		return r;
+	}
+	wb = ti->private;
+
+	r = consume_essential_argv(wb, &as);
+	if (r) {
+		ti->error = "consume_essential_argv failed";
+		goto bad_essential_argv;
+	}
+
+	/*
+	 * Default values
+	 */
+	wb->segment_size_order = 10;
+	wb->nr_rambuf_pool = 8;
+	if (wb->type)
+		wb->nr_plog_segs = 8;
+
+	r = consume_optional_argv(wb, &as);
+	if (r) {
+		ti->error = "consume_optional_argv failed";
+		goto bad_optional_argv;
+	}
+
+	r = resume_cache(wb);
+	if (r) {
+		ti->error = "resume_cache failed";
+		goto bad_resume_cache;
+	}
+
+	r = consume_tunable_argv(wb, &as);
+	if (r) {
+		ti->error = "consume_tunable_argv failed";
+		goto bad_tunable_argv;
+	}
+
+	clear_stat(wb);
+	atomic64_set(&wb->count_non_full_flushed, 0);
+
+	return r;
+
+bad_tunable_argv:
+	free_cache(wb);
+bad_resume_cache:
+bad_optional_argv:
+	dm_put_device(ti, wb->cache_dev);
+	dm_put_device(ti, wb->backing_dev);
+bad_essential_argv:
+	free_core_struct(wb);
+	ti->private = NULL;
+
+	return r;
+}
+
+static void writeboost_dtr(struct dm_target *ti)
+{
+	struct wb_device *wb = ti->private;
+
+	free_cache(wb);
+
+	dm_put_device(ti, wb->cache_dev);
+	dm_put_device(ti, wb->backing_dev);
+
+	free_core_struct(wb);
+	ti->private = NULL;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * .postsuspend is called before .dtr.
+ * We flush out all the transient data and make them persistent.
+ */
+static void writeboost_postsuspend(struct dm_target *ti)
+{
+	int r = 0;
+	struct wb_device *wb = ti->private;
+
+	flush_current_buffer(wb);
+	maybe_IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+}
+
+static int writeboost_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct wb_device *wb = ti->private;
+
+	struct dm_arg_set as;
+	as.argc = argc;
+	as.argv = argv;
+
+	if (!strcasecmp(argv[0], "clear_stat")) {
+		clear_stat(wb);
+		return 0;
+	}
+
+	if (!strcasecmp(argv[0], "drop_caches")) {
+		int r = 0;
+		wb->force_drop = true;
+		r = wait_event_interruptible(wb->wait_drop_caches,
+			     !atomic64_read(&wb->nr_dirty_caches));
+		wb->force_drop = false;
+		return r;
+	}
+
+	return do_consume_tunable_argv(wb, &as, 2);
+}
+
+/*
+ * Since Writeboost is just a cache target and the cache block size is fixed
+ * to 4KB. There is no reason to count the cache device in device iteration.
+ */
+static int writeboost_iterate_devices(struct dm_target *ti,
+				      iterate_devices_callout_fn fn, void *data)
+{
+	struct wb_device *wb = ti->private;
+	struct dm_dev *backing = wb->backing_dev;
+	sector_t start = 0;
+	sector_t len = dm_devsize(backing);
+	return fn(ti, backing, start, len, data);
+}
+
+static void writeboost_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	blk_limits_io_opt(limits, 4096);
+}
+
+static void emit_tunables(struct wb_device *wb, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+
+	DMEMIT(" %d", 12);
+	DMEMIT(" allow_writeback %d",
+	       wb->allow_writeback ? 1 : 0);
+	DMEMIT(" enable_writeback_modulator %d",
+	       wb->enable_writeback_modulator ? 1 : 0);
+	DMEMIT(" writeback_threshold %d",
+	       wb->writeback_threshold);
+	DMEMIT(" nr_cur_batched_writeback %u",
+	       wb->nr_cur_batched_writeback);
+	DMEMIT(" sync_interval %lu",
+	       wb->sync_interval);
+	DMEMIT(" update_record_interval %lu",
+	       wb->update_record_interval);
+}
+
+static void writeboost_status(struct dm_target *ti, status_type_t type,
+			      unsigned flags, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	char buf[BDEVNAME_SIZE];
+	struct wb_device *wb = ti->private;
+	size_t i;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%u %u %llu %llu %llu %llu %llu",
+		       (unsigned int)
+		       wb->cursor,
+		       (unsigned int)
+		       wb->nr_caches,
+		       (long long unsigned int)
+		       wb->nr_segments,
+		       (long long unsigned int)
+		       wb->current_seg->id,
+		       (long long unsigned int)
+		       atomic64_read(&wb->last_flushed_segment_id),
+		       (long long unsigned int)
+		       atomic64_read(&wb->last_writeback_segment_id),
+		       (long long unsigned int)
+		       atomic64_read(&wb->nr_dirty_caches));
+
+		for (i = 0; i < STATLEN; i++) {
+			atomic64_t *v = &wb->stat[i];
+			DMEMIT(" %llu", (unsigned long long) atomic64_read(v));
+		}
+		DMEMIT(" %llu", (unsigned long long) atomic64_read(&wb->count_non_full_flushed));
+		emit_tunables(wb, result + sz, maxlen - sz);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%u", wb->type);
+		format_dev_t(buf, wb->backing_dev->bdev->bd_dev);
+		DMEMIT(" %s", buf);
+		format_dev_t(buf, wb->cache_dev->bdev->bd_dev);
+		DMEMIT(" %s", buf);
+		if (wb->type)
+			DMEMIT(" %s", wb->plog_dev_desc);
+		DMEMIT(" 4 segment_size_order %u nr_rambuf_pool %u",
+		       wb->segment_size_order,
+		       wb->nr_rambuf_pool);
+		if (wb->should_emit_tunables)
+			emit_tunables(wb, result + sz, maxlen - sz);
+		break;
+	}
+}
+
+static struct target_type writeboost_target = {
+	.name = "writeboost",
+	.version = {0, 9, 0},
+	.module = THIS_MODULE,
+	.map = writeboost_map,
+	.end_io = writeboost_end_io,
+	.ctr = writeboost_ctr,
+	.dtr = writeboost_dtr,
+	/*
+	 * .merge is not implemented
+	 * We split the passed I/O into 4KB cache block no matter
+	 * how big the I/O is.
+	 */
+	.postsuspend = writeboost_postsuspend,
+	.message = writeboost_message,
+	.status = writeboost_status,
+	.io_hints = writeboost_io_hints,
+	.iterate_devices = writeboost_iterate_devices,
+};
+
+static int __init writeboost_module_init(void)
+{
+	int r = 0;
+
+	r = dm_register_target(&writeboost_target);
+	if (r < 0) {
+		DMERR("Failed to register target");
+		return r;
+	}
+
+	return r;
+}
+
+static void __exit writeboost_module_exit(void)
+{
+	dm_unregister_target(&writeboost_target);
+}
+
+module_init(writeboost_module_init);
+module_exit(writeboost_module_exit);
+
+MODULE_AUTHOR("Akira Hayakawa <ruby.wktk@gmail.com>");
+MODULE_DESCRIPTION(DM_NAME " writeboost target");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/writeboost/dm-writeboost.h b/drivers/staging/writeboost/dm-writeboost.h
new file mode 100644
index 0000000..05e52f4
--- /dev/null
+++ b/drivers/staging/writeboost/dm-writeboost.h
@@ -0,0 +1,586 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_H
+#define DM_WRITEBOOST_H
+
+#define DM_MSG_PREFIX "writeboost"
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mutex.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/crc32c.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+
+/*----------------------------------------------------------------*/
+
+#define SUB_ID(x, y) ((x) > (y) ? (x) - (y) : 0)
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The detail of the disk format (SSD)
+ * -----------------------------------
+ *
+ * ### Overall
+ * Superblock (1MB) + Segment + Segment ...
+ *
+ * ### Superblock
+ * Head <----                                     ----> Tail
+ * Superblock Header (512B) + ... + Superblock Record (512B)
+ *
+ * ### Segment
+ * segment_header_device (512B) +
+ * metablock_device * nr_caches_inseg +
+ * data[0] (4KB) + data[1] + ... + data[nr_cache_inseg - 1]
+ */
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Superblock Header (Immutable)
+ * -----------------------------
+ * First one sector of the super block region whose value
+ * is unchanged after formatted.
+ */
+#define WB_MAGIC 0x57427374 /* Magic number "WBst" */
+struct superblock_header_device {
+	__le32 magic;
+	__u8 segment_size_order;
+} __packed;
+
+/*
+ * Superblock Record (Mutable)
+ * ---------------------------
+ * Last one sector of the superblock region.
+ * Record the current cache status if required.
+ */
+struct superblock_record_device {
+	__le64 last_writeback_segment_id;
+} __packed;
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The size must be a factor of one sector to avoid starddling
+ * neighboring two sectors.
+ * Facebook's flashcache does the same thing.
+ */
+struct metablock_device {
+	__le64 sector;
+	__u8 dirty_bits;
+	__u8 padding[16 - (8 + 1)]; /* 16B */
+} __packed;
+
+#define WB_CKSUM_SEED (~(u32)0)
+
+struct segment_header_device {
+	/*
+	 * We assume 1 sector write is atomic.
+	 * This 1 sector region contains important information
+	 * such as checksum of the rest of the segment data.
+	 * We use 32bit checksum to audit if the segment is
+	 * correctly written to the cache device.
+	 */
+	/* - FROM ------------------------------------ */
+	__le64 id;
+	/* TODO Add timestamp? */
+	__le32 checksum;
+	/*
+	 * The number of metablocks in this segment header to be
+	 * considered in log replay. Note: 0 is allowed.
+	 */
+	__u8 length;
+	__u8 padding[512 - (8 + 4 + 1)]; /* 512B */
+	/* - TO -------------------------------------- */
+	struct metablock_device mbarr[0]; /* 16B * N */
+} __packed;
+
+/*----------------------------------------------------------------*/
+
+struct metablock {
+	sector_t sector; /* The original aligned address */
+
+	u32 idx; /* Index in the metablock array. const */
+
+	struct hlist_node ht_list; /* Linked to the hash table */
+
+	u8 dirty_bits; /* 8bit for dirtiness in sector granularity */
+};
+
+#define SZ_MAX (~(size_t)0)
+struct segment_header {
+	u64 id; /* Must be initialized to 0 */
+
+	/*
+	 * The number of metablocks in a segment to flush and then write back.
+	 */
+	u8 length;
+
+	u32 start_idx; /* Const */
+	sector_t start_sector; /* Const */
+
+	atomic_t nr_inflight_ios;
+
+	struct metablock mb_array[0];
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Object to be used in async plog write
+ */
+struct write_job {
+	struct wb_device *wb;
+
+	struct metablock *mb; /* Pos */
+	sector_t plog_head; /* Pos */
+
+	/*
+	 * We can't use zero-length array here
+	 * instead we must allocate the buffer
+	 * by explicitly calling kmalloc.
+	 * Otherwise, the dm_io() function fails.
+	 */
+	void *plog_buf;
+};
+
+/*
+ * RAM buffer is a buffer that any dirty data are first written to.
+ * Type member in wb_device indicates the buffer type.
+ */
+struct rambuffer {
+	void *data; /* The DRAM buffer. Used as the buffer to submit I/O */
+};
+
+/*
+ * Object to be consumed by wbflusher
+ * Foreground queues this object and wbflusher later pops
+ * one job to submit journal write to the cache device.
+ */
+struct flush_job {
+	struct work_struct work;
+	struct wb_device *wb;
+	struct segment_header *seg;
+	struct rambuffer *rambuf; /* RAM buffer to flush */
+	struct bio_list barrier_ios; /* List of deferred bios */
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The data structures in persistent logging
+ * -----------------------------------------
+ *
+ * Plog:
+ * plog_meta_device (512B) + data (512B-4096B)
+ * A plog contains a self-contained information of a accepted write.
+ * Plog is an atomic unit in persistent logging.
+ *
+ * plog_dev:
+ * The persistent device where plogs are written.
+ *
+ * plog_seg:
+ * Like cache_dev is split into segment_headers
+ * plog_dev is split into plog_segs of the same size.
+ *
+ * E.g.
+ * A plog_dev is split into two plog_seg
+ *
+ * |<------------------------ plog_dev ------------------------>|
+ * |<-------- plog_seg ---------->|<-------- plog_seg --------->|
+ * |(meta, data), (meta, data), ..|...                          |
+ *  <-- plog -->
+ */
+
+struct plog_meta_device {
+	__le64 id; /* Id of the segment */
+	__le64 sector; /* Orig sector */
+	__le32 checksum; /* Checksum of the data */
+	__u8 idx; /* Idx in the segment */
+	__u8 len; /* Length in sector */
+	__u8 padding[512 - (8 + 8 + 4 + 1 + 1)];
+} __packed;
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Batched and Sorted Writeback
+ * ----------------------------
+ *
+ * Writeback daemon writes back segments on the cache device effectively.
+ * "Batched" means it writes back number of segments at the same time
+ * in asynchronous manner.
+ * "Sorted" means these writeback IOs are sorted in ascending order of
+ * LBA in the backing device. Rb-tree is used to sort the writeback IOs.
+ *
+ * Reading from the cache device is sequential thus also effective.
+ */
+
+/*
+ * Writeback of a cache line
+ */
+struct writeback_io {
+	struct rb_node rb_node;
+
+	sector_t sector; /* Key */
+	u64 id; /* Key */
+
+	void *data;
+	u8 memorized_dirtiness;
+};
+#define writeback_io_from_node(node) rb_entry((node), struct writeback_io, rb_node)
+
+/*
+ * Writeback of a segment
+ */
+struct writeback_segment {
+	struct segment_header *seg; /* Segment to write back */
+	struct writeback_io *ios;
+	void *buf; /* Sequentially read */
+};
+
+/*----------------------------------------------------------------*/
+
+enum STATFLAG {
+	STAT_WRITE = 3, /* Write or read */
+	STAT_HIT = 2, /* Hit or miss */
+	STAT_ON_BUFFER = 1, /* Found on buffer or on the cache device */
+	STAT_FULLSIZE = 0, /* Bio is fullsize or partial */
+};
+#define STATLEN (1 << 4)
+
+enum WB_FLAG {
+	/*
+	 * This flag is set when either one of the underlying devices
+	 * returned EIO and we must immediately block up the whole to
+	 * avoid further damage.
+	 */
+	WB_DEAD = 0,
+};
+
+/*
+ * The context of the cache target instance.
+ */
+struct wb_device {
+	/*
+	 * 0: No persistent logging (plog) but only RAM buffers
+	 * 1: With plog (block device)
+	 * 2..: With plog (others) TODO
+	 */
+	int type;
+
+	struct dm_target *ti;
+
+	struct dm_dev *backing_dev; /* Slow device (HDD) */
+	struct dm_dev *cache_dev; /* Fast device (SSD) */
+
+	/*
+	 * Mutex is really light-weighted.
+	 * To mitigate the overhead of the locking we chose to use mutex.
+	 * To optimize the read path, rw_semaphore is an option
+	 * but it means to sacrifice writes.
+	 */
+	struct mutex io_lock;
+
+	/*
+	 * Wq to wait for nr_inflight_ios to be zero.
+	 * nr_inflight_ios of segment header increments inside io_lock.
+	 * While the refcount > 0, the segment can not be overwritten
+	 * since there is at least one bio to direct it.
+	 */
+	wait_queue_head_t inflight_ios_wq;
+
+	spinlock_t lock;
+
+	u8 segment_size_order; /* Const */
+	u8 nr_caches_inseg; /* Const */
+
+	struct kmem_cache *buf_1_cachep;
+	mempool_t *buf_1_pool; /* 1 sector buffer pool */
+	struct kmem_cache *buf_8_cachep;
+	mempool_t *buf_8_pool; /* 8 sector buffer pool */
+	struct workqueue_struct *io_wq;
+	struct dm_io_client *io_client;
+
+	/*---------------------------------------------*/
+
+	/******************
+	 * Current position
+	 ******************/
+
+	u32 cursor; /* Metablock index to write next */
+	struct segment_header *current_seg;
+	struct rambuffer *current_rambuf;
+
+	/*---------------------------------------------*/
+
+	/**********************
+	 * Segment header array
+	 **********************/
+
+	u32 nr_segments; /* Const */
+	struct large_array *segment_header_array;
+
+	/*---------------------------------------------*/
+
+	/********************
+	 * Chained Hash table
+	 ********************/
+
+	u32 nr_caches; /* Const */
+	struct large_array *htable;
+	size_t htsize; /* Number of buckets in the hash table */
+
+	/*
+	 * Our hashtable has one special bucket called null head.
+	 * Orphan metablocks are linked to the null head.
+	 */
+	struct ht_head *null_head;
+
+	/*---------------------------------------------*/
+
+	/*****************
+	 * RAM buffer pool
+	 *****************/
+
+	u32 nr_rambuf_pool; /* Const */
+	struct kmem_cache *rambuf_cachep;
+	struct rambuffer *rambuf_pool;
+
+	/*---------------------------------------------*/
+
+	/********************
+	 * One-shot Writeback
+	 ********************/
+
+	wait_queue_head_t writeback_mb_wait_queue;
+	struct dm_kcopyd_client *copier;
+
+	/*---------------------------------------------*/
+
+	/****************
+	 * Flusher Daemon
+	 ****************/
+
+	mempool_t *flush_job_pool;
+	struct workqueue_struct *flusher_wq;
+
+	/*
+	 * Wait for a specified segment to be flushed
+	 * non-interruptible
+	 * cf. wait_for_flushing()
+	 */
+	wait_queue_head_t flush_wait_queue;
+
+	atomic64_t last_flushed_segment_id;
+
+	/*---------------------------------------------*/
+
+	/*************************
+	 * Barrier deadline worker
+	 *************************/
+
+	struct work_struct flush_barrier_work;
+	struct bio_list barrier_ios; /* List of barrier requests */
+
+	/*---------------------------------------------*/
+
+	/******************
+	 * Writeback Daemon
+	 ******************/
+
+	struct task_struct *writeback_daemon;
+	int allow_writeback;
+	int urge_writeback; /* Start writeback immediately */
+	int force_drop; /* Don't stop writeback */
+	atomic64_t last_writeback_segment_id;
+
+	/*
+	 * Wait for a specified segment to be written back
+	 * Non-interruptible
+	 * cf. wait_for_writeback()
+	 */
+	wait_queue_head_t writeback_wait_queue;
+
+	/*
+	 * Wait for writing back all the dirty caches (or dropping caches)
+	 * Interruptible
+	 */
+	wait_queue_head_t wait_drop_caches;
+
+	/*
+	 * Wait for a backgraound writeback complete
+	 */
+	wait_queue_head_t writeback_io_wait_queue;
+	atomic_t writeback_io_count;
+	atomic_t writeback_fail_count;
+
+	u32 nr_cur_batched_writeback;
+	u32 nr_max_batched_writeback; /* Tunable */
+
+	struct rb_root writeback_tree;
+
+	u32 num_writeback_segs; /* Number of segments to write back */
+	struct writeback_segment **writeback_segs;
+
+	/*---------------------------------------------*/
+
+	/*********************
+	 * Writeback Modulator
+	 *********************/
+
+	struct task_struct *modulator_daemon;
+	int enable_writeback_modulator; /* Tunable */
+	u8 writeback_threshold; /* Tunable */
+
+	/*---------------------------------------------*/
+
+	/*********************
+	 * Superblock Recorder
+	 *********************/
+
+	struct task_struct *recorder_daemon;
+	unsigned long update_record_interval; /* Tunable */
+
+	/*---------------------------------------------*/
+
+	/*************
+	 * Sync Daemon
+	 *************/
+
+	struct task_struct *sync_daemon;
+	unsigned long sync_interval; /* Tunable */
+
+	/*---------------------------------------------*/
+
+	/********************
+	 * Persistent Logging
+	 ********************/
+
+	/* Common */
+	char plog_dev_desc[BDEVNAME_SIZE]; /* Passed as essential argv to describe the persistent device */
+
+	wait_queue_head_t plog_wait_queue; /* Wait queue to serialize writers */
+	atomic_t nr_inflight_plog_writes; /* Number of async plog writes not acked yet */
+
+	mempool_t *write_job_pool;
+	struct kmem_cache *plog_buf_cachep;
+	mempool_t *plog_buf_pool;
+	struct kmem_cache *plog_seg_buf_cachep;
+
+	sector_t plog_seg_size; /* Const. The size of a plog in sector */
+	sector_t alloc_plog_head; /* Next relative sector to allocate */
+	sector_t plog_seg_start_sector; /* The absolute start sector of the current plog */
+	u32 nr_plog_segs; /* Const. Number of plogs */
+
+	/* Type 1 */
+	struct dm_dev *plog_dev_t1;
+
+	/* Type 2 */
+	/* TODO */
+
+	/*---------------------------------------------*/
+
+	/************
+	 * Statistics
+	 ************/
+
+	atomic64_t nr_dirty_caches;
+	atomic64_t stat[STATLEN];
+	atomic64_t count_non_full_flushed;
+
+	/*---------------------------------------------*/
+
+	unsigned long flags;
+	bool should_emit_tunables; /* Should emit tunables in dmsetup table? */
+};
+
+/*----------------------------------------------------------------*/
+
+void acquire_new_seg(struct wb_device *, u64 id);
+void cursor_init(struct wb_device *);
+void flush_current_buffer(struct wb_device *);
+void inc_nr_dirty_caches(struct wb_device *);
+void cleanup_mb_if_dirty(struct wb_device *, struct segment_header *, struct metablock *);
+u8 read_mb_dirtiness(struct wb_device *, struct segment_header *, struct metablock *);
+void invalidate_previous_cache(struct wb_device *, struct segment_header *,
+			       struct metablock *old_mb, bool overwrite_fullsize);
+void rebuild_rambuf(void *rambuf, void *plog_buf, u64 log_id);
+
+/*----------------------------------------------------------------*/
+
+#define check_buffer_alignment(buf) \
+	do_check_buffer_alignment(buf, #buf, __func__)
+void do_check_buffer_alignment(void *, const char *, const char *);
+
+/*
+ * Wrapper of dm_io function.
+ * Set thread to true to run dm_io in other thread to avoid potential deadlock.
+ */
+#define dm_safe_io(io_req, num_regions, regions, err_bits, thread) \
+	dm_safe_io_internal(wb, (io_req), (num_regions), (regions), \
+			    (err_bits), (thread), __func__)
+int dm_safe_io_internal(struct wb_device *, struct dm_io_request *,
+			unsigned num_regions, struct dm_io_region *,
+			unsigned long *err_bits, bool thread, const char *caller);
+
+sector_t dm_devsize(struct dm_dev *);
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Device blockup (Marking the device as dead)
+ * -------------------------------------------
+ *
+ * I/O error on cache device blocks up the whole system.
+ * After the system is blocked up, cache device is dead,
+ * all I/Os to cache device are ignored as if it becomes /dev/null.
+ */
+#define mark_dead(wb) set_bit(WB_DEAD, &wb->flags)
+#define is_live(wb) likely(!test_bit(WB_DEAD, &wb->flags))
+
+/*
+ * This macro wraps I/Os to cache device to add context of failure.
+ */
+#define maybe_IO(proc) \
+	do { \
+		r = 0; \
+		if (is_live(wb)) {\
+			r = proc; \
+		} else { \
+			r = -EIO; \
+			break; \
+		} \
+		\
+		if (r == -EIO) { \
+			mark_dead(wb); \
+			DMERR("device is marked as dead"); \
+			break; \
+		} else if (r == -ENOMEM) { \
+			DMERR("I/O failed by ENOMEM"); \
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));\
+			continue; \
+		} else if (r == -EOPNOTSUPP) { \
+			break; \
+		} else if (r) { \
+			WARN_ONCE(1, "I/O failed for unknown reason err(%d)", r); \
+			break; \
+		} \
+	} while (r)
+
+/*----------------------------------------------------------------*/
+
+#endif
-- 
1.8.5.5

