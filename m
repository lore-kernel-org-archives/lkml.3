Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3LTGOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:14:06 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:24949 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3LTGOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:14:04 -0500
Message-ID: <1387520039.2704.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Date: Thu, 19 Dec 2013 22:13:59 -0800
In-Reply-To: <CA+55aFyrZmG6rNpY22OK3UQi18e=4UQyh8a3tpxY+QVCbNxXkw@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	 <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
	 <1387506141.8363.47.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFyrZmG6rNpY22OK3UQi18e=4UQyh8a3tpxY+QVCbNxXkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 19:13 -0800, Linus Torvalds wrote:
> On Thu, Dec 19, 2013 at 6:22 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > Ok so when I replied I was thinking about the plist really and not the
> > hb->lock ticket counter. Yeah, what you propose does make sense for
> > waiters. However in wake paths we have to decrement  the counter nwake
> > times (per each call to __unqueue_futex()), and if we rely on the
> > ticket, then we do it only once, in the unlock, so the counter doesn't
> > reflect the actual waitqueue size. Or am I missing something with ticket
> > spinlocks (I'm not very familiar with that code)?
> 
> So that's why I suggested checking the ticket lock _and_ the state of
> the node list.
> 
> The ticket lock state gives you the racy window before the entry has
> actually been added to the node list, and then after the lock has been
> released, the fact that the list isn't empty gives you the rest.

Yep, I'm starting to get around the idea now.

> I think we might have to order the two reads with an smp_rmb - making
> sure that we check the lock state first - but I think it should be
> otherwise pretty solid.

Yes, I don't see any guarantees otherwise.

> 
> And maybe there is some reason it doesn't work, but I'd really like to
> understand it (and I'd like to avoid the extra atomics for the waiters
> count if it at all can be avoided)

Other than the lock_ptr assignment I don't see much difference with what
you suggest. Since no wake paths use lock_ptr until after plist_del, and
we've already taken the lock way before then, it doesn't play a role in
what we're discussing.

I've put you suggestion (now corrected with spin_is_locked) and works
just as fine as with atomics. It's surviving my laptop and benchmarks on
a large system. I will wait to see if there are any concerns other might
have before sending another version of this patchset.

Thanks,
Davidlohr

