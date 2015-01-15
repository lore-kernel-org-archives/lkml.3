Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbbAOKKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:10:41 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37318 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbAOKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:10:01 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] irqchip: add sa1100 driver
Date: Thu, 15 Jan 2015 13:09:33 +0300
Message-Id: <1421316574-10022-4-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an irqchip driver for Intel StrongARM SA-11x0 family of chips. For
now it is just a copy of the current arch/arm/mach-sa1100/irq.c driver.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/irqchip/Makefile           |   1 +
 drivers/irqchip/irq-sa11x0.c       | 185 +++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/irq-sa11x0.h |  18 ++++
 3 files changed, 204 insertions(+)
 create mode 100644 drivers/irqchip/irq-sa11x0.c
 create mode 100644 include/linux/irqchip/irq-sa11x0.h

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a32..b0d1dde 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
 obj-$(CONFIG_MIPS_GIC)			+= irq-mips-gic.o
 obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
+obj-$(CONFIG_ARCH_SA1100)		+= irq-sa11x0.o
diff --git a/drivers/irqchip/irq-sa11x0.c b/drivers/irqchip/irq-sa11x0.c
new file mode 100644
index 0000000..c840187
--- /dev/null
+++ b/drivers/irqchip/irq-sa11x0.c
@@ -0,0 +1,185 @@
+/*
+ * drivers/irqchip/irq-sa11x0.c
+ *
+ * Copyright (C) 1999-2001 Nicolas Pitre
+ *
+ * Generic IRQ handling for the SA11x0.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/syscore_ops.h>
+#include <linux/irqchip/irq-sa11x0.h>
+
+#include <asm/exception.h>
+
+#define ICIP	0x00  /* IC IRQ Pending reg. */
+#define ICMR	0x04  /* IC Mask Reg.        */
+#define ICLR	0x08  /* IC Level Reg.       */
+#define ICCR	0x0C  /* IC Control Reg.     */
+#define ICFP	0x10  /* IC FIQ Pending reg. */
+#define ICPR	0x20  /* IC Pending Reg.     */
+
+static void __iomem *iobase;
+static DEFINE_RAW_SPINLOCK(lock);
+
+/*
+ * We don't need to ACK IRQs on the SA1100 unless they're GPIOs
+ * this is for internal IRQs i.e. from IRQ LCD to RTCAlrm.
+ */
+static void sa1100_mask_irq(struct irq_data *d)
+{
+	u32 reg;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&lock, flags);
+
+	reg = readl_relaxed(iobase + ICMR);
+	reg &= ~BIT(d->hwirq);
+	writel_relaxed(reg, iobase + ICMR);
+
+	raw_spin_unlock_irqrestore(&lock, flags);
+}
+
+static void sa1100_unmask_irq(struct irq_data *d)
+{
+	u32 reg;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&lock, flags);
+
+	reg = readl_relaxed(iobase + ICMR);
+	reg |= BIT(d->hwirq);
+	writel_relaxed(reg, iobase + ICMR);
+
+	raw_spin_unlock_irqrestore(&lock, flags);
+}
+
+static int sa1100_set_wake(struct irq_data *d, unsigned int on)
+{
+	return sa11x0_sc_set_wake(d->hwirq, on);
+}
+
+static struct irq_chip sa1100_normal_chip = {
+	.name		= "SC",
+	.irq_ack	= sa1100_mask_irq,
+	.irq_mask	= sa1100_mask_irq,
+	.irq_unmask	= sa1100_unmask_irq,
+	.irq_set_wake	= sa1100_set_wake,
+};
+
+static int sa1100_normal_irqdomain_map(struct irq_domain *d,
+		unsigned int irq, irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &sa1100_normal_chip,
+				 handle_level_irq);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static struct irq_domain_ops sa1100_normal_irqdomain_ops = {
+	.map = sa1100_normal_irqdomain_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
+static struct irq_domain *sa1100_normal_irqdomain;
+
+static struct sa1100irq_state {
+	unsigned int	saved;
+	unsigned int	icmr;
+	unsigned int	iclr;
+	unsigned int	iccr;
+} sa1100irq_state;
+
+static int sa1100irq_suspend(void)
+{
+	struct sa1100irq_state *st = &sa1100irq_state;
+
+	st->saved = 1;
+	st->icmr = readl_relaxed(iobase + ICMR);
+	st->iclr = readl_relaxed(iobase + ICLR);
+	st->iccr = readl_relaxed(iobase + ICCR);
+
+	/*
+	 * Disable all GPIO-based interrupts.
+	 */
+	writel_relaxed(st->icmr & 0xfffff000, iobase + ICMR);
+
+	return 0;
+}
+
+static void sa1100irq_resume(void)
+{
+	struct sa1100irq_state *st = &sa1100irq_state;
+
+	if (st->saved) {
+		writel_relaxed(st->iccr, iobase + ICCR);
+		writel_relaxed(st->iclr, iobase + ICLR);
+
+		writel_relaxed(st->icmr, iobase + ICMR);
+	}
+}
+
+static struct syscore_ops sa1100irq_syscore_ops = {
+	.suspend	= sa1100irq_suspend,
+	.resume		= sa1100irq_resume,
+};
+
+static int __init sa1100irq_init_devicefs(void)
+{
+	register_syscore_ops(&sa1100irq_syscore_ops);
+	return 0;
+}
+
+device_initcall(sa1100irq_init_devicefs);
+
+static asmlinkage void __exception_irq_entry
+sa1100_handle_irq(struct pt_regs *regs)
+{
+	uint32_t icip, icmr, mask;
+
+	do {
+		icip = readl_relaxed(iobase + ICIP);
+		icmr = readl_relaxed(iobase + ICMR);
+		mask = icip & icmr;
+
+		if (mask == 0)
+			break;
+
+		handle_domain_irq(sa1100_normal_irqdomain,
+				ffs(mask) - 1, regs);
+	} while (1);
+}
+
+void __init sa11x0_init_irq_nodt(int irq_start, resource_size_t io_start)
+{
+	iobase = ioremap(io_start, SZ_64K);
+	if (WARN_ON(!iobase))
+		return;
+
+	/* disable all IRQs */
+	writel_relaxed(0, iobase + ICMR);
+
+	/* all IRQs are IRQ, not FIQ */
+	writel_relaxed(0, iobase + ICLR);
+
+	/*
+	 * Whatever the doc says, this has to be set for the wait-on-irq
+	 * instruction to work... on a SA1100 rev 9 at least.
+	 */
+	writel_relaxed(1, iobase + ICCR);
+
+	sa1100_normal_irqdomain = irq_domain_add_simple(NULL,
+			32, irq_start,
+			&sa1100_normal_irqdomain_ops, NULL);
+
+	set_handle_irq(sa1100_handle_irq);
+}
diff --git a/include/linux/irqchip/irq-sa11x0.h b/include/linux/irqchip/irq-sa11x0.h
new file mode 100644
index 0000000..38ebe2f
--- /dev/null
+++ b/include/linux/irqchip/irq-sa11x0.h
@@ -0,0 +1,18 @@
+/*
+ * Generic IRQ handling for the SA11x0.
+ *
+ * Copyright (C) 1999-2001 Nicolas Pitre
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __INCLUDE_LINUX_IRQCHIP_IRQ_SA11x0_H
+#define __INCLUDE_LINUX_IRQCHIP_IRQ_SA11x0_H
+
+void __init sa11x0_init_irq_nodt(int irq_start, resource_size_t io_start);
+int sa11x0_gpio_set_wake(unsigned int gpio, unsigned int on);
+int sa11x0_sc_set_wake(unsigned int irq, unsigned int on);
+
+#endif
-- 
2.1.4

