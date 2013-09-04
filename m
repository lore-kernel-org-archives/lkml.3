Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3IDESg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:18:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53665 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3IDESf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:18:35 -0400
Date: Tue, 3 Sep 2013 21:18:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130904041828.GP3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.601365837@goodmis.org>
 <20130903171516.16290c47@gandalf.local.home>
 <20130903221808.GH3871@linux.vnet.ibm.com>
 <20130903195705.3ba3442f@gandalf.local.home>
 <20130904012404.GI3871@linux.vnet.ibm.com>
 <20130903220115.1018d8f4@gandalf.local.home>
 <20130903220325.273c2c7d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903220325.273c2c7d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090404-0928-0000-0000-0000013F1EF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 10:03:25PM -0400, Steven Rostedt wrote:
> On Tue, 3 Sep 2013 22:01:15 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 3 Sep 2013 18:24:04 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > 
> > > >  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> > > > @@ -588,15 +593,14 @@ static void
> > > >  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> > > >  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> > > >  {
> > > > -	int bit;
> > > > -
> > > > +	/* Make sure we see disabled or not first */
> > > > +	smp_rmb();
> > > 
> > > 	smp_mb__before_atomic_inc()?
> > > 
> > 
> > Ah, but this is before an atomic_read(), and not an atomic_inc(), thus
> > the normal smp_rmb() is still required.
> > 
> 
> Here's the changes against this one: 
> 
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index cdcf187..9e6902a 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -569,14 +569,14 @@ void ftrace_unsafe_rcu_checker_disable(void)
>  {
>  	atomic_inc(&ftrace_unsafe_rcu_disabled);
>  	/* Make sure the update is seen immediately */
> -	smp_wmb();
> +	smp_mb__after_atomic_inc();
>  }
> 
>  void ftrace_unsafe_rcu_checker_enable(void)
>  {
>  	atomic_dec(&ftrace_unsafe_rcu_disabled);
>  	/* Make sure the update is seen immediately */
> -	smp_wmb();
> +	smp_mb__after_atomic_dec();
>  }
> 
>  static void
> 
> 
> 
> Which is nice, because the smp_mb() are now in the really slow path.

Looks good!

But now that I look at it more carefully, including the comments...
The smp_mb__after_atomic_dec() isn't going to make the update be seen
faster -- instead, it will guarantee that if some other CPU sees this
CPU's later write, then that CPU will also see the results of the
atomic_dec().

							Thanx, Paul

