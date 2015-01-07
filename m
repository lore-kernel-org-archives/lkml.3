Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbbAGRgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:36:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41828 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbbAGRcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/14] rcu: Don't initiate RCU priority boosting on root rcu_node
Date: Wed,  7 Jan 2015 09:32:28 -0800
Message-Id: <1420651953-2651-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0013-0000-0000-000007B50666
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because there is no longer any preempted tasks on the root rcu_node, and
because there is no longer ever an rcub kthread for the root rcu_node,
this commit drops the code in force_qs_rnp() that attempts to awaken
the non-existent root rcub kthread.  This is strictly a performance
enhancement, removing a root rcu_node ->lock acquisition and release
along with some tests in rcu_initiate_boost(), ending with the test that
notes that there is no rcub kthread.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 990b406faf4e..5a0a4c969d38 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2513,12 +2513,6 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
-	rnp = rcu_get_root(rsp);
-	if (rnp->qsmask == 0) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
-		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
-	}
 }
 
 /*
-- 
1.8.1.5

