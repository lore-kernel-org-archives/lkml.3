Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaFLBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:25:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:8421 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaFLBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:25:08 -0400
Message-ID: <53990170.2010506@hp.com>
Date: Wed, 11 Jun 2014 21:25:04 -0400
From: "Long, Wai Man" <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@kernel.org, tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, hpa@zytor.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>		 <1401908911-8947-2-git-send-email-jason.low2@hp.com>		 <20140604194322.GN13930@laptop.programming.kicks-ass.net>		 <1401915420.13877.20.camel@buesod1.americas.hpqcorp.net>		 <1401915499.13877.21.camel@buesod1.americas.hpqcorp.net>	 <1402335482.6071.36.camel@j-VirtualBox> <5398C35B.5080301@hp.com> <1402523283.4035.23.camel@j-VirtualBox>
In-Reply-To: <1402523283.4035.23.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2014 5:48 PM, Jason Low wrote:
> On Wed, 2014-06-11 at 17:00 -0400, Long, Wai Man wrote:
>> On 6/9/2014 1:38 PM, Jason Low wrote:
>>> On Wed, 2014-06-04 at 13:58 -0700, Davidlohr Bueso wrote:
>>>> On Wed, 2014-06-04 at 13:57 -0700, Davidlohr Bueso wrote:
>>>>> In addition, how about the following helpers instead:
>>>>> - mutex_is_unlocked() : count > 0
>>>>> - mutex_has_waiters() : count < 0, or list_empty(->wait_list)
>>>>                                         ^ err, that's !list_empty()
>>> Between checking for (count < 0) or checking for !list_empty(wait_list)
>>> for waiters:
>>>
>>> Now that I think about it, I would expect a mutex_has_waiters() function
>>> to return !list_empty(wait_list) as that really tells whether or not
>>> there are waiters. For example, in highly contended cases, there can
>>> still be waiters on the mutex if count is 1.
>>>
>>> Likewise, in places where we currently use "MUTEX_SHOW_NO_WAITER", we
>>> need to check for (count < 0) to ensure lock->count is a negative value
>>> before the thread sleeps on the mutex.
>>>
>>> One option would be to still remove MUTEX_SHOW_NO_WAITER(), directly use
>>> atomic_read() in place of the macro, and just comment on why we have an
>>> extra atomic_read() that may "appear redundant". Another option could be
>>> to provide a function that checks for "potential waiters" on the mutex.
>>>
>>> Any thoughts?
>>>
>> For the first MUTEX_SHOW_NO_WAITER() call site, you can replace it with
>> a check for (count > 0).
> Yup, in my v2 patch, the first call site becomes !mutex_is_locked(lock)
> which is really a check for (count == 1).

Yes, your v2 patch looks fine to me.

>> The second call site within the for loop,
>> however, is a bit more tricky. It has to serve 2 purposes:
>>
>> 1. Opportunistically get the lock
>> 2. Set the count value to -1 to indicate someone is waiting on the lock,
>> that is why an xchg() operation has to be done even if its value is 0.
>>
>> I do agree that the naming isn't that good. Maybe it can be changed to
>> something like
>>
>> static inline int mutex_value_has_waiters(mutex *lock)    { return
>> lock->count < 0; }
> So I can imagine that a mutex_value_has_waiters() function might still
> not be a great name, since the mutex can have waiters in the case that
> the value lock->count >= 0.
>
> In the second call site, do you think we should just do a direct
> atomic_read(lock->count) >= 0 and comment that we only do the xchg if
> the count is non-negative to avoid unnecessary xchg? That what I did in
> my v2 patch.

I think that is a good idea to avoid any controversy in naming.

-Longman
