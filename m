Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3FKRga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3FKRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:36:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=i1PnZKElp1wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=qS4EiQt62_oA:10 a=OokLUahUzrLLa8UMXrYA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370972187.9844.205.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] v2 Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org,
        walken@google.com, waiman.long@hp.com
Date: Tue, 11 Jun 2013 13:36:27 -0400
In-Reply-To: <20130611170249.GA1091@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <20130611170249.GA1091@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 10:02 -0700, Paul E. McKenney wrote:

> +#ifdef CONFIG_TICKET_LOCK_QUEUED
> +
> +#define __TKT_SPIN_INC 2
> +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> +
> +#else /* #ifdef CONFIG_TICKET_LOCK_QUEUED */
> +
> +#define __TKT_SPIN_INC 1
> +static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> +{
> +	return false;
> +}
> +
> +#endif /* #else #ifdef CONFIG_TICKET_LOCK_QUEUED */
> +
>  /*
>   * Ticket locks are conceptually two parts, one indicating the current head of
>   * the queue, and the other indicating the current tail. The lock is acquired
> @@ -49,17 +64,15 @@
>   */
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
> -	register struct __raw_tickets inc = { .tail = 1 };
> +	register struct __raw_tickets inc = { .tail = __TKT_SPIN_INC };
>  
>  	inc = xadd(&lock->tickets, inc);
> -
>  	for (;;) {
> -		if (inc.head == inc.tail)
> +		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
>  			break;
> -		cpu_relax();

Overheating the CPU are we ;-)

Keeping the cpu_relax() doesn't hurt, even when TICKET_LOCK_QUEUE is
enabled. As the only latency to worry about is when tkt_spin_pass()
returns true, where it breaks out of the loop anyway.

But if you really don't want the double call to cpu_relax(), we can
probably remove the cpu_relax from tkt_spin_pass() and keep this one, or
in the above tkt_spin_pass() where TICK_LOCK_QUEUED is not set, we can
do:

static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct
__raw_tickets inc)
{
	cpu_relax();
	return false;
}

Honesty, I would say remove it from tkt_spin_pass() when returning
false.

-- Steve


>  		inc.head = ACCESS_ONCE(lock->tickets.head);
>  	}
> -	barrier();		/* make sure nothing creeps before the lock is taken */
> +	barrier(); /* Make sure nothing creeps in before the lock is taken. */
>  }
>  


