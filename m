Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3EZVhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:37:10 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:57477 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:37:05 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/8] posix-cpu-timers: timer functions should use timer time instead of clock time
Date: Sun, 26 May 2013 17:35:45 -0400
Message-Id: <1369604149-13016-7-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

For process timers, we use cpu_clock_sample_group() and cpu_timer_sample_group()
correctly. However, for thread timers, we always use cpu_clock_sample(). This is
wrong because a cpu_clock_sample() accounts uncommitted delta_exec too. And this
is inconsistent against run_posix_cpu_tiemrs().

This is not big matter because the following workaround code in
posix_cpu_timer_get() hides the timer miscalculation issue. However, it makes
rq lock held wrongly and it would be better to fix it.

  if (cpu_time_before(timer->it_clock, now, timer->it.cpu.expires)) {
    ...
  } else {
    /*
     * The timer should have expired already, but the firing
     * hasn't taken place yet.  Say it's just about to expire.
     */
     itp->it_value.tv_nsec = 1;
     itp->it_value.tv_sec = 0;

Cc: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/posix-cpu-timers.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index d068808..1b33c77 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -221,11 +221,10 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 }
 
 
-/*
- * Sample a per-thread clock for the given task.
- */
-static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
+static int do_cpu_clock_timer_sample(const clockid_t which_clock,
+				     struct task_struct *p,
+				     bool add_delta,
+				     union cpu_time_count *cpu)
 {
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
@@ -237,12 +236,30 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p, true);
+		cpu->sched = task_sched_runtime(p, add_delta);
 		break;
 	}
 	return 0;
 }
 
+/*
+ * Sample a per-thread clock for the given task.
+ */
+static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, true, cpu);
+}
+
+/*
+ * Sample a per-thread timer clock for the given task.
+ */
+static int cpu_timer_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, false, cpu);
+}
+
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
@@ -748,7 +765,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 * check if it's already passed.  In short, we need a sample.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &val);
+		cpu_timer_sample(timer->it_clock, p, &val);
 	} else {
 		cpu_timer_sample_group(timer->it_clock, p, &val);
 	}
@@ -804,7 +821,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * we need exact current time.
 		 */
 		if (CPUCLOCK_PERTHREAD(timer->it_clock))
-			now = val;
+			cpu_clock_sample(timer->it_clock, p, &now);
 		else
 			cpu_clock_sample_group(timer->it_clock, p, &now);
 		cpu_time_add(timer->it_clock, &new_expires, now);
@@ -894,7 +911,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	 * Sample the clock to take the difference with the expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &now);
+		cpu_timer_sample(timer->it_clock, p, &now);
 		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
@@ -1203,7 +1220,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &now);
+		cpu_timer_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		if (unlikely(p->exit_state)) {
 			clear_dead_task(timer, now);
-- 
1.7.1

