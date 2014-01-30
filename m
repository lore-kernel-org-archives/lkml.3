Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaA3Ryf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:54:35 -0500
Received: from [217.140.96.50] ([217.140.96.50]:37214 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbaA3Ryd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:54:33 -0500
Date: Thu, 30 Jan 2014 17:52:12 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "will@willdeacon.co.uk" <will@willdeacon.co.uk>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140130175212.GM7575@mudshark.cambridge.arm.com>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
 <20140130154400.GB5126@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130154400.GB5126@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jan 30, 2014 at 03:44:00PM +0000, Peter Zijlstra wrote:
> Something like this would work for ARM and PPC, although I didn't do the
> PPC variant of atomic_sub_release().
> 
> 
> --- a/arch/arm64/include/asm/atomic.h
> +++ b/arch/arm64/include/asm/atomic.h
> @@ -90,6 +90,21 @@ static inline void atomic_sub(int i, ato
>  	: "cc");
>  }
>  
> +static inline void atomic_sub_release(int i, atomic_t *v)
> +{
> +	unsigned long tmp;
> +	int result;
> +
> +	asm volatile("// atomic_sub\n"
> +"1:	ldxr	%w0, %2\n"
> +"	sub	%w0, %w0, %w3\n"
> +"	stlxr	%w1, %w0, %2\n"
> +"	cbnz	%w1, 1b"
> +	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
> +	: "Ir" (i)
> +	: "cc");

Probably want to replace this "cc" with a "memory".

> --- /dev/null
> +++ b/arch/arm64/include/asm/qrwlock.h
> @@ -0,0 +1,21 @@
> +#ifndef _ASM_ARM64_QRWLOCK_H
> +#define _ASM_ARM64_QRWLOCK_H
> +
> +#include <asm-generic/qrwlock_types.h>
> +
> +#define queue_read_unlock queue_read_unlock
> +static inline void queue_read_unlock(struct qrwlock *lock)
> +{
> +	atomic_sub_release(_QR_BIAS, &lock->cnts);
> +}
> +
> +#define queue_write_unlock queue_write_unlock
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +	atomic_sub_release(_QW_LOCKED, &lock->cnts);
> +}
> +
> +#include <asm-generic/qrwlock.h>
> +
> +#endif /* _ASM_ARM64_QRWLOCK_H */

It would be nice if these were default implementations of the unlock, then
architectures just implement atomic_sub_release how they like.

One thing worth mentioning: I have a fairly invasive set of changes pending
for arch/arm64/include/asm/atomic.h, so if you do decide to go with this,
I'm more than happy to take the sub_release part via the arm64 tree. I guess
it depends on when this is likely to get merged.

Cheers,

Will
