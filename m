Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3GOS4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:56:23 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:54311 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3GOS4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <51E44204.4000802@zytor.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
	<CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com>
	<CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
	<CA+55aFwcxWR-SFD=QFXAb38sPnN-hcOBF-W+NuRBSMx-n+RnxQ@mail.gmail.com>
	<51E44204.4000802@zytor.com>
Date: Mon, 15 Jul 2013 11:56:21 -0700
X-Google-Sender-Auth: rMuldEObCxybj6o-ORDyACOAYhU
Message-ID: <CA+55aFy=w6v9MqcVn1H6X7jqJq+QrEx7TfA6Kr+vC4SYJRjUyQ@mail.gmail.com>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tim Northover <t.p.northover@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:40 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2013 12:49 PM, Linus Torvalds wrote:
>
> This is also why the Intel manuals point out that "some assemblers" can
> take things like:
>
>         bt[l] $63,(%rsi)
>
> ... and turn it into:
>
>         btl $31,4(%rsi)
>
> This is definitely the friendly thing to do toward the human programmer.
>  Unfortunately gas doesn't, nor does e.g. NASM.

Yeah, that's definitely a "quality of implementation" issue. Clearly
"bt $63,mem" is talking about bit 63, and a quality assembler would
either warn about it or just do the RightThing(tm) like the intel
manual says.

I'd actually like to say "think you" to the gas people, because gas
today may not do the above, but gas today is still *lightyears* ahead
of where it used to be two decades ago. Back in those dark ages, GNU
as was even documented to be *only* about turning compiler output into
object code, and gas was the ghastliest assembler on the planet - it
silently did horrible horrible things, and didn't do *anything*
user-friendly or clever. It would entirely ignore things like implied
sizes from register names etc, and generate code that was obviously
not at all what the user expected, but because cc1 always used
explicit sizes etc and only generated very specific syntax, it "wasn't
an issue".

gas has improved immensely in this regard, and the fact that it
silently takes a $63 and effectively turns it into $31 is something I
think is not nice and not a good QoI, but considering where gas came
from, I'm not going to complain about it too much. It's
"understandable", even if it isn't great.

But quite frankly, partly because of just how bad gas used to be wrt
issues like this, I think that any other assembler should aim to be at
_least_ as good as gas, if not better. Because I definitely don't want
to go back to the bad old days. I've been there, done that. Assemblers
that are worse than gas are not worth working with. gas should be
considered the minimal implementation quality, and llvm-as should
strive to do better rather than worse..

(NASM used to be *much* more pleasant to work with than gas. Maybe you
should strive to make nasm DTRT wrt bt and constants, and maintain
that lead?)

                   Linus
