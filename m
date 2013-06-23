Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3FWGju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 02:39:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:58746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3FWGjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 02:39:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="358108631"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/4 RESEND] mei: move mei_cl_irq_write_complete to client.c
Date: Sun, 23 Jun 2013 09:36:59 +0300
Message-Id: <1371969422-16530-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_cl_irq_write_complete operates on a client so move it
to client.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c    | 60 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/client.h    |  3 +++
 drivers/misc/mei/interrupt.c | 59 -------------------------------------------
 3 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index c2534ca..788f647 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -682,6 +682,66 @@ err:
 }
 
 /**
+ * mei_cl_irq_write_complete - write a message to device
+ *	from the interrupt thread context
+ *
+ * @cl: client
+ * @cb: callback block.
+ * @slots: free slots.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise error.
+ */
+int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
+				     s32 *slots, struct mei_cl_cb *cmpl_list)
+{
+	struct mei_device *dev = cl->dev;
+	struct mei_msg_hdr mei_hdr;
+	size_t len = cb->request_buffer.size - cb->buf_idx;
+	u32 msg_slots = mei_data2slots(len);
+
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
+
+	if (*slots >= msg_slots) {
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 1;
+	/* Split the message only if we can write the whole host buffer */
+	} else if (*slots == dev->hbuf_depth) {
+		msg_slots = *slots;
+		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 0;
+	} else {
+		/* wait for next time the host buffer is empty */
+		return 0;
+	}
+
+	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
+			cb->request_buffer.size, cb->buf_idx);
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(&mei_hdr));
+
+	*slots -=  msg_slots;
+	if (mei_write_message(dev, &mei_hdr,
+			cb->request_buffer.data + cb->buf_idx)) {
+		cl->status = -ENODEV;
+		list_move_tail(&cb->list, &cmpl_list->list);
+		return -ENODEV;
+	}
+
+	cl->status = 0;
+	cb->buf_idx += mei_hdr.length;
+	if (mei_hdr.msg_complete) {
+		if (mei_cl_flow_ctrl_reduce(cl))
+			return -ENODEV;
+		list_move_tail(&cb->list, &dev->write_waiting_list.list);
+	}
+
+	return 0;
+}
+
+/**
  * mei_cl_write - submit a write cb to mei device
 	assumes device_lock is locked
  *
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 7dc2af7..26b157d 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -89,6 +89,9 @@ int mei_cl_disconnect(struct mei_cl *cl);
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
 int mei_cl_read_start(struct mei_cl *cl, size_t length);
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking);
+int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
+				s32 *slots, struct mei_cl_cb *cmpl_list);
+
 void mei_cl_complete(struct mei_cl *cl, struct mei_cl_cb *cb);
 
 void mei_host_client_init(struct work_struct *work);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7d9509a..4b59cb7 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -282,65 +282,6 @@ static int mei_cl_irq_ioctl(struct mei_cl *cl, struct mei_cl_cb *cb,
 	return 0;
 }
 
-/**
- * mei_cl_irq_write_complete - write messages to device.
- *
- * @cl: client
- * @cb: callback block.
- * @slots: free slots.
- * @cmpl_list: complete list.
- *
- * returns 0, OK; otherwise, error.
- */
-static int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
-				     s32 *slots, struct mei_cl_cb *cmpl_list)
-{
-	struct mei_device *dev = cl->dev;
-	struct mei_msg_hdr mei_hdr;
-	size_t len = cb->request_buffer.size - cb->buf_idx;
-	u32 msg_slots = mei_data2slots(len);
-
-	mei_hdr.host_addr = cl->host_client_id;
-	mei_hdr.me_addr = cl->me_client_id;
-	mei_hdr.reserved = 0;
-
-	if (*slots >= msg_slots) {
-		mei_hdr.length = len;
-		mei_hdr.msg_complete = 1;
-	/* Split the message only if we can write the whole host buffer */
-	} else if (*slots == dev->hbuf_depth) {
-		msg_slots = *slots;
-		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
-		mei_hdr.length = len;
-		mei_hdr.msg_complete = 0;
-	} else {
-		/* wait for next time the host buffer is empty */
-		return 0;
-	}
-
-	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
-			cb->request_buffer.size, cb->buf_idx);
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(&mei_hdr));
-
-	*slots -=  msg_slots;
-	if (mei_write_message(dev, &mei_hdr,
-			cb->request_buffer.data + cb->buf_idx)) {
-		cl->status = -ENODEV;
-		list_move_tail(&cb->list, &cmpl_list->list);
-		return -ENODEV;
-	}
-
-
-	cl->status = 0;
-	cb->buf_idx += mei_hdr.length;
-	if (mei_hdr.msg_complete) {
-		if (mei_cl_flow_ctrl_reduce(cl))
-			return -ENODEV;
-		list_move_tail(&cb->list, &dev->write_waiting_list.list);
-	}
-
-	return 0;
-}
 
 /**
  * mei_irq_read_handler - bottom half read routine after ISR to
-- 
1.8.1.2

