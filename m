Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaFXTNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:13:21 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47078 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <87egyeqt03.fsf@rasmusvillemoes.dk>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
Date: Tue, 24 Jun 2014 21:13:16 +0200
Message-ID: <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 16:31, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> Joe Perches <joe@perches.com> writes:
>
>> On Mon, 2014-06-23 at 08:23 +0200, Mathias Krause wrote:
>>> On 23 June 2014 00:56, Joe Perches <joe@perches.com> wrote:
>>> > On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
>>> >> [...] patch 2 adds some syntactical sugar for the most popular use
>>> >> case, by providing pr_<level> alike macros, namely pi_<level> for __init
>>> >> code and pe_<level> for __exit code. This hides the use of the marker
>>> >> macros behind the commonly known printing functions -- with just a
>>> >> single character changed.
>>> >>
>>> >> Patch 3 exemplarily changes all strings and format strings in
>>> >> arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
>>> >> few styling issues, though. But this already leads to ~1.7 kB of r/o
>>> >> data moved to the .init.rodata section, marking it for release after
>>> >> init.
>>> >>
>>> >> [...]
>>> >
>>> > I once proposed a similar thing.
>>> >
>>> > https://lkml.org/lkml/2009/7/21/421
>>> >
>>> > Matt Mackall replied
>>> >
>>> > https://lkml.org/lkml/2009/7/21/463
>>> >
>>>
>>> Thanks for the pointers. Have you looked at patch 2 and 3? I don't
>>> think it makes the printk() case ugly. In fact, using pi_<level>()
>>> should be no less readable then pr_<level>, no?
>>
>> I don't think it's particularly less readable, but I
>> do think using the plug-in mechanism might be a better
>> option as it would need no manual markings at all.
>
> gcc already seems to contain infrastructure for this kind of thing, so
> maybe it doesn't even require a plugin, but simply a little coordination
> with the gcc folks. This snippet from gcc internals seems relevant:
>
> -- Target Hook: section * TARGET_ASM_FUNCTION_RODATA_SECTION (tree
>           DECL)
>      Return the readonly data section associated with 'DECL_SECTION_NAME
>      (DECL)'.  The default version of this function selects
>      '.gnu.linkonce.r.name' if the function's section is
>      '.gnu.linkonce.t.name', '.rodata.name' if function is in
>      '.text.name', and the normal readonly-data section otherwise.
>

I don't think it's that easy. You cannot simply put all strings into
the .init.rodata section when code currently gets emitted to
.init.text. The reason is because strings used in __init code might be
referenced later on, too. For example, the name passed to
class_create() won't be copied. If that one would go into the
.init.rodata section automatically, we would have dangling pointers
after the .init.* memory got freed. Therefore a compiler driven
approach would need to be implemented as a compiler extension, a gcc
plugin to handle such cases -- know when a string can safely be put
into the .init.rodata section and when not. But that decision is not
as easy as Joe might think it would be. How would the plugin know
which strings to put into the .init.rodata section? Would it only
handle the ones passed to printk()? How to ensure those are actually
safe strings? The pr_<level> macros can ensure this by using
preprocessor string concatenation internally. Therefore those are
unique and can safely be put into the .init.rodata section. But the
compiler won't see the pr_<level> calls any more, only the printk().
But that one might be a direct call, called with a string used later
on, too. How would a plugin be able to detect this?
What about strings used in strcmp() and the like? What about strings
stored in temporary variables before getting passed to printk()? Those
would require the plugin to track variable assignment, too. That,
again, complicates the plugin.
For a fully automatic handling of such strings a global analysis is
needed, e.g. LTO is *required* to know if the strings passed to the
functions will be stored in data structures not backed in .init.*
sections. That's far from being easy to implement and even farther
away from being widely used. Beside that, for being able to use gcc
plugins, the plugin headers need to be installed -- not only the
compiler. Again, a perquisite, not available by default.

Therefore I still strongly believe it's better to do this manually.
It's way simpler and much more explicit and therefore less surprising.
Even if this means we need to change quite a lot of code to get the
best out of it. For a start it really depends on a few subsystem
maintainers to accept patches to get an initial value out of it. Heck,
even for the non-embedded case, it has value -- at least for me. I
like to get rid of the unused strings. It's just a few pages,
admitted. But hey, we can get them almost for free. So, why not just
do it?

Regards,
Mathias
