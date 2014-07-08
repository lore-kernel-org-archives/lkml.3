Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaGHNpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:45:51 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:58178 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbaGHNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:45:49 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH v2 02/15] ARM: pass IRQ domain to the core IRQ handler
Date: Tue,  8 Jul 2014 14:45:40 +0100
Message-Id: <1404827141-30381-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 176.25.195.83
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com, khilman@linaro.org, daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling irq_find_mapping from outside a irq_{enter,exit} section is
unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
If coming from the idle state, the rcu_read_lock call in irq_find_mapping
will generate an an unpleasant warning.

A solution is to add a new handle_domain_irq entry point into
the arm code that the interrupt controller code can call.
This new function takes an irq_domain, and calls into irq_find_domain
inside the irq_{enter,exit} block.

Interrupt controllers can then be updated to use the new mechanism.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Sending the right patch this time, with the missing includes that would
otherwise break the build...

 arch/arm/include/asm/irq.h |  2 ++
 arch/arm/kernel/irq.c      | 25 +++++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/irq.h b/arch/arm/include/asm/irq.h
index 53c15de..8578811 100644
--- a/arch/arm/include/asm/irq.h
+++ b/arch/arm/include/asm/irq.h
@@ -24,10 +24,12 @@
 #ifndef __ASSEMBLY__
 struct irqaction;
 struct pt_regs;
+struct irq_domain;
 extern void migrate_irqs(void);
 
 extern void asm_do_IRQ(unsigned int, struct pt_regs *);
 void handle_IRQ(unsigned int, struct pt_regs *);
+void handle_domain_irq(struct irq_domain *, unsigned int, struct pt_regs *);
 void init_IRQ(void);
 
 #ifdef CONFIG_MULTI_IRQ_HANDLER
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 2c42576..a9e37434 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -27,7 +27,9 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqchip.h>
+#include <linux/irqdomain.h>
 #include <linux/random.h>
+#include <linux/ratelimit.h>
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
@@ -62,20 +64,30 @@ int arch_show_interrupts(struct seq_file *p, int prec)
  * not come via this function.  Instead, they should provide their
  * own 'handler'.  Used by platform code implementing C-based 1st
  * level decoding.
+ *
+ * handle_domain_irq does the same thing, but also converts the HW
+ * interrupt number into a logical one using the provided domain. A
+ * NULL domain indicates that this conversion has already been done.
  */
-void handle_IRQ(unsigned int irq, struct pt_regs *regs)
+void handle_domain_irq(struct irq_domain *domain,
+		       unsigned int hwirq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
+	unsigned int irq;
 
 	irq_enter();
 
+	if (domain)
+		irq = irq_find_mapping(domain, hwirq);
+	else
+		irq = hwirq;
+
 	/*
 	 * Some hardware gives randomly wrong interrupts.  Rather
 	 * than crashing, do something sensible.
 	 */
-	if (unlikely(irq >= nr_irqs)) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING "Bad IRQ%u\n", irq);
+	if (unlikely(!irq || irq >= nr_irqs)) {
+		pr_warn_ratelimited("Bad IRQ%u (%u)\n", irq, hwirq);
 		ack_bad_irq(irq);
 	} else {
 		generic_handle_irq(irq);
@@ -85,6 +97,11 @@ void handle_IRQ(unsigned int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+void handle_IRQ(unsigned int irq, struct pt_regs *regs)
+{
+	handle_domain_irq(NULL, irq, regs);
+}
+
 /*
  * asm_do_IRQ is the interface to be used from assembly code.
  */
-- 
2.0.0

