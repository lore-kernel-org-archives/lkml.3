Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3DHEsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:48:24 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52378 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3DHEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <51624591.4010303@synopsys.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>
	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	<51624591.4010303@synopsys.com>
Date: Sun, 7 Apr 2013 21:48:21 -0700
X-Google-Sender-Auth: A6nRfOfHRGRdoXAznQ2tWIQDB20
Message-ID: <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 9:20 PM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
> Christian had already proposed that change - only I was reluctant to take it - as
> local_irq_* is used heavily in a configuration of ARC700 linux where (!SMP) cpu
> doesn't support load-locked/store-conditional instructions - hence atomic R-M-W
> sequences need those routines. Adding a mem clobber would lead to pathetic
> generated code hence the reason it was likely removed by me at some point in time.

Umm. The irq instructions absolutely *HAVE* to have the barriers. And
yes, the R-M-W instructions (if they are protected by them) obviously
need to have the load and the store inside the spinlocked region.

> Also I'd thought that given that barriers are already present in PREEMPT_COUNT
> variant of preempt_* macros we might as well add them to !PREEMPT_COUNT ones.

That's absolutely insane. It's insane for two reasons:

 - it's not SUFFICIENT. Any user of irq-safety needs the loads and
stores to stay inside the irq-safe region, and the preempt macros have
absolutely nothing to do with that.

 - it's POINTLESS and WRONG. If you run on UP, and have preemption
disabled, then there is no reason for a barrier in the preempt code,
since moving code around them doesn't matter - nothing is ever going
to preempt that.

The thing is, the irq disable/enable sequence absolutely has to have a
memory barrier in it, because if the compiler moves a load outside of
the irq-protected region, then that is a bug. Now, if you want to play
games with your atomics and do them with handcoded asm, go right
ahead, but that really isn't an argument for getting everything else
wrong.

That said, thinking about barriers and preemption made me realize that
we do have a potential issue between: (a) non-preemption UP kernel
(with no barriers in the preempt_enable/disable()) and (b)
architectures that use inline asm without a memory clobber for
get_user/put_user(). That includes x86.

The reason is that I could imagine code like

    if (get_user(val, addr))
        return -EFAULT;
    preempt_disable();
    ... do something percpu ..
    preempt_enable();

and it turns out that for non-preempt UP, we don't tell the compiler
anywhere that it can't move the get_user past the preempt_disable. But
the get_user() can cause a preemption point because of a page fault,
obviously.

I suspect that the best way to fix this ends up relying on the gcc
"asm volatile" rules, and make the rule be that:
 - preempt_disable/enable have to generate an asm volatile() string
(preferably just a ASM comment saying "preempt disable/enable")
 - get_user/put_user doesn't need to add a memory clobber, but needs
to be done with an asm volatile too.

Then the gcc "no reordering of volatile asms" should make the above be
ok, without having to add an actual compiler memory barrier.

Ingo? Peter? I'm not sure anybody really uses UP+no-preempt on x86,
but it does seem to be a bug.. Comments?

But the irq disable/enable sequences definitely need the memory
clobber. Because caching memory that could be changed by an interrupt
in registers is not good.

                    Linus
