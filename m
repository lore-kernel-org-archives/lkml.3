Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaJ1V5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:57:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50928 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaJ1V5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: Remove "cpu" argument to rcu_pending()
Date: Tue, 28 Oct 2014 14:53:31 -0700
Message-Id: <1414533217-24910-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0029-0000-0000-000000F4ECA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because rcu_pending()'s argument is guaranteed to always be the current
CPU, drop the argument and replace per_cpu_ptr() with this_cpu_ptr().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3107811bba69..0670ba3a65d3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -325,7 +325,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 				  unsigned long *maxj),
 			 bool *isidle, unsigned long *maxj);
 static void force_quiescent_state(struct rcu_state *rsp);
-static int rcu_pending(int cpu);
+static int rcu_pending(void);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -2421,7 +2421,7 @@ void rcu_check_callbacks(int user)
 		rcu_bh_qs();
 	}
 	rcu_preempt_check_callbacks(smp_processor_id());
-	if (rcu_pending(smp_processor_id()))
+	if (rcu_pending())
 		invoke_rcu_core();
 	if (user)
 		rcu_note_voluntary_context_switch(current);
@@ -3144,12 +3144,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+static int rcu_pending(void)
 {
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		if (__rcu_pending(rsp, per_cpu_ptr(rsp->rda, cpu)))
+		if (__rcu_pending(rsp, this_cpu_ptr(rsp->rda)))
 			return 1;
 	return 0;
 }
-- 
1.8.1.5

