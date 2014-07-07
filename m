Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaGGWij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57482 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGGWib (ORCPT
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
Subject: [PATCH tip/core/rcu 01/17] rcu: Document deadlock-avoidance information for rcu_read_unlock()
Date: Mon,  7 Jul 2014 15:38:05 -0700
Message-Id: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140707223756.GA7187@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A71C7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6a94cc8b1ca0..c56ad15204ec 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -858,6 +858,34 @@ static inline void rcu_read_lock(void)
 /**
  * rcu_read_unlock() - marks the end of an RCU read-side critical section.
  *
+ * In most situations, rcu_read_unlock() is immune from deadlock.
+ * However, in kernels built with CONFIG_RCU_BOOST, rcu_read_unlock()
+ * is responsible for deboosting, which it does via rt_mutex_unlock().
+ * Unfortunately, this function acquires the scheduler's runqueue and
+ * priority-inheritance spinlocks.  This means that deadlock could result
+ * if the caller of rcu_read_unlock() already holds one of these locks or
+ * any lock that is ever acquired while holding them.
+ *
+ * That said, RCU readers are never priority boosted unless they were
+ * preempted.  Therefore, one way to avoid deadlock is to make sure
+ * that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with one of
+ * rt_mutex_unlock()'s locks held.  Such preemption can be avoided in
+ * a number of ways, for example, by invoking preempt_disable() before
+ * critical section's outermost rcu_read_lock().
+ *
+ * Given that the set of locks acquired by rt_mutex_unlock() might change
+ * at any time, a somewhat more future-proofed approach is to make sure
+ * that that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with irqs disabled.
+ * This approach relies on the fact that rt_mutex_unlock() currently only
+ * acquires irq-disabled locks.
+ *
+ * The second of these two approaches is best in most situations,
+ * however, the first approach can also be useful, at least to those
+ * developers willing to keep abreast of the set of locks acquired by
+ * rt_mutex_unlock().
+ *
  * See rcu_read_lock() for more information.
  */
 static inline void rcu_read_unlock(void)
-- 
1.8.1.5

