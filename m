Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaD2AdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:33:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52015 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 30/45] rcutorture: Make rcu_torture_reader() use cond_resched()
Date: Mon, 28 Apr 2014 17:25:18 -0700
Message-Id: <1398731133-18925-30-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64A88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_torture_reader() function currently uses schedule().  This commit
therefore speeds things up a bit by substituting cond_resched().
This change makes rcu_torture_reader() more CPU-bound, so this commit
also adjusts the number of readers (the "nreaders" module parameter,
which feeds into the "nrealreaders" variable) to allow one CPU to be
free of readers on SMP systems.  The point of this is to increase the
probability that readers will be watching while an updater makes a change.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 15af04177e7e..ea8af005ea3f 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -941,7 +941,7 @@ rcu_torture_reader(void *arg)
 		__this_cpu_inc(rcu_torture_batch[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
-		schedule();
+		cond_resched();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
 	if (irqreader && cur_ops->irq_capable)
@@ -1481,10 +1481,13 @@ rcu_torture_init(void)
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
-	if (nreaders >= 0)
+	if (nreaders >= 0) {
 		nrealreaders = nreaders;
-	else
-		nrealreaders = 2 * num_online_cpus();
+	} else {
+		nrealreaders = num_online_cpus() - 1;
+		if (nrealreaders <= 0)
+			nrealreaders = 1;
+	}
 	rcu_torture_print_module_parms(cur_ops, "Start of test");
 
 	/* Set up the freelist. */
-- 
1.8.1.5

