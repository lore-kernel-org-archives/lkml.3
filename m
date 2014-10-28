Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaJ1WdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:33:02 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60960 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaJ1W1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:27:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/7] rcu: Fix for rcuo online-time-creation reorganization bug
Date: Tue, 28 Oct 2014 15:23:02 -0700
Message-Id: <1414534982-29203-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F50641
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit 35ce7f29a44a (rcu: Create rcuo kthreads only for onlined CPUs)
contains checks for the case where CPUs are brought online out of
order, re-wiring the rcuo leader-follower relationships as needed.
Unfortunately, this rewiring was broken.  This apparently went undetected
due to the tendency of systems to bring CPUs online in order.  This commit
nevertheless fixes the rewiring.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6d07fb402e84..5053dae4454e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2586,9 +2586,13 @@ static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
 			rdp->nocb_leader = rdp_spawn;
 			if (rdp_last && rdp != rdp_spawn)
 				rdp_last->nocb_next_follower = rdp;
-			rdp_last = rdp;
-			rdp = rdp->nocb_next_follower;
-			rdp_last->nocb_next_follower = NULL;
+			if (rdp == rdp_spawn) {
+				rdp = rdp->nocb_next_follower;
+			} else {
+				rdp_last = rdp;
+				rdp = rdp->nocb_next_follower;
+				rdp_last->nocb_next_follower = NULL;
+			}
 		} while (rdp);
 		rdp_spawn->nocb_next_follower = rdp_old_leader;
 	}
-- 
1.8.1.5

