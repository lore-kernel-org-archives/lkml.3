Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaLNUad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:30:33 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43582 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaLNUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:30:25 -0500
Date: Sun, 14 Dec 2014 21:30:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Fix lost reschedule in __cond_resched()
Message-ID: <20141214203011.GC12622@lerouge>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213073634.GD32572@gmail.com>
 <20141214180409.GB12622@lerouge>
 <CA+55aFzOHwkMSEMN7v6THmx1U3YPPTy9B=zeLx96Rt2_Er=yBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzOHwkMSEMN7v6THmx1U3YPPTy9B=zeLx96Rt2_Er=yBA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:50:20AM -0800, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 10:04 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> >
> > Such as:
> 
> So I like your patch, but quite frankly, can we go one step further?
> 
> Look at the callers of __schedule().
> 
> EVERY SINGLE ONE now has that loop around it that goes along the lines of
> 
>    do {
>       .. disable preemption somehow ..
>       __schedule();
>       ...enable preemption without scheduling ..
>    } while (need_resced());
> 
> except for one - the regular "schedule()" function.
> 
> Furthermore, look inside __schedule() itself: it has the same loop,
> except with a count of one.
> 
> So I would suggest going the extra mile, and
>  - remove the loop from __schedule() itself

That sounds like a good idea. Unless the loop inside __schedule()
is very frequent and sensitive enough to show visible overhead if we
force it to pass through the preemp_count_add/sub() and local_irq_*()
operations in the preempt_schedule_*() functions.

I suspect it's not, so I'm cooking that patch.

>  - add the same loop as everywhere else to "schedule()"

Right. I'm doing that too.

> IOW, just make this "you have to loop and disable preemption" thing be
> a rule that __schedule() can depend on.

Ok. It would be nice if we could have a common function that does the loop
and PREEMPT_ACTIVE increments. But the variable code is inside that loop
so that's only factorizable with a function pointer (no-go in that fast-path)
or a macro that would make things even worse and ugly.

So I think I'll just keep all those loops explicit.

Thanks.

>                  Linus
