Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaAKWhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 17:37:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:47204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaAKWhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 17:37:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="465255140"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc 3/4 V2] mei: revamp mei reset state machine
Date: Sun, 12 Jan 2014 00:36:09 +0200
Message-Id: <1389479770-8524-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. MEI_DEV_RESETTING device state spans only hardware reset flow
while starting dev state is saved into a local variable for further
reference, this let us to reduce big if statements in case we
are trying to avoid nested resets

2. During initializations if the reset ended in MEI_DEV_DISABLED device
state we bail out with -ENODEV

3. Remove redundant interrupts_enabled parameter as this
 can be deduced from the starting dev_state

4. mei_reset propagates error code to the caller

5. Add mei_restart function to wrap the pci resume

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
V2: rebased

 drivers/misc/mei/hbm.c       |   2 +-
 drivers/misc/mei/hw-me.c     |  10 +--
 drivers/misc/mei/init.c      | 209 ++++++++++++++++++++++++++-----------------
 drivers/misc/mei/interrupt.c |  13 +--
 drivers/misc/mei/mei_dev.h   |   3 +-
 drivers/misc/mei/pci-me.c    |  10 +--
 6 files changed, 143 insertions(+), 104 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 8520cdf..28cd74c 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -763,7 +763,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		dev->dev_state = MEI_DEV_DISABLED;
+		dev->dev_state = MEI_DEV_POWER_DOWN;
 		dev_info(&dev->pdev->dev, "hbm: stop response: resetting.\n");
 		/* force the reset */
 		return -EPROTO;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6c07623..6f656c0 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -185,7 +185,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
-	if (dev->dev_state == MEI_DEV_POWER_DOWN)
+	if (intr_enable == false)
 		mei_me_hw_reset_release(dev);
 
 	return 0;
@@ -482,11 +482,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 		mei_clear_interrupts(dev);
 
 	/* check if ME wants a reset */
-	if (!mei_hw_is_ready(dev) &&
-	    dev->dev_state != MEI_DEV_RESETTING &&
-	    dev->dev_state != MEI_DEV_INITIALIZING &&
-	    dev->dev_state != MEI_DEV_POWER_DOWN &&
-	    dev->dev_state != MEI_DEV_POWER_UP) {
+	if (!mei_hw_is_ready(dev) && dev->dev_state != MEI_DEV_RESETTING) {
 		dev_warn(&dev->pdev->dev, "FW not ready: resetting.\n");
 		schedule_work(&dev->reset_work);
 		goto end;
@@ -514,7 +510,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			break;
 		dev_dbg(&dev->pdev->dev, "slots to read = %08x\n", slots);
 		rets = mei_irq_read_handler(dev, &complete_list, &slots);
-		if (rets) {
+		if (rets && dev->dev_state != MEI_DEV_RESETTING) {
 			schedule_work(&dev->reset_work);
 			goto end;
 		}
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index c47fa27..059133d 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -43,62 +43,13 @@ const char *mei_dev_state_str(int state)
 #undef MEI_DEV_STATE
 }
 
-/**
- * mei_start - initializes host and fw to start work.
- *
- * @dev: the device structure
- *
- * returns 0 on success, <0 on failure.
- */
-int mei_start(struct mei_device *dev)
-{
-	mutex_lock(&dev->device_lock);
-
-	/* acknowledge interrupt and stop interupts */
-	mei_clear_interrupts(dev);
-
-	mei_hw_config(dev);
-
-	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
-
-	mei_reset(dev, 1);
-
-	if (mei_hbm_start_wait(dev)) {
-		dev_err(&dev->pdev->dev, "HBM haven't started");
-		goto err;
-	}
-
-	if (!mei_host_is_ready(dev)) {
-		dev_err(&dev->pdev->dev, "host is not ready.\n");
-		goto err;
-	}
-
-	if (!mei_hw_is_ready(dev)) {
-		dev_err(&dev->pdev->dev, "ME is not ready.\n");
-		goto err;
-	}
-
-	if (!mei_hbm_version_is_supported(dev)) {
-		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
-		goto err;
-	}
-
-	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
-
-	mutex_unlock(&dev->device_lock);
-	return 0;
-err:
-	dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
-	dev->dev_state = MEI_DEV_DISABLED;
-	mutex_unlock(&dev->device_lock);
-	return -ENODEV;
-}
-EXPORT_SYMBOL_GPL(mei_start);
 
 /**
  * mei_cancel_work. Cancel mei background jobs
  *
  * @dev: the device structure
+ *
+ * returns 0 on success or < 0 if the reset hasn't succeeded
  */
 void mei_cancel_work(struct mei_device *dev)
 {
@@ -113,21 +64,19 @@ EXPORT_SYMBOL_GPL(mei_cancel_work);
  * mei_reset - resets host and fw.
  *
  * @dev: the device structure
- * @interrupts_enabled: if interrupt should be enabled after reset.
  */
-void mei_reset(struct mei_device *dev, int interrupts_enabled)
+int mei_reset(struct mei_device *dev)
 {
-	bool unexpected;
+	enum mei_dev_state state = dev->dev_state;
+	bool interrupts_enabled;
 	int ret;
 
-	unexpected = (dev->dev_state != MEI_DEV_INITIALIZING &&
-			dev->dev_state != MEI_DEV_DISABLED &&
-			dev->dev_state != MEI_DEV_POWER_DOWN &&
-			dev->dev_state != MEI_DEV_POWER_UP);
-
-	if (unexpected)
+	if (state != MEI_DEV_INITIALIZING &&
+	    state != MEI_DEV_DISABLED &&
+	    state != MEI_DEV_POWER_DOWN &&
+	    state != MEI_DEV_POWER_UP)
 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
-			 mei_dev_state_str(dev->dev_state));
+			 mei_dev_state_str(state));
 
 	/* we're already in reset, cancel the init timer
 	 * if the reset was called due the hbm protocol error
@@ -136,25 +85,23 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	 */
 	mei_hbm_idle(dev);
 
-	ret = mei_hw_reset(dev, interrupts_enabled);
-	if (ret) {
-		dev_err(&dev->pdev->dev, "hw reset failed disabling the device\n");
-		interrupts_enabled = false;
-	}
+	/* enter reset flow */
+	interrupts_enabled = state != MEI_DEV_POWER_DOWN;
+	dev->dev_state = MEI_DEV_RESETTING;
 
+	ret = mei_hw_reset(dev, interrupts_enabled);
+	/* fall through and remove the sw state even if hw reset has failed */
 
-	if (dev->dev_state != MEI_DEV_INITIALIZING &&
-	    dev->dev_state != MEI_DEV_POWER_UP) {
-		if (dev->dev_state != MEI_DEV_DISABLED &&
-		    dev->dev_state != MEI_DEV_POWER_DOWN)
-			dev->dev_state = MEI_DEV_RESETTING;
+	/* no need to clean up software state in case of power up */
+	if (state != MEI_DEV_INITIALIZING &&
+	    state != MEI_DEV_POWER_UP) {
 
 		/* remove all waiting requests */
 		mei_cl_all_write_clear(dev);
 
 		mei_cl_all_disconnect(dev);
 
-		/* wake up all readings so they can be interrupted */
+		/* wake up all readers and writers so they can be interrupted */
 		mei_cl_all_wakeup(dev);
 
 		/* remove entry if already in list */
@@ -170,33 +117,126 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;
 
-	if (!interrupts_enabled) {
-		dev_dbg(&dev->pdev->dev, "intr not enabled end of reset\n");
+	if (ret) {
+		dev_err(&dev->pdev->dev, "hw_reset failed ret = %d\n", ret);
 		dev->dev_state = MEI_DEV_DISABLED;
-		return;
+		return ret;
+	}
+
+	if (state == MEI_DEV_POWER_DOWN) {
+		dev_dbg(&dev->pdev->dev, "powering down: end of reset\n");
+		dev->dev_state = MEI_DEV_DISABLED;
+		return 0;
 	}
 
 	ret = mei_hw_start(dev);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "hw_start failed disabling the device\n");
+		dev_err(&dev->pdev->dev, "hw_start failed ret = %d\n", ret);
 		dev->dev_state = MEI_DEV_DISABLED;
-		return;
+		return ret;
 	}
 
 	dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
-	/* link is established * start sending messages.  */
 
 	dev->dev_state = MEI_DEV_INIT_CLIENTS;
-
 	ret = mei_hbm_start_req(dev);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "hbm_start failed disabling the device\n");
+		dev_err(&dev->pdev->dev, "hbm_start failed ret = %d\n", ret);
 		dev->dev_state = MEI_DEV_DISABLED;
-		return;
+		return ret;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mei_reset);
 
+/**
+ * mei_start - initializes host and fw to start work.
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_start(struct mei_device *dev)
+{
+	mutex_lock(&dev->device_lock);
+
+	/* acknowledge interrupt and stop interrupts */
+	mei_clear_interrupts(dev);
+
+	mei_hw_config(dev);
+
+	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
+
+	dev->dev_state = MEI_DEV_INITIALIZING;
+	mei_reset(dev);
+
+	if (dev->dev_state == MEI_DEV_DISABLED) {
+		dev_err(&dev->pdev->dev, "reset failed");
+		goto err;
+	}
+
+	if (mei_hbm_start_wait(dev)) {
+		dev_err(&dev->pdev->dev, "HBM haven't started");
+		goto err;
+	}
+
+	if (!mei_host_is_ready(dev)) {
+		dev_err(&dev->pdev->dev, "host is not ready.\n");
+		goto err;
+	}
+
+	if (!mei_hw_is_ready(dev)) {
+		dev_err(&dev->pdev->dev, "ME is not ready.\n");
+		goto err;
+	}
+
+	if (!mei_hbm_version_is_supported(dev)) {
+		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
+		goto err;
+	}
+
+	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
+
+	mutex_unlock(&dev->device_lock);
+	return 0;
+err:
+	dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
+	dev->dev_state = MEI_DEV_DISABLED;
+	mutex_unlock(&dev->device_lock);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(mei_start);
+
+/**
+ * mei_restart - restart device after suspend
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success or -ENODEV if the restart hasn't succeeded
+ */
+int mei_restart(struct mei_device *dev)
+{
+	int err;
+
+	mutex_lock(&dev->device_lock);
+
+	mei_clear_interrupts(dev);
+
+	dev->dev_state = MEI_DEV_POWER_UP;
+
+	err = mei_reset(dev);
+
+	mutex_unlock(&dev->device_lock);
+
+	if (err || dev->dev_state == MEI_DEV_DISABLED)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mei_restart);
+
+
 static void mei_reset_work(struct work_struct *work)
 {
 	struct mei_device *dev =
@@ -204,9 +244,12 @@ static void mei_reset_work(struct work_struct *work)
 
 	mutex_lock(&dev->device_lock);
 
-	mei_reset(dev, true);
+	mei_reset(dev);
 
 	mutex_unlock(&dev->device_lock);
+
+	if (dev->dev_state == MEI_DEV_DISABLED)
+		dev_err(&dev->pdev->dev, "reset failed");
 }
 
 void mei_stop(struct mei_device *dev)
@@ -222,7 +265,7 @@ void mei_stop(struct mei_device *dev)
 	mei_wd_stop(dev);
 
 	dev->dev_state = MEI_DEV_POWER_DOWN;
-	mei_reset(dev, 0);
+	mei_reset(dev);
 
 	mutex_unlock(&dev->device_lock);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 2a7277d..f0fbb51 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -560,7 +560,7 @@ void mei_timer(struct work_struct *work)
 			if (--dev->init_clients_timer == 0) {
 				dev_err(&dev->pdev->dev, "timer: init clients timeout hbm_state = %d.\n",
 					dev->hbm_state);
-				mei_reset(dev, 1);
+				mei_reset(dev);
 				goto out;
 			}
 		}
@@ -573,8 +573,8 @@ void mei_timer(struct work_struct *work)
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
 		if (cl_pos->timer_count) {
 			if (--cl_pos->timer_count == 0) {
-				dev_err(&dev->pdev->dev, "reset: connect/disconnect timeout.\n");
-				mei_reset(dev, 1);
+				dev_err(&dev->pdev->dev, "timer: connect/disconnect timeout.\n");
+				mei_reset(dev);
 				goto out;
 			}
 		}
@@ -582,8 +582,8 @@ void mei_timer(struct work_struct *work)
 
 	if (dev->iamthif_stall_timer) {
 		if (--dev->iamthif_stall_timer == 0) {
-			dev_err(&dev->pdev->dev, "reset: amthif  hanged.\n");
-			mei_reset(dev, 1);
+			dev_err(&dev->pdev->dev, "timer: amthif  hanged.\n");
+			mei_reset(dev);
 			dev->iamthif_msg_buf_size = 0;
 			dev->iamthif_msg_buf_index = 0;
 			dev->iamthif_canceled = false;
@@ -636,7 +636,8 @@ void mei_timer(struct work_struct *work)
 		}
 	}
 out:
-	schedule_delayed_work(&dev->timer_work, 2 * HZ);
+	if (dev->dev_state != MEI_DEV_DISABLED)
+		schedule_delayed_work(&dev->timer_work, 2 * HZ);
 	mutex_unlock(&dev->device_lock);
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 2c76928..a617c84 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -472,8 +472,9 @@ static inline u32 mei_slots2data(int slots)
  * mei init function prototypes
  */
 void mei_device_init(struct mei_device *dev);
-void mei_reset(struct mei_device *dev, int interrupts);
+int mei_reset(struct mei_device *dev);
 int mei_start(struct mei_device *dev);
+int mei_restart(struct mei_device *dev);
 void mei_stop(struct mei_device *dev);
 void mei_cancel_work(struct mei_device *dev);
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 8b1deea..ddadd08 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -321,16 +321,14 @@ static int mei_me_pci_resume(struct device *device)
 		return err;
 	}
 
-	mutex_lock(&dev->device_lock);
-	dev->dev_state = MEI_DEV_POWER_UP;
-	mei_clear_interrupts(dev);
-	mei_reset(dev, 1);
-	mutex_unlock(&dev->device_lock);
+	err = mei_restart(dev);
+	if (err)
+		return err;
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);
 
-	return err;
+	return 0;
 }
 static SIMPLE_DEV_PM_OPS(mei_me_pm_ops, mei_me_pci_suspend, mei_me_pci_resume);
 #define MEI_ME_PM_OPS	(&mei_me_pm_ops)
-- 
1.8.4.2

