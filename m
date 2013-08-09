Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab3HISVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:21:10 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:40159 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab3HISVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130809130457.GA27493@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
	<CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
	<20130808191749.GA12062@redhat.com>
	<CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
	<20130809130457.GA27493@redhat.com>
Date: Fri, 9 Aug 2013 11:21:07 -0700
X-Google-Sender-Auth: NS5iedwLpnGVldfjXFAKyQBAf8g
Message-ID: <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com>
Subject: Re: Patch for lost wakeups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 6:04 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
>>    The case of signals is special, in that the "wakeup criteria" is
>> inside the scheduler itself, but conceptually the rule is the same.
>
> yes, and because the waiter lacks mb().

Hmm. Ok. So say we have a sleeper that does
__set_task_state(TASK_INTERRUPTIBLE) (so without the memory barrier
semantics of set_task_state()), so we have one thread doing

   prev->state = TASK_INTERRUPTIBLE
   raw_spin_lock_irq(&rq->lock);
   if (signal_pending_state(prev->state, prev))
     prev->state = TASK_RUNNING;

and since it's a spin-lock, things can in theory percolate *into* the
critical region, but not out of it. So as far as other CPU's are
concerned, that thread might actually do the "test pending signals"
before it even sets the state to TASK_INTERRUPTIBLE. And yes, that can
race against new signals coming in.

So it does look like a race. I get the feeling that we should put a
smp_wmb() into the top of __schedule(), before the spinlock - that's
basically free on any sane architecture (yeah, yeah, a bad memory
ordering implementaiton can make even smp_wmb() expensive, but
whatever - I can't find it in myself to care about badly implemented
microarchitectures when the common case gets it right).

That said, at least MIPS does not make spin-locks be that kind of
"semi-transparent" locks, so this race cannot hit MIPS. And I'm pretty
sure loongson has the same memory ordering as mips (ie "sync" will do
a memory barrier).

So this might be a real race for architectures that actually do
aggressive memory re-ordering _and_ actually implements spinlocks with
the aggressive acquire semantics. I think ia64 does. The ppc memory
ordering is confused enough that *maybe* it does, but I doubt it. On
most other architectures I think spinlocks end up being full memory
barriers.

I guess that instead of a "smp_wmb()", we could do another
"smp_mb__before_spinlock()" thing, like we already allow for other
architectures to do a weaker form of mb in case the spinlock is
already a full mb. That would allow avoiding extra synchronization. Do
a

   #ifndef smp_mb__before_spinlock
     #define smp_mb__before_spinlock() smp_wmb()
   #endif

in <linux/spinlock.h> to not force everybody to implement it. Because
a wmb+acquire should be close enough to a full mb that nobody cares
(ok, so reads could move into the critical region from outside, but by
the time anybody has called "schedule()", I can't see it mattering, so
"close enough").

                  Linus
