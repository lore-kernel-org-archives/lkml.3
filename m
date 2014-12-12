Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180AbaLLSKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:10:55 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45293 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935064AbaLLSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:10:54 -0500
Date: Fri, 12 Dec 2014 10:10:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212181044.GW25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212030343.GA7945@redhat.com>
 <20141212044509.GA21145@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212044509.GA21145@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121218-0033-0000-0000-000002FE79D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:45:09PM -0500, Dave Jones wrote:
> On Thu, Dec 11, 2014 at 10:03:43PM -0500, Dave Jones wrote:
>  > On Thu, Dec 11, 2014 at 01:49:17PM -0800, Linus Torvalds wrote:
>  >  
>  >  > Anyway, you might as well stop bisecting. Regardless of where it lands
>  >  > in the remaining pile, it's not going to give us any useful
>  >  > information, methinks.
>  >  > 
>  >  > I'm stumped.
>  > 
>  > yeah, likewise.  I don't recall any bug that's given me this much headache.
>  > I don't think it's helped that the symptoms are vague enough that a
>  > number of people have thought they've seen the same thing, which have
>  > turned out to be unrelated incidents.  At least some of those have
>  > gotten closure though it seems.
>  > 
>  >  > Maybe it's worth it to concentrate on just testing current kernels,
>  >  > and instead try to limit the triggering some other way. In particular,
>  >  > you had a trinity run that was *only* testing lsetxattr(). Is that
>  >  > really *all* that was going on? Obviously trinity will be using
>  >  > timers, fork, and other things? Can you recreate that lsetxattr thing,
>  >  > and just try to get as many problem reports as possible from one
>  >  > particular kernel (say, 3.18, since that should be a reasonable modern
>  >  > base with hopefully not a lot of other random issues)?
>  > 
>  > I'll let it run overnight, but so far after 4hrs, on .18 it's not done
>  > anything.
> 
> Two hours later, it had spewed this, but survived. (Trinity had quit after that
> point because /proc/sys/kernel/tainted changed).

[ . . . ]

> Few seconds later rcu craps itself..
> 
> [18801.941908] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [18801.942920] 	3: (3 GPs behind) idle=bf4/0/0 softirq=1597256/1597257 
> [18801.943890] 	(detected by 0, t=6002 jiffies, g=763359, c=763358, q=0)
> [18801.944843] Task dump for CPU 3:
> [18801.945770] swapper/3       R  running task    14576     0      1 0x00200000
> [18801.946706]  0000000342b6fe28 def23185c07e1b3d ffffe8ffff403518 0000000000000001
> [18801.947629]  ffffffff81cb2000 0000000000000003 ffff880242b6fe78 ffffffff8166cb95
> [18801.948557]  0000111242adb59f ffffffff81cb2070 ffff880242b6c000 ffffffff81d21ab0
> [18801.949478] Call Trace:
> [18801.950384]  [<ffffffff8166cb95>] ? cpuidle_enter_state+0x55/0x1c0
> [18801.951303]  [<ffffffff8166cdb7>] ? cpuidle_enter+0x17/0x20
> [18801.952211]  [<ffffffff810bf303>] ? cpu_startup_entry+0x423/0x4d0
> [18801.953125]  [<ffffffff810314c3>] ? start_secondary+0x1a3/0x220

Very strange.  Both cpuidle_enter() and cpuidle_enter_state() should be
within the idle loop, so that RCU should be ignoring this CPU.  And the
"idle=bf4/0/0" means that it really has marked itself as being idle from
an RCU perspective.  So I am guessing that the RCU grace-period kthread
has not gotten a chance to run.

If you are willing to live a bit dangerously, could you please see if
the (not for mainline) patch below clears this up?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Run grace-period kthreads at real-time priority

This is a experimental commit that attempts to better handle high-load
situations.

Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/init/Kconfig b/init/Kconfig
index cecce1b13825..6db1f304157c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -677,7 +677,6 @@ config RCU_BOOST
 config RCU_KTHREAD_PRIO
 	int "Real-time priority to use for RCU worker threads"
 	range 1 99
-	depends on RCU_BOOST
 	default 1
 	help
 	  This option specifies the SCHED_FIFO priority value that will be
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 93bca38925a9..57fd8f5bd1ad 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -156,6 +156,10 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
+/* rcuc/rcub kthread realtime priority */
+static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
+module_param(kthread_prio, int, 0644);
+
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
@@ -3631,15 +3635,19 @@ static int __init rcu_spawn_gp_kthread(void)
 	unsigned long flags;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
+	struct sched_param sp;
 	struct task_struct *t;
 
 	rcu_scheduler_fully_active = 1;
 	for_each_rcu_flavor(rsp) {
-		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
+		t = kthread_create(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
 		rnp = rcu_get_root(rsp);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
+		sp.sched_priority = kthread_prio;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+		wake_up_process(t);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	rcu_spawn_nocb_kthreads();
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cf3b4d532379..564944964f14 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -34,10 +34,6 @@
 
 #include "../locking/rtmutex_common.h"
 
-/* rcuc/rcub kthread realtime priority */
-static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
-module_param(kthread_prio, int, 0644);
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.

