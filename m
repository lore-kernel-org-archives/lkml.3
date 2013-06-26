Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3FZHTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:19:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51443 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3FZHTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:19:05 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 09:18:48 +0200
Message-Id: <1372231128-11802-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH v5] irqchip: Add support for ARMv7-M's NVIC
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interrupt controller is integrated in all Cortex-M3 and Cortex-M4
machines.

Support for this controller appeared in Catalin's Cortex tree based on
2.6.33 but was nearly completely rewritten.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---

Changes since v4, sent with
Message-Id: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>:

 - drop change to arch/arm to simplify merging
 - merge two loops into a single one

I added the acks v4 of this patch got assuming the changes introduced since
then don't affect your acknowledgment. Please tell me if you don't agree, then
I drop them.

 drivers/irqchip/Kconfig    |   5 ++
 drivers/irqchip/Makefile   |   1 +
 drivers/irqchip/irq-nvic.c | 115 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+)
 create mode 100644 drivers/irqchip/irq-nvic.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..8317a7e 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -10,6 +10,11 @@ config ARM_GIC
 config GIC_NON_BANKED
 	bool
 
+config ARM_NVIC
+	bool
+	select IRQ_DOMAIN
+	select GENERIC_IRQ_CHIP
+
 config ARM_VIC
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..4bb277c 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
new file mode 100644
index 0000000..7492d7b
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,115 @@
+/*
+ * drivers/irq/irq-nvic.c
+ *
+ * Copyright (C) 2008 ARM Limited, All Rights Reserved.
+ * Copyright (C) 2013 Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Support for the Nested Vectored Interrupt Controller found on the
+ * ARMv7-M CPUs (Cortex-M3/M4)
+ */
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+
+#include <asm/v7m.h>
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define NVIC_ISER			0x000
+#define NVIC_ICER			0x080
+#define NVIC_IPR			0x300
+
+#define NVIC_MAX_BANKS		16
+/*
+ * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
+ * 16 irqs.
+ */
+#define NVIC_MAX_IRQ		((NVIC_MAX_BANKS - 1) * 32 + 16)
+
+static struct irq_domain *nvic_irq_domain;
+
+asmlinkage void __exception_irq_entry
+nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
+{
+	unsigned int irq = irq_linear_revmap(nvic_irq_domain, hwirq);
+
+	handle_IRQ(irq, regs);
+}
+
+static void nvic_eoi(struct irq_data *d)
+{
+	/*
+	 * This is a no-op as end of interrupt is signaled by the exception
+	 * return sequence.
+	 */
+}
+
+static int __init nvic_of_init(struct device_node *node,
+			       struct device_node *parent)
+{
+	void __iomem *nvic_base;
+	unsigned int irqs, i, ret;
+	unsigned numbanks = (readl_relaxed(V7M_SCS_ICTR) &
+			     V7M_SCS_ICTR_INTLINESNUM_MASK) + 1;
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+
+	nvic_base = of_iomap(node, 0);
+	if (!nvic_base) {
+		pr_warn("unable to map nvic registers\n");
+		return -ENOMEM;
+	}
+
+	irqs = numbanks * 32;
+	if (irqs > NVIC_MAX_IRQ)
+		irqs = NVIC_MAX_IRQ;
+
+	nvic_irq_domain =
+		irq_domain_add_linear(node, irqs, &irq_generic_chip_ops, NULL);
+	if (!nvic_irq_domain) {
+		pr_warn("Failed to allocate irq domain\n");
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(nvic_irq_domain, 32, numbanks,
+					     "nvic_irq", handle_fasteoi_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_warn("Failed to allocate irq chips\n");
+		irq_domain_remove(nvic_irq_domain);
+		return ret;
+	}
+
+	for (i = 0; i < numbanks; ++i) {
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(nvic_irq_domain, 32 * i);
+		gc->reg_base = nvic_base + 4 * i;
+		gc->chip_types[0].regs.enable = NVIC_ISER;
+		gc->chip_types[0].regs.disable = NVIC_ICER;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
+		gc->chip_types[0].chip.irq_eoi = nvic_eoi;
+
+		/* disable interrupts */
+		writel_relaxed(~0, gc->reg_base + NVIC_ICER);
+	}
+
+	/* Set priority on all interrupts */
+	for (i = 0; i < irqs; i += 4)
+		writel_relaxed(0, nvic_base + NVIC_IPR + i);
+
+	return 0;
+}
+IRQCHIP_DECLARE(armv7m_nvic, "arm,armv7m-nvic", nvic_of_init);
-- 
1.8.3.1

