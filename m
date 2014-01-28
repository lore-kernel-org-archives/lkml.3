Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaA1VIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:08:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36761 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbaA1VII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:08:08 -0500
Date: Tue, 28 Jan 2014 22:07:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390936396-3962-6-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:13:16AM -0800, Jason Low wrote:
> Before a thread attempts mutex spin on owner, it is first added to a queue
> using an MCS lock so that only 1 thread spins on owner at a time. However, when
> the spinner is queued, it is unable to check if it needs to reschedule and
> will remain on the queue. This could cause the spinner to spin longer
> than its allocated time. 

what allocated time?

> However, once it is the spinner's turn to spin on
> owner, it would immediately go to slowpath if it need_resched() and gets no spin
> time. In these situations, not only does the spinner take up more time for a
> chance to spin for the mutex, it also ends up not getting to spin once it
> gets its turn.
> 
> One solution would be to exit the MCS queue and go to mutex slowpath if
> need_resched(). However, that may require a lot of overhead. For instance, if a
> thread at the end of the queue need_resched(), in order to remove it from the
> queue, we would have to unqueue and requeue all other spinners in front of it.

If you can do that, you can also walk the list and find prev and cmpxchg
the entry out. But I don't think you can do either, as we simply don't
have a head pointer.

> This RFC patch tries to address the issue in another context by avoiding
> situations where spinners immediately get sent to the slowpath on
> need_resched() upon getting to spin. 

> We will first check for need_resched()
> right after acquiring the MCS lock. If need_resched() is true, then
> need_resched() triggered while the thread is waiting in the MCS queue (since
> patch 1 makes the spinner check for need_resched() before entering the queue).

> In this case, we will allow the thread to have at least 1 try to do
> mutex_spin_on_owner() regardless of need_resched(). 

No! We should absolutely not ever willfully ignore need_resched(). Esp.
not for unbounded spins.

> This patch also removes
> the need_resched() in the outer loop in case we require a few extra spins to
> observe lock->count == 1, and patch 4 ensures we won't be spinning with
> lock owner preempted.
> 
> And if the need_resched() check after acquiring the MCS lock is false, then
> we won't give the spinner any extra spinning.

But urgh, nasty problem. Lemme ponder this a bit.
