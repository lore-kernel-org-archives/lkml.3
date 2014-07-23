Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaGWBDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:03:38 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49100 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGWBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
Date: Tue, 22 Jul 2014 18:03:35 -0700
X-Google-Sender-Auth: _K9WcFau9mMrxarqWULk4-JI2OM
Message-ID: <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> But here's the problem: what happens if an NMI or MCE happens between
> the sti and the lretq?  I think an MCE just might be okay -- it's not
> really recoverable anyway.  (Except for the absurd MCE broadcast crap,
> which may cause this to be a problem.)  But what about an NMI between
> sti and lretq?

Sadly, it's not architected.

The "mov ss" and "pop ss" do indeed suppress even NMI. And that *has*
to be true, because in legacy real mode - where there is no protection
domain change, and the "lss" instruction didn't originally exist - the
"pop/mov ss" and "mov sp" instruction sequence had to be entirely
atomic. And this is even very officially documented. From the intel
system manual:

    "A POP SS instruction inhibits all interrupts, including the NMI
interrupt, until after execution of the next instruction. This action
allows sequential execution of POP SS and MOV ESP, EBP instructions
without the danger of having an invalid stack during an interrupt.
However, use of the LSS instruction is the preferred method of loading
the SS and ESP registers"

However, while "sti" has conceptually the same one-instruction
interrupt window disable as mov/pop ss, it looks like Intel broke it
for NMI. The documentation only talks about "external, maskable
interrupts", and while I suspect *many* micro-architectures also end
up disabling NMI for the next instruction, there are many reasons to
think not all do.

See for example

    http://www.sandpile.org/x86/inter.htm

and note #5 under external interrupt suppression.

Now, sandpile is pretty old, but Christian Ludloff used to get things
like that right.

So I'm afraid that "sti; lret" is not guaranteed to be architecturally
NMI-safe. But it *might* be safe on certain micro-architectures, and
maybe somebody inside Intel or AMD can give us a hint about when it is
safe and when it isn't.

                Linus
