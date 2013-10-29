Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3J2OHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:07:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3J2OHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:07:49 -0400
Date: Tue, 29 Oct 2013 07:07:13 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-1ee14e6c8cddeeb8a490d7b54cd9016e4bb900b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131016181611.22647.80365.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181611.22647.80365.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix race on toggling cfs_bandwidth_used
Git-Commit-ID: 1ee14e6c8cddeeb8a490d7b54cd9016e4bb900b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ee14e6c8cddeeb8a490d7b54cd9016e4bb900b4
Gitweb:     http://git.kernel.org/tip/1ee14e6c8cddeeb8a490d7b54cd9016e4bb900b4
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Wed, 16 Oct 2013 11:16:12 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:19 +0100

sched: Fix race on toggling cfs_bandwidth_used

When we transition cfs_bandwidth_used to false, any currently
throttled groups will incorrectly return false from cfs_rq_throttled.
While tg_set_cfs_bandwidth will unthrottle them eventually, currently
running code (including at least dequeue_task_fair and
distribute_cfs_runtime) will cause errors.

Fix this by turning off cfs_bandwidth_used only after unthrottling all
cfs_rqs.

Tested: toggle bandwidth back and forth on a loaded cgroup. Caused
crashes in minutes without the patch, hasn't crashed with it.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181611.22647.80365.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  9 ++++++++-
 kernel/sched/fair.c  | 16 +++++++++-------
 kernel/sched/sched.h |  3 ++-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7c61f31..450a34b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7436,7 +7436,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 	runtime_enabled = quota != RUNTIME_INF;
 	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
-	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
+	/*
+	 * If we need to toggle cfs_bandwidth_used, off->on must occur
+	 * before making related changes, and on->off must occur afterwards
+	 */
+	if (runtime_enabled && !runtime_was_enabled)
+		cfs_bandwidth_usage_inc();
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
@@ -7462,6 +7467,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
+	if (runtime_was_enabled && !runtime_enabled)
+		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 813dd61..ebd187f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2845,13 +2845,14 @@ static inline bool cfs_bandwidth_used(void)
 	return static_key_false(&__cfs_bandwidth_used);
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled)
+void cfs_bandwidth_usage_inc(void)
 {
-	/* only need to count groups transitioning between enabled/!enabled */
-	if (enabled && !was_enabled)
-		static_key_slow_inc(&__cfs_bandwidth_used);
-	else if (!enabled && was_enabled)
-		static_key_slow_dec(&__cfs_bandwidth_used);
+	static_key_slow_inc(&__cfs_bandwidth_used);
+}
+
+void cfs_bandwidth_usage_dec(void)
+{
+	static_key_slow_dec(&__cfs_bandwidth_used);
 }
 #else /* HAVE_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
@@ -2859,7 +2860,8 @@ static bool cfs_bandwidth_used(void)
 	return true;
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+void cfs_bandwidth_usage_inc(void) {}
+void cfs_bandwidth_usage_dec(void) {}
 #endif /* HAVE_JUMP_LABEL */
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ffc7087..4e650ac 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1352,7 +1352,8 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
-extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern void cfs_bandwidth_usage_inc(void);
+extern void cfs_bandwidth_usage_dec(void);
 
 #ifdef CONFIG_NO_HZ_COMMON
 enum rq_nohz_flag_bits {
