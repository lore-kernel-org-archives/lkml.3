Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3BMTga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:36:30 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:56529 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3BMTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <511BE4A3.8050607@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <511BE4A3.8050607@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 11:36:07 -0800
X-Google-Sender-Auth: NE2n5NnSRiSX_Kh-Kc3z3zSWCCo
Message-ID: <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
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

On Wed, Feb 13, 2013 at 11:08 AM, Rik van Riel <riel@redhat.com> wrote:
>
> The spinlock backoff code prevents these last cases from
> experiencing large performance regressions when the hardware
> is upgraded.

I still want *numbers*.

There are real cases where backoff does exactly the reverse, and makes
things much much worse. The tuning of the backoff delays are often
*very* hardware sensitive, and upgrading hardware can turn out to do
exactly what you say - but for the backoff, not the regular spinning
code.

And we have hardware that actually autodetects some cacheline bouncing
patterns and may actually do a better job than software. It's *hard*
for software to know whether it's bouncing within the L1 cache between
threads, or across fabric in a large machine.

> As a car analogy, think of this not as an accelerator, but
> as an airbag. Spinlock backoff (or other scalable locking
> code) exists to keep things from going horribly wrong when
> we hit a scalability wall.
>
> Does that make more sense?

Not without tons of numbers from many different platforms, it doesn't.
And not without explaining which spinlock it is that is so contended
in the first place.

We've been very good at fixing spinlock contention. Now, that does
mean that what is likely left isn't exactly low-hanging fruit, but it
also means that the circumstances where it triggers are probably quite
uncommon.

So I claim:

 - it's *really* hard to trigger in real loads on common hardware.

 - if it does trigger in any half-way reasonably common setup
(hardware/software), we most likely should work really hard at fixing
the underlying problem, not the symptoms.

 - we absolutely should *not* pessimize the common case for this

So I suspect contention is something that you *may* need on some
particular platforms ("Oh, I have 64 sockets adn 1024 threads, I can
trigger contention easily"), but that tends to be unusual, and any
back-off code should be damn aware of the fact that it only helps the
0.01%.

Hurting the 99.99% even a tiny amount should be something we should
never ever do. This is why I think the fast case is so important (and
I had another email about possibly making it acceptable), but I think
the *slow* case should be looked at a lot too. Because "back-off" is
absolutely *not* necessarily hugely better than plain spinning, and it
needs numbers. How many times do you spin before even looking at
back-off? How much do you back off? How do you account for hardware
that notices busy loops and turns them into effectively just mwait?

Btw, the "notice busy loops and turn it into mwait" is not some
theoretical magic thing. And it's exactly the kind of thing that
back-off *breaks* by making the loop too complex for hardware to
understand. Even just adding counters with conditionals that are *not*
about just he value loaded from memory suddently means that hardware
has a lot harder time doing things like that.

And "notice busy loops and turn it into mwait" is actually a big deal
for power use of a CPU. Back-off with busy-looping timing waits can be
an absolutely *horrible* thing for power use.  So we have bigger
issues than just performance, there's complex CPU power behavior too.
Being "smart" can often be really really hard.

I don't know if you perhaps had some future plans of looking at using
mwait in the backoff code itself, but the patch I did see looked like
it might be absolutely horrible. How long does a "cpu_relax()" wait?
Do you know? How does "cpu_relax()" interface with the rest of the
CPU? Do you know? Because I've heard noises about cpu_relax() actually
affecting the memory pipe behavior of cache accesses of the CPU, and
thus the "cpu_relax()" in a busy loop that does *not* look at the
value (your "backoff delay loop") may actually work very very
differently from the cpu_relax() in the actual "wait for the value to
change" loop.

And how does that account for two different microarchitectures doing
totally different things? Maybe one uarch makes cpu_relax() just shut
down the front-end for a while, while another does something much
fancier and gives hints to in-flight memory accesses etc?

When do you start doing mwait vs just busy-looping with cpu_relax? How
do you tune it to do the right thing for different architectures?

So I think this is complex. At many different levels. And it's *all*
about the details. No handwaving about how "back-off is like a air
bag". Because the big picture is entirely and totally irrelevant, when
the details are almost all that actually matter.

               Linus
