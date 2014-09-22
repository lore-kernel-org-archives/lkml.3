Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaIVScY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:32:24 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:44656 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaIVScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:32:20 -0400
X-Yandex-Uniq: 6d46388b-46ee-47f9-b35f-e148f85e49ed
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 3/6] sched: Use dl_bw_of() under RCU read lock
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:32:16 +0400
Message-ID: <20140922183216.10761.27458.stgit@localhost>
In-Reply-To: <20140922183202.10761.6682.stgit@localhost>
References: <20140922183202.10761.6682.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
Probability of use-after-free isn't zero here.

Also add lockdep assert into dl_bw_cpus().

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: <stable@vger.kernel.org> # v3.14+
---
 kernel/sched/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5b864e9..a300fce 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1989,6 +1989,8 @@ unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_SMP
 inline struct dl_bw *dl_bw_of(int i)
 {
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
@@ -1997,6 +1999,8 @@ static inline int dl_bw_cpus(int i)
 	struct root_domain *rd = cpu_rq(i)->rd;
 	int cpus = 0;
 
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	for_each_cpu_and(i, rd->span, cpu_active_mask)
 		cpus++;
 
@@ -7623,6 +7627,8 @@ static int sched_dl_global_constraints(void)
 	int cpu, ret = 0;
 	unsigned long flags;
 
+	rcu_read_lock();
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7644,6 +7650,8 @@ static int sched_dl_global_constraints(void)
 			break;
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
@@ -7659,6 +7667,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7669,6 +7678,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)

