Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab3IYBox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:44:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36950 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab3IYBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/10] rcu: Track rcu_nocb_kthread()'s sleeping and awakening
Date: Tue, 24 Sep 2013 18:42:37 -0700
Message-Id: <1380073359-31959-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001DBA009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds event traces to track all of rcu_nocb_kthread()'s
blocking and awakening.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |  4 ++++
 kernel/rcutree_plugin.h    | 15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 4301cd9..a087d82 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -183,8 +183,12 @@ TRACE_EVENT(rcu_grace_period_init,
  *	"WakeOvf": Wake rcuo kthread, CB list is huge.
  *	"WakeNot": Don't wake rcuo kthread.
  *	"WakeNotPoll": Don't wake rcuo kthread because it is polling.
+ *	"Poll": Start of new polling cycle for rcu_nocb_poll.
+ *	"Sleep": Sleep waiting for CBs for !rcu_nocb_poll.
  *	"WokeEmpty": rcuo kthread woke to find empty list.
  *	"WokeNonEmpty": rcuo kthread woke to find non-empty list.
+ *	"WaitQueue": Enqueue partially done, timed wait for it to complete.
+ *	"WokeQueue": Partial enqueue now complete.
  */
 TRACE_EVENT(rcu_nocb_wake,
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 24b01b6..21205b1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2230,6 +2230,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 static int rcu_nocb_kthread(void *arg)
 {
 	int c, cl;
+	bool firsttime = 1;
 	struct rcu_head *list;
 	struct rcu_head *next;
 	struct rcu_head **tail;
@@ -2238,8 +2239,15 @@ static int rcu_nocb_kthread(void *arg)
 	/* Each pass through this loop invokes one batch of callbacks */
 	for (;;) {
 		/* If not polling, wait for next batch of callbacks. */
-		if (!rcu_nocb_poll)
+		if (!rcu_nocb_poll) {
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("Sleep"));
 			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
+		} else if (firsttime) {
+			firsttime = 0;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("Poll"));
+		}
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
 			if (!rcu_nocb_poll)
@@ -2249,6 +2257,7 @@ static int rcu_nocb_kthread(void *arg)
 			flush_signals(current);
 			continue;
 		}
+		firsttime = 1;
 		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 				    TPS("WokeNonEmpty"));
 
@@ -2271,7 +2280,11 @@ static int rcu_nocb_kthread(void *arg)
 			next = list->next;
 			/* Wait for enqueuing to complete, if needed. */
 			while (next == NULL && &list->next != tail) {
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WaitQueue"));
 				schedule_timeout_interruptible(1);
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WokeQueue"));
 				next = list->next;
 			}
 			debug_rcu_head_unqueue(list);
-- 
1.8.1.5

