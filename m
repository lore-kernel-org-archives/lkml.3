Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936363Ab3DHXmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:42:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:35272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760497Ab3DHXmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="316268341"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: nfc: Add NFC device to the MEI bus
Date: Tue,  9 Apr 2013 02:41:34 +0300
Message-Id: <1365464495-17642-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

After building its bus name as a string based on its vendor id and radio
type, we can add it to the bus.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 29a4e03..1846568 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -41,6 +41,7 @@ struct mei_nfc_dev {
 	u8 fw_ivn;
 	u8 vendor_id;
 	u8 radio_type;
+	char *bus_name;
 };
 
 static struct mei_nfc_dev nfc_dev;
@@ -54,6 +55,14 @@ static const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
 					0x48, 0xa4, 0xef, 0xab,
 					0xba, 0x8a, 0x12, 0x06);
 
+/* Vendors */
+#define MEI_NFC_VENDOR_INSIDE 0x00
+#define MEI_NFC_VENDOR_NXP    0x01
+
+/* Radio types */
+#define MEI_NFC_VENDOR_INSIDE_UREAD 0x00
+#define MEI_NFC_VENDOR_NXP_PN544    0x01
+
 static void mei_nfc_free(struct mei_nfc_dev *ndev)
 {
 	if (ndev->cl) {
@@ -69,6 +78,51 @@ static void mei_nfc_free(struct mei_nfc_dev *ndev)
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
+	case MEI_NFC_VENDOR_NXP:
+		switch (ndev->radio_type) {
+		case MEI_NFC_VENDOR_NXP_PN544:
+			ndev->bus_name = "pn544";
+			return 0;
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
 static int mei_nfc_if_version(struct mei_nfc_dev *ndev)
 {
 	struct mei_device *dev;
@@ -123,6 +177,7 @@ err:
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
+	struct mei_cl_device *cldev;
 	struct mei_nfc_dev *ndev;
 	struct mei_cl *cl_info;
 
@@ -165,6 +220,23 @@ static void mei_nfc_init(struct work_struct *work)
 
 	mutex_unlock(&dev->device_lock);
 
+	if (mei_nfc_build_bus_name(ndev) < 0) {
+		dev_err(&dev->pdev->dev,
+			"Could not build the bus ID name\n");
+		return;
+	}
+
+	cldev = mei_cl_add_device(dev, mei_nfc_guid, ndev->bus_name, NULL);
+	if (!cldev) {
+		dev_err(&dev->pdev->dev,
+			"Could not add the NFC device to the MEI bus\n");
+
+		goto err;
+	}
+
+	cldev->priv_data = ndev;
+
+
 	return;
 
 err:
@@ -246,5 +318,8 @@ void mei_nfc_host_exit(void)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 
+	if (ndev->cl && ndev->cl->device)
+		mei_cl_remove_device(ndev->cl->device);
+
 	mei_nfc_free(ndev);
 }
-- 
1.8.1.2

