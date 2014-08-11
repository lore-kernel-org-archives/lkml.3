Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaHKWxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:53:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58738 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaHKWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:49:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v5 tip/core/rcu 14/16] rcu: Remove redundant preempt_disable() from rcu_note_voluntary_context_switch()
Date: Mon, 11 Aug 2014 15:49:03 -0700
Message-Id: <1407797345-28227-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-6688-0000-0000-000003EF1169
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In theory, synchronize_sched() requires a read-side critical section to
order against.  In practice, preemption can be thought of as being
disabled across every machine instruction.  So this commit removes
the redundant preempt_disable() from rcu_note_voluntary_context_switch().

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f504f797c9c8..ed6e3e2e0089 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -326,10 +326,8 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 extern struct srcu_struct tasks_rcu_exit_srcu;
 #define rcu_note_voluntary_context_switch(t) \
 	do { \
-		preempt_disable(); /* Exclude synchronize_sched(); */ \
 		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
 			ACCESS_ONCE((t)->rcu_tasks_holdout) = 0; \
-		preempt_enable(); \
 	} while (0)
 #else /* #ifdef CONFIG_TASKS_RCU */
 #define TASKS_RCU(x) do { } while (0)
-- 
1.8.1.5

