Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaBWVkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:52217 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaBWVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:04 -0500
Message-Id: <20140223212737.214342433@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        arm <linux-arm-kernel@lists.infradead.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 09/26] arm: mmp: Remove pointless fiddling with irq internals
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=arm-mmp-remove-idiotic-fiddling-with-irq-internals.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm-mmp2 and pm-pxa910 power management related irq_set_wake
callbacks fiddle pointlessly with the irq actions for no reason except
for lack of understanding how the wakeup mechanism works.

On supsend the core disables all interrupts lazily, i.e. it does not
mask them at the irq controller level. So any interrupt which is
firing during supsend will mark the corresponding interrupt line as
pending. Just before the core powers down it checks whether there are
interrupts pending from interrupt lines which are marked as wakeup
sources and if so it aborts the resume and resends the interrupts.

The IRQF_NO_SUSPEND flag for interrupt actions is a totally different
mechanism. That allows the device driver to prevent the core from
disabling the interrupt despite the fact that it is not marked as a
wakeup source. This has nothing to do with the case at hand. It was
introduced for special cases where lazy disable is not possible.

Remove the nonsense along with the braindamaged boundary check. The
core code does NOT call these functions out of boundary.

Add a FIXME comment to an unhandled error path which merily printks
some useless blurb instead of returning a proper error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: arm <linux-arm-kernel@lists.infradead.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-mmp/pm-mmp2.c   |   16 +---------------
 arch/arm/mach-mmp/pm-pxa910.c |   20 ++++----------------
 2 files changed, 5 insertions(+), 31 deletions(-)

Index: tip/arch/arm/mach-mmp/pm-mmp2.c
===================================================================
--- tip.orig/arch/arm/mach-mmp/pm-mmp2.c
+++ tip/arch/arm/mach-mmp/pm-mmp2.c
@@ -27,22 +27,8 @@
 
 int mmp2_set_wake(struct irq_data *d, unsigned int on)
 {
-	int irq = d->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long data = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = d->irq;
 
 	/* enable wakeup sources */
 	switch (irq) {
Index: tip/arch/arm/mach-mmp/pm-pxa910.c
===================================================================
--- tip.orig/arch/arm/mach-mmp/pm-pxa910.c
+++ tip/arch/arm/mach-mmp/pm-pxa910.c
@@ -27,22 +27,8 @@
 
 int pxa910_set_wake(struct irq_data *data, unsigned int on)
 {
-	int irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(data->irq);
 	uint32_t awucrm = 0, apcr = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = data->irq;
 
 	/* setting wakeup sources */
 	switch (irq) {
@@ -115,9 +101,11 @@ int pxa910_set_wake(struct irq_data *dat
 		if (irq >= IRQ_GPIO_START && irq < IRQ_BOARD_START) {
 			awucrm = MPMU_AWUCRM_WAKEUP(2);
 			apcr |= MPMU_APCR_SLPWP2;
-		} else
+		} else {
+			/* FIXME: This should return a proper error code ! */
 			printk(KERN_ERR "Error: no defined wake up source irq: %d\n",
 				irq);
+		}
 	}
 
 	if (on) {


