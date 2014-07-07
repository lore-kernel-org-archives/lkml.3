Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaGGWkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56160 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaGGWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/17] rcu: Fix __rcu_reclaim() to use true/false for bool
Date: Mon,  7 Jul 2014 15:38:19 -0700
Message-Id: <1404772701-8804-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-0928-0000-0000-000003305D8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __rcu_reclaim() function returned 0/1, which is not proper for a
function of type bool.  This commit therefore converts to false/true.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcu.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index bfda2726ca45..ff1a6de62f17 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -99,6 +99,10 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 void kfree(const void *);
 
+/*
+ * Reclaim the specified callback, either by invoking it (non-lazy case)
+ * or freeing it directly (lazy case).  Return true if lazy, false otherwise.
+ */
 static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
@@ -108,12 +112,12 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
 		rcu_lock_release(&rcu_callback_map);
-		return 1;
+		return true;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
 		rcu_lock_release(&rcu_callback_map);
-		return 0;
+		return false;
 	}
 }
 
-- 
1.8.1.5

