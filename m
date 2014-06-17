Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbaFQXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:25:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28420 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaFQXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:24:58 -0400
Message-Id: <201406172323.s5HNNveT018439@userz7022.oracle.com>
Date: Tue, 17 Jun 2014 19:23:44 -0400
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <waiman.long@hp.com>
Cc: raghavendra.kt@linux.vnet.ibm.com, mingo@kernel.org, riel@redhat.com,
        oleg@redhat.com, gleb@redhat.com,
        virtualization@lists.linux-foundation.org, tglx@linutronix.de,
        chegu_vinod@hp.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, paolo.bonzini@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, scott.norton@hp.com,
        torvalds@linux-foundation.org, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, xen-devel@lists.xenproject.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5HNXfgS014143


On Jun 17, 2014 6:25 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> On 06/17/2014 05:10 PM, Konrad Rzeszutek Wilk wrote: 
> > On Tue, Jun 17, 2014 at 05:07:29PM -0400, Konrad Rzeszutek Wilk wrote: 
> >> On Tue, Jun 17, 2014 at 04:51:57PM -0400, Waiman Long wrote: 
> >>> On 06/17/2014 04:36 PM, Konrad Rzeszutek Wilk wrote: 
> >>>> On Sun, Jun 15, 2014 at 02:47:00PM +0200, Peter Zijlstra wrote: 
> >>>>> Because the qspinlock needs to touch a second cacheline; add a pending 
> >>>>> bit and allow a single in-word spinner before we punt to the second 
> >>>>> cacheline. 
> >>>> Could you add this in the description please: 
> >>>> 
> >>>> And by second cacheline we mean the local 'node'. That is the: 
> >>>> mcs_nodes[0] and mcs_nodes[idx] 
> >>>> 
> >>>> Perhaps it might be better then to split this in the header file 
> >>>> as this is trying to not be a slowpath code - but rather - a 
> >>>> pre-slow-path-lets-try-if-we can do another cmpxchg in case 
> >>>> the unlocker has just unlocked itself. 
> >>>> 
> >>>> So something like: 
> >>>> 
> >>>> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h 
> >>>> index e8a7ae8..29cc9c7 100644 
> >>>> --- a/include/asm-generic/qspinlock.h 
> >>>> +++ b/include/asm-generic/qspinlock.h 
> >>>> @@ -75,11 +75,21 @@ extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val); 
> >>>>Â Â Â  */ 
> >>>>Â Â  static __always_inline void queue_spin_lock(struct qspinlock *lock) 
> >>>>Â Â  { 
> >>>> - u32 val; 
> >>>> + u32 val, new; 
> >>>> 
> >>>>Â Â  val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL); 
> >>>>Â Â  if (likely(val == 0)) 
> >>>>Â Â  return; 
> >>>> + 
> >>>> + /* One more attempt - but if we fail mark it as pending. */ 
> >>>> + if (val == _Q_LOCKED_VAL) { 
> >>>> + new = Q_LOCKED_VAL |_Q_PENDING_VAL; 
> >>>> + 
> >>>> + old = atomic_cmpxchg(&lock->val, val, new); 
> >>>> + if (old == _Q_LOCKED_VAL) /* YEEY! */ 
> >>>> + return; 
> >>> No, it can leave like that. The unlock path will not clear the pending bit. 
> >> Err, you are right. It needs to go back in the slowpath. 
> > What I should have wrote is: 
> > 
> > if (old == 0) /* YEEY */ 
> >Â Â Â  return; 
>
> Unfortunately, that still doesn't work. If old is 0, it just meant the 
> cmpxchg failed. It still haven't got the lock. 
> > As that would the same thing as this patch does on the pending bit - that 
> > is if we can on the second compare and exchange set the pending bit (and the 
> > lock) and the lock has been released - we are good. 
>
> That is not true. When the lock is freed, the pending bit holder will 
> still have to clear the pending bit and set the lock bit as is done in 
> the slowpath. We cannot skip the step here. The problem of moving the 
> pending code here is that it includes a wait loop which we don't want to 
> put in the fastpath. 
> > 
> > And it is a quick path. 
> > 
> >>> We are trying to make the fastpath as simple as possible as it may be 
> >>> inlined. The complexity of the queue spinlock is in the slowpath. 
> >> Sure, but then it shouldn't be called slowpath anymore as it is not 
> >> slow. It is a combination of fast path (the potential chance of 
> >> grabbing the lock and setting the pending lock) and the real slow 
> >> path (the queuing). Perhaps it should be called 'queue_spinlock_complex' ? 
> >> 
> > I forgot to mention - that was the crux of my comments - just change 
> > the slowpath to complex name at that point to better reflect what 
> > it does. 
>
> Actually in my v11 patch, I subdivided the slowpath into a slowpath for 
> the pending code and slowerpath for actual queuing. Perhaps, we could 
> use quickpath and slowpath instead. Anyway, it is a minor detail that we 
> can discuss after the core code get merged.
>
> -Longman

Why not do it the right way the first time around?

That aside - these optimization - seem to make the code harder to read. And they do remind me of the scheduler code in 2.6.x which was based on heuristics - and eventually ripped out.

So are these optimizations based on turning off certain hardware features? Say hardware prefetching?

What I am getting at - can the hardware do this at some point (or perhaps already does on IvyBridge-EX?) - that is prefetch the per-cpu areas so they are always hot? And rendering this optimization not needed?

Thanks!
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
