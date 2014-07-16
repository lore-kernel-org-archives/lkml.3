Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaGPNON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:14:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53865 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933690AbaGPNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:14:09 -0400
Date: Wed, 16 Jul 2014 06:14:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
Message-ID: <20140716131403.GS8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com>
 <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com>
 <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
 <20140711094333.GG16041@linux.vnet.ibm.com>
 <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com>
 <20140712120806.GA16041@linux.vnet.ibm.com>
 <CAJhHMCA7crMuM=owe4T0S5FUZi1SGZPo5OFRtb6Cr5_veJzd+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCA7crMuM=owe4T0S5FUZi1SGZPo5OFRtb6Cr5_veJzd+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071613-7164-0000-0000-0000032BE34D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:27:00AM -0400, Pranith Kumar wrote:
> On Sat, Jul 12, 2014 at 8:08 AM, Paul E. McKenney wrote:
> >
> > They ensure that any RCU read-side critical sections that took place before
> > the current (or previous) idle/userspace period on the remote CPU in
> > question are seen as having completed before the completion of the current
> > grace period.  It also ensures that any RCU read-side critical sections
> > that extend beyond the end of the current grace period (thus starting
> > after the current (or previous) idle/userspace period) see any updates
> > that were carried out before the beginning of the current grace period.
> >
> > Of course, that is also the purpose of many of RCU's memory barriers,
> > so this probably doesn't help much.  An alternative explanation is that
> > it ensures a coherent view of the ->dynticks counter, but I am quite
> > sure that this helps even less.
> >
> > So here is the problem we are having:
> >
> > The dyntick_save_progress_counter() and rcu_implicit_dynticks_qs()
> > functions are really bad places to start reading the RCU code.  I would
> > say that starting there is like learning to swim by diving into the deep
> > end of a swimming pool, but that doesn't really capture it.  Instead,
> > it is more like learning to swim by diving from the top of this waterfall:
> >
> > http://blog.pacificnorthwestphotography.com/wp-content/uploads/2011/03/54.jpg
> >
> > To understand these functions, you will first need to understand how
> > the rest of RCU works.  These functions are tiny cogs in RCU's energy
> > efficiency optimization mechanism, which fits into the larger grace-period
> > detection mechanism.  The purpose of the two atomic operations is to
> > preserve the memory-ordering guarantees called out in the docbook header
> > comments for call_rcu() and synchronize_rcu(), and I must confess that
> > it is not clear to me that you actually read these header comments.
> > Even so, these two functions interact with lots of other accesses to
> > implement these guarantees -- so again, it is really really difficult
> > to understand these two functions in isolation.
> >
> > Please see the end of this message for my suggested order of learning
> > the RCU code.  A study plan, if you will.
> 
> This guide helps a lot, thank you for the detailed study plan. I will
> make sure to go slow and steady. :)

Best of everything with it!

> I believe my question was about a local issue, let me try to explain.
> 
> My question stems from my understanding of why barriers are needed:
> 
> (i) to prevent compiler re-ordering of memory accesses
> (ii) to ensure a partial ordering of memory accesses (global visibility)

Another way to put this is that barriers prevent both the compiler
(your i) and the CPU (your ii) from re-ordering memory references.

> Barriers are also costly and hence must be used sparingly, if at all.

Sometimes they are costly, as in smp_mb(), and sometimes they are almost
free, as in smp_read_barrier_depends() on most architectures.

> I understand the need to use a barrier before/after an update to
> a shared variable. And using a barrier before a read access to a
> shared variable makes sense, as it ensures that we order this read
> with a previous write from the same CPU, if any.
> 
> The question here is this: why do we need a barrier after a read
> access to a shared variable?

I suggest studying Scenario 3 (message and flag) in the LWN article
entitled "User-space RCU: Memory-barrier menagerie".  Here if CPU 0
fails to have a memory barrier after the read from "x", the BUG_ON()
expression can trigger.

> The only reason I could think of is reason (i) above, but looking at
> the code, we can see that the read cannot really float around. Did I
> miss something or is there something fundamentally wrong with my
> thinking?

The idea is to keep the things following the read, for example, any
code executed after the end of the grace period, from being reordered
with that read.  But as stated several times before, you really need to
know quite a bit more about how RCU works for this to make much sense.
This particular access is one small piece of a larger group that allows
RCU to correctly implement its memory ordering properties.  Trying to
understand this access in isolation is sort of like trying to understand
a piston without knowing about the cylinder, piston rod, and crankshaft.

> Please note that all updates to dynticks are already strongly
> ordered as the updates are wrapped with barriers both before and
> after. So _reading_ the dynticks variable on other CPUs should be
> consistent i.e., an update should be immediately visible.

Please see above.

Memory ordering is not about consistent access to a single variable,
but rather about ordering accesses to multiple variables.

							Thanx, Paul

