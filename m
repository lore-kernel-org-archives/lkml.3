Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaK0O1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:27:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaK0O1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:27:41 -0500
Subject: POSIX mutex destruction requirements vs. futexes
From: Torvald Riegel <triegel@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Nov 2014 15:27:35 +0100
Message-ID: <1417098455.1771.338.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TLDR: POSIX and C++11 make implementation requirements for the
destruction of mutexes that, if we want to continue to use the userspace
fastpath / kernel slowpath approach of non-PI futexes, conflict with
spurious wake-ups not being allowed for FUTEX_WAIT calls that return 0.
The best solutions seem to be to either allow spurious wake-ups, or
create new variants of FUTEX_WAIT and/or FUTEX_WAKE that allow spurious
wake-ups.


Using reference-counting in critical sections to decide when the mutex
protecting the critical section can be destroyed has been recently
discussed on LKML.   For example, something like this is supposed to
work:

int free = 0;

    mutex_lock(&s->lock);
    if (--s->refcount == 0)
        free = 1
    mutex_unlock(&s->lock);
    if (free)
	kfree(s);

The Austin Group has clarified that pthreads mutexes have to support
such uses:
http://austingroupbugs.net/view.php?id=811
C++11 makes essentially the same requirement (see 30.4.1.2.1p5;
destruction is allowed if no thread owns the mutex; it is not required
that all unlock calls have returned before destruction starts).
C11 is silent on this particular aspect of mutex semantics, but it
usually follows POSIX and/or C++ semantics.

The destruction requirement doesn't just apply in cases of explicit
reference counting.  Another example would be:

Thread1:
  pthread_mutex_lock(&m);
  pthread_create(..., Thread2, ...);
  pthread_mutex_unlock(&m);

Thread2:
  pthread_mutex_lock(&m);
  pthread_mutex_unlock(&m);
  pthread_mutex_destroy(&m);
  // reuse the memory of mutex m for something else;
  // a new, unrelated futex happens to reside at the same address as
  // m's internal futex

Here, the program has ensured in a different way that no thread owns the
mutex when it is destructed.

This requirement is tough to implement for glibc -- or with futexes in
general -- because what one would like to do in a mutex unlock
implementation based on futexes is the following, roughly:

lock():
  while (1) {
    // fast path: assume uncontended lock
    if (atomic_compare_exchange_acquire(&futex, NOT_ACQUIRED, ACQUIRED)
        == SUCCESS)
      return;
    // slow path: signal that there is a slow-path waiter and block
    prev = atomic_exchange(&futex, ACQUIRED_AND_WAITERS);
    if (prev == NOT_ACQUIRED) return;
    futex_wait(&futex, ACQUIRED_AND_WAITERS, ...);
  }

unlock():
  // fast path unlock
  prev = atomic_exchange_release(&futex, NOT_ACQUIRED);
  // slow path unlock
  if (prev == ACQUIRED_AND_WAITERS)
    futex_wake(&futex, ...);

Having the fast path is good for performance.  It enables spinning on
acquisition, and avoids a syscall when releasing the mutex.  The latter
is good in the uncontended case but also when there is contention,
because another spinning thread may be able to acquire the mutex more
quickly than if we'd require the kernel to wake a blocked thread -- thus
increasing scalability.

However, because another thread can acquire the mutex right after the
fast path of the unlock(), the next steps of this thread can then be
concurrent with the slow path of the unlock(), in particular the
futex_wake call.  All we need to make such a pending, concurrent
futex_wake call possible is that at some time in the past, we were in
the ACQUIRED_AND_WAITERS state.

This means that in the second example above, futex_wake can be
concurrent with whatever happens on the mutex' memory location after the
mutex has been destroyed.  Examples are:
      * The memory is unmapped.  futex_wake will return an error.  OK.
      * The memory is reused, but not for a futex.  No thread will get
        woken.  OK.
      * The memory is reused for another glibc mutex.  The slow-path
        futex wake will now hit another, unrelated futex -- but the
        mutex implementation is robust to such spurious wake-ups anyway,
        because it can always happen when a mutex is acquired and
        released more than once.  OK.
      * The memory is reused for another futex in some custom data
        structure that expects there is just one wait/wake cycle, and
        relies on  FUTEX_WAIT returning 0 to mean that this is caused by
        the matching FUTEX_WAKE call by *this* data structure.  Not OK,
        because now the delayed slow-path wake-up introduces a spurious
        wake-up in an unrelated futex.

Thus, introducing spurious wake-ups is the core issue.  This is not
restricted to pthreads mutexes
(https://sourceware.org/bugzilla/show_bug.cgi?id=13690) but also is an
issue for semaphores
(https://sourceware.org/bugzilla/show_bug.cgi?id=12674; I have a patch
that I'll send upstream soon that fixes the memory access issues under
concurrent destruction -- the futex issue remains) and barriers
(https://sourceware.org/bugzilla/show_bug.cgi?id=13065).
In general, this is an issue for all futex uses that rely on this same
fast-path / slow-path pattern and a similar destruction scheme.


There are ways to solve this in userspace only and with the existing
futex operations, but they all have disadvantages:
      * Using truly deferred memory reclamation schemes such as hazard
        pointers or RCU is probably impossible to implement for
        process-shared pthreads mutexes.
      * Mutexes could count pending slow-path futex_wake calls, but this
        increases contention on the mutex.  Also, mutex destruction
        would have to wait for these to finish.  We either need to do
        this with spin-waiting, which isn't ideal in terms of avoiding
        pathological performance cases; we could use a futex in stable
        storage but, again, this doesn't work for process-shared
        mutexes.
      * For non-process-shared mutexes, glibc could use per-thread
        futexes in stable storage or such (e.g., with something like an
        MCS lock).
      * (Ab)use PI futexes to solve the destruction problem.
        FUTEX_UNLOCK_PI does the whole mutex release in the kernel, so
        we avoid the split fast-path/slow-path problem.  However, mutex
        release latency (best case, perhaps common case depending on the
        length of the critical section and contention, etc.) will be
        higher.

(For more details on these options, see the glibc discussion thread of
this topic: https://sourceware.org/ml/libc-alpha/2014-04/msg00075.html)


It seems far better to just allow spurious wake-ups from FUTEX_WAIT.  I
can imagine a few options:

(1)  Allow spurious wake-ups from FUTEX_WAIT.

If we'd start from scratch, we could just specify that if FUTEX_WAIT
returns 0, this might be due to a spurious wake-up as well.  I cannot
think of any use case that might be significantly harder to implement
with such a specification.  Also, I would guess that effects on
performance are slow; after all; a racing, pending FUTEX_WAKE should be
rare (eg, it needs memory reuse at the exact same address, a thread
being suspended right between the fast and slow path of unlock, ...).

However, this is a change to the futex specs, if we were to make this
change now. I'm aware that you don't want to break userspace (and that's
a good thing IMO :), so I'm mentioning this option for completeness and
to some extent because there are reasons that make actually breaking
userspace in practice potentially unlikely:
      * FUTEX_WAIT can return EINTR, so calls of it need to be in a loop
        anyway.
      * All uses of futexes that are not one-shot mechanisms (ie, just
        one FUTEX_WAIT and FUTEX_WAKE for a particular futex instance)
        have to be robust to spurious wake-ups anyway, even if
        FUTEX_WAIT returns 0.
      * The current futex documentation (ie, before the additions by
        Ingo and Darren) is incomplete, so users may have followed
        existing practice anyway (e.g., glibc code and Ulrich's paper),
        which do handle spurious wake-ups.  OTOH, this may not be
        necessary, and the current incomplete docs don't allow for
        spurious wake-up.


(2) New FUTEX_WAKE_SPURIOUS operation that just emits spurious wakeups

The kernel could provide a new futex wake operation that enforces that
all FUTEX_WAIT calls it wakes return with EINTR.  EINTR is allowed by
the current futex documentation, so no change to the specs.
Callers such as glibc would then use this new futex op and make sure
that *their own* futexes interpret EINTR returns from FUTEX_WAIT as
caused by potentially both spurious and nonspurious wake-ups.  In
practice, that would require no or just a few changes on the FUTEX_WAIT
side, because rechecking the condition after EINTR is the natural thing
to do.


(3) New FUTEX_WAKE_SPURIOUS and FUTEX_WAIT_SPURIOUS operations

In this approach, FUTEX_WAKE_SPURIOUS would only wake
FUTEX_WAIT_SPURIOUS calls (and the latter including spurious wake-ups on
return of 0).  This separates new from old semantics; it's in some sense
similar to (2), except that there's an explicit "opt-in" for spurious
wake-ups on both sides.


There's practically nothing we can really do to change the mutex
destruction semantics specified by POSIX and C++11 (and that C11 likely
intended).  Therefore, I think we need to support this in
implementations.

I'm looking for feedback from the kernel community on the following
points:
      * Is this issue best solved on the kernel side?  If not, what else
        would you like to see before agreeing to that?
      * Is allowing spurious wake-ups in some way the best way to solve
        this?  If not, do you have other suggestions?
      * If we allow spurious wakeu-ps, which of (1), (2), or (3) is best
        in your opinion?  Or other suggestions?

Please CC me in replies because I'm not subscribed to LKML.


Thanks,

Torvald


PS: I'm aware that glibc is currently still a little sloppy when
checking return values from futex operations; this is work-in-progress
on the glibc side:
https://sourceware.org/ml/libc-alpha/2014-09/msg00381.html

