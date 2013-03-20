Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3CTWpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:45:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:34695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3CTWpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:45:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="282469878"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 11/11 V4] mei: nfc: Implement MEI bus IO ops
Date: Thu, 21 Mar 2013 00:44:29 +0200
Message-Id: <1363819469-696-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

The send ops for NFC builds the command header, updates the request id
and then waits for an ACK.
The recv ops check if it receives data or an ACK and in the latter case
wakes the send ops up.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h | 13 +++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 372d336..14d6076 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/device.h>
@@ -39,11 +40,15 @@ struct mei_nfc_dev {
 	struct mei_cl *cl;
 	struct mei_cl *cl_info;
 	struct work_struct init_work;
+	wait_queue_head_t send_wq;
 	u8 fw_ivn;
 	u8 vendor_id;
 	u8 radio_type;
 
 	char *bus_name;
+
+	u16 req_id;
+	u16 recv_req_id;
 };
 
 static struct mei_nfc_dev nfc_dev;
@@ -223,6 +228,74 @@ err:
 	return ret;
 }
 
+static int mei_nfc_send(struct mei_cl_device *cldev, u8 *buf, size_t length)
+{
+	struct mei_device *dev;
+	struct mei_nfc_dev *ndev;
+	struct mei_nfc_hci_hdr *hdr;
+	u8 *mei_buf;
+	int err;
+
+	ndev = (struct mei_nfc_dev *) cldev->priv_data;
+	dev = ndev->cl->dev;
+
+	mei_buf = kzalloc(length + MEI_NFC_HEADER_SIZE, GFP_KERNEL);
+	if (!mei_buf)
+		return -ENOMEM;
+
+	hdr = (struct mei_nfc_hci_hdr *) mei_buf;
+	hdr->cmd = MEI_NFC_CMD_HCI_SEND;
+	hdr->status = 0;
+	hdr->req_id = ndev->req_id;
+	hdr->reserved = 0;
+	hdr->data_size = length;
+
+	memcpy(mei_buf + MEI_NFC_HEADER_SIZE, buf, length);
+
+	err = __mei_cl_send(ndev->cl, mei_buf, length + MEI_NFC_HEADER_SIZE);
+
+	kfree(mei_buf);
+
+	if (!wait_event_interruptible_timeout(ndev->send_wq,
+				ndev->recv_req_id == ndev->req_id, HZ)) {
+		dev_err(&dev->pdev->dev, "NFC MEI command timeout\n");
+		err = -ETIMEDOUT;
+	} else {
+		ndev->req_id++;
+	}
+
+	return err;
+}
+
+static int mei_nfc_recv(struct mei_cl_device *cldev, u8 *buf, size_t length)
+{
+	struct mei_nfc_dev *ndev;
+	struct mei_nfc_hci_hdr *hci_hdr;
+	int received_length;
+
+	ndev = (struct mei_nfc_dev *)cldev->priv_data;
+
+	received_length = __mei_cl_recv(ndev->cl, buf, length);
+	if (received_length < 0)
+		return received_length;
+
+	hci_hdr = (struct mei_nfc_hci_hdr *) buf;
+
+	if (hci_hdr->cmd == MEI_NFC_CMD_HCI_SEND) {
+		ndev->recv_req_id = hci_hdr->req_id;
+		wake_up(&ndev->send_wq);
+
+		return 0;
+	}
+
+	return received_length;
+}
+
+static struct mei_cl_transport_ops nfc_ops = {
+	.send = mei_nfc_send,
+	.recv = mei_nfc_recv,
+};
+
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
@@ -293,6 +366,7 @@ static void mei_nfc_init(struct work_struct *work)
 	}
 
 	cldev->priv_data = ndev;
+	cldev->ops = &nfc_ops;
 
 	return;
 
@@ -359,8 +433,10 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	ndev->cl_info = cl_info;
 	ndev->cl = cl;
+	ndev->req_id = 1;
 
 	INIT_WORK(&ndev->init_work, mei_nfc_init);
+	init_waitqueue_head(&ndev->send_wq);
 	schedule_work(&ndev->init_work);
 
 	return 0;
diff --git a/drivers/misc/mei/nfc.h b/drivers/misc/mei/nfc.h
index 4440436..12e48d3 100644
--- a/drivers/misc/mei/nfc.h
+++ b/drivers/misc/mei/nfc.h
@@ -114,11 +114,24 @@ struct mei_nfc_connect_resp {
 	uint16_t me_build;
 } __packed;
 
+struct mei_nfc_hci_hdr {
+	u8 cmd;
+	u8 status;
+	u16 req_id;
+	u32 reserved;
+	u16 data_size;
+} __packed;
+
 #define MEI_NFC_CMD_MAINTENANCE 0x00
+#define MEI_NFC_CMD_HCI_SEND 0x01
+#define MEI_NFC_CMD_HCI_RECV 0x02
 
 #define MEI_NFC_SUBCMD_CONNECT    0x00
 #define MEI_NFC_SUBCMD_IF_VERSION 0x01
 
+#define MEI_NFC_HEADER_SIZE 10
+#define MEI_NFC_MAX_HCI_PAYLOAD 300
+
 /* Vendors */
 #define MEI_NFC_VENDOR_INSIDE 0x00
 
-- 
1.8.1.3

