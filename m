Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaFXKO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:14:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaFXKOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:14:55 -0400
Date: Tue, 24 Jun 2014 10:46:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman Long <waiman.long@hp.com>, raghavendra.kt@linux.vnet.ibm.com,
        mingo@kernel.org, riel@redhat.com, oleg@redhat.com, gleb@redhat.com,
        virtualization@lists.linux-foundation.org, tglx@linutronix.de,
        chegu_vinod@hp.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, paolo.bonzini@gmail.com,
        scott.norton@hp.com, torvalds@linux-foundation.org,
        kvm@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
Message-ID: <20140624084619.GN13930@laptop.programming.kicks-ass.net>
References: <201406172323.s5HNNveT018439@userz7022.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406172323.s5HNNveT018439@userz7022.oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 07:23:44PM -0400, Konrad Rzeszutek Wilk wrote:
> > Actually in my v11 patch, I subdivided the slowpath into a slowpath for 
> > the pending code and slowerpath for actual queuing. Perhaps, we could 
> > use quickpath and slowpath instead. Anyway, it is a minor detail that we 
> > can discuss after the core code get merged.

> Why not do it the right way the first time around?

Because I told him to not do this. There's the fast path; the inline
single trylock cmpxchg, and the slow path; the out-of-line thing doing
the rest.

Note that pretty much all other locking primitives are implemented
similarly, with fast and slow paths.

I find that having the entire state machine in a single function is
easier.

> That aside - these optimization - seem to make the code harder to
> read. And they do remind me of the scheduler code in 2.6.x which was
> based on heuristics - and eventually ripped out.

Well, it increases the states and thereby the complexity, nothing to be
done about that. Also, its not a random heuristic in the sense that it
has odd behaviour. Its behaviour is very well controlled.

Furthermore, without this the qspinlock performance is too far off the
ticket lock performance to be a possible replacement.

> So are these optimizations based on turning off certain hardware
> features? Say hardware prefetching?

We can try of course, but that doesn't help the code -- in fact, adding
the switch to turn if off _adds_ code on top.

> What I am getting at - can the hardware do this at some point (or
> perhaps already does on IvyBridge-EX?) - that is prefetch the per-cpu
> areas so they are always hot? And rendering this optimization not
> needed?

Got a ref to documentation on this new fancy stuff? I might have an
IVB-EX, but I've not tried it yet.

That said, memory fetches are 100s of cycles, and while prefetch can
hide some of that, I'm not sure we can hide all of it, there's not
_that_ much we do.

If we observe the pending and locked bit set, we immediately drop to the
queueing code and touch it. So there's only a few useful instructions to
do.
