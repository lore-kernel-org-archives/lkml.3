Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaICNDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:03:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62450 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaICNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:03:37 -0400
From: Imre Palik <imrep.amz@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: [PATCH] drbd: fix throttling on newly created DM backing devices
Date: Wed,  3 Sep 2014 15:02:36 +0200
Message-Id: <1409749356-5450-1-git-send-email-imrep.amz@gmail.com>
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
 drivers/block/drbd/drbd_receiver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9342b8d..511d2eb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2482,7 +2482,8 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 			atomic_read(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
-	    || !device->rs_last_events || curr_events - device->rs_last_events > 64) {
+		|| (curr_events && (!device->rs_last_events
+					|| curr_events - device->rs_last_events > 64))) {
 		unsigned long rs_left;
 		int i;
 
-- 
1.7.9.5

