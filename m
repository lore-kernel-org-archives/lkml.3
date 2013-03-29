Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3C2MHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 08:07:47 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38568 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3C2MHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 08:07:46 -0400
Message-ID: <51558407.5040005@surriel.com>
Date: Fri, 29 Mar 2013 08:07:35 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5150B1C2.8090607@oracle.com> <20130325163844.042a45ba@annuminas.surriel.com> <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com> <1364303965.5053.29.camel@laptop> <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com> <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com> <1364373750.5053.54.camel@laptop> <20130328162337.3003ccd4@cuia.bos.redhat.com> <CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
In-Reply-To: <CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 10:50 PM, Michel Lespinasse wrote:
> On Thu, Mar 28, 2013 at 1:23 PM, Rik van Riel <riel@surriel.com> wrote:
>> Subject: [PATCH -mm -next] ipc,sem: change locking scheme to make lockdep happy
>>
>> Unfortunately the locking scheme originally proposed has false positives
>> with lockdep.  This can be fixed by changing the code to only ever take
>> one lock, and making sure that other relevant locks are not locked, before
>> entering a critical section.
>>
>> For the "global lock" case, this is done by taking the sem_array lock,
>> and then (potentially) waiting for all the semaphore's spinlocks to be
>> unlocked.
>>
>> For the "local lock" case, we wait on the sem_array's lock to be free,
>> before taking the semaphore local lock. To prevent races, we need to
>> check again after we have taken the local lock.
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Reported-by: Sasha Levin <sasha.levin@oracle.com>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> TL;DR: The locking algorithm is not familiar for me, but it seems
> sound. There are some implementation details I don't like. More
> below...
>
>> ---
>>   ipc/sem.c |   55 ++++++++++++++++++++++++++++++++++++++++---------------
>>   1 files changed, 40 insertions(+), 15 deletions(-)
>>
>> diff --git a/ipc/sem.c b/ipc/sem.c
>> index 36500a6..87b74d5 100644
>> --- a/ipc/sem.c
>> +++ b/ipc/sem.c
>> @@ -320,24 +320,39 @@ void __init sem_init (void)
>>   }
>>
>>   /*
>> - * If the sem_array contains just one semaphore, or if multiple
>> - * semops are performed in one syscall, or if there are complex
>> - * operations pending, the whole sem_array is locked.
>> - * If one semop is performed on an array with multiple semaphores,
>> - * get a shared lock on the array, and lock the individual semaphore.
>> + * If the request contains only one semaphore operation, and there are
>> + * no complex transactions pending, lock only the semaphore involved.
>> + * Otherwise, lock the entire semaphore array, since we either have
>> + * multiple semaphores in our own semops, or we need to look at
>> + * semaphores from other pending complex operations.
>>    *
>>    * Carefully guard against sma->complex_count changing between zero
>>    * and non-zero while we are spinning for the lock. The value of
>>    * sma->complex_count cannot change while we are holding the lock,
>>    * so sem_unlock should be fine.
>> + *
>> + * The global lock path checks that all the local locks have been released,
>> + * checking each local lock once. This means that the local lock paths
>> + * cannot start their critical sections while the global lock is held.
>>    */
>>   static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
>>                                int nsops)
>>   {
>>          int locknum;
>> + again:
>>          if (nsops == 1 && !sma->complex_count) {
>>                  struct sem *sem = sma->sem_base + sops->sem_num;
>>
>> +               /*
>> +                * Another process is holding the global lock on the
>> +                * sem_array. Wait for that process to release the lock,
>> +                * before acquiring our lock.
>> +                */
>> +               if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
>> +                       spin_unlock_wait(&sma->sem_perm.lock);
>> +                       goto again;
>> +               }
>> +
>
> So, there are a few things I don't like about spin_unlock_wait():
>
> 1- From a lock ordering point of view, it is strictly equivalent to
> taking the lock and then releasing it - and yet, lockdep won't catch
> any deadlocks that involve spin_unlock_wait. (Not your fault here,
> this should be fixed as a separate change in lockdep. I manually
> looked at the lock ordering here and found it safe).
>
> 2- With the current ticket lock implementation, a stream of lockers
> can starve spin_unlock_wait() forever. Once again, not your fault and
> I suspect this could be fixed - I expect spin_unlock_wait() callers
> actually only want to know that the lock has been passed on, not that
> it actually got to an unlocked state.
>
> 3- Regarding your actual use here - I find it confusing to call
> spin_unlock_wait() before holding any other lock. The pattern I expect
> to see is that people take one lock, then see that the other lock they
> want is already taken, so they release the first lock and wait on the
> second. So, I'd suggest we remove the sem_perm.lock checks here and
> deal with this in a retry path later down.
>
>>                  /* Lock just the semaphore we are interested in. */
>>                  spin_lock(&sem->lock);
>>
>> @@ -347,17 +362,33 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
>>                   */
>>                  if (unlikely(sma->complex_count)) {
>>                          spin_unlock(&sem->lock);
>> -                       goto lock_all;
>> +                       goto lock_array;
>> +               }
>> +
>> +               /*
>> +                * Another process is holding the global lock on the
>> +                * sem_array; we cannot enter our critical section,
>> +                * but have to wait for the global lock to be released.
>> +                */
>> +               if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
>> +                       spin_unlock(&sem->lock);
>> +                       goto again;
>
> This is IMO where the spin_unlock_wait(&sma->sem_perm.lock) would
> belong - right before the goto again.

That is where I had it initially. I may have gotten too clever
and worked on keeping more accesses read-only. If you want, I
can move it back here and re-submit the patch :)

> Also - I think there is a risk that an endless stream of complex
> semops could starve a simple semop here, as it would always find the
> sem_perm.lock to be locked ??? One easy way to guarantee progress
> would be to goto lock_array instead; however there is then the issue
> that a complex semop could force an endless stream of following simple
> semops to take the lock_array path. I'm not sure which of these
> problems is preferable to have...

If starvation turns out to be an issue, there is an even
simpler solution:

	if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
		spin_unlock(&sem->lock);
		spin_lock(&sma->sem_perm.lock);
		spin_lock(&sem->lock);
		spin_unlock(&sma->sem_perm.lock);
	}

Followed by unconditionally doing the critical section for
holding a single semaphore's lock, because we know that a
subsequent taker of sma->sem_perm.lock will either grab a
different semaphore's spinlock, or wait on the same semaphore's
spinlock, or wait for us to unlock our spinlock.

-- 
All rights reversed.
