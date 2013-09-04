Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab3IDTmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:42:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38744 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3IDTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:42:46 -0400
Date: Wed, 4 Sep 2013 12:41:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 10/35] rcu: Replace __get_cpu_var uses
Message-ID: <20130904194135.GD3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130828193457.140443630@linux.com>
 <00000140c67825ee-d9e3a1ca-2e81-4868-8c8c-36ba965f7202-000000@email.amazonses.com>
 <20130831203559.GY3871@linux.vnet.ibm.com>
 <00000140e95815db-41b26a90-9bc9-490e-a313-e05364a152cb-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140e95815db-41b26a90-9bc9-490e-a313-e05364a152cb-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090419-1542-0000-0000-000001228BB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:19:59PM +0000, Christoph Lameter wrote:
> On Sat, 31 Aug 2013, Paul E. McKenney wrote:
> 
> > Queued for 3.13.  I had to rework for conflicts, please see below for
> > the update patch.
> 
> Looks fine to me. Can I drop the rcu patches from my patchset?

Yep, still queued for 3.13, and I even redid the change in
rcu_is_cpu_idle() to be the way you wanted it.  I wouldn't do that for
just anyone, you know!  ;-)

Current patch below.

							Thanx, Paul

------------------------------------------------------------------------

    rcu: Replace __get_cpu_var() uses
    
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

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a51985e..450b190 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -400,7 +400,7 @@ static void rcu_eqs_enter(bool user)
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
@@ -428,7 +428,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -471,7 +471,7 @@ void rcu_irq_exit(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
@@ -521,7 +521,7 @@ static void rcu_eqs_exit(bool user)
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
@@ -548,7 +548,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -592,7 +592,7 @@ void rcu_irq_enter(void)
 	long long oldval;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
@@ -613,7 +613,7 @@ void rcu_irq_enter(void)
  */
 void rcu_nmi_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
@@ -635,7 +635,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
 	    --rdtp->dynticks_nmi_nesting != 0)
@@ -658,7 +658,7 @@ int rcu_is_cpu_idle(void)
 	int ret;
 
 	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	ret = (atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1) == 0;
 	preempt_enable();
 	return ret;
 }
@@ -696,7 +696,7 @@ bool rcu_lockdep_current_cpu_online(void)
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	rdp = &__get_cpu_var(rcu_sched_data);
+	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
 	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
@@ -716,7 +716,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  */
 static int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
+	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
 }
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 08b6e74..dc09fb0 100644
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
@@ -1638,7 +1638,7 @@ static bool rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
 

