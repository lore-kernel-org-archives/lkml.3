Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310Ab3BOBzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 20:55:49 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:33560 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab3BOBzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 20:55:48 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 14 Feb 2013 17:55:44 -0800
In-Reply-To: <1359399845-10568-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Mon, 28 Jan 2013 20:03:57 +0100")
Message-ID: <87k3qa7333.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> Ingo,
>
> Please pull the new full dynticks cputime accounting code that
> can be found at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	tags/full-dynticks-cputime-for-mingo
>
> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
> being u64 for reasonable nanosec granularity implementation. And therefore
> we need a single instruction fetch to read kernel cpustat for atomicity
> requirement against concurrent incrementation, which only 64 bit archs
> can provide.

Actually, moderately recent 32-bit ARMs can do atomic 64-bit load/stores
too.   

Also, is it just kernel_cpustat increments that need protection? or do
the various reads of the task_struct's cputime fields also need
protection (hmm, thinking twice, maybe those are already sufficiently
protected by the vtime_seqlock?)

> It's probably no big deal to solve this issue. What we need is simply some
> atomic accessors.

What about using the atomic64_* accessors?  Those would just use the
native loads/stores on arches that have them, otherwise
CONFIG_GENERIC_ATOMIC64 provides some fallbacks.

To give it a try, below is a quick patch to convert kernel_cpustat to
atomic64.  I only got as far as compile testing and basic boot testing
on a 32-bit ARM platform, but let me know if this is the right
direction.

> There is just no emergency though as this new option depends on the context
> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
> this set is complex enough already. I think we can deal with that later.

I've started working on the ARM version of the context_tracker, so
"later" is coming quickly and I will do what I can to help this along.

Kevin



>From 9881fc4b86a63244018a4bdb5a383f3b862a0b8b Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Thu, 14 Feb 2013 17:46:08 -0800
Subject: [PATCH] kernel_cpustat: convert to atomic 64-bit accessors

WIP: only compile tested and basic boot tested on 32-bit ARM platform
---
 fs/proc/stat.c              | 36 ++++++++++++++++++------------------
 fs/proc/uptime.c            |  2 +-
 include/linux/kernel_stat.h |  2 +-
 kernel/sched/cputime.c      | 22 +++++++++++-----------
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..2a4c723 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -52,7 +52,7 @@ static u64 get_idle_time(int cpu)
 
 	if (idle_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
-		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+		idle = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE]);
 	else
 		idle = usecs_to_cputime64(idle_time);
 
@@ -68,7 +68,7 @@ static u64 get_iowait_time(int cpu)
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
-		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+		iowait = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT]);
 	else
 		iowait = usecs_to_cputime64(iowait_time);
 
@@ -95,16 +95,16 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+		nice += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+		system += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		idle += get_idle_time(i);
 		iowait += get_iowait_time(i);
-		irq += kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq += kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+		softirq += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+		steal += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		guest += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST]);
+		guest_nice += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE]);
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -132,16 +132,16 @@ static int show_stat(struct seq_file *p, void *v)
 
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+		nice = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+		system = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+		softirq = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+		steal = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		guest = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST]);
+		guest_nice = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE]);
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 9610ac7..10c0f6e 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -18,7 +18,7 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 
 	idletime = 0;
 	for_each_possible_cpu(i)
-		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+		idletime += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ed5f6ed..45b9f71 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -32,7 +32,7 @@ enum cpu_usage_stat {
 };
 
 struct kernel_cpustat {
-	u64 cpustat[NR_STATS];
+	atomic64_t cpustat[NR_STATS];
 };
 
 struct kernel_stat {
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ccff275..c1ac2b2 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -125,7 +125,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	atomic64_add(tmp, &__get_cpu_var(kernel_cpustat).cpustat[index]);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 	if (unlikely(!cpuacct_subsys.active))
@@ -176,7 +176,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
 	p->utime += cputime;
@@ -186,11 +186,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_NICE]);
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_GUEST_NICE]);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_USER]);
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_GUEST]);
 	}
 }
 
@@ -250,9 +250,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 
-	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
+	atomic64_add((__force u64) cputime, &cpustat[CPUTIME_STEAL]);
 }
 
 /*
@@ -261,13 +261,13 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_IOWAIT]);
 	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_IDLE]);
 }
 
 static __always_inline bool steal_account_process_tick(void)
-- 
1.8.1.2

