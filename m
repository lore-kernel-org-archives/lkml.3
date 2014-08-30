Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaH3P25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 11:28:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:45543 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaH3P2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 11:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140822082459.GA8771@gmail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
	<20140821125717.GA28987@gmail.com>
	<CA+rthh8XzSC-n+WaYEWiJQdF1XOSRiGSmxpJSFy9duXOOwXX_w@mail.gmail.com>
	<20140822082459.GA8771@gmail.com>
Date: Sat, 30 Aug 2014 17:28:53 +0200
Message-ID: <CA+rthh_tkpqYXJfnwCcAN5ULOHjiRp1EG7jceE1C2eLT-YJv8Q@mail.gmail.com>
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 August 2014 10:24, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Mathias Krause <minipli@googlemail.com> wrote:
>
>> > It feels like a burdensome hack that kernel developers are
>> > forced to use different printing facilities, depending on
>> > the life cycle of a method. We want to simplify init
>> > annotations, we don't want to complicate them!
>>
>> Does this:
>>
>>     pi_info("mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n");
>>
>> really look more complicated compared to this?:
>>
>>     static const char banner[] __initconst = KERN_INFO \
>>         "mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n";
>>     printk(banner);
>>
>> The latter can be found in drivers/net/hamradio/mkiss.c. Aged
>> code, admitted. But we have a few more of those and the
>> pi_info() looks way more appealing to me by doing the very
>> same thing ;)
>
> My point is that both are complicated, compared to using the
> regular printk() variants.
>
> In general printk()s should not be aware of what function
> context they are in.

I agree on the latter. But, unfortunately, the tooling side is not
able to allow this kind of optimization without being told so.

>
>> > And if tooling isn't ready for this, then wouldn't the
>> > right solution be to improve tooling - instead of
>> > complicating the kernel?
>>
>> Plugin based approaches for this have been mentioned before
>> but those suffer from the same "global view" problem. So,
>> IMHO it's not that easy to solve it at the toolchain level.
>
> It might be solved via a regular tooling feature, or via
> tooling extension based on plugins.

Joe has some valid points here. Solving it on the tooling side is 1/
not that easy to do (needs a compiler plugin or direct changes to the
compiler) and 2/ would require it to be solved for all tool-chains, so
all of them could benefit from it. Even more, solving it on the
tool-chain side, i.e. the compiler, would limit it to a fairly recent
tool-chain -- one that still needs to be written. OTOH, solving it on
the source code level makes it compatible with existing tool-chains.
It also allows a fine grained control of what code will be
instrumented and which will not -- much like we do with the __init /
__exit annotations today. It's explicit, not implicit. It would be
hard to express exceptions to the 'put format string into the
.init.rodata section for __init code' rule if it would be solved on
the tooling side. For source level changes it would be easy -- just do
not change that specific printk() call.

>
> Regardless of how it's implemented on the tooling side, my
> point remains: this kind of optimization is done on the tooling
> side in a natural fashion, while it's an ongoing maintenance
> concern on the kernel side.

The costs of making the required changes to the code, i.e. changing
printk() / pr_*() to pi_*() / pe_*(), are a necessary pain but are a
one-time cost, as Joe already said. Beside that, they're an
optimization, after all. Init / Exit code not changed to make use of
the pi_* / pe_* helpers just does not get the run-time memory savings.
So the existing code base can be changed on demand -- just as it is
done with the printk() to pr_*() conversion. Just in this case the
conversion has some additional gain beside cleaning up the code. It
allows saving run-time memory. So it's more than a cosmetically change
to the code.

>
> So it should be done on the tooling side, especially as the
> benefits appear to be marginal.

But still, they are measurable. As I showed on the other thread, even
popular modules like hid.ko or ipv6.ko can gain from dumb, scripted
changes. So, to repeat Joe's words: It's worth it, IMHO.


Regards,
Mathias
