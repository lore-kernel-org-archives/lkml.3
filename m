Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaGWALU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:11:20 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:52663 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaGWALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:11:19 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Jul 2014 17:10:57 -0700
Message-ID: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
Subject: STI architectural question (and lretq -- I'm not even kidding)
To: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that lretq-to-outer-privilege-level is about 100 cycles
faster than iretq on Sandy Bridge.  This may be enough to be worth
using for returns to userspace, despite the added complexity and
scariness.

Here's where it gets nasty.  Before using lretq, we have to have
interrupts on, and we have to have gs == usergs.  If an asynchronous
non-paranoid interrupt happens then, we're screwed, and I don't really
want to teach the IRQ code to handle this special case.

There's an easy "solution": do sti;lretq.  This even works in my
limited testing (whereas sti;nop;lretq blows up very quickly).

But here's the problem: what happens if an NMI or MCE happens between
the sti and the lretq?  I think an MCE just might be okay -- it's not
really recoverable anyway.  (Except for the absurd MCE broadcast crap,
which may cause this to be a problem.)  But what about an NMI between
sti and lretq?

The NMI itself won't cause any problem.  But the NMI will return to
the lretq with interrupts *on*, and we lose.

The Intel SDM helpfully says "The IF flag and the STI and CLI
instructions do not prohibit the generation of exceptions and NMI
interrupts. NMI interrupts (and SMIs) may be blocked for one
macroinstruction following an STI."  Does that mean that this isn't a
problem?  What about on AMD?

An alternative would be to do a manual fixup in the NMI and MCE code.  Yuck.

The implementation is here, in case you want to play with it:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/tag/?id=lretq-to-userspace

--Andy

P.S. I'm sure there will be any number of CPU errata here, especially
since lretq-from-long-mode-to-outer-privilege-level is involved, which
might be completely unused in any major OS.

P.P.S. At least on Sandy Bridge, lretq has the same 16-bit SS problem as iret.
