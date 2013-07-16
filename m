Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3GPBTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:19:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40648 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3GPBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:19:47 -0400
Message-ID: <51E49FA3.4030202@hp.com>
Date: Mon, 15 Jul 2013 21:19:31 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 06:31 PM, Thomas Gleixner wrote:
> On Fri, 12 Jul 2013, Waiman Long wrote:
>
>> In term of single-thread performance (no contention), a 256K
>> lock/unlock loop was run on a 2.4GHz Westmere x86-64 CPU. The following
>> table shows the average time for a single lock/unlock sequence:
>>
>> Lock Type		Time (ns)
>> ---------		---------
>> Ticket spinlock		  15.7
>> Read lock		  17.0
>> Write lock		  17.2
>> Queue read lock		  31.1
>> Queue write lock	  13.6
>>
>> While the queue read lock is almost double the time of a read lock
>> or spinlock, the queue write lock is the fastest of them all. The
>> execution time can probably be reduced a bit by allowing inlining of
>> the lock fast paths like the other locks.
> So you have the writer side faster than the ticket lock, but what
> about the reader side? And what about the contended case? What about
> high frequent readers with low frequent writers cases?

Yes, the queue read lock is almost twice the time of a read lock. I am 
trying to find way to reduce that.

>> To see how the queue write lock can be used as a replacement for ticket
>> spinlock (just like rwsem can be used as replacement of mutex), the
>> mb_cache_spinlock in fs/mbcache.c, which is a bottleneck in the disk
>> workload (ext4 FS) of the AIM7 benchmark, was converted to both a queue
>> write lock and a regular write lock. When running on a 8-socket 80-core
>> DL980 system, the performance improvement was shown in the table below.
>>
>> +-----------------+------------+------------+-----------+---------+
>> |  Configuration  |  Mean JPM  |  Mean JPM  | Mean JPM  | qrwlock |
>> |                 |Vanilla 3.10|3.10-qrwlock|3.10-rwlock| %Change |
>> +-----------------+-----------------------------------------------+
>> |                 |              User Range 10 - 100              |
>> +-----------------+-----------------------------------------------+
>> | 8 nodes, HT off |   441374   |   532774   |  637205   | +20.7%  |
>> | 8 nodes, HT on  |   449373   |   584387   |  641965   | +30.1%  |
>> +-----------------+-----------------------------------------------+
>> |                 |              User Range 200 - 1000            |
>> +-----------------+-----------------------------------------------+
>> | 8 nodes, HT off |   226870   |   354490   |  371593   | +56.3%  |
>> | 8 nodes, HT on  |   205997   |   314891   |  306378   | +52.9%  |
>> +-----------------+-----------------------------------------------+
>> |                 |              User Range 1100 - 2000           |
>> +-----------------+-----------------------------------------------+
>> | 8 nodes, HT off |   208234   |   321420   |  343694   | +54.4%  |
>> | 8 nodes, HT on  |   199612   |   297853   |  252569   | +49.2%  |
>> +-----------------+------------+------------+-----------+---------+
>>
>> Apparently, the regular read/write lock performs even better than
>> the queue read/write lock in some cases.  This is probably due to the
> The regular rwlock performs better in most cases. This is the full
> list comparing both against the ticket lock.
>
>      qrlock  	   rwlock
>      +20.7  	   +44.4
>      +30.1  	   +42.9
>
>      +56.3  	   +63.3
>      +52.9  	   +48.8
>
>      +54.4  	   +65.1
>      +49.2  	   +26.5
>
> So you try to sell that qrwlock as a replacement for ticket spinlocks,
> while at the same time you omit the fact that we have an even better
> implementation (except for the last test case) already in the
> kernel. What's the point of this exercise?

The main point is that the regular rwlock is not fair while the queue 
rwlock is close to as fair as the ticket spinlock. The LWN article 
http://lwn.net/Articles/364583/ mentioned about eliminating rwlock 
altogether precisely because of this unfairness as it can cause livelock 
in certain scenerio. I also saw slides to advise again using rwlock 
because of this.

>> fact that mb_cache_spinlock is in a separate cache line from the data
>> being manipulated.
> This is not about probably. What has the fact that the spinlock is in
> a different cache line to do with the replacement by a different
> implementation? Exactly nothing.
>
> All three candidates ticket spinlocks, qrwlocks and rwlocks are in a
> different cache line than the data which is protected by it.
>
> So what makes the performance difference between the three
> implementations? Definitely not the cache line association as that is
> the same for all implementations. And just for the record, we have
> tools to measure that.
>
> We really need proper explanations and not some guess based drivel to
> assess that.

I will collect more data about that.

> Further down you write in the code:
>
>> + * Compared with regular read/write lock, the queue read/write lock has
>> + * has the following advantages:
>> + * 1. It is more deterministic. Even though there is a slight chance of
> Why is it more deterministic than the existing implementation?

Deterministic means that that a process can acquire a lock within a 
reasonable time period without being starved for a long time. The 
qrwlock grants lock in FIFO order in most cases. That is what I mean by 
being more deterministic.

>
>> + *    stealing the lock if come at the right moment, the granting of the
>> + *    lock is mostly in FIFO order.
>> + * 2. It is faster in high contention situation.
> Again, why is it faster?

The current rwlock implementation suffers from a thundering herd 
problem. When many readers are waiting for the lock hold by a writer, 
they will all jump in more or less at the same time when the writer 
releases the lock. That is not the case with qrwlock. It has been shown 
in many cases that avoiding this thundering herd problem can lead to 
better performance.

>> + * The only downside is that the lock is 4 bytes larger in 32-bit systems
>> + * and 12 bytes larger in 64-bit systems.
>> + *
>> + * There are two queues for writers. The writer field of the lock is a
>> + * one-slot waiting queue. The writers that follows will have to wait
>> + * in the combined reader/writer queue (waitq).
>> + *
>> + * Compared with x86 ticket spinlock, the queue read/write lock is faster
>> + * in high contention situation. The writer lock is also faster in single
>> + * thread operations. Therefore, queue read/write lock can be considered as
>> + * a replacement for those spinlocks that are highly contended as long as
>> + * an increase in lock size is not an issue.
> So is it faster in the general case or only for the high contention or
> single thread operation cases?
>
> And you still miss to explain WHY it is faster. Can you please explain
> proper WHY it is faster and WHY we can't apply that technique you
> implemented for qrwlocks to writer only locks (aka spinlocks) with a
> smaller lock size?

I will try to collect more data to justify the usefulness of qrwlock.

>> Looking at the fserver and new_fserver workloads (ext4 FS) where the
>> journal->j_state_lock (a read/write lock) is a bottleneck especially
>> when HT is on, we see a slight different story. The j_state_lock is
>> an embedded read/write lock which is in the same cacheline as some
>> of the data being manipulated. The replacement by a queue read/write
>> lock gives the following improvement.
> Again, the fact that the lock is embedded and in the same cache line
> is not explaining anything here. Especially not why this is only
> relevant when HT is enabled. Please provide profound arguments backed
> by solid data collected with the proper tools.

It is the thundering herd problem that I mentioned above which can cause 
a lot of cacheline bouncing. If the process that got the lock try to 
access data around the lock, it can be slowed down by quite a lot.

>> +--------------------+-------------+--------------+---------------+
>> |      Workload      |mean % change|mean % change |mean % change  |
>> |                    |10-100 users |200-1000 users|1100-2000 users|
>> +--------------------+-------------+--------------+---------------+
>> |fserver (HT off)    |    +0.3%    |    -0.1%     |    +1.9%      |
>> |fserver (HT on)     |    -0.1%    |   +32.2%     |   +34.7%      |
>> |new_fserver (HT on) |    +0.8%    |    +0.9%     |    +0.9%      |
>> |new_fserver (HT off)|    -1.2%    |   +29.8%     |   +40.5%      |
>> +--------------------+-------------+--------------+---------------+
> So fserver gets a 34% improvement for HT ON, while new_fserver gets a
> 40% improvement for HT OFF. Any useful explanations except that the HT
> on/off annotations are swapped?
>
> Without explanations this is completely useless, really.

The reason is that rwlock contention accounts for only 1-2% of total CPU 
time when HT is off. When HT is on, the contention account for more than 
20%. That is why there isn't that much difference with HT off. I should 
have listed the perf data in the commit message. I will do that in the 
next version.

> And again we want to see the behaviour on machines which do not have a
> gazillion of sockets before we enable this unconditionally, as you try
> to do in the next patch. Just get it: 8 socket machines are nice toys,
> but 99% of the users do not have one.
>
> Aside of that, you are replacing all RW locks unconditionally by this
> new fangled thing, but did you actually run tests which look at other
> rwlock usage sites than the particular one you care about?

Users have the choice of using the old rwlock or the queue rwlock by 
selecting or unselecting the QUEUE_RWLOCK config parameter. I am not 
forcing the unconditional replacement of rwlock by qrwlock.

I will collect more data for the other use cases.

> I really doubt that. Why? Because it depends on the workload. And
> fserver triggers high frequency writers on the j_state_lock. But
> there are enough usage sites of rwlocks where the writer frequency is
> extremly low. So how does the almost doubled reader time affect those
> users of rwlocks?
>
> And reading further down your patch, I can confirm my suspicion.
>
>> +void queue_write_lock(struct qrwlock *lock)
>> +{
> ....
>> +	/*
>> +	 * At the head of the wait queue now, wait until no writer is pending
>> +	 * and then atomically set it again.
>> +	 */
> You are optimizing for the high frequency writer case. And that's not
> the primary use case for rwlocks. That's the special use case for the
> jbd2 journal_state_lock which CANNOT be generalized for all other
> rwlock usage sites.

It is true that this lock is kind of optimized for writers. For reader 
heavy code, the performance may not be as good as the rwlock for 
uncontended cases. However, I do believe that the fairness attribute of 
the qrwlock far outweigh the slight performance overhead of read 
lock/unlock. Furthermore, the lock/unlock sequence contributes only a 
very tiny percentage of total CPU time in uncontended cases. A slight 
increase may not really have a material impact on performance. Again, as 
promised, I will try to collect some more performance data for reader 
heavy usage cases.

Regards,
Longman
