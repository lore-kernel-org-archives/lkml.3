Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3COQyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:54:19 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53134 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3COQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:54:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/4] posix_cpu_timers: Consolidate expired timers check
Date: Fri, 15 Mar 2013 17:54:01 +0100
Message-Id: <1363366442-11494-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the common code amongst per thread and per process
timers list on tick time.

List traversal, expiry check and subsequent updates can be
shared in a common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/posix-cpu-timers.c |  118 +++++++++++++--------------------------------
 1 files changed, 33 insertions(+), 85 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b30775f..edf94b6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -812,6 +812,28 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	}
 }
 
+static unsigned long long
+check_timers_list(struct list_head *timers,
+		  struct list_head *firing,
+		  unsigned long long curr)
+{
+	int maxfire = 20;
+
+	while (!list_empty(timers)) {
+		struct cpu_timer_list *t;
+
+		t = list_first_entry(timers, struct cpu_timer_list, entry);
+
+		if (!--maxfire || curr < t->expires)
+			return t->expires;
+
+		t->firing = 1;
+		list_move_tail(&t->entry, firing);
+	}
+
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them off
  * the tsk->cpu_timers[N] list onto the firing list.  Here we update the
@@ -820,54 +842,20 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 static void check_thread_timers(struct task_struct *tsk,
 				struct list_head *firing)
 {
-	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	struct task_cputime *tsk_expires = &tsk->cputime_expires;
+	unsigned long long expires;
 	unsigned long soft;
 
-	maxfire = 20;
-	tsk->cputime_expires.prof_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || prof_ticks(tsk) < t->expires) {
-			tsk->cputime_expires.prof_exp = expires_to_cputime(t->expires);
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(timers, firing, prof_ticks(tsk));
+	tsk_expires->prof_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.virt_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || virt_ticks(tsk) < t->expires) {
-			tsk->cputime_expires.virt_exp = expires_to_cputime(t->expires);
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(++timers, firing, virt_ticks(tsk));
+	tsk_expires->virt_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.sched_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires) {
-			tsk->cputime_expires.sched_exp = t->expires;
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	tsk_expires->sched_exp = check_timers_list(++timers, firing,
+						   tsk->se.sum_exec_runtime);
 
 	/*
 	 * Check for the special case thread timers.
@@ -967,7 +955,6 @@ static inline int task_cputime_zero(const struct task_cputime *cputime)
 static void check_process_timers(struct task_struct *tsk,
 				 struct list_head *firing)
 {
-	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
 	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
@@ -982,49 +969,10 @@ static void check_process_timers(struct task_struct *tsk,
 	utime = cputime_to_expires(cputime.utime);
 	ptime = utime + cputime_to_expires(cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
-	maxfire = 20;
-	prof_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || ptime < tl->expires) {
-			prof_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
 
-	++timers;
-	maxfire = 20;
-	virt_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || utime < tl->expires) {
-			virt_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
-
-	++timers;
-	maxfire = 20;
-	sched_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || sum_sched_runtime < tl->expires) {
-			sched_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
+	prof_expires = check_timers_list(timers, firing, ptime);
+	virt_expires = check_timers_list(++timers, firing, utime);
+	sched_expires = check_timers_list(++timers, firing, sum_sched_runtime);
 
 	/*
 	 * Check for the special case process timers.
-- 
1.7.5.4

