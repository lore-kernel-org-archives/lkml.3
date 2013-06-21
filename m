Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab3FUA4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:56:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965866Ab3FUA41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:56:27 -0400
Date: Thu, 20 Jun 2013 17:55:23 -0700
Message-Id: <201306210055.r5L0tNKi027615@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.10-rc7
Cc: "H. Peter Anvin" <hpa@zytor.com>, <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        stable <stable@vger.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 17:55:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series fixes a couple of build failures, and fixes MTRR cleanup
and memory setup on very specific memory maps.  Finally, it fixes
triggering backtraces on all CPUs, which was inadvertently disabled on
x86.

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

for you to fetch changes up to b52e0a7c4e4100f8683af508664e60e1603070f9:

  x86: Fix trigger_all_cpu_backtrace() implementation (2013-06-20 14:00:21 +0200)

----------------------------------------------------------------
Michel Lespinasse (1):
      x86: Fix trigger_all_cpu_backtrace() implementation

Paul Gortmaker (1):
      x86: Fix section mismatch on load_ucode_ap

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Yinghai Lu (2):
      x86, mtrr: Fix original mtrr range get for mtrr_cleanup
      range: Do not add new blank slot with add_range_with_merge

 arch/x86/Kconfig                   |  1 +
 arch/x86/include/asm/irq.h         |  5 +++++
 arch/x86/include/asm/microcode.h   |  4 ++--
 arch/x86/include/asm/nmi.h         |  4 +---
 arch/x86/kernel/apic/hw_nmi.c      |  1 +
 arch/x86/kernel/cpu/mtrr/cleanup.c |  8 ++++----
 kernel/range.c                     | 21 +++++++++++----------
 7 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..fe120da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2265,6 +2265,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	---help---
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..57873be 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -41,4 +41,9 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+#endif
+
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 6825e2e..6bc3985 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -60,11 +60,11 @@ static inline void __exit exit_amd_microcode(void) {}
 #ifdef CONFIG_MICROCODE_EARLY
 #define MAX_UCODE_COUNT 128
 extern void __init load_ucode_bsp(void);
-extern __init void load_ucode_ap(void);
+extern void __cpuinit load_ucode_ap(void);
 extern int __init save_microcode_in_initrd(void);
 #else
 static inline void __init load_ucode_bsp(void) {}
-static inline __init void load_ucode_ap(void) {}
+static inline void __cpuinit load_ucode_ap(void) {}
 static inline int __init save_microcode_in_initrd(void)
 {
 	return 0;
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c0fa356..86f9301 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -18,9 +18,7 @@ extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void arch_trigger_all_cpu_backtrace(void);
-#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
-#endif
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 #define NMI_FLAG_FIRST	1
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 31cb9ae..a698d71 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -9,6 +9,7 @@
  *
  */
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 35ffda5..5f90b85 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -714,15 +714,15 @@ int __init mtrr_cleanup(unsigned address_bits)
 	if (mtrr_tom2)
 		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
 
-	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
 	 * [0, 1M) should always be covered by var mtrr with WB
 	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
-	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
+	nr_range = add_range_with_merge(range, RANGE_NUM, 0, 0,
 					1ULL<<(20 - PAGE_SHIFT));
-	/* Sort the ranges: */
-	sort_range(range, nr_range);
+	/* add from var mtrr at last */
+	nr_range = x86_get_mtrr_mem_range(range, nr_range,
+					  x_remove_base, x_remove_size);
 
 	range_sums = sum_ranges(range, nr_range);
 	printk(KERN_INFO "total RAM covered: %ldM\n",
diff --git a/kernel/range.c b/kernel/range.c
index eb911db..322ea8e 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sort.h>
-
+#include <linux/string.h>
 #include <linux/range.h>
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
@@ -32,9 +32,8 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 	if (start >= end)
 		return nr_range;
 
-	/* Try to merge it with old one: */
+	/* get new start/end: */
 	for (i = 0; i < nr_range; i++) {
-		u64 final_start, final_end;
 		u64 common_start, common_end;
 
 		if (!range[i].end)
@@ -45,14 +44,16 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 		if (common_start > common_end)
 			continue;
 
-		final_start = min(range[i].start, start);
-		final_end = max(range[i].end, end);
+		/* new start/end, will add it back at last */
+		start = min(range[i].start, start);
+		end = max(range[i].end, end);
 
-		/* clear it and add it back for further merge */
-		range[i].start = 0;
-		range[i].end =  0;
-		return add_range_with_merge(range, az, nr_range,
-			final_start, final_end);
+		memmove(&range[i], &range[i + 1],
+			(nr_range - (i + 1)) * sizeof(range[i]));
+		range[nr_range - 1].start = 0;
+		range[nr_range - 1].end   = 0;
+		nr_range--;
+		i--;
 	}
 
 	/* Need to add it: */
