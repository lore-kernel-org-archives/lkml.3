Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaBQNPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:15:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:45352 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaBQNPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:15:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852953"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 11/11] mei: wd: fix stop completion failure
Date: Mon, 17 Feb 2014 15:13:27 +0200
Message-Id: <1392642807-8878-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running Documentation/watchdog/src/watchdog-simple.c
and quiting by Ctrl-C, fallowing error is displayed:
mei_me 0000:00:16.0: wd: stop failed to complete ret=-512.

The whatchdog core framework is not able to propagate
-ESYSRESTART or -EINTR. Also There is no much sense in
restarting the close system call so instead of using
wait_event_interruptible_timeout we can use wait_event_timeout
with reasonable 10 msecs timeout.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |  2 +-
 drivers/misc/mei/wd.c        | 32 +++++++++++++++++---------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 834220a..5aab335 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -474,7 +474,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 	if (dev->wd_state == MEI_WD_STOPPING) {
 		dev->wd_state = MEI_WD_IDLE;
-		wake_up_interruptible(&dev->wait_stop_wd);
+		wake_up(&dev->wait_stop_wd);
 	}
 
 	if (mei_cl_is_connected(&dev->wd_cl)) {
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 13bb7a9..e084adf 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -155,9 +155,11 @@ int mei_wd_send(struct mei_device *dev)
  * @dev: the device structure
  * @preserve: indicate if to keep the timeout value
  *
- * returns 0 if success,
- *	-EIO when message send fails
+ * returns 0 if success
+ * on error:
+ *	-EIO    when message send fails
  *	-EINVAL when invalid message is to be sent
+ *	-ETIME  on message timeout
  */
 int mei_wd_stop(struct mei_device *dev)
 {
@@ -173,12 +175,12 @@ int mei_wd_stop(struct mei_device *dev)
 
 	ret = mei_cl_flow_ctrl_creds(&dev->wd_cl);
 	if (ret < 0)
-		goto out;
+		goto err;
 
 	if (ret && mei_hbuf_acquire(dev)) {
 		ret = mei_wd_send(dev);
 		if (ret)
-			goto out;
+			goto err;
 		dev->wd_pending = false;
 	} else {
 		dev->wd_pending = true;
@@ -186,21 +188,21 @@ int mei_wd_stop(struct mei_device *dev)
 
 	mutex_unlock(&dev->device_lock);
 
-	ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
-					dev->wd_state == MEI_WD_IDLE,
-					msecs_to_jiffies(MEI_WD_STOP_TIMEOUT));
+	ret = wait_event_timeout(dev->wait_stop_wd,
+				dev->wd_state == MEI_WD_IDLE,
+				msecs_to_jiffies(MEI_WD_STOP_TIMEOUT));
 	mutex_lock(&dev->device_lock);
-	if (dev->wd_state == MEI_WD_IDLE) {
-		dev_dbg(&dev->pdev->dev, "wd: stop completed ret=%d.\n", ret);
-		ret = 0;
-	} else {
-		if (!ret)
-			ret = -ETIME;
+	if (dev->wd_state != MEI_WD_IDLE) {
+		/* timeout */
+		ret = -ETIME;
 		dev_warn(&dev->pdev->dev,
 			"wd: stop failed to complete ret=%d.\n", ret);
+		goto err;
 	}
-
-out:
+	dev_dbg(&dev->pdev->dev, "wd: stop completed after %u msec\n",
+			MEI_WD_STOP_TIMEOUT - jiffies_to_msecs(ret));
+	return 0;
+err:
 	return ret;
 }
 
-- 
1.8.5.3

