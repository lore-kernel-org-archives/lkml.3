Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbbAUKKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:10:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58370 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbAUKI3 (ORCPT
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
Subject: [PATCH RFC tip/core/rcu 3/7] rcu: Prevent early-boot RCU callbacks from splatting
Date: Wed, 21 Jan 2015 02:08:16 -0800
Message-Id: <1421834900-23987-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0033-0000-0000-00000366C365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, a call_rcu() that precedes rcu_init() will splat due to the
callback lists not having yet been initialized.  This commit causes the
first such callback to initialize the boot CPU's RCU callback list.

Note that this commit does not change rcu_init()-time initialization,
which means that the callback will be discarded at rcu_init() time.
Fixing this is the job of later commits.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 37193daf2b62..ff2e42ebb64b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2839,11 +2839,21 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 
 		if (cpu != -1)
 			rdp = per_cpu_ptr(rsp->rda, cpu);
-		offline = !__call_rcu_nocb(rdp, head, lazy, flags);
-		WARN_ON_ONCE(offline);
-		/* _call_rcu() is illegal on offline CPU; leak the callback. */
-		local_irq_restore(flags);
-		return;
+		if (likely(rdp->mynode)) {
+			/* Post-boot, so this should be for a no-CBs CPU. */
+			offline = !__call_rcu_nocb(rdp, head, lazy, flags);
+			WARN_ON_ONCE(offline);
+			/* Offline CPU, _call_rcu() illegal, leak callback.  */
+			local_irq_restore(flags);
+			return;
+		}
+		/*
+		 * Very early boot, before rcu_init().  Initialize if needed
+		 * and then drop through to queue the callback.
+		 */
+		BUG_ON(cpu != -1);
+		if (!likely(rdp->nxtlist))
+			init_default_callback_list(rdp);
 	}
 	ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;
 	if (lazy)
-- 
1.8.1.5

