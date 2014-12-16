Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaLPJuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:50:06 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:59886 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaLPJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:50:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141216120551.053B.AA925319@jp.panasonic.com>
References: <20141215195101.0530.AA925319@jp.panasonic.com>
	<CAMuHMdUaSOr2iDHzWhkKXwwxdvHhpL1C_UR_tw9B1ALhebbdtQ@mail.gmail.com>
	<20141216120551.053B.AA925319@jp.panasonic.com>
Date: Tue, 16 Dec 2014 10:50:02 +0100
X-Google-Sender-Auth: E03KECPJwXW52INxq2F48AAUbSE
Message-ID: <CAMuHMdWbGdgK4vPGZfyvfcVj7hF=YMqL5mX46FY+WUqFVPg_WA@mail.gmail.com>
Subject: Re: [Question] How to print size_t type variable?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Murray <amurray@mpc-data.co.uk>,
        linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yamada-san,

On Tue, Dec 16, 2014 at 4:05 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> On Mon, 15 Dec 2014 12:00:25 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Mon, Dec 15, 2014 at 11:51 AM, Masahiro Yamada
>> <yamada.m@jp.panasonic.com> wrote:
>> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> >> On Mon, Dec 15, 2014 at 10:32 AM, Masahiro Yamada
>> >> <yamada.m@jp.panasonic.com> wrote:
>> >> > I read through Documentation/printk-formats.txt
>> >> >
>> >> > It clearly says to use "%zu" or "%zx" to print size_t variables,
>> >> > but I still have a question.
>> >> >
>> >> > Assume we have code something like:
>> >> >
>> >> >     printk("%zx", (size_t)10);
>> >> >
>> >> > I think this code works fine as long as it includes
>> >> > the compiler-provided <stddef.h>.
>> >> >
>> >> > In the kernel space, however, <stddef.h> is never included.
>> >> > Instead, size_t is defined by include/linux/types.h
>> >> > and include/uapi/asm-generic/posix_types.h.
>> >> >
>> >> > That is, size_t is defined independently from the compiler you are using,
>> >> > although the compiler still decides which variable type is expected for the "%zx" format.
>> >>
>> >> That's correct.
>> >>
>> >> > This causes compiler warnings for some compilers.
>> >> >
>> >> > On bare-metal m68k toolchains, for example, size_t is "unsignd long",
>> >> > whearas it is "unsigned int" on kernel.org m68k toolchains.
>> >> >
>> >> > I see such warnings when I built the kernel with bare-metal m68k toolchains.
>> >> >
>> >> > $ git describe
>> >> > v3.18
>> >> > $ make ARCH=m68k  CROSS_COMPILE=m68k-elf-  defconfig all
>> >> >   HOSTCC  scripts/basic/fixdep
>> >> >   HOSTCC  scripts/kconfig/conf.o
>> >> >   SHIPPED scripts/kconfig/zconf.tab.c
>> >> >   SHIPPED scripts/kconfig/zconf.lex.c
>> >> >   SHIPPED scripts/kconfig/zconf.hash.c
>> >> >   HOSTCC  scripts/kconfig/zconf.tab.o
>> >> >   HOSTLD  scripts/kconfig/conf
>> >> > *** Default configuration is based on 'multi_defconfig'
>> >> > kernel/time/Kconfig:163:warning: range is invalid
>> >> > #
>> >> > # configuration written to .config
>> >> > #
>> >> >
>> >> >   [ snip ]
>> >> >
>> >> >   LD      init/mounts.o
>> >> >   CC      init/initramfs.o
>> >> > init/initramfs.c: In function 'populate_rootfs':
>> >> > init/initramfs.c:635:5: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]
>> >>
>> >> Please use a compiler configured for Linux, i.e. m68k-linux-*.
>> >
>> > Yes, I can use it, but I am still curious.
>> >
>> > Do we have a good reason to keep this limitation?
>> >
>> > (All the problem I could see for using GCC that was not configured for Linux
>> > was just the printk-related warnings.)
>> >
>> > Instead of hard-coding the size_t type,
>> > can we use compiler-provided __SIZE_TYPE__ (or include <stddef.h>) ??
>>
>> Note that cris and s390 used __SIZE_TYPE__ in kernel headers before,
>> but it caused other compiler warnings due to a mismatch in the base types
>> for size_t and ssize_t, cfr. https://lkml.org/lkml/2012/8/12/36.
>> AFAIK, there's no __SSIZE_TYPE__.
>
> I notice __kernel_(s)size_t has the same width as "long".
> (The kernel does not support LLP64.  We just have to take LP64 into account.)

On 64-bit, __kernel_(s)size_t are indeed (unsigned) long
On 32-bit, __kernel_(s)size_t is usually (unsigned) int for historical
reasons.
Cfr. include/uapi/asm-generic/posix_types.h:

/*
 * Most 32 bit architectures use "unsigned int" size_t,
 * and all 64 bit architectures use "unsigned long" size_t.
 */
#ifndef __kernel_size_t
#if __BITS_PER_LONG != 64
typedef unsigned int    __kernel_size_t;
typedef int             __kernel_ssize_t;
typedef int             __kernel_ptrdiff_t;
#else
typedef __kernel_ulong_t __kernel_size_t;
typedef __kernel_long_t __kernel_ssize_t;
typedef __kernel_long_t __kernel_ptrdiff_t;
#endif
#endif

The are a few exceptions (e.g. avr32 and blackfin)

> Perhaps, we should have hard-coded
>
> typedef __kernel_ulong_t __kernel_size_t;
> typedef __kernel_long_t __kernel_ssize_t;
>
> and used "%lx" to print (s)size_t type variables.
>
> I think we do not have a good reason to use "%zx",
> although it might be too late.

In hindsight, it would have been better for (s)size_t to match (unsigned) long,
removing the need for %z.
However, that was realized only after 64-bit architectures were introduced.
It's definitely to late to change this for existing 32-bit architectures.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
