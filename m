Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbaCTRSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:18:39 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:55561 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaCTRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:18:37 -0400
Message-ID: <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 10:18:29 -0700
In-Reply-To: <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 09:41 -0700, Linus Torvalds wrote:
> On Wed, Mar 19, 2014 at 10:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > This problem suggests that we missed a wakeup for a task that was adding
> > itself to the queue in a wait path. And the only place that can happen
> > is with the hb spinlock check for any pending waiters.
> 
> Ok, so thinking about hb_waiters_pending():
> 
>  - spin_is_locked() test
>  - read barrier
>  - plist_head_empty() test
> 
> seems to be broken after all.
> 
> The race is against futex_wait() that does
> 
>  - futex_wait_setup():
>    - queue_lock()
>    - get_futex_value_locked()
>  - futex_wait_queue_me()
>    - queue_me()
>      - plist_add()
> 
> right?

Yep.

> 
> It strikes me that the "spin_is_locked()" test has no barriers wrt the
> writing of the new futex value on the wake path. And the read barrier
> obviously does nothing wrt the write either. Or am I missing
> something? So the write that actually released the futex might be
> almost arbitrarily delayed on the waking side. So the waiting side may
> not see the new value, even though the waker assumes it does due to
> the ordering of it doing the write first.

Aha, that would certainly violate the ordering guarantees. I feared
_something_ like that when we originally discussed your suggestion as
opposed to the atomics one, but didn't have any case for it either.

> So maybe we need a memory barrier in hb_waiters_pending() just to make
> sure that the new value is written.
> 
> But at that point, I suspect that Davidlohrs original patch that just
> had explicit waiting counts is just as well. The whole point with the
> head empty test was to emulate that "do we have waiters" without
> having to actually add the atomics, but a memory barrier is really no
> worse.
> 
> The attached is a TOTALLY UNTESTED interdiff that adds back Davidlohrs
> atomic count. It may be terminally broken, I literally didn't test it
> at all.

Comparing with the patch I sent earlier this morning, looks equivalent,
and fwiw, passes my initial qemu bootup, which is the first way of
detecting anything stupid going on.

So, Srikar, please try this patch out, as opposed to mine, you don't
have to first revert the commit in question.

