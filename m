Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab3BMQVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:21:06 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44655 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:21:03 -0500
MIME-Version: 1.0
In-Reply-To: <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 08:20:42 -0800
X-Google-Sender-Auth: vlVAJzS8KEycH5IRs5m_j_Sp5zU
Message-ID: <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 4:06 AM, tip-bot for Rik van Riel
<riel@redhat.com> wrote:
>
> x86/smp: Move waiting on contended ticket lock out of line
>
> Moving the wait loop for congested loops to its own function
> allows us to add things to that wait loop, without growing the
> size of the kernel text appreciably.

Did anybody actually look at the code generation of this?

Adding an external function call is *horrible*, and you might almost
as well just uninline the spinlock entirely if you do this. It means
that all the small callers now have their registers trashed, whether
the unlikely function call is taken or not, and now leaf functions
aren't leaves any more.

Guys, the biggest cost of a function call is not the "call"
instruction, it's all the crap around it - trashed registers causing
us to have to have a stack frame in the caller when none was required
otherwise, fixed register allocation by the arguments/return value etc
etc. So having inline functions that then call another function means
that the inline is almost entirely pointless (unless it was just to
set up default arguments or something).

The call is likely also about the same size as the code in the wait
loop. And the excuse is "so that we can add stuff to the wait loop".
What the f*ck? There's nothing to do in the wait-loop, and if you want
debugging or statistis or something, the spinlock should have been
out-of-line.

This is apparently for the auto-tuning, which came with absolutely no
performance numbers (except for the *regressions* it caused), and
which is something we have actively *avoided* in the past, because
back-off is a f*cking idiotic thing, and the only real fix for
contended spinlocks is to try to avoid the contention and fix the
caller to do something smarter to begin with.

In other words, the whole f*cking thing looks incredibly broken. At
least give some good explanations for why crap like this is needed,
instead of just implementing backoff without even numbers for real
loads. And no, don't bother to give numbers for pointless benchmarks.
It's easy to get contention on a benchmark, but spinlock backoff is
only remotely interesting on real loads.

                      Linus
