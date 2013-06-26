Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FZOCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:02:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3FZOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:02:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/2] ARM: EXYNOS: Remove combiner_init declaration
Date: Wed, 26 Jun 2013 16:02:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        tglx@linutronix.de, t.figa@samsung.com, patches@linaro.org
References: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306261602.26800.arnd@arndb.de>
X-Provags-ID: V02:K0:o3oiRYRaDHrhKOyT/njskLPU01+xwm7u4JienCVDGjh
 DiVTgRXtc/Hosz02tdtZF7Htgcd8PdIalYttaqhyp/9y4WEEFu
 1f7sXdicAVaxs8UUBLWW+G4c7fupB2rV+1ZNF0+S1kIWWjZ1WN
 Eo7JoTJjpp/gD2gBNh6/LrpZKMuvFqcw6iPU8Yi1QZFZz5m6N6
 MjdhBmqtkVgeEz2jbB/e6+GA3jHblwr9AuZwoIbrmgSKYfIT6U
 QhzOXoMzhT7TNpWLXye46nYWADO4Ks6ov0DOGZBhPaTyWVe+ud
 lMTMhzQ8FDaRCojLeHo6PNkpzovpCJgPLHkqslLAr8ZRqdO2jz
 NZN6Kd2Pm4TLZuSDdu3Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Sachin Kamat wrote:
> Commit d243997f ("ARM: EXYNOS: Remove legacy interrupt initialization
> code") removed the call to combiner_init(). Since there are no more
> users in the machine code, remove the declaration as well.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Hi,

Your two patches look good to me, but I think there is more that
can be cleaned up now. See below for my experimental patch.
I have not gotten around to test or submit that, but feel
free to take any contents for your own patches.

	Arnd

commit 3ee3acd595728d20b1a23fccc9684479749833e6
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Jun 14 15:47:26 2013 +0200

    irqchip: exynos: remove ATAGS code
    
    With 3.11, the exynos platform will only support DT based booting,
    so we can kill off a lot of code from this driver.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 3e156bc..a659ace 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -71,10 +71,6 @@ void exynos4212_register_clocks(void);
 #define exynos4212_register_clocks()
 #endif
 
-struct device_node;
-void combiner_init(void __iomem *combiner_base, struct device_node *np,
-			unsigned int max_nr, int irq_base);
-
 extern struct smp_operations exynos_smp_ops;
 
 extern void exynos_cpu_die(unsigned int cpu);
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 55df3bd..e6b9137 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
-obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
+obj-$(CONFIG_ARCH_EXYNOS_COMMON)	+= exynos-combiner.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index a9d2b2f..d6ba2f7 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -19,10 +19,6 @@
 #include <linux/of_irq.h>
 #include <asm/mach/irq.h>
 
-#ifdef CONFIG_EXYNOS_ATAGS
-#include <plat/cpu.h>
-#endif
-
 #include "irqchip.h"
 
 #define COMBINER_ENABLE_SET	0x0
@@ -138,7 +134,6 @@ static void __init combiner_init_one(struct combiner_chip_data *combiner_data,
 	__raw_writel(combiner_data->irq_mask, base + COMBINER_ENABLE_CLEAR);
 }
 
-#ifdef CONFIG_OF
 static int combiner_irq_domain_xlate(struct irq_domain *d,
 				     struct device_node *controller,
 				     const u32 *intspec, unsigned int intsize,
@@ -156,16 +151,6 @@ static int combiner_irq_domain_xlate(struct irq_domain *d,
 
 	return 0;
 }
-#else
-static int combiner_irq_domain_xlate(struct irq_domain *d,
-				     struct device_node *controller,
-				     const u32 *intspec, unsigned int intsize,
-				     unsigned long *out_hwirq,
-				     unsigned int *out_type)
-{
-	return -EINVAL;
-}
-#endif
 
 static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				   irq_hw_number_t hw)
@@ -184,95 +169,48 @@ static struct irq_domain_ops combiner_irq_domain_ops = {
 	.map	= combiner_irq_domain_map,
 };
 
-static unsigned int combiner_lookup_irq(int group)
-{
-#ifdef CONFIG_EXYNOS_ATAGS
-	if (group < EXYNOS4210_MAX_COMBINER_NR || soc_is_exynos5250())
-		return IRQ_SPI(group);
-
-	switch (group) {
-	case 16:
-		return IRQ_SPI(107);
-	case 17:
-		return IRQ_SPI(108);
-	case 18:
-		return IRQ_SPI(48);
-	case 19:
-		return IRQ_SPI(42);
-	}
-#endif
-	return 0;
-}
-
-void __init combiner_init(void __iomem *combiner_base,
-			  struct device_node *np,
-			  unsigned int max_nr,
-			  int irq_base)
+static int __init combiner_init(struct device_node *np)
 {
 	int i, irq;
+	unsigned int max_nr = 20;
 	unsigned int nr_irq;
+	void __iomem *combiner_base;
 	struct combiner_chip_data *combiner_data;
 
+	combiner_base = of_iomap(np, 0);
+	if (!combiner_base) {
+		pr_err("%s: failed to map combiner registers\n", __func__);
+		return -ENXIO;
+	}
+
+	if (of_property_read_u32(np, "samsung,combiner-nr", &max_nr)) {
+		pr_info("%s: number of combiners not specified, "
+			"setting default as %d.\n",
+			__func__, max_nr);
+	}
+
 	nr_irq = max_nr * IRQ_IN_COMBINER;
 
 	combiner_data = kcalloc(max_nr, sizeof (*combiner_data), GFP_KERNEL);
 	if (!combiner_data) {
 		pr_warning("%s: could not allocate combiner data\n", __func__);
-		return;
+		return -ENOMEM;
 	}
 
-	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
+	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, -1,
 				&combiner_irq_domain_ops, combiner_data);
 	if (WARN_ON(!combiner_irq_domain)) {
 		pr_warning("%s: irq domain init failed\n", __func__);
-		return;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < max_nr; i++) {
-#ifdef CONFIG_OF
-		if (np)
-			irq = irq_of_parse_and_map(np, i);
-		else
-#endif
-			irq = combiner_lookup_irq(i);
-
+		irq = irq_of_parse_and_map(np, i);
 		combiner_init_one(&combiner_data[i], i,
 				  combiner_base + (i >> 2) * 0x10, irq);
 		combiner_cascade_irq(&combiner_data[i], irq);
 	}
-}
-
-#ifdef CONFIG_OF
-static int __init combiner_of_init(struct device_node *np,
-				   struct device_node *parent)
-{
-	void __iomem *combiner_base;
-	unsigned int max_nr = 20;
-	int irq_base = -1;
-
-	combiner_base = of_iomap(np, 0);
-	if (!combiner_base) {
-		pr_err("%s: failed to map combiner registers\n", __func__);
-		return -ENXIO;
-	}
-
-	if (of_property_read_u32(np, "samsung,combiner-nr", &max_nr)) {
-		pr_info("%s: number of combiners not specified, "
-			"setting default as %d.\n",
-			__func__, max_nr);
-	}
-
-	/* 
-	 * FIXME: This is a hardwired COMBINER_IRQ(0,0). Once all devices
-	 * get their IRQ from DT, remove this in order to get dynamic
-	 * allocation.
-	 */
-	irq_base = 160;
-
-	combiner_init(combiner_base, np, max_nr, irq_base);
 
 	return 0;
 }
-IRQCHIP_DECLARE(exynos4210_combiner, "samsung,exynos4210-combiner",
-		combiner_of_init);
-#endif
+IRQCHIP_DECLARE(exynos_combiner, "samsung,exynos4210-combiner", combiner_init);
