Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaA1Wvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:51:39 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25368 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaA1Wvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:51:38 -0500
Message-ID: <1390949495.2807.52.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 14:51:35 -0800
In-Reply-To: <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
	 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 22:07 +0100, Peter Zijlstra wrote:
> On Tue, Jan 28, 2014 at 11:13:16AM -0800, Jason Low wrote:
> > Before a thread attempts mutex spin on owner, it is first added to a queue
> > using an MCS lock so that only 1 thread spins on owner at a time. However, when
> > the spinner is queued, it is unable to check if it needs to reschedule and
> > will remain on the queue. This could cause the spinner to spin longer
> > than its allocated time. 
> 
> what allocated time?

Hi Peter,

By "spin longer than its allocated time", I meant to say that the thread
can continue spinning/waiting in the MCS queue after need_resched() has
been set.

> > However, once it is the spinner's turn to spin on
> > owner, it would immediately go to slowpath if it need_resched() and gets no spin
> > time. In these situations, not only does the spinner take up more time for a
> > chance to spin for the mutex, it also ends up not getting to spin once it
> > gets its turn.
> > 
> > One solution would be to exit the MCS queue and go to mutex slowpath if
> > need_resched(). However, that may require a lot of overhead. For instance, if a
> > thread at the end of the queue need_resched(), in order to remove it from the
> > queue, we would have to unqueue and requeue all other spinners in front of it.
> 
> If you can do that, you can also walk the list and find prev and cmpxchg
> the entry out. But I don't think you can do either, as we simply don't
> have a head pointer.
> 
> > This RFC patch tries to address the issue in another context by avoiding
> > situations where spinners immediately get sent to the slowpath on
> > need_resched() upon getting to spin. 
> 
> > We will first check for need_resched()
> > right after acquiring the MCS lock. If need_resched() is true, then
> > need_resched() triggered while the thread is waiting in the MCS queue (since
> > patch 1 makes the spinner check for need_resched() before entering the queue).
> 
> > In this case, we will allow the thread to have at least 1 try to do
> > mutex_spin_on_owner() regardless of need_resched(). 
> 
> No! We should absolutely not ever willfully ignore need_resched(). Esp.
> not for unbounded spins.

Ok. This was sort of a proof of concept patch to illustrate the type of
performance gains we can get by addressing this issue.

> > This patch also removes
> > the need_resched() in the outer loop in case we require a few extra spins to
> > observe lock->count == 1, and patch 4 ensures we won't be spinning with
> > lock owner preempted.
> > 
> > And if the need_resched() check after acquiring the MCS lock is false, then
> > we won't give the spinner any extra spinning.
> 
> But urgh, nasty problem. Lemme ponder this a bit.

Thanks,
Jason


