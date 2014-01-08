Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaAHSUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:20:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:58387 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbaAHSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:20:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,625,1384329600"; 
   d="scan'208";a="463655457"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc 2/4] mei: use hbm idle state to prevent spurious resets
Date: Wed,  8 Jan 2014 20:19:22 +0200
Message-Id: <1389205164-13553-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reset is caused by hbm protocol mismatch or timeout
we might end up in an endless reset loop and hbm protocol
will never sync

Cc: <stable@vger.kernel.org> 
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hbm.c       | 19 +++++++++++++++++++
 drivers/misc/mei/hbm.h       |  1 +
 drivers/misc/mei/init.c      | 12 ++++++++----
 drivers/misc/mei/interrupt.c | 25 +++++++++++++++----------
 4 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 8109b9a..836f92d 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -126,6 +126,17 @@ static bool is_treat_specially_client(struct mei_cl *cl,
 	return false;
 }
 
+/**
+ * mei_hbm_idle - set hbm to idle state
+ *
+ * @dev: the device structure
+ */
+void mei_hbm_idle(struct mei_device *dev)
+{
+	dev->init_clients_timer = 0;
+	dev->hbm_state = MEI_HBM_IDLE;
+}
+
 int mei_hbm_start_wait(struct mei_device *dev)
 {
 	int ret;
@@ -583,6 +594,14 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	mei_read_slots(dev, dev->rd_msg_buf, hdr->length);
 	mei_msg = (struct mei_bus_message *)dev->rd_msg_buf;
 
+	/* ignore spurious message and prevent reset nesting
+	 * hbm is put to idle during system reset
+	 */
+	if (dev->hbm_state == MEI_HBM_IDLE) {
+		dev_dbg(&dev->pdev->dev, "hbm: state is idle ignore spurious messages\n");
+		return 0;
+	}
+
 	switch (mei_msg->hbm_cmd) {
 	case HOST_START_RES_CMD:
 		dev_dbg(&dev->pdev->dev, "hbm: start: response message received.\n");
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index f2540ff..5f92188 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -49,6 +49,7 @@ static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 	hdr->reserved = 0;
 }
 
+void mei_hbm_idle(struct mei_device *dev);
 int mei_hbm_start_req(struct mei_device *dev);
 int mei_hbm_start_wait(struct mei_device *dev);
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 71cd209..2af08bf 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -129,14 +129,19 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
 
+	/* we're already in reset, cancel the init timer
+	 * if the reset was called due the hbm protocol error
+	 * we need to call it before hw start
+	 * so the hbm watchdog won't kick in
+	 */
+	mei_hbm_idle(dev);
+
 	ret = mei_hw_reset(dev, interrupts_enabled);
 	if (ret) {
 		dev_err(&dev->pdev->dev, "hw reset failed disabling the device\n");
 		interrupts_enabled = false;
-		dev->dev_state = MEI_DEV_DISABLED;
 	}
 
-	dev->hbm_state = MEI_HBM_IDLE;
 
 	if (dev->dev_state != MEI_DEV_INITIALIZING &&
 	    dev->dev_state != MEI_DEV_POWER_UP) {
@@ -161,8 +166,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 	}
 
-	/* we're already in reset, cancel the init timer */
-	dev->init_clients_timer = 0;
 
 	dev->me_clients_num = 0;
 	dev->rd_msg_hdr = 0;
@@ -170,6 +173,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	if (!interrupts_enabled) {
 		dev_dbg(&dev->pdev->dev, "intr not enabled end of reset\n");
+		dev->dev_state = MEI_DEV_DISABLED;
 		return;
 	}
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index bbb61be..206dbe9 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -537,7 +537,6 @@ EXPORT_SYMBOL_GPL(mei_irq_write_handler);
  *
  * @work: pointer to the work_struct structure
  *
- * NOTE: This function is called by timer interrupt work
  */
 void mei_timer(struct work_struct *work)
 {
@@ -552,18 +551,24 @@ void mei_timer(struct work_struct *work)
 
 
 	mutex_lock(&dev->device_lock);
-	if (dev->dev_state != MEI_DEV_ENABLED) {
-		if (dev->dev_state == MEI_DEV_INIT_CLIENTS) {
-			if (dev->init_clients_timer) {
-				if (--dev->init_clients_timer == 0) {
-					dev_err(&dev->pdev->dev, "reset: init clients timeout hbm_state = %d.\n",
-						dev->hbm_state);
-					mei_reset(dev, 1);
-				}
+
+	/* Catch interrupt stalls during HBM init handshake */
+	if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
+	    dev->hbm_state != MEI_HBM_IDLE) {
+
+		if (dev->init_clients_timer) {
+			if (--dev->init_clients_timer == 0) {
+				dev_err(&dev->pdev->dev, "timer: init clients timeout hbm_state = %d.\n",
+					dev->hbm_state);
+				mei_reset(dev, 1);
+				goto out;
 			}
 		}
-		goto out;
 	}
+
+	if (dev->dev_state != MEI_DEV_ENABLED)
+		goto out;
+
 	/*** connect/disconnect timeouts ***/
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
 		if (cl_pos->timer_count) {
-- 
1.8.4.2

