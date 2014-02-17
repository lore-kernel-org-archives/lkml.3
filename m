Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaBQWSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:18:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54998 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaBQWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:21 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 43/55] rcutorture: Add an rcu_busted to test the test
Date: Mon, 17 Feb 2014 14:12:47 -0800
Message-Id: <1392675179-11560-43-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDCE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a deliberately buggy RCU implementation into rcutorture
to allow easy checking that rcutorture correctly flags buggy RCU
implementations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 81b8cc795a07..d7944a465850 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -370,6 +370,48 @@ static struct rcu_torture_ops rcu_bh_ops = {
 };
 
 /*
+ * Don't even think about trying any of these in real life!!!
+ * The names includes "busted", and they really means it!
+ * The only purpose of these functions is to provide a buggy RCU
+ * implementation to make sure that rcutorture correctly emits
+ * buggy-RCU error messages.
+ */
+static void rcu_busted_torture_deferred_free(struct rcu_torture *p)
+{
+	/* This is a deliberate bug for testing purposes only! */
+	rcu_torture_cb(&p->rtort_rcu);
+}
+
+static void synchronize_rcu_busted(void)
+{
+	/* This is a deliberate bug for testing purposes only! */
+}
+
+static void
+call_rcu_busted(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	/* This is a deliberate bug for testing purposes only! */
+	func(head);
+}
+
+static struct rcu_torture_ops rcu_busted_ops = {
+	.init		= rcu_sync_torture_init,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_busted_torture_deferred_free,
+	.sync		= synchronize_rcu_busted,
+	.exp_sync	= synchronize_rcu_busted,
+	.call		= call_rcu_busted,
+	.cb_barrier	= NULL,
+	.fqs		= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_busted"
+};
+
+/*
  * Definitions for srcu torture testing.
  */
 
@@ -1369,7 +1411,7 @@ rcu_torture_init(void)
 	int cpu;
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] = {
-		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
+		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
 	};
 
 	torture_init_begin(torture_type, verbose, &rcutorture_runnable);
-- 
1.8.1.5

