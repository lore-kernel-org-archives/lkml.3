Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaGaMhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:37:31 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51393 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaGaMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140731115759.GS19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
	<20140731115759.GS19379@twins.programming.kicks-ass.net>
Date: Thu, 31 Jul 2014 16:37:29 +0400
Message-ID: <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 3:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jul 31, 2014 at 02:16:37PM +0400, Ilya Dryomov wrote:
>> This reverts commit 34c6bc2c919a55e5ad4e698510a2f35ee13ab900.
>>
>> This commit can lead to deadlocks by way of what at a high level
>> appears to look like a missing wakeup on mutex_unlock() when
>> CONFIG_MUTEX_SPIN_ON_OWNER is set, which is how most distributions ship
>> their kernels.  In particular, it causes reproducible deadlocks in
>> libceph/rbd code under higher than moderate loads with the evidence
>> actually pointing to the bowels of mutex_lock().
>>
>> kernel/locking/mutex.c, __mutex_lock_common():
>> 476         osq_unlock(&lock->osq);
>> 477 slowpath:
>> 478         /*
>> 479          * If we fell out of the spin path because of need_resched(),
>> 480          * reschedule now, before we try-lock the mutex. This avoids getting
>> 481          * scheduled out right after we obtained the mutex.
>> 482          */
>> 483         if (need_resched())
>> 484                 schedule_preempt_disabled(); <-- never returns
>> 485 #endif
>> 486         spin_lock_mutex(&lock->wait_lock, flags);
>>
>> We started bumping into deadlocks in QA the day our branch has been
>> rebased onto 3.15 (the release this commit went in) but then as part of
>> debugging effort I enabled all locking debug options, which also
>> disabled CONFIG_MUTEX_SPIN_ON_OWNER and made everything disappear,
>> which is why it hasn't been looked into until now.  Revert makes the
>> problem go away, confirmed by our users.
>
> This doesn't make sense and you fail to explain how this can possibly
> deadlock.

This didn't make sense to me at first too, and I'll be happy to be
proven wrong, but we can reproduce this with rbd very reliably under
higher than usual load, and the revert makes it go away.  What we are
seeing in the rbd scenario is the following.

Suppose foo needs mutexes A and B, bar needs mutex B.  foo acquires
A and then wants to acquire B, but B is held by bar.  foo spins
a little and ends up calling schedule_preempt_disabled() on line 484
above, but that call never returns, even though a hundred usecs later
bar releases B.  foo ends up stuck in mutex_lock() indefinitely, but
still holds A and everybody else who needs A gets behind A.  Given that
this A happens to be a central libceph mutex all rbd activity halts.
Deadlock may not be the best term for this, but never returning from
mutex_lock(&B) even though B has been unlocked is *a* problem.

This obviously doesn't happen every time schedule_preempt_disabled() on
line 484 is called, so there must be some sort of race here.  I'll send
along the actual rbd stack traces shortly.

Thanks,

                Ilya
