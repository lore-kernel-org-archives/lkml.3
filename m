Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3IPUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3IPUqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571771"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/7] mei: push credentials inside the irq write handler
Date: Mon, 16 Sep 2013 23:44:44 +0300
Message-Id: <1379364288-16374-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this eventually allows as use a single write queue
both for control and data messages and removing possible
race

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |  9 +++++++++
 drivers/misc/mei/client.c    | 30 +++++++++++++++++++++++++-----
 drivers/misc/mei/interrupt.c |  5 -----
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index e4a4e2e..226c3f3 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -461,6 +461,15 @@ int mei_amthif_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 	u32 msg_slots = mei_data2slots(len);
 	int rets;
 
+	rets = mei_cl_flow_ctrl_creds(cl);
+	if (rets < 0)
+		return rets;
+
+	if (rets == 0) {
+		cl_dbg(dev, cl, "No flow control credentials: not sending.\n");
+		return 0;
+	}
+
 	mei_hdr.host_addr = cl->host_client_id;
 	mei_hdr.me_addr = cl->me_client_id;
 	mei_hdr.reserved = 0;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index c59c8a2..88bcde4 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -696,12 +696,33 @@ err:
 int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 				     s32 *slots, struct mei_cl_cb *cmpl_list)
 {
-	struct mei_device *dev = cl->dev;
+	struct mei_device *dev;
+	struct mei_msg_data *buf;
 	struct mei_msg_hdr mei_hdr;
-	size_t len = cb->request_buffer.size - cb->buf_idx;
-	u32 msg_slots = mei_data2slots(len);
+	size_t len;
+	u32 msg_slots;
 	int rets;
 
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	buf = &cb->request_buffer;
+
+	rets = mei_cl_flow_ctrl_creds(cl);
+	if (rets < 0)
+		return rets;
+
+	if (rets == 0) {
+		cl_dbg(dev, cl,	"No flow control credentials: not sending.\n");
+		return 0;
+	}
+
+	len = buf->size - cb->buf_idx;
+	msg_slots = mei_data2slots(len);
+
 	mei_hdr.host_addr = cl->host_client_id;
 	mei_hdr.me_addr = cl->me_client_id;
 	mei_hdr.reserved = 0;
@@ -724,8 +745,7 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 			cb->request_buffer.size, cb->buf_idx);
 
 	*slots -=  msg_slots;
-	rets = mei_write_message(dev, &mei_hdr,
-			cb->request_buffer.data + cb->buf_idx);
+	rets = mei_write_message(dev, &mei_hdr, buf->data + cb->buf_idx);
 	if (rets) {
 		cl->status = rets;
 		list_move_tail(&cb->list, &cmpl_list->list);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index e4bb9ae..7a95c07 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -513,11 +513,6 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		cl = cb->cl;
 		if (cl == NULL)
 			continue;
-		if (mei_cl_flow_ctrl_creds(cl) <= 0) {
-			cl_dbg(dev, cl, "No flow control credentials, not sending.\n");
-			continue;
-		}
-
 		if (cl == &dev->iamthif_cl)
 			ret = mei_amthif_irq_write_complete(cl, cb,
 						&slots, cmpl_list);
-- 
1.8.3.1

