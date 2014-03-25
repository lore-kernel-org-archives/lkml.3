Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaCYT0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:26:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:11211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaCYT0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="506557620"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        stable <stable@vger.kernel.org>
Subject: [char-misc-next] mei: me: do not load the driver if the FW doesn't support MEI interface
Date: Tue, 25 Mar 2014 21:25:18 +0200
Message-Id: <1395775518-2132-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NM and SPS  FW types that may run on ME device on server platforms
do not have valid MEI/HECI interface and driver should not
be bound to it as this might lead to system hung.
In practice not all BIOSes effectively hide such devices from the
OS and in some cases it is not possible.

We determine FW type by examining Host FW status registers in order to
unbind the driver.
In this patch we are adding check for ME on Cougar Point, Lynx Point
Devices

Cc: stable <stable@vger.kernel.org> # 3.10+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h |  5 +++++
 drivers/misc/mei/pci-me.c     | 30 +++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 72ba4d5..a7856c0 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -115,6 +115,11 @@
 #define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
 
 #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
+
+/* Host Firmware Status Registers in PCI Config Space */
+#define PCI_CFG_HFS_1         0x40
+#define PCI_CFG_HFS_2         0x48
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index bc3e043..88516b0 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -107,15 +107,31 @@ static bool mei_me_quirk_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
 	u32 reg;
-	if (ent->device == MEI_DEV_ID_PBG_1) {
-		pci_read_config_dword(pdev, 0x48, &reg);
-		/* make sure that bit 9 is up and bit 10 is down */
-		if ((reg & 0x600) == 0x200) {
-			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
-			return false;
-		}
+	/* Cougar Point || Patsburg */
+	if (ent->device == MEI_DEV_ID_CPT_1 ||
+	    ent->device == MEI_DEV_ID_PBG_1) {
+		pci_read_config_dword(pdev, PCI_CFG_HFS_2, &reg);
+		/* make sure that bit 9 (NM) is up and bit 10 (DM) is down */
+		if ((reg & 0x600) == 0x200)
+			goto no_mei;
 	}
+
+	/* Lynx Point */
+	if (ent->device == MEI_DEV_ID_LPT_H  ||
+	    ent->device == MEI_DEV_ID_LPT_W  ||
+	    ent->device == MEI_DEV_ID_LPT_HR) {
+		/* Read ME FW Status check for SPS Firmware */
+		pci_read_config_dword(pdev, PCI_CFG_HFS_1, &reg);
+		/* if bits [19:16] = 15, running SPS Firmware */
+		if ((reg & 0xf0000) == 0xf0000)
+			goto no_mei;
+	}
+
 	return true;
+
+no_mei:
+	dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+	return false;
 }
 /**
  * mei_probe - Device Initialization Routine
-- 
1.8.5.3

