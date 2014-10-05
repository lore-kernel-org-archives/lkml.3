Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJEU0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaJEU0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:26:49 -0400
Date: Sun, 5 Oct 2014 22:23:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: [PATCH 1/1] stop the unbound recursion in
	preempt_schedule_context()
Message-ID: <20141005202322.GB27962@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003232631.GA3439@redhat.com> <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com> <CA+55aFxBAFMxAsSvgOcVuWy4FWH77E4NT8M3SYvQzxGBJ_qkHw@mail.gmail.com> <20141004003300.GA6297@redhat.com> <20141005202300.GA27962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005202300.GA27962@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/preempt.h |    1 +
 kernel/context_tracking.c      |   40 ---------------------------------------
 kernel/sched/core.c            |   41 ++++++++++++++++++++++++++++++++++++++++
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
index 9023f56..86980c5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2903,6 +2903,47 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
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
-- 
1.5.5.1


