Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab3BLSiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:38:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:52524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933797Ab3BLSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="201566679"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 11/12 v3] mei: nfc: Add NFC device to the MEI bus
Date: Tue, 12 Feb 2013 19:37:01 +0100
Message-Id: <1360694222-27632-12-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After building its bus name as a string based on its vendor id and radio
type, we can add it to the bus.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h |    6 ++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index ddbf93f..75381b8 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -42,6 +42,8 @@ struct mei_nfc_dev {
 	u8 fw_ivn;
 	u8 vendor_id;
 	u8 radio_type;
+
+	char *bus_name;
 };
 
 static struct mei_nfc_dev nfc_dev;
@@ -70,6 +72,39 @@ static void mei_nfc_free(struct mei_nfc_dev *ndev)
 	}
 }
 
+static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
+{
+	struct mei_host *dev;
+
+	if (!ndev->cl)
+		return -ENODEV;
+
+	dev = ndev->cl->dev;
+
+	switch (ndev->vendor_id) {
+	case MEI_NFC_VENDOR_INSIDE:
+		switch (ndev->radio_type) {
+		case MEI_NFC_VENDOR_INSIDE_UREAD:
+			ndev->bus_name = "microread";
+			return 0;
+
+		default:
+			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+				ndev->radio_type);
+
+			return -EINVAL;
+		}
+
+	default:
+		dev_err(&dev->pdev->dev, "Unknow vendor ID 0x%x\n",
+			ndev->vendor_id);
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int mei_nfc_connect(struct mei_nfc_dev *ndev)
 {
 	struct mei_host *dev;
@@ -191,6 +226,7 @@ err:
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_host *dev;
+	struct mei_device *device;
 	struct mei_nfc_dev *ndev;
 	struct mei_cl *cl_info, *cl;
 	int ret;
@@ -242,6 +278,23 @@ static void mei_nfc_init(struct work_struct *work)
 		return;
 	}
 
+	if (mei_nfc_build_bus_name(ndev) < 0) {
+		dev_err(&dev->pdev->dev,
+			"Could not build the bus ID name\n");
+		return;
+	}
+
+	device = mei_add_device(dev, mei_nfc_guid,
+				    ndev->bus_name);
+	if (!device) {
+		dev_err(&dev->pdev->dev,
+			"Could not add the NFC device to the MEI bus\n");
+
+		goto err;
+	}
+
+	device->priv_data = ndev;
+
 	return;
 
 err:
@@ -323,5 +376,8 @@ void mei_nfc_host_exit(void)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 
+	if (ndev->cl && ndev->cl->device)
+		mei_remove_device(ndev->cl->device);
+
 	mei_nfc_free(ndev);
 }
diff --git a/drivers/misc/mei/nfc.h b/drivers/misc/mei/nfc.h
index 59e6703..4440436 100644
--- a/drivers/misc/mei/nfc.h
+++ b/drivers/misc/mei/nfc.h
@@ -119,4 +119,10 @@ struct mei_nfc_connect_resp {
 #define MEI_NFC_SUBCMD_CONNECT    0x00
 #define MEI_NFC_SUBCMD_IF_VERSION 0x01
 
+/* Vendors */
+#define MEI_NFC_VENDOR_INSIDE 0x00
+
+/* Radio types */
+#define MEI_NFC_VENDOR_INSIDE_UREAD 0x00
+
 #endif /* _MEI_NFC_H */
-- 
1.7.10.4

