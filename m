Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab3BLSjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:39:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:62881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933780Ab3BLSiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290196187"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 10/12 v3] mei: nfc: Connect also the regular ME client
Date: Tue, 12 Feb 2013 19:37:00 +0100
Message-Id: <1360694222-27632-11-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After receiving the NFC interface version, IVN and radio type,
we can connect to the the actual nfc ME client and send the
initialization (nfc connect) message.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 123 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 075ceb8..ddbf93f 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -28,6 +28,7 @@
 
 /** mei_nfc_dev - NFC mei device
  *
+ * @cl: NFC host client
  * @cl_info: NFC info host client
  * @init_work: perform connection to the info client
  * @fw_ivn: NFC Intervace Version Number
@@ -35,6 +36,7 @@
  * @radio_type: NFC radio type
  */
 struct mei_nfc_dev {
+	struct mei_cl *cl;
 	struct mei_cl *cl_info;
 	struct work_struct init_work;
 	u8 fw_ivn;
@@ -55,6 +57,12 @@ static const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
 
 static void mei_nfc_free(struct mei_nfc_dev *ndev)
 {
+	if (ndev->cl) {
+		list_del(&ndev->cl->device_link);
+		mei_cl_unlink(ndev->cl);
+		kfree(ndev->cl);
+	}
+
 	if (ndev->cl_info) {
 		list_del(&ndev->cl_info->device_link);
 		mei_cl_unlink(ndev->cl_info);
@@ -62,6 +70,73 @@ static void mei_nfc_free(struct mei_nfc_dev *ndev)
 	}
 }
 
+static int mei_nfc_connect(struct mei_nfc_dev *ndev)
+{
+	struct mei_host *dev;
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
+	ret = __mei_send(cl, (u8 *)cmd, connect_length);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not send connect cmd\n");
+		goto err;
+	}
+
+	bytes_recv = __mei_recv(cl, (u8 *)reply, connect_resp_length);
+	if (bytes_recv < 0) {
+		dev_err(&dev->pdev->dev, "Could not read connect response\n");
+		ret = bytes_recv;
+		goto err;
+	}
+
+	dev_info(&dev->pdev->dev, "IVN 0x%x Vendor ID 0x%x\n",
+		connect_resp->fw_ivn, connect_resp->vendor_id);
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
 	struct mei_host *dev;
@@ -117,12 +192,13 @@ static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_host *dev;
 	struct mei_nfc_dev *ndev;
-	struct mei_cl *cl_info;
+	struct mei_cl *cl_info, *cl;
 	int ret;
 
 	ndev = container_of(work, struct mei_nfc_dev, init_work);
 
 	cl_info = ndev->cl_info;
+	cl = ndev->cl;
 	dev = cl_info->dev;
 
 	mutex_lock(&dev->device_lock);
@@ -148,6 +224,24 @@ static void mei_nfc_init(struct work_struct *work)
 		"NFC MEI VERSION: IVN 0x%x Vendor ID 0x%x Type 0x%x\n",
 		ndev->fw_ivn, ndev->vendor_id, ndev->radio_type);
 
+	mutex_lock(&dev->device_lock);
+
+	if (mei_cl_connect(cl, NULL) < 0) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev,
+			"Could not connect to the NFC ME client");
+
+		goto err;
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	ret = mei_nfc_connect(ndev);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not connect to NFC");
+		return;
+	}
+
 	return;
 
 err:
@@ -160,7 +254,7 @@ err:
 int mei_nfc_host_init(struct mei_host *dev)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
-	struct mei_cl *cl_info;
+	struct mei_cl *cl_info, *cl  = NULL;
 	int i, ret;
 
 	/* already initialzed */
@@ -168,14 +262,19 @@ int mei_nfc_host_init(struct mei_host *dev)
 		return 0;
 
 	cl_info = mei_cl_allocate(dev);
-	if (!cl_info)
-		return -ENOMEM;
+	cl = mei_cl_allocate(dev);
+
+	if (!cl || !cl_info) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	/* check for valid client id */
 	i = mei_me_cl_by_uuid(dev, &mei_nfc_info_guid);
 	if (i < 0) {
 		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err;
 	}
 
 	cl_info->me_client_id = dev->me_clients[i].client_id;
@@ -188,7 +287,26 @@ int mei_nfc_host_init(struct mei_host *dev)
 
 	list_add_tail(&cl_info->device_link, &dev->device_list);
 
+	/* check for valid client id */
+	i = mei_me_cl_by_uuid(dev, &mei_nfc_guid);
+	if (i < 0) {
+		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	cl->me_client_id = dev->me_clients[i].client_id;
+
+	ret = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
+	if (ret)
+		goto err;
+
+	cl->device_uuid = mei_nfc_guid;
+
+	list_add_tail(&cl->device_link, &dev->device_list);
+
 	ndev->cl_info = cl_info;
+	ndev->cl = cl;
 
 	INIT_WORK(&ndev->init_work, mei_nfc_init);
 	schedule_work(&ndev->init_work);
-- 
1.7.10.4

