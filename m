Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab3GXNYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:24:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:27917 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3GXNYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:24:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,735,1367996400"; 
   d="scan'208";a="336062315"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: don't get stack in select during reset
Date: Wed, 24 Jul 2013 16:22:58 +0300
Message-Id: <1374672179-23949-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
References: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear pending connection after hw reset but before hw start
and wake up the waiting task in poll. Signal POLLERR in select
when device went through reset.

Add wrapper mei_cl_is_connected for checking if
the device and client are connected.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 14 +++++++++++---
 drivers/misc/mei/client.c |  5 +----
 drivers/misc/mei/client.h |  7 +++++++
 drivers/misc/mei/init.c   | 13 ++++++++-----
 drivers/misc/mei/main.c   | 22 +++++++++++++++-------
 5 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 749452f..d0fdc13 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -418,15 +418,23 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 		struct file *file, poll_table *wait)
 {
 	unsigned int mask = 0;
-	mutex_unlock(&dev->device_lock);
+
 	poll_wait(file, &dev->iamthif_cl.wait, wait);
+
 	mutex_lock(&dev->device_lock);
-	if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
-		dev->iamthif_file_object == file) {
+	if (!mei_cl_is_connected(&dev->iamthif_cl)) {
+
+		mask = POLLERR;
+
+	} else if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
+		   dev->iamthif_file_object == file) {
+
 		mask |= (POLLIN | POLLRDNORM);
 		dev_dbg(&dev->pdev->dev, "run next amthif cb\n");
 		mei_amthif_run_next_cmd(dev);
 	}
+	mutex_unlock(&dev->device_lock);
+
 	return mask;
 }
 
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index af1e602..e0684b4 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -635,10 +635,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 
 	dev = cl->dev;
 
-	if (cl->state != MEI_FILE_CONNECTED)
-		return -ENODEV;
-
-	if (dev->dev_state != MEI_DEV_ENABLED)
+	if (!mei_cl_is_connected(cl))
 		return -ENODEV;
 
 	if (cl->read_cb) {
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 9bae4c7..9eb031e 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -84,6 +84,13 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl);
 /*
  *  MEI input output function prototype
  */
+static inline bool mei_cl_is_connected(struct mei_cl *cl)
+{
+	return (cl->dev &&
+		cl->dev->dev_state == MEI_DEV_ENABLED &&
+		cl->state == MEI_FILE_CONNECTED);
+}
+
 bool mei_cl_is_other_connecting(struct mei_cl *cl);
 int mei_cl_disconnect(struct mei_cl *cl);
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4bb7f3c..e38e3d89 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -150,12 +150,20 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	if (dev->dev_state != MEI_DEV_INITIALIZING &&
 	    dev->dev_state != MEI_DEV_POWER_UP) {
+
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
 			dev->dev_state = MEI_DEV_RESETTING;
 
+
+		/* remove all waiting requests */
+		mei_cl_all_write_clear(dev);
+
 		mei_cl_all_disconnect(dev);
 
+		/* wake up all readings so they can be interrupted */
+		mei_cl_all_wakeup(dev);
+
 		/* remove entry if already in list */
 		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
 		mei_cl_unlink(&dev->wd_cl);
@@ -196,11 +204,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	mei_hbm_start_req(dev);
 
-	/* wake up all readings so they can be interrupted */
-	mei_cl_all_wakeup(dev);
-
-	/* remove all waiting requests */
-	mei_cl_all_write_clear(dev);
 }
 EXPORT_SYMBOL_GPL(mei_reset);
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5e11b5b..173ff09 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -625,24 +625,32 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 	unsigned int mask = 0;
 
 	if (WARN_ON(!cl || !cl->dev))
-		return mask;
+		return POLLERR;
 
 	dev = cl->dev;
 
 	mutex_lock(&dev->device_lock);
 
-	if (dev->dev_state != MEI_DEV_ENABLED)
-		goto out;
-
-
-	if (cl == &dev->iamthif_cl) {
-		mask = mei_amthif_poll(dev, file, wait);
+	if (!mei_cl_is_connected(cl)) {
+		mask = POLLERR;
 		goto out;
 	}
 
 	mutex_unlock(&dev->device_lock);
+
+
+	if (cl == &dev->iamthif_cl)
+		return mei_amthif_poll(dev, file, wait);
+
 	poll_wait(file, &cl->tx_wait, wait);
+
 	mutex_lock(&dev->device_lock);
+
+	if (!mei_cl_is_connected(cl)) {
+		mask = POLLERR;
+		goto out;
+	}
+
 	if (MEI_WRITE_COMPLETE == cl->writing_state)
 		mask |= (POLLIN | POLLRDNORM);
 
-- 
1.8.1.2

