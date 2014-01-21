Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaAUPpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:45:54 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20318 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaAUPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:45:50 -0500
Message-ID: <52DE9626.3030806@hp.com>
Date: Tue, 21 Jan 2014 10:45:42 -0500
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
Subject: Re: [PATCH v9 4/5] qrwlock: Use smp_store_release() in write_unlock()
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com> <1389761047-47566-5-git-send-email-Waiman.Long@hp.com> <20140120151855.GH30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140120151855.GH30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 10:18 AM, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 11:44:06PM -0500, Waiman Long wrote:
>> This patch modifies the queue_write_unlock() function to use the new
>> smp_store_release() function (currently in tip). It also removes the
>> temporary implementation of smp_load_acquire() and smp_store_release()
>> function in qrwlock.c.
>>
>> This patch will use atomic subtraction instead if the writer field is
>> not atomic.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>   include/asm-generic/qrwlock.h |   10 ++++++----
>>   kernel/locking/qrwlock.c      |   34 ----------------------------------
>>   2 files changed, 6 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
>> index 5abb6ca..68f488b 100644
>> --- a/include/asm-generic/qrwlock.h
>> +++ b/include/asm-generic/qrwlock.h
>> @@ -181,11 +181,13 @@ static inline void queue_read_unlock(struct qrwlock *lock)
>>   static inline void queue_write_unlock(struct qrwlock *lock)
>>   {
>>   	/*
>> -	 * Make sure that none of the critical section will be leaked out.
>> +	 * If the writer field is atomic, it can be cleared directly.
>> +	 * Otherwise, an atomic subtraction will be used to clear it.
>>   	 */
>> -	smp_mb__before_clear_bit();
>> -	ACCESS_ONCE(lock->cnts.writer) = 0;
>> -	smp_mb__after_clear_bit();
>> +	if (__native_word(lock->cnts.writer))
>> +		smp_store_release(&lock->cnts.writer, 0);
>> +	else
>> +		atomic_sub(_QW_LOCKED,&lock->cnts.rwa);
>>   }
> If we're a writer, read-count must be zero. The only way for that not to
> be zero is a concurrent read-(try)lock. If you move all the
> read-(try)locks over to cmpxchg() you can avoid this afaict:

That is not true. A reader may transiently set the reader count to a 
non-zero value in the fast path. Also, a reader in interrupt context 
will force a non-zero reader count to take the read lock as soon as the 
writer is done.

>
> static inline void queue_read_trylock(struct qrwlock *lock)
> {
> 	union qrwcnts cnts
>
> 	cnts = ACCESS_ONCE(lock->cnts);
> 	if (!cnts.writer) {
> 		if (cmpxchg(&lock->cnts.rwc, cnts.rwc, cnts.rwc + _QR_BIAS) == cnts.rwc)
> 			return 1;
> 	}
>
> 	return 0;
> }
>
> static inline void queue_read_lock(struct qrwlock *lock)
> {
> 	if (!queue_read_trylock(lock))
> 		queue_read_lock_slowpath(); // XXX do not assume extra _QR_BIAS
> }
>
> At which point you have the guarantee that read-count == 0, and you can
> write:
>
> static inline void queue_write_unlock(struct qrwlock *lock)
> {
> 	smp_store_release(&lock->cnts.rwc, 0);
> }
>
> No?
>

The current code is optimized for the reader-heavy case. So I used xadd 
for incrementing reader count to reduce the chance of retry due to 
concurrent reader count updates. The downside is the need to back out if 
a writer is here.

I can change the logic to use only cmpxchg for readers, but I don't see 
a compelling reason to do so.

-Longman
