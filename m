Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3GNSfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 14:35:23 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:40617 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3GNSfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 14:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
Date: Sun, 14 Jul 2013 18:35:20 +0000
Message-ID: <CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
From: Tim Northover <t.p.northover@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The issue perhaps wasn't explained ideally (and possibly shouldn't
have been CCed directly to you either, so apologies, but now that
there *is* a discussion...)

> Try some actual relevant test instead:
>
>    bt %eax,mem
>    bt %rax,mem
>
> and notice how they are actually fundamentally different. Test-case:

I'm coming at this from the compiler side, where the register form is
unambiguous and not questioned. The discussion we're having involves
only the immediate form of the instruction. GNU as interprets:

    bt $63, mem

as
    btl $63, mem

which may or may not be what the user intended, but is not the same as
"btq $63, mem".

I'm not an official LLVM spokesperson or anything, but our consensus
seems to be that "bt $imm, whatever" is ambiguous (the %eax and %rax
versions you quoted disambiguate the width) and should be disallowed
by the assembler.

The patch we're replying to implements that as a NOP fix to the kernel
(GNU as always treats "bt" with an immediate as "btl"). I don't
believe there's any situation in which it will produce different code,
but it will allow Clang to compile (this part of) the kernel.

There is, however, a potential optimisation here for someone who knows
their inline asm. Currently "set_bit(63, addr)" will use the "r"
version of the constraint even on amd64 targets, materialising 63 with
a "movl". With sufficiently clever faff, it could use "btsq" instead.

Cheers.

Tim.
