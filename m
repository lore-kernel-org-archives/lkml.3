Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab3IYBax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:30:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53562 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab3IYB3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/11] rcu: Micro-optimize rcu_cpu_has_callbacks()
Date: Tue, 24 Sep 2013 18:29:18 -0700
Message-Id: <1380072561-31134-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-7182-0000-0000-000008839849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The for_each_rcu_flavor() loop unconditionally scans all flavors, even
when the first flavor might have some non-lazy callbacks.  Once the
loop has seen a non-lazy callback, further passes through the loop
cannot change the state.  This is not a huge problem, given that there
can be at most three RCU flavors (RCU-bh, RCU-preempt, and RCU-sched),
but this code is on the path to idle, so speeding it up even a small
amount would have some benefit.

This commit therefore does two things:

1.	Rearranges the order of the list of RCU flavors in order to
	place the most active flavor first in the list.  The most active
	RCU flavor is RCU-preempt, or, if there is no RCU-preempt,
	RCU-sched.

2.	Reworks the for_each_rcu_flavor() to exit early when the first
	non-lazy callback is seen, or, in the case where the caller
	does not care about non-lazy callbacks (RCU_FAST_NO_HZ=n),
	when the first callback is seen.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e6f2e8f..49464ad 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2727,10 +2727,13 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 
 	for_each_rcu_flavor(rsp) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (rdp->qlen != rdp->qlen_lazy)
+		if (!rdp->nxtlist)
+			continue;
+		hc = true;
+		if (rdp->qlen != rdp->qlen_lazy || !all_lazy) {
 			al = false;
-		if (rdp->nxtlist)
-			hc = true;
+			break;
+		}
 	}
 	if (all_lazy)
 		*all_lazy = al;
@@ -3297,8 +3300,8 @@ void __init rcu_init(void)
 
 	rcu_bootup_announce();
 	rcu_init_geometry();
-	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
+	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
-- 
1.8.1.5

