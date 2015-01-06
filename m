Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbbAFMkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:40:43 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48669 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbAFMkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:40:42 -0500
Date: Tue, 6 Jan 2015 04:43:13 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106124313.GD26845@kmo-pixel>
References: <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106115645.GA26845@kmo-pixel>
 <20150106121603.GV29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106121603.GV29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:16:03PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 06, 2015 at 03:56:45AM -0800, Kent Overstreet wrote:
> > I do want to make the point that it's not really the callers that are broken;
> > especially those that are using prepare_to_wait() via wait_event(). Using
> > wait_event() is exactly what people _should_ be doing, instead of open coding
> > this stuff and/or coming up with hacks to work around the fact that
> > prepare_to_wait() is implemented via messing with the task state.
> 
> Yes and no.
> 
> So I agree that people should be using wait_event(), but I was also very
> much hoping people would not be nesting sleep primitives like this.
> 
> Now that we have the debug check its at least obvious when you do.
> 
> But yes I'm somewhat saddened by the amount of stuff that has come up
> because of this.

The cond argument to wait_event() _really is_ an arbitrary expression/chunk of
code; it's inescapable that you're going to be doing stuff that sleeps, and even
much more complicated stuff in there.

I have code out of tree that's sending network RPCs under wait_event_timeout()
(or did we switch that to closures? I'd have to check...) - and that actually
wasn't the first way I wrote it, but when I rewrote it that way the end result
was _much_ improved and easier to understand.

> > Anyways, my point is either wait_event() should be fixed to not muck with the
> > task state, or since that's not really practical we should at least provide a
> > standard drop in replacement that doesn't.
> 
> I had explicitly not done this because I had hoped this would be rare
> and feel/felt we should not encourage this pattern.

But it should be encouraged! If the expression you're waiting on sleeps, you
shouldn't have to contort your code to work around that - I mean, look at the
history of the AIO code, what was tried in the past and what Ben came up most
recently for this bug.

I can see where you're coming from, but this is something I've learned from
painful experience.

> > And the drop in replacement more or less exists, closure_wait_event() has the
> > same semantics as wait_event, similarly with the lower level primitives I just
> > listed the conversions for.
> 
> See my other email, I don't really agree with the whole
> closure_wait_event() thing, I think it dilutes what closures are. You've
> just used what you know to cobble together something that has the right
> semantics, but its not at all related to the concept of what closures
> were.

You know, if anyone's the authority on what closures are it's me :) I've done a
lot of programming with them, and experimented a lot with them - I've added and
taken back out lots of functionality, and this is something I'll confidently say
naturally goes with closures.

> I'm also not sure we want to change the existing wait_event() stuff to
> allow nested sleeps per default, there is some additional overhead
> involved -- although it could turn out to not be an issue, we'd have to
> look at that.

Yeah I don't think there's anything wrong with having two parallel
implementations, with a slightly faster one that doesn't allow sleeps.

> But IF we want to create a drop in replacement it should be in the wait
> code, it shouldn't be too hard once we've decided we do indeed want to
> go do this.

I don't care one way or the other there.

It might make the most sense to cook up something new, stealing some of the
closure code but using standard the wait_queue_head_t - having a single standard
waitlist type is definitely a good thing, and unfortunately I don't think it'd
be a good idea to convert closures to wait_queue_head_t mainly because of the
memory usage.

I will note that one thing that has been immensely useful with closures is the
ability to pass a closure around - think of it as a "wait object" - to some code
that may end up waiting on something, but you don't want to itself sleep, and
then the caller can closure_sync() or continue_at() or whatever it wants (or use
the same closure for waiting on multiple things, e.g. where we wait on writing
the two new btree nodes after a split).

Think of it a souped up completion.
