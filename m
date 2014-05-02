Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaEBNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:10:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaEBNK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:10:57 -0400
Message-ID: <53639958.9030002@infradead.org>
Date: Fri, 02 May 2014 06:10:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Peter Hurley <peter@hurleysoftware.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
References: <1398966637.2970.129.camel@schen9-DESK>  <5362AC24.9050508@hurleysoftware.com> <1398985513.2970.141.camel@schen9-DESK>
In-Reply-To: <1398985513.2970.141.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:05 PM, Tim Chen wrote:
> On Thu, 2014-05-01 at 16:18 -0400, Peter Hurley wrote:
>> On 05/01/2014 01:50 PM, Tim Chen wrote:
>>> It takes me a while to understand how rwsem's count field mainifest
>>> itself in different scenarios.  I'm adding comments to provide a quick
>>> reference on the the rwsem's count field for each scenario where readers
>>> and writers are contending/holding the lock.  Hopefully it will be useful
>>> for future maintenance of the code and for people to get up to speed on
>>> how the logic in the code works.
>>
>> Except there are a lot of transition states for the count that look like
>> stable states for some other condition, and vice versa.
>>
>> For example, 0xffff000X could be:
>> 1. stable state as described below.
>> 2. 1 or more (but not X) readers active,
>>      1 writer which failed to acquire and has not yet backed out the adjustment
>>      0 or more readers which failed to acquire because of the waiting writer
>>          and have not yet backed out
>> 3. 1 writer active,
>>      1 or more readers which failed to acquire because of the active writer and
>>          have not yet backed out
>> 4. maybe more states where a owning writer has just dropped the lock
>
> Thanks for the feedback.  Yes, one thing I missed was to account for the
> readers and writers who are actively attempting to lock by adding
> ACTIVE_BIAS or ACTIVE_WRITE_BIAS to the count.  Once we account for
> those we should take care of the transition states.
> The revised comments also look at the readers and writers actively
> attempting the lock.
>
>>
>> Because of this, it's hazardous to infer lock state except for the specific
>> existing tests (eg., the count observed by a failed reader after it has
>> acquired the wait_lock).
>
> Thanks.
>
> Tim
>
> ---
>
> It takes me quite a while to understand how rwsem's count field mainifest

                                                                manifests

> itself in different scenarios.  I'm adding comments to provide a quick
> reference on the the rwsem's count field for each scenario where readers
> and writers are contending for the lock.  Hopefully it will be useful
> for future maintenance of the code and for people to get up to speed on
> how the logic in the code works.
>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>   kernel/locking/rwsem-xadd.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 48 insertions(+)
>
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index 1d66e08..b92a403 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -12,6 +12,54 @@
>   #include <linux/export.h>
>
>   /*
> + * Guide to the rw_semaphore's count field for common values.
> + * (32 bit case illustrated, similar for 64 bit)

        32-bit                               64-bit

> + *
> + * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
> + *		    X = #active_readers + #readers attempting to lock
> + *		    (X*ACTIVE_BIAS)
> + *
> + * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
> + *		attempting to read lock or write lock.
> + *
> + * 0xffff000X	(1) X readers active or attempt lock, there are waiters for lock

			                        attempting

> + *		    X = #active readers + # readers attempting lock
> + *		    (X*ACTIVE_BIAS + WAITING_BIAS)
> + *		(2) 1 writer attempting lock, no waiters for lock
> + *		    X-1 = #active readers + #readers attempting lock
> + *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> + *		(3) 1 writer active, no waiters for lock
> + *		    X-1 = #active readers + #readers attempting lock
> + *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> + *
> + * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
> + *		    (WAITING_BIAS + ACTIVE_BIAS)
> + *		(2) 1 writer active or attempt lock, no waiters for lock

		                       attempting

> + *		    (ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> + *
> + * 0xffff0000	(1) There are writers or readers queued but none active
> + *		    or in the process of attempting lock.
> + *		    (WAITING_BIAS)
> + *		Note: writer can attempt to steal lock for this count by adding
> + *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
> + *
> + * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
> + *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
> + *
> + * Note: Reader attempt to lock by adding ACTIVE_BIAS in down_read and checking
> + *	 the count becomes more than 0, i.e. the case where there are only
> + *	 readers or no body has lock. (1st and 2nd case above)

	            nobody

> + *
> + *	 Writer attempt to lock by adding ACTIVE_WRITE_BIAS in down_write and
> + *	 checking the count becomes ACTIVE_WRITE_BIAS for succesful lock

	                                                  successful

> + *	 acquisition (i.e. nobody else has lock or attempts lock).  If
> + *	 unsuccessful, in rwsem_down_write_failed, we'll check to see if there
> + *	 are only waiters but none active (5th case above), and attempt to
> + *	 steal the lock.
> + *
> + */
> +
> +/*
>    * Initialize an rwsem:
>    */
>   void __init_rwsem(struct rw_semaphore *sem, const char *name,
>


-- 
~Randy
