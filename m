Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbaCDQoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:44:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaCDQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:44:16 -0500
Date: Tue, 4 Mar 2014 08:43:45 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b58d971da3433654787a88c40c6fca00f5bbaa04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, chris@zankel.net, tglx@linutronix.de,
        linux-xtensa@linux-xtensa.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, chris@zankel.net,
        linux-xtensa@linux-xtensa.org
In-Reply-To: <20140223212736.664624945@linutronix.de>
References: <20140223212736.664624945@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xtensa:
  Use irq_set_affinity instead of homebrewn code
Git-Commit-ID: b58d971da3433654787a88c40c6fca00f5bbaa04
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

Commit-ID:  b58d971da3433654787a88c40c6fca00f5bbaa04
Gitweb:     http://git.kernel.org/tip/b58d971da3433654787a88c40c6fca00f5bbaa04
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:55 +0100

xtensa: Use irq_set_affinity instead of homebrewn code

There is no point in having an incomplete copy of irq_set_affinity()
for the hotplug irq migration code.

Use the core function instead and while at it switch to
for_each_active_irq()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: xtensa <linux-xtensa@linux-xtensa.org>
Link: http://lkml.kernel.org/r/20140223212736.664624945@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/kernel/irq.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 482868a..3eee94f 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -155,18 +155,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (chip->irq_set_affinity)
-		chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -175,10 +163,9 @@ static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
 void migrate_irqs(void)
 {
 	unsigned int i, cpu = smp_processor_id();
-	struct irq_desc *desc;
 
-	for_each_irq_desc(i, desc) {
-		struct irq_data *data = irq_desc_get_irq_data(desc);
+	for_each_active_irq(i) {
+		struct irq_data *data = irq_get_irq_data(i);
 		unsigned int newcpu;
 
 		if (irqd_is_per_cpu(data))
@@ -194,11 +181,8 @@ void migrate_irqs(void)
 					    i, cpu);
 
 			cpumask_setall(data->affinity);
-			newcpu = cpumask_any_and(data->affinity,
-						 cpu_online_mask);
 		}
-
-		route_irq(data, i, newcpu);
+		irq_set_affinity(i, data->affinity);
 	}
 }
 #endif /* CONFIG_HOTPLUG_CPU */
