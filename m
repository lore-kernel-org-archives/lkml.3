Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaJFKWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:22:54 -0400
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:36574 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbaJFKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:22:53 -0400
Date: Mon, 6 Oct 2014 05:22:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410060959510.4383@nanos>
Message-ID: <alpine.DEB.2.11.1410060521010.27574@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos> <alpine.DEB.2.11.1410051824190.3424@gentwo.org> <alpine.DEB.2.11.1410060959510.4383@nanos>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Increase irq counters to 64 bit V3

V2->V3
  - Remove useless counter changes
  - Track use cases for kstat_irq_cpu
  - Verify it works on 32 bit.

V1->V2
  - Wrong size at percpu alloc.
  - Use u64 so that this will also work on 32 bit machines

Irq counters can overflow easily if they are just 32 bit.

For example the timer interrupt occurs 1000 times per second, so
it is predictable that the timer interrupt will overflow in


2^ 32 / 1000 [interrupts per second] / 86400 [seconds in a day]

which results in approximately 50 days.

Other irq counters for devices may wrap even faster for example
those for high speed networking devices.

This patch is needed to avoid the counter overflow by increasing
the counters to 64 bit.

Signed-off-by: Christoph Lameter <cl@linux.com>

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
@@ -450,7 +450,7 @@ int show_interrupts(struct seq_file *p,

 	seq_printf(p, "%*d: ", prec, i);
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+		seq_printf(p, "%10llu ", kstat_irqs_cpu(i, j));

 	if (desc->irq_data.chip) {
 		if (desc->irq_data.chip->irq_print_chip)
Index: linux/arch/m68k/sun3/sun3ints.c
===================================================================
--- linux.orig/arch/m68k/sun3/sun3ints.c
+++ linux/arch/m68k/sun3/sun3ints.c
@@ -51,7 +51,7 @@ void sun3_disable_irq(unsigned int irq)

 static irqreturn_t sun3_int7(int irq, void *dev_id)
 {
-	unsigned int cnt;
+	u64 cnt;

 	cnt = kstat_irqs_cpu(irq, 0);
 	if (!(cnt % 2000))
Index: linux/arch/parisc/kernel/irq.c
===================================================================
--- linux.orig/arch/parisc/kernel/irq.c
+++ linux/arch/parisc/kernel/irq.c
@@ -222,7 +222,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10llu ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
Index: linux/arch/s390/kernel/irq.c
===================================================================
--- linux.orig/arch/s390/kernel/irq.c
+++ linux/arch/s390/kernel/irq.c
@@ -136,7 +136,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%s: ", irqclass_main_desc[index].name);
 		irq = irqclass_main_desc[index].irq;
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, cpu));
+			seq_printf(p, "%10llu ", kstat_irqs_cpu(irq, cpu));
 		seq_putc(p, '\n');
 		goto out;
 	}
