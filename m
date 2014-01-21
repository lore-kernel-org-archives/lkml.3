Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaAUP6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:58:35 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:14080 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaAUP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:58:29 -0500
Message-ID: <52DE991F.1030900@hp.com>
Date: Tue, 21 Jan 2014 10:58:23 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 1/5] qrwlock: A queue read/write lock implementation
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com> <1389761047-47566-2-git-send-email-Waiman.Long@hp.com> <20140120152129.GH31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140120152129.GH31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 10:21 AM, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 11:44:03PM -0500, Waiman Long wrote:
>> +#ifndef arch_mutex_cpu_relax
>> +# define arch_mutex_cpu_relax() cpu_relax()
>> +#endif
> Include<linux/mutex.h>
>

Will do so.

>> +#ifndef smp_load_acquire
>> +# ifdef CONFIG_X86
>> +#   define smp_load_acquire(p)				\
>> +	({						\
>> +		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
>> +		barrier();				\
>> +		___p1;					\
>> +	})
>> +# else
>> +#   define smp_load_acquire(p)				\
>> +	({						\
>> +		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
>> +		smp_mb();				\
>> +		___p1;					\
>> +	})
>> +# endif
>> +#endif
>> +
>> +#ifndef smp_store_release
>> +# ifdef CONFIG_X86
>> +#   define smp_store_release(p, v)			\
>> +	do {						\
>> +		barrier();				\
>> +		ACCESS_ONCE(*p) = v;			\
>> +	} while (0)
>> +# else
>> +#   define smp_store_release(p, v)			\
>> +	do {						\
>> +		smp_mb();				\
>> +		ACCESS_ONCE(*p) = v;			\
>> +	} while (0)
>> +# endif
>> +#endif
> Remove these.

Will do that.

>> +/*
>> + * If an xadd (exchange-add) macro isn't available, simulate one with
>> + * the atomic_add_return() function.
>> + */
>> +#ifdef xadd
>> +# define qrw_xadd(rw, inc)	xadd(&(rw).rwc, inc)
>> +#else
>> +# define qrw_xadd(rw, inc)	(u32)(atomic_add_return(inc,&(rw).rwa) - inc)
>> +#endif
> Is GCC really so stupid that you cannot always use the
> atomic_add_return()? The x86 atomic_add_return is i + xadd(), so you'll
> end up with:
>
>   i + xadd() - i
>
> Surely it can just remove the two i terms?

I guess gcc should do the right thing. I will remove the macro.

>> +/**
>> + * wait_in_queue - Add to queue and wait until it is at the head
>> + * @lock: Pointer to queue rwlock structure
>> + * @node: Node pointer to be added to the queue
>> + */
>> +static inline void wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *prev;
>> +
>> +	node->next = NULL;
>> +	node->wait = true;
>> +	prev = xchg(&lock->waitq, node);
>> +	if (prev) {
>> +		prev->next = node;
>> +		/*
>> +		 * Wait until the waiting flag is off
>> +		 */
>> +		while (smp_load_acquire(&node->wait))
>> +			arch_mutex_cpu_relax();
>> +	}
>> +}
> Please rebase on top of the MCS lock patches such that this is gone.

I would like to keep this as long as the MCS patches have not been 
merged into tip. However, I will take that out if the MCS patches are in 
when I need to revise the qrwlock patches.

-Longman
