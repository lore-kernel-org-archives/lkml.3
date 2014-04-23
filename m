Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbaDWUkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbaDWUkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:40:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2 v4] nmi: Provide the option to issue an NMI back trace to every cpu but current
Date: Wed, 23 Apr 2014 16:40:04 -0400
Message-Id: <1398285605-147082-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1398285605-147082-1-git-send-email-dzickus@redhat.com>
References: <1398285605-147082-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

Some times it is preferred not to use the
trigger_all_cpu_backtrace() routine when one wants
to avoid capturing a back trace for current.
For instance if one was previously captured
recently.

This patch provides a new routine namely
trigger_allbutself_cpu_backtrace() which offers
the flexibility to issue an NMI to every cpu but
current and capture a back trace accordingly.

Patched x86 and sparc to support new routine.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
[Added stub in #else clause]
[Don't print message in single processor case,
 wrap with get/put_cpu based on Oleg's suggestion]
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/sparc/include/asm/irq_64.h |    2 +-
 arch/sparc/kernel/process_64.c  |   14 +++++++++-----
 arch/x86/include/asm/irq.h      |    2 +-
 arch/x86/kernel/apic/hw_nmi.c   |   17 +++++++++++++----
 include/linux/nmi.h             |   11 ++++++++++-
 5 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/include/asm/irq_64.h b/arch/sparc/include/asm/irq_64.h
index abf6afe..4f072b9 100644
--- a/arch/sparc/include/asm/irq_64.h
+++ b/arch/sparc/include/asm/irq_64.h
@@ -89,7 +89,7 @@ static inline unsigned long get_softint(void)
 	return retval;
 }
 
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 32a280e..3d61b98 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -237,7 +237,7 @@ static void __global_reg_poll(struct global_reg_snapshot *gp)
 	}
 }
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -249,15 +249,19 @@ void arch_trigger_all_cpu_backtrace(void)
 
 	spin_lock_irqsave(&global_cpu_snapshot_lock, flags);
 
-	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
-
 	this_cpu = raw_smp_processor_id();
 
-	__global_reg_self(tp, regs, this_cpu);
+	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
+
+	if (include_self)
+		__global_reg_self(tp, regs, this_cpu);
 
 	smp_fetch_global_regs();
 
 	for_each_online_cpu(cpu) {
+		if (!include_self && cpu == this_cpu)
+			continue;
+
 		struct global_reg_snapshot *gp = &global_cpu_snapshot[cpu].reg;
 
 		__global_reg_poll(gp);
@@ -290,7 +294,7 @@ void arch_trigger_all_cpu_backtrace(void)
 
 static void sysrq_handle_globreg(int key)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 }
 
 static struct sysrq_key_op sparc_globalreg_op = {
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index cb6cfcd..a80cbb8 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -43,7 +43,7 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 extern void init_ISA_irqs(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..1400d72 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -33,31 +33,40 @@ static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	int i;
+	int cpu = get_cpu();
 
-	if (test_and_set_bit(0, &backtrace_flag))
+	if (test_and_set_bit(0, &backtrace_flag)) {
 		/*
 		 * If there is already a trigger_all_cpu_backtrace() in progress
 		 * (backtrace_flag == 1), don't output double cpu dump infos.
 		 */
+		put_cpu();
 		return;
+	}
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
+	if (!include_self)
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
-	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_info("sending NMI to %s CPUs:\n", (include_self ? "all" : "other"));
+		apic->send_IPI_mask(to_cpumask(backtrace_mask), NMI_VECTOR);
+	}
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
 		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
+		touch_softlockup_watchdog();
 	}
 
 	clear_bit(0, &backtrace_flag);
 	smp_mb__after_clear_bit();
+	put_cpu();
 }
 
 static int __kprobes
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 6a45fb5..a17ab63 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -32,15 +32,24 @@ static inline void touch_nmi_watchdog(void)
 #ifdef arch_trigger_all_cpu_backtrace
 static inline bool trigger_all_cpu_backtrace(void)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 
 	return true;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	arch_trigger_all_cpu_backtrace(false);
+	return true;
+}
 #else
 static inline bool trigger_all_cpu_backtrace(void)
 {
 	return false;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
-- 
1.7.1

