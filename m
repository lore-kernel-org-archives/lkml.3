Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaGaNoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:44:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57354 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaGaNoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:44:21 -0400
Date: Thu, 31 Jul 2014 15:44:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
Message-ID: <20140731134411.GA12050@gmail.com>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
 <20140731115759.GS19379@twins.programming.kicks-ass.net>
 <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
 <20140731131331.GT19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731131331.GT19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jul 31, 2014 at 04:37:29PM +0400, Ilya Dryomov wrote:
> 
> > This didn't make sense to me at first too, and I'll be happy to be
> > proven wrong, but we can reproduce this with rbd very reliably under
> > higher than usual load, and the revert makes it go away.  What we are
> > seeing in the rbd scenario is the following.
> 
> This is drivers/block/rbd.c ? I can find but a single mutex_lock() in
> there.
> 
> > Suppose foo needs mutexes A and B, bar needs mutex B.  foo acquires
> > A and then wants to acquire B, but B is held by bar.  foo spins
> > a little and ends up calling schedule_preempt_disabled() on line 484
> > above, but that call never returns, even though a hundred usecs later
> > bar releases B.  foo ends up stuck in mutex_lock() indefinitely, but
> > still holds A and everybody else who needs A gets behind A.  Given that
> > this A happens to be a central libceph mutex all rbd activity halts.
> > Deadlock may not be the best term for this, but never returning from
> > mutex_lock(&B) even though B has been unlocked is *a* problem.
> > 
> > This obviously doesn't happen every time schedule_preempt_disabled() on
> > line 484 is called, so there must be some sort of race here.  I'll send
> > along the actual rbd stack traces shortly.
> 
> Smells like maybe current->state != TASK_RUNNING, does the below
> trigger?
> 
> If so, you've wrecked something in whatever...
> 
> ---
>  kernel/locking/mutex.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index ae712b25e492..3d726fdaa764 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -473,8 +473,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	 * reschedule now, before we try-lock the mutex. This avoids getting
>  	 * scheduled out right after we obtained the mutex.
>  	 */
> -	if (need_resched())
> +	if (need_resched()) {
> +		if (WARN_ON_ONCE(current->state != TASK_RUNNING))
> +			__set_current_state(TASK_RUNNING);
> +
>  		schedule_preempt_disabled();
> +	}

Might make sense to add that debug check under mutex debugging or so, 
with a sensible kernel message printed.

Thanks,

	Ingo
