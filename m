Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LAMK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:10:29 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:51726 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3LAMKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:10:25 -0500
Date: Sun, 1 Dec 2013 13:10:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
Message-ID: <20131201121022.GB12115@gmail.com>
References: <20131125203358.156292370@linutronix.de>
 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
 <20131126085256.GD789@laptop.programming.kicks-ass.net>
 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
 <20131128115946.GD13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128115946.GD13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Wouldn't something like the below also work?

> -#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
> -
>  /*
>   * Futex flags used to encode options to functions and preserve them across
>   * restarts.
> @@ -149,9 +147,11 @@ static const struct futex_q futex_q_init = {
>  struct futex_hash_bucket {
>  	spinlock_t lock;
>  	struct plist_head chain;
> -};
> +} ____cacheline_aligned_in_smp;
>  
> -static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
> +static unsigned long __read_mostly futex_hashsize;
> +
> +static struct futex_hash_bucket *futex_queues;
>  
>  /*
>   * We hash on the keys returned from get_futex_key (see below).
> @@ -161,7 +161,7 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
>  	u32 hash = jhash2((u32*)&key->both.word,
>  			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
>  			  key->both.offset);
> -	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
> +	return &futex_queues[hash & (futex_hashsize - 1)];
>  }
>  
>  /*
> @@ -2735,6 +2735,16 @@ static int __init futex_init(void)
>  	u32 curval;
>  	int i;
>  
> +#ifdef CONFIG_BASE_SMALL
> +	futex_hashsize = 16;
> +#else
> +	futex_hashsize = roundup_pow_of_two(256 * num_possible_cpus());
> +#endif
> +
> +	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
> +			futex_hashsize, 0, futex_hashsize < 256 ? HASH_SMALL : 0,
> +			NULL, NULL, futex_hashsize, futex_hashsize);
> +

Two observations:

1)

Once we go dynamic hash here we might as well do a proper job: I think 
we should also scale up by RAM as well.

A 64 GB computing node with 64 cores should probably not not scale the 
same way as a 64 TB system with 64 cores, right?

Something like += log2(memory_per_node / 1GB) ? I.e. every doubling in 
the per node gigabytes adds one more bit to the hash, or so.

2)

But more importantly, since these are all NUMA systems, would it make 
sense to create per node hashes on NUMA? Each futex would be enqueued 
into the hash belonging to its own page's node.

That kind of separation would both reduce the collision count, and it 
would also reduce the cost of a collision. (it would slightly increase 
hash calculation cost.)

(It also makes hash size calculation nicely node count independent, 
we'd only consider per node CPU count and per node memory.)

Thanks,

	Ingo
