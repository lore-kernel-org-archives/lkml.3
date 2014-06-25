Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaFYIRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:17:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53261 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <877g45qw53.fsf@rasmusvillemoes.dk>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
	<CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	<1403638620.29061.35.camel@joe-AO725>
	<CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	<1403641843.29061.51.camel@joe-AO725>
	<CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	<1403643440.29061.56.camel@joe-AO725>
	<CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
	<1403646310.29061.61.camel@joe-AO725>
	<CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
	<877g45qw53.fsf@rasmusvillemoes.dk>
Date: Wed, 25 Jun 2014 10:17:47 +0200
Message-ID: <CA+rthh-ZH4mhv5s4XUEYLHFe8aFW95K7dGfwQ-dzjUDum-znKw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>,
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

On 25 June 2014 09:35, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> Mathias Krause <minipli@googlemail.com> writes:
>
>> On 24 June 2014 16:31, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>>> gcc already seems to contain infrastructure for this kind of thing, so
>>> maybe it doesn't even require a plugin, but simply a little coordination
>>> with the gcc folks. This snippet from gcc internals seems relevant:
>>>
>>> -- Target Hook: section * TARGET_ASM_FUNCTION_RODATA_SECTION (tree
>>>           DECL)
>>>      Return the readonly data section associated with 'DECL_SECTION_NAME
>>>      (DECL)'.  The default version of this function selects
>>>      '.gnu.linkonce.r.name' if the function's section is
>>>      '.gnu.linkonce.t.name', '.rodata.name' if function is in
>>>      '.text.name', and the normal readonly-data section otherwise.
>>>
>>
>> I don't think it's that easy. You cannot simply put all strings into
>> the .init.rodata section when code currently gets emitted to
>> .init.text. The reason is because strings used in __init code might be
>> referenced later on, too. For example, the name passed to
>> class_create() won't be copied.
>
> Right, didn't think about that, so yes, the source would need
> to be annotated some way or other, or gcc would need to learn the
> semantics of certain kernel functions.

I would rather like to avoid the latter.

>
> Speaking of dangling pointers: A similar disaster would happen if some
> code containing pi_* calls gets copy-pasted to some non-__init
> function. Could checkpatch learn to warn about calling these functions
> from the wrong context?

But the same is already true for code. If an __init function gets
referenced from a non-__init function, the same dangling references
would occur. That's what scripts/mod/modpost is for -- detecting such
cases and warn about them. So this is already handled by the kernel
build system. A checkpatch warning might be a nice addition, anyway.

>
> Mathias Krause <minipli@googlemail.com> writes:
>
>> Merging strings across multiple compilation units does not happen,
>> anyway -- not now, not with the new macros.
>
> Certainly string merging seems to happen, at least at -O1 and higher:
>
> $ grep . *.c
> a.c:const char *a(void) { return "654321"; }
> b.c:const char *b(void) { return "4321"; }
> c.c:const char *c(void) { return "654321"; }
> main.c:#include <stdio.h>
> main.c:const char *a(void);
> main.c:const char *b(void);
> main.c:const char *c(void);
> main.c:int main(void)
> main.c:{
> main.c: printf("%p\n", a());
> main.c: printf("%p\n", b());
> main.c: printf("%p\n", c());
> main.c: return 0;
> main.c:}
> $ gcc -O1 -c a.c && gcc -O1 -c b.c && gcc -O1 -c c.c
> $ gcc -O1 main.c a.o b.o c.o
> $ ./a.out
> 0x400630
> 0x400632
> 0x400630
>
> So not only are identical strings merged; suffixes are also optimized.

Oh, indeed! But they're luckily not merged across sections. So no
problems with dangling pointers here, too.

Thanks,
Mathias
