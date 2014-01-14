Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaANA0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANA01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3.4 24/27] sched: Fix race on toggling cfs_bandwidth_used
Date: Mon, 13 Jan 2014 16:26:38 -0800
Message-Id: <20140114002624.065013790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Segall <bsegall@google.com>

commit 1ee14e6c8cddeeb8a490d7b54cd9016e4bb900b4 upstream.

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
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c  |    9 ++++++++-
 kernel/sched/fair.c  |   16 +++++++++-------
 kernel/sched/sched.h |    3 ++-
 3 files changed, 19 insertions(+), 9 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7906,7 +7906,12 @@ static int tg_set_cfs_bandwidth(struct t
 
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
@@ -7932,6 +7937,8 @@ static int tg_set_cfs_bandwidth(struct t
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
+	if (runtime_was_enabled && !runtime_enabled)
+		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1393,13 +1393,14 @@ static inline bool cfs_bandwidth_used(vo
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
@@ -1407,7 +1408,8 @@ static bool cfs_bandwidth_used(void)
 	return true;
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+void cfs_bandwidth_usage_inc(void) {}
+void cfs_bandwidth_usage_dec(void) {}
 #endif /* HAVE_JUMP_LABEL */
 
 /*
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1140,7 +1140,8 @@ extern void init_cfs_rq(struct cfs_rq *c
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
-extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern void cfs_bandwidth_usage_inc(void);
+extern void cfs_bandwidth_usage_dec(void);
 
 #ifdef CONFIG_NO_HZ
 enum rq_nohz_flag_bits {


