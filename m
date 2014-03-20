Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbaCTLkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:40:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221AbaCTLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:39:59 -0400
Date: Thu, 20 Mar 2014 04:39:48 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-6201b4d61fbf194df6371fb3376c5026cb8f5eec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org>
References: <1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Remove code redundancy while calling get_nohz_timer_target()
Git-Commit-ID: 6201b4d61fbf194df6371fb3376c5026cb8f5eec
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

Commit-ID:  6201b4d61fbf194df6371fb3376c5026cb8f5eec
Gitweb:     http://git.kernel.org/tip/6201b4d61fbf194df6371fb3376c5026cb8f5eec
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 18 Mar 2014 16:26:07 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 20 Mar 2014 12:35:46 +0100

timer: Remove code redundancy while calling get_nohz_timer_target()

There are only two users of get_nohz_timer_target(): timer and hrtimer. Both
call it under same circumstances, i.e.

	#ifdef CONFIG_NO_HZ_COMMON
	       if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
	               return get_nohz_timer_target();
	#endif

So, it makes more sense to get all this as part of get_nohz_timer_target()
instead of duplicating code at two places. For this another parameter is
required to be passed to this routine, pinned.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |  6 +++++-
 kernel/hrtimer.c      | 15 +--------------
 kernel/sched/core.c   |  5 ++++-
 kernel/timer.c        |  7 +------
 4 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68a0e84..6f6c56f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -291,10 +291,14 @@ extern int runqueue_is_locked(int cpu);
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
-extern int get_nohz_timer_target(void);
+extern int get_nohz_timer_target(int pinned);
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
+static inline int get_nohz_timer_target(int pinned)
+{
+	return smp_processor_id();
+}
 #endif
 
 /*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0909436..d55092c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -168,19 +168,6 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 	}
 }
 
-
-/*
- * Get the preferred target CPU for NOHZ
- */
-static int hrtimer_get_target(int this_cpu, int pinned)
-{
-#ifdef CONFIG_NO_HZ_COMMON
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
-		return get_nohz_timer_target();
-#endif
-	return this_cpu;
-}
-
 /*
  * With HIGHRES=y we do not migrate the timer when it is expiring
  * before the next event on the target cpu because we cannot reprogram
@@ -214,7 +201,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
-	int cpu = hrtimer_get_target(this_cpu, pinned);
+	int cpu = get_nohz_timer_target(pinned);
 	int basenum = base->index;
 
 again:
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..c0339e2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -555,12 +555,15 @@ void resched_cpu(int cpu)
  * selecting an idle cpu will add more delays to the timers than intended
  * (as that cpu's timer base may not be uptodate wrt jiffies etc).
  */
-int get_nohz_timer_target(void)
+int get_nohz_timer_target(int pinned)
 {
 	int cpu = smp_processor_id();
 	int i;
 	struct sched_domain *sd;
 
+	if (pinned || !get_sysctl_timer_migration() || !idle_cpu(cpu))
+		return cpu;
+
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		for_each_cpu(i, sched_domain_span(sd)) {
diff --git a/kernel/timer.c b/kernel/timer.c
index 8e503fe..1d35dda 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -760,12 +760,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
-
-#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
-		cpu = get_nohz_timer_target();
-#endif
+	cpu = get_nohz_timer_target(pinned);
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
