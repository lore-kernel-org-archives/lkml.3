Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaJPQqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:46:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaJPQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:46:14 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: tianyu.lan@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com
Subject: [PATCH v2] xen/smp: Use die_complete completion when taking CPU down
Date: Thu, 16 Oct 2014 12:47:26 -0400
Message-Id: <1413478046-4987-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
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

(Also, while at it, move these routines as well as die_complete under
ifdef CONFIG_HOTPLUG_CPU)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---

v2: Keep die_complete private to smpboot.c

 arch/x86/include/asm/smp.h |  5 ++++-
 arch/x86/kernel/smpboot.c  | 13 +++++++++++--
 arch/x86/xen/smp.c         |  3 +++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 8cd27e0..a78c509 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -149,7 +149,11 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 void cpu_disable_common(void);
+void cpu_die_common(unsigned int cpu);
+void play_dead_common(void);
+#endif
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
@@ -157,7 +161,6 @@ int native_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
-void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d5200e..6fe0fc1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,7 +102,9 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+#ifdef CONFIG_HOTPLUG_CPU
 static DEFINE_PER_CPU(struct completion, die_complete);
+#endif
 
 atomic_t init_deasserted;
 
@@ -1309,6 +1311,8 @@ void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
 
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
+
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
@@ -1327,16 +1331,21 @@ int native_cpu_disable(void)
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
1.8.1.4

