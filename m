Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab3GDQr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:47:59 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:57179 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3GDQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] posix_cpu_timers: consolidate expired timers check
Date: Thu,  4 Jul 2013 18:46:21 +0200
Message-Id: <1372956385-25396-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
References: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the common code amongst per thread and per process timers list
on tick time.

List traversal, expiry check and subsequent updates can be shared in a
common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |  118 +++++++++++++--------------------------------
 1 files changed, 33 insertions(+), 85 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b1450ce..92a4fbf 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -862,6 +862,28 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
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
@@ -870,54 +892,20 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
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
@@ -1002,7 +990,6 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 static void check_process_timers(struct task_struct *tsk,
 				 struct list_head *firing)
 {
-	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
 	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
@@ -1017,49 +1004,10 @@ static void check_process_timers(struct task_struct *tsk,
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

