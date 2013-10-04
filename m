Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3JDVkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:40:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:30818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab3JDVj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189165"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, jason.wessel@windriver.com
Subject: [PATCH 5/6] x86, kgdb: Support compiling without hardware break points
Date: Fri,  4 Oct 2013 14:39:47 -0700
Message-Id: <1380922788-23112-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add some ifdefs to support compiling without CONFIG_HW_BREAKPOINTS.
HW_BREAKPOINTS pulls in all of perf, and presumably there are
some use cases where people want to debug without perf.

The standard software breakpoints still work of course.

Cc: jason.wessel@windriver.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile |  2 +-
 arch/x86/kernel/kgdb.c       | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a735914..e125307 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -46,7 +46,7 @@ endif
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
-obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o 
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
 obj-$(CONFIG_HYPERVISOR_GUEST)		+= vmware.o hypervisor.o mshyperv.o
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 836f832..f3efeb9 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -193,6 +193,8 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs[GDB_SP]	= p->thread.sp;
 }
 
+#ifdef CONFIG_HW_BREAKPOINTS
+
 static struct hw_breakpoint {
 	unsigned		enabled;
 	unsigned long		addr;
@@ -419,6 +421,8 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
 	}
 }
 
+#endif
+
 #ifdef CONFIG_SMP
 /**
  *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
@@ -639,6 +643,8 @@ out:
 	return retval;
 }
 
+#ifdef CONFIG_HW_BREAKPOINTS
+
 static void kgdb_hw_overflow_handler(struct perf_event *event,
 		struct perf_sample_data *data, struct pt_regs *regs)
 {
@@ -689,6 +695,8 @@ void kgdb_arch_late(void)
 	}
 }
 
+#endif
+
 /**
  *	kgdb_arch_exit - Perform any architecture specific uninitalization.
  *
@@ -697,6 +705,7 @@ void kgdb_arch_late(void)
  */
 void kgdb_arch_exit(void)
 {
+#ifdef CONFIG_HW_BREAKPOINTS
 	int i;
 	for (i = 0; i < 4; i++) {
 		if (breakinfo[i].pev) {
@@ -704,6 +713,7 @@ void kgdb_arch_exit(void)
 			breakinfo[i].pev = NULL;
 		}
 	}
+#endif
 	unregister_nmi_handler(NMI_UNKNOWN, "kgdb");
 	unregister_nmi_handler(NMI_LOCAL, "kgdb");
 	unregister_die_notifier(&kgdb_notifier);
@@ -807,9 +817,11 @@ struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
 	.flags			= KGDB_HW_BREAKPOINT,
+#ifdef CONFIG_HW_BREAKPOINTS
 	.set_hw_breakpoint	= kgdb_set_hw_break,
 	.remove_hw_breakpoint	= kgdb_remove_hw_break,
 	.disable_hw_break	= kgdb_disable_hw_debug,
 	.remove_all_hw_break	= kgdb_remove_all_hw_break,
 	.correct_hw_break	= kgdb_correct_hw_break,
+#endif
 };
-- 
1.8.3.1

