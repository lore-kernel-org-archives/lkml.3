Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaBRCKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:10:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47503 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaBRCKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:10:18 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:11:32 +0900
Message-Id: <20140218021132.14164.62223.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH v2 05/08] PCI: rcar: Break out window size handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Break out the hard coded window size code to allow
dynamic setup. The window size is still left at 1GiB
but with this patch changing window size is easy for
testing.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

Changes since V1:
 - Updated to fit on top of patches from Ben Dooks

 drivers/pci/host/pci-rcar-gen2.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- 0007/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-13 10:16:48.000000000 +0900
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 
 /* AHB-PCI Bridge PCI communication registers */
@@ -98,6 +99,7 @@ struct rcar_pci_priv {
 	struct resource mem_res;
 	struct resource *cfg_res;
 	int irq;
+	unsigned long window_size;
 };
 
 /* PCI configuration space operations */
@@ -241,10 +243,31 @@ static int __init rcar_pci_setup(int nr,
 	iowrite32(val, reg + RCAR_USBCTR_REG);
 	udelay(4);
 
-	/* De-assert reset and set PCIAHB window1 size to 1GB */
+	/* De-assert reset and reset PCIAHB window1 size */
 	val &= ~(RCAR_USBCTR_PCIAHB_WIN1_MASK | RCAR_USBCTR_PCICLK_MASK |
 		 RCAR_USBCTR_USBH_RST | RCAR_USBCTR_PLL_RST);
-	iowrite32(val | RCAR_USBCTR_PCIAHB_WIN1_1G, reg + RCAR_USBCTR_REG);
+
+	/* Setup PCIAHB window1 size */
+	switch (priv->window_size) {
+	case SZ_2G:
+		val |= RCAR_USBCTR_PCIAHB_WIN1_2G;
+		break;
+	case SZ_1G:
+		val |= RCAR_USBCTR_PCIAHB_WIN1_1G;
+		break;
+	case SZ_512M:
+		val |= RCAR_USBCTR_PCIAHB_WIN1_512M;
+		break;
+	default:
+		pr_warn("unknown window size %ld - defaulting to 256M\n",
+			priv->window_size);
+		priv->window_size = SZ_256M;
+		/* fall-through */
+	case SZ_256M:
+		val |= RCAR_USBCTR_PCIAHB_WIN1_256M;
+		break;
+	}
+	iowrite32(val, reg + RCAR_USBCTR_REG);
 
 	/* Configure AHB master and slave modes */
 	iowrite32(RCAR_AHB_BUS_MODE, reg + RCAR_AHB_BUS_CTR_REG);
@@ -255,7 +278,7 @@ static int __init rcar_pci_setup(int nr,
 	       RCAR_PCI_ARBITER_PCIBP_MODE;
 	iowrite32(val, reg + RCAR_PCI_ARBITER_CTR_REG);
 
-	/* PCI-AHB mapping: 0x40000000-0x80000000 */
+	/* PCI-AHB mapping: 0x40000000 base */
 	iowrite32(0x40000000 | RCAR_PCIAHB_PREFETCH16,
 		  reg + RCAR_PCIAHB_WIN1_CTR_REG);
 
@@ -341,6 +364,8 @@ static int rcar_pci_probe(struct platfor
 		return priv->irq;
 	}
 
+	priv->window_size = SZ_1G;
+
 	hw_private[0] = priv;
 	memset(&hw, 0, sizeof(hw));
 	hw.nr_controllers = ARRAY_SIZE(hw_private);
