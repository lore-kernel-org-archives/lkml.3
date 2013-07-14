Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3GNS0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 14:26:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41652 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3GNS0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 14:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sun, 14 Jul 2013 23:56:10 +0530
Message-ID: <CALkWK0nWO3E2pOLKDds68d_SLA_72e2ok9AV7UvbN6Qa4yAoig@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
To: Linus Torvalds <torvalds@linux-foundation.org>
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

Linus Torvalds wrote:
>>   btrl  $1, 0
>>   btr   $1, 0
>>   btsl  $1, 0
>>   bts   $1, 0
>
> What the heck is that supposed to show?

I was trying to show a reduced case where gas doesn't complain, but
llvm-mc does.  Try compiling this with llvm-mc, and you'll get:

        .text
        btrl    $1, 0
in.s:2:1: error: ambiguous instructions require an explicit suffix
      (could be 'btrw', 'btrl', or 'btrq')
btr     $1, 0
^
        btsl    $1, 0
in.s:4:1: error: ambiguous instructions require an explicit suffix
      (could be 'btsw', 'btsl', or 'btsq')
bts     $1, 0
^

Obviously, I misunderstood something major and screwed up the commit message.

> int main(int argc, char **argv)
> {
>   asm("bt %1,%0":"=m" (**argv): "a" (argc));
>   asm("bt %1,%0":"=m" (**argv): "a" ((unsigned long)(argc)));
> }

Right, so in:

int main(int argc, char **argv)
{
  asm("bts %1,%0":"=m" (**argv): "r" (argc));
  asm("btsl %1,%0":"=m" (**argv): "r" (argc));
  asm("btr %1,%0":"=m" (**argv): "r" ((unsigned long)(argc)));
  asm("btrq %1,%0":"=m" (**argv): "r" ((unsigned long)(argc)));
}

bts disambiguates to btsl, and btr disambiguates to btrq, as
advertised.  Is it dependent on whether I have a 32-bit machine or
64-bit machine, or just on the operand lengths?

Either way, this is not a very enlightening example, because clang
also compiles this fine, and doesn't complain about any ambiguity.  To
see the ambiguity I'm talking about, try to compile linux.git with
clang; I'll paste one error:

arch/x86/include/asm/bitops.h:129:15: error: ambiguous instructions
      require an explicit suffix (could be 'btrw', 'btrl', or 'btrq')
        asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
                     ^
<inline asm>:1:2: note: instantiated into assembly here
        btr $0,(%rsi)
        ^

Since nr is an int, and ADDR is *(volatile long *), this should
disambiguate to btrl, right?  Any clue why clang is complaining?
