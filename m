Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaBSQ3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:29:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaBSQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:29:10 -0500
Date: Wed, 19 Feb 2014 08:27:28 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-18258f7239a61d8929b8e0c7b6d46c446459074c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@arm.linux.org.uk, peterz@infradead.org, chris@printf.net,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, chris@printf.net, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140215003823.653236081@linutronix.de>
References: <20140215003823.653236081@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide synchronize_hardirq()
Git-Commit-ID: 18258f7239a61d8929b8e0c7b6d46c446459074c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18258f7239a61d8929b8e0c7b6d46c446459074c
Gitweb:     http://git.kernel.org/tip/18258f7239a61d8929b8e0c7b6d46c446459074c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 15 Feb 2014 00:55:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Feb 2014 17:22:44 +0100

genirq: Provide synchronize_hardirq()

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
Tested-by: Russell King <linux@arm.linux.org.uk>
Cc: Chris Ball <chris@printf.net>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140215003823.653236081@linutronix.de

---
 include/linux/hardirq.h |  1 +
 kernel/irq/manage.c     | 70 +++++++++++++++++++++++++++++++++++--------------
 2 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 12d5f97..cba442e 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -9,6 +9,7 @@
 
 
 extern void synchronize_irq(unsigned int irq);
+extern void synchronize_hardirq(unsigned int irq);
 
 #if defined(CONFIG_TINY_RCU)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..274ba92 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -32,24 +32,10 @@ static int __init setup_forced_irqthreads(char *arg)
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
 
@@ -67,12 +53,56 @@ void synchronize_irq(unsigned int irq)
 
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
+ *	will deadlock. It does not take associated threaded handlers
+ *	into account.
+ *
+ *	Do not use this for shutdown scenarios where you must be sure
+ *	that all parts (hardirq and threaded handler) have completed.
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
 
