Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab3DQQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:02:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3DQQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:02:51 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Wed, 17 Apr 2013 18:02:20 +0200
Message-Id: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.

Support for this controller appeared in Catalin's Cortex tree based on
2.6.33 but was nearly completely rewritten.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---

Notes:
    Changes since v2, sent with
    Message-id:1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de:
    
     - drop superflous check for node != NULL in init function
     - rework for linear irq domain
     - drop seperate function for non-dt init

This patch triggers two checkpatch warnings:

	WARNING: Avoid CamelCase: <nvic_do_IRQ>
	WARNING: Avoid CamelCase: <handle_IRQ>

but I think they are OK for consistency?!
Moreover sparse tells me:

	drivers/irqchip/irq-nvic.c:58:1: warning: symbol 'nvic_do_IRQ' was not declared. Should it be static?

nvic_do_IRQ is called from assembler only, so a declaration couldn't be
shared and I couldn't find a nice place for a declaration. Suggestions
welcome.

Thanks
Uwe

 drivers/irqchip/Kconfig    |   4 ++
 drivers/irqchip/Makefile   |   1 +
 drivers/irqchip/irq-nvic.c | 154 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)
 create mode 100644 drivers/irqchip/irq-nvic.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index a350969..18657fd 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -10,6 +10,10 @@ config ARM_GIC
 config GIC_NON_BANKED
 	bool
 
+config ARM_NVIC
+	bool
+	select IRQ_DOMAIN
+
 config ARM_VIC
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 98e3b87..7227c5f 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
new file mode 100644
index 0000000..6e9ca8a
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,154 @@
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
+#include <linux/export.h>
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
+struct nvic_bank_data {
+	/*
+	 * For irq i base holds nvic_base + 4 * i / 32. So you can access the
+	 * right ISER register (i.e ISER[i / 32]) by just taking base + ISER.
+	 * Ditto for ICER.
+	 */
+	void __iomem *base;
+};
+
+static struct nvic_chip_data {
+	struct irq_domain *domain;
+	struct nvic_bank_data bdata[NVIC_MAX_BANKS];
+} nvic_chip_data;
+
+asmlinkage void __exception_irq_entry
+nvic_do_IRQ(irq_hw_number_t hwirq, struct pt_regs *regs)
+{
+	unsigned int irq = irq_linear_revmap(nvic_chip_data.domain, hwirq);
+
+	handle_IRQ(irq, regs);
+}
+
+static inline void __iomem *nvic_bank_base(struct irq_data *d)
+{
+	struct nvic_bank_data *bank_data = irq_data_get_irq_chip_data(d);
+	return bank_data->base;
+}
+
+static void nvic_mask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_bank_base(d) + NVIC_ICER);
+}
+
+static void nvic_unmask_irq(struct irq_data *d)
+{
+	u32 mask = 1 << (d->hwirq % 32);
+
+	writel_relaxed(mask, nvic_bank_base(d) + NVIC_ISER);
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
+static struct irq_chip nvic_chip = {
+	.name = "NVIC",
+	.irq_mask = nvic_mask_irq,
+	.irq_unmask = nvic_unmask_irq,
+	.irq_eoi = nvic_eoi,
+};
+
+static int nvic_irq_domain_map(struct irq_domain *domain, unsigned int virq,
+			       irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &nvic_chip,
+				 handle_fasteoi_irq);
+	irq_set_chip_data(virq, nvic_chip_data.bdata + hw / 32);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops nvic_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onetwocell,
+	.map = nvic_irq_domain_map,
+};
+
+static int __init nvic_of_init(struct device_node *node,
+			       struct device_node *parent)
+{
+	void __iomem *nvic_base;
+	unsigned int irqs, i;
+	unsigned numbanks = (readl_relaxed(V7M_SCS_ICTR) &
+			     V7M_SCS_ICTR_INTLINESNUM_MASK) + 1;
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
+	for (i = 0; i < numbanks; ++i)
+		nvic_chip_data.bdata[i].base = nvic_base + 4 * i;
+
+	nvic_chip_data.domain =
+		irq_domain_add_linear(node, irqs, &nvic_irq_domain_ops, NULL);
+	if (!nvic_chip_data.domain) {
+		pr_warn("Failed to allocate irq domain\n");
+		return -ENOMEM;
+	}
+
+	/* Disable all interrupts */
+	for (i = 0; i < irqs; i += 32)
+		writel_relaxed(~0, nvic_base + NVIC_ICER + i * 4 / 32);
+
+	/* Set priority on all interrupts */
+	for (i = 0; i < irqs; i += 4)
+		writel_relaxed(0, nvic_base + NVIC_IPR + i);
+
+	return 0;
+}
+IRQCHIP_DECLARE(armv7m_nvic, "arm,armv7m-nvic", nvic_of_init);
-- 
1.8.2.rc3

