Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3AZTno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 14:43:44 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:32972 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3AZTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 14:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
 <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
 <20130126125208.GC21395@pd.tnic> <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Jan 2013 11:43:21 -0800
X-Google-Sender-Auth: IrVnVSFilTXL5LpwADlaELyJy20
Message-ID: <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on CONFIG_CC_OPTIMIZE_FOR_SIZE=
 y in the 64-bit defconfig
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jan Beulich <jbeulich@suse.com>, ling.ml@alipay.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 7:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On the CPUs Ling is testing on the downsides of -Os probably matter less, in particular since rep movsb works well.
>
> It is questionable as a generic default, though.

So being the person who really pushed for -Os to begin with (I think
I$ and instruction decode bandwidth is one of the most fundamental
limits to CPU performance), I wouldn't mind it if we reintroduced it.

HOWEVER.

It wasn't just "rep movs". The thing that killed -Os for me was that
it makes it impossible to try to optimize hot code, because -Os seems
to throw out branch prediction information. So when you use "likely()"
etc to try to teach the compiler to lay out code a certain way so that
code that never really gets executed isn't even brought into the I$,
-Os then screws it up completely.

Of course, maybe newer versions of gcc might not suck so horribly with
-Os, I haven't actually tried in a while.

[ Just tested. Still does it ]

Also, I doubt Ling was testing a SB CPU. Because "rep movb" still
sucks pretty bad on SB. What core *is* Ling testing? Haswell?

Ugh. We could make it depend on the optimization target. I'd also wish
there was some way to just tune gcc -Os to be closer to reasonable. Or
make -O2 not do some of the excessive crap it does (it aligns code
*much* too much, for example - who cares if you can do it with a
single instruction, if that instruction is so long that it uses up
half your decode bandwidth?)

The problem, of course, is that most -O2 code generation is done
assuming hot loops that don't show much if any I$ issues. And the -Os
thing is done *purely* for size, not taking any performance into
account at all. There's no balanced middle ground, which is what _we_
would want.

                  Linus
