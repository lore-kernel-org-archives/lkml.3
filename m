Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaBMPvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:51:40 -0500
Received: from relay.parallels.com ([195.214.232.42]:49894 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaBMPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:51:39 -0500
Message-ID: <1392306716.5384.3.camel@tkhai>
Subject: [PATCH] sched/core: Create new task with twice disabled preemption
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Thu, 13 Feb 2014 19:51:56 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preemption state on enter in finish_task_switch() is different
in cases of context_switch() and schedule_tail().

In the first case we have it twice disabled: at the start of
schedule() and during spin locking. In the second it is only
once: the value which was set in init_task_preempt_count().

For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
that all newly created tasks execute finish_arch_post_lock_switch()
and post_schedule() with preemption enabled.

It seems there is possible a problem in rare situations on arm64,
when one freshly created thread preempts another before
finish_arch_post_lock_switch() has finished. If mm is the same,
then TIF_SWITCH_MM on the second won't be set.

The second rare but possible issue is zeroing of post_schedule()
on a wrong cpu.

So, lets fix this and unify preempt_count state.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/preempt.h |    6 ++++--
 include/asm-generic/preempt.h  |    6 ++++--
 include/linux/sched.h          |    2 ++
 kernel/sched/core.c            |    6 ++----
 4 files changed, 12 insertions(+), 8 deletions(-)
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index c8b0519..07fdf52 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -32,9 +32,11 @@ static __always_inline void preempt_count_set(int pc)
  */
 #define task_preempt_count(p) \
 	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
-
+/*
+ * Disable it twice to enter schedule_tail() with preemption disabled.
+ */
 #define init_task_preempt_count(p) do { \
-	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED; \
+	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED_TWICE; \
 } while (0)
 
 #define init_idle_preempt_count(p, cpu) do { \
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 1cd3f5d..0f67846 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -25,9 +25,11 @@ static __always_inline void preempt_count_set(int pc)
  */
 #define task_preempt_count(p) \
 	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
-
+/*
+ * Disable it twice to enter schedule_tail() with preemption disabled.
+ */
 #define init_task_preempt_count(p) do { \
-	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
+	task_thread_info(p)->preempt_count = PREEMPT_DISABLED_TWICE; \
 } while (0)
 
 #define init_idle_preempt_count(p, cpu) do { \
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c49a258..f6a6c1e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -520,8 +520,10 @@ struct task_cputime {
 
 #ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
+#define PREEMPT_DISABLED_TWICE	(2 + PREEMPT_ENABLED)
 #else
 #define PREEMPT_DISABLED	PREEMPT_ENABLED
+#define PREEMPT_DISABLED_TWICE	PREEMPT_ENABLED
 #endif
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fb9764f..18aa7f2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2203,12 +2203,10 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 
 	finish_task_switch(rq, prev);
 
-	/*
-	 * FIXME: do we need to worry about rq being invalidated by the
-	 * task_switch?
-	 */
 	post_schedule(rq);
 
+	preempt_enable();
+
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	/* In this case, finish_task_switch does not reenable preemption */
 	preempt_enable();


