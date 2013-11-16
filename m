Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3KPAZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:25:51 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36551 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3KPAXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/16] rcu: Provide better diagnostics for blocking in RCU callback functions
Date: Fri, 15 Nov 2013 16:23:32 -0800
Message-Id: <1384561418-30575-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C8D40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently blocking in an RCU callback function will result in
"scheduling while atomic", which could be triggered for any number
of reasons.  To aid debugging, this patch introduces a rcu_callback_map
that is used to tie the inappropriate voluntary context switch back
to the fact that the function is being invoked from within a callback.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 1 +
 kernel/rcu/rcu.h         | 3 +++
 kernel/rcu/update.c      | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 39cbb889e20d..a94a5805d378 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -325,6 +325,7 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
+extern struct lockdep_map rcu_callback_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 7859a0a3951e..a8f981a2d110 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -102,13 +102,16 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
+	rcu_lock_acquire(&rcu_callback_map);
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
+		rcu_lock_release(&rcu_callback_map);
 		return 1;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
+		rcu_lock_release(&rcu_callback_map);
 		return 0;
 	}
 }
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 6cb3dff89e2b..802365ccd591 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -128,6 +128,11 @@ struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 
+static struct lock_class_key rcu_callback_key;
+struct lockdep_map rcu_callback_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_callback", &rcu_callback_key);
+EXPORT_SYMBOL_GPL(rcu_callback_map);
+
 int notrace debug_lockdep_rcu_enabled(void)
 {
 	return rcu_scheduler_active && debug_locks &&
-- 
1.8.1.5

