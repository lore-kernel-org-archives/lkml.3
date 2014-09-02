Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaIBVPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:15:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54080 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaIBVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:15:21 -0400
Date: Tue, 2 Sep 2014 14:15:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140902211517.GO5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org>
 <20140902203743.GL5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090221-3532-0000-0000-0000045362CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 03:47:55PM -0500, Christoph Lameter wrote:
> On Tue, 2 Sep 2014, Paul E. McKenney wrote:
> 
> > But yes, in theory, something like this can work if appropriate memory
> > barriers are put in place.  In practice, this sort of change needs
> > profound testing on multiple architectures.
> 
> Ok how can we move forward? I just looked further and it seems a similar
> approach could perhaps work for the dynticks field.

Yep, these two have been on my "when I am feeling insanely gutsy" list
for quite some time.

But I have to ask...  On x86, is a pair of mfence instructions really
cheaper than an atomic increment?

> If the first patch I send gets merged then a lot of other this_cpu related
> optimizations become possible regardless of the ones in the RFC.

Yep, I am queuing that one.

But could you please do future patches against the rcu/dev branch of
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git?
I had to hand-apply due to conflicts.  Please see below for my version,
and please check to make sure that I didn't mess something up in the
translation.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Remove rcu_dynticks * parameters when they are always this_cpu_ptr(&rcu_dynticks)

For some functions in kernel/rcu/tree* the rdtp parameter is always
this_cpu_ptr(rdtp).  Remove the parameter if constant and calculate the
pointer in function.

This will have the advantage that it is obvious that the address are
all per cpu offsets and thus it will enable the use of this_cpu_ops in
the future.

Signed-off-by: Christoph Lameter <cl@linux.com>
[ paulmck: Forward-ported to rcu/dev, whitespace adjustment. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 929ea9a6e0a1..65c42a6465eb 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -497,11 +497,11 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
-				bool user)
+static void rcu_eqs_enter_common(long long oldval, bool user)
 {
 	struct rcu_state *rsp;
 	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
@@ -552,7 +552,7 @@ static void rcu_eqs_enter(bool user)
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-		rcu_eqs_enter_common(rdtp, oldval, user);
+		rcu_eqs_enter_common(oldval, user);
 	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	}
@@ -576,7 +576,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_enter(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -626,8 +626,8 @@ void rcu_irq_exit(void)
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_enter_common(rdtp, oldval, true);
-	rcu_sysidle_enter(rdtp, 1);
+		rcu_eqs_enter_common(oldval, true);
+	rcu_sysidle_enter(1);
 	local_irq_restore(flags);
 }
 
@@ -638,9 +638,10 @@ void rcu_irq_exit(void)
  * we really have exited idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
-			       int user)
+static void rcu_eqs_exit_common(long long oldval, int user)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
@@ -678,7 +679,7 @@ static void rcu_eqs_exit(bool user)
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
 	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-		rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(oldval, user);
 	}
 }
 
@@ -699,7 +700,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_exit(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -750,8 +751,8 @@ void rcu_irq_enter(void)
 	if (oldval)
 		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_exit_common(rdtp, oldval, true);
-	rcu_sysidle_exit(rdtp, 1);
+		rcu_eqs_exit_common(oldval, true);
+	rcu_sysidle_exit(1);
 	local_irq_restore(flags);
 }
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 06d615b1eaa9..f37f77c13c86 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -605,8 +605,8 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_enter(int irq);
+static void rcu_sysidle_exit(int irq);
 static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 				  unsigned long *maxj);
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b705bd3de4d8..10e2424ae4ab 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2728,9 +2728,10 @@ static int full_sysidle_state;		/* Current system-idle state. */
  * to detect full-system idle states, not RCU quiescent states and grace
  * periods.  The caller must have disabled interrupts.
  */
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 	unsigned long j;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
@@ -2799,8 +2800,10 @@ void rcu_sysidle_force_exit(void)
  * usermode execution does -not- count as idle here!  The caller must
  * have disabled interrupts.
  */
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
 		return;
@@ -3094,11 +3097,11 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 
 #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 }
 
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
 }
 

