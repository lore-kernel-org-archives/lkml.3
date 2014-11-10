Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaKJQV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:21:27 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:54049 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaKJQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:21:19 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 4/7] drbd: fix resync throttling initialization
Date: Mon, 10 Nov 2014 17:21:12 +0100
Message-Id: <1415636475-7883-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
References: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If for some reason DRBD resync was the only activity on a backend
device, drbd_rs_c_min_rate_throttle() would mistakenly decide that it is
still initialization time, and keep throttling the resync.

This patch explicitly initializes ->rs_last_events to the current
backend event counters, and drops the rs_last_events == 0 from the
throttle condition.

Reported-by: Mikhail Sugakov <msugakov@amazon.de>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 2 +-
 drivers/block/drbd/drbd_state.c    | 1 -
 drivers/block/drbd/drbd_worker.c   | 5 ++++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6960fb0..d169b4a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2482,7 +2482,7 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 			atomic_read(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
-	    || !device->rs_last_events || curr_events - device->rs_last_events > 64) {
+	    || curr_events - device->rs_last_events > 64) {
 		unsigned long rs_left;
 		int i;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 4529d92..2d7dd26 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1099,7 +1099,6 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 		set_ov_position(device, ns.conn);
 		device->rs_start = now;
-		device->rs_last_events = 0;
 		device->rs_last_sect_ev = 0;
 		device->ov_last_oos_size = 0;
 		device->ov_last_oos_start = 0;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d2d1f97..d0fae55 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1592,11 +1592,15 @@ void drbd_resync_after_changed(struct drbd_device *device)
 
 void drbd_rs_controller_reset(struct drbd_device *device)
 {
+	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
 	struct fifo_buffer *plan;
 
 	atomic_set(&device->rs_sect_in, 0);
 	atomic_set(&device->rs_sect_ev, 0);
 	device->rs_in_flight = 0;
+	device->rs_last_events =
+		(int)part_stat_read(&disk->part0, sectors[0]) +
+		(int)part_stat_read(&disk->part0, sectors[1]);
 
 	/* Updating the RCU protected object in place is necessary since
 	   this function gets called from atomic context.
@@ -1743,7 +1747,6 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		device->rs_failed    = 0;
 		device->rs_paused    = 0;
 		device->rs_same_csum = 0;
-		device->rs_last_events = 0;
 		device->rs_last_sect_ev = 0;
 		device->rs_total     = tw;
 		device->rs_start     = now;
-- 
1.9.1

