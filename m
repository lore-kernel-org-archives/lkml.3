Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3CKQ3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:29:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:50682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab3CKQ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208";a="299229644"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: add hw start callback
Date: Mon, 11 Mar 2013 18:27:03 +0200
Message-Id: <1363019223-624-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363019223-624-1-git-send-email-tomas.winkler@intel.com>
References: <1363019223-624-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback wraps up hardware dependent details
of the hardware initialization.

This callback also contains host ready setting
so we can remove host_set_ready callback

In ME we switch to waiting on event so
we can streamline the initialization flow.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   | 45 ++++++++++++++++++++++++++++++++++++---------
 drivers/misc/mei/init.c    | 16 ++++++++++++++++
 drivers/misc/mei/mei_dev.h | 16 ++++++++++------
 3 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 4d4738a..0db071f 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -232,6 +232,38 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
 	return (hw->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
+static int mei_me_hw_ready_wait(struct mei_device *dev)
+{
+	int err;
+	if (mei_me_hw_is_ready(dev))
+		return 0;
+
+	mutex_unlock(&dev->device_lock);
+	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
+			dev->recvd_hw_ready, MEI_INTEROP_TIMEOUT);
+	mutex_lock(&dev->device_lock);
+	if (!err && !dev->recvd_hw_ready) {
+		dev_err(&dev->pdev->dev,
+			"wait hw ready failed. status = 0x%x\n", err);
+		return -ETIMEDOUT;
+	}
+
+	dev->recvd_hw_ready = false;
+	return 0;
+}
+
+static int mei_me_hw_start(struct mei_device *dev)
+{
+	int ret = mei_me_hw_ready_wait(dev);
+	if (ret)
+		return ret;
+	dev_dbg(&dev->pdev->dev, "hw is ready\n");
+
+	mei_me_host_set_ready(dev);
+	return ret;
+}
+
+
 /**
  * mei_hbuf_filled_slots - gets number of device filled buffer slots
  *
@@ -466,14 +498,9 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 		if (mei_hw_is_ready(dev)) {
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
 
-			mei_host_set_ready(dev);
-
-			dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
-			/* link is established * start sending messages.  */
-
-			dev->dev_state = MEI_DEV_INIT_CLIENTS;
+			dev->recvd_hw_ready = true;
+			wake_up_interruptible(&dev->wait_hw_ready);
 
-			mei_hbm_start_req(dev);
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		} else {
@@ -532,12 +559,12 @@ end:
 }
 static const struct mei_hw_ops mei_me_hw_ops = {
 
-	.host_set_ready = mei_me_host_set_ready,
 	.host_is_ready = mei_me_host_is_ready,
 
 	.hw_is_ready = mei_me_hw_is_ready,
 	.hw_reset = mei_me_hw_reset,
-	.hw_config  = mei_me_hw_config,
+	.hw_config = mei_me_hw_config,
+	.hw_start = mei_me_hw_start,
 
 	.intr_clear = mei_me_intr_clear,
 	.intr_enable = mei_me_intr_enable,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 3561799..1ab1fb1 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -22,6 +22,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "client.h"
 
 const char *mei_dev_state_str(int state)
@@ -47,6 +48,7 @@ void mei_device_init(struct mei_device *dev)
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
 	mutex_init(&dev->device_lock);
+	init_waitqueue_head(&dev->wait_hw_ready);
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
@@ -176,6 +178,20 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
 
+	if (!interrupts_enabled) {
+		dev_dbg(&dev->pdev->dev, "intr not enabled end of reset\n");
+		return;
+	}
+
+	mei_hw_start(dev);
+
+	dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
+	/* link is established * start sending messages.  */
+
+	dev->dev_state = MEI_DEV_INIT_CLIENTS;
+
+	mei_hbm_start_req(dev);
+
 	/* wake up all readings so they can be interrupted */
 	mei_cl_all_read_wakeup(dev);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 224c0e3..c17bced 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -213,11 +213,11 @@ struct mei_cl {
 
 /** struct mei_hw_ops
  *
- * @host_set_ready   - notify FW that host side is ready
  * @host_is_ready    - query for host readiness
 
  * @hw_is_ready      - query if hw is ready
  * @hw_reset         - reset hw
+ * @hw_start         - start hw after reset
  * @hw_config        - configure hw
 
  * @intr_clear       - clear pending interrupts
@@ -237,11 +237,11 @@ struct mei_cl {
  */
 struct mei_hw_ops {
 
-	void (*host_set_ready) (struct mei_device *dev);
 	bool (*host_is_ready) (struct mei_device *dev);
 
 	bool (*hw_is_ready) (struct mei_device *dev);
 	void (*hw_reset) (struct mei_device *dev, bool enable);
+	int  (*hw_start) (struct mei_device *dev);
 	void (*hw_config) (struct mei_device *dev);
 
 	void (*intr_clear) (struct mei_device *dev);
@@ -296,11 +296,14 @@ struct mei_device {
 	 */
 	struct mutex device_lock; /* device lock */
 	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
+
+	bool recvd_hw_ready;
 	bool recvd_msg;
 
 	/*
 	 * waiting queue for receive message from FW
 	 */
+	wait_queue_head_t wait_hw_ready;
 	wait_queue_head_t wait_recvd_msg;
 	wait_queue_head_t wait_stop_wd;
 
@@ -466,6 +469,11 @@ static inline void mei_hw_reset(struct mei_device *dev, bool enable)
 	dev->ops->hw_reset(dev, enable);
 }
 
+static inline void mei_hw_start(struct mei_device *dev)
+{
+	dev->ops->hw_start(dev);
+}
+
 static inline void mei_clear_interrupts(struct mei_device *dev)
 {
 	dev->ops->intr_clear(dev);
@@ -481,10 +489,6 @@ static inline void mei_disable_interrupts(struct mei_device *dev)
 	dev->ops->intr_disable(dev);
 }
 
-static inline void mei_host_set_ready(struct mei_device *dev)
-{
-	dev->ops->host_set_ready(dev);
-}
 static inline bool mei_host_is_ready(struct mei_device *dev)
 {
 	return dev->ops->host_is_ready(dev);
-- 
1.8.1.3

