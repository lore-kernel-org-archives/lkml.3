Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaGCCyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:54:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39244 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGCCyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:54:02 -0400
Date: Wed, 2 Jul 2014 19:53:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140703025354.GA16643@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <53B40D2B.7090406@redhat.com>
 <20140702165556.GR4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702165556.GR4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070302-7164-0000-0000-000002DF02BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:55:56AM -0700, Paul E. McKenney wrote:
> On Wed, Jul 02, 2014 at 09:46:19AM -0400, Rik van Riel wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > On 07/02/2014 08:34 AM, Peter Zijlstra wrote:
> > > On Fri, Jun 27, 2014 at 07:20:38AM -0700, Paul E. McKenney wrote:
> > >> An 80-CPU system with a context-switch-heavy workload can require
> > >> so many NOCB kthread wakeups that the RCU grace-period kthreads
> > >> spend several tens of percent of a CPU just awakening things.
> > >> This clearly will not scale well: If you add enough CPUs, the RCU
> > >> grace-period kthreads would get behind, increasing grace-period
> > >> latency.
> > >> 
> > >> To avoid this problem, this commit divides the NOCB kthreads into
> > >> leaders and followers, where the grace-period kthreads awaken the
> > >> leaders each of whom in turn awakens its followers.  By default,
> > >> the number of groups of kthreads is the square root of the number
> > >> of CPUs, but this default may be overridden using the
> > >> rcutree.rcu_nocb_leader_stride boot parameter. This reduces the
> > >> number of wakeups done per grace period by the RCU grace-period
> > >> kthread by the square root of the number of CPUs, but of course
> > >> by shifting those wakeups to the leaders.  In addition, because 
> > >> the leaders do grace periods on behalf of their respective
> > >> followers, the number of wakeups of the followers decreases by up
> > >> to a factor of two. Instead of being awakened once when new
> > >> callbacks arrive and again at the end of the grace period, the
> > >> followers are awakened only at the end of the grace period.
> > >> 
> > >> For a numerical example, in a 4096-CPU system, the grace-period
> > >> kthread would awaken 64 leaders, each of which would awaken its
> > >> 63 followers at the end of the grace period.  This compares
> > >> favorably with the 79 wakeups for the grace-period kthread on an
> > >> 80-CPU system.
> > > 
> > > Urgh, how about we kill the entire nocb nonsense and try again?
> > > This is getting quite rediculous.
> > 
> > Some observations.
> > 
> > First, the rcuos/N threads are NOT bound to CPU N at all, but are
> > free to float through the system.
> 
> I could easily bind each to its home CPU by default for CONFIG_NO_HZ_FULL=n.
> For CONFIG_NO_HZ_FULL=y, they get bound to the non-nohz_full= CPUs.
> 
> > Second, the number of RCU callbacks at the end of each grace period
> > is quite likely to be small most of the time.
> > 
> > This suggests that on a system with N CPUs, it may be perfectly
> > sufficient to have a much smaller number of rcuos threads.
> > 
> > One thread can probably handle the RCU callbacks for as many as
> > 16, or even 64 CPUs...
> 
> In many cases, one thread could handle the RCU callbacks for way more
> than that.  In other cases, a single CPU could keep a single rcuo kthread
> quite busy.  So something dynamic ends up being required.
> 
> But I suspect that the real solution here is to adjust the Kconfig setup
> between NO_HZ_FULL and RCU_NOCB_CPU_ALL so that you have to specify boot
> parameters to get callback offloading on systems built with NO_HZ_FULL.
> Then add some boot-time code so that any CPU that has nohz_full= is
> forced to also have rcu_nocbs= set.  This would have the good effect
> of applying callback offloading only to those workloads for which it
> was specifically designed, but allowing those workloads to gain the
> latency-reduction benefits of callback offloading.
> 
> I do freely confess that I was hoping that callback offloading might one
> day completely replace RCU_SOFTIRQ, but that hope now appears to be at
> best premature.
> 
> Something like the attached patch.  Untested, probably does not even build.

Against all odds, it builds and passes moderate rcutorture testing.

Although this doesn't satisfy the desire to wean RCU of softirq, it does
allow NO_HZ_FULL kernels to maintain better compatibility with earlier
kernel versions, which appears to be more important for the time being.

							Thanx, Paul

> ------------------------------------------------------------------------
> 
> rcu: Don't offload callbacks unless specifically requested
> 
> <more here soon>
> 
> Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d76b99af1b9..9332d33346ac 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -737,7 +737,7 @@ choice
>  
>  config RCU_NOCB_CPU_NONE
>  	bool "No build_forced no-CBs CPUs"
> -	depends on RCU_NOCB_CPU && !NO_HZ_FULL
> +	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
>  	help
>  	  This option does not force any of the CPUs to be no-CBs CPUs.
>  	  Only CPUs designated by the rcu_nocbs= boot parameter will be
> @@ -751,7 +751,7 @@ config RCU_NOCB_CPU_NONE
>  
>  config RCU_NOCB_CPU_ZERO
>  	bool "CPU 0 is a build_forced no-CBs CPU"
> -	depends on RCU_NOCB_CPU && !NO_HZ_FULL
> +	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
>  	help
>  	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
>  	  callbacks are invoked by a per-CPU kthread whose name begins
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 58fbb8204d15..3b150bfcce3d 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2473,6 +2473,9 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
>  
>  	if (rcu_nocb_mask == NULL)
>  		return;
> +#ifdef CONFIG_NO_HZ_FULL
> +	cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
>  	if (ls == -1) {
>  		ls = int_sqrt(nr_cpu_ids);
>  		rcu_nocb_leader_stride = ls;

