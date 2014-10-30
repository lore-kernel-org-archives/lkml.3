Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbaJ3R4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbaJ3R4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:56:40 -0400
Subject: [PATCH 2/3] PCI: Re-factor __pci_read_base
From: Myron Stowe <myron.stowe@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: willy@linux.intel.com, unruh@physics.ubc.ca, linux-kernel@vger.kernel.org,
        martin@lucina.net
Date: Thu, 30 Oct 2014 11:54:43 -0600
Message-ID: <20141030175443.22238.49112.stgit@amt.stowe>
In-Reply-To: <20141030175430.22238.47671.stgit@amt.stowe>
References: <20141030175430.22238.47671.stgit@amt.stowe>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__pci_read_base() disables a device's decoding while sizing its BARs.  A
ramification of the disabling is printks needing to be withheld which has
lead to some rather messy exit logic.

This patch attempts to resolve such by coalescing the routine's sizing
logic in order to minimize the duration in which the device's decoding is
disabled.  This allows the error condition related printks to now reside
within their detection blocks.

The re-factoring also takes advantage of the symmetry of obtaining the
BAR's extent (pci_size) and storing the result as the 'region' for both
the 32 bit and 64 bit BARs, consolidating both cases.

No functional change intended.

Reported-by: William Unruh <unruh@physics.ubc.ca>
Reported-by: Martin Lucina <martin@lucina.net>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |   77 +++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 19dc247..5c13279 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -175,7 +175,6 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	u64 l64, sz64, mask64;
 	u16 orig_cmd;
 	struct pci_bus_region region, inverted_region;
-	bool bar_too_big = false, bar_too_high = false, bar_invalid = false;
 
 	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
@@ -201,8 +200,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	 * memory BAR or a ROM, bit 0 must be clear; if it's an io BAR, bit
 	 * 1 must be clear.
 	 */
-	if (!sz || sz == 0xffffffff)
-		goto fail;
+	if (sz == 0xffffffff)
+		sz = 0;
 
 	/*
 	 * I don't know how l can have all bits set.  Copied from old code.
@@ -215,26 +214,22 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->flags = decode_bar(dev, l);
 		res->flags |= IORESOURCE_SIZEALIGN;
 		if (res->flags & IORESOURCE_IO) {
-			l &= PCI_BASE_ADDRESS_IO_MASK;
-			sz &= PCI_BASE_ADDRESS_IO_MASK;
-			mask = PCI_BASE_ADDRESS_IO_MASK & (u32) IO_SPACE_LIMIT;
+			l64 = l & PCI_BASE_ADDRESS_IO_MASK;
+			sz64 = sz & PCI_BASE_ADDRESS_IO_MASK;
+			mask64 = PCI_BASE_ADDRESS_IO_MASK & (u32)IO_SPACE_LIMIT;
 		} else {
-			l &= PCI_BASE_ADDRESS_MEM_MASK;
-			sz &= PCI_BASE_ADDRESS_MEM_MASK;
-			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+			l64 = l & PCI_BASE_ADDRESS_MEM_MASK;
+			sz64 = sz & PCI_BASE_ADDRESS_MEM_MASK;
+			mask64 = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 		}
 	} else {
 		res->flags |= (l & IORESOURCE_ROM_ENABLE);
-		l &= PCI_ROM_ADDRESS_MASK;
-		sz &= PCI_ROM_ADDRESS_MASK;
-		mask = (u32)PCI_ROM_ADDRESS_MASK;
+		l64 = l & PCI_ROM_ADDRESS_MASK;
+		sz64 = sz & PCI_ROM_ADDRESS_MASK;
+		mask64 = (u32)PCI_ROM_ADDRESS_MASK;
 	}
 
 	if (res->flags & IORESOURCE_MEM_64) {
-		l64 = l;
-		sz64 = sz;
-		mask64 = mask | (u64)~0 << 32;
-
 		pci_read_config_dword(dev, pos + 4, &l);
 		pci_write_config_dword(dev, pos + 4, ~0);
 		pci_read_config_dword(dev, pos + 4, &sz);
@@ -242,18 +237,24 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 		l64 |= ((u64)l << 32);
 		sz64 |= ((u64)sz << 32);
+		mask64 |= ((u64)~0 << 32);
+	}
 
-		sz64 = pci_size(l64, sz64, mask64);
+	if (!dev->mmio_always_on &&
+	    (orig_cmd & PCI_COMMAND_DECODE_ENABLE))
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 
-		if (!sz64)
-			goto fail;
+	if (!sz64)
+		goto fail;
 
+	if (res->flags & IORESOURCE_MEM_64) {
 		if ((sizeof(dma_addr_t) < 8 || sizeof(resource_size_t) < 8) &&
 		    sz64 > 0x100000000ULL) {
 			res->flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
 			res->start = 0;
 			res->end = 0;
-			bar_too_big = true;
+			dev_err(&dev->dev, "reg 0x%x: can't handle BAR larger than 4GB (size %#010llx)\n",
+				pos, (unsigned long long)sz64);
 			goto out;
 		}
 
@@ -262,21 +263,19 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			res->flags |= IORESOURCE_UNSET;
 			res->start = 0;
 			res->end = sz64;
-			bar_too_high = true;
+			dev_info(&dev->dev, "reg 0x%x: can't handle BAR above 4G (bus address %#010llx)\n",
+				 pos, (unsigned long long)l64);
 			goto out;
-		} else {
-			region.start = l64;
-			region.end = l64 + sz64;
 		}
-	} else {
-		sz = pci_size(l, sz, mask);
+	}
 
-		if (!sz)
-			goto fail;
+	sz64 = pci_size(l64, sz64, mask64);
 
-		region.start = l;
-		region.end = l + sz;
-	}
+	if (!sz64)
+		goto fail;
+
+	region.start = l64;
+	region.end = l64 + sz64;
 
 	pcibios_bus_to_resource(dev->bus, res, &region);
 	pcibios_resource_to_bus(dev->bus, &inverted_region, res);
@@ -296,7 +295,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->flags |= IORESOURCE_UNSET;
 		res->start = 0;
 		res->end = region.end - region.start;
-		bar_invalid = true;
+		dev_info(&dev->dev, "reg 0x%x: initial BAR value %#010llx invalid\n",
+			 pos, (unsigned long long)region.start);
 	}
 
 	goto out;
@@ -305,19 +305,6 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 fail:
 	res->flags = 0;
 out:
-	if (!dev->mmio_always_on &&
-	    (orig_cmd & PCI_COMMAND_DECODE_ENABLE))
-		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
-
-	if (bar_too_big)
-		dev_err(&dev->dev, "reg 0x%x: can't handle BAR larger than 4GB (size %#010llx)\n",
-			pos, (unsigned long long) sz64);
-	if (bar_too_high)
-		dev_info(&dev->dev, "reg 0x%x: can't handle BAR above 4G (bus address %#010llx)\n",
-			 pos, (unsigned long long) l64);
-	if (bar_invalid)
-		dev_info(&dev->dev, "reg 0x%x: initial BAR value %#010llx invalid\n",
-			 pos, (unsigned long long) region.start);
 	if (res->flags)
 		dev_printk(KERN_DEBUG, &dev->dev, "reg 0x%x: %pR\n", pos, res);
 

