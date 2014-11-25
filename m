Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaKYLcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:32:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58530 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaKYKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <ktkhai@parallels.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 098/254] sched: Use dl_bw_of() under RCU read lock
Date: Tue, 25 Nov 2014 10:37:28 +0000
Message-Id: <1416912004-5928-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <ktkhai@parallels.com>

commit 66339c31bc3978d5fff9c4b4cb590a861def4db2 upstream.

dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
Probability of use-after-free isn't zero here.

Also add lockdep assert into dl_bw_cpus().

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183624.11015.71558.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0acf96b790c5..169720f46c30 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1969,6 +1969,8 @@ unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_SMP
 inline struct dl_bw *dl_bw_of(int i)
 {
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
@@ -1977,6 +1979,8 @@ static inline int dl_bw_cpus(int i)
 	struct root_domain *rd = cpu_rq(i)->rd;
 	int cpus = 0;
 
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	for_each_cpu_and(i, rd->span, cpu_active_mask)
 		cpus++;
 
@@ -7541,6 +7545,8 @@ static int sched_dl_global_constraints(void)
 	int cpu, ret = 0;
 	unsigned long flags;
 
+	rcu_read_lock();
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7562,6 +7568,8 @@ static int sched_dl_global_constraints(void)
 			break;
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
@@ -7577,6 +7585,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7587,6 +7596,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)
-- 
2.1.0

