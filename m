Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab3GDQq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:46:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:65134 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3GDQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:45 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
Date: Thu,  4 Jul 2013 18:46:25 +0200
Message-Id: <1372956385-25396-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
References: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When tsk->signal->cputimer->running is 1, signal->cputimer (i.e. per process
timer account) and tsk->sum_sched_runtime (i.e. per thread timer account)
increase at the same pace because update_curr() increases both accounting.

However, there is one exception. When thread exiting, __exit_signal() turns
over task's sum_shced_runtime to sig->sum_sched_runtime, but it doesn't stop
signal->cputimer accounting.

This inconsistency makes POSIX timer wake up too early. This patch fixes it.

Original-patch-by: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/stats.h |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..71bac97 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -162,6 +162,39 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
  */
 
 /**
+ * cputimer_running - return true if cputimer is running
+ *
+ * @tsk:	Pointer to target task.
+ */
+static inline bool cputimer_running(struct task_struct *tsk)
+
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+
+	if (!cputimer->running)
+		return false;
+
+	/*
+	 * After we flush the task's sum_exec_runtime to sig->sum_sched_runtime
+	 * in __exit_signal(), we won't account to the signal struct further
+	 * cputime consumed by that task, even though the task can still be
+	 * ticking after __exit_signal().
+	 *
+	 * In order to keep a consistent behaviour between thread group cputime
+	 * and thread group cputimer accounting, lets also ignore the cputime
+	 * elapsing after __exit_signal() in any thread group timer running.
+	 *
+	 * This makes sure that POSIX CPU clocks and timers are synchronized, so
+	 * that a POSIX CPU timer won't expire while the corresponding POSIX CPU
+	 * clock delta is behind the expiring timer value.
+	 */
+	if (unlikely(!tsk->sighand))
+		return false;
+
+	return true;
+}
+
+/**
  * account_group_user_time - Maintain utime for a thread group.
  *
  * @tsk:	Pointer to task structure.
@@ -176,7 +209,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -199,7 +232,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -222,7 +255,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-- 
1.7.5.4

