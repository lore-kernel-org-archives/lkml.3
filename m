Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3CQJld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 05:41:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:8342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3CQJlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 05:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="307767246"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: add mei_irq_compl_handler function
Date: Sun, 17 Mar 2013 11:41:20 +0200
Message-Id: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

similar to read/write add also irq completion handler
that is called for the irq thread

rename missnamed mei_irq_complete_handler to
mei_cl_complete_handler as it operates on a single client

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     | 18 +-----------------
 drivers/misc/mei/interrupt.c | 39 ++++++++++++++++++++++++++++++++-------
 drivers/misc/mei/mei_dev.h   |  3 +--
 3 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 0db071f..7c2b14d 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -466,8 +466,6 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 {
 	struct mei_device *dev = (struct mei_device *) dev_id;
 	struct mei_cl_cb complete_list;
-	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
-	struct mei_cl *cl;
 	s32 slots;
 	int rets;
 	bool  bus_message_received;
@@ -538,23 +536,9 @@ end:
 		wake_up_interruptible(&dev->wait_recvd_msg);
 		bus_message_received = false;
 	}
-	if (list_empty(&complete_list.list))
-		return IRQ_HANDLED;
 
+	mei_irq_compl_handler(dev, &complete_list);
 
-	list_for_each_entry_safe(cb_pos, cb_next, &complete_list.list, list) {
-		cl = cb_pos->cl;
-		list_del(&cb_pos->list);
-		if (cl) {
-			if (cl != &dev->iamthif_cl) {
-				dev_dbg(&dev->pdev->dev, "completing call back.\n");
-				mei_irq_complete_handler(cl, cb_pos);
-				cb_pos = NULL;
-			} else if (cl == &dev->iamthif_cl) {
-				mei_amthif_complete(dev, cb_pos);
-			}
-		}
-	}
 	return IRQ_HANDLED;
 }
 static const struct mei_hw_ops mei_me_hw_ops = {
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 14c70b8..73fbce3 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -30,21 +30,21 @@
 
 
 /**
- * mei_complete_handler - processes completed operation.
+ * mei_cl_complete_handler - processes completed operation for a client
  *
  * @cl: private data of the file object.
- * @cb_pos: callback block.
+ * @cb: callback block.
  */
-void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
+static void mei_cl_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb)
 {
-	if (cb_pos->fop_type == MEI_FOP_WRITE) {
-		mei_io_cb_free(cb_pos);
-		cb_pos = NULL;
+	if (cb->fop_type == MEI_FOP_WRITE) {
+		mei_io_cb_free(cb);
+		cb = NULL;
 		cl->writing_state = MEI_WRITE_COMPLETE;
 		if (waitqueue_active(&cl->tx_wait))
 			wake_up_interruptible(&cl->tx_wait);
 
-	} else if (cb_pos->fop_type == MEI_FOP_READ &&
+	} else if (cb->fop_type == MEI_FOP_READ &&
 			MEI_READING == cl->reading_state) {
 		cl->reading_state = MEI_READ_COMPLETE;
 		if (waitqueue_active(&cl->rx_wait))
@@ -54,6 +54,31 @@ void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 }
 
 /**
+ * mei_irq_compl_handler - dispatch complete handelers
+ *	for the completed callbacks
+ *
+ * @dev - mei device
+ * @compl_list - list of completed cbs
+ */
+void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
+{
+	struct mei_cl_cb *cb, *next;
+	struct mei_cl *cl;
+
+	list_for_each_entry_safe(cb, next, &compl_list->list, list) {
+		cl = cb->cl;
+		list_del(&cb->list);
+		if (!cl)
+			continue;
+
+		dev_dbg(&dev->pdev->dev, "completing call back.\n");
+		if (cl == &dev->iamthif_cl)
+			mei_amthif_complete(dev, cb);
+		else
+			mei_cl_complete_handler(cl, cb);
+	}
+}
+/**
  * _mei_irq_thread_state_ok - checks if mei header matches file private data
  *
  * @cl: private data of the file object
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c17bced..d6fd3d6 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -406,8 +406,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		struct mei_cl_cb *cmpl_list, s32 *slots);
 
 int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list);
-
-void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos);
+void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list);
 
 /*
  * AMTHIF - AMT Host Interface Functions
-- 
1.8.1.3

