Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3HPWgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:36:47 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:37197 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3HPWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:36:45 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v1 1/5] irqchip: add Armada 1500 APB interrupt controller
Date: Fri, 16 Aug 2013 21:41:34 +0200
Message-Id: <1376682098-10580-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds irqchip drivers for the secondary interrupt controllers found
on Armada 1500 APB and SYSMGT APB bus.

I tried to find a compatible irqchip driver within v3.11-rc5, but there
is no. I guess that it is a common IP core to buy for your SoC, so maybe
one of the maintainers knows a better name for it. Could be DesignWare
type-of as timers are DW, too.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/Makefile              |    1 +
 drivers/irqchip/irq-armada-1500-apb.c |  108 +++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)
 create mode 100644 drivers/irqchip/irq-armada-1500-apb.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index e65c41a..f02f4db 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
+obj-$(CONFIG_MACH_ARMADA_1500)		+= irq-armada-1500-apb.o
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
diff --git a/drivers/irqchip/irq-armada-1500-apb.c b/drivers/irqchip/irq-armada-1500-apb.c
new file mode 100644
index 0000000..8626eb1
--- /dev/null
+++ b/drivers/irqchip/irq-armada-1500-apb.c
@@ -0,0 +1,108 @@
+/*
+ * Marvell Armada 1500 SoC APB IRQ chip driver.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
+
+#define APB_INT_ENABLE		0x00
+#define APB_INT_MASK		0x08
+#define APB_INT_FINALSTATUS	0x30
+
+static void armada_1500_apb_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct irq_chip_generic *gc = irq_get_handler_data(irq);
+	struct irq_domain *d = gc->private;
+	u32 stat;
+
+	chained_irq_enter(chip, desc);
+
+	stat = readl_relaxed(gc->reg_base + APB_INT_FINALSTATUS);
+
+	while (stat) {
+		u32 hwirq = ffs(stat) - 1;
+		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
+		stat &= ~(1 << hwirq);
+	}
+	chained_irq_exit(chip, desc);
+}
+
+static int __init armada_1500_apb_irq_init(struct device_node *np,
+					   struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	int ret, irq;
+
+	domain = irq_domain_add_linear(np, 32,
+				       &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: unable to add irq domain\n", np->name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 32, 1, np->name,
+			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: unable to alloc irq domain gc\n", np->name);
+		return ret;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	if (ret) {
+		pr_err("%s: unable to get resource\n", np->name);
+		return ret;
+	}
+
+	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
+		pr_err("%s: unable to request mem region\n", np->name);
+		return -ENOMEM;
+	}
+
+	/* Map the parent interrupt for the chained handler */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", np->name);
+		return -EINVAL;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->private = domain;
+	gc->reg_base = ioremap(r.start, resource_size(&r));
+	if (!gc->reg_base) {
+		pr_err("%s: unable to map resource\n", np->name);
+		return -ENOMEM;
+	}
+
+	gc->chip_types[0].regs.mask = APB_INT_MASK;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+
+	/* mask and enable all interrupts */
+	writel(~0, gc->reg_base + APB_INT_MASK);
+	writel(~0, gc->reg_base + APB_INT_ENABLE);
+
+	irq_set_handler_data(irq, gc);
+	irq_set_chained_handler(irq, armada_1500_apb_irq_handler);
+
+	return 0;
+}
+IRQCHIP_DECLARE(armada_1500_apb_intc,
+		"marvell,armada-1500-apb-intc", armada_1500_apb_irq_init);
-- 
1.7.10.4

