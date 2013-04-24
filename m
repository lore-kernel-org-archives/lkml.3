Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3DXAoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:44:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33251 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3DXAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:44:10 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 3/4] rcu: Make call_rcu() leak callbacks for debug-object errors
Date: Tue, 23 Apr 2013 17:33:45 -0700
Message-Id: <1366763626-16712-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366763626-16712-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130424003312.GA15819@linux.vnet.ibm.com>
 <1366763626-16712-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042400-5406-0000-0000-000007D50531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If someone does a duplicate call_rcu(), the worst thing the second
call_rcu() could do would be to actually queue the callback the second
time because doing so corrupts whatever list the callback was already
queued on.  This commit therefore makes __call_rcu() check the new
return value from debug-objects and leak the callback upon error.
This commit also substitutes rcu_leak_callback() for whatever callback
function was previously in place in order to avoid freeing the callback
out from under any readers that might still be referencing it.

These changes increase the probability that the debug-objects error
messages will actually make it somewhere visible.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/rcu.h     | 10 +++++++---
 kernel/rcutree.c | 14 +++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 7f8e759..ad6c3f5 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -67,12 +67,15 @@
 
 extern struct debug_obj_descr rcuhead_debug_descr;
 
-static inline void debug_rcu_head_queue(struct rcu_head *head)
+static inline int debug_rcu_head_queue(struct rcu_head *head)
 {
-	debug_object_activate(head, &rcuhead_debug_descr);
+	int r1;
+
+	r1 = debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
 				  STATE_RCU_HEAD_QUEUED);
+	return r1;
 }
 
 static inline void debug_rcu_head_unqueue(struct rcu_head *head)
@@ -83,8 +86,9 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 	debug_object_deactivate(head, &rcuhead_debug_descr);
 }
 #else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-static inline void debug_rcu_head_queue(struct rcu_head *head)
+static inline int debug_rcu_head_queue(struct rcu_head *head)
 {
+	return 0;
 }
 
 static inline void debug_rcu_head_unqueue(struct rcu_head *head)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d226e55..df3094c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2276,6 +2276,13 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 }
 
 /*
+ * RCU callback function to leak a callback.
+ */
+static void rcu_leak_callback(struct rcu_head *rhp)
+{
+}
+
+/*
  * Helper function for call_rcu() and friends.  The cpu argument will
  * normally be -1, indicating "currently running CPU".  It may specify
  * a CPU only if that CPU is a no-CBs CPU.  Currently, only _rcu_barrier()
@@ -2289,7 +2296,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	struct rcu_data *rdp;
 
 	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
-	debug_rcu_head_queue(head);
+	if (debug_rcu_head_queue(head)) {
+		/* Probable double call_rcu(), so leak the callback. */
+		ACCESS_ONCE(head->func) = rcu_leak_callback;
+		WARN_ONCE(1, "__call_rcu(): Leaked duplicate callback\n");
+		return;
+	}
 	head->func = func;
 	head->next = NULL;
 
-- 
1.8.1.5

