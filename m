Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaGORp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:45:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44662 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaGORp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:45:26 -0400
Date: Tue, 15 Jul 2014 10:45:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140715174519.GH8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87lhs35p0v.fsf@rustcorp.com.au>
 <20140714113911.GM16041@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1407141014390.25436@gentwo.org>
 <20140715101150.GA8690@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1407150903570.10593@gentwo.org>
 <20140715143225.GC8690@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1407150952580.10593@gentwo.org>
 <CA+55aFzP_GZaTYcUg7CN+Sz5ZeWX2CgxX3hig2gyBxhCCayamA@mail.gmail.com>
 <alpine.DEB.2.11.1407151054390.11327@gentwo.org>
 <CA+55aFxU166V5-vH4vmK9OBdTZKyede=71RjjbOVSN9Qh+Se+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxU166V5-vH4vmK9OBdTZKyede=71RjjbOVSN9Qh+Se+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071517-6688-0000-0000-0000034F713B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:32:13AM -0700, Linus Torvalds wrote:
> On Jul 15, 2014 9:12 AM, "Christoph Lameter" <cl@gentwo.org> wrote:
> >
> > I mentioned that there is a barrier because the process of handing over
> > the offset to the other includes synchronization. In the slab case this is
> > a semaphore that is use to protect the structure and the list of
> > kmem_cache structures. The control struct containing the offset must be
> > entered somehow into something that tracks it for the future and thus
> > there is synchronization by the subsytem.
> 
> Maybe. It's not at all obvious, though. That control structure may be a
> lockless percpu thing, after all. We have front end caches to the
> allocators etc..
> 
> So yes, if there is a lock+unlock, that can be a memory barrier - but even
> that is not necessarily true on all architectures.
> 
> Is there even always one, though? And what about the other CPU? Does it
> have any paired barrier?
> 
> > And now we still see the old data. The cacheline changes of the initial
> > processor are ignored?
> 
> They aren't "ignored". But without the proper barriers, the zeroing writes
> may still be buffered on the other CPU, and may not even have had a cache
> line allocated to them!
> 
> That's the kind of thing that makes a barrier possibly required.
> 
> But yes, the barrier may be implied by other synchronization if that
> exists. A lock doesn't necessarily help, though. A write before a lock can
> migrate down into the locked region, and a write after the lock may
> similarly migrate into the locked region, and then two such writes may be
> seen out of order on another CPU that doesn't take the lock itself to
> serialize.
> 
> See? It's those kinds of things that can cause really subtle memory
> ordering problems. We generally never see them on x86, since writes are
> always ordered against other writes, and reads are allays ordered wrt other
> reads (but not reads against writes) and all locks are full memory barriers.
> 
> But on other architectures even a lock+unlock may not be a barrier, since
> things moving into the locked region is fine (the lock means that things
> had better not move *out* of s locked region).
> 
> So depending on serialization may not always be all that obvious. Even if
> it does happen to all work on x86.
> 
> And don't get me wrong. I despise weak memory models. I think they are a
> mistake. I absolutely detest the alpha model, and I think PowerPC and ARM
> are wrong too. It's just that we have to try to care about their broken
> crap )^:

Well at least all the required barriers are free on TSO systems like
x86 and mainframe, and the read-side barriers are free evne on ARM and
PowerPC (not so much on DEC Alpha, but you can't have everything).  OK,
OK, there is a volatile cast and/or a barrier() directive that might
constrain the compiler a bit in some cases.

So this might well be crap, but at least it is (nearly) zero-cost crap
from the viewpoint of TSO machines like x86.  ;-)

							Thanx, Paul

