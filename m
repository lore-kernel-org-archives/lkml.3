Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549Ab3IDLub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:50:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3IDLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:50:30 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6vL9NhcTi7YA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lu4-lkDicUYA:10 a=VnNF1IyMAAAA:8 a=J5_Iyqi5gACGRI3eAPwA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 07:50:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130904075027.483ab9fb@gandalf.local.home>
In-Reply-To: <20130904041828.GP3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
	<20130903171516.16290c47@gandalf.local.home>
	<20130903221808.GH3871@linux.vnet.ibm.com>
	<20130903195705.3ba3442f@gandalf.local.home>
	<20130904012404.GI3871@linux.vnet.ibm.com>
	<20130903220115.1018d8f4@gandalf.local.home>
	<20130903220325.273c2c7d@gandalf.local.home>
	<20130904041828.GP3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013 21:18:28 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Sep 03, 2013 at 10:03:25PM -0400, Steven Rostedt wrote:
> > On Tue, 3 Sep 2013 22:01:15 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Tue, 3 Sep 2013 18:24:04 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > 
> > > > >  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> > > > > @@ -588,15 +593,14 @@ static void
> > > > >  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> > > > >  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> > > > >  {
> > > > > -	int bit;
> > > > > -
> > > > > +	/* Make sure we see disabled or not first */
> > > > > +	smp_rmb();
> > > > 
> > > > 	smp_mb__before_atomic_inc()?
> > > > 
> > > 
> > > Ah, but this is before an atomic_read(), and not an atomic_inc(), thus
> > > the normal smp_rmb() is still required.
> > > 
> > 
> > Here's the changes against this one: 
> > 
> > diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> > index cdcf187..9e6902a 100644
> > --- a/kernel/trace/trace_functions.c
> > +++ b/kernel/trace/trace_functions.c
> > @@ -569,14 +569,14 @@ void ftrace_unsafe_rcu_checker_disable(void)
> >  {
> >  	atomic_inc(&ftrace_unsafe_rcu_disabled);
> >  	/* Make sure the update is seen immediately */
> > -	smp_wmb();
> > +	smp_mb__after_atomic_inc();
> >  }
> > 
> >  void ftrace_unsafe_rcu_checker_enable(void)
> >  {
> >  	atomic_dec(&ftrace_unsafe_rcu_disabled);
> >  	/* Make sure the update is seen immediately */
> > -	smp_wmb();
> > +	smp_mb__after_atomic_dec();
> >  }
> > 
> >  static void
> > 
> > 
> > 
> > Which is nice, because the smp_mb() are now in the really slow path.
> 
> Looks good!
> 
> But now that I look at it more carefully, including the comments...
> The smp_mb__after_atomic_dec() isn't going to make the update be seen
> faster -- instead, it will guarantee that if some other CPU sees this
> CPU's later write, then that CPU will also see the results of the
> atomic_dec().

I don't need to have it seen "faster", just before anything that comes
next after the call to ftrace_unsafe_rcu_checker_disable(). That's
what I meant by the comment. In other words, don't delay this write, it
needs to go first.

-- Steve

