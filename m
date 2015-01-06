Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbbAFLyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:54:14 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52502 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbbAFLyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:54:13 -0500
Date: Tue, 6 Jan 2015 03:56:45 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106115645.GA26845@kmo-pixel>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106114215.GS29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:42:15PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 06, 2015 at 03:07:30AM -0800, Kent Overstreet wrote:
> > > No, the root cause is nesting sleep primitives, this is not fixable in
> > > the one place, both prepare_to_wait and mutex_lock are using
> > > task_struct::state, they have to, no way around it.
> > 
> > No, it's completely possible to construct a prepare_to_wait() that doesn't
> > require messing with the task state. Had it for years.
> > 
> > http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix
> 
> Your closures are cute but not the same. And sure you can do a wait
> queue like interface -- my wait_woken thing is an example -- that
> doesn't require task state.
> 
> The point remains that you then have to fix every instance to conform to
> the new interface.

Possibly I missed your point because I've been overly crotchety lately.

I do want to make the point that it's not really the callers that are broken;
especially those that are using prepare_to_wait() via wait_event(). Using
wait_event() is exactly what people _should_ be doing, instead of open coding
this stuff and/or coming up with hacks to work around the fact that
prepare_to_wait() is implemented via messing with the task state.

This is a sore point for me because I've seen other experienced, _skilled_
programmers screw this kind of code up too many times and I hate debugging lost
wakeups. I can write this kind of code in my sleep because I've spent too much
of time time implementing these kinds of primitives and I'm sure you can too,
but most people can't.

Anyways, my point is either wait_event() should be fixed to not muck with the
task state, or since that's not really practical we should at least provide a
standard drop in replacement that doesn't.

And the drop in replacement more or less exists, closure_wait_event() has the
same semantics as wait_event, similarly with the lower level primitives I just
listed the conversions for.

I don't even really care if it's closures, we could make something new that uses
the existing wait_queue_head_t but IMO it's gonna look a lot like closures with
an embedded refcount and closure_sync() instead of schedule().
