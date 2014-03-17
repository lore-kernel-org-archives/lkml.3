Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaCQD0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:26:55 -0400
Received: from mail.xen.prgmr.com ([71.19.149.6]:57071 "EHLO
	mail.xen.prgmr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaCQD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:26:54 -0400
From: Sarah Newman <srn@prgmr.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        zhu.yanhai@gmail.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: Sarah Newman <srn@prgmr.com>
Subject: [PATCH] x86, fpu, xen: Allocate fpu state for xen pv based on PVABI behavior
Date: Sun, 16 Mar 2014 20:32:29 -0700
Message-Id: <1395027149-26298-1-git-send-email-srn@prgmr.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <53266841.6090308@prgmr.com>
References: <53266841.6090308@prgmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xen PVABI dictates that CR0 TS will be automatically cleared for
the device not available trap.  This means it is not safe to task
switch with the default PVABI behavior.

One method of working around this is to disallow scheduling when
allocating memory for the fpu state, but in extremely low memory
circumstances this may fail. Therefore only require this behavior
when xen pv mode is active and the xen PVABI does not allow task
switching.

One other solution, enabling eagerfpu, was explored but eventually
discarded due to notable performance impact.

Reported-by: Zhu Yanhai <zhu.yanhai@gmail.com>
Signed-off-by: Sarah Newman <srn@prgmr.com>
---
 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/include/asm/processor.h    |    5 +++++
 arch/x86/kernel/i387.c              |   13 +++++++++++++
 arch/x86/kernel/traps.c             |    2 --
 arch/x86/xen/enlighten.c            |    1 +
 arch/x86/xen/setup.c                |   27 +++++++++++++++++++++++++++
 6 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..9ec236c 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -571,7 +571,7 @@ static inline int fpu_alloc(struct fpu *fpu)
 {
 	if (fpu_allocated(fpu))
 		return 0;
-	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	fpu_ops.fpu_state_alloc(fpu);
 	if (!fpu->state)
 		return -ENOMEM;
 	WARN_ON((unsigned long)fpu->state & 15);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fdedd38..941b55d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -413,6 +413,11 @@ struct fpu {
 	union thread_xstate *state;
 };
 
+struct fpu_ops {
+	void (*fpu_state_alloc)(struct fpu *fpu);
+};
+extern struct fpu_ops fpu_ops;
+
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d5dd808..24ce161 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -157,6 +157,19 @@ static void init_thread_xstate(void)
 		xstate_size = sizeof(struct i387_fsave_struct);
 }
 
+static void native_fpu_state_alloc(struct fpu *fpu)
+{
+	unsigned long flags;
+	local_save_flags(flags);
+	local_irq_enable();
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	local_irq_restore(flags);
+}
+
+struct fpu_ops fpu_ops = {
+		.fpu_state_alloc = native_fpu_state_alloc,
+};
+
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..97479d6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -624,7 +624,6 @@ void math_state_restore(void)
 	struct task_struct *tsk = current;
 
 	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
 		/*
 		 * does a slab alloc which can sleep
 		 */
@@ -635,7 +634,6 @@ void math_state_restore(void)
 			do_group_exit(SIGKILL);
 			return;
 		}
-		local_irq_disable();
 	}
 
 	__thread_fpu_begin(tsk);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 201d09a..fb3aa30 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -69,6 +69,7 @@
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
 #include <asm/pat.h>
+#include <asm/processor.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 0982233..4e65b52 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -11,6 +11,7 @@
 #include <linux/memblock.h>
 #include <linux/cpuidle.h>
 #include <linux/cpufreq.h>
+#include <linux/slab.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -18,6 +19,7 @@
 #include <asm/setup.h>
 #include <asm/acpi.h>
 #include <asm/numa.h>
+#include <asm/processor.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
@@ -598,6 +600,28 @@ void __init xen_pvmmu_arch_setup(void)
 	xen_enable_nmi();
 }
 
+static void xen_fpu_state_alloc(struct fpu *fpu)
+{
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_NOWAIT);
+}
+
+static const struct fpu_ops xen_fpu_ops __initconst = {
+		.fpu_state_alloc = xen_fpu_state_alloc,
+};
+
+#define _XEN_CPUID_FEAT1_DEV_NA_TS_ALLOWED 1
+#define XEN_CPUID_FEAT1_DEV_NA_TS_ALLOWED \
+	(1u<<_XEN_CPUID_FEAT1_DEV_NA_TS_ALLOWED)
+static bool __init xen_check_dev_na_ts_allowed(void)
+{
+	uint32_t pages, msr, feat1, feat2, base;
+
+	base = xen_cpuid_base();
+	cpuid(base + 2, &pages, &msr, &feat1, &feat2);
+
+	return !!(feat1 & XEN_CPUID_FEAT1_DEV_NA_TS_ALLOWED);
+}
+
 /* This function is not called for HVM domains */
 void __init xen_arch_setup(void)
 {
@@ -605,6 +629,9 @@ void __init xen_arch_setup(void)
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		xen_pvmmu_arch_setup();
 
+	if (!xen_check_dev_na_ts_allowed())
+		fpu_ops = xen_fpu_ops;
+
 #ifdef CONFIG_ACPI
 	if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
 		printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
-- 
1.7.9.5

