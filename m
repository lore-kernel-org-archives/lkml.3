Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaLAMFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaLAMFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:05:54 -0500
Subject: Re: POSIX mutex destruction requirements vs. futexes
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
In-Reply-To: <CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
References: <1417098455.1771.338.camel@triegel.csb>
	 <CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Dec 2014 13:05:46 +0100
Message-ID: <1417435546.1771.400.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 11:38 -0800, Linus Torvalds wrote:
> On Thu, Nov 27, 2014 at 6:27 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > This means that in the second example above, futex_wake can be
> > concurrent with whatever happens on the mutex' memory location after the
> > mutex has been destroyed.  Examples are:
> >       * The memory is unmapped.  futex_wake will return an error.  OK.
> >       * The memory is reused, but not for a futex.  No thread will get
> >         woken.  OK.
> >       * The memory is reused for another glibc mutex.  The slow-path
> >         futex wake will now hit another, unrelated futex -- but the
> >         mutex implementation is robust to such spurious wake-ups anyway,
> >         because it can always happen when a mutex is acquired and
> >         released more than once.  OK.
> >       * The memory is reused for another futex in some custom data
> >         structure that expects there is just one wait/wake cycle, and
> >         relies on  FUTEX_WAIT returning 0 to mean that this is caused by
> >         the matching FUTEX_WAKE call by *this* data structure.  Not OK,
> >         because now the delayed slow-path wake-up introduces a spurious
> >         wake-up in an unrelated futex.
> >
> > Thus, introducing spurious wake-ups is the core issue.
> 
> So my gut feeling is that we should just try to see if we can live
> with spurious wakeups, ie your:
> 
> > (1)  Allow spurious wake-ups from FUTEX_WAIT.
> 
> because afaik that is what we actually *do* today (we'll wake up
> whoever re-used that location in another thread), and it's mainly
> about the whole documentation issue. No?

If that's what the kernel prefers to do, this would be fine with me.  In
this case, I'd follow up with Michael Kerrisk to get this documented.  I
guess something along the lines of this would work:
  "Return 0 if the process was woken by a FUTEX_WAKE call, or
  spuriously.
  (Note that these spurious wake-ups can result from futex operations by
  other threads or processes.)"
A more detailed explanation outside of the manpages (ie, the rationale
for this wording) would also be useful for users I suppose.

However, I've heard others being more concerned over this change in
semantics.  Therefore, I'll describe the pros/cons that I see, just so
that we're all on the same page on what the decision for (1) would mean.

The change in return-value-of-0 semantics that (1) is about can violate
the futex semantics that existing code like the following example might
assume:

Initially f==0

Thread 1:
  atomic_store_relaxed(&f, 1);
  futex_wake(&f, 1, ...);

Thread 2:
  do {
    err = futex_wait(&f, 0, NULL);
    // handle fatal errors like ENOSYS, EINVAL, ...
  } while (err == EINTR);
  // err must have been EWOULDBLOCK or 0

For this to work according to the specs, the program itself must not
have pending FUTEX_WAKE's to f (e.g., by having a barrier after the
operations by both threads).  The program can use glibc pthreads
synchronization operations, because they don't specify anywhere that
they cause concurrent FUTEX_WAKE's after the synchronization data
structures have been destroyed and their memory has been reused.

For this to work in practice, the program would need to not use
reference-counting to trigger destruction of pthread synchronization
datastructures (or do something similar that causes an mutex unlock that
has not returned to the caller to be concurrent with destruction).

Thus, there can be correct programs out there that never are affected by
spurious wake-ups, but now would have to change if they want to be
correct after the change in documentation.  I would bet that those cases
are the minority, but I don't have any data to back this up or even make
a guess about how small a minority they would be.

OTOH, in practice, they would *not* become buggy after the documentation
change, *unless* the kernel should decide to, in the future, also
introduce spurious wake-ups due to other reasons and return 0 instead of
EINTR.  (That's why I put the note in the suggested docs change above.)

One could also argue that the current spec actually allows the spurious
wake-ups we are concerned with.  The manpage currently states:
  "Returns 0 if the process was woken by a FUTEX_WAKE call."
The spurious wake-ups *are* due to other FUTEX_WAKE calls, just not due
to the calls that the piece of code assumed they might come from.  But
that's probably not quite obvious :)

It also seems a little odd that consequences of the design of how
futexes are used in practice (ie, fast/slow path split) and the POSIX/C
++11 requirements on destruction bleed into the semantics of kernel
operations.  However, allowing spurious wake-ups for a return value of 0
might be the simplest way to describe how a futex can be used safely;
this would be *easier* for programmers than giving them all the details
on pending futexes etc.
So maybe we could also change the futex specs like this (or similar):
  "Return 0 if the process was woken by a FUTEX_WAKE call.
  Note that typical uses of futexes elsewhere in the process (e.g., by
  other threads or in libraries) can lead to spurious wake-ups of
  FUTEX_WAIT operations that return 0.  Therefore, callers should assume
  that spurious wake-ups can happen, unless they have control over all
  uses of futexes in the process and other processes that have access to
  the futex."


So, if you continue to prefer option (1), I think that's what we should
do.  Also, in this case I'd like some feedback on the direction of the
documentation change, in particular whether
* We should explicitly allow spurious wake-ups for return value of 0 or
just add weasel-wording that spurious wake-ups may happen due to other
futex uses in the process or other processes that have access to the
futex variable.
* If we allow spurious wake-ups, whether this should still include a
promise that the kernel itself will not add spurious wake-ups (so that
programs that work today will continue to work in the future (see
example above)).

Thanks,

Torvald

