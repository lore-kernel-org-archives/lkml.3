Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaFXUKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:10:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64089 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaFXUKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <1403638620.29061.35.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
	<CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	<1403638620.29061.35.camel@joe-AO725>
Date: Tue, 24 Jun 2014 22:10:29 +0200
Message-ID: <CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

On 24 June 2014 21:37, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-06-24 at 21:13 +0200, Mathias Krause wrote:
>> I don't think it's that easy. You cannot simply put all strings into
>> the .init.rodata section when code currently gets emitted to
>> .init.text. The reason is because strings used in __init code might be
>> referenced later on, too. For example, the name passed to
>> class_create() won't be copied. If that one would go into the
>> .init.rodata section automatically, we would have dangling pointers
>> after the .init.* memory got freed. Therefore a compiler driven
>> approach would need to be implemented as a compiler extension, a gcc
>> plugin to handle such cases -- know when a string can safely be put
>> into the .init.rodata section and when not. But that decision is not
>> as easy as Joe might think it would be. How would the plugin know
>> which strings to put into the .init.rodata section? Would it only
>> handle the ones passed to printk()?
>
> Yes.

Well, I would like to handle the easy ones, too. E.g. strings used in
parameter parsing, i.e. strcmp()s.

>> I still strongly believe it's better to do this manually.
>
> Maybe.
>
> It'd work with any version of the compiler that way too.

That's a much stronger argument, IMHO. It'll work with gcc < 4.5 and
clang, even. And, it does not require us to maintain compatibility to
the repeating gcc plugin API breakage.

> It's a pretty simple transform.

Indeed, it is.

> I believe this will show most all of the __init
> uses of printks:
>
> $ grep-2.5.4 -rP --include=*.[ch] -n '\b__init\b[^\n][^\}]+\n}' * | \
>   grep -P '^[\w\/\.]+:\d+:|\bprintk\b|\bpr_[a-z]+' | \
>   grep -P -B1 '\bprintk\b|\bpr_[a-z]+'
>
> This shows a little more than a 1000 __init printks
> treewide that could be converted.

A simple awk script found additional 5399 pr_<level> calls in __init
code and 188 calls in __exit code. So it's worth it, IMHO.

>
> For example:
> arch/ia64/include/asm/cyclone.h:6:extern void __init cyclone_setup(void);
>         printk(KERN_ERR "Cyclone Counter: System not configured"
> --
> arch/ia64/kernel/acpi.c:66:static unsigned long __init acpi_find_rsdp(void)
>                 printk(KERN_WARNING PREFIX
> --
> arch/ia64/kernel/acpi.c:366:static int __init acpi_parse_madt(struct acpi_table
>         printk(KERN_INFO PREFIX "Local APIC address %p\n", ipi_base_addr);
>

Those might benefit twice from the change by being converted to
pi_<level> calls along the way. So it's a win-win on all sides, no?

> etc...
>
> There are maybe 200 or so __exit ones.
>

Yeah, the __exit ones are used less. Nonetheless, they should be
converted, too. For completeness, at least.

Thanks,
Mathias
