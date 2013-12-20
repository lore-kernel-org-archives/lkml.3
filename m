Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3LTDNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:13:12 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:48761 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LTDNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:13:10 -0500
MIME-Version: 1.0
In-Reply-To: <1387506141.8363.47.camel@buesod1.americas.hpqcorp.net>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
	<CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	<1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
	<1387506141.8363.47.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 19 Dec 2013 19:13:09 -0800
X-Google-Sender-Auth: v8vD-AjXv3AcPz4KhaRbceDDPZM
Message-ID: <CA+55aFyrZmG6rNpY22OK3UQi18e=4UQyh8a3tpxY+QVCbNxXkw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 6:22 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Ok so when I replied I was thinking about the plist really and not the
> hb->lock ticket counter. Yeah, what you propose does make sense for
> waiters. However in wake paths we have to decrement  the counter nwake
> times (per each call to __unqueue_futex()), and if we rely on the
> ticket, then we do it only once, in the unlock, so the counter doesn't
> reflect the actual waitqueue size. Or am I missing something with ticket
> spinlocks (I'm not very familiar with that code)?

So that's why I suggested checking the ticket lock _and_ the state of
the node list.

The ticket lock state gives you the racy window before the entry has
actually been added to the node list, and then after the lock has been
released, the fact that the list isn't empty gives you the rest.

I think we might have to order the two reads with an smp_rmb - making
sure that we check the lock state first - but I think it should be
otherwise pretty solid.

And maybe there is some reason it doesn't work, but I'd really like to
understand it (and I'd like to avoid the extra atomics for the waiters
count if it at all can be avoided)

> Btw, I tried using spin_is_contended + plist_head_empty and we run into
> a whole bunch of nasty issues which I have yet to sit down and look
> into.

Yeah, I said "spin_contended()" myself initially, but it needs to be
"spin_is_locked()". It's hopefully unlikely to ever actually be
contended (which in ticket lock terms is "head is _more_ than one away
from the tail").

            Linus
