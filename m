Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaALSon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:44:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaALSoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:44:38 -0500
Date: Sun, 12 Jan 2014 10:44:19 -0800
From: tip-bot for Prarit Bhargava <tipbot@zytor.com>
Message-ID: <tip-9345005f4eed805308193658d12e4e7e9c261e74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rui.y.wang@intel.com, seiji.aguchi@hds.com, yang.z.zhang@intel.com,
        tglx@linutronix.de, prarit@redhat.com, walken@google.com,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rui.y.wang@intel.com, seiji.aguchi@hds.com, yang.z.zhang@intel.com,
        tglx@linutronix.de, walken@google.com, prarit@redhat.com,
        paul.gortmaker@windriver.com
In-Reply-To: <1388938252-16627-1-git-send-email-prarit@redhat.com>
References: <1388938252-16627-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86/irq: Fix do_IRQ()
  interrupt warning for cpu hotplug retriggered irqs
Git-Commit-ID: 9345005f4eed805308193658d12e4e7e9c261e74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:44:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9345005f4eed805308193658d12e4e7e9c261e74
Gitweb:     http://git.kernel.org/tip/9345005f4eed805308193658d12e4e7e9c261e74
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Sun, 5 Jan 2014 11:10:52 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 13:13:02 +0100

x86/irq: Fix do_IRQ() interrupt warning for cpu hotplug retriggered irqs

During heavy CPU-hotplug operations the following spurious kernel warnings
can trigger:

  do_IRQ: No ... irq handler for vector (irq -1)

  [ See: https://bugzilla.kernel.org/show_bug.cgi?id=64831 ]

When downing a cpu it is possible that there are unhandled irqs
left in the APIC IRR register.  The following code path shows
how the problem can occur:

 1. CPU 5 is to go down.

 2. cpu_disable() on CPU 5 executes with interrupt flag cleared
    by local_irq_save() via stop_machine().

 3. IRQ 12 asserts on CPU 5, setting IRR but not ISR because
    interrupt flag is cleared (CPU unabled to handle the irq)

 4. IRQs are migrated off of CPU 5, and the vectors' irqs are set
    to -1. 5. stop_machine() finishes cpu_disable()

 6. cpu_die() for CPU 5 executes in normal context.

 7. CPU 5 attempts to handle IRQ 12 because the IRR is set for
    IRQ 12.  The code attempts to find the vector's IRQ and cannot
    because it has been set to -1. 8. do_IRQ() warning displays
    warning about CPU 5 IRQ 12.

I added a debug printk to output which CPU & vector was
retriggered and discovered that that we are getting bogus
events.  I see a 100% correlation between this debug printk in
fixup_irqs() and the do_IRQ() warning.

This patchset resolves this by adding definitions for
VECTOR_UNDEFINED(-1) and VECTOR_RETRIGGERED(-2) and modifying
the code to use them.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=64831
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Reviewed-by: Rui Wang <rui.y.wang@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: janet.morgan@Intel.com
Cc: tony.luck@Intel.com
Cc: ruiv.wang@gmail.com
Link: http://lkml.kernel.org/r/1388938252-16627-1-git-send-email-prarit@redhat.com
[ Cleaned up the code a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/hw_irq.h  |  3 +++
 arch/x86/kernel/apic/io_apic.c | 18 +++++++++---------
 arch/x86/kernel/irq.c          | 19 +++++++++++++------
 arch/x86/kernel/irqinit.c      |  4 ++--
 4 files changed, 27 insertions(+), 17 deletions(-)

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
index e63a5bd..6df0b66 100644
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
@@ -2208,7 +2208,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
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
 
