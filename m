Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3LBPFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:05:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:45145 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3LBPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:05:07 -0500
Date: Mon, 2 Dec 2013 16:05:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq fixes for 3.13
Message-ID: <alpine.DEB.2.02.1312021548220.30673@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

 * Correction of fuzzy and fragile IRQ_RETVAL macro
 * IRQ related resume fix affecting only XEN
 * ARM/GIC fix for chained GIC controllers

Thanks,

	tglx

------------------>
Geert Uytterhoeven (1):
      genirq: Correct fuzzy and fragile IRQ_RETVAL() definition

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Mark Rutland (1):
      irqchip: Gic: fix boot for chained gics


 drivers/irqchip/irq-gic.c |    9 +++++----
 include/linux/irqreturn.h |    2 +-
 kernel/irq/pm.c           |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d0e9480..e219a5bf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -814,12 +814,13 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	if (WARN_ON(!gic->domain))
 		return;
 
+	if (gic_nr == 0) {
 #ifdef CONFIG_SMP
-	set_smp_cross_call(gic_raise_softirq);
-	register_cpu_notifier(&gic_cpu_notifier);
+		set_smp_cross_call(gic_raise_softirq);
+		register_cpu_notifier(&gic_cpu_notifier);
 #endif
-
-	set_handle_irq(gic_handle_irq);
+		set_handle_irq(gic_handle_irq);
+	}
 
 	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 714ba08..e374e36 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -14,6 +14,6 @@ enum irqreturn {
 };
 
 typedef enum irqreturn irqreturn_t;
-#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
+#define IRQ_RETVAL(x)	((x) ? IRQ_HANDLED : IRQ_NONE)
 
 #endif
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..abcd6ca 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (is_early != want_early)
+		if (!is_early && want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
