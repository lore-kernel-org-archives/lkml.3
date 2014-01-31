Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbaAaSQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:16:30 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:37874 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaAaSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:16:29 -0500
Message-ID: <52EBE875.3070107@hp.com>
Date: Fri, 31 Jan 2014 13:16:21 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>  <1390933151-1797-2-git-send-email-Waiman.Long@hp.com> <1391108430.3138.86.camel@schen9-DESK>
In-Reply-To: <1391108430.3138.86.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:00 PM, Tim Chen wrote:
> On Tue, 2014-01-28 at 13:19 -0500, Waiman Long wrote:
>
>> +/**
>> + * queue_spin_lock_slowpath - acquire the queue spinlock
>> + * @lock: Pointer to queue spinlock structure
>> + */
>> +void queue_spin_lock_slowpath(struct qspinlock *lock)
>> +{
>> +	unsigned int cpu_nr, qn_idx;
>> +	struct qnode *node, *next = NULL;
>> +	u32 prev_qcode, my_qcode;
>> +
>> +	/*
>> +	 * Get the queue node
>> +	 */
>> +	cpu_nr = smp_processor_id();
>> +	node   = this_cpu_ptr(&qnodes[0]);
>> +	qn_idx = 0;
>> +
>> +	if (unlikely(node->used)) {
>> +		/*
>> +		 * This node has been used, try to find an empty queue
>> +		 * node entry.
>> +		 */
>> +		for (qn_idx = 1; qn_idx<  MAX_QNODES; qn_idx++)
>> +			if (!node[qn_idx].used)
>> +				break;
>> +		if (unlikely(qn_idx == MAX_QNODES)) {
>> +			/*
>> +			 * This shouldn't happen, print a warning message
>> +			 *&  busy spinning on the lock.
>> +			 */
>> +			printk_sched(
>> +			  "qspinlock: queue node table exhausted at cpu %d!\n",
>> +			  cpu_nr);
>> +			while (!unfair_trylock(lock))
>> +				arch_mutex_cpu_relax();
>> +			return;
>> +		}
>> +		/* Adjust node pointer */
>> +		node += qn_idx;
>> +	}
>> +
>> +	/*
>> +	 * Set up the new cpu code to be exchanged
>> +	 */
>> +	my_qcode = SET_QCODE(cpu_nr, qn_idx);
>> +
> If we get interrupted here before we have a chance to set the used flag,
> the interrupt handler could pick up the same qnode if it tries to
> acquire queued spin lock.  Then we could overwrite the qcode we have set
> here.
>
> Perhaps an exchange operation for the used flag to prevent this race
> condition?
>
> Tim

That actually is fine. I am assuming that whenever an interrupt handler 
needs to acquire a spinlock, it can use the same queue node as the 
interrupted function as long as it can finish the lock acquisition and 
release queue node back to the pool before returning to the interrupted 
function. The only case where an interrupt handler cannot use the queue 
node is when useful data were already there indicated by the setting of 
the used flag.

I will add comment to clarify this possible scenario.

-Longman
