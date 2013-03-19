Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3CST76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:59:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53223 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3CST75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:59:57 -0400
Date: Tue, 19 Mar 2013 19:59:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Screen turns off when booting in EFI mode
Message-ID: <20130319195950.GA16828@srcf.ucam.org>
References: <kg69ef$vdb$1@ger.gmane.org>
 <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
 <5126C3E1.80801@gmail.com>
 <513BACAC.9050800@gmail.com>
 <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:09:22AM -0700, Linus Torvalds wrote:

> Trusting firmware-provided values over the things we can find
> ourselves is known to be fundamentally crap, so what the hell is the
> point of that commit in the first place? The likelihood that firmware
> messes up is pretty damn high. Why would we take idiotic "here's the
> PCI ROM" data from firmware in the first place? What did this fix? We
> know what it broke..

Because it's the only way to get the PCI ROM in some cases, like on 
pretty much all Apples with Radeons. Only using it if we have no other 
options probably makes sense, though. Something like this (entirely 
untested)?

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index ab886b7..a746dd9 100644
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
+	if (res->parent == NULL && pci_assign_resource(pdev,PCI_ROM_RESOURCE))
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
Matthew Garrett | mjg59@srcf.ucam.org
