Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaAaS0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:26:40 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21172 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255AbaAaS0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:26:37 -0500
Message-ID: <52EBEAD5.3000502@hp.com>
Date: Fri, 31 Jan 2014 13:26:29 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tim Chen <tim.c.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com> <1390933151-1797-2-git-send-email-Waiman.Long@hp.com> <1391108430.3138.86.camel@schen9-DESK> <20140130192835.GK5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140130192835.GK5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:28 PM, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 11:00:30AM -0800, Tim Chen wrote:
>> On Tue, 2014-01-28 at 13:19 -0500, Waiman Long wrote:
>>
>>> +/**
>>> + * queue_spin_lock_slowpath - acquire the queue spinlock
>>> + * @lock: Pointer to queue spinlock structure
>>> + */
>>> +void queue_spin_lock_slowpath(struct qspinlock *lock)
>>> +{
>>> +	unsigned int cpu_nr, qn_idx;
>>> +	struct qnode *node, *next = NULL;
>>> +	u32 prev_qcode, my_qcode;
>>> +
>>> +	/*
>>> +	 * Get the queue node
>>> +	 */
>>> +	cpu_nr = smp_processor_id();
>>> +	node   = this_cpu_ptr(&qnodes[0]);
>>> +	qn_idx = 0;
>>> +
>>> +	if (unlikely(node->used)) {
>>> +		/*
>>> +		 * This node has been used, try to find an empty queue
>>> +		 * node entry.
>>> +		 */
>>> +		for (qn_idx = 1; qn_idx<  MAX_QNODES; qn_idx++)
>>> +			if (!node[qn_idx].used)
>>> +				break;
>>> +		if (unlikely(qn_idx == MAX_QNODES)) {
>>> +			/*
>>> +			 * This shouldn't happen, print a warning message
>>> +			 *&  busy spinning on the lock.
>>> +			 */
>>> +			printk_sched(
>>> +			  "qspinlock: queue node table exhausted at cpu %d!\n",
>>> +			  cpu_nr);
>>> +			while (!unfair_trylock(lock))
>>> +				arch_mutex_cpu_relax();
>>> +			return;
>>> +		}
>>> +		/* Adjust node pointer */
>>> +		node += qn_idx;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Set up the new cpu code to be exchanged
>>> +	 */
>>> +	my_qcode = SET_QCODE(cpu_nr, qn_idx);
>>> +
>> If we get interrupted here before we have a chance to set the used flag,
>> the interrupt handler could pick up the same qnode if it tries to
>> acquire queued spin lock.  Then we could overwrite the qcode we have set
>> here.
>>
>> Perhaps an exchange operation for the used flag to prevent this race
>> condition?
> I don't get why we need the used thing at all; something like:
>
> struct qna {
> 	int cnt;
> 	struct qnode nodes[4];
> };
>
> DEFINE_PER_CPU(struct qna, qna);
>
> struct qnode *get_qnode(void)
> {
> 	struct qna *qna = this_cpu_ptr(&qna);
>
> 	return qna->nodes[qna->cnt++]; /* RMW */
> }
>
> void put_qnode(struct qnode *qnode)
> {
> 	struct qna *qna = this_cpu_ptr(&qna);
> 	qna->cnt--;
> }
>
> Should do fine, right?

Yes, we can do something like that. However I think put_qnode() needs to 
use atomic dec as well. As a result, we will need 2 additional atomic 
operations per slowpath invocation. The code may look simpler, but I 
don't think it will be faster than what I am currently doing as the 
cases where the used flag is set will be relatively rare.

>
> If we interrupt the RMW above the interrupted context hasn't yet used
> the queue and once we return its free again, so all should be well even
> on load-store archs.
>
> The nodes array might as well be 3, because NMIs should never contend on
> a spinlock, so all we're left with is task, softirq and hardirq context.

I am not so sure about NMI not taking a spinlock. I seem to remember 
seeing code that did that. Actually, I think the NMI code is trying to 
printk something which, in turn, need to acquire a spinlock.

-Longman
