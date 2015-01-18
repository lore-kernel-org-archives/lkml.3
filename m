Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbbARBSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:18:04 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38995 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbbARBRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:17:48 -0500
X-Sasl-enc: bVtLTqpNVo+fTj9AcQf3gNDvqL8/WfzbN0+RTF6L9blW 1421543867
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/3] x86_64: don't use KERNEL_STACK_OFFSET for syscall and sysenter
Date: Sun, 18 Jan 2015 02:17:41 +0100
Message-Id: <1421543862-3552-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
References: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall and sysenter code use KERNEL_STACK_OFFSET to set the
initial stack pointer a bit below the top of the kernel stack page.
Stop doing that.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/ia32/ia32entry.S          | 4 ++--
 arch/x86/include/asm/thread_info.h | 6 ++----
 arch/x86/kernel/cpu/common.c       | 2 +-
 arch/x86/kernel/entry_64.S         | 3 ++-
 arch/x86/kernel/process_64.c       | 3 +--
 arch/x86/kernel/smpboot.c          | 3 +--
 arch/x86/xen/smp.c                 | 3 +--
 7 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 1c74f39..93b30a1 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -122,7 +122,6 @@ ENTRY(ia32_sysenter_target)
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
 	movq	PER_CPU_VAR(kernel_stack), %rsp
-	addq	$(KERNEL_STACK_OFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -292,13 +291,14 @@ ENDPROC(ia32_sysenter_target)
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
+	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
 	movq	PER_CPU_VAR(kernel_stack),%rsp
+	sub $(PTREGS_SIZE-RIP),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 471037d..2caaaf2 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,7 +149,6 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
 #define STACK_WARN		(THREAD_SIZE/8)
-#define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
 
 /*
  * macros/functions for gaining access to the thread information structure
@@ -163,8 +162,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(this_cpu_read_stable(kernel_stack) +
-		      KERNEL_STACK_OFFSET - THREAD_SIZE);
+	ti = (void *)(this_cpu_read_stable(kernel_stack) - THREAD_SIZE);
 	return ti;
 }
 
@@ -184,7 +182,7 @@ static inline unsigned long current_stack_pointer(void)
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
 	_ASM_MOV PER_CPU_VAR(kernel_stack),reg ; \
-	_ASM_SUB $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg ;
+	_ASM_SUB $THREAD_SIZE,reg ;
 
 /*
  * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c604965..aa76c69 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1116,7 +1116,7 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
-	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+	(unsigned long)&init_thread_union + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9f9ca20..7adff94 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -321,7 +321,7 @@ END(ret_from_fork)
 ENTRY(system_call)
 	CFI_STARTPROC	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
+	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -334,6 +334,7 @@ GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp
+	sub $(PTREGS_SIZE-RIP),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5a2c029..0747dbf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -414,8 +414,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
 
 	this_cpu_write(kernel_stack,
-		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - KERNEL_STACK_OFFSET);
+		  (unsigned long)task_stack_page(next_p) + THREAD_SIZE);
 
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6d7022c..66fd449 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -776,8 +776,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	initial_gs = per_cpu_offset(cpu);
 #endif
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(idle) -
-		KERNEL_STACK_OFFSET + THREAD_SIZE;
+		(unsigned long)task_stack_page(idle) + THREAD_SIZE;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = idle->thread.sp;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4c071ae..4e71a3b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -452,8 +452,7 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(idle) -
-		KERNEL_STACK_OFFSET + THREAD_SIZE;
+		(unsigned long)task_stack_page(idle) + THREAD_SIZE;
 
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
-- 
2.1.0

