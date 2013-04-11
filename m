Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937128Ab3DKBEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:04:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:29294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937009Ab3DKBD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:03:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,451,1363158000"; 
   d="scan'208";a="317471246"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 2/3 v7] mei: nfc: Add NFC device to the MEI bus
Date: Thu, 11 Apr 2013 03:03:30 +0200
Message-Id: <1365642211-21421-3-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
References: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After building its bus name as a string based on its vendor id and radio
type, we can add it to the bus.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 37d4b09..33354d94 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -102,6 +102,7 @@ struct mei_nfc_dev {
 	u8 fw_ivn;
 	u8 vendor_id;
 	u8 radio_type;
+	char *bus_name;
 };
 
 static struct mei_nfc_dev nfc_dev;
@@ -115,6 +116,14 @@ static const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
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
@@ -130,6 +139,51 @@ static void mei_nfc_free(struct mei_nfc_dev *ndev)
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
@@ -184,6 +238,7 @@ err:
 static void mei_nfc_init(struct work_struct *work)
 {
 	struct mei_device *dev;
+	struct mei_cl_device *cldev;
 	struct mei_nfc_dev *ndev;
 	struct mei_cl *cl_info;
 
@@ -226,6 +281,23 @@ static void mei_nfc_init(struct work_struct *work)
 
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
@@ -307,5 +379,8 @@ void mei_nfc_host_exit(void)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 
+	if (ndev->cl && ndev->cl->device)
+		mei_cl_remove_device(ndev->cl->device);
+
 	mei_nfc_free(ndev);
 }
-- 
1.7.10.4

