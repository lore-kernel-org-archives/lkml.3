Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3FJVIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:08:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3FJVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:08:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=wHZxKRnNx8T9UBDJ-0UA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370898505.9844.123.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Date: Mon, 10 Jun 2013 17:08:25 -0400
In-Reply-To: <20130609193657.GA13392@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
>  
> +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> +
> +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> +
> +static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
> +{
> +	register struct __raw_tickets inc = { .tail = 2 };
> +
> +	inc = xadd(&lock->tickets, inc);
> +	for (;;) {
> +		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
> +			break;
> +		inc.head = ACCESS_ONCE(lock->tickets.head);
> +	}
> +	barrier(); /* smp_mb() on Power or ARM. */
> +}
> +
> +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> +

To avoid the above code duplication, I would have this instead:

#ifdef CONFIG_TICKET_LOCK_QUEUED

bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
#define __TKT_SPIN_INC 2

#else

static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct
__raw_tickets inc)
{
	return false;
}

#define __TKT_SPIN_INC 1

#endif

static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
{
	register struct __raw_tickets inc = { .tail = __TKT_SPIN_INC };

	inc = xadd(&lock->tickets, inc);

	for (;;) {
		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
			break;
		cpu_relax();
		inc.head = ACCESS_ONCE(lock->tickets.head);
	}
	barrier;	/* make sure nothing creeps before the lock is taken */
}

-- Steve


