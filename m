Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaKRXPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:15:38 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63241 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaKRXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:15:35 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in schedule and __might_sleep
Date: Tue, 18 Nov 2014 15:15:19 -0800
Message-Id: <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1416352397.git.luto@amacapital.net>
References: <cover.1416352397.git.luto@amacapital.net>
In-Reply-To: <cover.1416352397.git.luto@amacapital.net>
References: <cover.1416352397.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, sleeping while on an IST or irq stack has a surprisingly
good chance of working, but it can also fail dramatically.  Add an
arch hook to allow schedule and __might_sleep to catch sleeping on
the wrong stack.

This will also catch do_exit from a funny stack, which could leave
an IST stack shifted or an NMI nesting count incremented.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig                   |  1 +
 arch/x86/include/asm/thread_info.h | 17 +++++++++++++++++
 arch/x86/kernel/irq_32.c           | 13 +++----------
 include/linux/thread_info.h        |  7 +++++++
 kernel/Kconfig.locks               |  3 +++
 kernel/sched/core.c                | 14 ++++++++++----
 6 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a6774ac9..a811286636d2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -137,6 +137,7 @@ config X86
 	select HAVE_ACPI_APEI_NMI if ACPI
 	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
 	select X86_FEATURE_NAMES if PROC_FS
+	select HAVE_ARCH_SCHEDULE_ALLOWED
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 547e344a6dc6..05701f132473 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -170,6 +170,23 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
+static inline unsigned long current_stack_pointer(void)
+{
+	unsigned long sp;
+#ifdef CONFIG_X86_64
+	asm("mov %%rsp,%0" : "=g" (sp));
+#else
+	asm("mov %%esp,%0" : "=g" (sp));
+#endif
+	return sp;
+}
+
+static inline bool arch_schedule_allowed(void)
+{
+	return ((current_stack_pointer() ^ this_cpu_read_stable(kernel_stack))
+		& ~(THREAD_SIZE - 1)) == 0;
+}
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 63ce838e5a54..28d28f5eb8f4 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -69,16 +69,9 @@ static void call_on_stack(void *func, void *stack)
 		     : "memory", "cc", "edx", "ecx", "eax");
 }
 
-/* how to get the current stack pointer from C */
-#define current_stack_pointer ({		\
-	unsigned long sp;			\
-	asm("mov %%esp,%0" : "=g" (sp));	\
-	sp;					\
-})
-
 static inline void *current_stack(void)
 {
-	return (void *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+	return (void *)(current_stack_pointer() & ~(THREAD_SIZE - 1));
 }
 
 static inline int
@@ -103,7 +96,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 
 	/* Save the next esp at the bottom of the stack */
 	prev_esp = (u32 *)irqstk;
-	*prev_esp = current_stack_pointer;
+	*prev_esp = current_stack_pointer();
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -156,7 +149,7 @@ void do_softirq_own_stack(void)
 
 	/* Push the previous esp onto the stack */
 	prev_esp = (u32 *)irqstk;
-	*prev_esp = current_stack_pointer;
+	*prev_esp = current_stack_pointer();
 
 	call_on_stack(__do_softirq, isp);
 }
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index ff307b548ed3..6deaf7e97009 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -145,6 +145,13 @@ static inline bool test_and_clear_restore_sigmask(void)
 #error "no set_restore_sigmask() provided and default one won't work"
 #endif
 
+#ifndef CONFIG_HAVE_ARCH_SCHEDULE_ALLOWED
+static inline bool arch_schedule_allowed(void)
+{
+	return true;
+}
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 76768ee812b2..2714dc34695a 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -237,3 +237,6 @@ config ARCH_USE_QUEUE_RWLOCK
 config QUEUE_RWLOCK
 	def_bool y if ARCH_USE_QUEUE_RWLOCK
 	depends on SMP
+
+config HAVE_ARCH_SCHEDULE_ALLOWED
+       bool
\ No newline at end of file
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c13ddc..e51ab65a9750 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2705,8 +2705,12 @@ static inline void schedule_debug(struct task_struct *prev)
 	 * Test if we are atomic. Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path. Otherwise whine
 	 * if we are scheduling when we should not.
+	 *
+	 * If architectural conditions for scheduling are not met,
+	 * complain even if we are in do_exit.
 	 */
-	if (unlikely(in_atomic_preempt_off() && prev->state != TASK_DEAD))
+	if (unlikely((in_atomic_preempt_off() && prev->state != TASK_DEAD) ||
+		     !arch_schedule_allowed()))
 		__schedule_bug(prev);
 	rcu_sleep_check();
 
@@ -7200,10 +7204,12 @@ static inline int preempt_count_equals(int preempt_offset)
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
 	static unsigned long prev_jiffy;	/* ratelimiting */
+	bool arch_ok;
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
+	arch_ok = arch_schedule_allowed();
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
-	     !is_idle_task(current)) ||
+	     !is_idle_task(current) && arch_ok) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
@@ -7214,8 +7220,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 		"BUG: sleeping function called from invalid context at %s:%d\n",
 			file, line);
 	printk(KERN_ERR
-		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
-			in_atomic(), irqs_disabled(),
+		"in_atomic(): %d, irqs_disabled(): %d, arch_schedule_allowed: %d, pid: %d, name: %s\n",
+			in_atomic(), irqs_disabled(), (int)arch_ok,
 			current->pid, current->comm);
 
 	debug_show_held_locks(current);
-- 
1.9.3

