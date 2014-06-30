Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaF3PyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:54:06 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50030 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbaF3PxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/18] drbd: close race when detaching from disk
Date: Mon, 30 Jun 2014 17:53:04 +0200
Message-Id: <1404143587-24344-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
IP: bd_release+0x21/0x70
Process drbd_w_t7146
Call Trace:
 close_bdev_exclusive
 drbd_free_ldev		[drbd]
 drbd_ldev_destroy	[drbd]
 w_after_state_ch	[drbd]

Race probably went like this:
  state.disk = D_FAILED

... first one to hit zero during D_FAILED:
   put_ldev() /* ----------------> 0 */
     i = atomic_dec_return()
     if (i == 0)
       if (state.disk == D_FAILED)
         schedule_work(go_diskless)
                                /* 1 <------ */ get_ldev_if_state()
   go_diskless()
      do_some_pre_cleanup()                     corresponding put_ldev():
      force_state(D_DISKLESS)   /* 0 <------ */ i = atomic_dec_return()
                                                if (i == 0)
        atomic_inc() /* ---------> 1 */
        state.disk = D_DISKLESS
        schedule_work(after_state_ch)           /* execution pre-empted by IRQ ? */

   after_state_ch()
     put_ldev()
       i = atomic_dec_return()  /* 0 */
       if (i == 0)
         if (state.disk == D_DISKLESS)            if (state.disk == D_DISKLESS)
           drbd_ldev_destroy()                      drbd_ldev_destroy();

Trying to fix this by checking the disk state *before* the
atomic_dec_return(), which implies memory barriers, and by inserting
extra memory barriers around the state assignment in __drbd_set_state().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |  9 +++++++--
 drivers/block/drbd/drbd_state.c | 11 +++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a16f9ae..a0ffc19 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1946,6 +1946,11 @@ static inline bool is_sync_state(enum drbd_conns connection_state)
 
 static inline void put_ldev(struct drbd_device *device)
 {
+	enum drbd_disk_state ds = device->state.disk;
+	/* We must check the state *before* the atomic_dec becomes visible,
+	 * or we have a theoretical race where someone hitting zero,
+	 * while state still D_FAILED, will then see D_DISKLESS in the
+	 * condition below and calling into destroy, where he must not, yet. */
 	int i = atomic_dec_return(&device->local_cnt);
 
 	/* This may be called from some endio handler,
@@ -1954,10 +1959,10 @@ static inline void put_ldev(struct drbd_device *device)
 	__release(local);
 	D_ASSERT(device, i >= 0);
 	if (i == 0) {
-		if (device->state.disk == D_DISKLESS)
+		if (ds == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
 			drbd_ldev_destroy(device);
-		if (device->state.disk == D_FAILED) {
+		if (ds == D_FAILED) {
 			/* all application IO references gone. */
 			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
 				drbd_queue_work(&first_peer_device(device)->connection->sender_work,
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 1bddd6c..6629f46 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -958,7 +958,6 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	enum drbd_state_rv rv = SS_SUCCESS;
 	enum sanitize_state_warnings ssw;
 	struct after_state_chg_work *ascw;
-	bool did_remote, should_do_remote;
 
 	os = drbd_read_state(device);
 
@@ -1010,18 +1009,22 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	    (os.disk != D_DISKLESS && ns.disk == D_DISKLESS))
 		atomic_inc(&device->local_cnt);
 
-	did_remote = drbd_should_do_remote(device->state);
 	if (!is_sync_state(os.conn) && is_sync_state(ns.conn))
 		clear_bit(RS_DONE, &device->flags);
 
+	/* changes to local_cnt and device flags should be visible before
+	 * changes to state, which again should be visible before anything else
+	 * depending on that change happens. */
+	smp_wmb();
 	device->state.i = ns.i;
-	should_do_remote = drbd_should_do_remote(device->state);
 	device->resource->susp = ns.susp;
 	device->resource->susp_nod = ns.susp_nod;
 	device->resource->susp_fen = ns.susp_fen;
+	smp_wmb();
 
 	/* put replicated vs not-replicated requests in seperate epochs */
-	if (did_remote != should_do_remote)
+	if (drbd_should_do_remote((union drbd_dev_state)os.i) !=
+	    drbd_should_do_remote((union drbd_dev_state)ns.i))
 		start_new_tl_epoch(connection);
 
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
-- 
1.9.1

