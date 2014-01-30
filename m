Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaA3Po3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:44:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaA3Po1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:44:27 -0500
Date: Thu, 30 Jan 2014 16:44:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, will@willdeacon.co.uk
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140130154400.GB5126@laptop.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130151715.GA5126@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 04:17:15PM +0100, Peter Zijlstra wrote:
> --- /dev/null
> +++ b/arch/x86/include/asm/qrwlock.h
> @@ -0,0 +1,18 @@
> +#ifndef _ASM_X86_QRWLOCK_H
> +#define _ASM_X86_QRWLOCK_H
> +
> +#include <asm-generic/qrwlock_types.h>
> +
> +#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
> +#define queue_write_unlock queue_write_unlock
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +        barrier();
> +        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
> +}
> +#endif
> +
> +#include <asm-generic/qrwlock.h>
> +
> +#endif /* _ASM_X86_QRWLOCK_H */
> +

> +/**
> + * queue_read_unlock - release read lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_read_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Atomically decrement the reader count
> +	 */
> +	smp_mb__before_atomic_dec();
> +	atomic_sub(_QR_BIAS, &lock->cnts);
> +}
> +
> +#ifndef queue_write_unlock
> +/**
> + * queue_write_unlock - release write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * If the writer field is atomic, it can be cleared directly.
> +	 * Otherwise, an atomic subtraction will be used to clear it.
> +	 */
> +	smp_mb__before_atomic_dec();
> +	atomic_sub(_QW_LOCKED, &lock->cnts);
> +}
> +#endif


Something like this would work for ARM and PPC, although I didn't do the
PPC variant of atomic_sub_release().


--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -90,6 +90,21 @@ static inline void atomic_sub(int i, ato
 	: "cc");
 }
 
+static inline void atomic_sub_release(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// atomic_sub\n"
+"1:	ldxr	%w0, %2\n"
+"	sub	%w0, %w0, %w3\n"
+"	stlxr	%w1, %w0, %2\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
+	: "Ir" (i)
+	: "cc");
+}
+
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	unsigned long tmp;
--- /dev/null
+++ b/arch/arm64/include/asm/qrwlock.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_ARM64_QRWLOCK_H
+#define _ASM_ARM64_QRWLOCK_H
+
+#include <asm-generic/qrwlock_types.h>
+
+#define queue_read_unlock queue_read_unlock
+static inline void queue_read_unlock(struct qrwlock *lock)
+{
+	atomic_sub_release(_QR_BIAS, &lock->cnts);
+}
+
+#define queue_write_unlock queue_write_unlock
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	atomic_sub_release(_QW_LOCKED, &lock->cnts);
+}
+
+#include <asm-generic/qrwlock.h>
+
+#endif /* _ASM_ARM64_QRWLOCK_H */
+
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -122,6 +122,7 @@ static inline void queue_write_lock(stru
 	queue_write_lock_slowpath(lock);
 }
 
+#ifndef queue_read_unlock
 /**
  * queue_read_unlock - release read lock of a queue rwlock
  * @lock : Pointer to queue rwlock structure
@@ -134,6 +135,7 @@ static inline void queue_read_unlock(str
 	smp_mb__before_atomic_dec();
 	atomic_sub(_QR_BIAS, &lock->cnts);
 }
+#endif
 
 #ifndef queue_write_unlock
 /**
