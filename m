Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3CKQ3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:29:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:50682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab3CKQ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208";a="299229608"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: revamp mei_data2slots
Date: Mon, 11 Mar 2013 18:27:02 +0200
Message-Id: <1363019223-624-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Move the mei_data2slots to mei_dev.h as it will be used
by the all supported HW.
2. Change return value from u8 to u32 to catch possible overflows
3. Eliminate computing the slots number twice in the same function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 11 +++++-----
 drivers/misc/mei/hw-me.c     |  3 ++-
 drivers/misc/mei/hw-me.h     |  6 ------
 drivers/misc/mei/interrupt.c | 50 +++++++++++++++++++++++++-------------------
 drivers/misc/mei/mei_dev.h   | 11 ++++++++++
 5 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index c86d7e3..9a5e8c7 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -449,7 +449,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 	struct mei_msg_hdr mei_hdr;
 	struct mei_cl *cl = cb->cl;
 	size_t len = dev->iamthif_msg_buf_size - dev->iamthif_msg_buf_index;
-	size_t msg_slots = mei_data2slots(len);
+	u32 msg_slots = mei_data2slots(len);
 
 	mei_hdr.host_addr = cl->host_client_id;
 	mei_hdr.me_addr = cl->me_client_id;
@@ -566,12 +566,13 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
  */
 int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 {
+	u32 msg_slots = mei_data2slots(sizeof(struct hbm_flow_control));
 
-	if (((*slots) * sizeof(u32)) < (sizeof(struct mei_msg_hdr)
-			+ sizeof(struct hbm_flow_control))) {
+	if (*slots < msg_slots)
 		return -EMSGSIZE;
-	}
-	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
+
+	*slots -= msg_slots;
+
 	if (mei_hbm_cl_flow_control_req(dev, &dev->iamthif_cl)) {
 		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
 		return -EIO;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 642c622..4d4738a 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -305,10 +305,11 @@ static int mei_me_write_message(struct mei_device *dev,
 			unsigned char *buf)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
-	unsigned long rem, dw_cnt;
+	unsigned long rem;
 	unsigned long length = header->length;
 	u32 *reg_buf = (u32 *)buf;
 	u32 hcsr;
+	u32 dw_cnt;
 	int i;
 	int empty_slots;
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 8518d3e..80bd829 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -36,12 +36,6 @@ struct mei_me_hw {
 
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev);
 
-/* get slots (dwords) from a message length + header (bytes) */
-static inline unsigned char mei_data2slots(size_t length)
-{
-	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
-}
-
 irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id);
 irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 3535b26..14c70b8 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -153,25 +153,27 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 				struct mei_cl *cl,
 				struct mei_cl_cb *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_connect_request)))
-		return -EBADMSG;
+	u32 msg_slots =
+		mei_data2slots(sizeof(struct hbm_client_connect_request));
 
-	*slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
+	if (*slots < msg_slots)
+		return -EMSGSIZE;
+
+	*slots -= msg_slots;
 
 	if (mei_hbm_cl_disconnect_req(dev, cl)) {
 		cl->status = 0;
 		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->list, &cmpl_list->list);
-		return -EMSGSIZE;
-	} else {
-		cl->state = MEI_FILE_DISCONNECTING;
-		cl->status = 0;
-		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
-		cl->timer_count = MEI_CONNECT_TIMEOUT;
+		return -EIO;
 	}
 
+	cl->state = MEI_FILE_DISCONNECTING;
+	cl->status = 0;
+	cb_pos->buf_idx = 0;
+	list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
+	cl->timer_count = MEI_CONNECT_TIMEOUT;
+
 	return 0;
 }
 
@@ -192,14 +194,15 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 			struct mei_cl *cl,
 			struct mei_cl_cb *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_flow_control))) {
+	u32 msg_slots = mei_data2slots(sizeof(struct hbm_flow_control));
+
+	if (*slots < msg_slots) {
 		/* return the cancel routine */
 		list_del(&cb_pos->list);
-		return -EBADMSG;
+		return -EMSGSIZE;
 	}
 
-	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
+	*slots -= msg_slots;
 
 	if (mei_hbm_cl_flow_control_req(dev, cl)) {
 		cl->status = -ENODEV;
@@ -229,15 +232,19 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 			struct mei_cl *cl,
 			struct mei_cl_cb *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_connect_request))) {
+	u32 msg_slots =
+		mei_data2slots(sizeof(struct hbm_client_connect_request));
+
+	if (*slots < msg_slots) {
 		/* return the cancel routine */
 		list_del(&cb_pos->list);
-		return -EBADMSG;
+		return -EMSGSIZE;
 	}
 
+	*slots -=  msg_slots;
+
 	cl->state = MEI_FILE_CONNECTING;
-	*slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
+
 	if (mei_hbm_cl_connect_req(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->buf_idx = 0;
@@ -266,7 +273,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 	struct mei_msg_hdr mei_hdr;
 	struct mei_cl *cl = cb->cl;
 	size_t len = cb->request_buffer.size - cb->buf_idx;
-	size_t msg_slots = mei_data2slots(len);
+	u32 msg_slots = mei_data2slots(len);
 
 	mei_hdr.host_addr = cl->host_client_id;
 	mei_hdr.me_addr = cl->me_client_id;
@@ -419,8 +426,7 @@ end:
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_irq_write_handler(struct mei_device *dev,
-				struct mei_cl_cb *cmpl_list)
+int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 {
 
 	struct mei_cl *cl;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 9787381..224c0e3 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -374,6 +374,17 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 	return msecs_to_jiffies(sec * MSEC_PER_SEC);
 }
 
+/**
+ * mei_data2slots - get slots - number of (dwords) from a message length
+ *	+ size of the mei header
+ * @length - size of the messages in bytes
+ * returns  - number of slots
+ */
+static inline u32 mei_data2slots(size_t length)
+{
+	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
+}
+
 
 /*
  * mei init function prototypes
-- 
1.8.1.3

