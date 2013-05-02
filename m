Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3EBMXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:23:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41075
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab3EBMXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:23:23 -0400
Date: Thu, 2 May 2013 14:23:02 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
Message-ID: <20130502122302.GK7800@kernel.dk>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
 <15077.1367490569@warthog.procyon.org.uk>
 <CAKMK7uGKnK1VL5wNiFJXeBOHypWup8-7hZDLSqvEsbwvxVW5tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGKnK1VL5wNiFJXeBOHypWup8-7hZDLSqvEsbwvxVW5tA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02 2013, Daniel Vetter wrote:
> On Thu, May 2, 2013 at 12:29 PM, David Howells <dhowells@redhat.com> wrote:
> >> Fix this by returning at least 1 if the condition becomes true. This
> >> semantic is in line with what wait_for_condition_timeout() does; see
> >> commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> >> failure under heavy load".
> >
> > But now you can't distinguish the timer expiring first, if the thread doing
> > the waiting gets delayed sufficiently long for the event to happen.
> 
> That can already happen, e.g.
> 
> 1. wakeup happens and condition is true.
> 2. we compute remaining jiffies > 0
> -> preempt
> 3. now wait_for_event_timeout returns.
> 
> Only difference is that the delay/preempt happens in between 1. and
> 2., and then suddenly the wake up didn't happen in time (with the
> current return code semantics).
> 
> So imo the current behaviour is simply a bug and will miss timely
> wakeups in some cases.
> 
> The other way round, namely wait_for_event_timeout taking longer than
> the timeout is expected (and part of the interface for every timeout
> function). So all current callers already need to be able to cope with
> random preemption/delays pushing the total time before the call to
> wait_for_event and checking the return value over the timeout, even
> when condition was signalled in time.
> 
> If there's any case which relies on accurate timeout detection that
> simply won't work with wait_for_event (they need an nmi or a hw
> timestamp counter or something similar).

I seriously doubt that anyone is depending on any sort of accuracy on
the return. 1 jiffy is not going to make or break anything - in fact,
jiffies could be incremented nsecs after the initial call. So a
granularity of at least 1 is going to be expected in any case.

The important bit here is that the API should behave as expected. And
the most logical way to code that is to check the return value. I can
easily see people forgetting to re-check the condition, hence you get a
bug. The fact that you and the original reporter already had accidents
with this is a clear sign that the logical way to use the API is not the
correct one.

IMHO, the change definitely makes sense.

-- 
Jens Axboe

