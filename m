Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaFLPwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:52:32 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:59382 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaFLPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:52:31 -0400
Date: Thu, 12 Jun 2014 11:52:27 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140612155227.GB23606@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612153426.GV4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Thu, Jun 12, 2014 at 08:34:26AM -0700, Paul E. McKenney wrote:
> > It can be argued that smp_read_barrier_depends() is the responsibility
> > of the caller; however, discerning local and remote accesses gets very
> > confusing with percpu areas (initialized remotely but local to this
> > cpu and vice-versa) and data dependency barrier is free on all archs
> > except for alpha, so I think it's better to include it as part of
> > percpu accessors and operations.
> 
> OK, I will bite...  Did you find a bug of this form?  (I do see a
> couple of possible bugs on a quick look, so maybe...)

I don't have an actual bug report or repro case, which isn't too
surprising given that this can't happen on x86, but I know of places
where percpu pointer is used opportunistically (if allocated) which
would be affected by this.

> I would argue that the code above should instead say something like:
> 
> 	smp_store_release(p, alloc_percpu());

Well, we can always say that it's the caller's responsibility to put
in enough barriers, but it becomes weird for percpu areas because the
ownership of the allocated areas isn't really clear.  Whether each
allocated cpu-specific area's queued writes belong to the allocating
cpu or the cpu that the area is associated with is an implementation
detail which may theoretically change and as such I think it'd be best
for the problem to be dealt with in percpu allocator and accessors
proper.  I think this is way too subtle to ask the users to handle
correctly.

> I was worried about use of per_cpu() by the reading CPU, but of course
> in that case, things are initialized at compiler time.

Not really.  The template is initialized on kernel load.  The actual
percpu areas have to be allocated dynamically; however, this happens
while the machine is still running UP, so this should be okay.

> > I wonder whether we also need a smp_wmb() for other __GFP_ZERO
> > allocations.  There isn't one and requiring the users to perform
> > smp_wmb() to ensure the propagation of zeroing seems too subtle.
> 
> I would say "no" even if we do decide that alloc_percpu() needs
> an smp_wmb().  The reason is that you really do have to store the
> pointer at some point, and you should use smp_store_release() for
> this task, at least if you are storing to something accessible to
> other CPUs.

For normal allocations, I don't have a strong opinion.  I'd prefer to
think of memory coming out of the allocator to have memory ordering
already taken care of but it is a lot less murky than with percpu
areas.

Thanks.

-- 
tejun
