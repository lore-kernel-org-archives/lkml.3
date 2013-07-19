Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795Ab3GSPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:30:26 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11460 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3GSPaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:30:23 -0400
Message-ID: <51E95B85.8090003@hp.com>
Date: Fri, 19 Jul 2013 11:30:13 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
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
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de> <51E49FA3.4030202@hp.com> <20130718074204.GA22623@gmail.com> <51E7F03A.4090305@hp.com> <20130719084023.GB25784@gmail.com>
In-Reply-To: <20130719084023.GB25784@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:40 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>> On 07/18/2013 03:42 AM, Ingo Molnar wrote:
>>> * Waiman Long<waiman.long@hp.com>   wrote:
>>>
>>>>>> + *    stealing the lock if come at the right moment, the granting of the
>>>>>> + *    lock is mostly in FIFO order.
>>>>>> + * 2. It is faster in high contention situation.
>>>>> Again, why is it faster?
>>>> The current rwlock implementation suffers from a thundering herd
>>>> problem. When many readers are waiting for the lock hold by a writer,
>>>> they will all jump in more or less at the same time when the writer
>>>> releases the lock. That is not the case with qrwlock. It has been shown
>>>> in many cases that avoiding this thundering herd problem can lead to
>>>> better performance.
>>> Btw., it's possible to further optimize this "writer releases the lock to
>>> multiple readers spinning" thundering herd scenario in the classic
>>> read_lock() case, without changing the queueing model.
>>>
>>> Right now read_lock() fast path is a single atomic instruction. When a
>>> writer releases the lock then it makes it available to all readers and
>>> each reader will execute a LOCK DEC instruction which will succeed.
>>>
>>> This is the relevant code in arch/x86/lib/rwlock.S [edited for
>>> readability]:
>>>
>>> __read_lock_failed():
>>>
>>> 0:      LOCK_PREFIX
>>>          READ_LOCK_SIZE(inc) (%__lock_ptr)
>>>
>>> 1:      rep; nop
>>>          READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
>>>          js      1b
>>>
>>>          LOCK_PREFIX READ_LOCK_SIZE(dec) (%__lock_ptr)
>>>          js      0b
>>>
>>>          ret
>>>
>>> This is where we could optimize: instead of signalling to each reader that
>>> it's fine to decrease the count and letting dozens of readers do that on
>>> the same cache-line, which ping-pongs around the numa cross-connect
>>> touching every other CPU as they execute the LOCK DEC instruction, we
>>> could let the _writer_ modify the count on unlock in essence, to the exact
>>> value that readers expect.
>>>
>>> Since read_lock() can never abort this should be relatively
>>> straightforward: the INC above could be left out, and the writer side
>>> needs to detect that there are no other writers waiting and can set the
>>> count to 'reader locked' value - which the readers will detect without
>>> modifying the cache line:
>>>
>>> __read_lock_failed():
>>>
>>> 0:      rep; nop
>>>          READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
>>>          js      0b
>>>
>>>          ret
>>>
>>> (Unless I'm missing something that is.)
>>>
>>> That way the current write_unlock() followed by a 'thundering herd' of
>>> __read_lock_failed() atomic accesses is transformed into an efficient
>>> read-only broadcast of information with only a single update to the
>>> cacheline: the writer-updated cacheline propagates in parallel to every
>>> CPU and is cached there.
>>>
>>> On typical hardware this will be broadcast to all CPUs as part of regular
>>> MESI invalidation bus traffic.
>>>
>>> reader unlock will still have to modify the cacheline, so rwlocks will
>>> still have a fundamental scalability limit even in the read-only usecase.
>> I think that will work. The only drawback that I can see is the fairness
>> argument. The current read/write lock implementation is unfair to the
>> writer. That change will make it even more unfair to the writer and
>> there is no easy way to detect a waiting writer unless we change the
>> structure to add such a field. As a result, a steady stream of readers
>> will have a higher chance of blocking out a writer indefinitely.
> The effect will have to be measured - but I don't think it's particularly
> hard to tune the fairness balance between readers and writers: the change
> I suggested would only affect the case when a writer already holding the
> lock unlocks it.
>
> But when a writer already holds the lock it can decide to pass that lock
> to another writer-spinning instead of unlocking to all readers. This too
> should be relatively straightforward to implement because neither
> read_lock() nor write_lock() can abort and race.
>
> Instead of doing:
>
> static inline void arch_write_unlock(arch_rwlock_t *rw)
> {
>          asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
>                       : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
> }
>
> the current owner could check whether there are other writers waiting and
> could drop into a slowpath that passes ownership to one of the writers via
> toggling bit 30 or so. This reduces the max number of writers by a factor
> of 2.
>
> But I'd implement this only if it proves to be a problem in practice.
>
> I'd strongly suggest to first address the thundering herd problem of
> write_unlock() and see how it affects scalability - before totally
> replacing it all with a new, fundamentally heavier locking primitive!
>
> Thanks,
>
> 	Ingo
I had run some performance tests using the fserver and new_fserver 
benchmarks
(on ext4 filesystems) of the AIM7 test suite on a 80-core DL980 with
HT on. The following kernels were used:

1. Modified 3.10.1 kernel with mb_cache_spinlock in fs/mbcache.c
    replaced by a rwlock
2. Modified 3.10.1 kernel + modified __read_lock_failed code as suggested
    by Ingo
3. Modified 3.10.1 kernel + queue read/write lock
4. Modified 3.10.1 kernel + queue read/write lock in classic read/write
    lock behavior

The last one is with the read lock stealing flag set in the qrwlock
structure to give priority to readers and behave more like the classic
read/write lock with less fairness.

The following table shows the averaged results in the 200-1000
user ranges:

+-----------------+--------+--------+--------+--------+
|  Kernel         |    1   |    2   |    3   |   4    |
+-----------------+--------+--------+--------+--------+
| fserver JPM     | 245598 | 274457 | 403348 | 411941 |
| % change from 1 |   0%   | +11.8% | +64.2% | +67.7% |
+-----------------+--------+--------+--------+--------+
| new-fserver JPM | 231549 | 269807 | 399093 | 399418 |
| % change from 1 |   0%   | +16.5% | +72.4% | +72.5% |
+-----------------+--------+--------+--------+--------+

The following table shows the averaged results in the 1100-2000
user ranges:

+-----------------+--------+--------+--------+--------+
|  Kernel         |    1   |    2   |    3   |   4    |
+-----------------+--------+--------+--------+--------+
| fserver JPM     | 230295 | 263562 | 347161 | 333908 |
| % change from 1 |   0%   | +14.5% | +50.8% | +45.0% |
+-----------------+--------+--------+--------+--------+
| new-fserver JPM | 241154 | 274571 | 338166 | 369550 |
| % change from 1 |   0%   | +13.9% | +40.2% | +53.2% |
+-----------------+--------+--------+--------+--------+

For these 2 benchmarks, the read/write lock bottleneck is in the
j_state_lock of the journal_s structure in include/linux/jbd2.h.

The following table show the amount of CPU time spent on the slowpaths
of the read and write lock for each of the different kernels listed
above as reported by perf with the fserver benchmark at 1500 users:

+-----------------+--------+--------+--------+--------+
|  Kernel         |    1   |    2   |    3   |   4    |
+-----------------+--------+--------+--------+--------+
| Read slowpath   | 16.9%  | 12.2%  | 11.7%  | 15.3%  |
| Write slowpath  | 13.3%  | 11.5%  | 0.02%  | 0.09%  |
+-----------------+--------+--------+--------+--------+

The small write slowpath numbers indicates that it is a reader heavy
lock with writers probably holding the lock a lot longer than the
readers.

It can be seen that the Ingo's changes does improve performance by
about 10-15% in this reader-heavy high contention scenario. It also 
reduces the read slowpath time relative to the write slowpath. However,
the queue read/write lock can improve performance by more than 50%. The
queue read/write lock is also much more fair to the writers as the
writers waiting time drop significantly.

In low contention situation, all the 4 kernels perform similarly with
1-2% performance variation and so it is hard to draw conclusion.

Regards,
Longman


