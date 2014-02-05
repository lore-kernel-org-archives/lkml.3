Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaBEGw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:52:27 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63137 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaBEGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:52:05 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, horms@verge.net.au,
        bhelgaas@google.com, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk
Date: Wed, 05 Feb 2014 15:53:15 +0900
Message-Id: <20140205065315.29445.65734.sendpatchset@w520>
In-Reply-To: <20140205065243.29445.76593.sendpatchset@w520>
References: <20140205065243.29445.76593.sendpatchset@w520>
Subject: [PATCH 02/04] PCI: rcar: Break out window size handling
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

 drivers/pci/host/pci-rcar-gen2.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- 0005/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-04 17:22:41.000000000 +0900
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 
 /* AHB-PCI Bridge PCI communication registers */
@@ -81,6 +82,7 @@ struct rcar_pci_priv {
 	struct resource mem_res;
 	struct resource *cfg_res;
 	int irq;
+	unsigned long window_size;
 };
 
 /* PCI configuration space operations */
@@ -180,10 +182,31 @@ static int __init rcar_pci_setup(int nr,
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
@@ -194,7 +217,7 @@ static int __init rcar_pci_setup(int nr,
 	       RCAR_PCI_ARBITER_PCIBP_MODE;
 	iowrite32(val, reg + RCAR_PCI_ARBITER_CTR_REG);
 
-	/* PCI-AHB mapping: 0x40000000-0x80000000 */
+	/* PCI-AHB mapping: 0x40000000 base */
 	iowrite32(0x40000000 | RCAR_PCIAHB_PREFETCH16,
 		  reg + RCAR_PCIAHB_WIN1_CTR_REG);
 
@@ -271,6 +294,8 @@ static int rcar_pci_probe(struct platfor
 	priv->reg = reg;
 	priv->dev = &pdev->dev;
 
+	priv->window_size = SZ_1G;
+
 	memset(&hw, 0, sizeof(hw));
 	hw.nr_controllers = 1;
 	hw.private_data = (void **)&priv;
