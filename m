Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3DSTC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:02:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:47770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab3DSTC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="288738719"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: revamp mei_irq_read_client_message function
Date: Fri, 19 Apr 2013 22:01:34 +0300
Message-Id: <1366398096-14756-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Rename the function and change parameters order,
 so that first parameter is mei_device
2. Simplify the function code flow
3. Rename helper functions to more self descriptive names
4. Use helpers common functions where possible

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 124 +++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 58 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 8e4db3d..9bf64c0 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -82,80 +82,90 @@ void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 	}
 }
 EXPORT_SYMBOL_GPL(mei_irq_compl_handler);
+
 /**
- * _mei_irq_thread_state_ok - checks if mei header matches file private data
+ * mei_cl_hbm_equal - check if hbm is addressed to the client
  *
- * @cl: private data of the file object
+ * @cl: host client
  * @mei_hdr: header of mei client message
  *
- * returns !=0 if matches, 0 if no match.
+ * returns true if matches, false otherwise
+ */
+static inline int mei_cl_hbm_equal(struct mei_cl *cl,
+			struct mei_msg_hdr *mei_hdr)
+{
+	return cl->host_client_id == mei_hdr->host_addr &&
+		cl->me_client_id == mei_hdr->me_addr;
+}
+/**
+ * mei_cl_is_reading - checks if the client
+		is the one to read this message
+ *
+ * @cl: mei client
+ * @mei_hdr: header of mei message
+ *
+ * returns true on match and false otherwise
  */
-static int _mei_irq_thread_state_ok(struct mei_cl *cl,
-				struct mei_msg_hdr *mei_hdr)
+static bool mei_cl_is_reading(struct mei_cl *cl, struct mei_msg_hdr *mei_hdr)
 {
-	return (cl->host_client_id == mei_hdr->host_addr &&
-		cl->me_client_id == mei_hdr->me_addr &&
+	return mei_cl_hbm_equal(cl, mei_hdr) &&
 		cl->state == MEI_FILE_CONNECTED &&
-		MEI_READ_COMPLETE != cl->reading_state);
+		cl->reading_state != MEI_READ_COMPLETE;
 }
 
 /**
- * mei_irq_thread_read_client_message - bottom half read routine after ISR to
- * handle the read mei client message data processing.
+ * mei_irq_read_client_message - process client message
  *
- * @complete_list: An instance of our list structure
  * @dev: the device structure
  * @mei_hdr: header of mei client message
+ * @complete_list: An instance of our list structure
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_read_client_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev,
-		struct mei_msg_hdr *mei_hdr)
+static int mei_cl_irq_read_msg(struct mei_device *dev,
+			       struct mei_msg_hdr *mei_hdr,
+			       struct mei_cl_cb *complete_list)
 {
 	struct mei_cl *cl;
-	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
+	struct mei_cl_cb *cb, *next;
 	unsigned char *buffer = NULL;
 
-	dev_dbg(&dev->pdev->dev, "start client msg\n");
-	if (list_empty(&dev->read_list.list))
-		goto quit;
-
-	list_for_each_entry_safe(cb_pos, cb_next, &dev->read_list.list, list) {
-		cl = cb_pos->cl;
-		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr)) {
-			cl->reading_state = MEI_READING;
-			buffer = cb_pos->response_buffer.data + cb_pos->buf_idx;
-
-			if (cb_pos->response_buffer.size <
-					mei_hdr->length + cb_pos->buf_idx) {
-				dev_dbg(&dev->pdev->dev, "message overflow.\n");
-				list_del(&cb_pos->list);
-				return -ENOMEM;
-			}
-			if (buffer)
-				mei_read_slots(dev, buffer, mei_hdr->length);
-
-			cb_pos->buf_idx += mei_hdr->length;
-			if (mei_hdr->msg_complete) {
-				cl->status = 0;
-				list_del(&cb_pos->list);
-				dev_dbg(&dev->pdev->dev,
-					"completed read H cl = %d, ME cl = %d, length = %lu\n",
-					cl->host_client_id,
-					cl->me_client_id,
-					cb_pos->buf_idx);
-
-				list_add_tail(&cb_pos->list,
-						&complete_list->list);
-			}
+	list_for_each_entry_safe(cb, next, &dev->read_list.list, list) {
+		cl = cb->cl;
+		if (!cl || !mei_cl_is_reading(cl, mei_hdr))
+			continue;
 
-			break;
+		cl->reading_state = MEI_READING;
+
+		if (cb->response_buffer.size == 0 ||
+		    cb->response_buffer.data == NULL) {
+			dev_err(&dev->pdev->dev, "response buffer is not allocated.\n");
+			list_del(&cb->list);
+			return -ENOMEM;
+		}
+
+		if (cb->response_buffer.size < mei_hdr->length + cb->buf_idx) {
+			dev_warn(&dev->pdev->dev, "message overflow.\n");
+			list_del(&cb->list);
+			return -ENOMEM;
 		}
 
+		buffer = cb->response_buffer.data + cb->buf_idx;
+		mei_read_slots(dev, buffer, mei_hdr->length);
+
+		cb->buf_idx += mei_hdr->length;
+		if (mei_hdr->msg_complete) {
+			cl->status = 0;
+			list_del(&cb->list);
+			dev_dbg(&dev->pdev->dev, "completed read H cl = %d, ME cl = %d, length = %lu\n",
+				cl->host_client_id,
+				cl->me_client_id,
+				cb->buf_idx);
+			list_add_tail(&cb->list, &complete_list->list);
+		}
+		break;
 	}
 
-quit:
 	dev_dbg(&dev->pdev->dev, "message read\n");
 	if (!buffer) {
 		mei_read_slots(dev, dev->rd_msg_buf, mei_hdr->length);
@@ -386,8 +396,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 					" client = %d, ME client = %d\n",
 					cl_pos->host_client_id,
 					cl_pos->me_client_id);
-			if (cl_pos->host_client_id == mei_hdr->host_addr &&
-			    cl_pos->me_client_id == mei_hdr->me_addr)
+			if (mei_cl_hbm_equal(cl_pos, mei_hdr))
 				break;
 		}
 
@@ -398,7 +407,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		}
 	}
 	if (((*slots) * sizeof(u32)) < mei_hdr->length) {
-		dev_dbg(&dev->pdev->dev,
+		dev_err(&dev->pdev->dev,
 				"we can't read the message slots =%08x.\n",
 				*slots);
 		/* we can't read the message */
@@ -414,20 +423,19 @@ int mei_irq_read_handler(struct mei_device *dev,
 	} else if (mei_hdr->host_addr == dev->iamthif_cl.host_client_id &&
 		   (MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
 		   (dev->iamthif_state == MEI_IAMTHIF_READING)) {
-		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
 
+		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
 		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 		ret = mei_amthif_irq_read_msg(dev, mei_hdr, cmpl_list);
 		if (ret)
 			goto end;
 	} else {
-		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_client_message.\n");
-		ret = mei_irq_thread_read_client_message(cmpl_list,
-							 dev, mei_hdr);
+		dev_dbg(&dev->pdev->dev, "call mei_cl_irq_read_msg.\n");
+		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
+		ret = mei_cl_irq_read_msg(dev, mei_hdr, cmpl_list);
 		if (ret)
 			goto end;
-
 	}
 
 	/* reset the number of slots and header */
@@ -436,7 +444,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 
 	if (*slots == -EOVERFLOW) {
 		/* overflow - reset */
-		dev_dbg(&dev->pdev->dev, "resetting due to slots overflow.\n");
+		dev_err(&dev->pdev->dev, "resetting due to slots overflow.\n");
 		/* set the event since message has been read */
 		ret = -ERANGE;
 		goto end;
-- 
1.8.1.2

