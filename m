Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaHJVoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:44:16 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:11663 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaHJVoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:44:15 -0400
Message-ID: <53E7E7AD.6090404@hp.com>
Date: Sun, 10 Aug 2014 17:44:13 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>  <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>  <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net>  <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>  <1407527412.8365.60.camel@j-VirtualBox>  <1407529306.6583.19.camel@buesod1.americas.hpqcorp.net> <1407530326.8365.69.camel@j-VirtualBox>
In-Reply-To: <1407530326.8365.69.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 04:38 PM, Jason Low wrote:
> On Fri, 2014-08-08 at 13:21 -0700, Davidlohr Bueso wrote:
>> On Fri, 2014-08-08 at 12:50 -0700, Jason Low wrote:
>>>>   __visible __used noinline
>>>> @@ -730,6 +744,23 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>>>>   	if (__mutex_slowpath_needs_to_unlock())
>>>>   		atomic_set(&lock->count, 1);
>>>>
>>>> +/*
>>>> + * Skipping the mutex_has_owner() check when DEBUG, allows us to
>>>> + * avoid taking the wait_lock in order to do not call mutex_release()
>>>> + * and debug_mutex_unlock() when !DEBUG. This can otherwise result in
>>>> + * deadlocks when another task enters the lock's slowpath in mutex_lock().
>>>> + */
>>>> +#ifndef CONFIG_DEBUG_MUTEXES
>>>> +	/*
>>>> +	 * Abort the wakeup operation if there is an another mutex owner, as the
>>>> +	 * lock was stolen. mutex_unlock() should have cleared the owner field
>>>> +	 * before calling this function. If that field is now set, another task
>>>> +	 * must have acquired the mutex.
>>>> +	 */
>>>> +	if (mutex_has_owner(lock))
>>>> +		return;
>>> Would we need the mutex lock count to eventually get set to a negative
>>> value if there are waiters? An optimistic spinner can get the lock and
>>> set lock->count to 0. Then the lock count might remain 0 since a waiter
>>> might not get waken up here to try-lock and set lock->count to -1 if it
>>> goes back to sleep in the lock path.
>> This is a good point, but I think we are safe because we do not rely on
>> strict dependence between the mutex counter and the wait list. So to see
>> if there are waiters to wakeup, we do a !list_empty() check, but to
>> determine the lock state, we rely on the counter.
> Right, though if an optimistic spinner gets the lock, it would set
> lock->count to 0. After it is done with its critical region and calls
> mutex_unlock(), it would skip the slowpath and not wake up the next
> thread either, because it sees that the lock->count is 0. In that case,
> there might be a situation where the following mutex_unlock() call would
> skip waking up the waiter as there's no call to slowpath.
>
>

Actually, I am contemplating making similar changes for mutex. One code 
change that I made is for the spinner to change the count value to 
either 0 or -1 depending on the status of list_empty() so as to prevent 
the case of missed wakeup.

-Longman
