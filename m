Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaHLRSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:18:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:34867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaHLRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:18:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,850,1400050800"; 
   d="scan'208";a="587103467"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: me: wait for hw ready non-interruptible
Date: Tue, 12 Aug 2014 20:16:03 +0300
Message-Id: <1407863763-8177-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We cannot handle user interrupt in context of hw initialization
so we only wait for time out which is reasonably short
Also we don't need to check error from wait, only flag value.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index a9a0d08..caf0da3 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -266,19 +266,14 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
 
 static int mei_me_hw_ready_wait(struct mei_device *dev)
 {
-	int err;
-
 	mutex_unlock(&dev->device_lock);
-	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
+	wait_event_timeout(dev->wait_hw_ready,
 			dev->recvd_hw_ready,
 			mei_secs_to_jiffies(MEI_HW_READY_TIMEOUT));
 	mutex_lock(&dev->device_lock);
-	if (!err && !dev->recvd_hw_ready) {
-		if (!err)
-			err = -ETIME;
-		dev_err(&dev->pdev->dev,
-			"wait hw ready failed. status = %d\n", err);
-		return err;
+	if (!dev->recvd_hw_ready) {
+		dev_err(&dev->pdev->dev, "wait hw ready failed\n");
+		return -ETIME;
 	}
 
 	dev->recvd_hw_ready = false;
@@ -664,7 +659,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
 
 			dev->recvd_hw_ready = true;
-			wake_up_interruptible(&dev->wait_hw_ready);
+			wake_up(&dev->wait_hw_ready);
 		} else {
 			dev_dbg(&dev->pdev->dev, "Spurious Interrupt\n");
 		}
-- 
1.9.3

