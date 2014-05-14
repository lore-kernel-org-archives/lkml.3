Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaENMfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:35:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49391 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaENMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:35:29 -0400
MIME-Version: 1.0
In-Reply-To: <4645786.pJABUgPlCA@wuerfel>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	<20140509220915.GA391@arch.cereza>
	<20140513205548.GC22907@obsidianresearch.com>
	<4645786.pJABUgPlCA@wuerfel>
Date: Wed, 14 May 2014 14:35:28 +0200
X-Google-Sender-Auth: FOiGY38_q4wEIA-JV-xNfAzFqZw
Message-ID: <CAMuHMdXD7HhG_jGJdz8hCR847tKcRC-tQnHp=xtTDYVKBc6yQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Sure, but did anyone (Arnd?) have thoughts on a better way to do this:
>>
>> +#ifdef CONFIG_64BIT
>> +               buf64[i++] = readq_relaxed(io_base);
>> +#else
>> +               buf64[i++] = *(const volatile u64 __force *)io_base;
>> +#endif
>>
>> IMHO, readq should exist on any platform that can issue a 64 bit bus
>> transaction, and I expect many ARM's qualify.
>
> Well, the original problem happened specifically for the case that doesn't
> have a 64-bit bus transaction (building for ARMv4). If we define
> readq_relaxed, it has to be an inline assembly, in order to work for
> drivers that require an atomic transaction, so that would have the
> same problem. We are a bit inconsistent here though: most 32-bit
> architectures have no readq, parisc has one that does two 32-bit accesses,
> sh relies on the compiler, and tile apparently has a native instruction.
>
> It seems reasonable to replace the inline assembly in this driver with
> a new function as a cleanup, but then how do you want to solve the case
> of building a combined armv4/v5 kernel?

Provide two helper functions, one for v4, one for v5, and call
them through a function pointer that's set up during driver probe?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
