Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaAWRMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:12:34 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39463 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAWRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:12:31 -0500
Message-ID: <52E14D67.4000202@hp.com>
Date: Thu, 23 Jan 2014 12:12:07 -0500
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
Subject: Re: [PATCH v10 1/4] qrwlock: A queue read/write lock implementation
References: <1390426438-31252-1-git-send-email-Waiman.Long@hp.com> <1390426438-31252-2-git-send-email-Waiman.Long@hp.com> <20140123100751.GS30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140123100751.GS30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 05:07 AM, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 04:33:55PM -0500, Waiman Long wrote:
>> +/**
>> + * queue_read_unlock - release read lock of a queue rwlock
>> + * @lock : Pointer to queue rwlock structure
>> + */
>> +static inline void queue_read_unlock(struct qrwlock *lock)
>> +{
>> +	/*
>> +	 * Atomically decrement the reader count
>> +	 */
>> +	atomic_sub(_QR_BIAS,&lock->cnts.rwa);
>> +}
>> +
>> +/**
>> + * queue_write_unlock - release write lock of a queue rwlock
>> + * @lock : Pointer to queue rwlock structure
>> + */
>> +static inline void queue_write_unlock(struct qrwlock *lock)
>> +{
>> +	/*
>> +	 * If the writer field is atomic, it can be cleared directly.
>> +	 * Otherwise, an atomic subtraction will be used to clear it.
>> +	 */
>> +	if (__native_word(lock->cnts.writer))
>> +		smp_store_release(&lock->cnts.writer, 0);
>> +	else
>> +		atomic_sub(_QW_LOCKED,&lock->cnts.rwa);
>> +}
> Both these unlocks miss a barrier; atomic_sub() doesn't imply any
> barrier what so ever.
>
> The smp_store_release() does, but the other two are invalid release ops
> in generic.

I thought that all atomic RMW instructions are memory barrier. If they 
are not, what kind of barrier should be added?

-Longman
