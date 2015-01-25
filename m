Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbbAYOZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:25:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:42375 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbAYOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:25:28 -0500
Date: Sun, 25 Jan 2015 15:25:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq fixes for 3.19
Message-ID: <alpine.DEB.2.11.1501251518390.5526@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

>From the irqchip departement you get:
  - Regression fix for omap-intc
  - Regression fix for atmel-aic-common
  - Functional correctness fix for hip04
  - Type mismatch fix for gic-v3-its
  - Proper error pointer check for mtd-sysirq 

Mostly one and two liners except for the omap regression fix which is
slightly larger than desired.

Thanks,

	tglx

------------------>
Felipe Balbi (1):
      irqchip: omap-intc: Fix legacy DMA regression

Gavin Li (1):
      irqchip: atmel-aic-common: Prevent clobbering of priority when changing IRQ type

Wang Long (1):
      irqchip: hip04: Initialize hip04_cpu_map to 0xffff

Will Deacon (1):
      irqchip: gic-v3-its: Fix use of max with decimal constant

Yingjoe Chen (1):
      irqchip: mtk-sysirq: Use IS_ERR() instead of NULL pointer check


 drivers/irqchip/irq-atmel-aic-common.c |  4 ++--
 drivers/irqchip/irq-gic-v3-its.c       |  2 +-
 drivers/irqchip/irq-hip04.c            |  2 +-
 drivers/irqchip/irq-mtk-sysirq.c       |  4 ++--
 drivers/irqchip/irq-omap-intc.c        | 26 +++++++++++++++++++++-----
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index d111ac779c40..63cd031b2c28 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -28,7 +28,7 @@
 #define AT91_AIC_IRQ_MIN_PRIORITY	0
 #define AT91_AIC_IRQ_MAX_PRIORITY	7
 
-#define AT91_AIC_SRCTYPE		GENMASK(7, 6)
+#define AT91_AIC_SRCTYPE		GENMASK(6, 5)
 #define AT91_AIC_SRCTYPE_LOW		(0 << 5)
 #define AT91_AIC_SRCTYPE_FALLING	(1 << 5)
 #define AT91_AIC_SRCTYPE_HIGH		(2 << 5)
@@ -74,7 +74,7 @@ int aic_common_set_type(struct irq_data *d, unsigned type, unsigned *val)
 		return -EINVAL;
 	}
 
-	*val &= AT91_AIC_SRCTYPE;
+	*val &= ~AT91_AIC_SRCTYPE;
 	*val |= aic_type;
 
 	return 0;
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 86e4684adeb1..d8996bdf0f61 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1053,7 +1053,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	 * of two entries. No, the architecture doesn't let you
 	 * express an ITT with a single entry.
 	 */
-	nr_ites = max(2, roundup_pow_of_two(nvecs));
+	nr_ites = max(2UL, roundup_pow_of_two(nvecs));
 	sz = nr_ites * its->ite_size;
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
 	itt = kmalloc(sz, GFP_KERNEL);
diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
index 29b8f21b74d0..6bc2deb73d53 100644
--- a/drivers/irqchip/irq-hip04.c
+++ b/drivers/irqchip/irq-hip04.c
@@ -381,7 +381,7 @@ hip04_of_init(struct device_node *node, struct device_node *parent)
 	 * It will be refined as each CPU probes its ID.
 	 */
 	for (i = 0; i < NR_HIP04_CPU_IF; i++)
-		hip04_cpu_map[i] = 0xff;
+		hip04_cpu_map[i] = 0xffff;
 
 	/*
 	 * Find out how many interrupts are supported.
diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
index 7e342df6a62f..0b0d2c00a2df 100644
--- a/drivers/irqchip/irq-mtk-sysirq.c
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -137,9 +137,9 @@ static int __init mtk_sysirq_of_init(struct device_node *node,
 		return -ENOMEM;
 
 	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
-	if (!chip_data->intpol_base) {
+	if (IS_ERR(chip_data->intpol_base)) {
 		pr_err("mtk_sysirq: unable to map sysirq register\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(chip_data->intpol_base);
 		goto out_free;
 	}
 
diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index 28718d3e8281..c03f140acbae 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -263,7 +263,7 @@ static int __init omap_init_irq_of(struct device_node *node)
 	return ret;
 }
 
-static int __init omap_init_irq_legacy(u32 base)
+static int __init omap_init_irq_legacy(u32 base, struct device_node *node)
 {
 	int j, irq_base;
 
@@ -277,7 +277,7 @@ static int __init omap_init_irq_legacy(u32 base)
 		irq_base = 0;
 	}
 
-	domain = irq_domain_add_legacy(NULL, omap_nr_irqs, irq_base, 0,
+	domain = irq_domain_add_legacy(node, omap_nr_irqs, irq_base, 0,
 			&irq_domain_simple_ops, NULL);
 
 	omap_irq_soft_reset();
@@ -301,10 +301,26 @@ static int __init omap_init_irq(u32 base, struct device_node *node)
 {
 	int ret;
 
-	if (node)
+	/*
+	 * FIXME legacy OMAP DMA driver sitting under arch/arm/plat-omap/dma.c
+	 * depends is still not ready for linear IRQ domains; because of that
+	 * we need to temporarily "blacklist" OMAP2 and OMAP3 devices from using
+	 * linear IRQ Domain until that driver is finally fixed.
+	 */
+	if (of_device_is_compatible(node, "ti,omap2-intc") ||
+			of_device_is_compatible(node, "ti,omap3-intc")) {
+		struct resource res;
+
+		if (of_address_to_resource(node, 0, &res))
+			return -ENOMEM;
+
+		base = res.start;
+		ret = omap_init_irq_legacy(base, node);
+	} else if (node) {
 		ret = omap_init_irq_of(node);
-	else
-		ret = omap_init_irq_legacy(base);
+	} else {
+		ret = omap_init_irq_legacy(base, NULL);
+	}
 
 	if (ret == 0)
 		omap_irq_enable_protection();
