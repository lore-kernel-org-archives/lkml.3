Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbbAGRjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:39:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45119 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAGRjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:39:17 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: Expand SRCU ->completed to 64 bits
Date: Wed,  7 Jan 2015 09:39:06 -0800
Message-Id: <1420652348-3867-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150107173842.GA3240@linux.vnet.ibm.com>
References: <20150107173842.GA3240@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0009-0000-0000-000007C63C7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When rcutorture used only the low-order 32 bits of the grace-period
number, it was not a problem for SRCU to use a 32-bit completed field.
However, rcutorture now uses the full 64 bits on 64-bit systems, so
this commit converts SRCU's ->completed field to unsigned long so as to
provide 64 bits on 64-bit systems.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h | 4 ++--
 kernel/rcu/srcu.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a2783cb5d275..ef923dd96249 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -45,7 +45,7 @@ struct rcu_batch {
 #define RCU_BATCH_INIT(name) { NULL, &(name.head) }
 
 struct srcu_struct {
-	unsigned completed;
+	unsigned long completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
 	spinlock_t queue_lock; /* protect ->batch_queue, ->running */
 	bool running;
@@ -135,7 +135,7 @@ int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
-long srcu_batches_completed(struct srcu_struct *sp);
+unsigned long srcu_batches_completed(struct srcu_struct *sp);
 void srcu_barrier(struct srcu_struct *sp);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index e037f3eb2f7b..445bf8ffe3fb 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -546,7 +546,7 @@ EXPORT_SYMBOL_GPL(srcu_barrier);
  * Report the number of batches, correlated with, but not necessarily
  * precisely the same as, the number of grace periods that have elapsed.
  */
-long srcu_batches_completed(struct srcu_struct *sp)
+unsigned long srcu_batches_completed(struct srcu_struct *sp)
 {
 	return sp->completed;
 }
-- 
1.8.1.5

