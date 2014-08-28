Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaH1SlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:41:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60889 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaH1Sih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/14] rcu: Handle NOCB callbacks from irq-disabled idle code
Date: Thu, 28 Aug 2014 11:38:16 -0700
Message-Id: <1409251097-26734-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-9332-0000-0000-000001D6C6C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If an RCU callback is queued on a no-CBs CPU from idle code with irqs
disabled, and if that CPU stays idle forever after, the callback will
never be invoked.  This commit therefore adds a check for this situation
in ____call_rcu_nocb(), invoking the RCU core solely for the purpose
of the ensuing return-to-idle transition.  (If the CPU doesn't return
to idle, the next scheduling-clock interrupt will fix things up.)

Reported-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 304f42c6543b..700e5b37bf26 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2129,6 +2129,17 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 		trace_rcu_callback(rdp->rsp->name, rhp,
 				   -atomic_long_read(&rdp->nocb_q_count_lazy),
 				   -atomic_long_read(&rdp->nocb_q_count));
+
+	/*
+	 * If called from an extended quiescent state with interrupts
+	 * disabled, invoke the RCU core in order to allow the idle-entry
+	 * deferred-wakeup check to function.
+	 */
+	if (irqs_disabled_flags(flags) &&
+	    !rcu_is_watching() &&
+	    cpu_online(smp_processor_id()))
+		invoke_rcu_core();
+
 	return true;
 }
 
-- 
1.8.1.5

