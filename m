Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaHHPjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:39:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:31207 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752570AbaHHPjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:39:54 -0400
Date: Fri, 8 Aug 2014 11:39:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808113949.046522c5@gandalf.local.home>
In-Reply-To: <20140808151643.GD9918@twins.programming.kicks-ass.net>
References: <20140807172753.GG3588@twins.programming.kicks-ass.net>
	<20140807184635.GI3588@twins.programming.kicks-ass.net>
	<20140807154907.6f59cf6e@gandalf.local.home>
	<20140807155326.18481e66@gandalf.local.home>
	<20140807200813.GB3935@laptop>
	<20140807171823.1a481290@gandalf.local.home>
	<20140808064020.GZ9918@twins.programming.kicks-ass.net>
	<20140808101221.21056900@gandalf.local.home>
	<20140808143413.GB9918@twins.programming.kicks-ass.net>
	<20140808105858.171da847@gandalf.local.home>
	<20140808151643.GD9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 17:16:43 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

 
> > Well, kprobes, like function callbacks are just restricted like
> > interrupt handlers are. If they break, they break. They should know
> > better ;-)
> 
> But is there debugging infrastructure to test they don't do funny? Or
> are we just going to wait for some random runtime weirdness and then
> pull our hair out?

Well, currently there isn't many handler. I'm not sure about kprobes.
They only have a few handlers too. Just enabling the handler to run
under interrupt or NMI context would probably be enough to see if they
do something stupid.

> 
> So do we run these handlers with preempt_disable() or anything like
> that? (maybe only as a debug option).

Actually, for dynamically created ftrace_ops (like perf, and
ftrace instances), we call a wrapper function that does disable
preemption. Because we still need to free the "ops" part, which is
passed to the handler. And we don't want some handler being called
without ops, or even the list function.

Any dynamic ops is called by the ftrace list routine always, because it
disables preemption before traversing the list. Here we can't even us
synchronize_sched() because the function tracer can be called outside
the scope of RCU (going into, out of idle or userspace). Thus, when a
dynamically created ftrace ops is unregistered, a call to
schedule_on_each_cpu() is made, and when that returns, we free the ops.
 
> 
> > > Sure, as long as you make absolutely sure none of that code ends up
> > > calling cond_resched()/might_sleep() etc. Which I think you already said
> > > was true, so no worries there.
> > 
> > Right. There's no guarantees that someone wont do such a stupid thing.
> > But then, there's no guarantees that someone wont register an NMI
> > callback with the same code too.
> 
> Well, kprobes is 'special' in that it it almost encourages random non
> kernel devs to write modules for it, so it gets extra special creative
> crap in.

Well, crap gets what crap deserves ;-)

> 
> I'm fairly sure you'll get your ftrace handler right, because that's
> only you and maybe a few other people ever touching that code. Not so
> with kprobes.

Actually, that's becoming less true. What do you think the live
kernel patching is going to use?

Also, anyone can register a function handler (perf, systemtap, and even
LTTng can). But these still get wrapped by that preempt off.

But we can still make a debug option that has the trampoline disable
preemption, and this will make sure the function it calls doesn't do
something stupid.

> 
> > > Sure, I get that part. What I was getting as is _WHY_ you need
> > > call_rcu_task(), why isn't synchronize_tasks() good enough?
> > 
> > Oh, because that synchronize_tasks() may take minutes. And that means
> > we wont be able to return for a long time. The only thing I can really
> > see using call_rcu_task() is something that needs to free its data. Why
> > wait around when all you're going to do is call free? It's basically
> > just a garbage collector.
> 
> Well the waiting has the advantage of being a natural throttle on the
> amount of memory tied up in the whole scheme.

Yeah, but it would suck if you do "echo nop > current_tracer" while
running something that is preventing a task to unload, and have to wait
a few minutes for that to return.

> 
> > > > What we want to do today, is to create a dynamic trampoline for each of
> > > > theses 1000 functions. Each function will call a separate trampoline
> > > > that will only call the function that was registered to it. That way,
> > > > we can have 1000 different ops registered to 1000 different functions
> > > > and still have the same performance.
> > > 
> > > And how will you limit the amount of memory tied up in this? This looks
> > > like a good way to tie up an immense amount of memory fast.
> > 
> > Well, these operations are currently only allowed by root. Thus, it's
> > the thing that root should be careful about. The trampolines are small,
> > and it will take a hell of a lot of callbacks to cause issues.
> 
> You said 10e3 order things, I then give you a small 32bit arm system.
> 
> The thing is, even root is a clueless idiot most of the times, yes we'll
> let him shoot his foot off and give him enough rope to hang himself, and
> we'll even show him how to tie the knot at times, but how is he to know
> that this script that 'worked' now causes his machine to OOM and behave
> brick like?

Honestly, to allocate 1000 different callbacks now, requires allocating
1000 different ops, which are much larger than a single trampoline.
Right now, the only way to do that is to create a 1000 ftrace
instances, and those creates a 1000 directories, would would include
1000 event directories, each having its own dentry for each event
(around 900).

I don't think we need to worry about this use to work on a small arm 32
bit system and it doesn't work now. The difference in memory
consumption is not that much.


> 
> > The thing I'm worried about is to make sure they get freed. Otherwise a
> > leak will cause more issues than anything else. Which also means we
> > need to have a way to expedite call_rcu_tasks() if need be.
> 
> No.. for one, that doesn't follow. Things will get freed (eventually)
> even without expedite, and secondly implementing expedite would mean
> force scheduling tasks etc. And we're just so not going to do that.
> 
> 

Yeah, you are probably right. This should not be used much, and for
now, only by root users (or other privilege users). And the amount of
memory that needs to be freed will be very small. It would probably be
very difficult to DoS the system with this feature even if you had root.

-- Steve
