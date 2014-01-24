Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaAXI0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:26:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55670 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:26:00 -0500
Date: Fri, 24 Jan 2014 09:25:14 +0100
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
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 1/4] qrwlock: A queue read/write lock implementation
Message-ID: <20140124082514.GB31570@twins.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <1390537731-45996-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390537731-45996-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:28:48PM -0500, Waiman Long wrote:
> +/**
> + * queue_read_trylock - try to acquire read lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static inline int queue_read_trylock(struct qrwlock *lock)
> +{
> +	union qrwcnts cnts;
> +
> +	cnts.rwc = ACCESS_ONCE(lock->cnts.rwc);
> +	if (likely(!cnts.writer)) {
> +		cnts.rwc = (u32)atomic_add_return(_QR_BIAS, &lock->cnts.rwa);
> +		if (likely(!cnts.writer)) {
> +			smp_mb__after_atomic_inc();

That's superfluous, as atomic_add_return() is documented as being a full
barrier.

> +			return 1;
> +		}
> +		atomic_sub(_QR_BIAS, &lock->cnts.rwa);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * queue_write_trylock - try to acquire write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static inline int queue_write_trylock(struct qrwlock *lock)
> +{
> +	union qrwcnts old, new;
> +
> +	old.rwc = ACCESS_ONCE(lock->cnts.rwc);
> +	if (likely(!old.rwc)) {
> +		new.rwc = old.rwc;
> +		new.writer = _QW_LOCKED;
> +		if (likely(cmpxchg(&lock->cnts.rwc, old.rwc, new.rwc)
> +				== old.rwc))

One could actually use atomic_cmpxchg() and avoid one (ab)use of that
union :-)

> +			return 1;
> +	}
> +	return 0;
> +}
> +/**
> + * queue_read_lock - acquire read lock of a queue rwlock
> + * @lock: Pointer to queue rwlock structure
> + */
> +static inline void queue_read_lock(struct qrwlock *lock)
> +{
> +	union qrwcnts cnts;
> +
> +	cnts.rwc = atomic_add_return(_QR_BIAS, &lock->cnts.rwa);
> +	if (likely(!cnts.writer)) {
> +		smp_mb__after_atomic_inc();

Superfluous again.

> +		return;
> +	}
> +	/*
> +	 * Slowpath will decrement the reader count, if necessary
> +	 */
> +	queue_read_lock_slowpath(lock);
> +}
> +
> +/**
> + * queue_write_lock - acquire write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_write_lock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Optimize for the unfair lock case where the fair flag is 0.
> +	 */
> +	if (cmpxchg(&lock->cnts.rwc, 0, _QW_LOCKED) == 0)

Could equally be atomic_cmpxchg() again.

> +		return;
> +	queue_write_lock_slowpath(lock);
> +}
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
> +	atomic_sub(_QR_BIAS, &lock->cnts.rwa);
> +}
> +
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
> +	if (__native_word(lock->cnts.writer))
> +		smp_store_release(&lock->cnts.writer, 0);
> +	else {
> +		smp_mb__before_atomic_dec();
> +		atomic_sub(_QW_LOCKED, &lock->cnts.rwa);
> +	}

Missing {}, Documentation/CodingStyle Chapter 3 near the very end.

> +}
