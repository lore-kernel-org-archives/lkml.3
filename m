Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3JWQ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:58:31 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:14002 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3JWQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:58:28 -0400
Message-ID: <52680022.1020200@hp.com>
Date: Wed, 23 Oct 2013 12:58:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: walken@google.com
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 1/3] qrwlock: A queue read/write lock implementation
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com> <1380722946-30468-2-git-send-email-Waiman.Long@hp.com> <20131023120004.GD2862@localhost>
In-Reply-To: <20131023120004.GD2862@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 08:00 AM, walken@google.com wrote:
> On Wed, Oct 02, 2013 at 10:09:04AM -0400, Waiman Long wrote:
>>
>> Tim Chen also tested the qrwlock with Ingo's patch on a 4-socket
>> machine.  It was found the performance improvement of 11% was the
>> same with regular rwlock or queue rwlock.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> I haven't followed all the locking threads lately; did this get into any
> tree yet and is it still being considered ?

I think it is still being considered. I am hoping that it can get into 
3.13, if possible.

>> + * Writer state values&  mask
>> + */
>> +#define	QW_WAITING	1			/* A writer is waiting	   */
>> +#define	QW_LOCKED	0xff			/* A writer holds the lock */
>> +#define QW_MASK_FAIR	((u8)~QW_WAITING)	/* Mask for fair reader    */
>> +#define QW_MASK_UNFAIR	((u8)~0)		/* Mask for unfair reader  */
> I'm confused - I expect fair readers want to queue behind a waiting writer,
> so shouldn't this be QW_MASK_FAIR=~0 and QW_MASK_UNFAIR=~QW_WAITING ?

Yes, you are right. I think I had mixed up the values in a revision to 
the patch. I will send out an updated patch with the right values.

>> +/**
>> + * wait_in_queue - Add to queue and wait until it is at the head
>> + * @lock: Pointer to queue rwlock structure
>> + * @node: Node pointer to be added to the queue
>> + *
>> + * The use of smp_wmb() is to make sure that the other CPUs see the change
>> + * ASAP.
>> + */
>> +static __always_inline void
>> +wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *prev;
>> +
>> +	node->next = NULL;
>> +	node->wait = true;
>> +	prev = xchg(&lock->waitq, node);
>> +	if (prev) {
>> +		prev->next = node;
>> +		smp_wmb();
>> +		/*
>> +		 * Wait until the waiting flag is off
>> +		 */
>> +		while (ACCESS_ONCE(node->wait))
>> +			cpu_relax();
>> +	}
>> +}
>> +
>> +/**
>> + * signal_next - Signal the next one in queue to be at the head
>> + * @lock: Pointer to queue rwlock structure
>> + * @node: Node pointer to the current head of queue
>> + */
>> +static __always_inline void
>> +signal_next(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *next;
>> +
>> +	/*
>> +	 * Try to notify the next node first without disturbing the cacheline
>> +	 * of the lock. If that fails, check to see if it is the last node
>> +	 * and so should clear the wait queue.
>> +	 */
>> +	next = ACCESS_ONCE(node->next);
>> +	if (likely(next))
>> +		goto notify_next;
>> +
>> +	/*
>> +	 * Clear the wait queue if it is the last node
>> +	 */
>> +	if ((ACCESS_ONCE(lock->waitq) == node)&&
>> +	    (cmpxchg(&lock->waitq, node, NULL) == node))
>> +			return;
>> +	/*
>> +	 * Wait until the next one in queue set up the next field
>> +	 */
>> +	while (likely(!(next = ACCESS_ONCE(node->next))))
>> +		cpu_relax();
>> +	/*
>> +	 * The next one in queue is now at the head
>> +	 */
>> +notify_next:
>> +	barrier();
>> +	ACCESS_ONCE(next->wait) = false;
>> +	smp_wmb();
>> +}
> I believe this could be unified with mspin_lock() / mspin_unlock() in
> kernel/mutex.c ? (there is already talk of extending these functions
> to be used by rwsem for adaptive spinning as well...)

It probably can, but the unification can wait until the code are in.

> Not a full review yet - I like the idea of making rwlock more fair but
> I haven't dug too much into the details yet.
>

Thank for taking the time to review it.

-Longman
