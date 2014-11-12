Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866AbaKLBjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:39:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbaKLBjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:39:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <ktkhai@parallels.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 043/203] sched: Use dl_bw_of() under RCU read lock
Date: Wed, 12 Nov 2014 10:15:13 +0900
Message-Id: <20141112011544.688355045@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1895,6 +1895,8 @@ unsigned long to_ratio(u64 period, u64 r
 #ifdef CONFIG_SMP
 inline struct dl_bw *dl_bw_of(int i)
 {
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
@@ -1903,6 +1905,8 @@ static inline int dl_bw_cpus(int i)
 	struct root_domain *rd = cpu_rq(i)->rd;
 	int cpus = 0;
 
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	for_each_cpu_and(i, rd->span, cpu_active_mask)
 		cpus++;
 
@@ -7458,6 +7462,8 @@ static int sched_dl_global_constraints(v
 	int cpu, ret = 0;
 	unsigned long flags;
 
+	rcu_read_lock();
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7479,6 +7485,8 @@ static int sched_dl_global_constraints(v
 			break;
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
@@ -7494,6 +7502,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7504,6 +7513,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)


