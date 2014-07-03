Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaGCIuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:50:23 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45906 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaGCInU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/23] drbd: improve throttling decisions of background resynchronisation
Date: Thu,  3 Jul 2014 10:42:59 +0200
Message-Id: <1404376995-4877-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Background resynchronisation does some "side-stepping", or throttles
itself, if it detects application IO activity, and the current resync
rate estimate is above the configured "cmin-rate".

What was not detected: if there is no application IO,
because it blocks on activity log transactions.

Introduce a new atomic_t ap_actlog_cnt, tracking such blocked requests,
and count non-zero as application IO activity.
This counter is exposed at proc_details level 2 and above.

Also make sure to release the currently locked resync extent
if we side-step due to such voluntary throttling.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   | 29 ++++++++++++++++++++++++++---
 drivers/block/drbd/drbd_int.h      |  4 +++-
 drivers/block/drbd/drbd_main.c     |  1 +
 drivers/block/drbd/drbd_proc.c     |  3 +++
 drivers/block/drbd/drbd_receiver.c | 19 ++++++++++++-------
 drivers/block/drbd/drbd_req.c      |  4 ++++
 drivers/block/drbd/drbd_worker.c   |  9 ++-------
 7 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index d7e8066..6ce5c76 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -991,6 +991,15 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
 	int i;
+	bool throttle = drbd_rs_should_slow_down(device, sector, true);
+
+	/* If we need to throttle, a half-locked (only marked BME_NO_WRITES,
+	 * not yet BME_LOCKED) extent needs to be kicked out explicitly if we
+	 * need to throttle. There is at most one such half-locked extent,
+	 * which is remembered in resync_wenr. */
+
+	if (throttle && device->resync_wenr != enr)
+		return -EAGAIN;
 
 	spin_lock_irq(&device->al_lock);
 	if (device->resync_wenr != LC_FREE && device->resync_wenr != enr) {
@@ -1014,8 +1023,10 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 			D_ASSERT(device, test_bit(BME_NO_WRITES, &bm_ext->flags));
 			clear_bit(BME_NO_WRITES, &bm_ext->flags);
 			device->resync_wenr = LC_FREE;
-			if (lc_put(device->resync, &bm_ext->lce) == 0)
+			if (lc_put(device->resync, &bm_ext->lce) == 0) {
+				bm_ext->flags = 0;
 				device->resync_locked--;
+			}
 			wake_up(&device->al_wait);
 		} else {
 			drbd_alert(device, "LOGIC BUG\n");
@@ -1077,8 +1088,20 @@ proceed:
 	return 0;
 
 try_again:
-	if (bm_ext)
-		device->resync_wenr = enr;
+	if (bm_ext) {
+		if (throttle) {
+			D_ASSERT(device, !test_bit(BME_LOCKED, &bm_ext->flags));
+			D_ASSERT(device, test_bit(BME_NO_WRITES, &bm_ext->flags));
+			clear_bit(BME_NO_WRITES, &bm_ext->flags);
+			device->resync_wenr = LC_FREE;
+			if (lc_put(device->resync, &bm_ext->lce) == 0) {
+				bm_ext->flags = 0;
+				device->resync_locked--;
+			}
+			wake_up(&device->al_wait);
+		} else
+			device->resync_wenr = enr;
+	}
 	spin_unlock_irq(&device->al_lock);
 	return -EAGAIN;
 }
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index fa010ea..81f4af4 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -797,6 +797,7 @@ struct drbd_device {
 	unsigned int al_writ_cnt;
 	unsigned int bm_writ_cnt;
 	atomic_t ap_bio_cnt;	 /* Requests we need to complete */
+	atomic_t ap_actlog_cnt;  /* Requests waiting for activity log */
 	atomic_t ap_pending_cnt; /* AP data packets on the wire, ack expected */
 	atomic_t rs_pending_cnt; /* RS request/data packets on the wire */
 	atomic_t unacked_cnt;	 /* Need to send replies for */
@@ -1454,7 +1455,8 @@ extern void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req);
 extern int drbd_receiver(struct drbd_thread *thi);
 extern int drbd_asender(struct drbd_thread *thi);
 extern bool drbd_rs_c_min_rate_throttle(struct drbd_device *device);
-extern bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector);
+extern bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector,
+		bool throttle_if_app_is_waiting);
 extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5886596..ad7c0e8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1909,6 +1909,7 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	drbd_set_defaults(device);
 
 	atomic_set(&device->ap_bio_cnt, 0);
+	atomic_set(&device->ap_actlog_cnt, 0);
 	atomic_set(&device->ap_pending_cnt, 0);
 	atomic_set(&device->rs_pending_cnt, 0);
 	atomic_set(&device->unacked_cnt, 0);
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 9059d7b..06e6147 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -335,6 +335,9 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			lc_seq_printf_stats(seq, device->act_log);
 			put_ldev(device);
 		}
+
+		if (proc_details >= 2)
+			seq_printf(seq, "\tblocked on activity log: %d\n", atomic_read(&device->ap_actlog_cnt));
 	}
 	rcu_read_unlock();
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7a1078d..0d3cbd8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2417,13 +2417,14 @@ out_interrupted:
  * The current sync rate used here uses only the most recent two step marks,
  * to have a short time average so we can react faster.
  */
-bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector)
+bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector,
+		bool throttle_if_app_is_waiting)
 {
 	struct lc_element *tmp;
-	bool throttle = true;
+	bool throttle = drbd_rs_c_min_rate_throttle(device);
 
-	if (!drbd_rs_c_min_rate_throttle(device))
-		return false;
+	if (!throttle || throttle_if_app_is_waiting)
+		return throttle;
 
 	spin_lock_irq(&device->al_lock);
 	tmp = lc_find(device->resync, BM_SECT_TO_EXT(sector));
@@ -2431,7 +2432,8 @@ bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector)
 		struct bm_extent *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 		if (test_bit(BME_PRIORITY, &bm_ext->flags))
 			throttle = false;
-		/* Do not slow down if app IO is already waiting for this extent */
+		/* Do not slow down if app IO is already waiting for this extent,
+		 * and our progress is necessary for application IO to complete. */
 	}
 	spin_unlock_irq(&device->al_lock);
 
@@ -2456,7 +2458,9 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 		      (int)part_stat_read(&disk->part0, sectors[1]) -
 			atomic_read(&device->rs_sect_ev);
-	if (!device->rs_last_events || curr_events - device->rs_last_events > 64) {
+
+	if (atomic_read(&device->ap_actlog_cnt)
+	    || !device->rs_last_events || curr_events - device->rs_last_events > 64) {
 		unsigned long rs_left;
 		int i;
 
@@ -2646,7 +2650,8 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 	 * we would also throttle its application reads.
 	 * In that case, throttling is done on the SyncTarget only.
 	 */
-	if (device->state.peer != R_PRIMARY && drbd_rs_should_slow_down(device, sector))
+	if (device->state.peer != R_PRIMARY
+	&& drbd_rs_should_slow_down(device, sector, false))
 		schedule_timeout_uninterruptible(HZ/10);
 	if (drbd_rs_begin_io(device, sector))
 		goto out_free_e;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3f6a6ed..74ebef1 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1218,6 +1218,7 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 	if (rw == WRITE && req->private_bio && req->i.size
 	&& !test_bit(AL_SUSPENDED, &device->flags)) {
 		if (!drbd_al_begin_io_fastpath(device, &req->i)) {
+			atomic_inc(&device->ap_actlog_cnt);
 			drbd_queue_write(device, req);
 			return NULL;
 		}
@@ -1354,6 +1355,7 @@ static void submit_fast_path(struct drbd_device *device, struct list_head *incom
 
 			req->rq_state |= RQ_IN_ACT_LOG;
 			req->in_actlog_jif = jiffies;
+			atomic_dec(&device->ap_actlog_cnt);
 		}
 
 		list_del_init(&req->tl_requests);
@@ -1439,6 +1441,7 @@ skip_fast_path:
 		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
 			req->rq_state |= RQ_IN_ACT_LOG;
 			req->in_actlog_jif = jiffies;
+			atomic_dec(&device->ap_actlog_cnt);
 			list_del_init(&req->tl_requests);
 			drbd_send_and_submit(device, req);
 		}
@@ -1454,6 +1457,7 @@ skip_fast_path:
 			if (!was_cold) {
 				req->rq_state |= RQ_IN_ACT_LOG;
 				req->in_actlog_jif = jiffies;
+				atomic_dec(&device->ap_actlog_cnt);
 				/* Corresponding extent was hot after all? */
 				drbd_send_and_submit(device, req);
 			} else {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 0ff8f46..48975a2 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -395,9 +395,6 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	if (!get_ldev(device))
 		return -EIO;
 
-	if (drbd_rs_should_slow_down(device, sector))
-		goto defer;
-
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
 	peer_req = drbd_alloc_peer_req(peer_device, ID_SYNCER /* unused */, sector,
@@ -651,8 +648,7 @@ next_sector:
 
 		sector = BM_BIT_TO_SECT(bit);
 
-		if (drbd_rs_should_slow_down(device, sector) ||
-		    drbd_try_rs_begin_io(device, sector)) {
+		if (drbd_try_rs_begin_io(device, sector)) {
 			device->bm_resync_fo = bit;
 			goto requeue;
 		}
@@ -783,8 +779,7 @@ static int make_ov_request(struct drbd_device *device, int cancel)
 
 		size = BM_BLOCK_SIZE;
 
-		if (drbd_rs_should_slow_down(device, sector) ||
-		    drbd_try_rs_begin_io(device, sector)) {
+		if (drbd_try_rs_begin_io(device, sector)) {
 			device->ov_position = sector;
 			goto requeue;
 		}
-- 
1.9.1

