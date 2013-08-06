Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab3HFVoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43518 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HFVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:04 -0400
Date: Tue, 6 Aug 2013 14:43:52 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-277d5b40b7bf495d2d4193746181b17dd98441b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-10-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-10-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make several variables used from assembler/linker script visible
Git-Commit-ID: 277d5b40b7bf495d2d4193746181b17dd98441b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  277d5b40b7bf495d2d4193746181b17dd98441b2
Gitweb:     http://git.kernel.org/tip/277d5b40b7bf495d2d4193746181b17dd98441b2
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:43 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:20:13 -0700

x86, asmlinkage: Make several variables used from assembler/linker script visible

Plus one function, load_gs_index().

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-10-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
