Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3GOUow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:44:52 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:27635 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3GOUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:44:50 -0400
Message-ID: <51E45F30.5070707@hp.com>
Date: Mon, 15 Jul 2013 16:44:32 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
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
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>  <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <1373899141.17876.145.camel@gandalf.local.home>
In-Reply-To: <1373899141.17876.145.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 10:39 AM, Steven Rostedt wrote:
> On Fri, 2013-07-12 at 21:34 -0400, Waiman Long wrote:
>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>
>> +/*
>> + * The queue read/write lock data structure
>> + * The reader stealing flag, if sea,t will enable reader at the head of the
> "sea,t"?

Should be "if set,". Thank for spotting the typo. It will be fixed in 
the next version.

>> +/**
>> + * wait_in_queue - Add to queue and wait until it is at the head
>> + * @lock: Pointer to queue read/writer lock structure
>> + * @node: Node pointer to be added to the queue
>> + */
>> +static __always_inline void
>> +wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *prev;
>> +
>> +	node->next = NULL;
>> +	node->wait = true;
>> +	barrier();
>> +	prev = xchg(&lock->waitq, node);
> "barrier()" isn't needed, as xchg() is a full blown smp_mb(), it also
> acts as a compiler barrier.

Will remove barrier().

>> +/*
>> + * queue_read_trylock - try to acquire read lock of a queue read/write lock
>> + * @lock : Pointer to queue read/writer lock structure
>> + * Return: 1 if lock acquired, 0 if failed
>> + */
>> +int queue_read_trylock(struct qrwlock *lock)
>> +{
>> +	struct qrwlock old, new;
>> +
>> +	old.rw = ACCESS_ONCE(lock->rw);
>> +	if (unlikely(old.writer))
>> +		return 0;
>> +	new.rw = old.rw;
>> +	new.readers++;
>> +
>> +	if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
>> +		return 1;
>> +	cpu_relax();
> What's the cpu_relax() for? It's not in a loop.

I put a cpu_relax() after each cacheline contention event. You are right 
that we don't need a cpu_relax() in the trylock() function here.

>
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(queue_read_trylock);
>> +
>> +/**
>> + * queue_write_lock - acquire write lock of a queue read/write lock
>> + * @lock : Pointer to queue read/writer lock structure
>> + */
>> +void queue_write_lock(struct qrwlock *lock)
>> +{
>> +	struct qrwnode node, *next;
>> +
>> +	if (likely(!ACCESS_ONCE(lock->writer))) {
>> +		/*
>> +		 * Atomically set the writer to 1, then wait until reader
>> +		 * count goes to 0.
>> +		 */
>> +		if (xchg(&lock->writer, 1) == 0) {
>> +			while (ACCESS_ONCE(lock->readers))
>> +				cpu_relax();
>> +			return;
>> +		}
>> +		cpu_relax();
> Another cpu_relax() outside of a loop.

I can remove that one too.

>> +
>> +/**
>> + * queue_write_trylock - try to acquire write lock of a queue read/write lock
>> + * @lock : Pointer to queue read/writer lock structure
>> + * Return: 1 if lock acquired, 0 if failed
>> + */
>> +int queue_write_trylock(struct qrwlock *lock)
>> +{
>> +	struct qrwlock old, new;
>> +
>> +	old.rw = ACCESS_ONCE(lock->rw);
>> +	if (!old.rw) {
>> +		/*
>> +		 * Atomically set the writer to 1 if readers = 0
>> +		 */
>> +		new.rw = old.rw;
>> +		new.writer = 1;
>> +		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
>> +			return 1;
>> +		cpu_relax();
> Again the cpu_relax with no loop.

Ditto.

>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(queue_write_trylock);
> I haven't seen anything bad about this with a quick review. But it
> should have a more thorough review to check all corner cases.
>
> -- Steve
>

Thank for your time.

Regards,
Longman
