Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3JDAlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:41:17 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47702 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JDAlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:41:16 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 3 Oct 2013 17:41:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004004108.GA9914@jtriplet-mobl1>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
 <20131003232826.GA6604@jtriplet-mobl1>
 <CA+55aFxvZV0brpjRERYj6Bb-i2kF+nhfCVvmXV5Bdn2QhEt5sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxvZV0brpjRERYj6Bb-i2kF+nhfCVvmXV5Bdn2QhEt5sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 04:51:00PM -0700, Linus Torvalds wrote:
> On Thu, Oct 3, 2013 at 4:28 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Thu, Oct 03, 2013 at 01:52:45PM -0700, Linus Torvalds wrote:
> >> On Thu, Oct 3, 2013 at 1:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> >
> >> > The problem is this:
> >> > A = 1, B = 1
> >> > CPU1:
> >> > A = 0
> >> > <full barrier>
> >> > synchronize_rcu()
> >> > read B
> >> >
> >> > CPU2:
> >> > rcu_read_lock()
> >> > B = 0
> >> > read A
> >> >
> >> > Are we guaranteed that we won't get both of them seeing ones, in situation
> >> > when that rcu_read_lock() comes too late to be noticed by synchronize_rcu()?
> >>
> >> Yeah, I think we should be guaranteed that, because the
> >> synchronize_rcu() will guarantee that all other CPU's go through an
> >> idle period. So the "read A" on CPU2 cannot possibly see a 1 _unless_
> >> it happens so early that synchronize_rcu() definitely sees it (ie it's
> >> a "preexisting reader" by definition), in which case synchronize_rcu()
> >> will be waiting for a subsequent idle period, in which case the B=0 on
> >> CPU2 is not only guaranteed to happen but also be visible out, so the
> >> "read B" on CPU1 will see 0. And that's true even if CPU2 doesn't have
> >> an explicit memory barrier, because the "RCU idle" state implies that
> >> it has gone through a barrier.
> >
> > I think the reasoning in one direction is actually quite a bit less
> > obvious than that.
> >
> > rcu_read_unlock() does *not* necessarily imply a memory barrier
> 
> Don't think of it in those terms.
> 
> The only thing that matters is semantics. The semantics of
> synchronize_rcu() is that it needs to wait for all RCU users. It's
> that simple. By definition, anything inside a "rcu_read_lock()" is a
> RCU user, so if we have a read of memory (memory barrier or not), then
> synchronize_rcu() needs to wait for it. Otherwise serialize_rcu() is
> clearly totally broken.

Read, yes, but I don't think that's enough to force your example above
to work in all cases.  That requires semantics beyond what RCU's
primitives guarantee, and I don't think you can draw conclusions about
those semantics without talking about CPU memory barriers.

synchronize_rcu() says it'll wait for any in-progress reader, which
includes whatever that reader might be doing.  That guarantees one
direction of your example above.  It's a tool for controlling what the
*reader* can observe.  The vast majority of RCU usage models assume the
writers will use a lock to guard against each other, and that readers
don't make modifications.  synchronize_rcu() doesn't make any particular
guarantees in the other direction about what the *writer* can observe,
especially in the case where synchronize_rcu() does not observe the
rcu_read_lock() and doesn't need to count that reader.  (Also note that
B=0 is a blind write, with no read.)

The example above will work on x86 with any reasonable implementation
(due to write ordering guarantees), and it should work on any
architecture with all the current implementations of RCU in the Linux
kernel.  If we want to require that all future implementations of RCU
allow the above example to work, we should document that example and
associated assumption for future reference, because I don't think the
semantics of the RCU primitives inherently guarantee it.

> Now, the fact that the normal rcu_read_lock() is just a compiler
> barrier may make you think "oh, it cannot work", but the thing is, the
> way things happens is that synchronize_rcu() ends up relying on the
> _scheduler_ data structures, rather than anything else. It requires
> seeing an idle scheduler state for each CPU after being called.

That's a detail of implementation.  In practice, the required semantics
of synchronize_rcu() would be perfectly satisfied by an implementation
that can divine that no readers are currently running without waiting
for everyone to pass through the scheduler.  synchronize_sched() means
"everyone has scheduled"; synchronize_rcu() *only* means "any readers
in-progress when I called synchronize_rcu() have finished when
synchronize_rcu() returns", which does not have to imply a trip through
the scheduler.

- Josh Triplett
