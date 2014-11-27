Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaK0TiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:38:13 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39822 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK0TiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:38:12 -0500
MIME-Version: 1.0
In-Reply-To: <1417098455.1771.338.camel@triegel.csb>
References: <1417098455.1771.338.camel@triegel.csb>
Date: Thu, 27 Nov 2014 11:38:11 -0800
X-Google-Sender-Auth: 9uTzULTSyeUl9Es0RzNOpOkdhxs
Message-ID: <CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
Subject: Re: POSIX mutex destruction requirements vs. futexes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 6:27 AM, Torvald Riegel <triegel@redhat.com> wrote:
>
> Using reference-counting in critical sections to decide when the mutex
> protecting the critical section can be destroyed has been recently
> discussed on LKML.   For example, something like this is supposed to
> work:
>
> int free = 0;
>
>     mutex_lock(&s->lock);
>     if (--s->refcount == 0)
>         free = 1
>     mutex_unlock(&s->lock);
>     if (free)
>         kfree(s);

Yeah, this is a nasty case. We've had this bug in the kernel, and only
allow self-locking data structures with spinlocks (in which the unlock
operation is guaranteed to release the lock and never touch the data
structure afterwards in any way - no "unlock fastpath followed by
still touching it").


> This requirement is tough to implement for glibc -- or with futexes in
> general -- because what one would like to do in a mutex unlock
> implementation based on futexes is the following, roughly:
>
> lock():
>   while (1) {
>     // fast path: assume uncontended lock
>     if (atomic_compare_exchange_acquire(&futex, NOT_ACQUIRED, ACQUIRED)
>         == SUCCESS)
>       return;
>     // slow path: signal that there is a slow-path waiter and block
>     prev = atomic_exchange(&futex, ACQUIRED_AND_WAITERS);
>     if (prev == NOT_ACQUIRED) return;
>     futex_wait(&futex, ACQUIRED_AND_WAITERS, ...);
>   }
>
> unlock():
>   // fast path unlock
>   prev = atomic_exchange_release(&futex, NOT_ACQUIRED);
>   // slow path unlock
>   if (prev == ACQUIRED_AND_WAITERS)
>     futex_wake(&futex, ...);

Yup.

> This means that in the second example above, futex_wake can be
> concurrent with whatever happens on the mutex' memory location after the
> mutex has been destroyed.  Examples are:
>       * The memory is unmapped.  futex_wake will return an error.  OK.
>       * The memory is reused, but not for a futex.  No thread will get
>         woken.  OK.
>       * The memory is reused for another glibc mutex.  The slow-path
>         futex wake will now hit another, unrelated futex -- but the
>         mutex implementation is robust to such spurious wake-ups anyway,
>         because it can always happen when a mutex is acquired and
>         released more than once.  OK.
>       * The memory is reused for another futex in some custom data
>         structure that expects there is just one wait/wake cycle, and
>         relies on  FUTEX_WAIT returning 0 to mean that this is caused by
>         the matching FUTEX_WAKE call by *this* data structure.  Not OK,
>         because now the delayed slow-path wake-up introduces a spurious
>         wake-up in an unrelated futex.
>
> Thus, introducing spurious wake-ups is the core issue.

So my gut feeling is that we should just try to see if we can live
with spurious wakeups, ie your:

> (1)  Allow spurious wake-ups from FUTEX_WAIT.

because afaik that is what we actually *do* today (we'll wake up
whoever re-used that location in another thread), and it's mainly
about the whole documentation issue. No?

                      Linus
