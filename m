Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaKZQUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaKZQUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:20:10 -0500
Date: Wed, 26 Nov 2014 18:19:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126161947.GA10850@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
 <20141126151729.GB9612@redhat.com>
 <20141126152334.GA9648@redhat.com>
 <20141126163207.63810fcb@thinkpad-w530>
 <20141126154717.GB10568@redhat.com>
 <20141126170223.3b108b94@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126170223.3b108b94@thinkpad-w530>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:02:23PM +0100, David Hildenbrand wrote:
> > > This is what happened on our side (very recent kernel):
> > > 
> > > spin_lock(&lock)
> > > copy_to_user(...)
> > > spin_unlock(&lock)
> > 
> > That's a deadlock even without copy_to_user - it's
> > enough for the thread to be preempted and another one
> > to try taking the lock.
> > 
> > 
> > > 1. s390 locks/unlocks a spin lock with a compare and swap, using the _cpu id_
> > >    as "old value"
> > > 2. we slept during copy_to_user()
> > > 3. the thread got scheduled onto another cpu
> > > 4. spin_unlock failed as the _cpu id_ didn't match (another cpu that locked
> > >    the spinlock tried to unlocked it).
> > > 5. lock remained locked -> deadlock
> > > 
> > > Christian came up with the following explanation:
> > > Without preemption, spin_lock() will not touch the preempt counter.
> > > disable_pfault() will always touch it.
> > > 
> > > Therefore, with preemption disabled, copy_to_user() has no idea that it is
> > > running in atomic context - and will therefore try to sleep.
> > >
> > > So copy_to_user() will on s390:
> > > 1. run "as atomic" while spin_lock() with preemption enabled.
> > > 2. run "as not atomic" while spin_lock() with preemption disabled.
> > > 3.  run "as atomic" while pagefault_disabled() with preemption enabled or
> > > disabled.
> > > 4. run "as not atomic" when really not atomic.
> 
> should have been more clear at that point: 
> preemption enabled == kernel compiled with preemption support
> preemption disabled == kernel compiled without preemption support
> 
> > > 
> > > And exactly nr 2. is the thing that produced the deadlock in our scenario and
> > > the reason why I want a might_sleep() :)
> > 
> > IMHO it's not copy to user that causes the problem.
> > It's the misuse of spinlocks with preemption on.
> 
> As I said, preemption was off.

off -> disabled at compile time?

But the code is broken for people that do enable it.


> > 
> > So might_sleep would make you think copy_to_user is
> > the problem, and e.g. let you paper over it by
> > moving copy_to_user out.
> 
> Actually implementing different way of locking easily fixed the problem for us.
> The old might_sleep() checks would have given us the problem within a few
> seconds (I tested it).


Or enable CONFIG_PREMPT, with same effect (copy_to_user will report
an error).

Do you check  return code from copy to user?
If not then you have another bug ...

> > 
> > Enable lock prover and you will see what the real
> > issue is, which is you didn't disable preempt.
> > and if you did, copy_to_user would be okay.
> > 
> 
> Our kernel is compiled without preemption and we turned on all lock/atomic
> sleep debugging aid. No problem was detected.

But your code is still buggy with preemption on, isn't it?


> ----
> But the question is if we shouldn't rather provide a:
> 
>   copy_to_user_nosleep() implementation that can be called from
>     pagefault_disable() because it won't sleep.
> and a
>   copy_to_user_sleep() implementation that cannot be called from
>     pagefault_disable().
> 
> Another way to fix it would be a reworked pagefault_disable() function that
> somehow sets "a flag", so copy_to_user() knows that it is in fact called from a
> valid context, not just from "some atomic" context. So we could trigger
> might_sleep() when detecting a !pagefault_disable contex

I think all this is just directing people to paper over the
problem. You should normally disable preemption if you take
spinlocks.
Yes it might happen to work if preempt is compiled out
and you don't trigger scheduler, but Linux might
add scheduler calls at any point without notice,
code must be preempt safe.

Maybe add a debug option warning about spinlocks taken
with preempt on.

That would make sense I think.


-- 
MST
