Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaFYLIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:08:01 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41102 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -repost 15/21] kgr: make a per-process 'in progress' flag a single bit
Date: Wed, 25 Jun 2014 13:07:09 +0200
Message-Id: <1403694435-3180-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Having the per-task 'kgr_in_progress' flag stored as long is a waste
of space. And manipulating it is likely slower than just performing
single bit operations. Convert the flag to a thread info flag.

Additionally, making the KGR TI_flag part of _TIF_ALLWORK_MASK and
_TIF_WORK_SYSCALL_ENTRY allows for offloading the flag manipulation to
slow code paths.

js: use *_tsk_thread_flag helpers

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/thread_info.h |  7 ++++---
 arch/x86/kernel/asm-offsets.c      |  1 -
 arch/x86/kernel/entry_64.S         | 12 +++++++++---
 include/linux/kgraft.h             |  5 ++---
 include/linux/sched.h              |  2 +-
 5 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e44c8fda9c43..53df17c72359 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -35,7 +35,6 @@ struct thread_info {
 	void __user		*sysenter_return;
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
-	unsigned long		kgr_in_progress;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -88,6 +87,7 @@ struct thread_info {
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
+#define TIF_KGR_IN_PROGRESS	26	/* kGraft patching running */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
@@ -112,6 +112,7 @@ struct thread_info {
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
+#define _TIF_KGR_IN_PROGRESS	(1 << TIF_KGR_IN_PROGRESS)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_ADDR32		(1 << TIF_ADDR32)
@@ -121,7 +122,7 @@ struct thread_info {
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
 	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
-	 _TIF_NOHZ)
+	 _TIF_NOHZ | _TIF_KGR_IN_PROGRESS)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
@@ -137,7 +138,7 @@ struct thread_info {
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
 	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |	\
-	_TIF_NOHZ)
+	_TIF_NOHZ | _TIF_KGR_IN_PROGRESS)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 0db0437967a2..9f6b9341950f 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,6 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_kgr_in_progress, thread_info, kgr_in_progress);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a7c570abc918..edaa5abd58f9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -409,7 +409,6 @@ GLOBAL(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	movq $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -434,7 +433,6 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movq $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
@@ -454,6 +452,9 @@ sysret_check:
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */
 sysret_careful:
+#if IS_ENABLED(CONFIG_KGRAFT)
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -517,6 +518,9 @@ sysret_audit:
 
 	/* Do syscall tracing */
 tracesys:
+#if IS_ENABLED(CONFIG_KGRAFT)
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
@@ -557,7 +561,6 @@ GLOBAL(int_ret_from_sys_call)
 GLOBAL(int_with_check)
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
-	movq $0, TI_kgr_in_progress(%rcx)
 	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz   int_careful
@@ -568,6 +571,9 @@ GLOBAL(int_with_check)
 	/* First do a reschedule test. */
 	/* edx:	work, edi: workmask */
 int_careful:
+#if IS_ENABLED(CONFIG_KGRAFT)
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags(%rcx)
+#endif
 	bt $TIF_NEED_RESCHED,%edx
 	jnc  int_very_careful
 	TRACE_IRQS_ON
diff --git a/include/linux/kgraft.h b/include/linux/kgraft.h
index 93bb1c50e079..92b642408b6f 100644
--- a/include/linux/kgraft.h
+++ b/include/linux/kgraft.h
@@ -73,13 +73,12 @@ extern int kgr_start_patching(struct kgr_patch *);
 
 static inline void kgr_mark_task_in_progress(struct task_struct *p)
 {
-	/* This is replaced by thread_flag later. */
-	set_bit(0, &task_thread_info(p)->kgr_in_progress);
+	set_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
 }
 
 static inline bool kgr_task_in_progress(struct task_struct *p)
 {
-	return test_bit(0, &task_thread_info(p)->kgr_in_progress);
+	return test_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
 }
 
 #endif /* IS_ENABLED(CONFIG_KGRAFT) */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6bc2d63a59c4..0c037f6bba55 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2977,7 +2977,7 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 #if IS_ENABLED(CONFIG_KGRAFT)
 static inline void kgr_task_safe(struct task_struct *p)
 {
-	clear_bit(0, &task_thread_info(p)->kgr_in_progress);
+	clear_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
 }
 #else
 static inline void kgr_task_safe(struct task_struct *p) { }
-- 
2.0.0

