Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaLPDGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:06:43 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:42588 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaLPDGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:06:42 -0500
Date: Tue, 16 Dec 2014 12:05:51 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [Question] How to print size_t type variable?
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Murray <amurray@mpc-data.co.uk>,
        linux-m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <CAMuHMdUaSOr2iDHzWhkKXwwxdvHhpL1C_UR_tw9B1ALhebbdtQ@mail.gmail.com>
References: <20141215195101.0530.AA925319@jp.panasonic.com> <CAMuHMdUaSOr2iDHzWhkKXwwxdvHhpL1C_UR_tw9B1ALhebbdtQ@mail.gmail.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141216120551.053B.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,


On Mon, 15 Dec 2014 12:00:25 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Hi Yamada-san,
> 
> On Mon, Dec 15, 2014 at 11:51 AM, Masahiro Yamada
> <yamada.m@jp.panasonic.com> wrote:
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> On Mon, Dec 15, 2014 at 10:32 AM, Masahiro Yamada
> >> <yamada.m@jp.panasonic.com> wrote:
> >> > I read through Documentation/printk-formats.txt
> >> >
> >> > It clearly says to use "%zu" or "%zx" to print size_t variables,
> >> > but I still have a question.
> >> >
> >> >
> >> > Assume we have code something like:
> >> >
> >> >     printk("%zx", (size_t)10);
> >> >
> >> >
> >> > I think this code works fine as long as it includes
> >> > the compiler-provided <stddef.h>.
> >> >
> >> > In the kernel space, however, <stddef.h> is never included.
> >> > Instead, size_t is defined by include/linux/types.h
> >> > and include/uapi/asm-generic/posix_types.h.
> >> >
> >> >
> >> > That is, size_t is defined independently from the compiler you are using,
> >> > although the compiler still decides which variable type is expected for the "%zx" format.
> >>
> >> That's correct.
> >>
> >> > This causes compiler warnings for some compilers.
> >> >
> >> > On bare-metal m68k toolchains, for example, size_t is "unsignd long",
> >> > whearas it is "unsigned int" on kernel.org m68k toolchains.
> >> >
> >> >
> >> > I see such warnings when I built the kernel with bare-metal m68k toolchains.
> >> >
> >> >
> >> > $ git describe
> >> > v3.18
> >> > $ make ARCH=m68k  CROSS_COMPILE=m68k-elf-  defconfig all
> >> >   HOSTCC  scripts/basic/fixdep
> >> >   HOSTCC  scripts/kconfig/conf.o
> >> >   SHIPPED scripts/kconfig/zconf.tab.c
> >> >   SHIPPED scripts/kconfig/zconf.lex.c
> >> >   SHIPPED scripts/kconfig/zconf.hash.c
> >> >   HOSTCC  scripts/kconfig/zconf.tab.o
> >> >   HOSTLD  scripts/kconfig/conf
> >> > *** Default configuration is based on 'multi_defconfig'
> >> > kernel/time/Kconfig:163:warning: range is invalid
> >> > #
> >> > # configuration written to .config
> >> > #
> >> >
> >> >   [ snip ]
> >> >
> >> >   LD      init/mounts.o
> >> >   CC      init/initramfs.o
> >> > init/initramfs.c: In function 'populate_rootfs':
> >> > init/initramfs.c:635:5: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]
> >>
> >> Please use a compiler configured for Linux, i.e. m68k-linux-*.
> >
> >
> > Yes, I can use it, but I am still curious.
> >
> > Do we have a good reason to keep this limitation?
> >
> > (All the problem I could see for using GCC that was not configured for Linux
> > was just the printk-related warnings.)
> >
> >
> > Instead of hard-coding the size_t type,
> > can we use compiler-provided __SIZE_TYPE__ (or include <stddef.h>) ??
> 
> Note that cris and s390 used __SIZE_TYPE__ in kernel headers before,
> but it caused other compiler warnings due to a mismatch in the base types
> for size_t and ssize_t, cfr. https://lkml.org/lkml/2012/8/12/36.
> AFAIK, there's no __SSIZE_TYPE__.


I notice __kernel_(s)size_t has the same width as "long".
(The kernel does not support LLP64.  We just have to take LP64 into account.)

Perhaps, we should have hard-coded

typedef __kernel_ulong_t __kernel_size_t;
typedef __kernel_long_t __kernel_ssize_t;

and used "%lx" to print (s)size_t type variables.

I think we do not have a good reason to use "%zx",
although it might be too late.



Best Regards
Masahiro Yamada

