Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbbAMPXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:23:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAMPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:23:20 -0500
Date: Tue, 13 Jan 2015 16:23:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150113152311.GK25256@twins.programming.kicks-ass.net>
References: <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106115645.GA26845@kmo-pixel>
 <20150106121603.GV29390@twins.programming.kicks-ass.net>
 <20150106124313.GD26845@kmo-pixel>
 <20150106130317.GX29390@twins.programming.kicks-ass.net>
 <20150106132844.GF26845@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106132844.GF26845@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:28:44AM -0800, Kent Overstreet wrote:
> On Tue, Jan 06, 2015 at 02:03:17PM +0100, Peter Zijlstra wrote:
> > Yeah I got that aspect. I'm still trying to get my head around how the
> > wait_event bit would be a natural match though ;-)
> > 
> > Let me stew a bit on that.
> 
> Also, I think it was kind of a surprise to me back in the day how structurally
> similar the wait_event() implementation (circa several years ago, not the
> monstrosity it is now :) and closure_wait_event() turned out - I wasn't aiming
> for that, but that got me thinking there must be something more fundamental
> going on here.

That 'monstrosity' helped reduce the line count significantly, but more
importantly it fixed a fair few inconsistencies across the various
wait_event*() functions. But yes, its a bit of a handful.

Now back to why I don't really like closures for this purpose; the
wait_event*() stuff is really only a wait list, closures are a wait list
+ bits.

So while it makes sense to me to implement closures in terms of
wait_event, the reverse does not make sense to me.

Now you gave a good reason to not use the existing wait list stuff, its
somewhat bloated, and that's fair.

> > That said, the RT people want a simple waitqueue, one that has
> > deterministic behaviour. This is only possibly by removing some of the
> > more obscure waitqueue features and thus also results in a slimmer
> > structure.
> 
> Oh really? That's good to hear.

http://thread.gmane.org/gmane.linux.kernel/1808752 is the last posting
iirc.

> I do like wake_all() being cheaper with the singly linked list, wakups are much
> more common than waiting on things (e.g. the aio code delivering events to the
> ringbuffer, anything that's freeing up resources).
> 
> Been kind of wondering how sane it would be to implement
> finish_wait()/wake_one() with a singly linked list, and maybe preserve some of
> the locklessness. You do fancy lockless stuff too, don't you? Maybe you have
> some ideas :)

Ha! I think I implemented the required nightmare, have a look at:

  fb0527bd5ea9 ("locking/mutexes: Introduce cancelable MCS lock for adaptive spinning")

MCS locks are basically a single linked lockless FIFO queue, however for
the optimistic spinning stuff we needed to be able to abort the lock
op/unlink ourselves.

I'll be the first to admit that that code is somewhat mind bending. I
had to draw quite a few doodles when writing that code :-)


