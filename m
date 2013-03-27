Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3C0PcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:32:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3C0PbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="308170180"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/11 V5] mei: nfc: Add NFC device to the MEI bus
Date: Wed, 27 Mar 2013 17:30:02 +0200
Message-Id: <1364398203-11159-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

After building its bus name as a string based on its vendor id and radio
type, we can add it to the bus.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h |  6 ++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index b903d82..372d336 100644
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
+	struct mei_device *dev;
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
 	struct mei_device *dev;
@@ -191,6 +226,7 @@ err:
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
+	struct mei_cl_device *cldev;
 	struct mei_nfc_dev *ndev;
 	struct mei_cl *cl_info, *cl;
 	int ret;
@@ -242,6 +278,22 @@ static void mei_nfc_init(struct work_struct *work)
 		return;
 	}
 
+	if (mei_nfc_build_bus_name(ndev) < 0) {
+		dev_err(&dev->pdev->dev,
+			"Could not build the bus ID name\n");
+		return;
+	}
+
+	cldev = mei_cl_add_device(dev, mei_nfc_guid, ndev->bus_name);
+	if (!cldev) {
+		dev_err(&dev->pdev->dev,
+			"Could not add the NFC device to the MEI bus\n");
+
+		goto err;
+	}
+
+	cldev->priv_data = ndev;
+
 	return;
 
 err:
@@ -323,5 +375,8 @@ void mei_nfc_host_exit(void)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 
+	if (ndev->cl && ndev->cl->device)
+		mei_cl_remove_device(ndev->cl->device);
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
1.7.11.7

