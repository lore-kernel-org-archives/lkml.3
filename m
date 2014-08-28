Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaH1TWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:22:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32794 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbaH1TUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 14/17] rcu: Remove redundant preempt_disable() from rcu_note_voluntary_context_switch()
Date: Thu, 28 Aug 2014 12:20:05 -0700
Message-Id: <1409253608-32538-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-6688-0000-0000-0000045BBBB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In theory, synchronize_sched() requires a read-side critical section
to order against.  In practice, preemption can be thought of as
being disabled across every machine instruction, at least for those
machine instructions that are not in the idle loop and not on offline
CPUs.  So this commit removes the redundant preempt_disable() from
rcu_note_voluntary_context_switch().

Please note that the single instruction in question is the store of
zero to ->rcu_tasks_holdout.  The "if" is simply a performance optimization
that avoids unnecessary stores.  To see this, keep in mind that both
the "if" condition and the store are in a quiescent state.  Therefore,
even if the task is preempted for a full grace period (presumably due
to its having done a context switch beforehand), the store will be
recording a legitimate quiescent state.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Conflicts:
	include/linux/rcupdate.h
---
 include/linux/rcupdate.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a3123f53a4ce..132e1e34cdca 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -326,10 +326,8 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 extern struct srcu_struct tasks_rcu_exit_srcu;
 #define rcu_note_voluntary_context_switch(t) \
 	do { \
-		preempt_disable(); /* Exclude synchronize_sched(); */ \
 		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
 			ACCESS_ONCE((t)->rcu_tasks_holdout) = false; \
-		preempt_enable(); \
 	} while (0)
 #else /* #ifdef CONFIG_TASKS_RCU */
 #define TASKS_RCU(x) do { } while (0)
-- 
1.8.1.5

