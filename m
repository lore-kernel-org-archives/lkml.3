Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaJaPrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:47:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49062 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaJaPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:47:34 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: mingo@kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH for -tip v4] xen/smp: Use die_complete completion when taking CPU down
Date: Fri, 31 Oct 2014 11:49:32 -0400
Message-Id: <1414770572-7950-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2ed53c0d6cc9 ("x86/smpboot: Speed up suspend/resume by avoiding
100ms sleep for CPU offline during S3") introduced completions to CPU
offlining process. These completions are not initialized on Xen kernels
causing a panic in play_dead_common().

Move handling of die_complete into common routines to make them
available to Xen guests.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
v4: Rebased for -tip
v3: Don't #ifdef function prototypes in smp.h
v2: Keep die_complete private to smpboot.c

 arch/x86/include/asm/smp.h |  1 +
 arch/x86/kernel/smpboot.c  | 15 +++++++++++----
 arch/x86/xen/smp.c         |  3 +++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 8cd27e0..8cd1cc3 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -150,6 +150,7 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 }
 
 void cpu_disable_common(void);
+void cpu_die_common(unsigned int cpu);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4d2128a..668d8f2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1303,10 +1303,14 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
 
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
+
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
@@ -1316,8 +1320,6 @@ void cpu_disable_common(void)
 	fixup_irqs();
 }
 
-static DEFINE_PER_CPU(struct completion, die_complete);
-
 int native_cpu_disable(void)
 {
 	int ret;
@@ -1327,16 +1329,21 @@ int native_cpu_disable(void)
 		return ret;
 
 	clear_local_APIC();
-	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
 
 	return 0;
 }
 
+void cpu_die_common(unsigned int cpu)
+{
+	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+}
+
 void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
-	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+
+	cpu_die_common(cpu);
 
 	/* They ack this in play_dead() by setting CPU_DEAD */
 	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8650cdb..4c071ae 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -510,6 +510,9 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
+
+	cpu_die_common(cpu);
+
 	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
-- 
1.8.3.1

