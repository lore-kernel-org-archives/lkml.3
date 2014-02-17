Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaBQNOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:14:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:4049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaBQNOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852886"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/11 RESEND] mei: revamp writing slot counting
Date: Mon, 17 Feb 2014 15:13:18 +0200
Message-Id: <1392642807-8878-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since txe use doorbell and not circular buffer
we have to cheat in write slot counting, txe always consume all the
slots upon write. In order for it to work we need to track
slots using mei_hbuf_empty_slots() instead of tracking it in mei layer

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 19 ++++++-----
 drivers/misc/mei/client.c    | 19 +++++------
 drivers/misc/mei/client.h    |  4 +--
 drivers/misc/mei/hw-me.c     |  2 +-
 drivers/misc/mei/hw-txe.c    | 21 +++++++-----
 drivers/misc/mei/hw-txe.h    |  1 +
 drivers/misc/mei/interrupt.c | 78 +++++++++++++++++---------------------------
 drivers/misc/mei/mei_dev.h   |  4 +--
 8 files changed, 68 insertions(+), 80 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 71af677..b8dfc61 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -441,23 +441,23 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 
 
 /**
- * mei_amthif_irq_write_completed - processes completed iamthif operation.
+ * mei_amthif_irq_write - write iamthif command in irq thread context.
  *
  * @dev: the device structure.
- * @slots: free slots.
  * @cb_pos: callback block.
  * @cl: private data of the file object.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
-				  s32 *slots, struct mei_cl_cb *cmpl_list)
+int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
+			 struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
 	struct mei_msg_hdr mei_hdr;
 	size_t len = dev->iamthif_msg_buf_size - dev->iamthif_msg_buf_index;
 	u32 msg_slots = mei_data2slots(len);
+	int slots;
 	int rets;
 
 	rets = mei_cl_flow_ctrl_creds(cl);
@@ -474,13 +474,15 @@ int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 	mei_hdr.reserved = 0;
 	mei_hdr.internal = 0;
 
-	if (*slots >= msg_slots) {
+	slots = mei_hbuf_empty_slots(dev);
+
+	if (slots >= msg_slots) {
 		mei_hdr.length = len;
 		mei_hdr.msg_complete = 1;
 	/* Split the message only if we can write the whole host buffer */
-	} else if (*slots == dev->hbuf_depth) {
-		msg_slots = *slots;
-		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+	} else if (slots == dev->hbuf_depth) {
+		msg_slots = slots;
+		len = (slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
 		mei_hdr.length = len;
 		mei_hdr.msg_complete = 0;
 	} else {
@@ -490,7 +492,6 @@ int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 
 	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(&mei_hdr));
 
-	*slots -=  msg_slots;
 	rets = mei_write_message(dev, &mei_hdr,
 			dev->iamthif_msg_buf + dev->iamthif_msg_buf_index);
 	if (rets) {
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 24fa85e..f505764 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -701,27 +701,26 @@ err:
 }
 
 /**
- * mei_cl_irq_write_complete - write a message to device
+ * mei_cl_irq_write - write a message to device
  *	from the interrupt thread context
  *
  * @cl: client
  * @cb: callback block.
- * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise error.
  */
-int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
-				     s32 *slots, struct mei_cl_cb *cmpl_list)
+int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
+		     struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev;
 	struct mei_msg_data *buf;
 	struct mei_msg_hdr mei_hdr;
 	size_t len;
 	u32 msg_slots;
+	int slots;
 	int rets;
 
-
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
 
@@ -738,6 +737,7 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return 0;
 	}
 
+	slots = mei_hbuf_empty_slots(dev);
 	len = buf->size - cb->buf_idx;
 	msg_slots = mei_data2slots(len);
 
@@ -746,13 +746,13 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 	mei_hdr.reserved = 0;
 	mei_hdr.internal = cb->internal;
 
-	if (*slots >= msg_slots) {
+	if (slots >= msg_slots) {
 		mei_hdr.length = len;
 		mei_hdr.msg_complete = 1;
 	/* Split the message only if we can write the whole host buffer */
-	} else if (*slots == dev->hbuf_depth) {
-		msg_slots = *slots;
-		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+	} else if (slots == dev->hbuf_depth) {
+		msg_slots = slots;
+		len = (slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
 		mei_hdr.length = len;
 		mei_hdr.msg_complete = 0;
 	} else {
@@ -763,7 +763,6 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 	cl_dbg(dev, cl, "buf: size = %d idx = %lu\n",
 			cb->request_buffer.size, cb->buf_idx);
 
-	*slots -=  msg_slots;
 	rets = mei_write_message(dev, &mei_hdr, buf->data + cb->buf_idx);
 	if (rets) {
 		cl->status = rets;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index c8396e5..c11b663 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -102,8 +102,8 @@ int mei_cl_disconnect(struct mei_cl *cl);
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
 int mei_cl_read_start(struct mei_cl *cl, size_t length);
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking);
-int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
-				s32 *slots, struct mei_cl_cb *cmpl_list);
+int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
+		     struct mei_cl_cb *cmpl_list);
 
 void mei_cl_complete(struct mei_cl *cl, struct mei_cl_cb *cb);
 
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index b0c42d6..84165cc 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -354,7 +354,7 @@ static int mei_me_write_message(struct mei_device *dev,
 
 	dw_cnt = mei_data2slots(length);
 	if (empty_slots < 0 || dw_cnt > empty_slots)
-		return -EIO;
+		return -EMSGSIZE;
 
 	mei_me_reg_write(hw, H_CB_WW, *((u32 *) header));
 
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index ab0442e..69a5ce7 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -565,7 +565,9 @@ static int mei_txe_write(struct mei_device *dev,
 	struct mei_txe_hw *hw = to_txe_hw(dev);
 	unsigned long rem;
 	unsigned long length;
+	int slots = dev->hbuf_depth;
 	u32 *reg_buf = (u32 *)buf;
+	u32 dw_cnt;
 	int i;
 
 	if (WARN_ON(!header || !buf))
@@ -575,11 +577,9 @@ static int mei_txe_write(struct mei_device *dev,
 
 	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
 
-	if ((length + sizeof(struct mei_msg_hdr)) > PAYLOAD_SIZE) {
-		dev_err(&dev->pdev->dev, "write length exceeded = %ld > %d\n",
-			length + sizeof(struct mei_msg_hdr), PAYLOAD_SIZE);
-		return -ERANGE;
-	}
+	dw_cnt = mei_data2slots(length);
+	if (dw_cnt > slots)
+		return -EMSGSIZE;
 
 	if (WARN(!hw->aliveness, "txe write: aliveness not asserted\n"))
 		return -EAGAIN;
@@ -604,6 +604,9 @@ static int mei_txe_write(struct mei_device *dev,
 		mei_txe_input_payload_write(dev, i + 1, reg);
 	}
 
+	/* after each write the whole buffer is consumed */
+	hw->slots = 0;
+
 	/* Set Input-Doorbell */
 	mei_txe_input_doorbell_set(hw);
 
@@ -631,7 +634,8 @@ static size_t mei_txe_hbuf_max_len(const struct mei_device *dev)
  */
 static int mei_txe_hbuf_empty_slots(struct mei_device *dev)
 {
-	return dev->hbuf_depth;
+	struct mei_txe_hw *hw = to_txe_hw(dev);
+	return hw->slots;
 }
 
 /**
@@ -977,11 +981,12 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 		}
 	}
 	/* Input Ready: Detection if host can write to SeC */
-	if (test_and_clear_bit(TXE_INTR_IN_READY_BIT, &hw->intr_cause))
+	if (test_and_clear_bit(TXE_INTR_IN_READY_BIT, &hw->intr_cause)) {
 		dev->hbuf_is_ready = true;
+		hw->slots = dev->hbuf_depth;
+	}
 
 	if (hw->aliveness && dev->hbuf_is_ready) {
-
 		/* get the real register value */
 		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 		rets = mei_irq_write_handler(dev, &complete_list);
diff --git a/drivers/misc/mei/hw-txe.h b/drivers/misc/mei/hw-txe.h
index 857d88c..3d8d6e5 100644
--- a/drivers/misc/mei/hw-txe.h
+++ b/drivers/misc/mei/hw-txe.h
@@ -44,6 +44,7 @@ struct mei_txe_hw {
 	void __iomem *mem_addr[NUM_OF_MEM_BARS];
 	u32 aliveness;
 	u32 readiness;
+	u32 slots;
 
 	wait_queue_head_t wait_aliveness;
 	bool recvd_aliveness;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 8f8ab08..8fbdb59 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -165,25 +165,24 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
  *
  * @cl: client
  * @cb: callback block.
- * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
 static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
-			s32 *slots, struct mei_cl_cb *cmpl_list)
+				     struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
+	u32 msg_slots;
+	int slots;
 	int ret;
 
-	u32 msg_slots =
-		mei_data2slots(sizeof(struct hbm_client_connect_response));
+	slots = mei_hbuf_empty_slots(dev);
+	msg_slots = mei_data2slots(sizeof(struct hbm_client_connect_response));
 
-	if (*slots < msg_slots)
+	if (slots < msg_slots)
 		return -EMSGSIZE;
 
-	*slots -= msg_slots;
-
 	ret = mei_hbm_cl_disconnect_rsp(dev, cl);
 
 	cl->state = MEI_FILE_DISCONNECTED;
@@ -201,24 +200,23 @@ static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
  *
  * @cl: client
  * @cb: callback block.
- * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
 static int mei_cl_irq_close(struct mei_cl *cl, struct mei_cl_cb *cb,
-			s32 *slots, struct mei_cl_cb *cmpl_list)
+			    struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
+	u32 msg_slots;
+	int slots;
 
-	u32 msg_slots =
-		mei_data2slots(sizeof(struct hbm_client_connect_request));
+	msg_slots = mei_data2slots(sizeof(struct hbm_client_connect_request));
+	slots = mei_hbuf_empty_slots(dev);
 
-	if (*slots < msg_slots)
+	if (slots < msg_slots)
 		return -EMSGSIZE;
 
-	*slots -= msg_slots;
-
 	if (mei_hbm_cl_disconnect_req(dev, cl)) {
 		cl->status = 0;
 		cb->buf_idx = 0;
@@ -242,27 +240,23 @@ static int mei_cl_irq_close(struct mei_cl *cl, struct mei_cl_cb *cb,
  *
  * @cl: client
  * @cb: callback block.
- * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
 static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
-			   s32 *slots, struct mei_cl_cb *cmpl_list)
+			   struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
-	u32 msg_slots = mei_data2slots(sizeof(struct hbm_flow_control));
-
+	u32 msg_slots;
+	int slots;
 	int ret;
 
+	msg_slots = mei_data2slots(sizeof(struct hbm_flow_control));
+	slots = mei_hbuf_empty_slots(dev);
 
-	if (*slots < msg_slots) {
-		/* return the cancel routine */
-		list_del(&cb->list);
+	if (slots < msg_slots)
 		return -EMSGSIZE;
-	}
-
-	*slots -= msg_slots;
 
 	ret = mei_hbm_cl_flow_control_req(dev, cl);
 	if (ret) {
@@ -283,30 +277,26 @@ static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
  *
  * @cl: client
  * @cb: callback block.
- * @slots: free slots.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
 static int mei_cl_irq_connect(struct mei_cl *cl, struct mei_cl_cb *cb,
-			   s32 *slots, struct mei_cl_cb *cmpl_list)
+			      struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
+	u32 msg_slots;
+	int slots;
 	int ret;
 
-	u32 msg_slots =
-		mei_data2slots(sizeof(struct hbm_client_connect_request));
+	msg_slots = mei_data2slots(sizeof(struct hbm_client_connect_request));
+	slots = mei_hbuf_empty_slots(dev);
 
 	if (mei_cl_is_other_connecting(cl))
 		return 0;
 
-	if (*slots < msg_slots) {
-		/* return the cancel routine */
-		list_del(&cb->list);
+	if (slots < msg_slots)
 		return -EMSGSIZE;
-	}
-
-	*slots -=  msg_slots;
 
 	cl->state = MEI_FILE_CONNECTING;
 
@@ -494,13 +484,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
 			else if (mei_cl_flow_ctrl_reduce(&dev->wd_cl))
 				return -ENODEV;
-
 			dev->wd_pending = false;
-
-			if (dev->wd_state == MEI_WD_RUNNING)
-				slots -= mei_data2slots(MEI_WD_START_MSG_SIZE);
-			else
-				slots -= mei_data2slots(MEI_WD_STOP_MSG_SIZE);
 		}
 	}
 
@@ -515,28 +499,28 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		switch (cb->fop_type) {
 		case MEI_FOP_CLOSE:
 			/* send disconnect message */
-			ret = mei_cl_irq_close(cl, cb, &slots, cmpl_list);
+			ret = mei_cl_irq_close(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
 		case MEI_FOP_READ:
 			/* send flow control message */
-			ret = mei_cl_irq_read(cl, cb, &slots, cmpl_list);
+			ret = mei_cl_irq_read(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
 		case MEI_FOP_CONNECT:
 			/* connect message */
-			ret = mei_cl_irq_connect(cl, cb, &slots, cmpl_list);
+			ret = mei_cl_irq_connect(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
 		case MEI_FOP_DISCONNECT_RSP:
 			/* send disconnect resp */
-			ret = mei_cl_irq_disconnect_rsp(cl, cb, &slots, cmpl_list);
+			ret = mei_cl_irq_disconnect_rsp(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
 		default:
@@ -551,11 +535,9 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		if (cl == NULL)
 			continue;
 		if (cl == &dev->iamthif_cl)
-			ret = mei_amthif_irq_write_complete(cl, cb,
-						&slots, cmpl_list);
+			ret = mei_amthif_irq_write(cl, cb, cmpl_list);
 		else
-			ret = mei_cl_irq_write_complete(cl, cb,
-						&slots, cmpl_list);
+			ret = mei_cl_irq_write(cl, cb, cmpl_list);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c77b747..49bf2cf 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -514,8 +514,8 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 
 void mei_amthif_run_next_cmd(struct mei_device *dev);
 
-int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
-				  s32 *slots, struct mei_cl_cb *cmpl_list);
+int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
+			struct mei_cl_cb *cmpl_list);
 
 void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
 int mei_amthif_irq_read_msg(struct mei_device *dev,
-- 
1.8.5.3

