Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaBZGP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:15:27 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56067 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaBZGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:15:26 -0500
MIME-Version: 1.0
In-Reply-To: <87sir856a7.fsf@rustcorp.com.au>
References: <20140221201031.GA8089@www.outflux.net>
	<87sir856a7.fsf@rustcorp.com.au>
Date: Tue, 25 Feb 2014 22:15:25 -0800
X-Google-Sender-Auth: gSXZKyeDBjUWBk4dLLvirEq598Q
Message-ID: <CAGXu5j+iwHryXB9sQrT4agTa=GQ-OwoPLS256=cBuQoqnT3fhA@mail.gmail.com>
Subject: Re: [PATCH] kallsyms: fix absolute addresses for kASLR
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ming Lei <tom.leiming@gmail.com>, Andy Honig <ahonig@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 5:29 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> From: Andy Honig <ahonig@google.com>
>>
>> Currently symbols that are absolute addresses are incorrectly
>> displayed in /proc/kallsyms if the kernel is loaded with kASLR.
>>
>> The problem was that the scripts/kallsyms.c file which generates
>> the array of symbol names and addresses uses an relocatable value
>> for all symbols, even absolute symbols.  This patch fixes that.
>
> Hi Andy, Kees,
>
>         This is not a good patch.  See the commit where this was
> introduced:
>
> [PATCH] relocatable kernel: Fix kallsyms on avr32 after relocatable kernel changes
>
>     o On some platforms like avr32, section init comes before .text and
>       not necessarily a symbol's relative position w.r.t _text is positive.
>       In such cases assembler detects the overflow and emits warning. This
>       patch fixes it.
>
> Did you just break avr32?
>
> And absolute symbols are supposed to be handled in the other branch:
>
>         for (i = 0; i < table_cnt; i++) {
>                 if (toupper(table[i].sym[0]) != 'A') {
>                         if (_text <= table[i].addr)
>                                 printf("\tPTR\t_text + %#llx\n",
>                                         table[i].addr - _text);
>                         else
>                                 printf("\tPTR\t_text - %#llx\n",
>                                         _text - table[i].addr);
>                 } else {
>                         printf("\tPTR\t%#llx\n", table[i].addr);
>                 }
>         }
>
> __per_cpu_start is not an absolute symbol anyway.
>
> You need to fix this properly.
> Rusty.

Hm, yeah, it seems we need another class of variable. The per_cpu
stuff is technically relative, but it's not relocated, since it's not
relative to the text location. We'll see how to do this more sanely.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
