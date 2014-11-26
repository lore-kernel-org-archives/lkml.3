Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaKZQuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbaKZQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:50:44 -0500
Date: Wed, 26 Nov 2014 18:50:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126165024.GA11202@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
 <20141126151729.GB9612@redhat.com>
 <20141126152334.GA9648@redhat.com>
 <20141126163207.63810fcb@thinkpad-w530>
 <20141126154717.GB10568@redhat.com>
 <20141126170223.3b108b94@thinkpad-w530>
 <20141126161947.GA10850@redhat.com>
 <5476002B.30900@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5476002B.30900@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:30:35PM +0100, Christian Borntraeger wrote:
> Am 26.11.2014 um 17:19 schrieb Michael S. Tsirkin:
> > On Wed, Nov 26, 2014 at 05:02:23PM +0100, David Hildenbrand wrote:
> >>>> This is what happened on our side (very recent kernel):
> >>>>
> >>>> spin_lock(&lock)
> >>>> copy_to_user(...)
> >>>> spin_unlock(&lock)
> >>>
> >>> That's a deadlock even without copy_to_user - it's
> >>> enough for the thread to be preempted and another one
> >>> to try taking the lock.
> >>>
> >>>
> >>>> 1. s390 locks/unlocks a spin lock with a compare and swap, using the _cpu id_
> >>>>    as "old value"
> >>>> 2. we slept during copy_to_user()
> >>>> 3. the thread got scheduled onto another cpu
> >>>> 4. spin_unlock failed as the _cpu id_ didn't match (another cpu that locked
> >>>>    the spinlock tried to unlocked it).
> >>>> 5. lock remained locked -> deadlock
> >>>>
> >>>> Christian came up with the following explanation:
> >>>> Without preemption, spin_lock() will not touch the preempt counter.
> >>>> disable_pfault() will always touch it.
> >>>>
> >>>> Therefore, with preemption disabled, copy_to_user() has no idea that it is
> >>>> running in atomic context - and will therefore try to sleep.
> >>>>
> >>>> So copy_to_user() will on s390:
> >>>> 1. run "as atomic" while spin_lock() with preemption enabled.
> >>>> 2. run "as not atomic" while spin_lock() with preemption disabled.
> >>>> 3.  run "as atomic" while pagefault_disabled() with preemption enabled or
> >>>> disabled.
> >>>> 4. run "as not atomic" when really not atomic.
> >>
> >> should have been more clear at that point: 
> >> preemption enabled == kernel compiled with preemption support
> >> preemption disabled == kernel compiled without preemption support
> >>
> >>>>
> >>>> And exactly nr 2. is the thing that produced the deadlock in our scenario and
> >>>> the reason why I want a might_sleep() :)
> >>>
> >>> IMHO it's not copy to user that causes the problem.
> >>> It's the misuse of spinlocks with preemption on.
> >>
> >> As I said, preemption was off.
> > 
> > off -> disabled at compile time?
> > 
> > But the code is broken for people that do enable it.
> [...]
> > You should normally disable preemption if you take
> > spinlocks.
> 
> Your are telling that any sequence of
> spin_lock
> ...
> spin_unlock
> 
> is broken with CONFIG_PREEMPT?
> Michael, that is bullshit. spin_lock will take care of CONFIG_PREEMPT just fine. 
> 
> Only sequences like
> spin_lock
> ...
> schedule
> ...
> spin_unlock
> are broken.
> 
> But as I said. That is not the problem that we are discussing here.
> 
> Christian

I'm saying spin_lock without _irqsave is often a bug.


I am also saying this code in mm/fault.c:
__do_page_fault
...
        /*
         * If we're in an interrupt, have no user context or are running
         * in an atomic region then we must not take the fault:
         */
        if (unlikely(in_atomic() || !mm)) {
                bad_area_nosemaphore(regs, error_code, address);
                return;
        }

means that a fault won't cause sleep if called in atomic context.

And a bunch of code relies on this.

This is why might_fault does:

         * it would be nicer only to annotate paths which are not under
         * pagefault_disable, however that requires a larger audit and
         * providing helpers like get_user_atomic.
         */
        if (in_atomic())
                return;

        __might_sleep(__FILE__, __LINE__, 0);


If you see this violated, let's figure out why.

-- 
MST
