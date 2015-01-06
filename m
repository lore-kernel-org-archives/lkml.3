Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbbAFMPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:15:35 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63290 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbbAFMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:15:34 -0500
Date: Tue, 6 Jan 2015 04:18:06 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106121806.GC26845@kmo-pixel>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106115822.GU29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106115822.GU29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:58:22PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 06, 2015 at 03:07:30AM -0800, Kent Overstreet wrote:
> > http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix
> 
> Very terse changelogs there :/

erg, I've been slacking on changelogs lately. that closure_sync() fix definitely
merits explanation.

> Also, I'm not sure I agree with that whole closure_wait_event*() stuff,
> the closure interface as it exist before that makes sense, but now
> you're just mixing up things.
> 
> Why would you want to retrofit a lot of the wait_event*() stuff on top
> of this?

Actually it's not retrofitted, closure_wait_event() dates to the very original
closure code, it was dropped for awhile because bcache happened not to be using
it anymore and I just dug it out of the git history.

Think of it this way - closures wait on things: sometimes you want to wait
asynchronously, sometimes synchronously, but you want the same primitives for
both - something has to bridge the gap between the async and sync stuff.

For example - here's the code in the bcache-dev branch that handles reading the
journal from each device in the cache set in parallel:

http://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/journal.c?h=bcache-dev#n399

It's using closure_call() to kick off the read for each device, then
closure_sync() to wait on them all to finish.

So closure_sync() is completely necessary, and then once you've got that
closure_wait_event() is just a trivial macro.

Also, closures could be using wait_queue_head_t instead of closure waitlist,
mainly I didn't want to nearly double the size of closures to stuff in a
__wait_queue.

I'd argue that "closures the junk for writing weird pseudo continuation passing
style asynchronous C" are not really the important parts of closures, the
important part is the infrastructure for waiting on stuff and then doing
something when that stuff completes. closure_get(), closure_put() and waitlists
are the real primitives; both closure_sync() and all the fancy asynchronous
stuff are built on top of that.
