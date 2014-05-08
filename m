Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaEHKrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:47:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaEHKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:47:45 -0400
Date: Thu, 8 May 2014 03:47:16 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-kf5suce6njh5xf5d3od13rr0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, nico@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, nico@linaro.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Avoid spurious wakeup IPIs
Git-Commit-ID: fd99f91aa007ba255aac44fe6cf21c1db398243a
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

Commit-ID:  fd99f91aa007ba255aac44fe6cf21c1db398243a
Gitweb:     http://git.kernel.org/tip/fd99f91aa007ba255aac44fe6cf21c1db398243a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 9 Apr 2014 15:35:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:58 +0200

sched/idle: Avoid spurious wakeup IPIs

Because mwait_idle_with_hints() gets called from !idle context it must
call current_clr_polling(). This however means that resched_task() is
very likely to send an IPI even when we were polling:

  CPU0					CPU1

  if (current_set_polling_and_test())
    goto out;

  __monitor(&ti->flags);
  if (!need_resched())
    __mwait(eax, ecx);
					set_tsk_need_resched(p);
					smp_mb();
out:
  current_clr_polling();
					if (!tsk_is_polling(p))
					  smp_send_reschedule(cpu);

So while it is correct (extra IPIs aren't a problem, whereas a missed
IPI would be) it is a performance problem (for some).

Avoid this issue by using fetch_or() to atomically set NEED_RESCHED
and test if POLLING_NRFLAG is set.

Since a CPU stuck in mwait is unlikely to modify the flags word,
contention on the cmpxchg is unlikely and thus we should mostly
succeed in a single go.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-kf5suce6njh5xf5d3od13rr0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1c9c3b7..4b82622 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -506,6 +506,39 @@ static inline void init_hrtick(void)
 #endif	/* CONFIG_SCHED_HRTICK */
 
 /*
+ * cmpxchg based fetch_or, macro so it works for different integer types
+ */
+#define fetch_or(ptr, val)						\
+({	typeof(*(ptr)) __old, __val = *(ptr);				\
+ 	for (;;) {							\
+ 		__old = cmpxchg((ptr), __val, __val | (val));		\
+ 		if (__old == __val)					\
+ 			break;						\
+ 		__val = __old;						\
+ 	}								\
+ 	__old;								\
+})
+
+#ifdef TIF_POLLING_NRFLAG
+/*
+ * Atomically set TIF_NEED_RESCHED and test for TIF_POLLING_NRFLAG,
+ * this avoids any races wrt polling state changes and thereby avoids
+ * spurious IPIs.
+ */
+static bool set_nr_and_not_polling(struct task_struct *p)
+{
+	struct thread_info *ti = task_thread_info(p);
+	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
+}
+#else
+static bool set_nr_and_not_polling(struct task_struct *p)
+{
+	set_tsk_need_resched(p);
+	return true;
+}
+#endif
+
+/*
  * resched_task - mark a task 'to be rescheduled now'.
  *
  * On UP this means the setting of the need_resched flag, on SMP it
@@ -521,17 +554,15 @@ void resched_task(struct task_struct *p)
 	if (test_tsk_need_resched(p))
 		return;
 
-	set_tsk_need_resched(p);
-
 	cpu = task_cpu(p);
+
 	if (cpu == smp_processor_id()) {
+		set_tsk_need_resched(p);
 		set_preempt_need_resched();
 		return;
 	}
 
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(p))
+	if (set_nr_and_not_polling(p))
 		smp_send_reschedule(cpu);
 }
 
