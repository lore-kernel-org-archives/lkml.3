Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951AbaFQQ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:57:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56689 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965665AbaFQQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:57:08 -0400
Date: Tue, 17 Jun 2014 09:57:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617165702.GF4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617152752.GC31819@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061716-7164-0000-0000-000002807578
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:27:52AM -0400, Tejun Heo wrote:
> Hello, Paul.
> 
> On Tue, Jun 17, 2014 at 07:41:51AM -0700, Paul E. McKenney wrote:
> > > Well, we can always say that it's the caller's responsibility to put
> > > in enough barriers, but it becomes weird for percpu areas because the
> > > ownership of the allocated areas isn't really clear.  Whether each
> > > allocated cpu-specific area's queued writes belong to the allocating
> > > cpu or the cpu that the area is associated with is an implementation
> > > detail which may theoretically change and as such I think it'd be best
> > > for the problem to be dealt with in percpu allocator and accessors
> > > proper.  I think this is way too subtle to ask the users to handle
> > > correctly.
> > 
> > But in the case where the allocation is initially zeroed, then a few
> > fields are initialized to non-zero values, the memory barrier in the
> > allocator is insufficient.  I believe that it will be easier for people
> 
> Oh, definitely but in those cases it's clear whose responsbility it
> is.  The task/cpu which modified the memory owns the in-flight
> modifications and is responsible for propagation.  The problem with
> zeroed allocation, especially for percpu areas, is that it isn't clear
> who owns the zeroing.  Again, there's no reason the zeroing can't
> belong to the each local cpu, which could have performance benefits if
> we ever get frequent enough with percpu allocations.  To me, this
> really seems like an implementation detail which shouldn't leak to the
> users of the allocator.

Good point about the possibility that CPUs might initialize their own
dynamically allocated per-CPU areas as needed!  And yes, in that case,
we would need some way of communicating what had and had not yet been
zeroed from the initializing CPUs to the allocating CPU, and that would
require memory barriers to sort things out.

That said, my guess is that the initialization would happen in rather
large chunks, otherwise the allocating CPU might frequently need to
wait on the other CPUs to do the initialization, which doesn't sound
like the way to performance and scalability.  So my guess is that the
common case looks something like this:

	CPU 0				CPU 1

	allocate/initialize big chunk
	smp_mb()
	update metadata accordingly

					load metadata
					if change from last time {
						update local copy of metadata
						smp_mb()
					}
					if (need more)
						ask all for more memory
					initialize non-zero pieces if needed
					smp_store_release()

I am not sure that this is actually better than having the allocating
CPU do the initialization, though, even given a large number of CPUs.
Or maybe even especially given a large number of CPUs.  The bit about
asking all the other CPUs to do their allocations and initializations
and then waiting for them to respond might not be pretty.

> > to always use smp_store_release() or whatever than to not need it if
> > the initialization is strictly zero, but to need it if additional
> > initialization is required.
> 
> That goes further and would require dedicated assignment macros for
> percpu pointers, a la rcu_assign_pointer().  Yeah, I think that would
> be helpful.  It'd take quite a bit of work but percpu allocator usage
> is still in low hundreds, so it should be doable.  The whole thing is
> way too subtle to require each user to handle it manually.
> 
> So, how about the followings?
> 
> * Add data dependency barrier to percpu accessors and write barrier to
>   the allocator with the comment that this will be replaced with
>   proper assignment macros and mark this change w/ -stable.
> 
> * Later, introduce percpu pointer assignment macros and convert all
>   users and remove the wmb added above.

This longer-term approach seems like a good one to me.

> > > > I was worried about use of per_cpu() by the reading CPU, but of course
> > > > in that case, things are initialized at compiler time.
> > > 
> > > Not really.  The template is initialized on kernel load.  The actual
> > > percpu areas have to be allocated dynamically; however, this happens
> > > while the machine is still running UP, so this should be okay.
> > 
> > Good point.  How about per-CPU variables that are introduced by
> > loadable modules?  (I would guess that there are plenty of memory
> > barriers in the load process, given that text and data also needs
> > to be visible to other CPUs.)
> 
> (cc'ing Rusty, hi!)
> 
> Percpu initialization happens in post_relocation() before
> module_finalize().  There seem to be enough operations which can act
> as write barrier afterwards but nothing seems explicit.
> 
> I have no idea how we're guaranteeing that .data is visible to all
> cpus without barrier from reader side.  Maybe we don't allow something
> like the following?
> 
>   module init				built-in code
> 
>   static int mod_static_var = X;	if (builtin_ptr)
>   builtin_ptr = &mod_static_var;		WARN_ON(*builtin_ptr != X);
> 
> Rusty, can you please enlighten me?
> 
> > > For normal allocations, I don't have a strong opinion.  I'd prefer to
> > > think of memory coming out of the allocator to have memory ordering
> > > already taken care of but it is a lot less murky than with percpu
> > > areas.
> > 
> > Again, it won't help for the allocator to strongly order the
> > initialization to zero if there are additional initializations of some
> > fields to non-zero values.  And again, it should be a lot easier to
> > require the smp_store_release() or whatever uniformly than only in cases
> > where additional initialization occurred.
> 
> This one is less murky as we can say that the cpu which allocated owns
> the zeroing; however, it still deviates from requiring the one which
> makes changes to take care of barriering for those changes, which is
> what makes me feel a bit uneasy.  IOW, it's the allocator which
> cleared the memory, why should its users worry about in-flight
> operations from it?  That said, this poses a lot less issues compared
> to percpu ones as passing normal pointers to other cpus w/o going
> through proper set of barriers is a special thing to do anyway.

I much prefer the model where the thing that -published- the pointer is
responsible for memory ordering.  After all, if a task allocates some
zeroed memory, uses it locally, then frees it, there is no ordering
to worry about in the first place.  The memory allocator doing the
initialization cannot tell how the memory is to be used, after all.

							Thanx, Paul

