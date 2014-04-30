Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732AbaD3OcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52341 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759070AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 16/16] kgr: make a per-process 'in progress' flag a single bit
Date: Wed, 30 Apr 2014 16:30:49 +0200
Message-Id: <1398868249-26169-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Having the per-task 'kgr_in_progress' flag stored as int is a waste of
space, and manipulating it is likely slower than just performing a single
bit operations. Convert the flag to thread info flag.

Additionaly, makking KGR TI_flag part of _TIF_ALLWORK_MASK and
_TIF_WORK_SYSCALL_ENTRY allows for offloading the flag manipulation
to slow code paths.

js: use *_tsk_thread_flag helpers

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/kgr.h         |  2 +-
 arch/x86/include/asm/thread_info.h |  7 ++++---
 arch/x86/kernel/asm-offsets.c      |  1 -
 arch/x86/kernel/entry_64.S         | 12 +++++++++---
 fs/proc/base.c                     |  3 ++-
 include/linux/kgr.h                | 14 ++++++++++++++
 include/linux/sched.h              |  2 +-
 kernel/kgr.c                       |  4 ++--
 8 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
index 8a3819886e4b..44d32c22fbac 100644
--- a/arch/x86/include/asm/kgr.h
+++ b/arch/x86/include/asm/kgr.h
@@ -18,7 +18,7 @@ static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_i
 	struct kgr_loc_caches *c = ops->private;			\
 	bool irq = !!in_interrupt();					\
 									\
-	if ((!irq && task_thread_info(current)->kgr_in_progress) ||	\
+	if ((!irq && kgr_task_in_progress(current)) ||			\
 			(irq && !*this_cpu_ptr(c->irq_use_new))) {	\
 		pr_info("kgr: slow stub: calling old code at %lx\n",	\
 				c->old);				\
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1fdc144dcc9c..06ef370044cf 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -35,7 +35,6 @@ struct thread_info {
 	void __user		*sysenter_return;
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
-	unsigned short		kgr_in_progress;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -87,6 +86,7 @@ struct thread_info {
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
+#define TIF_KGR_IN_PROGRESS	26	/* kgr patching running */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
@@ -110,6 +110,7 @@ struct thread_info {
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
+#define _TIF_KGR_IN_PROGRESS	(1 << TIF_KGR_IN_PROGRESS)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_ADDR32		(1 << TIF_ADDR32)
@@ -119,7 +120,7 @@ struct thread_info {
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
 	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
-	 _TIF_NOHZ)
+	 _TIF_NOHZ | _TIF_KGR_IN_PROGRESS)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
@@ -135,7 +136,7 @@ struct thread_info {
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
index a03b1e9d2de3..fbf391e99c46 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -615,7 +615,6 @@ GLOBAL(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -640,7 +639,6 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
@@ -660,6 +658,9 @@ sysret_check:
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */
 sysret_careful:
+#ifdef CONFIG_KGR
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -723,6 +724,9 @@ sysret_audit:
 
 	/* Do syscall tracing */
 tracesys:
+#ifdef CONFIG_KGR
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
@@ -763,7 +767,6 @@ GLOBAL(int_ret_from_sys_call)
 GLOBAL(int_with_check)
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
-	movw $0, TI_kgr_in_progress(%rcx)
 	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz   int_careful
@@ -774,6 +777,9 @@ GLOBAL(int_with_check)
 	/* First do a reschedule test. */
 	/* edx:	work, edi: workmask */
 int_careful:
+#ifdef CONFIG_KGR
+	andl $~_TIF_KGR_IN_PROGRESS,TI_flags(%rcx)
+#endif
 	bt $TIF_NEED_RESCHED,%edx
 	jnc  int_very_careful
 	TRACE_IRQS_ON
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 70cba8b21c3f..21d7841ec60d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -87,6 +87,7 @@
 #include <linux/slab.h>
 #include <linux/flex_array.h>
 #include <linux/posix-timers.h>
+#include <linux/kgr.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2109,7 +2110,7 @@ static const struct file_operations proc_timers_operations = {
 #ifdef CONFIG_KGR
 static int proc_pid_kgr_in_progress(struct task_struct *task, char *buffer)
 {
-	return sprintf(buffer, "%d\n", task_thread_info(task)->kgr_in_progress);
+	return sprintf(buffer, "%d\n", kgr_task_in_progress(task));
 }
 #endif /* CONFIG_KGR */
 
diff --git a/include/linux/kgr.h b/include/linux/kgr.h
index ebc6f5bc1ec1..7a1a4d9d97f4 100644
--- a/include/linux/kgr.h
+++ b/include/linux/kgr.h
@@ -4,6 +4,9 @@
 #include <linux/init.h>
 #include <linux/ftrace.h>
 
+static void kgr_mark_task_in_progress(struct task_struct *p);
+static bool kgr_task_in_progress(struct task_struct *p);
+
 #include <asm/kgr.h>
 
 #ifdef CONFIG_KGR
@@ -67,6 +70,17 @@ struct kgr_loc_caches {
 #define KGR_PATCH_END		NULL
 
 extern int kgr_start_patching(struct kgr_patch *);
+
+static inline void kgr_mark_task_in_progress(struct task_struct *p)
+{
+	set_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
+}
+
+static inline bool kgr_task_in_progress(struct task_struct *p)
+{
+	return test_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
+}
+
 #endif /* CONFIG_KGR */
 
 #endif /* LINUX_KGR_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afd5747bc7ff..8efd164f1962 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2972,7 +2972,7 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 #ifdef CONFIG_KGR
 static inline void kgr_task_safe(struct task_struct *p)
 {
-	task_thread_info(p)->kgr_in_progress = false;
+	clear_tsk_thread_flag(p, TIF_KGR_IN_PROGRESS);
 }
 #else
 static inline void kgr_task_safe(struct task_struct *p) { }
diff --git a/kernel/kgr.c b/kernel/kgr.c
index 1fadde396021..a55409122e77 100644
--- a/kernel/kgr.c
+++ b/kernel/kgr.c
@@ -44,7 +44,7 @@ static bool kgr_still_patching(void)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		if (task_thread_info(p)->kgr_in_progress) {
+		if (kgr_task_in_progress(p)) {
 			failed = true;
 			break;
 		}
@@ -98,7 +98,7 @@ static void kgr_handle_processes(void)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		task_thread_info(p)->kgr_in_progress = true;
+		kgr_mark_task_in_progress(p);
 
 		/* wake up kthreads, they will clean the progress flag */
 		if (!p->mm) {
-- 
1.9.2

