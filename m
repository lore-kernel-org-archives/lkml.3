Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaLAUoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:44:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbaLAUoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:44:06 -0500
Subject: Re: POSIX mutex destruction requirements vs. futexes
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
In-Reply-To: <CA+55aFxiPbr9CJt_+G03zzYvkrr0ENNHFKNU08AjZh-j=PzUig@mail.gmail.com>
References: <1417098455.1771.338.camel@triegel.csb>
	 <CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
	 <1417435546.1771.400.camel@triegel.csb>
	 <CA+55aFxiPbr9CJt_+G03zzYvkrr0ENNHFKNU08AjZh-j=PzUig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Dec 2014 21:44:00 +0100
Message-ID: <1417466640.1771.576.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 10:31 -0800, Linus Torvalds wrote:
> On Mon, Dec 1, 2014 at 4:05 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Thu, 2014-11-27 at 11:38 -0800, Linus Torvalds wrote:
> >>
> >> > (1)  Allow spurious wake-ups from FUTEX_WAIT.
> >>
> >> because afaik that is what we actually *do* today (we'll wake up
> >> whoever re-used that location in another thread), and it's mainly
> >> about the whole documentation issue. No?
> >
> > If that's what the kernel prefers to do, this would be fine with me.
> 
> I think it's more of a "can we even do anything else"?
> 
> The kernel doesn't even see the reuse of the futex, or the fast path
> parts. Not seeing the fast path is obviously by design, and not seeing
> the reuse is partly due to pthreads interfaces (I guess people should
> generally call mutex_destroy, but I doubt people really do, and even
> if they did, how would user space actually handle the nasty race
> between "pthread_unlock -> stale futex_wake" "pthread_mutex_destroy()"
> anyway?).

User space could count stale (or, pending) futex_wake calls and spin in
pthread_mutex_destroy() until this count is zero.  However, that would
increase contention significantly, and we must spin, not block in
pthread_mutex_destroy() at least for process-shared mutexes, because
there's no place to put a futex for this destruction-time blocking that
is not subject to the same issue again.  (For process-private futexes,
this could be a memory location that is only ever used by glibc.)
There might even be more issues related to unmapping memory of
process-shared mutexes based on reference-counting in the critical
sections.

The additional contention of counting stale futex_wake's worries me
most.  You only need to count when threads actually use futexes to
block, and perhaps glibc's mutex implementation could be changed to
spin-wait aggressively, and perhaps we could add some explicit handover
to other lock owners or something similar to avoid issuing a futex_wake
unless really necessary -- but this seems like quite a lot of hoops to
jump through to work around a relatively small aspect of the current
futexes.

> So the thing is, I don't see how we could possibly change the existing
> FUTEX_WAKE behavior.
> 
> And introducing a new "debug mode" that explicitly adds spurious
> events might as well be done in user space with a wrapper about
> FUTEX_WAKE or something.

User space could introduce a wrapper (e.g., glibc could provide a futex
wrapper that allows spurious wakeup on return of 0) -- but glibc can't
prevent users from not using futexes directly and not through the
wrapper.  Or should it try to intercept direct, non-wrapper uses of the
futex syscall in some way?

That's why I included a "debug mode" -- I'd rather call it a "new" mode
than a debug mode, because it's not really about debugging -- in the
list of options (ie, options (2) and (3)).  This would allow glibc (and
other libraries) to use the futex variants with the new semantics in the
most natural way.  And yet would not create situations in which calls to
the old futex variant *appear* to allow spurious wake-ups (due to
glibc's or other libraries' fault -- libstdc++ is in the same boat, for
example).

> Because as far as the *kernel* is concerned, there is no "spurious
> wake" event.  It's not spurious. It's real and exists, and the wakeup
> was really done by the user. The fact that it's really a stale wakeup
> for a previous allocation of a pthread mutex data structure is
> something that is completely and fundamentally invisible to the
> kernel.
> 
> No?

I agree, and that's why I mentioned that it may seem odd to fix this on
the level of the kernel interface.  However, it just seems the best
approach when considering practice in kernel and user space, the
by-design futex properties, and the realities of what POSIX requires.

> So even from a documentation standpoint, it's really not about "kernel
> interfaces" being incorrectly documented, as about a big honking
> warning about internal pthread_mutex() implementation in a library,
> and the impact that library choice has on allocation re-use, and how
> that means that even if the FUTEX_WAKE is guaranteed to not be
> spurious from a *kernel* standpoint, certain use models will create
> their own spurious wake events in very subtle ways.

I agree it's not the kernel's fault, but that doesn't solve the dilemma.
It's one aspect of the futex design -- whether spurious wake-ups are
allowed for a return of 0 -- that makes it hard to use futexes for
POSIX, C++11 (and C11, most likely) synchronization primitives without
user space violating the kernel interface's semantics.  In an ideal
world, we'd have considered that right away when designing futexes, made
a decision that works well for both the kernel and user space, and
specified the return conditions accordingly.  IMO, allowing spurious
wake-ups doesn't actually make using futexes any harder, so allowing
them from the start would have been fine.

If somebody has any suggestions for how to fix this in user space, with
no or at least an acceptable performance hit, and in a way that works
with process-shared POSIX mutexes, I'm all ears.  I don't see a good
user space solutions in the sense of being more efficient and more
effective than a kernel-side solution, so this is why I think options
(2) and (3) might be good.  They would give us the futex design that
works best for POSIX etc. and yet would never affect old programs using
futexes directly because they would use the old-style semantics.

If options (2) and (3) are not acceptable to the kernel community and if
we find don't find other solutions, then I'd like to at least document
the issue in the kernel man pages (making sure pointing out that this is
caused by user space realities).

Thoughts?

