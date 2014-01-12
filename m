Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaALELJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 23:11:09 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:47145 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaALELH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 23:11:07 -0500
From: Sander Eikelenboom <linux@eikelenboom.it>
To: Dave Airlie <airlied@redhat.com>,
        Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] In "pci_fixup_video" check if this is or should be the primary video device to prevent setting the IORESOURCE_ROM_SHADOW flag on a secondary VGA card
Date: Sun, 12 Jan 2014 05:10:41 +0100
Message-Id: <1389499841-6097-2-git-send-email-linux@eikelenboom.it>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389499841-6097-1-git-send-email-linux@eikelenboom.it>
References: <1389499841-6097-1-git-send-email-linux@eikelenboom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the IORESOURCE_ROM_SHADOW flag on a secondary VGA card prevents if from
reading it's own rom. It will get the content of the shadowrom at C000 instead,
which is of the primary VGA card and the driver of the secondary card will bail
out.

Fix this by checking if this is or should be the primary video device before
applying the fix and let the comment reflect this.

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 arch/x86/pci/fixup.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b046e07..525e49a 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -314,9 +314,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PC1,	pcie_r
  * IORESOURCE_ROM_SHADOW is used to associate the boot video
  * card with this copy. On laptops this copy has to be used since
  * the main ROM may be compressed or combined with another image.
- * See pci_map_rom() for use of this flag. IORESOURCE_ROM_SHADOW
- * is marked here since the boot video device will be the only enabled
- * video device at this point.
+ * See pci_map_rom() for use of this flag. Before we mark the device
+ * with IORESOURCE_ROM_SHADOW we have to check if this is or should become
+ * the primary video card, since this quirk is ran for all video devices.
  */
 
 static void pci_fixup_video(struct pci_dev *pdev)
@@ -347,12 +347,13 @@ static void pci_fixup_video(struct pci_dev *pdev)
 		}
 		bus = bus->parent;
 	}
-	pci_read_config_word(pdev, PCI_COMMAND, &config);
-	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
-		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
-		if (!vga_default_device())
+	if (!vga_default_device() || pdev == vga_default_device()) {
+		pci_read_config_word(pdev, PCI_COMMAND, &config);
+		if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
+			pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
+			dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
 			vga_set_default_device(pdev);
+		}
 	}
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-- 
1.7.10.4

