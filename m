Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946474Ab3BHMaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:30:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:26503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946449Ab3BHM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:29:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477830"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/11] mei: nfc: Add NFC device to the MEI bus
Date: Fri,  8 Feb 2013 14:28:23 +0200
Message-Id: <1360326504-17041-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

After building its bus name as a string based on its vendor id and radio
type, we can add it to the bus.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h |    6 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index ab66944..c65bd44 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -43,6 +43,8 @@ struct mei_bus_dev_nfc {
 	u8 fw_ivn;
 	u8 vendor_id;
 	u8 radio_type;
+
+	char *bus_name;
 };
 
 struct mei_bus_dev_nfc nfc_bdev;
@@ -71,6 +73,39 @@ static void mei_nfc_free(struct mei_bus_dev_nfc *bdev)
 	}
 }
 
+static int mei_nfc_build_bus_name(struct mei_bus_dev_nfc *bdev)
+{
+	struct mei_device *dev;
+
+	if (!bdev->cl)
+		return -ENODEV;
+
+	dev = bdev->cl->dev;
+
+	switch (bdev->vendor_id) {
+	case MEI_NFC_VENDOR_INSIDE:
+		switch (bdev->radio_type) {
+		case MEI_NFC_VENDOR_INSIDE_UREAD:
+			bdev->bus_name = "microread";
+			return 0;
+
+		default:
+			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+				bdev->radio_type);
+
+			return -EINVAL;
+		}
+
+	default:
+		dev_err(&dev->pdev->dev, "Unknow vendor ID 0x%x\n",
+			bdev->vendor_id);
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int mei_nfc_connect(struct mei_bus_dev_nfc *bdev)
 {
 	struct mei_device *dev;
@@ -192,6 +227,7 @@ err:
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
+	struct mei_bus_client *bus_client;
 	struct mei_bus_dev_nfc *bdev;
 	struct mei_cl *cl_info, *cl;
 	int ret;
@@ -243,6 +279,23 @@ static void mei_nfc_init(struct work_struct *work)
 		return;
 	}
 
+	if (mei_nfc_build_bus_name(bdev) < 0) {
+		dev_err(&dev->pdev->dev,
+			"Could not build the bus ID name\n");
+		return;
+	}
+
+	bus_client = mei_add_device(dev, mei_nfc_guid,
+				    bdev->bus_name);
+	if (!bus_client) {
+		dev_err(&dev->pdev->dev,
+			"Could not add the NFC device to the MEI bus\n");
+
+		goto err;
+	}
+
+	bus_client->priv_data = bdev;
+
 	return;
 
 err:
@@ -324,5 +377,8 @@ void mei_nfc_host_exit(void)
 {
 	struct mei_bus_dev_nfc *bdev = &nfc_bdev;
 
+	if (bdev->cl && bdev->cl->client)
+		mei_remove_device(bdev->cl->client);
+
 	mei_nfc_free(bdev);
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
1.7.4.4

