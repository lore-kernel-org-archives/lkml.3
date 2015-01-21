Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbbAUKKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:10:14 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56135 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbAUKIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:30 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/7] rcu: Wire ->rda pointers at compile time
Date: Wed, 21 Jan 2015 02:08:15 -0800
Message-Id: <1421834900-23987-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0029-0000-0000-000007595BE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit wires up the rcu_state structures' ->rda pointers to the
per-CPU rcu_data structures at compile time, thus ensuring that this
linkage is present at early boot, in turn allowing posting of callbacks
before rcu_init() is executed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9b5ed5333c9a..37193daf2b62 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -91,8 +91,10 @@ static const char *tp_##sname##_varname __used __tracepoint_string = sname##_var
 
 #define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
 DEFINE_RCU_TPS(sname) \
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, sname##_data); \
 struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
+	.rda = &sname##_data, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
 	.gpnum = 0UL - 300UL, \
@@ -104,8 +106,7 @@ struct rcu_state sname##_state = { \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
 	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
-}; \
-DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, sname##_data)
+}
 
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
@@ -3815,7 +3816,6 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 		}
 	}
 
-	rsp->rda = rda;
 	init_waitqueue_head(&rsp->gp_wq);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
-- 
1.8.1.5

