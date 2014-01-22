Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaAVCPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:15:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:55562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaAVCOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:14:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="405174605"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v2 3/4] x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
Date: Wed, 22 Jan 2014 17:27:45 +0800
Message-Id: <1390382866-6361-4-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
References: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PR_MPX_INIT and PR_MPX_RELEASE prctl()
commands on the x86 platform. These commands can be used to
init and release MPX related resource.

A MMU notifier will be registered during PR_MPX_INIT
command execution. So the bound tables can be automatically
deallocated when one memory area is unmapped.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/Kconfig                 |    4 ++
 arch/x86/include/asm/mpx.h       |    9 ++++
 arch/x86/include/asm/processor.h |   16 +++++++
 arch/x86/kernel/mpx.c            |   84 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/prctl.h       |    6 +++
 kernel/sys.c                     |   12 +++++
 6 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..695101a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -233,6 +233,10 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
+config HAVE_INTEL_MPX
+	def_bool y
+	select MMU_NOTIFIER
+
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
index d074153..9652e9e 100644
--- a/arch/x86/include/asm/mpx.h
+++ b/arch/x86/include/asm/mpx.h
@@ -30,6 +30,15 @@
 
 #endif
 
+typedef union {
+	struct {
+		unsigned long ignored:MPX_IGN_BITS;
+		unsigned long l2index:MPX_L2_BITS;
+		unsigned long l1index:MPX_L1_BITS;
+	};
+	unsigned long addr;
+} mpx_addr;
+
 void do_mpx_bt_fault(struct xsave_struct *xsave_buf);
 
 #endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 43be6f6..ea4e72d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -963,6 +963,22 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+#ifdef CONFIG_HAVE_INTEL_MPX
+
+/* Init/release a process' MPX related resource */
+#define MPX_INIT(tsk)		mpx_init((tsk))
+#define MPX_RELEASE(tsk)	mpx_release((tsk))
+
+extern int mpx_init(struct task_struct *tsk);
+extern int mpx_release(struct task_struct *tsk);
+
+#else /* CONFIG_HAVE_INTEL_MPX */
+
+#define MPX_INIT(tsk)		(-EINVAL)
+#define MPX_RELEASE(tsk)	(-EINVAL)
+
+#endif /* CONFIG_HAVE_INTEL_MPX */
+
 extern u16 amd_get_nb_id(int cpu);
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
index 767b3bf..ffe5aee 100644
--- a/arch/x86/kernel/mpx.c
+++ b/arch/x86/kernel/mpx.c
@@ -1,5 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
+#include <linux/prctl.h>
+#include <linux/mmu_notifier.h>
 #include <asm/processor.h>
 #include <asm/mpx.h>
 #include <asm/mman.h>
@@ -7,6 +9,88 @@
 #include <asm/fpu-internal.h>
 #include <asm/alternative.h>
 
+static struct mmu_notifier mpx_mn;
+
+static void mpx_invl_range_end(struct mmu_notifier *mn,
+		struct mm_struct *mm,
+		unsigned long start, unsigned long end)
+{
+	struct xsave_struct *xsave_buf;
+	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
+	unsigned long bt_addr;
+	unsigned long bd_base;
+	unsigned long bd_entry, bde_start, bde_end;
+	mpx_addr lap;
+
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/* ignore swap notifications */
+	pgd = pgd_offset(mm, start);
+	pud = pud_offset(pgd, start);
+	pmd = pmd_offset(pud, start);
+	pte = pte_offset_kernel(pmd, start);
+	if (!pte_present(*pte) && !pte_none(*pte) && !pte_file(*pte))
+		return;
+
+	/* get bound directory base address */
+	fpu_xsave(&current->thread.fpu);
+	xsave_buf = &(current->thread.fpu.state->xsave);
+	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
+
+	/* get related bde range */
+	lap.addr = start;
+	bde_start = bd_base + (lap.l1index << MPX_L1_SHIFT);
+
+	lap.addr = end;
+	if (lap.ignored || lap.l2index)
+		bde_end = bd_base + (lap.l1index<<MPX_L1_SHIFT) + sizeof(long);
+	else
+		bde_end = bd_base + (lap.l1index<<MPX_L1_SHIFT);
+
+	for (bd_entry = bde_start; bd_entry < bde_end;
+		bd_entry += sizeof(unsigned long)) {
+
+		if (get_user(bt_addr, (long __user *)bd_entry))
+			return;
+
+		if (bt_addr & 0x1) {
+			user_atomic_cmpxchg_inatomic(&bt_addr,
+					(long __user *)bd_entry, bt_addr, 0);
+			do_munmap(mm, bt_addr & MPX_L2_NODE_ADDR_MASK, bt_size);
+		}
+	}
+}
+
+static struct mmu_notifier_ops mpx_mmuops = {
+	.invalidate_range_end = mpx_invl_range_end,
+};
+
+int mpx_init(struct task_struct *tsk)
+{
+	if (!boot_cpu_has(X86_FEATURE_MPX))
+		return -EINVAL;
+
+	/* register mmu_notifier to delallocate the bound tables */
+	mpx_mn.ops = &mpx_mmuops;
+	mmu_notifier_register(&mpx_mn, current->mm);
+
+	return 0;
+}
+
+int mpx_release(struct task_struct *tsk)
+{
+	if (!boot_cpu_has(X86_FEATURE_MPX))
+		return -EINVAL;
+
+	/* unregister mmu_notifier */
+	mmu_notifier_unregister(&mpx_mn, current->mm);
+
+	return 0;
+}
+
 static bool allocate_bt(unsigned long bd_entry)
 {
 	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..19ab881 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,10 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * Init/release MPX related resource.
+ */
+#define PR_MPX_INIT	41
+#define PR_MPX_RELEASE	42
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index c18ecca..bbaf573 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -92,6 +92,12 @@
 #ifndef SET_TSC_CTL
 # define SET_TSC_CTL(a)		(-EINVAL)
 #endif
+#ifndef MPX_INIT
+# define MPX_INIT(a)		(-EINVAL)
+#endif
+#ifndef MPX_RELEASE
+# define MPX_RELEASE(a)		(-EINVAL)
+#endif
 
 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -1999,6 +2005,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_MPX_INIT:
+		error = MPX_INIT(me);
+		break;
+	case PR_MPX_RELEASE:
+		error = MPX_RELEASE(me);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
1.7.1

