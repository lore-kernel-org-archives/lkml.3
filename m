Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaH3TEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:04:35 -0400
Received: from cthulhu.worldbroken.com ([173.230.133.178]:34509 "EHLO
	cthulhu.worldbroken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaH3TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:04:31 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2014 15:04:30 EDT
From: wfp5p@worldbroken.com
To: gregkh@linuxfoundation.org
Cc: cascardo@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        lidza.louina@gmail.com, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] jsm: add support for additional Neo cards
Date: Sat, 30 Aug 2014 14:54:36 -0400
Message-Id: <1409424877-2304-2-git-send-email-wfp5p@worldbroken.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1409424877-2304-1-git-send-email-wfp5p@worldbroken.com>
References: <1409424877-2304-1-git-send-email-wfp5p@worldbroken.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Pemberton <wfp5p@worldbroken.com>

Add device ids for additional Neo cards.  The ids come from the dgnc
driver.

Signed-off-by: Bill Pemberton <wfp5p@worldbroken.com>
---
 drivers/tty/serial/jsm/jsm_driver.c | 38 +++++++++++++++++++++++++++++++++----
 include/linux/pci_ids.h             |  8 ++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index a47d882d6743..d2885a7bb090 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -93,12 +93,34 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* store the info for the board we've found */
 	brd->boardnum = adapter_count++;
 	brd->pci_dev = pdev;
-	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
+
+	switch (pdev->device) {
+
+	case PCI_DEVICE_ID_NEO_2DB9:
+	case PCI_DEVICE_ID_NEO_2DB9PRI:
+	case PCI_DEVICE_ID_NEO_2RJ45:
+	case PCI_DEVICE_ID_NEO_2RJ45PRI:
+	case PCI_DEVICE_ID_NEO_2_422_485:
+		brd->maxports = 2;
+		break;
+
+	case PCI_DEVICE_ID_NEO_4:
+	case PCIE_DEVICE_ID_NEO_4:
+	case PCIE_DEVICE_ID_NEO_4RJ45:
+	case PCIE_DEVICE_ID_NEO_4_IBM:
 		brd->maxports = 4;
-	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
+		break;
+
+	case PCI_DEVICE_ID_DIGI_NEO_8:
+	case PCIE_DEVICE_ID_NEO_8:
+	case PCIE_DEVICE_ID_NEO_8RJ45:
 		brd->maxports = 8;
-	else
-		brd->maxports = 2;
+		break;
+
+	default:
+		brd->maxports = 1;
+		break;
+	}
 
 	spin_lock_init(&brd->bd_intr_lock);
 
@@ -209,6 +231,14 @@ static struct pci_device_id jsm_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_4), 0, 0, 6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_1_422), 0, 0, 7 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_1_422_485), 0, 0, 8 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2_422_485), 0, 0, 9 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_8), 0, 0, 10 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4), 0, 0, 11 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4RJ45), 0, 0, 12 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_8RJ45), 0, 0, 13 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb73a864..f0f610c94bb2 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1516,11 +1516,19 @@
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
+#define PCI_DEVICE_ID_NEO_4             0x00B0
 #define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
 #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
+#define PCI_DEVICE_ID_NEO_1_422         0x00CC
+#define PCI_DEVICE_ID_NEO_1_422_485     0x00CD
+#define PCI_DEVICE_ID_NEO_2_422_485     0x00CE
+#define PCIE_DEVICE_ID_NEO_8            0x00F0
+#define PCIE_DEVICE_ID_NEO_4            0x00F1
+#define PCIE_DEVICE_ID_NEO_4RJ45        0x00F2
+#define PCIE_DEVICE_ID_NEO_8RJ45        0x00F3
 #define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
 
 #define PCI_VENDOR_ID_XIRCOM		0x115d
-- 
1.9.3

