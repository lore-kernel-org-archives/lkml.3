Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3EZVgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:36:15 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:44346 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3EZVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:36:10 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/8] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
Date: Sun, 26 May 2013 17:35:41 -0400
Message-Id: <1369604149-13016-3-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched/stats.h |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..8a0567f 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -162,6 +162,33 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
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
+	 * After turning over se.sum_exec_runtime's time accounting to
+	 * sig->sum_sched_runtime in __exit_signal(), a per-thread cputime
+	 * of the thread is going to be lost. We must not account exec_runtime
+	 * here too because we need to keep consistent cputime between
+	 * per-thread and per-process. Otherwise, the inconsistency is
+	 * observable when single thread program run.
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
@@ -176,7 +203,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -199,7 +226,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -222,7 +249,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-- 
1.7.1

