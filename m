Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaHRU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:58:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46653 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHRU6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:58:17 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 16:57:45 -0400
Message-ID: <CAJhHMCCdXThXebuPt-xwYc220C--6zpzBCg-0YiBxXQyUtz2PQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build failure for PPC_32
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 3:28 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Pranith,
>
> On Mon, Aug 18, 2014 at 9:01 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> > Fix ppc 32 build failure as reported here:
> >
> > http://kisskb.ellerman.id.au/kisskb/buildresult/11663513/
>
> | arch/powerpc/include/asm/floppy.h:142:20: error: 'isa_bridge_pcidev'
> undeclared (first use in this function)
> | make[3]: *** [drivers/block/floppy.o] Error 1
>
> The definition of isa_bridge_pcidev is only available if CONFIG_PCI=y...
>
> > The error is that pci_32.o was not being built for PPC_32. Fix error by adding
> > it in the Makefile. Tested using the ppc cross compiler.
>
> ... so how can adding this make the floppy.h error go away?


So the definition which you are talking about within CONFIG_PCI=y is
an extern definition

arch/powerpc/include/asm/ppc-pci.h:28:extern struct pci_dev *isa_bridge_pcidev;

If you build pci_32.o unconditionally, there is an

EXPORT_SYMBOL(isa_bridge_pcidev);

which supplies the required symbol.

But yes, you are right in that we should not unconditionally compile
pci_32.o. Making floppy depend on PCI is the right thing to do.
However,

>
>
> Note that arch/powerpc/kernel/Makefile does add
> pci_$(CONFIG_WORD_SIZE).o, but only if CONFIG_PCI=y.
>
> So, thanks for your patch, but I don't think your fix is the right solution.
>
> However, drivers/block/floppy.o is enabled by BLK_DEV_FD, which
> depends on ARCH_MAY_HAVE_PC_FDC.
>
> arch/powerpc/Kconfig has:
>
> config ARCH_MAY_HAVE_PC_FDC
>         bool
>         default !PPC_PSERIES || PCI
>
> PCI is not set, and PPC_PSERIES is also not set, so this
> defaults to y, which is obviously not correct, as floppy.h needs PCI.
>
> As this symbol doesn't enable floppy support in-se, probably it should just
> be:
>
> config ARCH_MAY_HAVE_PC_FDC
>         bool
>         depends on PCI


the right thing I guess here is to depend on !PPC_PSERIES && PCI since
I guess pSeries does not support floppy.h (hence the original
condition check?).

Note that there are other unrelated errors which do not let me
complete the PPC 32 build with the config there yet. I just verified
this symbol error.

>
> This config line was last touched by
> commit bed59275810a55500e885cbdc5c2a0507f13c00e
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Sun Mar 4 17:04:44 2007 +1100
>
>     [POWERPC] Allow pSeries to build without CONFIG_PCI
>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Signed-off-by: Paul Mackerras <paulus@samba.org>


-- 
Pranith
