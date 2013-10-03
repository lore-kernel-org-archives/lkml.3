Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3JCX2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:28:37 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52273 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:28:35 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 3 Oct 2013 16:28:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131003232826.GA6604@jtriplet-mobl1>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:52:45PM -0700, Linus Torvalds wrote:
> On Thu, Oct 3, 2013 at 1:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > The problem is this:
> > A = 1, B = 1
> > CPU1:
> > A = 0
> > <full barrier>
> > synchronize_rcu()
> > read B
> >
> > CPU2:
> > rcu_read_lock()
> > B = 0
> > read A
> >
> > Are we guaranteed that we won't get both of them seeing ones, in situation
> > when that rcu_read_lock() comes too late to be noticed by synchronize_rcu()?
> 
> Yeah, I think we should be guaranteed that, because the
> synchronize_rcu() will guarantee that all other CPU's go through an
> idle period. So the "read A" on CPU2 cannot possibly see a 1 _unless_
> it happens so early that synchronize_rcu() definitely sees it (ie it's
> a "preexisting reader" by definition), in which case synchronize_rcu()
> will be waiting for a subsequent idle period, in which case the B=0 on
> CPU2 is not only guaranteed to happen but also be visible out, so the
> "read B" on CPU1 will see 0. And that's true even if CPU2 doesn't have
> an explicit memory barrier, because the "RCU idle" state implies that
> it has gone through a barrier.

I think the reasoning in one direction is actually quite a bit less
obvious than that.

rcu_read_unlock() does *not* necessarily imply a memory barrier (so the
B=0 can actually move logically outside the rcu_read_unlock()), but
synchronize_rcu() *does* imply (and enforce) that a memory barrier has
occurred on all CPUs as part of quiescence.  However, likewise,
rcu_read_lock() doesn't imply anything in particular about writes; it
does enforce either that reads can't leak earlier or that if they do a
synchronize_rcu() will still wait for them, but I don't think the safety
interaction between a *write* in the RCU reader and a *read* in the RCU
writer necessarily follows from that enforcement.

(Also, to the best of my knowledge, you don't even need a barrier on
CPU1; synchronize_rcu() should imply one.)

If synchronize_rcu() on CPU1 sees rcu_read_lock() on CPU2, then
synchronize_rcu() will wait for CPU2's read-side critical section and a
memory barrier before reading B, so CPU1 will see B==0.

The harder direction: If synchronize_rcu() on CPU1 does not see
rcu_read_lock() on CPU2, then it won't necessarily wait for anything,
and since rcu_read_lock() itself does not imply any CPU write barriers,
it's not at all obvious that rcu_read_lock() prevents B=0 from occurring
before CPU1's read of B.

In short, the interaction between RCU's ordering guarantees and CPU
memory barriers in the presence of writes on the read side and reads on
the write side does not seem sufficiently clear to support the portable
use of the above pattern without an smp_wmb() on CPU2 between
rcu_read_lock() and B=0.  I think it might happen to work with the
current implementations of RCU (with which synchronize_rcu() won't
actually notice a quiescent state and return until after either
the rcu_read_unlock() or a preemption point), but by the strict semantic
guarantees of the RCU primitives I think you could write a legitimate
RCU implementation that would break the above code.

That said, I believe this pattern *will* work with every existing
implementation of RCU.  Thus, I'd suggest documenting it as a warning to
prospective RCU optimizers to avoid breaking the above pattern.

- Josh Triplett
