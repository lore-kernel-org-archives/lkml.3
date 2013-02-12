Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3BLSik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:38:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:3324 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933792Ab3BLSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290196257"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 12/12 v3] mei: nfc: Implement MEI bus IO ops
Date: Tue, 12 Feb 2013 19:37:02 +0100
Message-Id: <1360694222-27632-13-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The send ops for NFC builds the command header, updates the request id
and then waits for an ACK.
The recv ops check if it receives data or an ACK and in the latter case
wakes the send ops up.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h |   13 +++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 75381b8..f8889e0 100644
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
 
+static int mei_nfc_send(struct mei_device *device, u8 *buf, size_t length)
+{
+	struct mei_host *dev;
+	struct mei_nfc_dev *ndev;
+	struct mei_nfc_hci_hdr *hdr;
+	u8 *mei_buf;
+	int err;
+
+	ndev = (struct mei_nfc_dev *) device->priv_data;
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
+	err = __mei_send(ndev->cl, mei_buf, length + MEI_NFC_HEADER_SIZE);
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
+static int mei_nfc_recv(struct mei_device *device, u8 *buf, size_t length)
+{
+	struct mei_nfc_dev *ndev;
+	struct mei_nfc_hci_hdr *hci_hdr;
+	int received_length;
+
+	ndev = (struct mei_nfc_dev *) device->priv_data;
+
+	received_length = __mei_recv(ndev->cl, buf, length);
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
+static struct mei_transport_ops nfc_ops = {
+	.send = mei_nfc_send,
+	.recv = mei_nfc_recv,
+};
+
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_host *dev;
@@ -294,6 +367,7 @@ static void mei_nfc_init(struct work_struct *work)
 	}
 
 	device->priv_data = ndev;
+	device->ops = &nfc_ops;
 
 	return;
 
@@ -360,8 +434,10 @@ int mei_nfc_host_init(struct mei_host *dev)
 
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
1.7.10.4

