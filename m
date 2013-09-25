Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3IYBua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:50:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50086 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3IYBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/6] rcu: Remove redundant code from rcu_cleanup_after_idle()
Date: Tue, 24 Sep 2013 18:50:11 -0700
Message-Id: <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130925014954.GA32109@linux.vnet.ibm.com>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-8236-0000-0000-0000021246C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_try_advance_all_cbs() function returns a bool saying whether or
not there are callbacks ready to invoke, but rcu_cleanup_after_idle()
rechecks this regardless.  This commit therefore uses the value returned
by rcu_try_advance_all_cbs() instead of making rcu_cleanup_after_idle()
do this recheck.

Reported-by: Tibor Billes <tbilles@gmx.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Tibor Billes <tbilles@gmx.com>
---
 kernel/rcutree_plugin.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 130c97b..18d9c91 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1768,17 +1768,11 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	struct rcu_data *rdp;
-	struct rcu_state *rsp;
 
 	if (rcu_is_nocb_cpu(cpu))
 		return;
-	rcu_try_advance_all_cbs();
-	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (cpu_has_callbacks_ready_to_invoke(rdp))
-			invoke_rcu_core();
-	}
+	if (rcu_try_advance_all_cbs())
+		invoke_rcu_core();
 }
 
 /*
-- 
1.8.1.5

