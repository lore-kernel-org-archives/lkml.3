Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab3CSV1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:27:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54457 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab3CSV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:27:29 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: grawity@gmail.com
Cc: torvalds@linux-foundation.org, bhelgaas@google.com,
        seth.forshee@canonical.com, airlied@gmail.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] PCI: Use ROM images from firmware only if no other ROM source available
Date: Tue, 19 Mar 2013 17:26:57 -0400
Message-Id: <1363728417-32450-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <5148D5C8.2000701@gmail.com>
References: <5148D5C8.2000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:618d:193b:f11b:6df9
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mantas Mikulėnas reported that his graphics hardware failed to initialise
after commit f9a37be0f02a. The aim of this commit was to ensure that ROM
images were available on some Apple systems that don't expose the GPU ROM
via any other source. In this case, UEFI appears to have provided a broken
ROM image that we were using even though there was a perfectly valid ROM
available via other sources. The simplest way to handle this seems to be
to just re-order pci_map_rom() and leave any firmare-supplied ROM to last.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Mantas Mikulėnas <grawity@gmail.com>
---
 drivers/pci/rom.c | 55 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index ab886b7..b41ac77 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -100,6 +100,27 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 	return min((size_t)(image - rom), size);
 }
 
+static loff_t pci_find_rom(struct pci_dev *pdev, size_t *size)
+{
+	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
+	loff_t start;
+
+	/* assign the ROM an address if it doesn't have one */
+	if (res->parent == NULL && pci_assign_resource(pdev, PCI_ROM_RESOURCE))
+		return 0;
+	start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
+	*size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
+
+	if (*size == 0)
+		return 0;
+
+	/* Enable ROM space decodes */
+	if (pci_enable_rom(pdev))
+		return 0;
+
+	return start;
+}
+
 /**
  * pci_map_rom - map a PCI ROM to kernel space
  * @pdev: pointer to pci device struct
@@ -114,21 +135,15 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
-	loff_t start;
+	loff_t start = 0;
 	void __iomem *rom;
 
 	/*
-	 * Some devices may provide ROMs via a source other than the BAR
-	 */
-	if (pdev->rom && pdev->romlen) {
-		*size = pdev->romlen;
-		return phys_to_virt(pdev->rom);
-	/*
 	 * IORESOURCE_ROM_SHADOW set on x86, x86_64 and IA64 supports legacy
 	 * memory map if the VGA enable bit of the Bridge Control register is
 	 * set for embedded VGA.
 	 */
-	} else if (res->flags & IORESOURCE_ROM_SHADOW) {
+	if (res->flags & IORESOURCE_ROM_SHADOW) {
 		/* primary video rom always starts here */
 		start = (loff_t)0xC0000;
 		*size = 0x20000; /* cover C000:0 through E000:0 */
@@ -139,21 +154,21 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 			return (void __iomem *)(unsigned long)
 				pci_resource_start(pdev, PCI_ROM_RESOURCE);
 		} else {
-			/* assign the ROM an address if it doesn't have one */
-			if (res->parent == NULL &&
-			    pci_assign_resource(pdev,PCI_ROM_RESOURCE))
-				return NULL;
-			start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
-			*size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
-			if (*size == 0)
-				return NULL;
-
-			/* Enable ROM space decodes */
-			if (pci_enable_rom(pdev))
-				return NULL;
+			start = pci_find_rom(pdev, size);
 		}
 	}
 
+	/*
+	 * Some devices may provide ROMs via a source other than the BAR
+	 */
+	if (!start && pdev->rom && pdev->romlen) {
+		*size = pdev->romlen;
+		return phys_to_virt(pdev->rom);
+	}
+
+	if (!start)
+		return NULL;
+
 	rom = ioremap(start, *size);
 	if (!rom) {
 		/* restore enable if ioremap fails */
-- 
1.8.1.2

