Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3HUIJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:09:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3HUIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:08:46 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] irq_work: Provide a irq work that can be processed on any cpu
Date: Wed, 21 Aug 2013 10:08:30 +0200
Message-Id: <1377072512-7986-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377072512-7986-1-git-send-email-jack@suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide new irq work flag - IRQ_WORK_UNBOUND - meaning that can be
processed on any cpu. This flag implies IRQ_WORK_LAZY so that things are
simple and we don't have to pick any particular cpu to do the work. We
just do the work from a timer tick on whichever cpu it happens first.
This is useful as a lightweight and simple code path without locking or
other dependencies to offload work to other cpu if possible.

We will use this type of irq work to make a guarantee of forward
progress of printing to a (serial) console when printing on one cpu
would cause interrupts to be disabled for too long.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/irq_work.h |  2 ++
 kernel/irq_work.c        | 51 +++++++++++++++++++++++++++++-------------------
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..ca07a16 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,6 +16,8 @@
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 #define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+#define __IRQ_WORK_UNBOUND      8UL /* Use IRQ_WORK_UNBOUND instead! */
+#define IRQ_WORK_UNBOUND	(__IRQ_WORK_UNBOUND | IRQ_WORK_LAZY) /* Any cpu can process this work */
 
 struct irq_work {
 	unsigned long flags;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 55fcce6..446cd81 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -22,6 +22,9 @@
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
 static DEFINE_PER_CPU(int, irq_work_raised);
 
+/* List of irq-work any CPU can pick up */
+static LLIST_HEAD(unbound_irq_work_list);
+
 /*
  * Claim the entry so that no one else will poke at it.
  */
@@ -70,12 +73,16 @@ void irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	if (!(work->flags & __IRQ_WORK_UNBOUND))
+		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	else
+		llist_add(&work->llnode, &unbound_irq_work_list);
 
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
 	 * work interrupt (if supported by the arch), otherwise, just wait
-	 * for the next tick.
+	 * for the next tick. We do this even for unbound work to make sure
+	 * *some* CPU will be doing the work.
 	 */
 	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
 		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
@@ -100,28 +107,11 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-static void __irq_work_run(void)
+static void process_irq_work_list(struct llist_node *llnode)
 {
 	unsigned long flags;
 	struct irq_work *work;
-	struct llist_head *this_list;
-	struct llist_node *llnode;
-
-
-	/*
-	 * Reset the "raised" state right before we check the list because
-	 * an NMI may enqueue after we find the list empty from the runner.
-	 */
-	__this_cpu_write(irq_work_raised, 0);
-	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
-		return;
-
-	BUG_ON(!irqs_disabled());
-
-	llnode = llist_del_all(this_list);
 	while (llnode != NULL) {
 		work = llist_entry(llnode, struct irq_work, llnode);
 
@@ -146,6 +136,27 @@ static void __irq_work_run(void)
 	}
 }
 
+static void __irq_work_run(void)
+{
+	struct llist_head *this_list;
+
+	/*
+	 * Reset the "raised" state right before we check the list because
+	 * an NMI may enqueue after we find the list empty from the runner.
+	 */
+	__this_cpu_write(irq_work_raised, 0);
+	barrier();
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list) && llist_empty(&unbound_irq_work_list))
+		return;
+
+	BUG_ON(!irqs_disabled());
+
+	process_irq_work_list(llist_del_all(this_list));
+	process_irq_work_list(llist_del_all(&unbound_irq_work_list));
+}
+
 /*
  * Run the irq_work entries on this cpu. Requires to be ran from hardirq
  * context with local IRQs disabled.
-- 
1.8.1.4

