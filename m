Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaATLu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:50:58 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35775 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaATLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:50:55 -0500
Date: Mon, 20 Jan 2014 12:50:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] IRQ changes for v3.14
Message-ID: <20140120115051.GA10283@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   # HEAD: c7a730fa4624092e2d1c0cb7b750816e87c32364 x86/irq: Fix kbuild warning in smp_irq_move_cleanup_interrupt()

The only change in this cycle is a CPU hotplug related spurious 
warning fix.

 Thanks,

	Ingo

------------------>
Prarit Bhargava (2):
      x86/irq: Fix do_IRQ() interrupt warning for cpu hotplug retriggered irqs
      x86/irq: Fix kbuild warning in smp_irq_move_cleanup_interrupt()


 arch/x86/include/asm/hw_irq.h  |  3 +++
 arch/x86/kernel/apic/io_apic.c | 20 ++++++++++----------
 arch/x86/kernel/irq.c          | 19 +++++++++++++------
 arch/x86/kernel/irqinit.c      |  4 ++--
 4 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index cba45d9..67d69b8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -191,6 +191,9 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 #define trace_interrupt interrupt
 #endif
 
+#define VECTOR_UNDEFINED	-1
+#define VECTOR_RETRIGGERED	-2
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 extern void setup_vector_irq(int cpu);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e63a5bd..a43f068 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1142,9 +1142,10 @@ next:
 		if (test_bit(vector, used_vectors))
 			goto next;
 
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
+			if (per_cpu(vector_irq, new_cpu)[vector] > VECTOR_UNDEFINED)
 				goto next;
+		}
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
@@ -1183,7 +1184,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	vector = cfg->vector;
 	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
-		per_cpu(vector_irq, cpu)[vector] = -1;
+		per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
 
 	cfg->vector = 0;
 	cpumask_clear(cfg->domain);
@@ -1191,11 +1192,10 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	if (likely(!cfg->move_in_progress))
 		return;
 	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-								vector++) {
+		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
 				continue;
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
 			break;
 		}
 	}
@@ -1228,12 +1228,12 @@ void __setup_vector_irq(int cpu)
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
 		irq = per_cpu(vector_irq, cpu)[vector];
-		if (irq < 0)
+		if (irq <= VECTOR_UNDEFINED)
 			continue;
 
 		cfg = irq_cfg(irq);
 		if (!cpumask_test_cpu(cpu, cfg->domain))
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
 	}
 	raw_spin_unlock(&vector_lock);
 }
@@ -2202,13 +2202,13 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
+		int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __this_cpu_read(vector_irq[vector]);
 
-		if (irq == -1)
+		if (irq <= VECTOR_UNDEFINED)
 			continue;
 
 		desc = irq_to_desc(irq);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 22d0687..884d875 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -193,9 +193,13 @@ __visible unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	if (!handle_irq(irq, regs)) {
 		ack_APIC_irq();
 
-		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
-				__func__, smp_processor_id(), vector, irq);
+		if (irq != VECTOR_RETRIGGERED) {
+			pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %d)\n",
+					     __func__, smp_processor_id(),
+					     vector, irq);
+		} else {
+			__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
+		}
 	}
 
 	irq_exit();
@@ -344,7 +348,7 @@ void fixup_irqs(void)
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irr;
 
-		if (__this_cpu_read(vector_irq[vector]) < 0)
+		if (__this_cpu_read(vector_irq[vector]) <= VECTOR_UNDEFINED)
 			continue;
 
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
@@ -355,11 +359,14 @@ void fixup_irqs(void)
 			data = irq_desc_get_irq_data(desc);
 			chip = irq_data_get_irq_chip(data);
 			raw_spin_lock(&desc->lock);
-			if (chip->irq_retrigger)
+			if (chip->irq_retrigger) {
 				chip->irq_retrigger(data);
+				__this_cpu_write(vector_irq[vector], VECTOR_RETRIGGERED);
+			}
 			raw_spin_unlock(&desc->lock);
 		}
-		__this_cpu_write(vector_irq[vector], -1);
+		if (__this_cpu_read(vector_irq[vector]) != VECTOR_RETRIGGERED)
+			__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
 	}
 }
 #endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index a2a1fbc..7f50156 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -52,7 +52,7 @@ static struct irqaction irq2 = {
 };
 
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... NR_VECTORS - 1] = -1,
+	[0 ... NR_VECTORS - 1] = VECTOR_UNDEFINED,
 };
 
 int vector_used_by_percpu_irq(unsigned int vector)
@@ -60,7 +60,7 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
+		if (per_cpu(vector_irq, cpu)[vector] > VECTOR_UNDEFINED)
 			return 1;
 	}
 
