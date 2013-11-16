Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3KPAZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:25:14 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36554 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3KPAXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/16] rcu: Improve SRCU's grace-period comments
Date: Fri, 15 Nov 2013 16:23:31 -0800
Message-Id: <1384561418-30575-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C8D3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit documents the memory-barrier guarantees provided by
synchronize_srcu() and call_srcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/srcu.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 0f0c63111f20..3318d8284384 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -363,6 +363,29 @@ static void srcu_flip(struct srcu_struct *sp)
 /*
  * Enqueue an SRCU callback on the specified srcu_struct structure,
  * initiating grace-period processing if it is not already running.
+ *
+ * Note that all CPUs must agree that the grace period extended beyond
+ * all pre-existing SRCU read-side critical section.  On systems with
+ * more than one CPU, this means that when "func()" is invoked, each CPU
+ * is guaranteed to have executed a full memory barrier since the end of
+ * its last corresponding SRCU read-side critical section whose beginning
+ * preceded the call to call_rcu().  It also means that each CPU executing
+ * an SRCU read-side critical section that continues beyond the start of
+ * "func()" must have executed a memory barrier after the call_rcu()
+ * but before the beginning of that SRCU read-side critical section.
+ * Note that these guarantees include CPUs that are offline, idle, or
+ * executing in user mode, as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked call_rcu() and CPU B invoked the
+ * resulting SRCU callback function "func()", then both CPU A and CPU
+ * B are guaranteed to execute a full memory barrier during the time
+ * interval between the call to call_rcu() and the invocation of "func()".
+ * This guarantee applies even if CPU A and CPU B are the same CPU (but
+ * again only if the system has more than one CPU).
+ *
+ * Of course, these guarantees apply only for invocations of call_srcu(),
+ * srcu_read_lock(), and srcu_read_unlock() that are all passed the same
+ * srcu_struct structure.
  */
 void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 		void (*func)(struct rcu_head *head))
@@ -459,7 +482,30 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  * Note that it is illegal to call synchronize_srcu() from the corresponding
  * SRCU read-side critical section; doing so will result in deadlock.
  * However, it is perfectly legal to call synchronize_srcu() on one
- * srcu_struct from some other srcu_struct's read-side critical section.
+ * srcu_struct from some other srcu_struct's read-side critical section,
+ * as long as the resulting graph of srcu_structs is acyclic.
+ *
+ * There are memory-ordering constraints implied by synchronize_srcu().
+ * On systems with more than one CPU, when synchronize_srcu() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since
+ * the end of its last corresponding SRCU-sched read-side critical section
+ * whose beginning preceded the call to synchronize_srcu().  In addition,
+ * each CPU having an SRCU read-side critical section that extends beyond
+ * the return from synchronize_srcu() is guaranteed to have executed a
+ * full memory barrier after the beginning of synchronize_srcu() and before
+ * the beginning of that SRCU read-side critical section.  Note that these
+ * guarantees include CPUs that are offline, idle, or executing in user mode,
+ * as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked synchronize_srcu(), which returned
+ * to its caller on CPU B, then both CPU A and CPU B are guaranteed
+ * to have executed a full memory barrier during the execution of
+ * synchronize_srcu().  This guarantee applies even if CPU A and CPU B
+ * are the same CPU, but again only if the system has more than one CPU.
+ *
+ * Of course, these memory-ordering guarantees apply only when
+ * synchronize_srcu(), srcu_read_lock(), and srcu_read_unlock() are
+ * passed the same srcu_struct structure.
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
@@ -476,12 +522,8 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * Wait for an SRCU grace period to elapse, but be more aggressive about
  * spinning rather than blocking when waiting.
  *
- * Note that it is also illegal to call synchronize_srcu_expedited()
- * from the corresponding SRCU read-side critical section;
- * doing so will result in deadlock.  However, it is perfectly legal
- * to call synchronize_srcu_expedited() on one srcu_struct from some
- * other srcu_struct's read-side critical section, as long as
- * the resulting graph of srcu_structs is acyclic.
+ * Note that synchronize_srcu_expedited() has the same deadlock and
+ * memory-ordering properties as does synchronize_srcu().
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-- 
1.8.1.5

