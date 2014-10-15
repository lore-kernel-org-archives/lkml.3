Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaJOOyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:54:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30689 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaJOOyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:54:01 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: tianyu.lan@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com
Subject: [PATCH] xen/smp: Use die_complete completion when taking CPU down
Date: Wed, 15 Oct 2014 10:55:10 -0400
Message-Id: <1413384910-1231-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2ed53c0d6cc9 ("x86/smpboot: Speed up suspend/resume by avoiding
100ms sleep for CPU offline during S3") introduced completions to CPU
offlining process. These completions are not initialized on Xen kernels
causing a panic in play_dead_common().

Add handling of die_complete on Xen (this requires moving die_complete
to global scope. While at it, move die_complete definition in
arch/x86/kernel/smpboot.c under ifdef CONFIG_HOTPLUG_CPU)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/include/asm/cpu.h | 3 +++
 arch/x86/kernel/smpboot.c  | 4 +++-
 arch/x86/xen/smp.c         | 4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index d2b1298..b65d5c9 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -6,6 +6,7 @@
 #include <linux/topology.h>
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
+#include <linux/completion.h>
 
 #ifdef CONFIG_SMP
 
@@ -26,6 +27,8 @@ struct x86_cpu {
 };
 
 #ifdef CONFIG_HOTPLUG_CPU
+DECLARE_PER_CPU(struct completion, die_complete);
+
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 extern void start_cpu0(void);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d5200e..abe9005 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,7 +102,9 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
-static DEFINE_PER_CPU(struct completion, die_complete);
+#ifdef CONFIG_HOTPLUG_CPU
+DEFINE_PER_CPU(struct completion, die_complete);
+#endif
 
 atomic_t init_deasserted;
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8650cdb..4da0008 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -498,6 +498,7 @@ static int xen_cpu_disable(void)
 	if (cpu == 0)
 		return -EBUSY;
 
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
 
 	load_cr3(swapper_pg_dir);
@@ -510,6 +511,9 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
+
+	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+
 	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
-- 
1.8.1.4

