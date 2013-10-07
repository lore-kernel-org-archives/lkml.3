Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3JGWOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:14:50 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60472 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGWOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131007083505.GA22585@localhost>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
Date: Mon, 7 Oct 2013 15:14:48 -0700
X-Google-Sender-Auth: R190TA1c0nMzehssCmizx_TIa-8
Message-ID: <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 1:35 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Mon, Oct 07, 2013 at 01:12:17AM -0700, Linus Torvalds wrote:
>
> My pleasure! Here are 100 randomly selected call traces. Also attached
> several full dmesgs and the kconfig.

Ok, they may be randomly selected, but they are all the same. Which is
good, I guess, we're only talking about one bug.

Anyway, they all have RIP:run_timer_softirq+0x12c/0x1b8, and the code is

   0: 8b 65 c8             mov    -0x38(%rbp),%esp
   3: 4d 39 ec             cmp    %r13,%r12
   6: 0f 84 2f ff ff ff     je     0xffffffffffffff3b
   c: 41 8b 4c 24 18       mov    0x18(%r12),%ecx
  11: 4d 8b 74 24 20       mov    0x20(%r12),%r14
  16: 4d 8b 7c 24 28       mov    0x28(%r12),%r15
  1b: 4c 89 63 38           mov    %r12,0x38(%rbx)
  1f: 49 8b 44 24 08       mov    0x8(%r12),%rax
  24: 49 8b 14 24           mov    (%r12),%rdx
  28: 83 e1 02             and    $0x2,%ecx
  2b:* 48 89 42 08           mov    %rax,0x8(%rdx) <-- trapping instruction
  2f: 48 89 10             mov    %rdx,(%rax)
  32: 48 b8 00 02 20 00 00 movabs $0xdead000000200200,%rax

where that constant is LIST_POISON2 and the "and $2" seems to be
TIMER_IRQSAFE. So the trapping instruction *looks* like it's doing
__list_del() on the timer, and timer->next is NULL.

So somebody added a timer, and then deallocated/cleared the structure
before it triggered. The problem is, I can't see a way to figure out
_who_ did that.

I *think* r14 contains the function we're going to jump to in the
oops, and that could be interesting to know, but it's not decoded, so
you'd have to match it up against a symbol map...

                        Linus
