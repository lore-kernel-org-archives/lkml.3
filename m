Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3BDTBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:01:21 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52845 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab3BDTBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:01:20 -0500
Date: Mon, 4 Feb 2013 10:59:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] rcu: Have rcu torture test select trace_clock
Message-ID: <20130204185938.GY2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1359993141.5642.61.camel@gandalf.local.home>
 <20130204165932.GW2632@linux.vnet.ibm.com>
 <1360002973.5642.66.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360002973.5642.66.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020419-7182-0000-0000-000004ED4D6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:36:13PM -0500, Steven Rostedt wrote:
> On Mon, 2013-02-04 at 08:59 -0800, Paul E. McKenney wrote:
> > On Mon, Feb 04, 2013 at 10:52:21AM -0500, Steven Rostedt wrote:
> > > The rcu torture test uses trace_clock, and requires that it be built
> > > into the kernel. If it is not, then we get the following build error:
> > > 
> > > ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> > > 
> > > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > This would work, but would unnecessarily force trace_clock_local()
> > to be defined when RCU tracing is disabled.  So, would the alternative
> > patch I posted work for you?
> > 
> 
> Unfortunately the other patch wasn't Cc'd to LKML (I hate private
> emails).
> 
> I would suggest the following to be complete, why keep that extra divide
> around?

Good point, queued!

							Thanx, Paul

> -- Steve
> 
> I started with your patch:
> 
> 
> rcu: Allow rcutorture to be built at low optimization levels
> 
> The uses of trace_clock_local() are dead code when CONFIG_RCU_TRACE=n,
> but some compilers might nevertheless generate code calling this function.
> This commit therefore ensures that trace_clock_local() is invoked only
> when CONFIG_RCU_TRACE=y.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-trace.git/kernel/rcutorture.c
> ===================================================================
> --- linux-trace.git.orig/kernel/rcutorture.c
> +++ linux-trace.git/kernel/rcutorture.c
> @@ -208,6 +208,20 @@ MODULE_PARM_DESC(rcutorture_runnable, "S
>  #define rcu_can_boost() 0
>  #endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
> 
> +#ifdef CONFIG_RCU_TRACE
> +static u64 notrace rcu_trace_clock_local(void)
> +{
> +	u64 ts = trace_clock_local();
> +	unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
> +	return ts;
> +}
> +#else /* #ifdef CONFIG_RCU_TRACE */
> +static u64 notrace rcu_trace_clock_local(void)
> +{
> +	return 0ULL;
> +}
> +#endif /* #else #ifdef CONFIG_RCU_TRACE */
> +
>  static unsigned long shutdown_time;	/* jiffies to system shutdown. */
>  static unsigned long boost_starttime;	/* jiffies of next boost test start. */
>  DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
> @@ -1051,7 +1065,7 @@ static void rcu_torture_timer(unsigned l
> 
>  	idx = cur_ops->readlock();
>  	completed = cur_ops->completed();
> -	ts = trace_clock_local();
> +	ts = rcu_trace_clock_local();
>  	p = rcu_dereference_check(rcu_torture_current,
>  				  rcu_read_lock_bh_held() ||
>  				  rcu_read_lock_sched_held() ||
> @@ -1075,8 +1089,6 @@ static void rcu_torture_timer(unsigned l
>  	}
>  	completed_end = cur_ops->completed();
>  	if (pipe_count > 1) {
> -		unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
> -
>  		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu, ts,
>  					  completed, completed_end);
>  		rcutorture_trace_dump();
> @@ -1122,7 +1134,7 @@ rcu_torture_reader(void *arg)
>  		}
>  		idx = cur_ops->readlock();
>  		completed = cur_ops->completed();
> -		ts = trace_clock_local();
> +		ts = rcu_trace_clock_local();
>  		p = rcu_dereference_check(rcu_torture_current,
>  					  rcu_read_lock_bh_held() ||
>  					  rcu_read_lock_sched_held() ||
> @@ -1144,9 +1156,6 @@ rcu_torture_reader(void *arg)
>  		}
>  		completed_end = cur_ops->completed();
>  		if (pipe_count > 1) {
> -			unsigned long __maybe_unused ts_rem =
> -					do_div(ts, NSEC_PER_USEC);
> -
>  			do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu,
>  						  ts, completed, completed_end);
>  			rcutorture_trace_dump();
> 
> 

