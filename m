Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaHULbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:31:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:16496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbaHULbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969526"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/14] mei: wait for hbm start non-interruptible
Date: Thu, 21 Aug 2014 14:29:19 +0300
Message-Id: <1408620563-25834-10-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We cannot handle user interrupt in context of hbm start
so we only wait for time out which is reasonably short.

1. Add kdoc
2. Rename state to better reflect its function
3. Simplify wait condition and rename
   wait_recvd_msg to wait_hbm_start

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c     | 26 ++++++++++++++++----------
 drivers/misc/mei/hbm.h     |  6 ++++--
 drivers/misc/mei/init.c    |  2 +-
 drivers/misc/mei/mei_dev.h |  2 +-
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index cda9141..2968b52 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -172,21 +172,27 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
 		cl->me_client_id == cmd->me_addr;
 }
 
-
+/**
+ * mei_hbm_start_wait - wait for start response message.
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success and < 0 on failure
+ */
 int mei_hbm_start_wait(struct mei_device *dev)
 {
 	int ret;
-	if (dev->hbm_state > MEI_HBM_START)
+
+	if (dev->hbm_state > MEI_HBM_STARTING)
 		return 0;
 
 	mutex_unlock(&dev->device_lock);
-	ret = wait_event_interruptible_timeout(dev->wait_recvd_msg,
-			dev->hbm_state == MEI_HBM_IDLE ||
-			dev->hbm_state >= MEI_HBM_STARTED,
+	ret = wait_event_timeout(dev->wait_hbm_start,
+			dev->hbm_state != MEI_HBM_STARTING,
 			mei_secs_to_jiffies(MEI_HBM_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
-	if (ret <= 0 && (dev->hbm_state <= MEI_HBM_START)) {
+	if (ret == 0 && (dev->hbm_state <= MEI_HBM_STARTING)) {
 		dev->hbm_state = MEI_HBM_IDLE;
 		dev_err(&dev->pdev->dev, "waiting for mei start failed\n");
 		return -ETIME;
@@ -227,7 +233,7 @@ int mei_hbm_start_req(struct mei_device *dev)
 		return ret;
 	}
 
-	dev->hbm_state = MEI_HBM_START;
+	dev->hbm_state = MEI_HBM_STARTING;
 	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
 	return 0;
 }
@@ -726,7 +732,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		}
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
-		    dev->hbm_state != MEI_HBM_START) {
+		    dev->hbm_state != MEI_HBM_STARTING) {
 			dev_err(&dev->pdev->dev, "hbm: start: state mismatch, [%d, %d]\n",
 				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
@@ -739,7 +745,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EIO;
 		}
 
-		wake_up_interruptible(&dev->wait_recvd_msg);
+		wake_up(&dev->wait_hbm_start);
 		break;
 
 	case CLIENT_CONNECT_RES_CMD:
@@ -866,7 +872,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		dev_dbg(&dev->pdev->dev, "hbm: stop request: message received\n");
 		dev->hbm_state = MEI_HBM_STOPPED;
 		if (mei_hbm_stop_req(dev)) {
-			dev_err(&dev->pdev->dev, "hbm: start: failed to send stop request\n");
+			dev_err(&dev->pdev->dev, "hbm: stop request: failed to send stop request\n");
 			return -EIO;
 		}
 		break;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index 683eb28..80920f0 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -25,13 +25,15 @@ struct mei_cl;
  * enum mei_hbm_state - host bus message protocol state
  *
  * @MEI_HBM_IDLE : protocol not started
- * @MEI_HBM_START : start request message was sent
+ * @MEI_HBM_STARTING : start request message was sent
+ * @MEI_HBM_STARTED : start reply message was received
  * @MEI_HBM_ENUM_CLIENTS : enumeration request was sent
  * @MEI_HBM_CLIENT_PROPERTIES : acquiring clients properties
+ * @MEI_HBM_STOPPED : stopping exchange
  */
 enum mei_hbm_state {
 	MEI_HBM_IDLE = 0,
-	MEI_HBM_START,
+	MEI_HBM_STARTING,
 	MEI_HBM_STARTED,
 	MEI_HBM_ENUM_CLIENTS,
 	MEI_HBM_CLIENT_PROPERTIES,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 73ccbb6..9f635be 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -360,7 +360,7 @@ void mei_device_init(struct mei_device *dev, const struct mei_cfg *cfg)
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_hw_ready);
 	init_waitqueue_head(&dev->wait_pg);
-	init_waitqueue_head(&dev->wait_recvd_msg);
+	init_waitqueue_head(&dev->wait_hbm_start);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
 	dev->reset_count = 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 0922ce8..79124ae 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -443,7 +443,7 @@ struct mei_device {
 	 */
 	wait_queue_head_t wait_hw_ready;
 	wait_queue_head_t wait_pg;
-	wait_queue_head_t wait_recvd_msg;
+	wait_queue_head_t wait_hbm_start;
 	wait_queue_head_t wait_stop_wd;
 
 	/*
-- 
1.9.3

