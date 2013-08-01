Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3HAKFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:05:37 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54323 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3HAKFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:05:35 -0400
Message-ID: <51FA3455.1000607@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 15:41:33 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
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
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com> <1375324631-32868-2-git-send-email-Waiman.Long@hp.com> <20130801094029.GK3008@twins.programming.kicks-ass.net>
In-Reply-To: <20130801094029.GK3008@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080110-5140-0000-0000-0000039CAF07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 03:10 PM, Peter Zijlstra wrote:
> On Wed, Jul 31, 2013 at 10:37:10PM -0400, Waiman Long wrote:
>
> OK, so over-all I rather like the thing. It might be good to include a
> link to some MCS lock description, sadly wikipedia doesn't have an
> article on the concept :/
>
> http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
>
> That seems like nice (short-ish) write-up of the general algorithm.
>
>> +typedef struct qspinlock {
>> +	union {
>> +		struct {
>> +			u8	locked;		/* Bit lock */
>> +			u8	reserved;
>> +			u16	qcode;		/* Wait queue code */
>> +		};
>> +		u32		qlock;
>> +	};
>> +} arch_spinlock_t;
>
>> +static __always_inline void queue_spin_unlock(struct qspinlock *lock)
>> +{
>> +	barrier();
>> +	ACCESS_ONCE(lock->locked) = 0;
>
> Its always good to add comments with barriers..
>
>> +	smp_wmb();
>> +}
>
>> +/*
>> + * The queue node structure
>> + */
>> +struct qnode {
>> +	struct qnode	*next;
>> +	u8		 wait;		/* Waiting flag	*/
>> +	u8		 used;		/* Used flag	*/
>> +#ifdef	CONFIG_DEBUG_SPINLOCK
>> +	u16		 cpu_nr;	/* CPU number	*/
>> +	void		*lock;		/* Lock address */
>> +#endif
>> +};
>> +
>> +/*
>> + * The 16-bit wait queue code is divided into the following 2 fields:
>> + * Bits 0-1 : queue node index
>> + * Bits 2-15: cpu number + 1
>> + *
>> + * The current implementation will allow a maximum of (1<<14)-1 = 16383 CPUs.
>
> I haven't yet read far enough to figure out why you need the -1 thing,
> but effectively you're restricted to 15k due to this.
>

It is exactly 16k-1 not 15k
That is because CPU_CODE of 1 to 16k represents cpu 0..16k-1



