Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3HAVJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:09:38 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29034 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab3HAVJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:09:35 -0400
Message-ID: <51FACE78.9070901@hp.com>
Date: Thu, 01 Aug 2013 17:09:12 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com> <1375324631-32868-2-git-send-email-Waiman.Long@hp.com> <51FAC3BA.9050705@linux.vnet.ibm.com>
In-Reply-To: <51FAC3BA.9050705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 04:23 PM, Raghavendra K T wrote:
> On 08/01/2013 08:07 AM, Waiman Long wrote:
>>
>> +}
>> +/**
>> + * queue_spin_trylock - try to acquire the queue spinlock
>> + * @lock : Pointer to queue spinlock structure
>> + * Return: 1 if lock acquired, 0 if failed
>> + */
>> +static __always_inline int queue_spin_trylock(struct qspinlock *lock)
>> +{
>> +    if (!queue_spin_is_contended(lock) && (xchg(&lock->locked, 1) == 
>> 0))
>> +        return 1;
>> +    return 0;
>> +}
>> +
>> +/**
>> + * queue_spin_lock - acquire a queue spinlock
>> + * @lock: Pointer to queue spinlock structure
>> + */
>> +static __always_inline void queue_spin_lock(struct qspinlock *lock)
>> +{
>> +    if (likely(queue_spin_trylock(lock)))
>> +        return;
>> +    queue_spin_lock_slowpath(lock);
>> +}
>
> quickly falling into slowpath may hurt performance in some cases. no?

Failing the trylock means that the process is likely to wait. I do retry 
one more time in the slowpath before waiting in the queue.

> Instead, I tried something like this:
>
> #define SPIN_THRESHOLD 64
>
> static __always_inline void queue_spin_lock(struct qspinlock *lock)
> {
>         unsigned count = SPIN_THRESHOLD;
>         do {
>                 if (likely(queue_spin_trylock(lock)))
>                         return;
>                 cpu_relax();
>         } while (count--);
>         queue_spin_lock_slowpath(lock);
> }
>
> Though I could see some gains in overcommit, but it hurted undercommit
> in some workloads :(.

The gcc 4.4.7 compiler that I used in my test machine has the tendency 
of allocating stack space for variables instead of using registers when 
a loop is present. So I try to avoid having loop in the fast path. Also 
the count itself is rather arbitrary. For the first pass, I would like 
to make thing simple. We can always enhance it once it is accepted and 
merged.

>
>>
>> +/**
>> + * queue_trylock - try to acquire the lock bit ignoring the qcode in 
>> lock
>> + * @lock: Pointer to queue spinlock structure
>> + * Return: 1 if lock acquired, 0 if failed
>> + */
>> +static __always_inline int queue_trylock(struct qspinlock *lock)
>> +{
>> +    if (!ACCESS_ONCE(lock->locked) && (xchg(&lock->locked, 1) == 0))
>> +        return 1;
>> +    return 0;
>> +}
>
> It took long time for me to confirm myself that,
> this is being used when we exhaust all the nodes. But not sure of
> any better name so that it does not confuse with queue_spin_trylock.
> anyway, they are in different files :).
>

Yes, I know it is confusing. I will change the name to make it more 
explicit.

>
> Result:
> sandybridge 32 cpu/ 16 core (HT on) 2 node machine with 16 vcpu kvm
> guests.
>
> In general, I am seeing undercommit loads are getting benefited by the 
> patches.
>
> base = 3.11-rc1
> patched = base + qlock
> +----+-----------+-----------+-----------+------------+-----------+
>                      hackbench (time in sec lower is better)
> +----+-----------+-----------+-----------+------------+-----------+
>  oc      base        stdev       patched    stdev       %improvement
> +----+-----------+-----------+-----------+------------+-----------+
> 0.5x    18.9326     1.6072    20.0686     2.9968      -6.00023
> 1.0x    34.0585     5.5120    33.2230     1.6119       2.45313
> +----+-----------+-----------+-----------+------------+-----------+
> +----+-----------+-----------+-----------+------------+-----------+
>                       ebizzy  (records/sec higher is better)
> +----+-----------+-----------+-----------+------------+-----------+
>  oc      base        stdev       patched    stdev       %improvement
> +----+-----------+-----------+-----------+------------+-----------+
> 0.5x  20499.3750   466.7756     22257.8750   884.8308       8.57831
> 1.0x  15903.5000   271.7126     17993.5000   682.5095      13.14176
> 1.5x  1883.2222   166.3714      1742.8889   135.2271      -7.45177
> 2.5x   829.1250    44.3957       803.6250    78.8034      -3.07553
> +----+-----------+-----------+-----------+------------+-----------+
> +----+-----------+-----------+-----------+------------+-----------+
>                    dbench  (Throughput in MB/sec higher is better)
> +----+-----------+-----------+-----------+------------+-----------+
>  oc      base        stdev       patched    stdev       %improvement
> +----+-----------+-----------+-----------+------------+-----------+
> 0.5x 11623.5000    34.2764     11667.0250    47.1122       0.37446
> 1.0x  6945.3675    79.0642      6798.4950   161.9431      -2.11468
> 1.5x  3950.4367    27.3828      3910.3122    45.4275      -1.01570
> 2.0x  2588.2063    35.2058      2520.3412    51.7138      -2.62209
> +----+-----------+-----------+-----------+------------+-----------+
>
> I saw dbench results improving to 0.3529, -2.9459, 3.2423, 4.8027
> respectively after delaying entering to slowpath above.
> [...]
>
> I have not yet tested on bigger machine. I hope that bigger machine will
> see significant undercommit improvements.
>

Thank for running the test. I am a bit confused about the terminology. 
What exactly do undercommit and overcommit mean?

Regards,
Longman

