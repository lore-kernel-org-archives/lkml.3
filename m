Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbbAGRcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49012 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbbAGRcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:42 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless accesses with ACCESS_ONCE()
Date: Wed,  7 Jan 2015 09:32:20 -0800
Message-Id: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150107173215.GA897@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-0000079397C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit prevents random compiler optimizations by applying
ACCESS_ONCE() to lockless accesses.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3ec85cb5d544..d59913ef8360 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1127,7 +1127,8 @@ static int rcu_boost(struct rcu_node *rnp)
 	struct task_struct *t;
 	struct list_head *tb;
 
-	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
+	if (ACCESS_ONCE(rnp->exp_tasks) == NULL &&
+	    ACCESS_ONCE(rnp->boost_tasks) == NULL)
 		return 0;  /* Nothing left to boost. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-- 
1.8.1.5

