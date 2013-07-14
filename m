Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3GNTJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:09:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64810 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3GNTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
Date: Sun, 14 Jul 2013 12:09:21 -0700
X-Google-Sender-Auth: 1G_1gWh_hEyLhAf2Q72A8xAkBio
Message-ID: <CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Northover <t.p.northover@gmail.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 11:35 AM, Tim Northover <t.p.northover@gmail.com> wrote:
>
> I'm coming at this from the compiler side, where the register form is
> unambiguous and not questioned. The discussion we're having involves
> only the immediate form of the instruction. GNU as interprets:
>
>     bt $63, mem
>
> as
>     btl $63, mem
>
> which may or may not be what the user intended, but is not the same as
> "btq $63, mem".

Umm. The user doesn't care. The user wants the best code without
having to worry about it.

Think of it this way: the whole and ONLY point of an assembler is to
make machine code reasonably easy to write, by not having to worry
about the exact encoding details. We don't want the users specifying
the hex representation of the instructions, do we? Or even details
like "what is the most efficient form of this instruction". For
example, think about branch offsets and immediates. Most architectures
have some limits about how long branch offsets or immediates are, and
a short branch offset may use TOTALLY DIFFERENT instruction encoding
than a long branch offset.

Do you really expect that the user says "jnel" for the long form of
the "jne" instruction? And "jnes" if you want the
smaller/faster/simpler 8-bit version?

No sane person actually wants that, and no modern assembler does that
(although I can remember ones that did - ugh). You write "jne target"
and depend on the assembler doing the right thing. Or you write "add
$5,%eax", and depend on the fact that the assembler will use the much
shorter version of the "add" instruction that just takes a 8-bit
signed value instead of the full 32-bit immediate. Or any number of
details like this ("there are special versions that only work on %eax"
etc rules)

And that is why I think you should just consider "bt $x,y" to be
trivially the same thing and not at all ambiguous. Because there is
ABSOLUTELY ZERO ambiguity when people write

   bt $63, mem

Zero. Nada. None. The semantics are *exactly* the same for btl and btq
in this case, so why would you want the user to specify one or the
other? The user may be knowledgeable about the architecture, and know
that "btl" is one byte shorter than "btq", and use "btl" for that
reason. You seem to argue that that is the "right thing"(tm) to do,
since that's what the instruction encoding will be. But if that's the
case, then you are arguing that "jne target" is "ambiguous" because
there are two different ways to encode that too? Do you seriously
argue that?

So I'm arguing that that is wrong for an assembler to not just do the
right thing, because the user isn't *supposed* to have to know about
things like "one byte shorter encoding format". And there really is no
semantic difference between the two forms. So making the user specify
the size is just going to cause problems (in particular, it might well
make users go "this is an array of 64-bit entities, so I should use
btq", even though that is actually incorrect).

Now, I obviously think that the user should have the choice to
*override* the default thing, so sometimes you might have

   /* We use a 64-bit btsq to encourage the CPU to do it as a 64-bit
read-modify-write, since we will do a 64-bit read of the result later,
and otherwise we'll get a partial write buffer stall */

   btsq $63, mem

and then the assembler had obviously better use the size information
the user gave it. But the thing is, this is basically never a concern
in practice, and when it is, the assembler really cannot know (it
could go either way: maybe the bts is following a 32-bit write, and
you want the 32-bit version - and I suspect that the likelihood of
most users getting this right by hand is quite low too).

(Side note: I'm not even going to guarantee that the actual CPU uses
the operand size for the memory access size. The manuals imply they
do, but since there are no real semantic reasons to enforce that, I
could imagine that some microarchitecture doesn't actually care).

                    Linus
