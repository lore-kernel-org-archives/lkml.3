Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbbAFMQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:16:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbbAFMQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:16:23 -0500
Date: Tue, 6 Jan 2015 13:16:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106121603.GV29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106115645.GA26845@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106115645.GA26845@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:56:45AM -0800, Kent Overstreet wrote:
> I do want to make the point that it's not really the callers that are broken;
> especially those that are using prepare_to_wait() via wait_event(). Using
> wait_event() is exactly what people _should_ be doing, instead of open coding
> this stuff and/or coming up with hacks to work around the fact that
> prepare_to_wait() is implemented via messing with the task state.

Yes and no.

So I agree that people should be using wait_event(), but I was also very
much hoping people would not be nesting sleep primitives like this.

Now that we have the debug check its at least obvious when you do.

But yes I'm somewhat saddened by the amount of stuff that has come up
because of this.

> Anyways, my point is either wait_event() should be fixed to not muck with the
> task state, or since that's not really practical we should at least provide a
> standard drop in replacement that doesn't.

I had explicitly not done this because I had hoped this would be rare
and feel/felt we should not encourage this pattern.

> And the drop in replacement more or less exists, closure_wait_event() has the
> same semantics as wait_event, similarly with the lower level primitives I just
> listed the conversions for.

See my other email, I don't really agree with the whole
closure_wait_event() thing, I think it dilutes what closures are. You've
just used what you know to cobble together something that has the right
semantics, but its not at all related to the concept of what closures
were.

I'm also not sure we want to change the existing wait_event() stuff to
allow nested sleeps per default, there is some additional overhead
involved -- although it could turn out to not be an issue, we'd have to
look at that.

But IF we want to create a drop in replacement it should be in the wait
code, it shouldn't be too hard once we've decided we do indeed want to
go do this.
