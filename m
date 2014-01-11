Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaAKWhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 17:37:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:47204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaAKWhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 17:37:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="465255142"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc 4/4 V2] mei: limit the number of consecutive resets
Date: Sun, 12 Jan 2014 00:36:10 +0200
Message-Id: <1389479770-8524-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389479770-8524-1-git-send-email-tomas.winkler@intel.com>
References: <1389479770-8524-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

give up reseting after 3 unsuccessful tries

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
V2: rebased

 drivers/misc/mei/client.c  |  1 +
 drivers/misc/mei/init.c    | 10 ++++++++++
 drivers/misc/mei/mei_dev.h |  7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 4f268a3..1ee2b94 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -370,6 +370,7 @@ void mei_host_client_init(struct work_struct *work)
 	}
 
 	dev->dev_state = MEI_DEV_ENABLED;
+	dev->reset_count = 0;
 
 	mutex_unlock(&dev->device_lock);
 }
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 059133d..cdd31c2 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -89,6 +89,13 @@ int mei_reset(struct mei_device *dev)
 	interrupts_enabled = state != MEI_DEV_POWER_DOWN;
 	dev->dev_state = MEI_DEV_RESETTING;
 
+	dev->reset_count++;
+	if (dev->reset_count > MEI_MAX_CONSEC_RESET) {
+		dev_err(&dev->pdev->dev, "reset: reached maximal consecutive resets: disabling the device\n");
+		dev->dev_state = MEI_DEV_DISABLED;
+		return -ENODEV;
+	}
+
 	ret = mei_hw_reset(dev, interrupts_enabled);
 	/* fall through and remove the sw state even if hw reset has failed */
 
@@ -169,6 +176,7 @@ int mei_start(struct mei_device *dev)
 	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
 
 	dev->dev_state = MEI_DEV_INITIALIZING;
+	dev->reset_count = 0;
 	mei_reset(dev);
 
 	if (dev->dev_state == MEI_DEV_DISABLED) {
@@ -224,6 +232,7 @@ int mei_restart(struct mei_device *dev)
 	mei_clear_interrupts(dev);
 
 	dev->dev_state = MEI_DEV_POWER_UP;
+	dev->reset_count = 0;
 
 	err = mei_reset(dev);
 
@@ -285,6 +294,7 @@ void mei_device_init(struct mei_device *dev)
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
+	dev->reset_count = 0;
 
 	mei_io_list_init(&dev->read_list);
 	mei_io_list_init(&dev->write_list);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index a617c84..f7de95b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -61,6 +61,11 @@ extern const uuid_le mei_wd_guid;
 #define MEI_CLIENTS_MAX 256
 
 /*
+ * maximum number of consecutive resets
+ */
+#define MEI_MAX_CONSEC_RESET  3
+
+/*
  * Number of File descriptors/handles
  * that can be opened to the driver.
  *
@@ -327,6 +332,7 @@ struct mei_cl_device {
 /**
  * struct mei_device -  MEI private device struct
 
+ * @reset_count - limits the number of consecutive resets
  * @hbm_state - state of host bus message protocol
  * @mem_addr - mem mapped base register address
 
@@ -370,6 +376,7 @@ struct mei_device {
 	/*
 	 * mei device  states
 	 */
+	unsigned long reset_count;
 	enum mei_dev_state dev_state;
 	enum mei_hbm_state hbm_state;
 	u16 init_clients_timer;
-- 
1.8.4.2

