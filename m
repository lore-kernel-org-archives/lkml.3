Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbbAOKKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:10:39 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47893 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbAOKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:10:04 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: sa1100: drop irq driver
Date: Thu, 15 Jan 2015 13:09:34 +0300
Message-Id: <1421316574-10022-5-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop irq driver for sa1100 in favour of irqchip driver replacement.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-sa1100/Makefile  |   2 +-
 arch/arm/mach-sa1100/generic.c |  13 +++
 arch/arm/mach-sa1100/irq.c     | 195 -----------------------------------------
 3 files changed, 14 insertions(+), 196 deletions(-)
 delete mode 100644 arch/arm/mach-sa1100/irq.c

diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 61ff91e..ebc4d58 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y := clock.o generic.o irq.o #nmi-oopser.o
+obj-y := clock.o generic.o #nmi-oopser.o
 
 # Specific board support
 obj-$(CONFIG_SA1100_ASSABET)		+= assabet.o
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 022e451..3fdc16b 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -20,6 +20,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
+#include <linux/irqchip/irq-sa11x0.h>
 
 #include <video/sa1100fb.h>
 
@@ -375,6 +376,18 @@ void __init sa1100_timer_init(void)
 	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x90000000), 3686400);
 }
 
+static struct resource irq_resource =
+	DEFINE_RES_MEM_NAMED(0x90050000, SZ_64K, "irqs");
+
+void __init sa1100_init_irq(void)
+{
+	request_resource(&iomem_resource, &irq_resource);
+
+	sa11x0_init_irq_nodt(IRQ_GPIO0_SC, irq_resource.start);
+
+	sa1100_init_gpio();
+}
+
 /*
  * Disable the memory bus request/grant signals on the SA1110 to
  * ensure that we don't receive spurious memory requests.  We set
diff --git a/arch/arm/mach-sa1100/irq.c b/arch/arm/mach-sa1100/irq.c
deleted file mode 100644
index 66464fd..0000000
--- a/arch/arm/mach-sa1100/irq.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/irq.c
- *
- * Copyright (C) 1999-2001 Nicolas Pitre
- *
- * Generic IRQ handling for the SA11x0, GPIO 11-27 IRQ demultiplexing.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/ioport.h>
-#include <linux/syscore_ops.h>
-
-#include <mach/irqs.h>
-#include <asm/exception.h>
-
-#include "generic.h"
-
-#define ICIP	0x00  /* IC IRQ Pending reg. */
-#define ICMR	0x04  /* IC Mask Reg.        */
-#define ICLR	0x08  /* IC Level Reg.       */
-#define ICCR	0x0C  /* IC Control Reg.     */
-#define ICFP	0x10  /* IC FIQ Pending reg. */
-#define ICPR	0x20  /* IC Pending Reg.     */
-
-static void __iomem *iobase;
-static DEFINE_RAW_SPINLOCK(lock);
-
-/*
- * We don't need to ACK IRQs on the SA1100 unless they're GPIOs
- * this is for internal IRQs i.e. from IRQ LCD to RTCAlrm.
- */
-static void sa1100_mask_irq(struct irq_data *d)
-{
-	u32 reg;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&lock, flags);
-
-	reg = readl_relaxed(iobase + ICMR);
-	reg &= ~BIT(d->hwirq);
-	writel_relaxed(reg, iobase + ICMR);
-
-	raw_spin_unlock_irqrestore(&lock, flags);
-}
-
-static void sa1100_unmask_irq(struct irq_data *d)
-{
-	u32 reg;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&lock, flags);
-
-	reg = readl_relaxed(iobase + ICMR);
-	reg |= BIT(d->hwirq);
-	writel_relaxed(reg, iobase + ICMR);
-
-	raw_spin_unlock_irqrestore(&lock, flags);
-}
-
-static int sa1100_set_wake(struct irq_data *d, unsigned int on)
-{
-	return sa11x0_sc_set_wake(d->hwirq, on);
-}
-
-static struct irq_chip sa1100_normal_chip = {
-	.name		= "SC",
-	.irq_ack	= sa1100_mask_irq,
-	.irq_mask	= sa1100_mask_irq,
-	.irq_unmask	= sa1100_unmask_irq,
-	.irq_set_wake	= sa1100_set_wake,
-};
-
-static int sa1100_normal_irqdomain_map(struct irq_domain *d,
-		unsigned int irq, irq_hw_number_t hwirq)
-{
-	irq_set_chip_and_handler(irq, &sa1100_normal_chip,
-				 handle_level_irq);
-	set_irq_flags(irq, IRQF_VALID);
-
-	return 0;
-}
-
-static struct irq_domain_ops sa1100_normal_irqdomain_ops = {
-	.map = sa1100_normal_irqdomain_map,
-	.xlate = irq_domain_xlate_onetwocell,
-};
-
-static struct irq_domain *sa1100_normal_irqdomain;
-
-static struct resource irq_resource =
-	DEFINE_RES_MEM_NAMED(0x90050000, SZ_64K, "irqs");
-
-static struct sa1100irq_state {
-	unsigned int	saved;
-	unsigned int	icmr;
-	unsigned int	iclr;
-	unsigned int	iccr;
-} sa1100irq_state;
-
-static int sa1100irq_suspend(void)
-{
-	struct sa1100irq_state *st = &sa1100irq_state;
-
-	st->saved = 1;
-	st->icmr = readl_relaxed(iobase + ICMR);
-	st->iclr = readl_relaxed(iobase + ICLR);
-	st->iccr = readl_relaxed(iobase + ICCR);
-
-	/*
-	 * Disable all GPIO-based interrupts.
-	 */
-	writel_relaxed(st->icmr & 0xfffff000, iobase + ICMR);
-
-	return 0;
-}
-
-static void sa1100irq_resume(void)
-{
-	struct sa1100irq_state *st = &sa1100irq_state;
-
-	if (st->saved) {
-		writel_relaxed(st->iccr, iobase + ICCR);
-		writel_relaxed(st->iclr, iobase + ICLR);
-
-		writel_relaxed(st->icmr, iobase + ICMR);
-	}
-}
-
-static struct syscore_ops sa1100irq_syscore_ops = {
-	.suspend	= sa1100irq_suspend,
-	.resume		= sa1100irq_resume,
-};
-
-static int __init sa1100irq_init_devicefs(void)
-{
-	register_syscore_ops(&sa1100irq_syscore_ops);
-	return 0;
-}
-
-device_initcall(sa1100irq_init_devicefs);
-
-static asmlinkage void __exception_irq_entry
-sa1100_handle_irq(struct pt_regs *regs)
-{
-	uint32_t icip, icmr, mask;
-
-	do {
-		icip = readl_relaxed(iobase + ICIP);
-		icmr = readl_relaxed(iobase + ICMR);
-		mask = icip & icmr;
-
-		if (mask == 0)
-			break;
-
-		handle_domain_irq(sa1100_normal_irqdomain,
-				ffs(mask) - 1, regs);
-	} while (1);
-}
-
-void __init sa1100_init_irq(void)
-{
-	request_resource(&iomem_resource, &irq_resource);
-
-	iobase = ioremap(irq_resource.start, SZ_64K);
-	if (WARN_ON(!iobase))
-		return;
-
-	/* disable all IRQs */
-	writel_relaxed(0, iobase + ICMR);
-
-	/* all IRQs are IRQ, not FIQ */
-	writel_relaxed(0, iobase + ICLR);
-
-	/*
-	 * Whatever the doc says, this has to be set for the wait-on-irq
-	 * instruction to work... on a SA1100 rev 9 at least.
-	 */
-	writel_relaxed(1, iobase + ICCR);
-
-	sa1100_normal_irqdomain = irq_domain_add_simple(NULL,
-			32, IRQ_GPIO0_SC,
-			&sa1100_normal_irqdomain_ops, NULL);
-
-	set_handle_irq(sa1100_handle_irq);
-
-	sa1100_init_gpio();
-}
-- 
2.1.4

