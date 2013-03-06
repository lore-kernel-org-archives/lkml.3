Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3CFVpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:45:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:52697 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3CFVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:45:44 -0500
Date: Wed, 6 Mar 2013 13:45:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
Message-ID: <20130306214502.GC3268@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130306154917.GA15249@windriver.com>
 <alpine.LFD.2.02.1303061651360.22263@ionos>
 <20130306171648.GO3268@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1303062010060.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303062010060.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030621-3620-0000-0000-000001833CB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:11:25PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Paul E. McKenney wrote:
> 
> > On Wed, Mar 06, 2013 at 04:58:54PM +0100, Thomas Gleixner wrote:
> > > On Wed, 6 Mar 2013, Paul Gortmaker wrote:
> > > > So, I guess the question is, whether we want to try and make the system
> > > > fail in a more meaningful way -- kind of like the rt throttling message
> > > > does - as it lets users know they've hit the wall?  Something watching
> > > 
> > > That Joe Doe should have noticed the throttler message, which came
> > > before the stall, shouldn't he?
> > > 
> > > > for kstat_incr_softirqs traffic perhaps?  Or other options?
> > > 
> > > The rcu stall detector could use the softirq counter and if it did not
> > > change in the stall period print: "Caused by softirq starvation" or
> > > something like that.
> > 
> > The idea is to (at grace-period start) take a snapshot of the CPU's
> > value of kstat.softirqs[RCU_SOFTIRQ], then check it at stall time, right?
> 
> Yep.
> 
> > Or do I have the wrong softirq counter?
> 
> kstat_softirqs_cpu(RCU_SOFTIRQ, cpu) is the function you want to use.

Good point!

So this is what I am considering doing:

o	Adding this under CONFIG_RCU_CPU_STALL_INFO=y.

o	When a given CPU sees a new grace period starting, it takes a
	snapshot of kstat_softirqs_cpu(RCU_SOFTIRQ, smp_processor_id().

o	When a CPU detects a stall, for each CPU that is stalled, it
	prints kstat_softirqs_cpu(RCU_SOFTIRQ, cpu) as well as the
	last snapshot taken from that CPU.

This information will require some interpretation.  Here are a few
things that can happen:

o	The CPU saw the beginning of the stalled grace period, took a
	few more RCU softirqs, but got into a softirq-unfriendly state,
	thus causing the stall.  In this case, the stall-warning
	message would show a small difference between the snapshot
	and the stalled CPU's current value, but this difference would
	not change for additional stall-warning messages happening for
	the same CPU-stall event.  Also, because this CPU did see the
	beginning of the stalled grace period, the line will have a
	"(N ticks this GP)" string instead of an "(N GPs behind)" string.

o	The CPU entered a softirq-unfriendly state before the beginning
	of the stalled grace period.  In this case, the stall-warning
	message would show the number of RCU softirqs that the stalled
	CPU took since the last time it saw the beginning of some prior
	grace period.  This prior grace period might have been a really
	long time ago if the CPU was in dyntick-idle mode immediately
	before going into a softirq-unfriendly state.  In addition,
	the CPU's line in the stall-warning message will have an "(N
	GPs behind)" string.

o	If the CPU entered a softirq-unfriendly state just after the
	beginning of the last grace period that it saw, then and only then
	will it show zero softirq handlers having happened.  It might have
	either a "(N ticks this GP)" string or an "(N GPs behind)" string,
	depending on which grace period was the last one that it saw.

Is this behavior OK?  If so, the following (untested) patch might do
what you want.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Add softirq-stall indications to stall-warning messages

If RCU's softirq handler is prevented from executing, an RCU CPU stall
warning can result.  Ways to prevent RCU's softirq handler from executing
include: (1) CPU spinning with interrupts disabled, (2) infinite loop
in some softirq handler, and (3) in -rt kernels, an infinite loop in a
set of real-time threads running at priorities higher than that of RCU's
softirq handler.

Because this situation can be difficult to track down, this commit causes
the count of RCU softirq handler invocations to be printed with RCU
CPU stall warnings.  This information does require some interpretation,
as now documented in Documentation/RCU/stallwarn.txt.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 1927151..e38b8df 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -92,14 +92,14 @@ If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
 more information is printed with the stall-warning message, for example:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0
+	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0 softirq=82/543
 	   (t=65000 jiffies)
 
 In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer not pending
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 softirq=82/543 last_accelerate: a345/d342 nonlazy_posted: 25 .D
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -116,13 +116,28 @@ number between the two "/"s is the value of the nesting, which will
 be a small positive number if in the idle loop and a very large positive
 number (as shown above) otherwise.
 
-For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the CPU is
-not in the process of trying to force itself into dyntick-idle state, the
-"." indicates that the CPU has not given up forcing RCU into dyntick-idle
-mode (it would be "H" otherwise), and the "timer not pending" indicates
-that the CPU has not recently forced RCU into dyntick-idle mode (it
-would otherwise indicate the number of microseconds remaining in this
-forced state).
+The "softirq=" portion of the message tracks the number of RCU softirq
+handlers that the stalled CPU has executed.  The number before the "/"
+is the number that had executed since boot at the time that this CPU
+last noted the beginning of a grace period, which might be the current
+(stalled) grace period, or it might be some earlier grace period (for
+example, if the CPU might have been in dyntick-idle mode for an extended
+time period.  The number after the "/" is the number that have executed
+since boot until the current time.  If this latter number stays constant
+across repeated stall-warning messages, it is possible that RCU's softirq
+handlers are no longer able to execute on this CPU.  This can happen if
+the stalled CPU is spinning with interrupts are disabled, or, in -rt
+kernels, if a high-priority process is starving RCU's softirq handler.
+
+For CONFIG_RCU_FAST_NO_HZ kernels, the "last_accelerate:" prints the
+low-order 16 bits (in hex) of the jiffies counter when this CPU last
+invoked rcu_try_advance_all_cbs() from rcu_needs_cpu() or last invoked
+rcu_accelerate_cbs() from rcu_prepare_for_idle().  The "nonlazy_posted:"
+prints the number of non-lazy callbacks posted since the last call to
+rcu_needs_cpu().  Finally, an "L" indicates that there are currently
+no non-lazy callbacks ("." is printed otherwise, as shown above) and
+"D" indicates that dyntick-idle processing is enabled ("." is printed
+otherwise, for example, if disabled via the "nohz=" kernel boot parameter).
 
 
 Multiple Warnings From One Stall
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index de6ad68..14ee407 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -326,6 +326,11 @@ struct rcu_data {
 	struct task_struct *nocb_kthread;
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+	/* 8) RCU CPU stall data. */
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+	unsigned int softirq_snap;	/* Snapshot of softirq activity. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
 	int cpu;
 	struct rcu_state *rsp;
 };
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 723af5f..d084ae3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1913,10 +1913,11 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d %s\n",
+	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
+	       rdp->softirq_snap, kstat_softirqs_cpu(RCU_SOFTIRQ, cpu),
 	       fast_no_hz);
 }
 
@@ -1930,6 +1931,7 @@ static void print_cpu_stall_info_end(void)
 static void zero_cpu_stall_ticks(struct rcu_data *rdp)
 {
 	rdp->ticks_this_gp = 0;
+	rdp->softirq_snap = kstat_softirqs_cpu(RCU_SOFTIRQ, smp_processor_id());
 }
 
 /* Increment ->ticks_this_gp for all flavors of RCU. */

