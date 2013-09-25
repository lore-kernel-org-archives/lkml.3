Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3IYBbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:31:43 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34174 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3IYB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/11] rcu: Replace __get_cpu_var() uses
Date: Tue, 24 Sep 2013 18:29:16 -0700
Message-Id: <1380072561-31134-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-7164-0000-0000-000001E539DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

__get_cpu_var() is used for multiple purposes in the kernel source. One
of them is address calculation via the form &__get_cpu_var(x). This
calculates the address for the instance of the percpu variable of the
current processor based on an offset.

Other use cases are for storing and retrieving data from the current
processors percpu area.  __get_cpu_var() can be used as an lvalue when
writing data or on the right side of an assignment.

__get_cpu_var() is defined as :

__get_cpu_var() always only does an address determination. However,
store and retrieve operations could use a segment prefix (or global
register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into
a percpu area and use optimized assembly code to read and write per
cpu variables.

This patch converts __get_cpu_var into either an explicit address
calculation using this_cpu_ptr() or into a use of this_cpu operations
that use the offset. Thereby address calcualtions are avoided and less
registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed
so the macro is removed too.

The patchset includes passes over all arches as well. Once these
operations are used throughout then specialized macros can be defined in
non -x86 arches as well in order to optimize per cpu access by f.e. using
a global register that may be set to the per cpu base.

Transformations done to __get_cpu_var()

1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);

2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);

3. Retrieve the content of the current processors instance of a per cpu
   variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);

4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&x), y, sizeof(x));

5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);

6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)

Signed-off-by: Christoph Lameter <cl@linux.com>
[ paulmck: Address conflicts. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        | 22 +++++++++++-----------
 kernel/rcutree_plugin.h | 14 +++++++-------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2712b89..8eb9cfd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -407,7 +407,7 @@ static void rcu_eqs_enter(bool user)
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
@@ -435,7 +435,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -478,7 +478,7 @@ void rcu_irq_exit(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
@@ -528,7 +528,7 @@ static void rcu_eqs_exit(bool user)
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
@@ -555,7 +555,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -599,7 +599,7 @@ void rcu_irq_enter(void)
 	long long oldval;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
@@ -620,7 +620,7 @@ void rcu_irq_enter(void)
  */
 void rcu_nmi_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
@@ -642,7 +642,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
 	    --rdtp->dynticks_nmi_nesting != 0)
@@ -665,7 +665,7 @@ int rcu_is_cpu_idle(void)
 	int ret;
 
 	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	ret = (atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1) == 0;
 	preempt_enable();
 	return ret;
 }
@@ -703,7 +703,7 @@ bool rcu_lockdep_current_cpu_online(void)
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	rdp = &__get_cpu_var(rcu_sched_data);
+	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
 	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
@@ -723,7 +723,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  */
 static int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
+	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
 }
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6f9aece..c684f7a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -660,7 +660,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 
 static void rcu_preempt_do_callbacks(void)
 {
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+	rcu_do_batch(&rcu_preempt_state, this_cpu_ptr(&rcu_preempt_data));
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1332,7 +1332,7 @@ static void invoke_rcu_callbacks_kthread(void)
  */
 static bool rcu_is_callbacks_kthread(void)
 {
-	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+	return __this_cpu_read(rcu_cpu_kthread_task) == current;
 }
 
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
@@ -1382,8 +1382,8 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 
 static void rcu_kthread_do_work(void)
 {
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_do_batch(&rcu_sched_state, this_cpu_ptr(&rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, this_cpu_ptr(&rcu_bh_data));
 	rcu_preempt_do_callbacks();
 }
 
@@ -1402,7 +1402,7 @@ static void rcu_cpu_kthread_park(unsigned int cpu)
 
 static int rcu_cpu_kthread_should_run(unsigned int cpu)
 {
-	return __get_cpu_var(rcu_cpu_has_work);
+	return __this_cpu_read(rcu_cpu_has_work);
 }
 
 /*
@@ -1412,8 +1412,8 @@ static int rcu_cpu_kthread_should_run(unsigned int cpu)
  */
 static void rcu_cpu_kthread(unsigned int cpu)
 {
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
+	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
 	int spincnt;
 
 	for (spincnt = 0; spincnt < 10; spincnt++) {
-- 
1.8.1.5

