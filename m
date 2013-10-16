Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029Ab3JPSRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:17:01 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52222 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934978Ab3JPSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:16:15 -0400
Subject: [PATCH 1/5] sched: Fix race on toggling cfs_bandwidth_used
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:12 -0700
Message-ID: <20131016181611.22647.80365.stgit@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched/core.c  |    9 ++++++++-
 kernel/sched/fair.c  |   16 +++++++++-------
 kernel/sched/sched.h |    3 ++-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c3feeb..2d2ac236 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7433,7 +7433,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
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
@@ -7459,6 +7464,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
+	if (runtime_was_enabled && !runtime_enabled)
+		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4aa0b10..67c9ecf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2854,13 +2854,14 @@ static inline bool cfs_bandwidth_used(void)
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
@@ -2868,7 +2869,8 @@ static bool cfs_bandwidth_used(void)
 	return true;
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+void cfs_bandwidth_usage_inc(void) {}
+void cfs_bandwidth_usage_dec(void) {}
 #endif /* HAVE_JUMP_LABEL */
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d69cb32..d73761f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1334,7 +1334,8 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
-extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern void cfs_bandwidth_usage_inc(void);
+extern void cfs_bandwidth_usage_dec(void);
 
 #ifdef CONFIG_NO_HZ_COMMON
 enum rq_nohz_flag_bits {

