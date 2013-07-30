Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3G3ISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:18:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38486 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab3G3IR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:17:57 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-b4-51f776b2901d
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, peterz@infradead.org, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: [PATCH RFC 2/3] Add power consumption counter in task_struct.
Date: Tue, 30 Jul 2013 12:17:38 +0400
Message-id: <1375172259-9641-3-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
References: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xq7qbyr4HGhzYI2cxZ/0aNou159qZ
	LFZcPcJoMXXhYXaL3gVX2SzONr1ht7i8aw6bxedeoMSlAwuYLI73HmCy6F/Yy2Sx8auHA4/H
	5hVaHneu7WHzODHjN4vH+31X2Tz6tqxi9Hi0uIXR4/MmuQD2KC6blNSczLLUIn27BK6MaRev
	sRYsV61ovdDI1MB4Va6LkYNDQsBEYuM7pi5GTiBTTOLCvfVsXYxcHEICSxklPi39zQrhdDNJ
	3Jw7nQWkig2oYffei8wgCRGBxYwSy25OAmtnFmhilPh3ogjEFhZwk7jecZ4NxGYRUJVY1rqR
	EcTmBYovmnCfHWKzgsScSTYgYU4Bd4mWY8eYQWwhoJJrZ1YwTmDkXcDIsIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJCy/7mBceszqEKMAB6MSDy9H8bdAIdbEsuLK3EOMEhzMSiK8LDeA
	QrwpiZVVqUX58UWlOanFhxiZODilGhilZod8SF1d1f3BKGfHXBWJ5eUPph3+tCGA6yLnKQX/
	aRJ7Wbe42+4U+sGrvf/sn/hJfMGbjh7YdXPq16ynTMVPQ18zzXCd0Cly3b4nRtN+/fsdhhLy
	Z8zf1E2eePOXBG9Bf7d6V/D/ldmL1MzTr7Q1BLfs6n7o4Kopc+rOkqORVrPF3vs+tFmqxFKc
	kWioxVxUnAgAdsnOWSkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
---
 include/linux/sched.h          |    2 ++
 include/uapi/linux/taskstats.h |    2 ++
 kernel/fork.c                  |    1 +
 kernel/sched/core.c            |    8 ++++++++
 kernel/sched/cputime.c         |   11 +++++++++++
 kernel/tsacct.c                |    3 +++
 6 files changed, 27 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cdd5407..f074718 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1157,6 +1157,8 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	cputime_t utime, stime, utimescaled, stimescaled;
+	u64 utime_power_cons;
+	u64 stime_power_cons;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
diff --git a/include/uapi/linux/taskstats.h b/include/uapi/linux/taskstats.h
index 2466e55..02ac708 100644
--- a/include/uapi/linux/taskstats.h
+++ b/include/uapi/linux/taskstats.h
@@ -116,6 +116,8 @@ struct taskstats {
 					/* Elapsed time [usec] */
 	__u64	ac_utime;		/* User CPU time [usec] */
 	__u64	ac_stime;		/* SYstem CPU time [usec] */
+	__u64   ac_utime_power_cons;	/* User CPU time power consumption */
+	__u64   ac_stime_power_cons;	/* System CPU time power consumption */
 	__u64	ac_minflt;		/* Minor Page Fault Count */
 	__u64	ac_majflt;		/* Major Page Fault Count */
 	/* Basic Accounting Fields end */
diff --git a/kernel/fork.c b/kernel/fork.c
index 6e6a1c1..a021d5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1240,6 +1240,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
+	p->utime_power_cons = p->stime_power_cons = 0;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9b1f2e5..cac73d7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -73,6 +73,7 @@
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
 #include <linux/context_tracking.h>
+#include <linux/cpufreq.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -297,6 +298,13 @@ __read_mostly int scheduler_running;
 int sysctl_sched_rt_runtime = 950000;
 
 
+static u64 cpu_power_cons(cputime_t cputime)
+{
+	struct thread_info *ti = current_thread_info();
+
+	return cpu_power_get(ti->cpu) * cputime;
+}
+
 
 /*
  * __task_rq_lock - lock the rq @p resides on.
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a7959e0..512727d 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -4,6 +4,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/static_key.h>
 #include <linux/context_tracking.h>
+#include <linux/cpufreq.h>
 #include "sched.h"
 
 
@@ -126,6 +127,13 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	cpuacct_account_field(p, index, tmp);
 }
 
+static u64 cpu_power_cons(cputime_t cputime)
+{
+	struct thread_info *ti = current_thread_info();
+
+	return cpu_power_get(ti->cpu) * cputime;
+}
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -138,6 +146,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	int index;
 
 	/* Add user time to process. */
+	p->utime_power_cons += cpu_power_cons(cputime);
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
@@ -163,6 +172,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
+	p->utime_power_cons += cpu_power_cons(cputime);
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
@@ -190,6 +200,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 			cputime_t cputime_scaled, int index)
 {
 	/* Add system time to process. */
+	p->stime_power_cons += cpu_power_cons(cputime);
 	p->stime += cputime;
 	p->stimescaled += cputime_scaled;
 	account_group_system_time(p, cputime);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index a1dd9a1..cea4a9c 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -75,6 +75,9 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_utimescaled = cputime_to_usecs(utimescaled);
 	stats->ac_stimescaled = cputime_to_usecs(stimescaled);
 
+	stats->ac_utime_power_cons = tsk->utime_power_cons;
+	stats->ac_stime_power_cons = tsk->stime_power_cons;
+
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
-- 
1.7.9.5

