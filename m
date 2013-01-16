Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3APQIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3APQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 173/222] PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz
Date: Wed, 16 Jan 2013 13:56:13 -0200
Message-Id: <1358351822-7675-174-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 812089e01b9f65f90fc8fc670d8cce72a0e01fbb upstream.

Otherwise it fails like this on cards like the Transcend 16GB SDHC card:

    mmc0: new SDHC card at address b368
    mmcblk0: mmc0:b368 SDC   15.0 GiB
    mmcblk0: error -110 sending status command, retrying
    mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb0

Tested on my Lenovo x200 laptop.

[bhelgaas: changelog]
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Chris Ball <cjb@laptop.org>
CC: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pci/quirks.c    |    7 +++++--
 include/linux/pci_ids.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2a75216..777e56f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2720,7 +2720,7 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 	if (PCI_FUNC(dev->devfn))
 		return;
 	/*
-	 * RICOH 0xe823 SD/MMC card reader fails to recognize
+	 * RICOH 0xe822 and 0xe823 SD/MMC card readers fail to recognize
 	 * certain types of SD/MMC cards. Lowering the SD base
 	 * clock frequency from 200Mhz to 50Mhz fixes this issue.
 	 *
@@ -2731,7 +2731,8 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 	 * 0xf9  - Key register for 0x150
 	 * 0xfc  - key register for 0xe1
 	 */
-	if (dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
+	if (dev->device == PCI_DEVICE_ID_RICOH_R5CE822 ||
+	    dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
 		pci_write_config_byte(dev, 0xf9, 0xfc);
 		pci_write_config_byte(dev, 0x150, 0x10);
 		pci_write_config_byte(dev, 0xf9, 0x00);
@@ -2758,6 +2759,8 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE822, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE822, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a56c194..a3f8d6d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1566,6 +1566,7 @@
 #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
 #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
 #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
+#define PCI_DEVICE_ID_RICOH_R5CE822	0xe822
 #define PCI_DEVICE_ID_RICOH_R5CE823	0xe823
 #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
 #define PCI_DEVICE_ID_RICOH_R5C843	0x0843
-- 
1.7.9.5

