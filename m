Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaJEXZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:25:08 -0400
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:50651 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaJEXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:25:00 -0400
Date: Sun, 5 Oct 2014 18:24:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410052331420.4383@nanos>
Message-ID: <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Increase irq counters to 64 bit V2

V1->V2
  - Wrong sie and percpu alloc.
  - Use u64 so that this will also work on 32 bit machines

Irq counters can overflow easily if they are just 32 bit.

For example the timer interrupt occurs 1000 times per second, so
it is predictable that the timer interrupt will overflow in


2^ 32 / 1000 [interrupts per second] / 86400 [seconds in a day]

which results in 46 days.

Other irq counters for devices may wrap even faster for example
those for high speed networking devices.

This patch is needed to avoid the counter overflow by increasing
the counters to 64 bit.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/processor.h
===================================================================
--- linux.orig/arch/x86/include/asm/processor.h
+++ linux/arch/x86/include/asm/processor.h
@@ -432,7 +432,7 @@ DECLARE_PER_CPU_FIRST(union irq_stack_un
 DECLARE_INIT_PER_CPU(irq_stack_union);

 DECLARE_PER_CPU(char *, irq_stack_ptr);
-DECLARE_PER_CPU(unsigned int, irq_count);
+DECLARE_PER_CPU(u64, irq_count);
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -1144,7 +1144,7 @@ EXPORT_PER_CPU_SYMBOL(current_task);
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;

-DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
+DEFINE_PER_CPU(u64, irq_count) __visible = -1;

 DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
 EXPORT_PER_CPU_SYMBOL(__preempt_count);
Index: linux/include/linux/irqdesc.h
===================================================================
--- linux.orig/include/linux/irqdesc.h
+++ linux/include/linux/irqdesc.h
@@ -41,7 +41,7 @@ struct irq_desc;
  */
 struct irq_desc {
 	struct irq_data		irq_data;
-	unsigned int __percpu	*kstat_irqs;
+	u64 __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
 	irq_preflow_handler_t	preflow_handler;
@@ -51,7 +51,7 @@ struct irq_desc {
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
-	unsigned int		irq_count;	/* For detecting broken IRQs */
+	u64			irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	atomic_t		threads_handled;
Index: linux/include/linux/kernel_stat.h
===================================================================
--- linux.orig/include/linux/kernel_stat.h
+++ linux/include/linux/kernel_stat.h
@@ -51,7 +51,7 @@ DECLARE_PER_CPU(struct kernel_cpustat, k

 extern unsigned long long nr_context_switches(void);

-extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+extern u64 kstat_irqs_cpu(unsigned int irq, int cpu);
 extern void kstat_incr_irq_this_cpu(unsigned int irq);

 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
Index: linux/kernel/irq/debug.h
===================================================================
--- linux.orig/kernel/irq/debug.h
+++ linux/kernel/irq/debug.h
@@ -11,7 +11,7 @@

 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
-	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
+	printk("irq %d, desc: %p, depth: %d, count: %llu, unhandled: %d\n",
 		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
Index: linux/kernel/irq/irqdesc.c
===================================================================
--- linux.orig/kernel/irq/irqdesc.c
+++ linux/kernel/irq/irqdesc.c
@@ -140,7 +140,7 @@ static struct irq_desc *alloc_desc(int i
 	if (!desc)
 		return NULL;
 	/* allocate based on nr_cpu_ids */
-	desc->kstat_irqs = alloc_percpu(unsigned int);
+	desc->kstat_irqs = alloc_percpu(u64);
 	if (!desc->kstat_irqs)
 		goto err_desc;

@@ -532,7 +532,7 @@ void kstat_incr_irq_this_cpu(unsigned in
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 }

-unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+u64 kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);

Index: linux/kernel/irq/proc.c
===================================================================
--- linux.orig/kernel/irq/proc.c
+++ linux/kernel/irq/proc.c
@@ -248,7 +248,7 @@ static int irq_spurious_proc_show(struct
 {
 	struct irq_desc *desc = irq_to_desc((long) m->private);

-	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
+	seq_printf(m, "count %llu\n" "unhandled %u\n" "last_unhandled %u ms\n",
 		   desc->irq_count, desc->irqs_unhandled,
 		   jiffies_to_msecs(desc->last_unhandled));
 	return 0;
@@ -450,7 +450,7 @@ int show_interrupts(struct seq_file *p,

 	seq_printf(p, "%*d: ", prec, i);
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+		seq_printf(p, "%10llu ", kstat_irqs_cpu(i, j));

 	if (desc->irq_data.chip) {
 		if (desc->irq_data.chip->irq_print_chip)
