Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3ELMgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 08:36:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:42194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab3ELMgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 08:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="312205213"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: move mei_cl_complete to client.c
Date: Sun, 12 May 2013 15:34:45 +0300
Message-Id: <1368362086-21471-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. rename mei_cl_complete_handler to mei_cl_complete
2. move the function client.c where it belongs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c    | 26 ++++++++++++++++++++++++++
 drivers/misc/mei/client.h    |  1 +
 drivers/misc/mei/interrupt.c | 28 +---------------------------
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e310ca6..c2534ca 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -785,6 +785,32 @@ err:
 }
 
 
+/**
+ * mei_cl_complete - processes completed operation for a client
+ *
+ * @cl: private data of the file object.
+ * @cb: callback block.
+ */
+void mei_cl_complete(struct mei_cl *cl, struct mei_cl_cb *cb)
+{
+	if (cb->fop_type == MEI_FOP_WRITE) {
+		mei_io_cb_free(cb);
+		cb = NULL;
+		cl->writing_state = MEI_WRITE_COMPLETE;
+		if (waitqueue_active(&cl->tx_wait))
+			wake_up_interruptible(&cl->tx_wait);
+
+	} else if (cb->fop_type == MEI_FOP_READ &&
+			MEI_READING == cl->reading_state) {
+		cl->reading_state = MEI_READ_COMPLETE;
+		if (waitqueue_active(&cl->rx_wait))
+			wake_up_interruptible(&cl->rx_wait);
+		else
+			mei_cl_bus_rx_event(cl);
+
+	}
+}
+
 
 /**
  * mei_cl_all_disconnect - disconnect forcefully all connected clients
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index cfdb144..7dc2af7 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -89,6 +89,7 @@ int mei_cl_disconnect(struct mei_cl *cl);
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
 int mei_cl_read_start(struct mei_cl *cl, size_t length);
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking);
+void mei_cl_complete(struct mei_cl *cl, struct mei_cl_cb *cb);
 
 void mei_host_client_init(struct work_struct *work);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 2ad7369..93da90a 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -31,32 +31,6 @@
 
 
 /**
- * mei_cl_complete_handler - processes completed operation for a client
- *
- * @cl: private data of the file object.
- * @cb: callback block.
- */
-static void mei_cl_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb)
-{
-	if (cb->fop_type == MEI_FOP_WRITE) {
-		mei_io_cb_free(cb);
-		cb = NULL;
-		cl->writing_state = MEI_WRITE_COMPLETE;
-		if (waitqueue_active(&cl->tx_wait))
-			wake_up_interruptible(&cl->tx_wait);
-
-	} else if (cb->fop_type == MEI_FOP_READ &&
-			MEI_READING == cl->reading_state) {
-		cl->reading_state = MEI_READ_COMPLETE;
-		if (waitqueue_active(&cl->rx_wait))
-			wake_up_interruptible(&cl->rx_wait);
-		else
-			mei_cl_bus_rx_event(cl);
-
-	}
-}
-
-/**
  * mei_irq_compl_handler - dispatch complete handelers
  *	for the completed callbacks
  *
@@ -78,7 +52,7 @@ void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 		if (cl == &dev->iamthif_cl)
 			mei_amthif_complete(dev, cb);
 		else
-			mei_cl_complete_handler(cl, cb);
+			mei_cl_complete(cl, cb);
 	}
 }
 EXPORT_SYMBOL_GPL(mei_irq_compl_handler);
-- 
1.8.1.2

