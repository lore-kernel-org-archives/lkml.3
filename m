Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaCDQoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:44:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaCDQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:43:59 -0500
Date: Tue, 4 Mar 2014 08:43:21 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-6decf1a33c386d4addc2ed9d269c3868f08c70bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, lethal@linux-sh.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        lethal@linux-sh.org
In-Reply-To: <20140223212736.774961401@linutronix.de>
References: <20140223212736.774961401@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] sh: Use irq_set_affinity instead of homebrewn code
Git-Commit-ID: 6decf1a33c386d4addc2ed9d269c3868f08c70bb
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

Commit-ID:  6decf1a33c386d4addc2ed9d269c3868f08c70bb
Gitweb:     http://git.kernel.org/tip/6decf1a33c386d4addc2ed9d269c3868f08c70bb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:55 +0100

sh: Use irq_set_affinity instead of homebrewn code

There is no point in having an incomplete copy of irq_set_affinity()
for the hotplug irq migration code.

Use the core function instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: sh <linux-sh@vger.kernel.org>
Link: http://lkml.kernel.org/r/20140223212736.774961401@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/sh/kernel/irq.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 0833736..65a1ecd 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -217,19 +217,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-
-	printk(KERN_INFO "IRQ%u: moving from cpu%u to cpu%u\n",
-	       irq, data->node, cpu);
-
-	raw_spin_lock_irq(&desc->lock);
-	chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irq(&desc->lock);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -250,11 +237,8 @@ void migrate_irqs(void)
 						    irq, cpu);
 
 				cpumask_setall(data->affinity);
-				newcpu = cpumask_any_and(data->affinity,
-							 cpu_online_mask);
 			}
-
-			route_irq(data, irq, newcpu);
+			irq_set_affinity(irq, data->affinity);
 		}
 	}
 }
