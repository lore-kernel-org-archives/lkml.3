Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaAWTcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:32:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63421 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaAWTcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:32:03 -0500
Date: Thu, 23 Jan 2014 11:31:59 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123193159.GU9037@kmo>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
 <20140123135539.GF889@kmo-pixel>
 <20140123154312.GX30183@twins.programming.kicks-ass.net>
 <20140123162254.GK3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123162254.GK3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:22:54PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> > pool->lock is also going to be fairly badly contended in the worst case,
> > and that can get real bad real fast... now that I think about it we
> > probably want to avoid the __alloc_global_tag() double call just because
> > of that, pool->lock is going to be quite a bit more contended than the
> > waitlist lock just because fo the amount of work done under it.
> 
> On top of the two previous; I think we can reduce pool->lock contention
> by not holding it while doing steal_tags().
> 
> By dropping pool->lock around steal_tags() we loose serialization over:
> 
>   pool->cpus_have_tags is an atomic bitmask, and
>   pool->cpu_last_stolem, that's a heuristic anyway, so sod it.
> 
> We further loose the guarantee relied upon by percpu_ida_free(), so have
> it also acquire the tags->lock, which should be a far less contended
> resource.
> 
> Now everything modifying percpu_ida_cpu state holds
> percpu_ida_cpu::lock, everything that modifies the actual percpu_ida
> freelists holds percpu_ida::lock, and percpu_ida_cpu::lock nests inside
> percpu_ida::lock.

I find myself wondering why I didn't originally do this - I'm a bit worried
there was some subtle race I've forgotten about with this approach - but
probably I just got tired of trying out and trying to reason about different
subtle optimizations is all :)

So yeah, assuming we can't find anything wrong with this approach - this should
be great.

> The only annoying thing is that we're still holding IRQs over
> steal_tags(), we should be able to make that a preempt_disable() without
> too much effort, or very much cheat and drop even that and rely on the
> percpu_ida_cpu::lock to serialize everything and just hope that we don't
> migrate too often.

I don't think that's an issue - it's pretty hard to come up with a scenario
where most/all of a large number of cpus are marked in the bit vector as having
tags, and _then_ none of them actually have tags (because as soon as one of them
does, we'll succeed and break out of the loop).

And then that would only be able to happen once, because we clear bits as we go.

And we need interrupts disabled while we're holding any of the spinlocks (as
freeing can certainly happen in atomic context), so the only alternative would
be to save/restore interrupts on every loop iteration, and that'll get _real_
expensive fast. (last I profiled it nested push/pop of the flags register was
_ridiculous_, sigh)
