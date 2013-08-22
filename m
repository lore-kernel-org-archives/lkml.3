Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3HVH4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:56:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60370 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3HVH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:56:13 -0400
Message-ID: <5215C415.60108@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:56:05 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/11] sched/cleanup: remove the extra parm of irq_set_thread_affinity()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082218-3568-0000-0000-0000041F069C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'force' has been ignored, and currently no one need a 'true' option, so
remove it to make code clean.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/irq/internals.h |    2 +-
 kernel/irq/manage.c    |    7 +++----
 kernel/irq/migration.c |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..c5b4085 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -102,7 +102,7 @@ extern int irq_select_affinity_usr(unsigned int irq, struct cpumask *mask);
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 extern int irq_do_set_affinity(struct irq_data *data,
-			       const struct cpumask *dest, bool force);
+			       const struct cpumask *dest);
 
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46941e7..9a71ba5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -143,8 +143,7 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
-int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			bool force)
+int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_data_to_desc(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
@@ -172,7 +171,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -323,7 +322,7 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 		if (cpumask_intersects(mask, nodemask))
 			cpumask_and(mask, mask, nodemask);
 	}
-	irq_do_set_affinity(&desc->irq_data, mask, false);
+	irq_do_set_affinity(&desc->irq_data, mask);
 	return 0;
 }
 #else
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index ca3f4aa..4790949 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,7 +43,7 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * masking the irqs.
 	 */
 	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids)
-		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
+		irq_do_set_affinity(&desc->irq_data, desc->pending_mask);
 
 	cpumask_clear(desc->pending_mask);
 }
-- 
1.7.9.5

