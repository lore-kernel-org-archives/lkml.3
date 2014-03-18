Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaCRU5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:57:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbaCRUxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172429"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 06/13] mei: me: add pg exit and entry flow commands
Date: Tue, 18 Mar 2014 22:52:00 +0200
Message-Id: <1395175927-10562-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power gating entry we write hbm pg entry request command and
then we set pg register
For power gating exit we clear pg register and wait for exit request
hbm command.

Exit power gating request might also be initiated by the firmware
w/o explicit driver request

The power gating state is tracked by pg_state member of me_hw

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hbm.c   |  2 ++
 drivers/misc/mei/hw-me.c | 92 +++++++++++++++++++++++++++++++++++++++++++++---
 drivers/misc/mei/hw-me.h |  4 +++
 drivers/misc/mei/hw.h    |  1 +
 4 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index a16b47c..a725365 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -732,12 +732,14 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case MEI_PG_ISOLATION_ENTRY_RES_CMD:
 		dev_dbg(&dev->pdev->dev, "power gate isolation entry response received\n");
+		dev->pg_event = MEI_PG_EVENT_RECEIVED;
 		if (waitqueue_active(&dev->wait_pg))
 			wake_up(&dev->wait_pg);
 		break;
 
 	case MEI_PG_ISOLATION_EXIT_REQ_CMD:
 		dev_dbg(&dev->pdev->dev, "power gate isolation exit request received\n");
+		dev->pg_event = MEI_PG_EVENT_RECEIVED;
 		if (waitqueue_active(&dev->wait_pg))
 			wake_up(&dev->wait_pg);
 		break;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 02f3b0c..4b048b6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -109,9 +109,12 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
  */
 static void mei_me_hw_config(struct mei_device *dev)
 {
+	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(to_me_hw(dev));
 	/* Doesn't change in runtime */
 	dev->hbuf_depth = (hcsr & H_CBD) >> 24;
+
+	hw->pg_state = MEI_PG_OFF;
 }
 
 /**
@@ -123,7 +126,8 @@ static void mei_me_hw_config(struct mei_device *dev)
  */
 static inline enum mei_pg_state mei_me_pg_state(struct mei_device *dev)
 {
-	return MEI_PG_OFF;
+	struct mei_me_hw *hw = to_me_hw(dev);
+	return hw->pg_state;
 }
 
 /**
@@ -473,6 +477,80 @@ static void mei_me_pg_exit(struct mei_device *dev)
 }
 
 /**
+ * mei_me_pg_set_sync - perform pg entry procedure
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success an error code otherwise
+ */
+int mei_me_pg_set_sync(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	unsigned long timeout = mei_secs_to_jiffies(MEI_PGI_TIMEOUT);
+	int ret;
+
+	dev->pg_event = MEI_PG_EVENT_WAIT;
+
+	ret = mei_hbm_pg(dev, MEI_PG_ISOLATION_ENTRY_REQ_CMD);
+	if (ret)
+		return ret;
+
+	mutex_unlock(&dev->device_lock);
+	wait_event_timeout(dev->wait_pg,
+		dev->pg_event == MEI_PG_EVENT_RECEIVED, timeout);
+	mutex_lock(&dev->device_lock);
+
+	if (dev->pg_event == MEI_PG_EVENT_RECEIVED) {
+		mei_me_pg_enter(dev);
+		ret = 0;
+	} else {
+		ret = -ETIME;
+	}
+
+	dev->pg_event = MEI_PG_EVENT_IDLE;
+	hw->pg_state = MEI_PG_ON;
+
+	return ret;
+}
+
+/**
+ * mei_me_pg_unset_sync - perform pg exit procedure
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success an error code otherwise
+ */
+int mei_me_pg_unset_sync(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	unsigned long timeout = mei_secs_to_jiffies(MEI_PGI_TIMEOUT);
+	int ret;
+
+	if (dev->pg_event == MEI_PG_EVENT_RECEIVED)
+		goto reply;
+
+	dev->pg_event = MEI_PG_EVENT_WAIT;
+
+	mei_me_pg_exit(dev);
+
+	mutex_unlock(&dev->device_lock);
+	wait_event_timeout(dev->wait_pg,
+		dev->pg_event == MEI_PG_EVENT_RECEIVED, timeout);
+	mutex_lock(&dev->device_lock);
+
+reply:
+	if (dev->pg_event == MEI_PG_EVENT_RECEIVED)
+		ret = mei_hbm_pg(dev, MEI_PG_ISOLATION_EXIT_RES_CMD);
+	else
+		ret = -ETIME;
+
+	dev->pg_event = MEI_PG_EVENT_IDLE;
+	hw->pg_state = MEI_PG_OFF;
+
+	return ret;
+}
+
+/**
  * mei_me_pg_is_enabled - detect if PG is supported by HW
  *
  * @dev: the device structure
@@ -601,9 +679,15 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 
-	rets = mei_irq_write_handler(dev, &complete_list);
-
-	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
+	/*
+	 * During PG handshake only allowed write is the replay to the
+	 * PG exit message, so block calling write function
+	 * if the pg state is not idle
+	 */
+	if (dev->pg_event == MEI_PG_EVENT_IDLE) {
+		rets = mei_irq_write_handler(dev, &complete_list);
+		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
+	}
 
 	mei_irq_compl_handler(dev, &complete_list);
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 80bd829..1d72b55 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -30,12 +30,16 @@ struct mei_me_hw {
 	 */
 	u32 host_hw_state;
 	u32 me_hw_state;
+	enum mei_pg_state pg_state;
 };
 
 #define to_me_hw(dev) (struct mei_me_hw *)((dev)->hw)
 
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev);
 
+int mei_me_pg_set_sync(struct mei_device *dev);
+int mei_me_pg_unset_sync(struct mei_device *dev);
+
 irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id);
 irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id);
 
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index ec4a91a..9bad9cf 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -31,6 +31,7 @@
 #define MEI_IAMTHIF_STALL_TIMER    12  /* HPS */
 #define MEI_IAMTHIF_READ_TIMER     10  /* HPS */
 
+#define MEI_PGI_TIMEOUT            1  /* PG Isolation time response 1 sec */
 #define MEI_HBM_TIMEOUT            1   /* 1 second */
 
 /*
-- 
1.8.5.3

