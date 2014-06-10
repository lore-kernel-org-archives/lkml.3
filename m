Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaFJUij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:38:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaFJTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/160] mei: me: do not load the driver if the FW doesn't support MEI interface
Date: Tue, 10 Jun 2014 12:44:20 -0700
Message-Id: <1402429600-20477-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 5e6533a6f52f1a8283b2f818f5828be99a417dd6 upstream.

NM and SPS  FW types that may run on ME device on server platforms
do not have valid MEI/HECI interface and driver should not
be bound to it as this might lead to system hung.
In practice not all BIOSes effectively hide such devices from the
OS and in some cases it is not possible.

We determine FW type by examining Host FW status registers in order to
unbind the driver.
In this patch we are adding check for ME on Cougar Point, Lynx Point
Devices

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/hw-me-regs.h |  5 +++++
 drivers/misc/mei/pci-me.c     | 30 +++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 66f411a..cabc043 100644
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
index 2cab3c0..6b0babc 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -100,15 +100,31 @@ static bool mei_me_quirk_probe(struct pci_dev *pdev,
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
1.9.1

