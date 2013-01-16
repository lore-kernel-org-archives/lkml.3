Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3APP6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3APP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 020/222] genirq: Always force thread affinity
Date: Wed, 16 Jan 2013 13:53:40 -0200
Message-Id: <1358351822-7675-21-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 04aa530ec04f61875b99c12721162e2964e3318c upstream.

Sankara reported that the genirq core code fails to adjust the
affinity of an interrupt thread in several cases:

 1) On request/setup_irq() the call to setup_affinity() happens before
    the new action is registered, so the new thread is not notified.

 2) For secondary shared interrupts nothing notifies the new thread to
    change its affinity.

 3) Interrupts which have the IRQ_NO_BALANCE flag set are not moving
    the thread either.

Fix this by setting the thread affinity flag right on thread creation
time. This ensures that under all circumstances the thread moves to
the right place. Requires a check in irq_thread_check_affinity for an
existing affinity mask (CONFIG_CPU_MASK_OFFSTACK=y)

Reported-and-tested-by: Sankara Muthukrishnan <sankara.m@gmail.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1209041738200.2754@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/irq/manage.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5e42eb1..b4c6385 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -716,6 +716,7 @@ static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 {
 	cpumask_var_t mask;
+	bool valid = true;
 
 	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
 		return;
@@ -730,10 +731,18 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	}
 
 	raw_spin_lock_irq(&desc->lock);
-	cpumask_copy(mask, desc->irq_data.affinity);
+	/*
+	 * This code is triggered unconditionally. Check the affinity
+	 * mask pointer. For CPU_MASK_OFFSTACK=n this is optimized out.
+	 */
+	if (desc->irq_data.affinity)
+		cpumask_copy(mask, desc->irq_data.affinity);
+	else
+		valid = false;
 	raw_spin_unlock_irq(&desc->lock);
 
-	set_cpus_allowed_ptr(current, mask);
+	if (valid)
+		set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
 #else
@@ -936,6 +945,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
+		/*
+		 * Tell the thread to set its affinity. This is
+		 * important for shared interrupt handlers as we do
+		 * not invoke setup_affinity() for the secondary
+		 * handlers as everything is already set up. Even for
+		 * interrupts marked with IRQF_NO_BALANCE this is
+		 * correct as we want the thread to move to the cpu(s)
+		 * on which the requesting code placed the interrupt.
+		 */
+		set_bit(IRQTF_AFFINITY, &new->thread_flags);
 	}
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
-- 
1.7.9.5

