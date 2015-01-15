Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbbAOKKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:10:07 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53443 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbAOKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:09:59 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: sa1100: use ioremapped memory to access SC registers
Date: Thu, 15 Jan 2015 13:09:32 +0300
Message-Id: <1421316574-10022-3-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ioremap() and readl/writel_relaxed() to access IRQ controller
registers.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-sa1100/irq.c | 63 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-sa1100/irq.c b/arch/arm/mach-sa1100/irq.c
index 7a5aa56..66464fd 100644
--- a/arch/arm/mach-sa1100/irq.c
+++ b/arch/arm/mach-sa1100/irq.c
@@ -18,13 +18,20 @@
 #include <linux/ioport.h>
 #include <linux/syscore_ops.h>
 
-#include <mach/hardware.h>
 #include <mach/irqs.h>
-#include <asm/mach/irq.h>
 #include <asm/exception.h>
 
 #include "generic.h"
 
+#define ICIP	0x00  /* IC IRQ Pending reg. */
+#define ICMR	0x04  /* IC Mask Reg.        */
+#define ICLR	0x08  /* IC Level Reg.       */
+#define ICCR	0x0C  /* IC Control Reg.     */
+#define ICFP	0x10  /* IC FIQ Pending reg. */
+#define ICPR	0x20  /* IC Pending Reg.     */
+
+static void __iomem *iobase;
+static DEFINE_RAW_SPINLOCK(lock);
 
 /*
  * We don't need to ACK IRQs on the SA1100 unless they're GPIOs
@@ -32,12 +39,30 @@
  */
 static void sa1100_mask_irq(struct irq_data *d)
 {
-	ICMR &= ~BIT(d->hwirq);
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
 }
 
 static void sa1100_unmask_irq(struct irq_data *d)
 {
-	ICMR |= BIT(d->hwirq);
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
 }
 
 static int sa1100_set_wake(struct irq_data *d, unsigned int on)
@@ -85,16 +110,14 @@ static int sa1100irq_suspend(void)
 	struct sa1100irq_state *st = &sa1100irq_state;
 
 	st->saved = 1;
-	st->icmr = ICMR;
-	st->iclr = ICLR;
-	st->iccr = ICCR;
+	st->icmr = readl_relaxed(iobase + ICMR);
+	st->iclr = readl_relaxed(iobase + ICLR);
+	st->iccr = readl_relaxed(iobase + ICCR);
 
 	/*
 	 * Disable all GPIO-based interrupts.
 	 */
-	ICMR &= ~(IC_GPIO11_27|IC_GPIO10|IC_GPIO9|IC_GPIO8|IC_GPIO7|
-		  IC_GPIO6|IC_GPIO5|IC_GPIO4|IC_GPIO3|IC_GPIO2|
-		  IC_GPIO1|IC_GPIO0);
+	writel_relaxed(st->icmr & 0xfffff000, iobase + ICMR);
 
 	return 0;
 }
@@ -104,10 +127,10 @@ static void sa1100irq_resume(void)
 	struct sa1100irq_state *st = &sa1100irq_state;
 
 	if (st->saved) {
-		ICCR = st->iccr;
-		ICLR = st->iclr;
+		writel_relaxed(st->iccr, iobase + ICCR);
+		writel_relaxed(st->iclr, iobase + ICLR);
 
-		ICMR = st->icmr;
+		writel_relaxed(st->icmr, iobase + ICMR);
 	}
 }
 
@@ -130,8 +153,8 @@ sa1100_handle_irq(struct pt_regs *regs)
 	uint32_t icip, icmr, mask;
 
 	do {
-		icip = (ICIP);
-		icmr = (ICMR);
+		icip = readl_relaxed(iobase + ICIP);
+		icmr = readl_relaxed(iobase + ICMR);
 		mask = icip & icmr;
 
 		if (mask == 0)
@@ -146,17 +169,21 @@ void __init sa1100_init_irq(void)
 {
 	request_resource(&iomem_resource, &irq_resource);
 
+	iobase = ioremap(irq_resource.start, SZ_64K);
+	if (WARN_ON(!iobase))
+		return;
+
 	/* disable all IRQs */
-	ICMR = 0;
+	writel_relaxed(0, iobase + ICMR);
 
 	/* all IRQs are IRQ, not FIQ */
-	ICLR = 0;
+	writel_relaxed(0, iobase + ICLR);
 
 	/*
 	 * Whatever the doc says, this has to be set for the wait-on-irq
 	 * instruction to work... on a SA1100 rev 9 at least.
 	 */
-	ICCR = 1;
+	writel_relaxed(1, iobase + ICCR);
 
 	sa1100_normal_irqdomain = irq_domain_add_simple(NULL,
 			32, IRQ_GPIO0_SC,
-- 
2.1.4

