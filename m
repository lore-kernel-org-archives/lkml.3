Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaHUOaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:30:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64797 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbaHUO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140821125717.GA28987@gmail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
	<20140821125717.GA28987@gmail.com>
Date: Thu, 21 Aug 2014 16:29:55 +0200
Message-ID: <CA+rthh8XzSC-n+WaYEWiJQdF1XOSRiGSmxpJSFy9duXOOwXX_w@mail.gmail.com>
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

On 21 August 2014 14:57, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Mathias Krause <minipli@googlemail.com> wrote:
>
>> This is v3 of the patch series initially posted here:
>>
>>   https://lkml.org/lkml/2014/6/22/149
>>
>> This series tries to address the problem of dangling strings of __init
>> functions after initialization, as well as __exit strings for code not
>> even included in the final kernel image. The code might get freed, but
>> the format strings are not, as they're in the wrong section.
>>
>> One solution to the problem might be to declare variables in the code
>> and mark those variables as __initconst. That, though, makes the code
>> ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
>> 'static const char[] __initconst' lines just for the pr_info() call.
>>
>> To be able to mark strings easily patch 1 adds macros to init.h to do so
>> without the need to explicitly define variables in the code. (Internally
>> it'll declare ones nonetheless, as this seem to be the only way to
>> attach an __attribute__() to a verbatim string.) That's already enough to
>> solve the problem -- mark the corresponding stings by using these
>> macros. But patch 2 adds some syntactical sugar for the most popular use
>> case, by providing pr_<level> alike macros, namely pi_<level> for __init
>> code and pe_<level> for __exit code. This hides the use of the marker
>> macros behind the commonly known printing functions -- with just a
>> single character changed. For code that cannot be changed to use the
>> pi_<level>() / pe_<level>() helpers printk_init() and printk_exit()
>> macros are provided, too.
>>
>> The (hidden) variables used in the macros of patch 1 will pollute the
>> kernel's symbol table with unneeded entries. It'll be a problem in the
>> KALLSYMS_ALL case only, however, patch 3 takes care of filtering the
>> pseudo symbols. They have no value for us beside being the only way to
>> attach an __attribute__ to a string literal.
>>
>> If users of the new macros get it wrong, e.g. use printk_init() /
>> pi_<level>() in non-init code or vice versa printk_exit() / pe_<level>()
>> in non-exit code, modpost will detect the error as a section mismatch
>> and report it accordingly. Still, the message printed by modpost with
>> CONFIG_DEBUG_SECTION_MISMATCH=y is rather confusing as the __initconst /
>> __exitdata annotation is hidden behind the macros. That's what patch 4
>> takes care of -- detecting such cases and providing better modpost
>> messages, guiding the user on how to fix the error.
>>
>> The remaining patches (5 to 9) exemplarily change strings and format
>> strings in a selection of files under arch/x86/ to use the new macros.
>> They also address a few styling issues, e.g., patches 4 and 5 are
>> cleanup patches I stumbled across while changing the corresponding code
>> to make use of the new pi_*() helpers. The changes to arch/x86/ already
>> lead to moving ~3kb of memory from .rodata to .init.rodata. This should
>> free up a page after init on almost any x86 system.
>>
>> To show that there's actual more value to it: A hacked up script, dully
>> changing pr_<level> to pi_<level> for __init functions under arch/x86/
>> is able to move ~8kB of r/o data into the .init section (partly already
>> covered by the patches of this series). The script, though, is dump. It
>> does not handle any of the printk() calls, nor does it handle panic()
>> calls or other strings used only in initialization code. So there's more
>> to squeeze out.
>
> It feels like a burdensome hack that kernel developers are
> forced to use different printing facilities, depending on the
> life cycle of a method. We want to simplify init annotations,
> we don't want to complicate them!

Does this:

    pi_info("mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n");

really look more complicated compared to this?:

    static const char banner[] __initconst = KERN_INFO \
        "mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n";
    printk(banner);

The latter can be found in drivers/net/hamradio/mkiss.c. Aged code,
admitted. But we have a few more of those and the pi_info() looks way
more appealing to me by doing the very same thing ;)

>
> Why isn't this problem solved transparently at build time, via
> tooling, instead of burdening developers? If a particular
> string is only used by an init (or exit) function, it can be
> moved to an init section without forcing the developer to
> declare it as such.

That's the point. It's not easy to decide "[i]f a particular string is
only used by an init (or exit) function" at the toolchain level. I
agree that it would be best if gcc / ld could detect the life span of
objects automatically and put them into the appropriate sections. But
this is harder to do then it might seems to on the first sight. Not
all string literals used in __init / __exit code can be put into the
corresponding .init / .exit section because some of those strings will
be used later on -- the name passed to class_create(), for example. To
make the toolchain detect which cases are safe to move and which are
not would require it to have a complete view of the resulting kernel
image -- be an LTO stage, so to speak. Otherwise it would either be
impossible -- how would gcc / ld know what a function does with the
string it gets passed to? -- or only work in very special cases, e.g.
where the string is only used within the scope of the compilation unit
-- for strcpy() and such, functions gcc is aware of what they're
doing.

>
> And if tooling isn't ready for this, then wouldn't the right
> solution be to improve tooling - instead of complicating the
> kernel?

Plugin based approaches for this have been mentioned before but those
suffer from the same "global view" problem. So, IMHO it's not that
easy to solve it at the toolchain level. Not to speak, that the kernel
has no infrastructure support for gcc plugins so far. A source level
change seems like a good trade-off. It not only is able to change
existing printk(KERN_* ..) constructs to there pi_*() / pe_*()
counterparts but also marks the memory for release, thereby allows
freeing memory otherwise just lingering around.


Thanks,
Mathias
