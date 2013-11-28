Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3K1Hoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:44:46 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26571 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3K1Hom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:44:42 -0500
Message-ID: <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 27 Nov 2013 23:44:38 -0800
In-Reply-To: <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
	 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
	 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 00:56 +0100, Thomas Gleixner wrote:
> On Tue, 26 Nov 2013, Davidlohr Bueso wrote:
> > On Tue, 2013-11-26 at 11:25 -0800, Davidlohr Bueso wrote:
> > > *sigh* I just realized I had some extra debugging options in the .config
> > > I ran for the patched kernel. This probably explains why the huge
> > > overhead. I'll rerun and report shortly.
> 
> So you pulled a FUTEX, i.e. F*d Up That EXperiment :)

hehe

> 
> > I'm very sorry about the false alarm -- after midnight my brain starts
> > to melt. After re-running everything on my laptop (yes, with the
> > correct .config file), I can see that the differences are rather minimal
> > and variation also goes down, as expected. I've also included the
> > results for the original atomic ops approach, which mostly measures the
> > atomic_dec when we dequeue the woken task. Results are in the noise
> > range and virtually the same for both approaches (at least on a smaller
> > x86_64 system).
> >
> > +---------+-----------------------------+----------------------------+------------------------------+
> > | threads | baseline time (ms) [stddev] | barrier time (ms) [stddev] | atomicops time (ms) [stddev] |
> > +---------+-----------------------------+----------------------------+------------------------------+
> > |     512 | 2.8360 [0.5168]             | 4.4100 [1.1150]            | 3.8150 [1.3293]              |
> > |     256 | 2.5080 [0.6375]             | 2.3070 [0.5112]            | 2.5980 [0.9079]              |
> > |     128 | 1.0200 [0.4264]             | 1.3980 [0.3391]            | 1.5180 [0.4902]              |
> > |      64 | 0.7890 [0.2667]             | 0.6970 [0.3374]            | 0.4020 [0.2447]              |
> > |      32 | 0.1150 [0.0184]             | 0.1870 [0.1428]            | 0.1490 [0.1156]              |
> > +---------+-----------------------------+----------------------------+------------------------------+
> 
> That probably wants more than 10 repeated runs to converge into stable
> numbers. Thanks for providing the atomicops comparison! That's very
> helpful.
> 

Sorry about the delay, I've been airborne all day.

Here are the results for 1000 runs. The numbers stabilize nicely as you
add more samples. I think we can conclude that there really isn't much
of an impact in either case.

+---------+-----------------------------+----------------------------+------------------------------+
| threads | baseline time (ms) [stddev] | barrier time (ms) [stddev] | atomicops time (ms) [stddev] |
+---------+-----------------------------+----------------------------+------------------------------+
|     512 | 3.0959 [0.5293]             | 3.8402 [0.4282]            | 3.4274 [0.4418]              |
|     256 | 1.0973 [0.4023]             | 1.1162 [0.4167]            | 1.0768 [0.4130]              |
|     128 | 0.5062 [0.2110]             | 0.5221 [0.1867]            | 0.4249 [0.1922]              |
|      64 | 0.3146 [0.1312]             | 0.2580 [0.1302]            | 0.2555 [0.1266]              |
|      32 | 0.1448 [0.1022]             | 0.1568 [0.0838]            | 0.1478 [0.0788]              |
+---------+-----------------------------+----------------------------+------------------------------+

> It would be interesting to measure the overhead on the waiter side as
> well for both approaches (mb and atomic_inc), but I'm sure that at
> least for x86 it's going to be in the same ballpark.

Yeah, I don't expect much difference either, but will do the experiment.

> So I discovered earlier today, that your atomic ops variant is working
> because the atomic_inc() in get_futex_key_refs() is accidentally
> providing the required memory barrier on the waker side (on x86 and
> all other architectures which have an implict mb in atomic_inc()).
> 
> For !fshared ones it's even a full mb on all architectiures today, see
> ihold().

Interesting.

> Aside of that get_user_pages_fast() is using atomic ops as well, not
> sure if it's a full mb on all architectures today, but it is on x86
> and others.
> 
> Now I'm tempted to turn this accidental into a documented behaviour.
> The basic requirement for the fast lockless check of the plist is:
> 
>     record_waiter(hb)   |      *uaddr = newval
>     mb                  |      mb
>     *uaddr == oldval ?  |      nr_waiters(hb) != 0?
> 
> So on the waker side we can conditonally (dependent on the arch
> implementation) rely on the mb in get_futex_key_refs(). See below.
> 
> Now it does not matter much in terms of barrier related overhead
> whether the record_waiter() is implemented via atomic_inc() or via the
> early enqueue into the plist + smp_mb. In both cases we have a full
> smp_mb(), whether implicit or explicit.
> 
> And versus memory/cache footprint it's probably not relevant either
> whether we add the counter or not. Assumed we have no debug options
> enabled then the resulting size of futex_hash_bucket will be:
> 
>  16 bytes on 32bit (12 bytes today)
> 
>  24 bytes on 64bit (24 bytes today)
> 
> In fact for 32bit despite the slightly larger memory foot print the
> cache line efficiency is actually better than now as we avoid hash
> buckets crossing cache line boundaries.
> 
> No change on the 64 bit side.

Right, I should have mentioned this in the original changelog.

> 
> As a side note, it might be worthwhile to epxlore whether forcing the
> hash buckets to be cache line aligned gives us an advantage over
> blindly increasing the hash size:
> 
>  We could avoid access across cacheline boundaries and also avoid
>  massive cache line bouncing if multiple cpus are hammering away at
>  different hash buckets which happen to reside in the same cache line.

How about both enlarging the table _and_ aligning the buckets? As you
know, increasing the size of the table also benefits (particularly in
larger systems) in having more spinlocks. So we reduce the amount of
collisions and alleviate contention on the hb->lock. Btw, do you have
any particular concerns about the larger hash table patch? 

> But back to the problem at hand.
> 
> I'm leaning towards your initial atomic_inc() approach for the
> following reasons:
> 
> 1) It avoids the queue/unqueue dance in the error and (*uaddr != uval)
>    case. The latter is the one you are optimizing for.
> 
>    We dirty the cache line in any case on the waiter side.
> 
>    With the optimized check, we avoid dirtying the cache line on the
>    waker side in the case that there is no waiter in flight or
>    enqueued.
> 
> 2) It's very simple to make it OPT-IN. That allows architectures to
>    trade the mb/memory overhead with the spinlock contention overhead.
> 
>    A lot of [embedded] architectures do not care at all about the
>    futex performance simply because they do not run futex sensitive
>    workloads. And others might want to avoid the heavy smp_mb() for
>    obvious reasons.
> 
>    Make that a CONFIG switch which can be selected by the user or by a
>    select statement in the arch. That also allows archs to determine
>    the costs of that optimization just by recompiling with a different
>    .config.

Would it be useful to consider NR_CPUS? Sure, you get the problem of
when it's too little or too big, but it would deal quite well for
smaller systems - perhaps it could at least be mentioned in the option
description/help. I don't think users should have a direct say in the
option, though.

> 
>    All it needs are conditional implementations for futex_get_mm(),
>    hb_waiters_inc(x), hb_waiters_dec() and hb_waiters_pending()

I like this abstraction.

> 
>    futex_get_mm(x)
>    {
>       atomic_inc(x); 
>       #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
>         /*
> 	 * Reduced to a simple barrier() where the atomic_inc
> 	 * has an implicit mb()
> 	 */
>         smp_mb__after_atomic_inc();
>       #endif
>    }
> 
>    futex_get_mm() must be used for incrementing the refcount of
>    &key->private.mm->mm_count in get_futex_key_refs().
> 
>    hb_waiters_inc(hb)
>    {
>       #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
>       atomic_inc(&hb->waiters); 
>         /*
> 	 * Reduced to a simple barrier() where the atomic_inc
> 	 * has an implicit mb()
> 	 */
>         smp_mb__after_atomic_inc();
>       #endif
>    }
> 
>    hb_waiters_inc() must be used in futex_wait()
> 
>    hb_waiters_dec(hb)
>    {
>       #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
>       atomic_dec(&hb->waiters); 
>         /*
> 	 * Reduced to a simple barrier() where the atomic_dec
> 	 * has an implicit mb().
> 	 *
> 	 * For the other archs it's debatable whether this has
> 	 * a hard requirement to be guarded. The optimized
> 	 * hb_waiters_pending() check for pending wakers might
> 	 * fail in rare cases, but just for the cost of a
> 	 * spinlock/unlock. The consistency of hb->waiters itself
> 	 * is always guaranteed, i.e. it can't go below 0.
> 	 */
>         smp_mb__after_atomic_dec();
>       #endif }
> 
>    hb_waiters_dec() must be used for dequeueing in all cases which
>    are counterparts to a queueing futex_wait().
> 
>    hb_waiters_pending(x)
>    {
>       #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
>           return atomic_read(x);
>       #else
> 	  return 1;
>       #endif
>    }
> 
>    So the compiler can optimize the quick check in futex_wait() out:
> 

You mean futex_wake().

>    	   if (!hb_waiters_pending(&hb->waiters))
> 	      goto out_put_keys;
> 
> 
> Of course that wants to be documented very carefully in the code, so
> we can avoid the brain melting exercise of the futex/memory ordering
> combo next time.

Thanks for all the careful analysis and feedback!
Davidlohr

