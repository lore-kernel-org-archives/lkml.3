Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab3BMWrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:47:47 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:46940 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3BMWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <511C1204.9040608@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
 <511C1204.9040608@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 14:40:13 -0800
X-Google-Sender-Auth: 2KxhK0UG4H3DMGydClLHknaSvLk
Message-ID: <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 2:21 PM, Rik van Riel <riel@redhat.com> wrote:
>
> What kind of numbers would you like?
>
> Numbers showing that the common case is not affected by this
> code?
>
> Or numbers showing that performance of something is improved
> with this code?
>
> Of course, the latter would point out a scalability issue,
> that may be fixable by changing the data structures and code
> involved :)

Yes.

To all three.

> If we have just a few CPUs bouncing the cache line around, we
> have no real performance issues and the loop with cpu_relax
> seems to be doing fine.
>
> Real issues arise when we have a larger number of CPUs contending
> on the same lock. At that point we know we are no longer bouncing
> between sibling cores.

Again. Exactly my point.

So you're potentially making things worse for just about everybody, in
order to fix a problem that almost nobody can actually see. And
apparently you don't even know the problem.

> This patch series is not as much for the spinlocks we know about
> (we can probably fix those), but to prevent catastrophic
> performance degradation when users run into contention on spinlocks
> we do NOT know about.

.. and as I already explained, THAT IS PURE AND UTTER BULLSHIT.

It may make things WORSE. On all the things you haven't run to check
that it does better.

You just stated something that is not at all necessarily true. You
changed the spinlock behavior, and then you blindly state that it will
"fix" things on loads you haven't even tested.

That's pure bullshit.

For all we know, it goes exactly the other way around, and makes some
unknown load perform much much worse, because it turns something that
didn't *use* to be contended into a contended case, because the
spinlock is slower on some piece of hardware (or under
virtualization).

We already saw one virtual load regress quite noticeably, didn't we?

And yet you go on to say that it will fix performance problems THAT WE
DON'T EVEN KNOW ABOUT! After seeing *proof* to the exact contrary
behavior! What f*cking planet are you from, again?

Christ, that's hubris.

Besides, out-of-line spinlock loops are *horrible* for performance
monitoring. One of the *best* things about inlining the spinlock
looping code is that it's so very obvious where a hot lock is used. It
shows up as a shining beacon in profiles, without any need for
callchains etc. So not only don't we know what loads it would improve,
but those unknown loads would also be much harder to figure out.

(And yes, this is a real problem - look at every time we have a
problem with scaling sleeping locks, and how all the time just ends up
being random scheduler time, with the actual lock being very hard to
see. Spinlocks are *easy* partly because they can be inlined)

Seriously. I'm going to NAK these kinds of changes unless you can
actually show real improvement on real loads. No more of this "in
theory this will fix all our problems" crap.

             Linus
