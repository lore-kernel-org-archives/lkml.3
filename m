Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3ELMgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 08:36:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:42194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3ELMgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 08:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="312205214"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: revamp interrupt thread handlers
Date: Sun, 12 May 2013 15:34:46 +0300
Message-Id: <1368362086-21471-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368362086-21471-1-git-send-email-tomas.winkler@intel.com>
References: <1368362086-21471-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Use common prefix mei_cl_irq_ and common parameter list
for client handlers.
2. Update function kdocs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   6 +-
 drivers/misc/mei/interrupt.c | 130 +++++++++++++++++++++----------------------
 drivers/misc/mei/mei_dev.h   |  13 +----
 3 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index b3e5098..749452f 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -443,11 +443,11 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
  *
  * returns 0, OK; otherwise, error.
  */
-int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
+int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
+				  s32 *slots, struct mei_cl_cb *cmpl_list)
 {
+	struct mei_device *dev = cl->dev;
 	struct mei_msg_hdr mei_hdr;
-	struct mei_cl *cl = cb->cl;
 	size_t len = dev->iamthif_msg_buf_size - dev->iamthif_msg_buf_index;
 	u32 msg_slots = mei_data2slots(len);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 93da90a..7d9509a 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -163,21 +163,21 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 }
 
 /**
- * _mei_irq_thread_close - processes close related operation.
+ * mei_cl_irq_close - processes close related operation from
+ *	interrupt thread context - send disconnect request
  *
- * @dev: the device structure.
+ * @cl: client
+ * @cb: callback block.
  * @slots: free slots.
- * @cb_pos: callback block.
- * @cl: private data of the file object.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
-				struct mei_cl_cb *cb_pos,
-				struct mei_cl *cl,
-				struct mei_cl_cb *cmpl_list)
+static int mei_cl_irq_close(struct mei_cl *cl, struct mei_cl_cb *cb,
+			s32 *slots, struct mei_cl_cb *cmpl_list)
 {
+	struct mei_device *dev = cl->dev;
+
 	u32 msg_slots =
 		mei_data2slots(sizeof(struct hbm_client_connect_request));
 
@@ -188,15 +188,15 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 
 	if (mei_hbm_cl_disconnect_req(dev, cl)) {
 		cl->status = 0;
-		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->list, &cmpl_list->list);
+		cb->buf_idx = 0;
+		list_move_tail(&cb->list, &cmpl_list->list);
 		return -EIO;
 	}
 
 	cl->state = MEI_FILE_DISCONNECTING;
 	cl->status = 0;
-	cb_pos->buf_idx = 0;
-	list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
+	cb->buf_idx = 0;
+	list_move_tail(&cb->list, &dev->ctrl_rd_list.list);
 	cl->timer_count = MEI_CONNECT_TIMEOUT;
 
 	return 0;
@@ -204,26 +204,26 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 
 
 /**
- * _mei_irq_thread_read - processes read related operation.
+ * mei_cl_irq_close - processes client read related operation from the
+ *	interrupt thread context - request for flow control credits
  *
- * @dev: the device structure.
+ * @cl: client
+ * @cb: callback block.
  * @slots: free slots.
- * @cb_pos: callback block.
- * @cl: private data of the file object.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list)
+static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
+			   s32 *slots, struct mei_cl_cb *cmpl_list)
 {
+	struct mei_device *dev = cl->dev;
+
 	u32 msg_slots = mei_data2slots(sizeof(struct hbm_flow_control));
 
 	if (*slots < msg_slots) {
 		/* return the cancel routine */
-		list_del(&cb_pos->list);
+		list_del(&cb->list);
 		return -EMSGSIZE;
 	}
 
@@ -231,38 +231,38 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 
 	if (mei_hbm_cl_flow_control_req(dev, cl)) {
 		cl->status = -ENODEV;
-		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->list, &cmpl_list->list);
+		cb->buf_idx = 0;
+		list_move_tail(&cb->list, &cmpl_list->list);
 		return -ENODEV;
 	}
-	list_move_tail(&cb_pos->list, &dev->read_list.list);
+	list_move_tail(&cb->list, &dev->read_list.list);
 
 	return 0;
 }
 
 
 /**
- * _mei_irq_thread_ioctl - processes ioctl related operation.
+ * mei_cl_irq_ioctl - processes client ioctl related operation from the
+ *	interrupt thread context -   send connection request
  *
- * @dev: the device structure.
+ * @cl: client
+ * @cb: callback block.
  * @slots: free slots.
- * @cb_pos: callback block.
- * @cl: private data of the file object.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list)
+static int mei_cl_irq_ioctl(struct mei_cl *cl, struct mei_cl_cb *cb,
+			   s32 *slots, struct mei_cl_cb *cmpl_list)
 {
+	struct mei_device *dev = cl->dev;
+
 	u32 msg_slots =
 		mei_data2slots(sizeof(struct hbm_client_connect_request));
 
 	if (*slots < msg_slots) {
 		/* return the cancel routine */
-		list_del(&cb_pos->list);
+		list_del(&cb->list);
 		return -EMSGSIZE;
 	}
 
@@ -272,31 +272,31 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 
 	if (mei_hbm_cl_connect_req(dev, cl)) {
 		cl->status = -ENODEV;
-		cb_pos->buf_idx = 0;
-		list_del(&cb_pos->list);
+		cb->buf_idx = 0;
+		list_del(&cb->list);
 		return -ENODEV;
-	} else {
-		list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
-		cl->timer_count = MEI_CONNECT_TIMEOUT;
 	}
+
+	list_move_tail(&cb->list, &dev->ctrl_rd_list.list);
+	cl->timer_count = MEI_CONNECT_TIMEOUT;
 	return 0;
 }
 
 /**
- * mei_irq_thread_write_complete - write messages to device.
+ * mei_cl_irq_write_complete - write messages to device.
  *
- * @dev: the device structure.
- * @slots: free slots.
+ * @cl: client
  * @cb: callback block.
+ * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
+static int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
+				     s32 *slots, struct mei_cl_cb *cmpl_list)
 {
+	struct mei_device *dev = cl->dev;
 	struct mei_msg_hdr mei_hdr;
-	struct mei_cl *cl = cb->cl;
 	size_t len = cb->request_buffer.size - cb->buf_idx;
 	u32 msg_slots = mei_data2slots(len);
 
@@ -455,7 +455,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 {
 
 	struct mei_cl *cl;
-	struct mei_cl_cb *pos = NULL, *next = NULL;
+	struct mei_cl_cb *cb, *next;
 	struct mei_cl_cb *list;
 	s32 slots;
 	int ret;
@@ -472,19 +472,19 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	dev_dbg(&dev->pdev->dev, "complete all waiting for write cb.\n");
 
 	list = &dev->write_waiting_list;
-	list_for_each_entry_safe(pos, next, &list->list, list) {
-		cl = pos->cl;
+	list_for_each_entry_safe(cb, next, &list->list, list) {
+		cl = cb->cl;
 		if (cl == NULL)
 			continue;
 
 		cl->status = 0;
-		list_del(&pos->list);
+		list_del(&cb->list);
 		if (MEI_WRITING == cl->writing_state &&
-		    pos->fop_type == MEI_FOP_WRITE &&
+		    cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
-			list_add_tail(&pos->list, &cmpl_list->list);
+			list_add_tail(&cb->list, &cmpl_list->list);
 		}
 		if (cl == &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
@@ -526,25 +526,23 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 	/* complete control write list CB */
 	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
-	list_for_each_entry_safe(pos, next, &dev->ctrl_wr_list.list, list) {
-		cl = pos->cl;
+	list_for_each_entry_safe(cb, next, &dev->ctrl_wr_list.list, list) {
+		cl = cb->cl;
 		if (!cl) {
-			list_del(&pos->list);
+			list_del(&cb->list);
 			return -ENODEV;
 		}
-		switch (pos->fop_type) {
+		switch (cb->fop_type) {
 		case MEI_FOP_CLOSE:
 			/* send disconnect message */
-			ret = _mei_irq_thread_close(dev, &slots, pos,
-						cl, cmpl_list);
+			ret = mei_cl_irq_close(cl, cb, &slots, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
 		case MEI_FOP_READ:
 			/* send flow control message */
-			ret = _mei_irq_thread_read(dev, &slots, pos,
-						cl, cmpl_list);
+			ret = mei_cl_irq_read(cl, cb, &slots, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -553,8 +551,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 			/* connect message */
 			if (mei_cl_is_other_connecting(cl))
 				continue;
-			ret = _mei_irq_thread_ioctl(dev, &slots, pos,
-						cl, cmpl_list);
+			ret = mei_cl_irq_ioctl(cl, cb, &slots, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -567,8 +564,8 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	}
 	/* complete  write list CB */
 	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
-	list_for_each_entry_safe(pos, next, &dev->write_list.list, list) {
-		cl = pos->cl;
+	list_for_each_entry_safe(cb, next, &dev->write_list.list, list) {
+		cl = cb->cl;
 		if (cl == NULL)
 			continue;
 		if (mei_cl_flow_ctrl_creds(cl) <= 0) {
@@ -579,14 +576,13 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		}
 
 		if (cl == &dev->iamthif_cl)
-			ret = mei_amthif_irq_write_complete(dev, &slots,
-							pos, cmpl_list);
+			ret = mei_amthif_irq_write_complete(cl, cb,
+						&slots, cmpl_list);
 		else
-			ret = mei_irq_thread_write_complete(dev, &slots, pos,
-						cmpl_list);
+			ret = mei_cl_irq_write_complete(cl, cb,
+						&slots, cmpl_list);
 		if (ret)
 			return ret;
-
 	}
 	return 0;
 }
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 4de5140..197ba64 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -502,8 +502,8 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 
 void mei_amthif_run_next_cmd(struct mei_device *dev);
 
-int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
+int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
+				  s32 *slots, struct mei_cl_cb *cmpl_list);
 
 void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
 int mei_amthif_irq_read_msg(struct mei_device *dev,
@@ -522,15 +522,6 @@ void mei_nfc_host_exit(void);
  */
 extern const uuid_le mei_nfc_guid;
 
-int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
-
-void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
-int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
-int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
-
-
 int mei_wd_send(struct mei_device *dev);
 int mei_wd_stop(struct mei_device *dev);
 int mei_wd_host_init(struct mei_device *dev);
-- 
1.8.1.2

