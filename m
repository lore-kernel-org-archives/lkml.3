Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaBOAzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:55:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:45560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaBOAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:55:14 -0500
Message-Id: <20140215003823.653236081@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sat, 15 Feb 2014 00:55:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/2] genirq: Provide synchronize_hardirq()
References: <20140215002742.507053194@linutronix.de>
Content-Disposition: inline; filename=genirq-synchronize-hardirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_irq() waits for hard irq and threaded handlers to complete
before returning. For some special cases we only need to make sure
that the hard interrupt part of the irq line is not in progress when
we disabled the - possibly shared - interrupt at the device level.

A proper use case for this was provided by Russell. The sdhci driver
requires some irq triggered functions to be run in thread context. The
current implementation of the thread context is a sdio private kthread
construct, which has quite some shortcomings. These can be avoided
when the thread is directly associated to the device interrupt via the
generic threaded irq infrastructure.

Though there is a corner case related to run time power management
where one side disables the device interrupts at the device level and
needs to make sure, that an already running hard interrupt handler has
completed before proceeding further. Though that hard interrupt
handler might wake the associated thread, which in turn can request
the runtime PM to reenable the device. Using synchronize_irq() leads
to an immediate deadlock of the irq thread waiting for the PM lock and
the synchronize_irq() waiting for the irq thread to complete.

Due to the fact that it is sufficient for this case to ensure that no
hard irq handler is executing a new function which avoids the check
for the thread is required.

Add a function, which just monitors the hard irq parts and ignores the
threaded handlers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hardirq.h |    1 
 kernel/irq/manage.c     |   67 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 48 insertions(+), 20 deletions(-)

Index: linux-2.6/include/linux/hardirq.h
===================================================================
--- linux-2.6.orig/include/linux/hardirq.h
+++ linux-2.6/include/linux/hardirq.h
@@ -9,6 +9,7 @@
 
 
 extern void synchronize_irq(unsigned int irq);
+extern void synchronize_hardirq(unsigned int irq);
 
 #if defined(CONFIG_TINY_RCU)
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -32,24 +32,10 @@ static int __init setup_forced_irqthread
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
-/**
- *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
- *	@irq: interrupt number to wait for
- *
- *	This function waits for any pending IRQ handlers for this interrupt
- *	to complete before returning. If you use this function while
- *	holding a resource the IRQ handler may need you will deadlock.
- *
- *	This function may be called - with care - from IRQ context.
- */
-void synchronize_irq(unsigned int irq)
+static void __synchronize_hardirq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	bool inprogress;
 
-	if (!desc)
-		return;
-
 	do {
 		unsigned long flags;
 
@@ -67,12 +53,53 @@ void synchronize_irq(unsigned int irq)
 
 		/* Oops, that failed? */
 	} while (inprogress);
+}
 
-	/*
-	 * We made sure that no hardirq handler is running. Now verify
-	 * that no threaded handlers are active.
-	 */
-	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
+/**
+ *	synchronize_hardirq - wait for pending hard IRQ handlers (on other CPUs)
+ *	@irq: interrupt number to wait for
+ *
+ *	This function waits for any pending hard IRQ handlers for this
+ *	interrupt to complete before returning. If you use this
+ *	function while holding a resource the IRQ handler may need you
+ *	will deadlock. It does not take associated threaded handlers into
+ *	account.
+ *
+ *	This function may be called - with care - from IRQ context.
+ */
+void synchronize_hardirq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc)
+		__synchronize_hardirq(desc);
+}
+EXPORT_SYMBOL(synchronize_hardirq);
+
+/**
+ *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
+ *	@irq: interrupt number to wait for
+ *
+ *	This function waits for any pending IRQ handlers for this interrupt
+ *	to complete before returning. If you use this function while
+ *	holding a resource the IRQ handler may need you will deadlock.
+ *
+ *	This function may be called - with care - from IRQ context.
+ */
+void synchronize_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc) {
+		__synchronize_hardirq(desc);
+		/*
+		 * We made sure that no hardirq handler is
+		 * running. Now verify that no threaded handlers are
+		 * active.
+		 */
+		wait_event(desc->wait_for_threads,
+			   !atomic_read(&desc->threads_active));
+	}
 }
 EXPORT_SYMBOL(synchronize_irq);
 


