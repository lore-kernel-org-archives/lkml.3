Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3GNRTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 13:19:22 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:36063 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3GNRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 13:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
Date: Sun, 14 Jul 2013 10:19:20 -0700
X-Google-Sender-Auth: u5-9rOyBldiae2t78e01pCO4X4k
Message-ID: <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 5:56 AM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
> 1c54d77 (x86: partial unification of asm-x86/bitops.h, 2008-01-30)
> changed a bunch of btrl/btsl instructions to btr/bts, with the following
> justification:
>
>   The inline assembly for the bit operations has been changed to remove
>   explicit sizing hints on the instructions, so the assembler will pick
>   the appropriate instruction forms depending on the architecture and
>   the context.
>
> Unfortunately, GNU as does no such thing

Yes it does.

>   btrl  $1, 0
>   btr   $1, 0
>   btsl  $1, 0
>   bts   $1, 0

What the heck is that supposed to show? It shows nothing at all. With
an argument of '1', *of*course* gas will use "btsl", since that's the
short form. Using the rex-predix and a btsq would be *stupid*.

So gas will pick the appropriate form, exactly as claimed.

Try some actual relevant test instead:

   bt %eax,mem
   bt %rax,mem

and notice how they are actually fundamentally different. Test-case:

int main(int argc, char **argv)
{
  asm("bt %1,%0":"=m" (**argv): "a" (argc));
  asm("bt %1,%0":"=m" (**argv): "a" ((unsigned long)(argc)));
}

and I get

   0f a3 02             bt     %eax,(%rdx)
   48 0f a3 02           bt     %rax,(%rdx)

exactly as expected and wanted.

Now, there are possible cases where you want to make the size explicit
because you are mixing memory operand sizes and there can be nasty
performance implications of doing a 32-bit write and then doing a
64-bit read of the result. I'm not actually aware of us having ever
worried/cared about it, but it's a possible source of trouble: mixing
bitop instructions with non-bitop instructions can have some subtle
interactions, and you need to be careful, since the size of the
operand affects both the offset *and* the memory access size. The
access size generally is meaningless from a semantic standpoint
(little-endian being the only sane model), but the access size *can*
have performance implications for the write queue forwarding.

                      Linus
