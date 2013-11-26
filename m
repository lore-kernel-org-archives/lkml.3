Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3KZX4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:56:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:37192 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3KZX4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:56:34 -0500
Date: Wed, 27 Nov 2013 00:56:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
In-Reply-To: <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de>  <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>  <20131126085256.GD789@laptop.programming.kicks-ass.net>  <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Davidlohr Bueso wrote:
> On Tue, 2013-11-26 at 11:25 -0800, Davidlohr Bueso wrote:
> > *sigh* I just realized I had some extra debugging options in the .config
> > I ran for the patched kernel. This probably explains why the huge
> > overhead. I'll rerun and report shortly.

So you pulled a FUTEX, i.e. F*d Up That EXperiment :)

> I'm very sorry about the false alarm -- after midnight my brain starts
> to melt. After re-running everything on my laptop (yes, with the
> correct .config file), I can see that the differences are rather minimal
> and variation also goes down, as expected. I've also included the
> results for the original atomic ops approach, which mostly measures the
> atomic_dec when we dequeue the woken task. Results are in the noise
> range and virtually the same for both approaches (at least on a smaller
> x86_64 system).
>
> +---------+-----------------------------+----------------------------+------------------------------+
> | threads | baseline time (ms) [stddev] | barrier time (ms) [stddev] | atomicops time (ms) [stddev] |
> +---------+-----------------------------+----------------------------+------------------------------+
> |     512 | 2.8360 [0.5168]             | 4.4100 [1.1150]            | 3.8150 [1.3293]              |
> |     256 | 2.5080 [0.6375]             | 2.3070 [0.5112]            | 2.5980 [0.9079]              |
> |     128 | 1.0200 [0.4264]             | 1.3980 [0.3391]            | 1.5180 [0.4902]              |
> |      64 | 0.7890 [0.2667]             | 0.6970 [0.3374]            | 0.4020 [0.2447]              |
> |      32 | 0.1150 [0.0184]             | 0.1870 [0.1428]            | 0.1490 [0.1156]              |
> +---------+-----------------------------+----------------------------+------------------------------+

That probably wants more than 10 repeated runs to converge into stable
numbers. Thanks for providing the atomicops comparison! That's very
helpful.

It would be interesting to measure the overhead on the waiter side as
well for both approaches (mb and atomic_inc), but I'm sure that at
least for x86 it's going to be in the same ballpark.

So I discovered earlier today, that your atomic ops variant is working
because the atomic_inc() in get_futex_key_refs() is accidentally
providing the required memory barrier on the waker side (on x86 and
all other architectures which have an implict mb in atomic_inc()).

For !fshared ones it's even a full mb on all architectiures today, see
ihold().

Aside of that get_user_pages_fast() is using atomic ops as well, not
sure if it's a full mb on all architectures today, but it is on x86
and others.

Now I'm tempted to turn this accidental into a documented behaviour.
The basic requirement for the fast lockless check of the plist is:

    record_waiter(hb)   |      *uaddr = newval
    mb                  |      mb
    *uaddr == oldval ?  |      nr_waiters(hb) != 0?

So on the waker side we can conditonally (dependent on the arch
implementation) rely on the mb in get_futex_key_refs(). See below.

Now it does not matter much in terms of barrier related overhead
whether the record_waiter() is implemented via atomic_inc() or via the
early enqueue into the plist + smp_mb. In both cases we have a full
smp_mb(), whether implicit or explicit.

And versus memory/cache footprint it's probably not relevant either
whether we add the counter or not. Assumed we have no debug options
enabled then the resulting size of futex_hash_bucket will be:

 16 bytes on 32bit (12 bytes today)

 24 bytes on 64bit (24 bytes today)

In fact for 32bit despite the slightly larger memory foot print the
cache line efficiency is actually better than now as we avoid hash
buckets crossing cache line boundaries.

No change on the 64 bit side.

As a side note, it might be worthwhile to epxlore whether forcing the
hash buckets to be cache line aligned gives us an advantage over
blindly increasing the hash size:

 We could avoid access across cacheline boundaries and also avoid
 massive cache line bouncing if multiple cpus are hammering away at
 different hash buckets which happen to reside in the same cache line.

But back to the problem at hand.

I'm leaning towards your initial atomic_inc() approach for the
following reasons:

1) It avoids the queue/unqueue dance in the error and (*uaddr != uval)
   case. The latter is the one you are optimizing for.

   We dirty the cache line in any case on the waiter side.

   With the optimized check, we avoid dirtying the cache line on the
   waker side in the case that there is no waiter in flight or
   enqueued.

2) It's very simple to make it OPT-IN. That allows architectures to
   trade the mb/memory overhead with the spinlock contention overhead.

   A lot of [embedded] architectures do not care at all about the
   futex performance simply because they do not run futex sensitive
   workloads. And others might want to avoid the heavy smp_mb() for
   obvious reasons.

   Make that a CONFIG switch which can be selected by the user or by a
   select statement in the arch. That also allows archs to determine
   the costs of that optimization just by recompiling with a different
   .config.

   All it needs are conditional implementations for futex_get_mm(),
   hb_waiters_inc(x), hb_waiters_dec() and hb_waiters_pending()

   futex_get_mm(x)
   {
      atomic_inc(x); 
      #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
        /*
	 * Reduced to a simple barrier() where the atomic_inc
	 * has an implicit mb()
	 */
        smp_mb__after_atomic_inc();
      #endif
   }

   futex_get_mm() must be used for incrementing the refcount of
   &key->private.mm->mm_count in get_futex_key_refs().

   hb_waiters_inc(hb)
   {
      #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
      atomic_inc(&hb->waiters); 
        /*
	 * Reduced to a simple barrier() where the atomic_inc
	 * has an implicit mb()
	 */
        smp_mb__after_atomic_inc();
      #endif
   }

   hb_waiters_inc() must be used in futex_wait()

   hb_waiters_dec(hb)
   {
      #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
      atomic_dec(&hb->waiters); 
        /*
	 * Reduced to a simple barrier() where the atomic_dec
	 * has an implicit mb().
	 *
	 * For the other archs it's debatable whether this has
	 * a hard requirement to be guarded. The optimized
	 * hb_waiters_pending() check for pending wakers might
	 * fail in rare cases, but just for the cost of a
	 * spinlock/unlock. The consistency of hb->waiters itself
	 * is always guaranteed, i.e. it can't go below 0.
	 */
        smp_mb__after_atomic_dec();
      #endif }

   hb_waiters_dec() must be used for dequeueing in all cases which
   are counterparts to a queueing futex_wait().

   hb_waiters_pending(x)
   {
      #ifdef CONFIG_FUTEX_SOMESENSIBLE_OPTION
          return atomic_read(x);
      #else
	  return 1;
      #endif
   }

   So the compiler can optimize the quick check in futex_wait() out:

   	   if (!hb_waiters_pending(&hb->waiters))
	      goto out_put_keys;


Of course that wants to be documented very carefully in the code, so
we can avoid the brain melting exercise of the futex/memory ordering
combo next time.

Thanks,

      tglx, who is about to apply a full memory barrier to himself in
      	    order to cure all this FU[BAR]TEX induced brain damage.
