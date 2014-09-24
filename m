Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIXO6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:58:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaIXO57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:57:59 -0400
Date: Wed, 24 Sep 2014 07:57:05 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-66339c31bc3978d5fff9c4b4cb590a861def4db2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20140922183624.11015.71558.stgit@localhost>
References: <20140922183624.11015.71558.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use dl_bw_of() under RCU read lock
Git-Commit-ID: 66339c31bc3978d5fff9c4b4cb590a861def4db2
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

Commit-ID:  66339c31bc3978d5fff9c4b4cb590a861def4db2
Gitweb:     http://git.kernel.org/tip/66339c31bc3978d5fff9c4b4cb590a861def4db2
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 22 Sep 2014 22:36:24 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:09 +0200

sched: Use dl_bw_of() under RCU read lock

dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
Probability of use-after-free isn't zero here.

Also add lockdep assert into dl_bw_cpus().

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # v3.14+
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183624.11015.71558.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5b0eac9..f0adb03 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2021,6 +2021,8 @@ unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_SMP
 inline struct dl_bw *dl_bw_of(int i)
 {
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
@@ -2029,6 +2031,8 @@ static inline int dl_bw_cpus(int i)
 	struct root_domain *rd = cpu_rq(i)->rd;
 	int cpus = 0;
 
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	for_each_cpu_and(i, rd->span, cpu_active_mask)
 		cpus++;
 
@@ -7645,6 +7649,8 @@ static int sched_dl_global_constraints(void)
 	int cpu, ret = 0;
 	unsigned long flags;
 
+	rcu_read_lock();
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7666,6 +7672,8 @@ static int sched_dl_global_constraints(void)
 			break;
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
@@ -7681,6 +7689,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7691,6 +7700,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)
