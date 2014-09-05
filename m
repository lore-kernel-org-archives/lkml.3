Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaIESlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:41:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53235 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIESle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:41:34 -0400
From: Imre Palik <imrep.amz@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: [PATCH v3] drbd: fix throttling on newly created DM backing devices
Date: Fri,  5 Sep 2014 20:41:18 +0200
Message-Id: <1409942478-29135-1-git-send-email-imrep.amz@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Palik, Imre" <imrep@amazon.de>

If the drbd backing device is a new device mapper device (e.g., a
dm-linear mapping of an existing block device that contains data), the
counters are initially 0 even though the device contains useful
data. This causes throttling until something accesses the drbd device
or the backing device.

The patch disables throttling, as long as only resync is responsible
for disk activity on a freshly created device.

Reported-by: Mikhail Sugakov <msugakov@amazon.de>
Cc: Matt Wilson <msw@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
---
 drivers/block/drbd/drbd_int.h      |    4 ++--
 drivers/block/drbd/drbd_receiver.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1a00001..298b1dc 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -960,8 +960,8 @@ struct drbd_device {
 	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
 	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
 	int rs_last_sect_ev; /* counter to compare with */
-	int rs_last_events;  /* counter of read or write "events" (unit sectors)
-			      * on the lower level device when we last looked. */
+	unsigned int rs_last_events;  /* counter of read or write "events" (unit sectors)
+				       * on the lower level device when we last looked. */
 	int c_sync_rate; /* current resync rate after syncer throttle magic */
 	struct fifo_buffer *rs_plan_s; /* correction values of resync planer (RCU, connection->conn_update) */
 	int rs_in_flight; /* resync sectors in flight (to proxy, in proxy and from proxy) */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9342b8d..147c917 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2467,7 +2467,7 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
 	unsigned long db, dt, dbdt;
 	unsigned int c_min_rate;
-	int curr_events;
+	unsigned int curr_events;
 
 	rcu_read_lock();
 	c_min_rate = rcu_dereference(device->ldev->disk_conf)->c_min_rate;
@@ -2477,12 +2477,12 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 	if (c_min_rate == 0)
 		return false;
 
-	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
-		      (int)part_stat_read(&disk->part0, sectors[1]) -
-			atomic_read(&device->rs_sect_ev);
+	curr_events = (unsigned int)part_stat_read(&disk->part0, sectors[0]) +
+		      (unsigned int)part_stat_read(&disk->part0, sectors[1]) -
+		(unsigned int)atomic_read(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
-	    || !device->rs_last_events || curr_events - device->rs_last_events > 64) {
+		|| curr_events - device->rs_last_events > 64) {
 		unsigned long rs_left;
 		int i;
 
-- 
1.7.9.5

