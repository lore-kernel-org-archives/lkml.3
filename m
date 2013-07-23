Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3GWIJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:09:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:9945 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab3GWIJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="335418728"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 01/13] ACPI/IPMI: Fix potential response buffer overflow
Date: Tue, 23 Jul 2013 16:08:59 +0800
Message-Id: <be902a592144313dbf382876965166166bf81438.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances sanity checks on message size to avoid potential buffer
overflow.

The kernel IPMI message size is IPMI_MAX_MSG_LENGTH(272 bytes) while the
ACPI specification defined IPMI message size is 64 bytes.  The difference
is not handled by the original codes.  This may cause crash in the response
handling codes.
This patch fixes this gap and also combines rx_data/tx_data to use single
data/len pair since they need not be seperated.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |  100 ++++++++++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index f40acef..28e2b4c 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -51,6 +51,7 @@ MODULE_LICENSE("GPL");
 #define ACPI_IPMI_UNKNOWN		0x07
 /* the IPMI timeout is 5s */
 #define IPMI_TIMEOUT			(5 * HZ)
+#define ACPI_IPMI_MAX_MSG_LENGTH	64
 
 struct acpi_ipmi_device {
 	/* the device list attached to driver_data.ipmi_devices */
@@ -89,11 +90,9 @@ struct acpi_ipmi_msg {
 	struct completion tx_complete;
 	struct kernel_ipmi_msg tx_message;
 	int	msg_done;
-	/* tx data . And copy it from ACPI object buffer */
-	u8	tx_data[64];
-	int	tx_len;
-	u8	rx_data[64];
-	int	rx_len;
+	/* tx/rx data . And copy it from/to ACPI object buffer */
+	u8	data[ACPI_IPMI_MAX_MSG_LENGTH];
+	u8	rx_len;
 	struct acpi_ipmi_device *device;
 };
 
@@ -101,7 +100,7 @@ struct acpi_ipmi_msg {
 struct acpi_ipmi_buffer {
 	u8 status;
 	u8 length;
-	u8 data[64];
+	u8 data[ACPI_IPMI_MAX_MSG_LENGTH];
 };
 
 static void ipmi_register_bmc(int iface, struct device *dev);
@@ -140,9 +139,9 @@ static struct acpi_ipmi_msg *acpi_alloc_ipmi_msg(struct acpi_ipmi_device *ipmi)
 
 #define		IPMI_OP_RGN_NETFN(offset)	((offset >> 8) & 0xff)
 #define		IPMI_OP_RGN_CMD(offset)		(offset & 0xff)
-static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
-				acpi_physical_address address,
-				acpi_integer *value)
+static int acpi_format_ipmi_request(struct acpi_ipmi_msg *tx_msg,
+				    acpi_physical_address address,
+				    acpi_integer *value)
 {
 	struct kernel_ipmi_msg *msg;
 	struct acpi_ipmi_buffer *buffer;
@@ -155,15 +154,21 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 	 */
 	msg->netfn = IPMI_OP_RGN_NETFN(address);
 	msg->cmd = IPMI_OP_RGN_CMD(address);
-	msg->data = tx_msg->tx_data;
+	msg->data = tx_msg->data;
 	/*
 	 * value is the parameter passed by the IPMI opregion space handler.
 	 * It points to the IPMI request message buffer
 	 */
 	buffer = (struct acpi_ipmi_buffer *)value;
 	/* copy the tx message data */
+	if (buffer->length > ACPI_IPMI_MAX_MSG_LENGTH) {
+		dev_WARN_ONCE(&tx_msg->device->pnp_dev->dev, true,
+			      "Unexpected request (msg len %d).\n",
+			      buffer->length);
+		return -EINVAL;
+	}
 	msg->data_len = buffer->length;
-	memcpy(tx_msg->tx_data, buffer->data, msg->data_len);
+	memcpy(tx_msg->data, buffer->data, msg->data_len);
 	/*
 	 * now the default type is SYSTEM_INTERFACE and channel type is BMC.
 	 * If the netfn is APP_REQUEST and the cmd is SEND_MESSAGE,
@@ -181,10 +186,12 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 	device->curr_msgid++;
 	tx_msg->tx_msgid = device->curr_msgid;
 	mutex_unlock(&device->tx_msg_lock);
+
+	return 0;
 }
 
 static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
-		acpi_integer *value, int rem_time)
+				      acpi_integer *value, int rem_time)
 {
 	struct acpi_ipmi_buffer *buffer;
 
@@ -206,13 +213,14 @@ static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
 		buffer->status = ACPI_IPMI_UNKNOWN;
 		return;
 	}
+
 	/*
 	 * If the IPMI response message is obtained correctly, the status code
 	 * will be ACPI_IPMI_OK
 	 */
 	buffer->status = ACPI_IPMI_OK;
 	buffer->length = msg->rx_len;
-	memcpy(buffer->data, msg->rx_data, msg->rx_len);
+	memcpy(buffer->data, msg->data, msg->rx_len);
 }
 
 static void ipmi_flush_tx_msg(struct acpi_ipmi_device *ipmi)
@@ -244,12 +252,12 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	struct pnp_dev *pnp_dev = ipmi_device->pnp_dev;
 
 	if (msg->user != ipmi_device->user_interface) {
-		dev_warn(&pnp_dev->dev, "Unexpected response is returned. "
-			"returned user %p, expected user %p\n",
-			msg->user, ipmi_device->user_interface);
-		ipmi_free_recv_msg(msg);
-		return;
+		dev_warn(&pnp_dev->dev,
+			 "Unexpected response is returned. returned user %p, expected user %p\n",
+			 msg->user, ipmi_device->user_interface);
+		goto out_msg;
 	}
+
 	mutex_lock(&ipmi_device->tx_msg_lock);
 	list_for_each_entry(tx_msg, &ipmi_device->tx_msg_list, head) {
 		if (msg->msgid == tx_msg->tx_msgid) {
@@ -257,24 +265,31 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 			break;
 		}
 	}
-
 	mutex_unlock(&ipmi_device->tx_msg_lock);
+
 	if (!msg_found) {
-		dev_warn(&pnp_dev->dev, "Unexpected response (msg id %ld) is "
-			"returned.\n", msg->msgid);
-		ipmi_free_recv_msg(msg);
-		return;
+		dev_warn(&pnp_dev->dev,
+			 "Unexpected response (msg id %ld) is returned.\n",
+			 msg->msgid);
+		goto out_msg;
 	}
 
-	if (msg->msg.data_len) {
-		/* copy the response data to Rx_data buffer */
-		memcpy(tx_msg->rx_data, msg->msg_data, msg->msg.data_len);
-		tx_msg->rx_len = msg->msg.data_len;
-		tx_msg->msg_done = 1;
+	/* copy the response data to Rx_data buffer */
+	if (msg->msg.data_len > ACPI_IPMI_MAX_MSG_LENGTH) {
+		dev_WARN_ONCE(&pnp_dev->dev, true,
+			      "Unexpected response (msg len %d).\n",
+			      msg->msg.data_len);
+		goto out_comp;
 	}
+	tx_msg->rx_len = msg->msg.data_len;
+	memcpy(tx_msg->data, msg->msg.data, tx_msg->rx_len);
+	tx_msg->msg_done = 1;
+
+out_comp:
 	complete(&tx_msg->tx_complete);
+out_msg:
 	ipmi_free_recv_msg(msg);
-};
+}
 
 static void ipmi_register_bmc(int iface, struct device *dev)
 {
@@ -353,6 +368,7 @@ static void ipmi_bmc_gone(int iface)
 	}
 	mutex_unlock(&driver_data.ipmi_lock);
 }
+
 /* --------------------------------------------------------------------------
  *			Address Space Management
  * -------------------------------------------------------------------------- */
@@ -371,13 +387,14 @@ static void ipmi_bmc_gone(int iface)
 
 static acpi_status
 acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
-		      u32 bits, acpi_integer *value,
-		      void *handler_context, void *region_context)
+			u32 bits, acpi_integer *value,
+			void *handler_context, void *region_context)
 {
 	struct acpi_ipmi_msg *tx_msg;
 	struct acpi_ipmi_device *ipmi_device = handler_context;
 	int err, rem_time;
 	acpi_status status;
+
 	/*
 	 * IPMI opregion message.
 	 * IPMI message is firstly written to the BMC and system software
@@ -394,28 +411,33 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	if (!tx_msg)
 		return AE_NO_MEMORY;
 
-	acpi_format_ipmi_msg(tx_msg, address, value);
+	if (acpi_format_ipmi_request(tx_msg, address, value) != 0) {
+		status = AE_TYPE;
+		goto out_msg;
+	}
+
 	mutex_lock(&ipmi_device->tx_msg_lock);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
 	mutex_unlock(&ipmi_device->tx_msg_lock);
 	err = ipmi_request_settime(ipmi_device->user_interface,
-					&tx_msg->addr,
-					tx_msg->tx_msgid,
-					&tx_msg->tx_message,
-					NULL, 0, 0, 0);
+				   &tx_msg->addr,
+				   tx_msg->tx_msgid,
+				   &tx_msg->tx_message,
+				   NULL, 0, 0, 0);
 	if (err) {
 		status = AE_ERROR;
-		goto end_label;
+		goto out_list;
 	}
 	rem_time = wait_for_completion_timeout(&tx_msg->tx_complete,
-					IPMI_TIMEOUT);
+					       IPMI_TIMEOUT);
 	acpi_format_ipmi_response(tx_msg, value, rem_time);
 	status = AE_OK;
 
-end_label:
+out_list:
 	mutex_lock(&ipmi_device->tx_msg_lock);
 	list_del(&tx_msg->head);
 	mutex_unlock(&ipmi_device->tx_msg_lock);
+out_msg:
 	kfree(tx_msg);
 	return status;
 }
-- 
1.7.10

