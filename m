Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915Ab3DHMm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:42:29 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54657 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935723Ab3DHMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:42:28 -0400
Date: Mon, 8 Apr 2013 14:42:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
Message-ID: <20130408124223.GA10093@gmail.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
 <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> In the __mutex_lock_common() function, an initial entry into
> the lock slow path will cause two atomic_xchg instructions to be
> issued. Together with the atomic decrement in the fast path, a total
> of three atomic read-modify-write instructions will be issued in
> rapid succession. This can cause a lot of cache bouncing when many
> tasks are trying to acquire the mutex at the same time.
> 
> This patch will reduce the number of atomic_xchg instructions used by
> checking the counter value first before issuing the instruction. The
> atomic_read() function is just a simple memory read. The atomic_xchg()
> function, on the other hand, can be up to 2 order of magnitude or even
> more in cost when compared with atomic_read(). By using atomic_read()
> to check the value first before calling atomic_xchg(), we can avoid a
> lot of unnecessary cache coherency traffic. The only downside with this
> change is that a task on the slow path will have a tiny bit
> less chance of getting the mutex when competing with another task
> in the fast path.
> 
> The same is true for the atomic_cmpxchg() function in the
> mutex-spin-on-owner loop. So an atomic_read() is also performed before
> calling atomic_cmpxchg().
> 
> The mutex locking and unlocking code for the x86 architecture can allow
> any negative number to be used in the mutex count to indicate that some
> tasks are waiting for the mutex. I am not so sure if that is the case
> for the other architectures. So the default is to avoid atomic_xchg()
> if the count has already been set to -1. For x86, the check is modified
> to include all negative numbers to cover a larger case.
> 
> The following table shows the scalability data on an 8-node 80-core
> Westmere box with a 3.7.10 kernel. The numactl command is used to
> restrict the running of the high_systime workloads to 1/2/4/8 nodes
> with hyperthreading on and off.
> 
> +-----------------+------------------+------------------+----------+
> |  Configuration  | Mean Transaction | Mean Transaction | % Change |
> |		  |  Rate w/o patch  | Rate with patch  |	   |
> +-----------------+------------------------------------------------+
> |		  |              User Range 1100 - 2000		   |
> +-----------------+------------------------------------------------+
> | 8 nodes, HT on  |      36980       |      148590      | +301.8%  |
> | 8 nodes, HT off |      42799       |      145011      | +238.8%  |
> | 4 nodes, HT on  |      61318       |      118445      |  +51.1%  |
> | 4 nodes, HT off |     158481       |      158592      |   +0.1%  |
> | 2 nodes, HT on  |     180602       |      173967      |   -3.7%  |
> | 2 nodes, HT off |     198409       |      198073      |   -0.2%  |
> | 1 node , HT on  |     149042       |      147671      |   -0.9%  |
> | 1 node , HT off |     126036       |      126533      |   +0.4%  |
> +-----------------+------------------------------------------------+
> |		  |              User Range 200 - 1000		   |
> +-----------------+------------------------------------------------+
> | 8 nodes, HT on  |      41525       |      122349      | +194.6%  |
> | 8 nodes, HT off |      49866       |      124032      | +148.7%  |
> | 4 nodes, HT on  |      66409       |      106984      |  +61.1%  |
> | 4 nodes, HT off |     119880       |      130508      |   +8.9%  |
> | 2 nodes, HT on  |     138003       |      133948      |   -2.9%  |
> | 2 nodes, HT off |     132792       |      131997      |   -0.6%  |
> | 1 node , HT on  |     116593       |      115859      |   -0.6%  |
> | 1 node , HT off |     104499       |      104597      |   +0.1%  |
> +-----------------+------------------+------------------+----------+

Hm, the most interesting/important measurement range is missing: 1-100 users?

> 
> AIM7 benchmark run has a pretty large run-to-run variance due to random
> nature of the subtests executed. So a difference of less than +-5%
> may not be really significant.
> 
> This patch improves high_systime workload performance at 4 nodes
> and up by maintaining transaction rates without significant drop-off
> at high node count.  The patch has practically no impact on 1 and 2
> nodes system.
> 
> The table below shows the percentage time (as reported by perf
> record -a -s -g) spent on the __mutex_lock_slowpath() function by
> the high_systime workload at 1500 users for 2/4/8-node configurations
> with hyperthreading off.
> 
> +---------------+-----------------+------------------+---------+
> | Configuration | %Time w/o patch | %Time with patch | %Change |
> +---------------+-----------------+------------------+---------+
> |    8 nodes    |      65.34%     |      0.69%       |  -99%   |
> |    4 nodes    |       8.70%	    |      1.02%       |  -88%   |
> |    2 nodes    |       0.41%     |      0.32%       |  -22%   |
> +---------------+-----------------+------------------+---------+
> 
> It is obvious that the dramatic performance improvement at 8
> nodes was due to the drastic cut in the time spent within the
> __mutex_lock_slowpath() function.
> 
> The table below show the improvements in other AIM7 workloads (at 8
> nodes, hyperthreading off).
> 
> +--------------+---------------+----------------+-----------------+
> |   Workload   | mean % change | mean % change  | mean % change   |
> |              | 10-100 users  | 200-1000 users | 1100-2000 users |
> +--------------+---------------+----------------+-----------------+
> | alltests     |     +0.6%     |   +104.2%      |   +185.9%       |
> | five_sec     |     +1.9%     |     +0.9%      |     +0.9%       |
> | fserver      |     +1.4%     |     -7.7%      |     +5.1%       |
> | new_fserver  |     -0.5%     |     +3.2%      |     +3.1%       |
> | shared       |    +13.1%     |   +146.1%      |   +181.5%       |
> | short        |     +7.4%     |     +5.0%      |     +4.2%       |
> +--------------+---------------+----------------+-----------------+
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  arch/x86/include/asm/mutex.h |   16 ++++++++++++++++
>  kernel/mutex.c               |    9 ++++++---
>  kernel/mutex.h               |    8 ++++++++
>  3 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
> index 7d3a482..aa6a3ec 100644
> --- a/arch/x86/include/asm/mutex.h
> +++ b/arch/x86/include/asm/mutex.h
> @@ -3,3 +3,19 @@
>  #else
>  # include <asm/mutex_64.h>
>  #endif
> +
> +#ifndef	__ASM_MUTEX_H
> +#define	__ASM_MUTEX_H
> +
> +#ifdef MUTEX_SHOULD_XCHG_COUNT
> +#undef MUTEX_SHOULD_XCHG_COUNT
> +#endif
> +/*
> + * For the x86 architecture, it allows any negative number (besides -1) in
> + * the mutex counter to indicate that some other threads are waiting on the
> + * mutex. So the atomic_xchg() function should not be called in
> + * __mutex_lock_common() if the value of the counter has already been set
> + * to a negative number.
> + */
> +#define MUTEX_SHOULD_XCHG_COUNT(mutex)	(atomic_read(&(mutex)->count) >= 0)
> +#endif
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 52f2301..5e5ea03 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -171,7 +171,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		if (owner && !mutex_spin_on_owner(lock, owner))
>  			break;
>  
> -		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> +		if ((atomic_read(&lock->count) == 1) &&
> +		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>  			lock_acquired(&lock->dep_map, ip);
>  			mutex_set_owner(lock);
>  			preempt_enable();
> @@ -205,7 +206,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	list_add_tail(&waiter.list, &lock->wait_list);
>  	waiter.task = task;
>  
> -	if (atomic_xchg(&lock->count, -1) == 1)
> +	if (MUTEX_SHOULD_XCHG_COUNT(lock) &&
> +	   (atomic_xchg(&lock->count, -1) == 1))
>  		goto done;
>  
>  	lock_contended(&lock->dep_map, ip);
> @@ -220,7 +222,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		 * that when we release the lock, we properly wake up the
>  		 * other waiters:
>  		 */
> -		if (atomic_xchg(&lock->count, -1) == 1)
> +		if (MUTEX_SHOULD_XCHG_COUNT(lock) &&
> +		   (atomic_xchg(&lock->count, -1) == 1))
>  			break;
>  
>  		/*
> diff --git a/kernel/mutex.h b/kernel/mutex.h
> index 4115fbf..b873f8e 100644
> --- a/kernel/mutex.h
> +++ b/kernel/mutex.h
> @@ -46,3 +46,11 @@ static inline void
>  debug_mutex_lock_common(struct mutex *lock, struct mutex_waiter *waiter)
>  {
>  }
> +
> +/*
> + * The atomic_xchg() function should not be called in __mutex_lock_common()
> + * if the value of the counter has already been set to -1.
> + */
> +#ifndef MUTEX_SHOULD_XCHG_COUNT
> +#define	MUTEX_SHOULD_XCHG_COUNT(mutex)	(atomic_read(&(mutex)->count) != -1)
> +#endif

So, AFAICS, what we are doing here is to replace the rather aggressive 
modification+dirtying 'trylock' attempt loop of the mutex cacheline with softer 
atomic_read() based polling, and thus keep the polling nicer.

This helps you, because with 8 nodes and a lot of inter-node cacheline transfer 
latency, all the cores polling the same cachelines is going to show up big time 
and will reduce general system performance by eating up memory bandwidth.

I think doing a change into this general direction (be less aggressive in 
contention) might be reasonable, but its effect on the small range should be 
measured more accurately I think.

AFAICS the main performance trade-off is the following: when the owner CPU unlocks 
the mutex, we'll poll it via a read first, which turns the cacheline into 
shared-read MESI state. Then we notice that its content signals 'lock is 
available', and we attempt the trylock again.

This increases lock latency in the few-contended-tasks case slightly - and we'd 
like to know by precisely how much, not just for a generic '10-100 users' case 
which does not tell much about the contention level.

Furthermore, since you are seeing this effect so profoundly, have you considered 
using another approach, such as queueing all the poll-waiters in some fashion? 

That would optimize your workload additionally: removing the 'stampede' of trylock 
attempts when an unlock happens - only a single wait-poller would get the lock.

I don't think patch #2 is really meaningful - AFAICS it replaces the polling of a 
field in the mutex cacheline by polling another field in the mutex cacheline. That 
does not truly queue tasks, as mutex->spinner will still be stampeded on when it 
gets set to NULL by an unlock.

AFAICS patch #3 is really trying to work around the limitations of patch #1 I 
think, via arbitrary looking tuning limits. Furthermore, its access to the 
SMP-global calc_load_tasks variable is not very good looking either.

So instead of these 3 patches I think we should try a single, conceptually more 
robust, queueing based mutex-owner slow path spin-loop. If done right then I think 
it should improve performance in pretty much _all_ cases, without weird load 
limits.

Btw., I think the sensitivity of your numbers to HyperThreading is interesting. 
You might want to try to remove the arch_mutex_cpu_relax() call (or make it less 
frequent) and see what happens - does that improve the HT numbers?

Thanks,

	Ingo
