Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937182Ab3DKBEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:04:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:13786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937009Ab3DKBEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,451,1363158000"; 
   d="scan'208";a="316313772"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 3/3 v7] mei: nfc: Implement MEI bus ops
Date: Thu, 11 Apr 2013 03:03:31 +0200
Message-Id: <1365642211-21421-4-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
References: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The send ops for NFC builds the command header, updates the request id
and then waits for an ACK.
The recv ops check if it receives data or an ACK and in the latter case
wakes the send ops up.
The enable ops sends the NFC HECI connect command.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |  170 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 33354d94..3adf8a7 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/device.h>
@@ -99,10 +100,14 @@ struct mei_nfc_dev {
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
@@ -184,6 +189,73 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 	return 0;
 }
 
+static int mei_nfc_connect(struct mei_nfc_dev *ndev)
+{
+	struct mei_device *dev;
+	struct mei_cl *cl;
+	struct mei_nfc_cmd *cmd, *reply;
+	struct mei_nfc_connect *connect;
+	struct mei_nfc_connect_resp *connect_resp;
+	size_t connect_length, connect_resp_length;
+	int bytes_recv, ret;
+
+	cl = ndev->cl;
+	dev = cl->dev;
+
+	connect_length = sizeof(struct mei_nfc_cmd) +
+			sizeof(struct mei_nfc_connect);
+
+	connect_resp_length = sizeof(struct mei_nfc_cmd) +
+			sizeof(struct mei_nfc_connect_resp);
+
+	cmd = kzalloc(connect_length, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+	connect = (struct mei_nfc_connect *)cmd->data;
+
+	reply = kzalloc(connect_resp_length, GFP_KERNEL);
+	if (!reply) {
+		kfree(cmd);
+		return -ENOMEM;
+	}
+
+	connect_resp = (struct mei_nfc_connect_resp *)reply->data;
+
+	cmd->command = MEI_NFC_CMD_MAINTENANCE;
+	cmd->data_size = 3;
+	cmd->sub_command = MEI_NFC_SUBCMD_CONNECT;
+	connect->fw_ivn = ndev->fw_ivn;
+	connect->vendor_id = ndev->vendor_id;
+
+	ret = __mei_cl_send(cl, (u8 *)cmd, connect_length);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not send connect cmd\n");
+		goto err;
+	}
+
+	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, connect_resp_length);
+	if (bytes_recv < 0) {
+		dev_err(&dev->pdev->dev, "Could not read connect response\n");
+		ret = bytes_recv;
+		goto err;
+	}
+
+	dev_info(&dev->pdev->dev, "IVN 0x%x Vendor ID 0x%x\n",
+		 connect_resp->fw_ivn, connect_resp->vendor_id);
+
+	dev_info(&dev->pdev->dev, "ME FW %d.%d.%d.%d\n",
+		connect_resp->me_major, connect_resp->me_minor,
+		connect_resp->me_hotfix, connect_resp->me_build);
+
+	ret = 0;
+
+err:
+	kfree(reply);
+	kfree(cmd);
+
+	return ret;
+}
+
 static int mei_nfc_if_version(struct mei_nfc_dev *ndev)
 {
 	struct mei_device *dev;
@@ -235,6 +307,100 @@ err:
 	return ret;
 }
 
+static int mei_nfc_enable(struct mei_cl_device *cldev)
+{
+	struct mei_device *dev;
+	struct mei_nfc_dev *ndev = &nfc_dev;
+	int ret;
+
+	dev = ndev->cl->dev;
+
+	ret = mei_nfc_connect(ndev);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not connect to NFC");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mei_nfc_disable(struct mei_cl_device *cldev)
+{
+	return 0;
+}
+
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
+	if (err < 0)
+		return err;
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
+static struct mei_cl_ops nfc_ops = {
+	.enable = mei_nfc_enable,
+	.disable = mei_nfc_disable,
+	.send = mei_nfc_send,
+	.recv = mei_nfc_recv,
+};
+
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
@@ -287,7 +453,7 @@ static void mei_nfc_init(struct work_struct *work)
 		return;
 	}
 
-	cldev = mei_cl_add_device(dev, mei_nfc_guid, ndev->bus_name, NULL);
+	cldev = mei_cl_add_device(dev, mei_nfc_guid, ndev->bus_name, &nfc_ops);
 	if (!cldev) {
 		dev_err(&dev->pdev->dev,
 			"Could not add the NFC device to the MEI bus\n");
@@ -363,8 +529,10 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	ndev->cl_info = cl_info;
 	ndev->cl = cl;
+	ndev->req_id = 1;
 
 	INIT_WORK(&ndev->init_work, mei_nfc_init);
+	init_waitqueue_head(&ndev->send_wq);
 	schedule_work(&ndev->init_work);
 
 	return 0;
-- 
1.7.10.4

