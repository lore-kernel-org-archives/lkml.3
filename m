Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaF3PyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:54:05 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50033 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbaF3PxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/18] drbd: use drbd_device_post_work() in more places
Date: Mon, 30 Jun 2014 17:53:06 +0200
Message-Id: <1404143587-24344-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This replaces the md_sync_work member of struct drbd_device
by a new MD_SYNC "work bit" in device->flags.

This replaces the resync_start_work member of struct drbd_device
by a new RS_START "work bit" in device->flags.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    | 16 ++--------------
 drivers/block/drbd/drbd_main.c   | 25 +------------------------
 drivers/block/drbd/drbd_worker.c | 27 +++++++++++++++++----------
 3 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5768260..3c701b0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -457,6 +457,8 @@ enum {
 	/* to be used in drbd_device_post_work() */
 	GO_DISKLESS,		/* tell worker to schedule cleanup before detach */
 	DESTROY_DISK,		/* tell worker to close backing devices and destroy related structures. */
+	MD_SYNC,		/* tell worker to call drbd_md_sync() */
+	RS_START,		/* tell worker to start resync/OV */
 	RS_PROGRESS,		/* tell worker that resync made significant progress */
 	RS_DONE,		/* tell worker that resync is done */
 };
@@ -709,18 +711,10 @@ struct drbd_device {
 	unsigned long last_reattach_jif;
 	struct drbd_work resync_work;
 	struct drbd_work unplug_work;
-	struct drbd_work md_sync_work;
-	struct drbd_work start_resync_work;
 	struct timer_list resync_timer;
 	struct timer_list md_sync_timer;
 	struct timer_list start_resync_timer;
 	struct timer_list request_timer;
-#ifdef DRBD_DEBUG_MD_SYNC
-	struct {
-		unsigned int line;
-		const char* func;
-	} last_md_mark_dirty;
-#endif
 
 	/* Used after attach while negotiating new disk state. */
 	union drbd_state new_state_tmp;
@@ -977,13 +971,7 @@ extern void __drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must
 extern void drbd_md_set_flag(struct drbd_device *device, int flags) __must_hold(local);
 extern void drbd_md_clear_flag(struct drbd_device *device, int flags)__must_hold(local);
 extern int drbd_md_test_flag(struct drbd_backing_dev *, int);
-#ifndef DRBD_DEBUG_MD_SYNC
 extern void drbd_md_mark_dirty(struct drbd_device *device);
-#else
-#define drbd_md_mark_dirty(m)	drbd_md_mark_dirty_(m, __LINE__ , __func__ )
-extern void drbd_md_mark_dirty_(struct drbd_device *device,
-		unsigned int line, const char *func);
-#endif
 extern void drbd_queue_bitmap_io(struct drbd_device *device,
 				 int (*io_fn)(struct drbd_device *),
 				 void (*done)(struct drbd_device *, int),
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0cf6094..ed35d52 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -60,7 +60,6 @@
 static DEFINE_MUTEX(drbd_main_mutex);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
 static void drbd_release(struct gendisk *gd, fmode_t mode);
-static int w_md_sync(struct drbd_work *w, int unused);
 static void md_sync_timer_fn(unsigned long data);
 static int w_bitmap_io(struct drbd_work *w, int unused);
 
@@ -1928,15 +1927,11 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	INIT_LIST_HEAD(&device->resync_reads);
 	INIT_LIST_HEAD(&device->resync_work.list);
 	INIT_LIST_HEAD(&device->unplug_work.list);
-	INIT_LIST_HEAD(&device->md_sync_work.list);
-	INIT_LIST_HEAD(&device->start_resync_work.list);
 	INIT_LIST_HEAD(&device->bm_io_work.w.list);
 
 	device->resync_work.cb  = w_resync_timer;
 	device->unplug_work.cb  = w_send_write_hint;
-	device->md_sync_work.cb = w_md_sync;
 	device->bm_io_work.w.cb = w_bitmap_io;
-	device->start_resync_work.cb = w_start_resync;
 
 	init_timer(&device->resync_timer);
 	init_timer(&device->md_sync_timer);
@@ -3623,25 +3618,7 @@ int drbd_md_test_flag(struct drbd_backing_dev *bdev, int flag)
 static void md_sync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
-
-	/* must not double-queue! */
-	if (list_empty(&device->md_sync_work.list))
-		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
-				      &device->md_sync_work);
-}
-
-static int w_md_sync(struct drbd_work *w, int unused)
-{
-	struct drbd_device *device =
-		container_of(w, struct drbd_device, md_sync_work);
-
-	drbd_warn(device, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
-#ifdef DEBUG
-	drbd_warn(device, "last md_mark_dirty: %s:%u\n",
-		device->last_md_mark_dirty.func, device->last_md_mark_dirty.line);
-#endif
-	drbd_md_sync(device);
-	return 0;
+	drbd_device_post_work(device, MD_SYNC);
 }
 
 const char *cmdname(enum drbd_packet cmd)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 00bf490..a4310fd 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1606,26 +1606,20 @@ void drbd_rs_controller_reset(struct drbd_device *device)
 void start_resync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
-
-	drbd_queue_work(&first_peer_device(device)->connection->sender_work,
-			&device->start_resync_work);
+	drbd_device_post_work(device, RS_START);
 }
 
-int w_start_resync(struct drbd_work *w, int cancel)
+static void do_start_resync(struct drbd_device *device)
 {
-	struct drbd_device *device =
-		container_of(w, struct drbd_device, start_resync_work);
-
 	if (atomic_read(&device->unacked_cnt) || atomic_read(&device->rs_pending_cnt)) {
-		drbd_warn(device, "w_start_resync later...\n");
+		drbd_warn(device, "postponing start_resync ...\n");
 		device->start_resync_timer.expires = jiffies + HZ/10;
 		add_timer(&device->start_resync_timer);
-		return 0;
+		return;
 	}
 
 	drbd_start_resync(device, C_SYNC_SOURCE);
 	clear_bit(AHEAD_TO_SYNC_SOURCE, &device->flags);
-	return 0;
 }
 
 /**
@@ -1882,9 +1876,18 @@ static void go_diskless(struct drbd_device *device)
 	drbd_force_state(device, NS(disk, D_DISKLESS));
 }
 
+static int do_md_sync(struct drbd_device *device)
+{
+	drbd_warn(device, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
+	drbd_md_sync(device);
+	return 0;
+}
+
 #define WORK_PENDING(work_bit, todo)	(todo & (1UL << work_bit))
 static void do_device_work(struct drbd_device *device, const unsigned long todo)
 {
+	if (WORK_PENDING(MD_SYNC, todo))
+		do_md_sync(device);
 	if (WORK_PENDING(RS_DONE, todo) ||
 	    WORK_PENDING(RS_PROGRESS, todo))
 		update_on_disk_bitmap(device, WORK_PENDING(RS_DONE, todo));
@@ -1892,11 +1895,15 @@ static void do_device_work(struct drbd_device *device, const unsigned long todo)
 		go_diskless(device);
 	if (WORK_PENDING(DESTROY_DISK, todo))
 		drbd_ldev_destroy(device);
+	if (WORK_PENDING(RS_START, todo))
+		do_start_resync(device);
 }
 
 #define DRBD_DEVICE_WORK_MASK	\
 	((1UL << GO_DISKLESS)	\
 	|(1UL << DESTROY_DISK)	\
+	|(1UL << MD_SYNC)	\
+	|(1UL << RS_START)	\
 	|(1UL << RS_PROGRESS)	\
 	|(1UL << RS_DONE)	\
 	)
-- 
1.9.1

