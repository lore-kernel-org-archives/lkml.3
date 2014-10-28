Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaJ1LEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:04:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaJ1LE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:04:28 -0400
Date: Tue, 28 Oct 2014 04:03:13 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-009f60e2763568cdcd75bd1cf360c7c7165e2e60@git.kernel.org>
Cc: hpa@zytor.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cebbert.lkml@gmail.com,
        fweisbec@gmail.com, oleg@redhat.com, dvlasenk@redhat.com,
        mingo@kernel.org, sasha.levin@oracle.com,
        masami.hiramatsu.pt@hitachi.com, agraf@suse.de, luto@amacapital.net,
        peterz@infradead.org, cl@linux.com, tglx@linutronix.de,
        rostedt@goodmis.org
Reply-To: agraf@suse.de, masami.hiramatsu.pt@hitachi.com, luto@amacapital.net,
        peterz@infradead.org, tglx@linutronix.de, cl@linux.com,
        rostedt@goodmis.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cebbert.lkml@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, oleg@redhat.com, fweisbec@gmail.com,
        mingo@kernel.org, sasha.levin@oracle.com, dvlasenk@redhat.com
In-Reply-To: <20141005202322.GB27962@redhat.com>
References: <20141005202322.GB27962@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  stop the unbound recursion in preempt_schedule_context()
Git-Commit-ID: 009f60e2763568cdcd75bd1cf360c7c7165e2e60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  009f60e2763568cdcd75bd1cf360c7c7165e2e60
Gitweb:     http://git.kernel.org/tip/009f60e2763568cdcd75bd1cf360c7c7165e2e60
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 5 Oct 2014 22:23:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:05 +0100

sched: stop the unbound recursion in preempt_schedule_context()

preempt_schedule_context() does preempt_enable_notrace() at the end
and this can call the same function again; exception_exit() is heavy
and it is quite possible that need-resched is true again.

1. Change this code to dec preempt_count() and check need_resched()
   by hand.

2. As Linus suggested, we can use the PREEMPT_ACTIVE bit and avoid
   the enable/disable dance around __schedule(). But in this case
   we need to move into sched/core.c.

3. Cosmetic, but x86 forgets to declare this function. This doesn't
   really matter because it is only called by asm helpers, still it
   make sense to add the declaration into asm/preempt.h to match
   preempt_schedule().

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20141005202322.GB27962@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/preempt.h |  1 +
 kernel/context_tracking.c      | 40 ----------------------------------------
 kernel/sched/core.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 7024c12..4008734 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -105,6 +105,7 @@ static __always_inline bool should_resched(void)
 # ifdef CONFIG_CONTEXT_TRACKING
     extern asmlinkage void ___preempt_schedule_context(void);
 #   define __preempt_schedule_context() asm ("call ___preempt_schedule_context")
+    extern asmlinkage void preempt_schedule_context(void);
 # endif
 #endif
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 5664985..937ecdf 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -107,46 +107,6 @@ void context_tracking_user_enter(void)
 }
 NOKPROBE_SYMBOL(context_tracking_user_enter);
 
-#ifdef CONFIG_PREEMPT
-/**
- * preempt_schedule_context - preempt_schedule called by tracing
- *
- * The tracing infrastructure uses preempt_enable_notrace to prevent
- * recursion and tracing preempt enabling caused by the tracing
- * infrastructure itself. But as tracing can happen in areas coming
- * from userspace or just about to enter userspace, a preempt enable
- * can occur before user_exit() is called. This will cause the scheduler
- * to be called when the system is still in usermode.
- *
- * To prevent this, the preempt_enable_notrace will use this function
- * instead of preempt_schedule() to exit user context if needed before
- * calling the scheduler.
- */
-asmlinkage __visible void __sched notrace preempt_schedule_context(void)
-{
-	enum ctx_state prev_ctx;
-
-	if (likely(!preemptible()))
-		return;
-
-	/*
-	 * Need to disable preemption in case user_exit() is traced
-	 * and the tracer calls preempt_enable_notrace() causing
-	 * an infinite recursion.
-	 */
-	preempt_disable_notrace();
-	prev_ctx = exception_enter();
-	preempt_enable_no_resched_notrace();
-
-	preempt_schedule();
-
-	preempt_disable_notrace();
-	exception_exit(prev_ctx);
-	preempt_enable_notrace();
-}
-EXPORT_SYMBOL_GPL(preempt_schedule_context);
-#endif /* CONFIG_PREEMPT */
-
 /**
  * context_tracking_user_exit - Inform the context tracking that the CPU is
  *                              exiting userspace mode and entering the kernel.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dde8adb..240157c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2951,6 +2951,47 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
 }
 NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
+
+#ifdef CONFIG_CONTEXT_TRACKING
+/**
+ * preempt_schedule_context - preempt_schedule called by tracing
+ *
+ * The tracing infrastructure uses preempt_enable_notrace to prevent
+ * recursion and tracing preempt enabling caused by the tracing
+ * infrastructure itself. But as tracing can happen in areas coming
+ * from userspace or just about to enter userspace, a preempt enable
+ * can occur before user_exit() is called. This will cause the scheduler
+ * to be called when the system is still in usermode.
+ *
+ * To prevent this, the preempt_enable_notrace will use this function
+ * instead of preempt_schedule() to exit user context if needed before
+ * calling the scheduler.
+ */
+asmlinkage __visible void __sched notrace preempt_schedule_context(void)
+{
+	enum ctx_state prev_ctx;
+
+	if (likely(!preemptible()))
+		return;
+
+	do {
+		__preempt_count_add(PREEMPT_ACTIVE);
+		/*
+		 * Needs preempt disabled in case user_exit() is traced
+		 * and the tracer calls preempt_enable_notrace() causing
+		 * an infinite recursion.
+		 */
+		prev_ctx = exception_enter();
+		__schedule();
+		exception_exit(prev_ctx);
+
+		__preempt_count_sub(PREEMPT_ACTIVE);
+		barrier();
+	} while (need_resched());
+}
+EXPORT_SYMBOL_GPL(preempt_schedule_context);
+#endif /* CONFIG_CONTEXT_TRACKING */
+
 #endif /* CONFIG_PREEMPT */
 
 /*
