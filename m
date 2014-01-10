Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaAJUwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:52:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbaAJUwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:52:03 -0500
Message-ID: <1389387082.2591.95.camel@deneb.redhat.com>
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 10 Jan 2014 15:51:22 -0500
In-Reply-To: <CAL_JsqLZQ=3gph4yaNSrZ5oPL3kasQKqA5C5+my0GwjGHsvMeQ@mail.gmail.com>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com>
	 <1389325833-16535-5-git-send-email-msalter@redhat.com>
	 <CAL_JsqLZQ=3gph4yaNSrZ5oPL3kasQKqA5C5+my0GwjGHsvMeQ@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 10:11 -0600, Rob Herring wrote:
> On Thu, Jan 9, 2014 at 9:50 PM, Mark Salter <msalter@redhat.com> wrote:
> > +config EARLY_IOREMAP
> > +       depends on MMU
> 
> Is it possible to implement a !MMU version of early_ioremap that
> simply returns the phys address rather than have this dependency?

I don't think that would be too hard to do.

> 
> > +       bool "Provide early_ioremap() support for kernel initialization."
> > +       select GENERIC_EARLY_IOREMAP
> > +       help
> > +         Provide a mechanism for kernel initialisation code to temporarily
> > +         map, in a highmem-agnostic way, memory pages in before ioremap()
> > +         and friends are available (before paging_init() has run). It uses
> > +         the same virtual memory range as kmap so all early mappings must
> > +         be unapped before paging_init() is called.
> > +
> >  config SECCOMP
> >         bool
> >         prompt "Enable seccomp to safely compute untrusted bytecode"
> > diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> > index c38b58c..49ec506 100644
> > --- a/arch/arm/include/asm/Kbuild
> > +++ b/arch/arm/include/asm/Kbuild
> > @@ -4,6 +4,7 @@ generic-y += auxvec.h
> >  generic-y += bitsperlong.h
> >  generic-y += cputime.h
> >  generic-y += current.h
> > +generic-y += early_ioremap.h
> >  generic-y += emergency-restart.h
> >  generic-y += errno.h
> >  generic-y += exec.h
> > diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> > index 68ea615..e92b7a4 100644
> > --- a/arch/arm/include/asm/fixmap.h
> > +++ b/arch/arm/include/asm/fixmap.h
> > @@ -21,8 +21,26 @@ enum fixed_addresses {
> >         FIX_KMAP_BEGIN,
> >         FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
> >         __end_of_fixed_addresses
> > +/*
> > + * 224 temporary boot-time mappings, used by early_ioremap(),
> > + * before ioremap() is functional.
> > + *
> > + * (P)re-using the FIXADDR region, which is used for highmem
> > + * later on, and statically aligned to 1MB.
> > + */
> > +#define NR_FIX_BTMAPS          32
> > +#define FIX_BTMAPS_SLOTS       7
> > +#define TOTAL_FIX_BTMAPS       (NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
> > +#define FIX_BTMAP_END          FIX_KMAP_BEGIN
> > +#define FIX_BTMAP_BEGIN                (FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1)
> >  };
> >
> > +#define FIXMAP_PAGE_NORMAL (L_PTE_MT_WRITEBACK | L_PTE_YOUNG | L_PTE_PRESENT)
> > +#define FIXMAP_PAGE_IO (L_PTE_MT_DEV_NONSHARED | L_PTE_YOUNG | L_PTE_PRESENT)
> > +
> > +extern void __early_set_fixmap(enum fixed_addresses idx,
> > +                              phys_addr_t phys, pgprot_t flags);
> > +
> >  #include <asm-generic/fixmap.h>
> >
> >  #endif
> > diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> > index fbeb39c..6b2cc53 100644
> > --- a/arch/arm/include/asm/io.h
> > +++ b/arch/arm/include/asm/io.h
> > @@ -28,6 +28,7 @@
> >  #include <asm/byteorder.h>
> >  #include <asm/memory.h>
> >  #include <asm-generic/pci_iomap.h>
> > +#include <asm/early_ioremap.h>
> >  #include <xen/xen.h>
> >
> >  /*
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 987a7f5..038fb75 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -36,6 +36,7 @@
> >  #include <asm/cpu.h>
> >  #include <asm/cputype.h>
> >  #include <asm/elf.h>
> > +#include <asm/io.h>
> 
> Use linux/io.h?

Yes.

> 
> >  #include <asm/procinfo.h>
> >  #include <asm/psci.h>
> >  #include <asm/sections.h>
> > @@ -887,6 +888,8 @@ void __init setup_arch(char **cmdline_p)
> >
> >         parse_early_param();
> >
> > +       early_ioremap_init();
> > +
> 
> This call would need to be before parse_early_param for the earlycon to work.

Yes, like arm64 does it.


