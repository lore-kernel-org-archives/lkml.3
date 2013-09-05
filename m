Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3IEU1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:27:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3IEU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:27:53 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DA-RvV7NLMYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6u4amIDVaRwA:10 a=JfrnYn6hAAAA:8 a=VTRQp1l0jkDh5ajDjggA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 5 Sep 2013 16:27:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep
 splat show what function triggered
Message-ID: <20130905162752.236107ba@gandalf.local.home>
In-Reply-To: <20130905193553.GG31370@twins.programming.kicks-ass.net>
References: <20130831051117.884125230@goodmis.org>
	<20130831051702.766697014@goodmis.org>
	<20130905193553.GG31370@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 21:35:53 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Why put RHT in there? Surely greg and jonathan know you work for them?
> :-)
> 

It has nothing to do with Greg or Jonathan. Even though I think they
both told me the same thing. It has to do with anyone looking at a git
commit, and they will know that my work on this commit was sponsored by
Red Hat. Has nothing to do with those silly stat numbers that come out
every release ;-)



> > When the RCU lockdep splat hits because of the unsafe RCU checker,
> > the backtrace does not always show the culprit. But the culprit was
> > passed to the unsafe RCU checker.
> > 
> > Save the ip of the function being traced in a per_cpu variable, and
> > when the RCU lockdep detects a problem, it can also print out what
> > function was being traced if it was caused by the unsafe RCU checker.
> 
> So the below is an example of why this_cpu_* is utter shite, what
> ensures the code there isn't preemptible.

No disagreements with me about the utter shite, but what ensures it is
what is hidden from the patch. If I expand the code a little, I get
this:

        preempt_disable_notrace();

        if (this_cpu_read(ftrace_rcu_running))
                goto out;

        if (WARN_ONCE(ftrace_rcu_unsafe(ip),
                      "UNSAFE RCU function called %pS",
                      (void *)ip))
                goto out;

        this_cpu_write(ftrace_rcu_running, 1);
        this_cpu_write(ftrace_rcu_func, ip);

        /* Should trigger a RCU splat if called from unsafe RCU
        function */ rcu_read_lock();
        rcu_read_unlock();
        this_cpu_write(ftrace_rcu_func, 0);

        this_cpu_write(ftrace_rcu_running, 0);
 out:
        preempt_enable_notrace();



> 
> That said, I suppose you've thought about that and there's something
> obvious from the callpath but I can't be bothered to go hunt through the
> series if the changelog can't be bothered to clarify such things.
> 
> > @@ -592,9 +604,11 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> >  		      (void *)ip))
> >  		goto out;
> >  
> > +	this_cpu_write(ftrace_rcu_func, ip);
> >  	/* Should trigger a RCU splat if called from unsafe RCU function */
> >  	rcu_read_lock();
> >  	rcu_read_unlock();
> > +	this_cpu_write(ftrace_rcu_func, 0);
> >  
> >  	trace_clear_recursion(bit);
> >   out:
> 
> I suppose this is all ok. I haven't read the entire series and I'm not
> going to during my vacation.
> 
> One quick question though, why do we have to mark functions and can't
> rely on the state RCU already keeps? Surely RCU knows when its 'enabled'
> and thus safe to use RCU -- if only for debuggin.

Funny you should say that. I just recently asked Paul about this very
topic. It may make most of this patch series moot.

> 
> For instance that scheduler_ipi() call can happen in either state, do we
> really have to disallow it always?

Nope! The one thing I fear with this method is, is the inconsistency of
seeing the scheduler_ipi() traced, and not seeing it. I predict getting
nasty bug reports from people telling me that the tracer is broken.

"why don't I see scheduler_ipi() traced here! I see it here!!!! The
tracer is shite!"

> 
> Anyway, I suppose ACK on both these patches you asked me to look at, not
> particularly harmful it seems, just not something I feel I've got me
> head round atm.

Thanks for taking some of your PTO out to do this! Although, it may all
be in vain if I go the RCU state route. I wont need either of these
patches then.

-- Steve
