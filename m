Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3CZV02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:26:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51416 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3CZV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:26:26 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: airlied@gmail.com
Cc: alexander.deucher@amd.com, skeggsb@gmail.com, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, bhelgaas@google.com, grawity@gmail.com,
        torvalds@linux-foundation.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
Date: Tue, 26 Mar 2013 17:25:54 -0400
Message-Id: <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.36.151
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that some UEFI systems provide apparently an apparently valid
PCI ROM BAR that turns out to contain garbage, so the attempt in f4eb5ff05
to prefer the ROM from the BAR actually breaks a different set of machines.
As Linus pointed out, the graphics drivers are probably in the best
position to make this judgement, so this basically reverts f4eb5ff05 and
f9a37be0f and adds a new helper function. Followup patches will add support
to nouveau and radeon for probing this ROM source if they can't find a ROM
from some other source.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/pci/rom.c   | 67 +++++++++++++++++++++++++----------------------------
 include/linux/pci.h |  1 +
 2 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index b41ac77..c5d0a08 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -100,27 +100,6 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 	return min((size_t)(image - rom), size);
 }
 
-static loff_t pci_find_rom(struct pci_dev *pdev, size_t *size)
-{
-	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
-	loff_t start;
-
-	/* assign the ROM an address if it doesn't have one */
-	if (res->parent == NULL && pci_assign_resource(pdev, PCI_ROM_RESOURCE))
-		return 0;
-	start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
-	*size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
-
-	if (*size == 0)
-		return 0;
-
-	/* Enable ROM space decodes */
-	if (pci_enable_rom(pdev))
-		return 0;
-
-	return start;
-}
-
 /**
  * pci_map_rom - map a PCI ROM to kernel space
  * @pdev: pointer to pci device struct
@@ -135,7 +114,7 @@ static loff_t pci_find_rom(struct pci_dev *pdev, size_t *size)
 void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
-	loff_t start = 0;
+	loff_t start;
 	void __iomem *rom;
 
 	/*
@@ -154,21 +133,21 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 			return (void __iomem *)(unsigned long)
 				pci_resource_start(pdev, PCI_ROM_RESOURCE);
 		} else {
-			start = pci_find_rom(pdev, size);
-		}
-	}
+			/* assign the ROM an address if it doesn't have one */
+			if (res->parent == NULL &&
+			    pci_assign_resource(pdev,PCI_ROM_RESOURCE))
+				return NULL;
+			start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
+			*size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
+			if (*size == 0)
+				return NULL;
 
-	/*
-	 * Some devices may provide ROMs via a source other than the BAR
-	 */
-	if (!start && pdev->rom && pdev->romlen) {
-		*size = pdev->romlen;
-		return phys_to_virt(pdev->rom);
+			/* Enable ROM space decodes */
+			if (pci_enable_rom(pdev))
+				return NULL;
+		}
 	}
 
-	if (!start)
-		return NULL;
-
 	rom = ioremap(start, *size);
 	if (!rom) {
 		/* restore enable if ioremap fails */
@@ -202,8 +181,7 @@ void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom)
 	if (res->flags & (IORESOURCE_ROM_COPY | IORESOURCE_ROM_BIOS_COPY))
 		return;
 
-	if (!pdev->rom || !pdev->romlen)
-		iounmap(rom);
+	iounmap(rom);
 
 	/* Disable again before continuing, leave enabled if pci=rom */
 	if (!(res->flags & (IORESOURCE_ROM_ENABLE | IORESOURCE_ROM_SHADOW)))
@@ -227,7 +205,24 @@ void pci_cleanup_rom(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * pci_platform_rom - provides a pointer to any ROM image provided by the
+ * platform
+ * @pdev: pointer to pci device struct
+ * @size: pointer to receive size of pci window over ROM
+ */
+void __iomem *pci_platform_rom(struct pci_dev *pdev, size_t *size)
+{
+	if (pdev->rom && pdev->romlen) {
+		*size = pdev->romlen;
+		return phys_to_virt((phys_addr_t)pdev->rom);
+	}
+
+	return NULL;
+}
+
 EXPORT_SYMBOL(pci_map_rom);
 EXPORT_SYMBOL(pci_unmap_rom);
 EXPORT_SYMBOL_GPL(pci_enable_rom);
 EXPORT_SYMBOL_GPL(pci_disable_rom);
+EXPORT_SYMBOL(pci_platform_rom);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2461033a..710067f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -916,6 +916,7 @@ void pci_disable_rom(struct pci_dev *pdev);
 void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
 void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom);
 size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size);
+void __iomem __must_check *pci_platform_rom(struct pci_dev *pdev, size_t *size);
 
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
-- 
1.8.1.2

