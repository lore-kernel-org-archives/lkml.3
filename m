Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaKEISw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:18:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKEISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:18:48 -0500
Date: Wed, 5 Nov 2014 09:18:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@kernel.org, torvalds@linux-foundation.org, rjw@rjwysocki.net,
        hpa@zytor.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/wait: Reimplement wait_event_freezable()
Message-ID: <20141105081838.GN10501@worktop.programming.kicks-ass.net>
References: <tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org>
 <20141104201203.GA15071@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104201203.GA15071@amd>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:12:03PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Commit-ID:  36df04bc5273a046f53b5e359febc1225f85aa7b
> > Gitweb:     http://git.kernel.org/tip/36df04bc5273a046f53b5e359febc1225f85aa7b
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed, 29 Oct 2014 12:21:57 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 4 Nov 2014 07:17:45 +0100
> > 
> > sched/wait: Reimplement wait_event_freezable()
> > 
> > Provide better implementations of wait_event_freezable() APIs.
> > 
> > The problem is with freezer_do_not_count(), it hides the thread from
> > the freezer, even though this thread might not actually freeze/sleep
> > at all.
> 
> Can you elaborate?
> 
> The thread will be in freezer_do_not_count() area, but it is just
> waiting for event there, it should not do much damage.

There are wait_event()s for which the cond expands to quite a lot of
code. This code can still be running while the freezer reports success.
This can happen because we're hidden by the do_not_count logic.

Also, I initially overlooked that freezer_count() did a try_to_freeze().

> If this is bugfix, should it be cc-ed to stable?

Its not a bugfix per se, the issue above is rare and extremely hard to
hit, esp since the freezer tries multiple times before giving up. But
its a theoretical possibility.

> Did you test it with suspend/hibernation? Because I can't really see
> how it works.

It calls try_to_freeze() after each schedule(). But no, I've not
actually tried.

If we're stuck in the schedule, waiting for the event, freeze_task()
will wake us up and then we'll find freeing() true and call into
__refrigerator().

If we're not stuck in schedule() we're running and the freezer
can see us running and will wait for us to hit another freeze point.

> > +#define __wait_event_freezable(wq, condition)				\
> > +	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
> > +			    schedule(); try_to_freeze())
> > +

> _Three_ underscores. And two underscore version exists, too,
> fortunately it at least has different number of arguments.

Hehe, yeah, there was a discount on underscores that day. The double
underscore variants can be used in code along with the no underscores
variants. The tripple one is implementation goo.
