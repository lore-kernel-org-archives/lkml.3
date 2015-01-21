Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbbAUKIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:08:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56128 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAUKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:29 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 4/7] rcu: Refine diagnostics for lacking kthread for no-CBs callbacks
Date: Wed, 21 Jan 2015 02:08:17 -0800
Message-Id: <1421834900-23987-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0029-0000-0000-000007595BE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Some diagnostics under CONFIG_PROVE_RCU in rcu_nocb_cpu_needs_barrier()
assume that there can be no early-boot callbacks.  This commit therefore
qualifies the diagnostic with rcu_scheduler_fully_active to permit
early boot callbacks to avoid this splat.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 371c5538c789..9b7f8c8ca355 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1938,7 +1938,8 @@ static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu)
 		rhp = ACCESS_ONCE(rdp->nocb_follower_head);
 
 	/* Having no rcuo kthread but CBs after scheduler starts is bad! */
-	if (!ACCESS_ONCE(rdp->nocb_kthread) && rhp) {
+	if (!ACCESS_ONCE(rdp->nocb_kthread) && rhp &&
+	    rcu_scheduler_fully_active) {
 		/* RCU callback enqueued before CPU first came online??? */
 		pr_err("RCU: Never-onlined no-CBs CPU %d has CB %p\n",
 		       cpu, rhp->func);
-- 
1.8.1.5

