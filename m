Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3KRKk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:40:28 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:29515 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3KRKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:40:20 -0500
From: Warner Wang <warner.wang@hp.com>
To: tglx@linutronix.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Cc: Warner Wang <warner.wang@hp.com>
Subject: [RFC][PATCH] irq: restrict the numbers of misrouted interrupt (per second).
Date: Sat, 19 Oct 2013 18:33:50 +0800
Message-Id: <1382178830-19727-1-git-send-email-warner.wang@hp.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original spurious.c already provides the functionality of
detect & disable screaming interrupts.  But under some situation
the code won't work.  When irq_poll is on and the system has some
ISRs that don’t do sanity check and return IRQ_NONE.  This will
come into a loop:  device A is screaming, keeps generates large
amount of interrupts,  while device B's ISR keep being executed by
misrouted irq code (because B's ISR have problem and won't return
as IRQ_NONE.  In this situation the original code to detect the
screaming interrupts will not have a chance to be called.  And the
system performance will be very poor.

This RFC patch tries to solve this problem, by adding a counter for
maximum misrouted interrupts we should handle per second.  And if
we reached the maximum number we simply skip the misrounted irq.

This patch is based on tag v3.12, please give comments on it, all
kinds of comments are welcome.

Signed-off-by: Warner Wang <warner.wang@hp.com>
---
 include/linux/irqdesc.h |    1 +
 kernel/irq/irqdesc.c    |    1 +
 kernel/irq/manage.c     |    1 +
 kernel/irq/spurious.c   |   14 +++++++++++---
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 56fb646..1b777e3 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -52,6 +52,7 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
+	unsigned int		handled_in_jiff;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..0fcbb55 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -86,6 +86,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	desc->depth = 1;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
+	desc->handled_in_jiff = 0;
 	desc->name = NULL;
 	desc->owner = owner;
 	for_each_possible_cpu(cpu)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..31b2cb0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1146,6 +1146,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
+	desc->handled_in_jiff = 0;
 
 	/*
 	 * Check whether we disabled the irq via the spurious handler
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 7b5f012..817d5a8 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -265,6 +265,7 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
+static int irq_in_sec = 5000;
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
@@ -295,9 +296,16 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	}
 
 	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
-		int ok = misrouted_irq(irq);
-		if (action_ret == IRQ_NONE)
-			desc->irqs_unhandled -= ok;
+		if (desc->handled_in_jiff < (irq_in_sec / HZ)) {
+			int ok = misrouted_irq(irq);
+			if (action_ret == IRQ_NONE) {
+				desc->irqs_unhandled -= ok;
+				if (time_after_eq(desc->last_unhandled, jiffies))
+					desc->handled_in_jiff++;
+				else
+					desc->handled_in_jiff = 0;
+			}
+		}
 	}
 
 	desc->irq_count++;
-- 
1.7.1

