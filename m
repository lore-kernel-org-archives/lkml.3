Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3HEWDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:64992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab3HEWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341518"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/16] x86, asmlinkage: Make several variables used from assembler/linker script visible
Date: Mon,  5 Aug 2013 15:02:43 -0700
Message-Id: <1375740170-7446-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

plus one function load_gs_index

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/pgtable.h       | 3 ++-
 arch/x86/include/asm/processor.h     | 2 +-
 arch/x86/include/asm/special_insns.h | 2 +-
 arch/x86/kernel/cpu/amd.c            | 4 ++--
 arch/x86/kernel/cpu/common.c         | 4 ++--
 arch/x86/kernel/process.c            | 2 +-
 arch/x86/kernel/process_64.c         | 2 +-
 arch/x86/kernel/setup.c              | 4 ++--
 arch/x86/kernel/signal.c             | 2 +-
 arch/x86/lib/usercopy_64.c           | 2 +-
 10 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 7dc305a..4e47659 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -22,7 +22,8 @@
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
+	__visible;
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
 extern spinlock_t pgd_lock;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 24cf5ae..573c1ad 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -412,7 +412,7 @@ union irq_stack_union {
 	};
 };
 
-DECLARE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union);
+DECLARE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union) __visible;
 DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2f4d924..645cad2 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -101,7 +101,7 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
-extern void native_load_gs_index(unsigned);
+extern asmlinkage void native_load_gs_index(unsigned);
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f654ece..466e3d1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -66,8 +66,8 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
  *	performance at the same time..
  */
 
-extern void vide(void);
-__asm__(".align 4\nvide: ret");
+extern __visible void vide(void);
+__asm__(".globl vide\n\t.align 4\nvide: ret");
 
 static void init_amd_k5(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25eb274..2793d1f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1076,7 +1076,7 @@ struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
 				    (unsigned long) debug_idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
-		     irq_stack_union) __aligned(PAGE_SIZE);
+		     irq_stack_union) __aligned(PAGE_SIZE) __visible;
 
 /*
  * The following four percpu variables are hot.  Align current_task to
@@ -1093,7 +1093,7 @@ EXPORT_PER_CPU_SYMBOL(kernel_stack);
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
-DEFINE_PER_CPU(unsigned int, irq_count) = -1;
+DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83369e5..c83516b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -36,7 +36,7 @@
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
+__visible DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU(unsigned char, is_idle);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6e8c1d0..bb1dc51 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -52,7 +52,7 @@
 
 asmlinkage extern void ret_from_fork(void);
 
-DEFINE_PER_CPU(unsigned long, old_rsp);
+asmlinkage DEFINE_PER_CPU(unsigned long, old_rsp);
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..dfa55af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -206,9 +206,9 @@ EXPORT_SYMBOL(boot_cpu_data);
 
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-unsigned long mmu_cr4_features;
+__visible unsigned long mmu_cr4_features;
 #else
-unsigned long mmu_cr4_features = X86_CR4_PAE;
+__visible unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
 /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 1dba45d..6a9acc6 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -728,7 +728,7 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void
+__visible void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 	user_exit();
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 906fea3..c905e89 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(copy_in_user);
  * Since protection fault in copy_from/to_user is not a normal situation,
  * it is not necessary to optimize tail handling.
  */
-unsigned long
+__visible unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 {
 	char c;
-- 
1.8.3.1

