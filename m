Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FZJe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:34:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3FZJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:34:54 -0400
Date: Wed, 26 Jun 2013 02:34:18 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVXdlIEtsZWluZS1Lw7ZuaWc=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-292ec080491d87c888c29c5e161c10eb86e5961e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@kernel.org, catalin.marinas@arm.com, arnd@arndb.de,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        jonathan.austin@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, arnd@arndb.de,
        jonathan.austin@arm.com, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de
In-Reply-To: <1372231128-11802-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1372231128-11802-1-git-send-email-u.kleine-koenig@pengutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: Add support for ARMv7-M NVIC
Git-Commit-ID: 292ec080491d87c888c29c5e161c10eb86e5961e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 02:34:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  292ec080491d87c888c29c5e161c10eb86e5961e
Gitweb:     http://git.kernel.org/tip/292ec080491d87c888c29c5e161c10eb86e5961e
Author:     Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
AuthorDate: Wed, 26 Jun 2013 09:18:48 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Jun 2013 11:29:38 +0200

irqchip: Add support for ARMv7-M NVIC

This interrupt controller is integrated in all Cortex-M3 and Cortex-M4
machines.

Support for this controller appeared in Catalin's Cortex tree based on
2.6.33 but was nearly completely rewritten.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Jonathan Austin <jonathan.austin@arm.com>
Cc: kernel@pengutronix.de
Link: http://lkml.kernel.org/r/1372231128-11802-1-git-send-email-u.kleine-koenig@pengutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/Kconfig    |   5 ++
 drivers/irqchip/Makefile   |   1 +
 drivers/irqchip/irq-nvic.c | 117 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index d4d1f4b..1fea003 100644
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
index 8fe6ad5..2065ef6 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
new file mode 100644
index 0000000..8d0c8b3
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,117 @@
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
+#define NVIC_ISER		0x000
+#define NVIC_ICER		0x080
+#define NVIC_IPR		0x300
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
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	unsigned int irqs, i, ret, numbanks;
+	void __iomem *nvic_base;
+
+	numbanks = (readl_relaxed(V7M_SCS_ICTR) &
+		    V7M_SCS_ICTR_INTLINESNUM_MASK) + 1;
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
+		struct irq_chip_generic *gc;
+
+		gc = irq_get_domain_generic_chip(nvic_irq_domain, 32 * i);
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
