Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaHRT2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:28:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:54919 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaHRT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <1408388465-26577-1-git-send-email-bobby.prani@gmail.com>
References: <1408388465-26577-1-git-send-email-bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 21:28:15 +0200
X-Google-Sender-Auth: fe0Y_EyHsrZkK32lVK8VHB7-vCQ
Message-ID: <CAMuHMdXutLPeyDYHdRJ6Heb4vhtg=zMTpwOpKq1h4Yyk8exUSQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build failure for PPC_32
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Gerhard Sittig <gsi@denx.de>, Rob Herring <robh@kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Mon, Aug 18, 2014 at 9:01 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Fix ppc 32 build failure as reported here:
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/11663513/

| arch/powerpc/include/asm/floppy.h:142:20: error: 'isa_bridge_pcidev'
undeclared (first use in this function)
| make[3]: *** [drivers/block/floppy.o] Error 1

The definition of isa_bridge_pcidev is only available if CONFIG_PCI=y...

> The error is that pci_32.o was not being built for PPC_32. Fix error by adding
> it in the Makefile. Tested using the ppc cross compiler.

... so how can adding this make the floppy.h error go away?

Note that arch/powerpc/kernel/Makefile does add
pci_$(CONFIG_WORD_SIZE).o, but only if CONFIG_PCI=y.

So, thanks for your patch, but I don't think your fix is the right solution.

However, drivers/block/floppy.o is enabled by BLK_DEV_FD, which
depends on ARCH_MAY_HAVE_PC_FDC.

arch/powerpc/Kconfig has:

config ARCH_MAY_HAVE_PC_FDC
        bool
        default !PPC_PSERIES || PCI

PCI is not set, and PPC_PSERIES is also not set, so this
defaults to y, which is obviously not correct, as floppy.h needs PCI.

As this symbol doesn't enable floppy support in-se, probably it should just
be:

config ARCH_MAY_HAVE_PC_FDC
        bool
        depends on PCI

This config line was last touched by
commit bed59275810a55500e885cbdc5c2a0507f13c00e
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Sun Mar 4 17:04:44 2007 +1100

    [POWERPC] Allow pSeries to build without CONFIG_PCI

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/powerpc/kernel/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 670c312..3206ba1 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -89,7 +89,7 @@ extra-y                               += vmlinux.lds
>
>  obj-$(CONFIG_RELOCATABLE_PPC32)        += reloc_32.o
>
> -obj-$(CONFIG_PPC32)            += entry_32.o setup_32.o
> +obj-$(CONFIG_PPC32)            += entry_32.o setup_32.o pci_32.o
>  obj-$(CONFIG_PPC64)            += dma-iommu.o iommu.o
>  obj-$(CONFIG_KGDB)             += kgdb.o
>  obj-$(CONFIG_MODULES)          += ppc_ksyms.o

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
