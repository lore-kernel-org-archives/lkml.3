Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab3BGVEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:04:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:49853 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395Ab3BGVDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:03:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="253970227"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 09/11] mei: nfc: Connect also the regular ME client
Date: Thu,  7 Feb 2013 23:03:15 +0200
Message-Id: <1360270997-7639-10-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

After receiving the NFC interface version, IVN and radio type,
we can connect to the the actual nfc me client and send the
initialization (nfc connect) message.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 240dd2b..ab66944 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -29,6 +29,7 @@
 
 /** mei_nfc_bdev - nfc mei bus device
  *
+ * @cl: nfc info host client
  * @cl_info: nfc info host client
  * @init_work: perform connection to the info client
  * @fw_ivn: NFC Intervace Version Number
@@ -36,6 +37,7 @@
  * @radio_type: NFC radio type
  */
 struct mei_bus_dev_nfc {
+	struct mei_cl *cl;
 	struct mei_cl *cl_info;
 	struct work_struct init_work;
 	u8 fw_ivn;
@@ -56,6 +58,12 @@ const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
 
 static void mei_nfc_free(struct mei_bus_dev_nfc *bdev)
 {
+	if (bdev->cl) {
+		list_del(&bdev->cl->bus_client_link);
+		mei_cl_unlink(bdev->cl);
+		kfree(bdev->cl);
+	}
+
 	if (bdev->cl_info) {
 		list_del(&bdev->cl_info->bus_client_link);
 		mei_cl_unlink(bdev->cl_info);
@@ -63,6 +71,73 @@ static void mei_nfc_free(struct mei_bus_dev_nfc *bdev)
 	}
 }
 
+static int mei_nfc_connect(struct mei_bus_dev_nfc *bdev)
+{
+	struct mei_device *dev;
+	struct mei_cl *cl;
+	struct mei_nfc_cmd *cmd, *reply;
+	struct mei_nfc_connect *connect;
+	struct mei_nfc_connect_resp *connect_resp;
+	size_t connect_length, connect_resp_length;
+	int bytes_recv, ret;
+
+	cl = bdev->cl;
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
+	connect->fw_ivn = bdev->fw_ivn;
+	connect->vendor_id = bdev->vendor_id;
+
+	ret = mei_send(cl, (u8 *)cmd, connect_length);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not send connect cmd\n");
+		goto err;
+	}
+
+	bytes_recv = mei_recv(cl, (u8 *)reply, connect_resp_length);
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
 static int mei_nfc_if_version(struct mei_bus_dev_nfc *bdev)
 {
 	struct mei_device *dev;
@@ -118,12 +193,13 @@ static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
 	struct mei_bus_dev_nfc *bdev;
-	struct mei_cl *cl_info;
+	struct mei_cl *cl_info, *cl;
 	int ret;
 
 	bdev = container_of(work, struct mei_bus_dev_nfc, init_work);
 
 	cl_info = bdev->cl_info;
+	cl = bdev->cl;
 	dev = cl_info->dev;
 
 	mutex_lock(&dev->device_lock);
@@ -149,6 +225,24 @@ static void mei_nfc_init(struct work_struct *work)
 		"NFC MEI VERSION: IVN 0x%x Vendor ID 0x%x Type 0x%x\n",
 		bdev->fw_ivn, bdev->vendor_id, bdev->radio_type);
 
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
+	ret = mei_nfc_connect(bdev);
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not connect to NFC");
+		return;
+	}
+
 	return;
 
 err:
@@ -161,7 +255,7 @@ err:
 int mei_nfc_host_init(struct mei_device *dev)
 {
 	struct mei_bus_dev_nfc *bdev = &nfc_bdev;
-	struct mei_cl *cl_info;
+	struct mei_cl *cl_info, *cl  = NULL;
 	int i, ret;
 
 	/* already initialzed */
@@ -169,14 +263,19 @@ int mei_nfc_host_init(struct mei_device *dev)
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
@@ -189,7 +288,26 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	list_add_tail(&cl_info->bus_client_link, &dev->bus_client_list);
 
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
+	cl->bus_client_uuid = mei_nfc_guid;
+
+	list_add_tail(&cl->bus_client_link, &dev->bus_client_list);
+
 	bdev->cl_info = cl_info;
+	bdev->cl = cl;
 
 	INIT_WORK(&bdev->init_work, mei_nfc_init);
 	schedule_work(&bdev->init_work);
-- 
1.7.4.4

