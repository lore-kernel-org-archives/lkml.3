Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab3BNQLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:11:10 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:62501 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934736Ab3BNQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130214105027.GB25282@gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com> <20130214105027.GB25282@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Feb 2013 08:10:44 -0800
X-Google-Sender-Auth: BsH84Mb1wN6lo5Cbltufs-ZoVRw
Message-ID: <CA+55aFxxt4Qu=kSGCuvqh+veotL7P=14mHiFTUUNgkh3UwRiDQ@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 2:50 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> At least on x86, how about saving *all* volatile registers in
> the slow out of line code path (to stack)?

Sure. The reason I suggested perhaps not saving %rax/%rdx is simply
that if it's a function that returns a value, %rax obviously cannot be
saved anyway. And then I was confused about the calling convention,
and said %rx because it's the second argument register, but that's
only true on x86-32 (with our regparm calling convention). On x86-64,
it's %rdi/%rsi that have arguments.

Anyway, argument registers *can* be useful to save, but are often
computed, so it can go either way.

> It blows up the slow path somewhat, but it would allow us to
> keep the fast-path register impact even smaller - as the slow
> path would only have memory content side effects.
>
> Am I missing something?

The best option would be to just let the user say which registers it
wants saved for any particular function. We'd probably want some
default set so that people who call "unlikely()" functions can just
pick that one, but for architecture-specific helper functions for
locking etc, we would probably want to optimize it for usage (ie "is
the argument likely to be useful to the caller after the call").

Sometimes saving everything is the right thing to do, sometimes it
might just be extra work.

And even *if* the callee saves everything, the caller still ends up
being constrained by the calling convention (ie fixed registers for
arguments), so it could mess up code generation in the caller for that
reason. But at least it would be much less painful.

Btw, it may end up that almost nobody cares. Modern CPU's are really
good at handling the straightforward "save/restore to stack"
instructions. One of the reasons I care is not performance per se,
butu the fact that I still look at asm code every time I do any
performance profiling, and it's absolutely horrible to see the code
when you see "ugh, that's pointless". I'm sensitive to the spinlocks
in particular, because we've gone back and forth on inlining them
before, so I've seen this. But right now I don't think we inline the
lock under normal configs *anyway*, so I guess it doesn't much matter.

                            Linus
