Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaE1V4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbaE1V4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:56:38 -0400
Message-ID: <53865B53.7050809@redhat.com>
Date: Wed, 28 May 2014 17:55:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, konrad.wilk@oracle.com,
        pbonzini@redhat.com, gleb@redhat.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
CC: torvalds@linux-foundation.org, waiman.long@hp.com, davej@redhat.com,
        oleg@redhat.com, x86@kernel.org, jeremy@goop.org,
        paul.gortmaker@windriver.com, ak@linux.intel.com, jasowang@redhat.com,
        fernando_b1@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Implement Batched (group) ticket lock
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 08:16 AM, Raghavendra K T wrote:

This patch looks very promising.

> TODO:
> - we need an intelligent way to nullify the effect of batching for baremetal
>  (because extra cmpxchg is not required).

On (larger?) NUMA systems, the unfairness may be a nice performance
benefit, reducing cache line bouncing through the system, and it
could well outweigh the extra cmpxchg at times.

> - we may have to make batch size as kernel arg to solve above problem
>  (to run same kernel for host/guest). Increasing batch size also seem to help
>  virtualized guest more, so we will have flexibility of tuning depending on vm size.
> 
> - My kernbench/ebizzy test on baremetal (32 cpu +ht sandybridge) did not seem to
>   show the impact of extra cmpxchg. but there should be effect of extra cmpxchg.

Canceled out by better NUMA locality?

Or maybe cmpxchg is cheap once you already own the cache line
exclusively?

> - virtualized guest had slight impact on 1x cases of some benchmarks but we have got
>  impressive performance for >1x cases. So overall, patch needs exhaustive tesing.
> 
> - we can further add dynamically changing batch_size implementation (inspiration and
>   hint by Paul McKenney) as necessary.

I could see a larger batch size being beneficial.

Currently the maximum wait time for a spinlock on a system
with N CPUs is N times the length of the largest critical
section.

Having the batch size set equal to the number of CPUs would only
double that, and better locality (CPUs local to the current
lock holder winning the spinlock operation) might speed things
up enough to cancel that part of that out again...

>  I have found that increasing  batch size gives excellent improvements for 
>  overcommitted guests. I understand that we need more exhaustive testing.
> 
>  Please provide your suggestion and comments.

I have only nitpicks so far...

> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index 4f1bea1..b04c03d 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -3,15 +3,16 @@
>  
>  #include <linux/types.h>
>  
> +#define TICKET_LOCK_INC_SHIFT 1
> +#define __TICKET_LOCK_TAIL_INC (1<<TICKET_LOCK_INC_SHIFT)
> +
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
> -#define __TICKET_LOCK_INC	2
>  #define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
>  #else
> -#define __TICKET_LOCK_INC	1
>  #define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
>  #endif

For the !CONFIG_PARAVIRT case, TICKET_LOCK_INC_SHIFT used to be 0,
now you are making it one. Probably not an issue, since even people
who compile with 128 < CONFIG_NR_CPUS <= 256 will likely have their
spinlocks padded out to 32 or 64 bits anyway in most data structures.

> -#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
> +#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_TAIL_INC))
>  typedef u8  __ticket_t;
>  typedef u16 __ticketpair_t;
>  #else
> @@ -19,7 +20,12 @@ typedef u16 __ticket_t;
>  typedef u32 __ticketpair_t;
>  #endif
>  
> -#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
> +#define TICKET_LOCK_TAIL_INC ((__ticket_t)__TICKET_LOCK_TAIL_INC)
> +
> +#define TICKET_LOCK_HEAD_INC ((__ticket_t)1)
> +#define TICKET_BATCH    0x4 /* 4 waiters can contend simultaneously */
> +#define TICKET_LOCK_BATCH_MASK (~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + \
> +				  TICKET_LOCK_TAIL_INC - 1)

I do not see the value in having TICKET_BATCH declared with a
hexadecimal number, and it may be worth making sure the code
does not compile if someone tried a TICKET_BATCH value that
is not a power of 2.

-- 
All rights reversed
