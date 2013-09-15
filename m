Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3IOPMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:12:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:11876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab3IOPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:12:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,909,1371106800"; 
   d="scan'208";a="403616413"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: prefix client log messages with client me and host ids
Date: Sun, 15 Sep 2013 18:11:07 +0300
Message-Id: <1379257867-9107-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379257867-9107-1-git-send-email-tomas.winkler@intel.com>
References: <1379257867-9107-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

define cl_dbg and cl_err macros that add me and host id
prefix for debug and error log messages so we can track
for the client context of the flow.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c    | 43 ++++++++++++++++++++++---------------------
 drivers/misc/mei/client.h    |  9 +++++++++
 drivers/misc/mei/interrupt.c | 18 +++++++-----------
 3 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e0684b4..77b8d9b 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -187,10 +187,14 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
  */
 int mei_cl_flush_queues(struct mei_cl *cl)
 {
+	struct mei_device *dev;
+
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
 
-	dev_dbg(&cl->dev->pdev->dev, "remove list entry belonging to cl\n");
+	dev = cl->dev;
+
+	cl_dbg(dev, cl, "remove list entry belonging to cl\n");
 	mei_io_list_flush(&cl->dev->read_list, cl);
 	mei_io_list_flush(&cl->dev->write_list, cl);
 	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
@@ -296,7 +300,7 @@ int mei_cl_link(struct mei_cl *cl, int id)
 
 	cl->state = MEI_FILE_INITIALIZING;
 
-	dev_dbg(&dev->pdev->dev, "link cl host id = %d\n", cl->host_client_id);
+	cl_dbg(dev, cl, "link cl\n");
 	return 0;
 }
 
@@ -322,7 +326,7 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
 		if (cl->host_client_id == pos->host_client_id) {
-			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
+			cl_dbg(dev, cl, "remove host client = %d, ME client = %d\n",
 				pos->host_client_id, pos->me_client_id);
 			list_del_init(&pos->link);
 			break;
@@ -390,6 +394,8 @@ int mei_cl_disconnect(struct mei_cl *cl)
 
 	dev = cl->dev;
 
+	cl_dbg(dev, cl, "disconnecting");
+
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
 
@@ -402,13 +408,13 @@ int mei_cl_disconnect(struct mei_cl *cl)
 		dev->hbuf_is_ready = false;
 		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
-			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
+			cl_err(dev, cl, "failed to disconnect.\n");
 			goto free;
 		}
 		mdelay(10); /* Wait for hardware disconnection ready */
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
-		dev_dbg(&dev->pdev->dev, "add disconnect cb to control write list\n");
+		cl_dbg(dev, cl, "add disconnect cb to control write list\n");
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 
 	}
@@ -421,18 +427,17 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	mutex_lock(&dev->device_lock);
 	if (MEI_FILE_DISCONNECTED == cl->state) {
 		rets = 0;
-		dev_dbg(&dev->pdev->dev, "successfully disconnected from FW client.\n");
+		cl_dbg(dev, cl, "successfully disconnected from FW client.\n");
 	} else {
 		rets = -ENODEV;
 		if (MEI_FILE_DISCONNECTED != cl->state)
-			dev_dbg(&dev->pdev->dev, "wrong status client disconnect.\n");
+			cl_err(dev, cl, "wrong status client disconnect.\n");
 
 		if (err)
-			dev_dbg(&dev->pdev->dev,
-					"wait failed disconnect err=%08x\n",
+			cl_dbg(dev, cl, "wait failed disconnect err=%08x\n",
 					err);
 
-		dev_dbg(&dev->pdev->dev, "failed to disconnect from FW client.\n");
+		cl_err(dev, cl, "failed to disconnect from FW client.\n");
 	}
 
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);
@@ -639,13 +644,12 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		return -ENODEV;
 
 	if (cl->read_cb) {
-		dev_dbg(&dev->pdev->dev, "read is pending.\n");
+		cl_dbg(dev, cl, "read is pending.\n");
 		return -EBUSY;
 	}
 	i = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (i < 0) {
-		dev_err(&dev->pdev->dev, "no such me client %d\n",
-			cl->me_client_id);
+		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return  -ENODEV;
 	}
 
@@ -664,6 +668,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 	if (dev->hbuf_is_ready) {
 		dev->hbuf_is_ready = false;
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
+			cl_err(dev, cl, "flow control send failed\n");
 			rets = -ENODEV;
 			goto err;
 		}
@@ -714,9 +719,8 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return 0;
 	}
 
-	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
+	cl_dbg(dev, cl, "buf: size = %d idx = %lu\n",
 			cb->request_buffer.size, cb->buf_idx);
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(&mei_hdr));
 
 	*slots -=  msg_slots;
 	if (mei_write_message(dev, &mei_hdr,
@@ -767,7 +771,7 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 	buf = &cb->request_buffer;
 
-	dev_dbg(&dev->pdev->dev, "mei_cl_write %d\n", buf->size);
+	cl_dbg(dev, cl, "mei_cl_write %d\n", buf->size);
 
 
 	cb->fop_type = MEI_FOP_WRITE;
@@ -800,9 +804,6 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 	mei_hdr.me_addr = cl->me_client_id;
 	mei_hdr.reserved = 0;
 
-	dev_dbg(&dev->pdev->dev, "write " MEI_HDR_FMT "\n",
-		MEI_HDR_PRM(&mei_hdr));
-
 
 	if (mei_write_message(dev, &mei_hdr, buf->data)) {
 		rets = -EIO;
@@ -898,11 +899,11 @@ void mei_cl_all_wakeup(struct mei_device *dev)
 	struct mei_cl *cl, *next;
 	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
 		if (waitqueue_active(&cl->rx_wait)) {
-			dev_dbg(&dev->pdev->dev, "Waking up reading client!\n");
+			cl_dbg(dev, cl, "Waking up reading client!\n");
 			wake_up_interruptible(&cl->rx_wait);
 		}
 		if (waitqueue_active(&cl->tx_wait)) {
-			dev_dbg(&dev->pdev->dev, "Waking up writing client!\n");
+			cl_dbg(dev, cl, "Waking up writing client!\n");
 			wake_up_interruptible(&cl->tx_wait);
 		}
 	}
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 892cc42..c8396e5 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -115,4 +115,13 @@ void mei_cl_all_disconnect(struct mei_device *dev);
 void mei_cl_all_wakeup(struct mei_device *dev);
 void mei_cl_all_write_clear(struct mei_device *dev);
 
+#define MEI_CL_FMT "cl:host=%02d me=%02d "
+#define MEI_CL_PRM(cl) (cl)->host_client_id, (cl)->me_client_id
+
+#define cl_dbg(dev, cl, format, arg...) \
+	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
+
+#define cl_err(dev, cl, format, arg...) \
+	dev_err(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
+
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 4b59cb7..d27804e 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -113,13 +113,13 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 
 		if (cb->response_buffer.size == 0 ||
 		    cb->response_buffer.data == NULL) {
-			dev_err(&dev->pdev->dev, "response buffer is not allocated.\n");
+			cl_err(dev, cl, "response buffer is not allocated.\n");
 			list_del(&cb->list);
 			return -ENOMEM;
 		}
 
 		if (cb->response_buffer.size < mei_hdr->length + cb->buf_idx) {
-			dev_dbg(&dev->pdev->dev, "message overflow. size %d len %d idx %ld\n",
+			cl_dbg(dev, cl, "message overflow. size %d len %d idx %ld\n",
 				cb->response_buffer.size,
 				mei_hdr->length, cb->buf_idx);
 			buffer = krealloc(cb->response_buffer.data,
@@ -127,7 +127,7 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 					  GFP_KERNEL);
 
 			if (!buffer) {
-				dev_err(&dev->pdev->dev, "allocation failed.\n");
+				cl_err(dev, cl, "allocation failed.\n");
 				list_del(&cb->list);
 				return -ENOMEM;
 			}
@@ -143,9 +143,7 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 		if (mei_hdr->msg_complete) {
 			cl->status = 0;
 			list_del(&cb->list);
-			dev_dbg(&dev->pdev->dev, "completed read H cl = %d, ME cl = %d, length = %lu\n",
-				cl->host_client_id,
-				cl->me_client_id,
+			cl_dbg(dev, cl, "completed read length = %lu\n",
 				cb->buf_idx);
 			list_add_tail(&cb->list, &complete_list->list);
 		}
@@ -423,12 +421,12 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		if (MEI_WRITING == cl->writing_state &&
 		    cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
-			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
+			cl_dbg(dev, cl, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
 			list_add_tail(&cb->list, &cmpl_list->list);
 		}
 		if (cl == &dev->iamthif_cl) {
-			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
+			cl_dbg(dev, cl, "check iamthif flow control.\n");
 			if (dev->iamthif_flow_control_pending) {
 				ret = mei_amthif_irq_read(dev, &slots);
 				if (ret)
@@ -510,9 +508,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		if (cl == NULL)
 			continue;
 		if (mei_cl_flow_ctrl_creds(cl) <= 0) {
-			dev_dbg(&dev->pdev->dev,
-				"No flow control credentials for client %d, not sending.\n",
-				cl->host_client_id);
+			cl_dbg(dev, cl, "No flow control credentials, not sending.\n");
 			continue;
 		}
 
-- 
1.8.3.1

