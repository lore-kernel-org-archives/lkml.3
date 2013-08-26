Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3HZUqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:46:05 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:53235 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab3HZUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:44:40 -0400
Message-ID: <00000140bc5f0403-24ce80da-7652-4e63-a688-84e7a7a4bf7d-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:38 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 10/31] rcu: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Others usage cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does a address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




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


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&y), x, sizeof(x));


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

Index: linux/kernel/rcutree.c
===================================================================
--- linux.orig/kernel/rcutree.c	2013-08-26 14:27:35.000000000 -0500
+++ linux/kernel/rcutree.c	2013-08-26 14:28:13.959886770 -0500
@@ -383,7 +383,7 @@ static void rcu_eqs_enter(bool user)
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
@@ -443,7 +443,7 @@ void rcu_user_enter_after_irq(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	/* Ensure this irq is interrupting a non-idle RCU state.  */
 	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
 	rdtp->dynticks_nesting = 1;
@@ -474,7 +474,7 @@ void rcu_irq_exit(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
@@ -523,7 +523,7 @@ static void rcu_eqs_exit(bool user)
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
@@ -581,7 +581,7 @@ void rcu_user_exit_after_irq(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	/* Ensure we are interrupting an RCU idle mode. */
 	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
 	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
@@ -615,7 +615,7 @@ void rcu_irq_enter(void)
 	long long oldval;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
@@ -635,7 +635,7 @@ void rcu_irq_enter(void)
  */
 void rcu_nmi_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
@@ -657,7 +657,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
 	    --rdtp->dynticks_nmi_nesting != 0)
@@ -680,7 +680,7 @@ int rcu_is_cpu_idle(void)
 	int ret;
 
 	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	ret = (atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1) == 0;
 	preempt_enable();
 	return ret;
 }
@@ -718,7 +718,7 @@ bool rcu_lockdep_current_cpu_online(void
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	rdp = &__get_cpu_var(rcu_sched_data);
+	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
 	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cp
  */
 static int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
+	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
 }
 
 /*
Index: linux/kernel/rcutree_plugin.h
===================================================================
--- linux.orig/kernel/rcutree_plugin.h	2013-08-26 14:27:35.000000000 -0500
+++ linux/kernel/rcutree_plugin.h	2013-08-26 14:28:13.963886728 -0500
@@ -662,7 +662,7 @@ static void rcu_preempt_check_callbacks(
 
 static void rcu_preempt_do_callbacks(void)
 {
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+	rcu_do_batch(&rcu_preempt_state, this_cpu_ptr(&rcu_preempt_data));
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1334,7 +1334,7 @@ static void invoke_rcu_callbacks_kthread
  */
 static bool rcu_is_callbacks_kthread(void)
 {
-	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+	return __this_cpu_read(rcu_cpu_kthread_task) == current;
 }
 
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
@@ -1384,8 +1384,8 @@ static int rcu_spawn_one_boost_kthread(s
 
 static void rcu_kthread_do_work(void)
 {
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_do_batch(&rcu_sched_state, this_cpu_ptr(&rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, this_cpu_ptr(&rcu_bh_data));
 	rcu_preempt_do_callbacks();
 }
 
@@ -1404,7 +1404,7 @@ static void rcu_cpu_kthread_park(unsigne
 
 static int rcu_cpu_kthread_should_run(unsigned int cpu)
 {
-	return __get_cpu_var(rcu_cpu_has_work);
+	return __this_cpu_read(rcu_cpu_has_work);
 }
 
 /*
@@ -1414,8 +1414,8 @@ static int rcu_cpu_kthread_should_run(un
  */
 static void rcu_cpu_kthread(unsigned int cpu)
 {
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
+	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
 	int spincnt;
 
 	for (spincnt = 0; spincnt < 10; spincnt++) {

