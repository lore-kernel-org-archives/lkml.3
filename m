Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3FBOSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 10:18:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37148 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3FBOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 10:18:25 -0400
Date: Sun, 2 Jun 2013 07:18:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Hotplug and PROVE_RCU_DELAY not playing well
 together
Message-ID: <20130602141814.GA24198@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1370035669.26799.85.camel@gandalf.local.home>
 <20130602025425.GE3957@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130602025425.GE3957@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060214-5518-0000-0000-00000F447A2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 07:54:25PM -0700, Paul E. McKenney wrote:
> On Fri, May 31, 2013 at 05:27:49PM -0400, Steven Rostedt wrote:
> > Paul,
> > 
> > I've been debugging the last couple of days why my tests have been
> > locking up. One of my tracing tests, runs all available tracers. The
> > lockup always happened with the mmiotrace, which is used to trace
> > interactions between priority drivers and the kernel. But to do this
> > easily, when the tracer gets registered, it disables all but the boot
> > CPUs. The lockup always happened after it got done disabling the CPUs.
> > 
> > Then I decided to try this:
> > 
> > while :; do
> > 	for i in 1 2 3; do
> > 		echo 0 > /sys/devices/system/cpu/cpu$i/online
> > 	done
> > 	for i in 1 2 3; do
> > 		echo 1 > /sys/devices/system/cpu/cpu$i/online
> > 	done
> > done
> > 
> > Well, sure enough, that locked up too, with the same users. Doing a
> > sysrq-w (showing all blocked tasks):
> 
> Impressive debugging!!!  And that is what I call one gnarly deadlock!
> 
> Your patch looks like it should fix the problem, but my immediate
> reaction was that it would be simpler to have rcu_gp_init()
> do either cpu_maps_update_begin(), get_online_cpus(), or
> cpu_hotplug_begin() if CONFIG_PROVE_RCU_DELAY instead of the
> current mutex_lock(&rsp->onoff_mutex).  (My first choice would be
> get_online_cpus(), but I am not sure that I fully understand the
> deadlock.)
> 
> Or am I missing something about the nature of this deadlock?
> 
> One concern is that if I made that change, and if any hotplug notifier
> waited for a grace period, there would be another deadlock.  Which
> might well be why this acquires ->onoff_lock.  Hmmm...
> 
> OK, another possible simplification would be to use udelay() or something
> similar to do the waiting, and maybe dial down the delay from the current
> two jiffies to (say) 200 microseconds.  I could adjust the "if" condition
> to make the delay more probable to get roughly the same testing intensity
> as the current code has.

And here is a patch based on this approach.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d12470e..9a08bdc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1320,9 +1320,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0 &&
+		if ((prandom_u32() % (rcu_num_nodes + 1)) == 0 &&
 		    system_state == SYSTEM_RUNNING)
-			schedule_timeout_uninterruptible(2);
+			udelay(200);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
 	}

