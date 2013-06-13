Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab3FMDDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:03:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab3FMDDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:03:14 -0400
Date: Wed, 12 Jun 2013 20:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130612200311.7f9d938a.akpm@linux-foundation.org>
In-Reply-To: <20130613020536.GA10979@localhost>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 19:05:36 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> ...
>
> > Why can't we use ida_get_new_above()?
> > 
> >    If it is "speed" then how bad is the problem and what efforts have
> >    been made to address them within the idr code?  (A per-cpu magazine
> >    frontend to ida_get_new_above() might suit).
> > 
> >    If it is "functionality" then what efforts have been made to
> >    suitably modify the ida code?
> 
> Originally, it was because every time I opened idr.[ch] I was confronted
> with an enormous pile of little functions, with very little indication
> in the way of what they were all trying to do or which ones I might want
> to start with.
> 
> Having finally read enough of the code to maybe get a handle on what
> it's about - performance is a large part of it, but idr is also a more
> complicated api that does more than what I wanted.

They all sound like pretty crappy reasons ;) If the idr/ida interface
is nasty then it can be wrapped to provide the same interface as the
percpu tag allocator.

I could understand performance being an issue, but diligence demands
that we test that, or at least provide a convincing argument.

>
> ...
>
> > > +		remote = per_cpu_ptr(pool->tag_cpu, cpu);
> > > +
> > > +		if (remote == tags)
> > > +			continue;
> > > +
> > > +		clear_bit(cpu, pool->cpus_have_tags);
> > > +
> > > +		nr_free = xchg(&remote->nr_free, TAG_CPU_STEALING);
> > 
> > (looks to see what TAG_CPU_STEALING does)
> > 
> > OK, this looks pretty lame.  It adds a rare fallback to the central
> > allocator, which makes that path hard to test.  And it does this at
> > basically the same cost of plain old spin_lock().  I do think it would
> > be better to avoid the underministic code and use plain old
> > spin_lock().  I appreciate the lock ranking concern, but you're a
> > cleaver chap ;)
> 
> Yeah, the cmpxchg() stuff turned out trickier than I'd hoped - it's
> actually the barriers (guarding against a race with percpu_tag_free())
> that concern me more than that fallback.
> 
> I did torture test this code quite a bit and I'm not terribly eager to
> futz with it more, but I may try switching to spinlocks for the percpu
> freelists to see how it works out - I had the idea that I might be able
> to avoid some writes to shared cachelines if I can simplify that stuff,
> which would probably make it worth it.

The nice thing about a lock per cpu is that the stealing CPU can grab
it and then steal a bunch of tags without releasing the lock: less
lock-taking.  Maybe the current code does that amortisation as well;
my intent-reverse-engineering resources got depleted.

Also, with a lock-per-cpu the stolen-from CPU just spins, so the ugly
TAG_CPU_STEALING fallback-to-global-allocator thing goes away.

> > Also, I wonder if this was all done in the incorrect order.  Why make
> > alloc_local_tag() fail?  steal_tags() could have just noodled off and
> > tried to steal from the next CPU if alloc_local_tag() was in progress
> > on this CPU?
> 
> steal_tags() can't notice that alloc_local_tag() is in progress,

Yes it can - the stolen-from CPU sets a flag in its cpu-local object
while in its critical section.  The stealing CPU sees that and skips.

I think all this could be done with test_and_set_bit() and friends,
btw.  xchg() hurts my brain.

> alloc_local_tag() just uses cmpxchg to update nr_free - there's no
> sentinal value or anything.
> 
> OTOH, if alloc_local_tag() sees TAG_CPU_STEALING - the next thing that's
> going to happen is steal_tags() is going to set nr_free to 0, and the
> only way tags are going to end up back on our cpu's freelist is if we
> fail and do something else - we've got irqs disabled so
> percpu_tag_free() can't do it.
> 
> ...
>
> > What actions can a driver take if an irq-time tag allocation attempt
> > fails?  How can the driver author test those actions?
> 
> You mean if a GFP_NOWAIT allocation fails? It's the same as any other
> allocation, I suppose.
> 
> Did you have something else in mind that could be implemented? I don't
> want to add code for a reserve to this code - IMO, if a reserve is
> needed it should be done elsewhere (like how mempools work on top of
> existing allocators).

Dunno, really - I'm just wondering what the implications of an
allocation failure will be.  I suspect it's EIO?  Which in some
circumstances could be as serious as total system failure (loss of
data), so reliability/robustness is a pretty big deal.


Another thing: CPU hot-unplug.  If it's "don't care" then the
forthcoming changelog should thoroughly explain why, please.  Otherwise
it will need a notifier to spill back any reservation.

