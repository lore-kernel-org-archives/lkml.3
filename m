Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaGLMIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:08:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59461 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGLMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:08:12 -0400
Date: Sat, 12 Jul 2014 05:08:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
Message-ID: <20140712120806.GA16041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com>
 <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com>
 <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
 <20140711094333.GG16041@linux.vnet.ibm.com>
 <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071212-8236-0000-0000-000003C94F9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:32:17PM -0400, Pranith Kumar wrote:
> On Fri, Jul 11, 2014 at 5:43 AM, Paul E. McKenney  wrote:
> > On Thu, Jul 10, 2014 at 09:17:33PM -0400, Pranith Kumar wrote:
> >> On Wed, Jul 9, 2014 at 3:56 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> <snip>
> >> > OK, so ->dynticks_snap is accessed by only one task, namely the
> >> > corresponding RCU grace-period kthread.  So it can be accessed without
> >> > any atomic instructions or memory barriers, since all accesses to it are
> >> > single-threaded.  On the other hand, ->dynticks is written by one CPU
> >> > and potentially accessed from any CPU.  Therefore, accesses to it must
> >> > take concurrency into account.  Especially given that any confusion can
> >> > fool RCU into thinking that a CPU is idle when it really is not, which
> >> > could result in too-short grace periods, which could in turn result in
> >> > random memory corruption.
> >>
> >> Yes, I missed reading the call-chain for accessing dynticks_snap. It
> >> does not need any synchronization/barriers.
> >>
> >> Here since we are reading ->dynticks, doesn't having one barrier
> >> before reading make sense? like
> >>
> >> smp_mb();
> >> dynticks_snap = atomic_read(...->dynticks);
> >>
> >> instead of having two barriers with atomic_add_return()? i.e.,
> >> why is the second barrier necessary?
> >
> > I suggest looking at the docbook comment headers for call_rcu() and
> > synchronize_rcu() and thinking about the memory-barrier guarantees.
> > Those guarantees are quite strong, and so if you remove any one of a
> > large number of memory barriers (either explicit or, as in this case,
> > implicit in some other operation), you will break RCU.
> >
> > Now, there might well be some redundant memory barriers somewhere in
> > RCU, but the second memory barrier implied by this atomic_add_return()
> > most certainly is not one of them.
> 
> One reason I could think of having barriers on both sides here is to
> disable the read to float around. But in these two particular cases
> that does not seem to be necessary.
> 
> Could you please clarify why a barrier after this atomic read is
> required? Almost all the barriers are commented about why they are
> necessary. Would be good to have that here too.

They ensure that any RCU read-side critical sections that took place before
the current (or previous) idle/userspace period on the remote CPU in
question are seen as having completed before the completion of the current
grace period.  It also ensures that any RCU read-side critical sections
that extend beyond the end of the current grace period (thus starting
after the current (or previous) idle/userspace period) see any updates
that were carried out before the beginning of the current grace period.

Of course, that is also the purpose of many of RCU's memory barriers,
so this probably doesn't help much.  An alternative explanation is that
it ensures a coherent view of the ->dynticks counter, but I am quite
sure that this helps even less.

So here is the problem we are having:

The dyntick_save_progress_counter() and rcu_implicit_dynticks_qs()
functions are really bad places to start reading the RCU code.  I would
say that starting there is like learning to swim by diving into the deep
end of a swimming pool, but that doesn't really capture it.  Instead,
it is more like learning to swim by diving from the top of this waterfall:

http://blog.pacificnorthwestphotography.com/wp-content/uploads/2011/03/54.jpg

To understand these functions, you will first need to understand how
the rest of RCU works.  These functions are tiny cogs in RCU's energy
efficiency optimization mechanism, which fits into the larger grace-period
detection mechanism.  The purpose of the two atomic operations is to
preserve the memory-ordering guarantees called out in the docbook header
comments for call_rcu() and synchronize_rcu(), and I must confess that
it is not clear to me that you actually read these header comments.
Even so, these two functions interact with lots of other accesses to
implement these guarantees -- so again, it is really really difficult
to understand these two functions in isolation.

Please see the end of this message for my suggested order of learning
the RCU code.  A study plan, if you will.

> <snip>
> >>
> >> Sorry to ask you about such an old change. But I am not able to see
> >> why we need atomic_t for dynticks here since per-cpu operations are
> >> guaranteed to be atomic.
> >
> > Per-CPU operations are guaranteed to be atomic?  When one CPU is accessing
> > another CPU's per-CPU variable, as is the case here?  Can't say that I
> > believe you.  ;-)
> 
> this_cpu_ops() are guaranteed to be atomic when operating on local
> per-cpu variables. When we are operating on other CPU's per-cpu
> variables directly this does not hold.

Exactly!!!

> dynticks here is a per-cpu variable. I don't understand why one CPU
> needs to access another CPU's dynticks variable.

Because if RCU wakes up an idle CPU to determine that it was idle,
the guys that care about battery lifetime will get very angry with me.
This means that the CPU running the grace-period kthread needs to access
these idle CPUs' dyntick-idle state.  Because this state is recorded
in per-CPU variables, this means on CPU accessing another CPU's per-CPU
variables.

And yes, there has been talk about restricting cross-CPU access to per-CPU
variables.  Some people have been insisting that you should use IPIs in
these cases, but if I use IPIs, battery lifetime becomes a big problem.

So what to do?  Well, if people really do impose those sorts of
restrictions, RCU will simply move some of its state from per-CPU
variables to the old-school NR_CPUS-element arrays.  We should always use
the right tool for the job, so if some tool suddenly becomes the wrong
tool, then it is necessary to switch to some other tool.  Pretty simple!

> >> It gets twisted pretty fast trying to understand the RCU code. No
> >> wonder people say that rcu is scary black magic :)
> >
> > Well, let's just say that this isn't one of the parts of the RCU code
> > that should be randomly hacked.  Lots and lots of ways to get it wrong,
> > and very few ways to get it right.  And most of the ways of getting it
> > right are too slow or too non-scalable to be useful.
> 
> I am definitely not trying to hack randomly. Reading the code is very
> educating. I tried looking up why this was being done and it was not
> clear from the code and history. I was thinking of getting hold of you
> on IRC, but was not sure if that is such a good idea. I'll ask
> questions instead of sending RFCs from now on.

Perhaps instead of saying "hack randomly" I should have said "hack
locally on portions of RCU requiring global knowledge."  I am not trying
to insult you or to discourage you.  Instead, I am simply pointing out
that some parts of RCU are more intertwined than others, and suggesting
that you start hacking on the parts that are less intertwined.  Over time,
you will learn more about RCU and hopefully become able to take on some
of the more intertwined parts of RCU.

> > Speaking of portions of RCU that are more susceptible to local-knowledge
> > hacking, how are things going on that rcutorture printing fixup?
> 
> It must have reached your inbox by now :)

Indeed it did, along with a review.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

In a perfect world, there would be up-to-date design documents describing
RCU.  This being the real world, what is available is imcomplete and
outdated, but see http://www2.rdrop.com/users/paulmck/RCU/ for a long
list of writeups.  Of these, the most important are Documentation/RCU/*
and http://lwn.net/Articles/262464/, http://lwn.net/Articles/263130/,
and http://lwn.net/Articles/418853/.  But you probably have already
read these.

If you really want to understand RCU strictly from the source code,
that can be done, but you will need to choose your starting point very
very carefully.  I suggest the following approach:


1.	Start with TINY_RCU as a warmup exercise.  This does everything
	that RCU needs to do, but on a uniprocessor system.  Therefore,
	this is a good starting point to see how RCU interacts with
	the rest of the kernel.

2.	Move to userspace RCU, first reading the paper:
	http://www.rdrop.com/users/paulmck/RCU/urcu-main-accepted.2011.08.30a.pdf
	http://www.computer.org/cms/Computer.org/dl/trans/td/2012/02/extras/ttd2012020375s.pdf
	Then moving on to the code, which has changed a bit since the
	paper was written.

	This paper is highly recommended as it also gives a good overview
	of what RCU is trying to accomplish.

3.	Move to SRCU in include/linux/srcu.h and kernel/rcu/srcu.c.
	This gives a compact view of some of the memory-barrier tricks
	that RCU uses to provide its memory-ordering guarantees.

4.	Move to TREE_RCU, but with restricted Kconfig and workload:

	o	Start at call_rcu().

	o	Assume CONFIG_TREE_RCU=y and that most of the other Kconfig
		variables are deselected.  This will allow you to ignore the
		bulk of kernel/rcu/tree_plugin.h initially.

	o	Assume that CPUs never enter dyntick-idle state, so that
		rdp->dynticks->dynticks always has an odd-numbered value.

	o	Assume that all RCU grace periods end quickly, allowing
		you to ignore the stall-warning code.

5.	At this point, a quick review of the recent LWN articles on
	RCU features would help. http://lwn.net/Kernel/Index/#Read-copy-update

6.	The might be a good time to look at the dyntick-idle and
	CPU stall-warning mechanisms.

7.	Add in Kconfig variables one at a time, thus incrementally including
	code from kernel/rcu/tree_plugin.h.

