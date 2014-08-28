Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaH1S1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54568 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaH1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/15] rcu: Replace flush_signals() with WARN_ON(signal_pending())
Date: Thu, 28 Aug 2014 11:26:33 -0700
Message-Id: <1409250394-25159-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-0928-0000-0000-00000467DC1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, when RCU awakens from a wait_event_interruptible() that
might have awakened prematurely, it does a flush_signals(). This is
done on the off-chance that someone figured out how to deliver a signal
to a kthread, which is supposed to be impossible.  Given that this
is supposed to be impossible, this commit changes the flush_signals()
calls into WARN_ON(signal_pending()).

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 4 ++--
 kernel/rcu/tree_plugin.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9e83cd9a32f1..3e002c1cb441 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1796,7 +1796,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			if (rcu_gp_init(rsp))
 				break;
 			cond_resched();
-			flush_signals(current);
+			WARN_ON(signal_pending(current));
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwaitsig"));
@@ -1842,7 +1842,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			} else {
 				/* Deal with stray signal. */
 				cond_resched();
-				flush_signals(current);
+				WARN_ON(signal_pending(current));
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqswaitsig"));
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a1af86099a67..ce62cf3de2a2 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2237,7 +2237,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
 		if (likely(d))
 			break;
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		trace_rcu_future_gp(rnp, rdp, c, TPS("ResumeWait"));
 	}
 	trace_rcu_future_gp(rnp, rdp, c, TPS("EndWait"));
@@ -2296,7 +2296,7 @@ wait_again:
 		if (!rcu_nocb_poll)
 			trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu,
 					    "WokeEmpty");
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		schedule_timeout_interruptible(1);
 
 		/* Rescan in case we were a victim of memory ordering. */
@@ -2375,7 +2375,7 @@ static void nocb_follower_wait(struct rcu_data *rdp)
 		if (!rcu_nocb_poll)
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    "WokeEmpty");
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		schedule_timeout_interruptible(1);
 	}
 }
-- 
1.8.1.5

