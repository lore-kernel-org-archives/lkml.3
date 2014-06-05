Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaFEDYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:24:35 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:56432 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaFEDYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:24:34 -0400
Message-ID: <538FE2DE.8080800@hp.com>
Date: Wed, 04 Jun 2014 23:24:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>  <1401908911-8947-2-git-send-email-jason.low2@hp.com>  <20140604194322.GN13930@laptop.programming.kicks-ass.net> <1401917173.2232.14.camel@j-VirtualBox>
In-Reply-To: <1401917173.2232.14.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:26 PM, Jason Low wrote:
> On Wed, 2014-06-04 at 21:43 +0200, Peter Zijlstra wrote:
>> On Wed, Jun 04, 2014 at 12:08:29PM -0700, Jason Low wrote:
>>> Upon entering the slowpath in __mutex_lock_common(), we try once more
>>> to acquire the mutex. We only try to acquire it if MUTEX_SHOW_NO_WAITER
>>> (lock->count>= 0) is true in order to avoid using the atomic xchg()
>>> operation whenever it is not necessary. However, we really only need
>>> to try to acquire if the mutex is free (lock->count == 1).
>>>
>>> This patch changes it so that we only try-acquire the mutex upon
>>> entering the slowpath if it is unlocked, rather than if there are
>>> no waiters. This helps further reduce unncessary atomic xchg()
>>> operations. Furthermore, this patch introduces and uses a new
>>> MUTEX_IS_UNLOCKED() macro to improve readbability.
>>>
>>> Signed-off-by: Jason Low<jason.low2@hp.com>
>>> ---
>>>   kernel/locking/mutex.c |   10 ++++++----
>>>   1 files changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
>>> index bc73d33..0925968 100644
>>> --- a/kernel/locking/mutex.c
>>> +++ b/kernel/locking/mutex.c
>>> @@ -48,9 +48,10 @@
>>>
>>>   /*
>>>    * A negative mutex count indicates that waiters are sleeping waiting for the
>>> - * mutex.
>>> + * mutex, and a count of one indicates the mutex is unlocked.
>>>    */
>>>   #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count)>= 0)
>>> +#define	MUTEX_IS_UNLOCKED(mutex)	(atomic_read(&(mutex)->count) == 1)
>> So I recently saw that MUTEX_SHOW_NO_WAITER thing and cried a little;
>> and now you're adding more of that same nonsense.
>>
>> Please make them inline functions, also can we rename the SHOW_NO_WAITER
>> thing, because its not at all clear to me wtf it does; should it be
>> called: mutex_no_waiters() or somesuch?
> Okay, I can make them inline functions. I mainly added the macro to keep
> it consistent with the MUTEX_SHOW_NO_WAITER() check, but we can surely
> make this more clear. mutex_no_waiters() sounds fine, or perhaps
> something like mutex_has_no_waiters()?
>

You can remove the MUTEX_SHOW_NO_WAITER macro as all the call sites are 
to be replaced. I didn't check directly for unlocked count because of 
fairness concern in my original patch, but I think checking directly for 
unlocked count should be fine too.

-Longman
