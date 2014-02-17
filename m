Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaBQWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:08 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51097 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaBQWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 33/55] rcutorture: Clean up rcu_torture_init() error checking
Date: Mon, 17 Feb 2014 14:12:37 -0800
Message-Id: <1392675179-11560-33-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1344-0000-0000-000005D5BE19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies some simple cleanups to rcu_torture_init() error
checking.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 9f42d320531d..4402b95b376b 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1459,7 +1459,6 @@ rcu_torture_init(void)
 	int i;
 	int cpu;
 	int firsterr = 0;
-	int retval;
 	static struct rcu_torture_ops *torture_ops[] = {
 		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
 	};
@@ -1628,33 +1627,23 @@ rcu_torture_init(void)
 		for_each_possible_cpu(i) {
 			if (cpu_is_offline(i))
 				continue;  /* Heuristic: CPU can go offline. */
-			retval = rcutorture_booster_init(i);
-			if (retval < 0) {
-				firsterr = retval;
+			firsterr = rcutorture_booster_init(i);
+			if (firsterr)
 				goto unwind;
-			}
 		}
 	}
-	i = torture_shutdown_init(shutdown_secs, rcu_torture_cleanup);
-	if (i != 0) {
-		firsterr = i;
+	firsterr = torture_shutdown_init(shutdown_secs, rcu_torture_cleanup);
+	if (firsterr)
 		goto unwind;
-	}
-	i = torture_onoff_init(onoff_holdoff * HZ, onoff_interval * HZ);
-	if (i != 0) {
-		firsterr = i;
+	firsterr = torture_onoff_init(onoff_holdoff * HZ, onoff_interval * HZ);
+	if (firsterr)
 		goto unwind;
-	}
-	i = rcu_torture_stall_init();
-	if (i != 0) {
-		firsterr = i;
+	firsterr = rcu_torture_stall_init();
+	if (firsterr)
 		goto unwind;
-	}
-	retval = rcu_torture_barrier_init();
-	if (retval != 0) {
-		firsterr = retval;
+	firsterr = rcu_torture_barrier_init();
+	if (firsterr)
 		goto unwind;
-	}
 	if (object_debug)
 		rcu_test_debug_objects();
 	rcutorture_record_test_transition();
-- 
1.8.1.5

