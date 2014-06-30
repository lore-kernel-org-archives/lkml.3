Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaF3PyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:54:00 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50052 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbaF3PxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/18] drbd: make sure disk cleanup happens in worker context
Date: Mon, 30 Jun 2014 17:53:05 +0200
Message-Id: <1404143587-24344-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The recent fix to put_ldev() (correct ordering of access to local_cnt
and state.disk; memory barrier in __drbd_set_state) guarantees
that the cleanup happens exactly once.

However it does not yet guarantee that the cleanup happens from worker
context, the last put_ldev() may still happen from atomic context,
which must not happen: blkdev_put() may sleep.

Fix this by scheduling the cleanup to the worker instead,
using a couple more bits in device->flags and a new helper,
drbd_device_post_work().

Generalized the "resync progress" work to cover these new work bits.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   9 +---
 drivers/block/drbd/drbd_int.h    |  40 +++++++++++-----
 drivers/block/drbd/drbd_main.c   |  59 -----------------------
 drivers/block/drbd/drbd_nl.c     |   2 +-
 drivers/block/drbd/drbd_worker.c | 100 +++++++++++++++++++++++++++++++++++----
 5 files changed, 120 insertions(+), 90 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 14b2f27..5add201 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -797,20 +797,13 @@ static bool lazy_bitmap_update_due(struct drbd_device *device)
 
 static void maybe_schedule_on_disk_bitmap_update(struct drbd_device *device, bool rs_done)
 {
-	struct drbd_connection *connection;
 	if (rs_done)
 		set_bit(RS_DONE, &device->flags);
 		/* and also set RS_PROGRESS below */
 	else if (!lazy_bitmap_update_due(device))
 		return;
 
-	/* compare with test_and_clear_bit() calls in and above
-	 * try_update_all_on_disk_bitmaps() from the drbd_worker(). */
-	if (test_and_set_bit(RS_PROGRESS, &device->flags))
-		return;
-	connection = first_peer_device(device)->connection;
-	if (!test_and_set_bit(CONN_RS_PROGRESS, &connection->flags))
-		wake_up(&connection->sender_work.q_wait);
+	drbd_device_post_work(device, RS_PROGRESS);
 }
 
 static int update_sync_bits(struct drbd_device *device,
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a0ffc19..5768260 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -432,16 +432,12 @@ enum {
 				 * goes into C_CONNECTED state. */
 	CONSIDER_RESYNC,
 
-	RS_PROGRESS,		/* tell worker that resync made significant progress */
-	RS_DONE,		/* tell worker that resync is done */
-
 	MD_NO_FUA,		/* Users wants us to not use FUA/FLUSH on meta data dev */
 
 	SUSPEND_IO,		/* suspend application io */
 	BITMAP_IO,		/* suspend application io;
 				   once no more io in flight, start bitmap io */
 	BITMAP_IO_QUEUED,       /* Started bitmap IO */
-	GO_DISKLESS,		/* Disk is being detached, on io-error or admin request. */
 	WAS_IO_ERROR,		/* Local disk failed, returned IO error */
 	WAS_READ_ERROR,		/* Local disk READ failed (set additionally to the above) */
 	FORCE_DETACH,		/* Force-detach from local disk, aborting any pending local IO */
@@ -454,6 +450,15 @@ enum {
 	B_RS_H_DONE,		/* Before resync handler done (already executed) */
 	DISCARD_MY_DATA,	/* discard_my_data flag per volume */
 	READ_BALANCE_RR,
+
+	/* cleared only after backing device related structures have been destroyed. */
+	GOING_DISKLESS,		/* Disk is being detached, because of io-error, or admin request. */
+
+	/* to be used in drbd_device_post_work() */
+	GO_DISKLESS,		/* tell worker to schedule cleanup before detach */
+	DESTROY_DISK,		/* tell worker to close backing devices and destroy related structures. */
+	RS_PROGRESS,		/* tell worker that resync made significant progress */
+	RS_DONE,		/* tell worker that resync is done */
 };
 
 struct drbd_bitmap; /* opaque for drbd_device */
@@ -581,7 +586,8 @@ enum {
 				 * and potentially deadlock on, this drbd worker.
 				 */
 	DISCONNECT_SENT,
-	CONN_RS_PROGRESS,	/* tell worker that resync made significant progress */
+
+	DEVICE_WORK_PENDING,	/* tell worker that some device has pending work */
 };
 
 struct drbd_resource {
@@ -703,7 +709,6 @@ struct drbd_device {
 	unsigned long last_reattach_jif;
 	struct drbd_work resync_work;
 	struct drbd_work unplug_work;
-	struct drbd_work go_diskless;
 	struct drbd_work md_sync_work;
 	struct drbd_work start_resync_work;
 	struct timer_list resync_timer;
@@ -991,7 +996,6 @@ extern int drbd_bitmap_io_from_worker(struct drbd_device *device,
 		char *why, enum bm_flag flags);
 extern int drbd_bmio_set_n_write(struct drbd_device *device) __must_hold(local);
 extern int drbd_bmio_clear_n_write(struct drbd_device *device) __must_hold(local);
-extern void drbd_ldev_destroy(struct drbd_device *device);
 
 /* Meta data layout
  *
@@ -1796,6 +1800,18 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 	wake_up(&q->q_wait);
 }
 
+static inline void
+drbd_device_post_work(struct drbd_device *device, int work_bit)
+{
+	if (!test_and_set_bit(work_bit, &device->flags)) {
+		struct drbd_connection *connection =
+			first_peer_device(device)->connection;
+		struct drbd_work_queue *q = &connection->sender_work;
+		if (!test_and_set_bit(DEVICE_WORK_PENDING, &connection->flags))
+			wake_up(&q->q_wait);
+	}
+}
+
 extern void drbd_flush_workqueue(struct drbd_work_queue *work_queue);
 
 static inline void wake_asender(struct drbd_connection *connection)
@@ -1961,13 +1977,11 @@ static inline void put_ldev(struct drbd_device *device)
 	if (i == 0) {
 		if (ds == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
-			drbd_ldev_destroy(device);
-		if (ds == D_FAILED) {
+			drbd_device_post_work(device, DESTROY_DISK);
+		if (ds == D_FAILED)
 			/* all application IO references gone. */
-			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
-				drbd_queue_work(&first_peer_device(device)->connection->sender_work,
-						&device->go_diskless);
-		}
+			if (!test_and_set_bit(GOING_DISKLESS, &device->flags))
+				drbd_device_post_work(device, GO_DISKLESS);
 		wake_up(&device->misc_wait);
 	}
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 77d34a6..0cf6094 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -63,7 +63,6 @@ static void drbd_release(struct gendisk *gd, fmode_t mode);
 static int w_md_sync(struct drbd_work *w, int unused);
 static void md_sync_timer_fn(unsigned long data);
 static int w_bitmap_io(struct drbd_work *w, int unused);
-static int w_go_diskless(struct drbd_work *w, int unused);
 
 MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
 	      "Lars Ellenberg <lars@linbit.com>");
@@ -1929,14 +1928,12 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	INIT_LIST_HEAD(&device->resync_reads);
 	INIT_LIST_HEAD(&device->resync_work.list);
 	INIT_LIST_HEAD(&device->unplug_work.list);
-	INIT_LIST_HEAD(&device->go_diskless.list);
 	INIT_LIST_HEAD(&device->md_sync_work.list);
 	INIT_LIST_HEAD(&device->start_resync_work.list);
 	INIT_LIST_HEAD(&device->bm_io_work.w.list);
 
 	device->resync_work.cb  = w_resync_timer;
 	device->unplug_work.cb  = w_send_write_hint;
-	device->go_diskless.cb  = w_go_diskless;
 	device->md_sync_work.cb = w_md_sync;
 	device->bm_io_work.w.cb = w_bitmap_io;
 	device->start_resync_work.cb = w_start_resync;
@@ -2011,7 +2008,6 @@ void drbd_device_cleanup(struct drbd_device *device)
 	D_ASSERT(device, list_empty(&first_peer_device(device)->connection->sender_work.q));
 	D_ASSERT(device, list_empty(&device->resync_work.list));
 	D_ASSERT(device, list_empty(&device->unplug_work.list));
-	D_ASSERT(device, list_empty(&device->go_diskless.list));
 
 	drbd_set_defaults(device);
 }
@@ -3531,61 +3527,6 @@ static int w_bitmap_io(struct drbd_work *w, int unused)
 	return 0;
 }
 
-void drbd_ldev_destroy(struct drbd_device *device)
-{
-	lc_destroy(device->resync);
-	device->resync = NULL;
-	lc_destroy(device->act_log);
-	device->act_log = NULL;
-	__no_warn(local,
-		drbd_free_ldev(device->ldev);
-		device->ldev = NULL;);
-
-	clear_bit(GO_DISKLESS, &device->flags);
-}
-
-static int w_go_diskless(struct drbd_work *w, int unused)
-{
-	struct drbd_device *device =
-		container_of(w, struct drbd_device, go_diskless);
-
-	D_ASSERT(device, device->state.disk == D_FAILED);
-	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
-	 * inc/dec it frequently. Once we are D_DISKLESS, no one will touch
-	 * the protected members anymore, though, so once put_ldev reaches zero
-	 * again, it will be safe to free them. */
-
-	/* Try to write changed bitmap pages, read errors may have just
-	 * set some bits outside the area covered by the activity log.
-	 *
-	 * If we have an IO error during the bitmap writeout,
-	 * we will want a full sync next time, just in case.
-	 * (Do we want a specific meta data flag for this?)
-	 *
-	 * If that does not make it to stable storage either,
-	 * we cannot do anything about that anymore.
-	 *
-	 * We still need to check if both bitmap and ldev are present, we may
-	 * end up here after a failed attach, before ldev was even assigned.
-	 */
-	if (device->bitmap && device->ldev) {
-		/* An interrupted resync or similar is allowed to recounts bits
-		 * while we detach.
-		 * Any modifications would not be expected anymore, though.
-		 */
-		if (drbd_bitmap_io_from_worker(device, drbd_bm_write,
-					"detach", BM_LOCKED_TEST_ALLOWED)) {
-			if (test_bit(WAS_READ_ERROR, &device->flags)) {
-				drbd_md_set_flag(device, MDF_FULL_SYNC);
-				drbd_md_sync(device);
-			}
-		}
-	}
-
-	drbd_force_state(device, NS(disk, D_DISKLESS));
-	return 0;
-}
-
 /**
  * drbd_queue_bitmap_io() - Queues an IO operation on the whole bitmap
  * @device:	DRBD device.
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ceebd31..628167d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1482,7 +1482,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * drbd_ldev_destroy is done already, we may end up here very fast,
 	 * e.g. if someone calls attach from the on-io-error handler,
 	 * to realize a "hot spare" feature (not that I'd recommend that) */
-	wait_event(device->misc_wait, !atomic_read(&device->local_cnt));
+	wait_event(device->misc_wait, !test_bit(GOING_DISKLESS, &device->flags));
 
 	/* make sure there is no leftover from previous force-detach attempts */
 	clear_bit(FORCE_DETACH, &device->flags);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index bafb62e..00bf490 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1813,10 +1813,9 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 	mutex_unlock(device->state_mutex);
 }
 
-static void update_on_disk_bitmap(struct drbd_device *device)
+static void update_on_disk_bitmap(struct drbd_device *device, bool resync_done)
 {
 	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
-	bool resync_done = test_and_clear_bit(RS_DONE, &device->flags);
 	device->rs_last_bcast = jiffies;
 
 	if (!get_ldev(device))
@@ -1832,7 +1831,87 @@ static void update_on_disk_bitmap(struct drbd_device *device)
 	put_ldev(device);
 }
 
-static void try_update_all_on_disk_bitmaps(struct drbd_connection *connection)
+static void drbd_ldev_destroy(struct drbd_device *device)
+{
+	lc_destroy(device->resync);
+	device->resync = NULL;
+	lc_destroy(device->act_log);
+	device->act_log = NULL;
+	__no_warn(local,
+		drbd_free_ldev(device->ldev);
+		device->ldev = NULL;);
+	clear_bit(GOING_DISKLESS, &device->flags);
+	wake_up(&device->misc_wait);
+}
+
+static void go_diskless(struct drbd_device *device)
+{
+	D_ASSERT(device, device->state.disk == D_FAILED);
+	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
+	 * inc/dec it frequently. Once we are D_DISKLESS, no one will touch
+	 * the protected members anymore, though, so once put_ldev reaches zero
+	 * again, it will be safe to free them. */
+
+	/* Try to write changed bitmap pages, read errors may have just
+	 * set some bits outside the area covered by the activity log.
+	 *
+	 * If we have an IO error during the bitmap writeout,
+	 * we will want a full sync next time, just in case.
+	 * (Do we want a specific meta data flag for this?)
+	 *
+	 * If that does not make it to stable storage either,
+	 * we cannot do anything about that anymore.
+	 *
+	 * We still need to check if both bitmap and ldev are present, we may
+	 * end up here after a failed attach, before ldev was even assigned.
+	 */
+	if (device->bitmap && device->ldev) {
+		/* An interrupted resync or similar is allowed to recounts bits
+		 * while we detach.
+		 * Any modifications would not be expected anymore, though.
+		 */
+		if (drbd_bitmap_io_from_worker(device, drbd_bm_write,
+					"detach", BM_LOCKED_TEST_ALLOWED)) {
+			if (test_bit(WAS_READ_ERROR, &device->flags)) {
+				drbd_md_set_flag(device, MDF_FULL_SYNC);
+				drbd_md_sync(device);
+			}
+		}
+	}
+
+	drbd_force_state(device, NS(disk, D_DISKLESS));
+}
+
+#define WORK_PENDING(work_bit, todo)	(todo & (1UL << work_bit))
+static void do_device_work(struct drbd_device *device, const unsigned long todo)
+{
+	if (WORK_PENDING(RS_DONE, todo) ||
+	    WORK_PENDING(RS_PROGRESS, todo))
+		update_on_disk_bitmap(device, WORK_PENDING(RS_DONE, todo));
+	if (WORK_PENDING(GO_DISKLESS, todo))
+		go_diskless(device);
+	if (WORK_PENDING(DESTROY_DISK, todo))
+		drbd_ldev_destroy(device);
+}
+
+#define DRBD_DEVICE_WORK_MASK	\
+	((1UL << GO_DISKLESS)	\
+	|(1UL << DESTROY_DISK)	\
+	|(1UL << RS_PROGRESS)	\
+	|(1UL << RS_DONE)	\
+	)
+
+static unsigned long get_work_bits(unsigned long *flags)
+{
+	unsigned long old, new;
+	do {
+		old = *flags;
+		new = old & ~DRBD_DEVICE_WORK_MASK;
+	} while (cmpxchg(flags, old, new) != old);
+	return old & DRBD_DEVICE_WORK_MASK;
+}
+
+static void do_unqueued_work(struct drbd_connection *connection)
 {
 	struct drbd_peer_device *peer_device;
 	int vnr;
@@ -1840,12 +1919,13 @@ static void try_update_all_on_disk_bitmaps(struct drbd_connection *connection)
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		if (!test_and_clear_bit(RS_PROGRESS, &device->flags))
+		unsigned long todo = get_work_bits(&device->flags);
+		if (!todo)
 			continue;
 
 		kref_get(&device->kref);
 		rcu_read_unlock();
-		update_on_disk_bitmap(device);
+		do_device_work(device, todo);
 		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
@@ -1927,7 +2007,7 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 			maybe_send_barrier(connection,
 					connection->send.current_epoch_nr + 1);
 
-		if (test_bit(CONN_RS_PROGRESS, &connection->flags))
+		if (test_bit(DEVICE_WORK_PENDING, &connection->flags))
 			break;
 
 		/* drbd_send() may have called flush_signals() */
@@ -1972,8 +2052,8 @@ int drbd_worker(struct drbd_thread *thi)
 		if (list_empty(&work_list))
 			wait_for_work(connection, &work_list);
 
-		if (test_and_clear_bit(CONN_RS_PROGRESS, &connection->flags))
-			try_update_all_on_disk_bitmaps(connection);
+		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags))
+			do_unqueued_work(connection);
 
 		if (signal_pending(current)) {
 			flush_signals(current);
@@ -1998,13 +2078,15 @@ int drbd_worker(struct drbd_thread *thi)
 	}
 
 	do {
+		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags))
+			do_unqueued_work(connection);
 		while (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
 			w->cb(w, 1);
 		}
 		dequeue_work_batch(&connection->sender_work, &work_list);
-	} while (!list_empty(&work_list));
+	} while (!list_empty(&work_list) || test_bit(DEVICE_WORK_PENDING, &connection->flags));
 
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
-- 
1.9.1

