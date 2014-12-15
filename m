Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLOJoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:44:38 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:50976 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbaLOJoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:44:32 -0500
MIME-Version: 1.0
In-Reply-To: <1418422034-17099-14-git-send-email-cernekee@gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com> <1418422034-17099-14-git-send-email-cernekee@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 15 Dec 2014 10:43:58 +0100
Message-ID: <CAOiHx=nX9jJEFZmkA-1fWj47whq85wj-ZgUxnZBwpAYDUfAO4w@mail.gmail.com>
Subject: Re: [PATCH V5 13/23] MIPS: BMIPS: Flush the readahead cache after DMA
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Brian Norris <computersforpeace@gmail.com>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:07 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
> BMIPS 3300/435x/438x CPUs have a readahead cache that is separate from
> the L1/L2.  During a DMA operation, accesses adjacent to a DMA buffer
> may cause parts of the DMA buffer to be prefetched into the RAC.  To
> avoid possible coherency problems, flush the RAC upon DMA completion.

According to what I have, any cpu [d-]cache invalidate operation
should already flush the full RAC unless explicitly disabled in the
RAC configuration - is this intended as an optimization/shortcut?

> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  arch/mips/mm/dma-default.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
> index af5f046..ee6d12c 100644
> --- a/arch/mips/mm/dma-default.c
> +++ b/arch/mips/mm/dma-default.c
> @@ -18,6 +18,7 @@
>  #include <linux/highmem.h>
>  #include <linux/dma-contiguous.h>
>
> +#include <asm/bmips.h>
>  #include <asm/cache.h>
>  #include <asm/cpu-type.h>
>  #include <asm/io.h>
> @@ -69,6 +70,18 @@ static inline struct page *dma_addr_to_page(struct device *dev,
>   */
>  static inline int cpu_needs_post_dma_flush(struct device *dev)
>  {

The place for it seems a bit misplaced; I would not expect
cpu_needs_post_dma_flush() to have any side effects.

> +       if (boot_cpu_type() == CPU_BMIPS3300 ||
> +           boot_cpu_type() == CPU_BMIPS4350 ||
> +           boot_cpu_type() == CPU_BMIPS4380) {
> +               void __iomem *cbr = BMIPS_GET_CBR();
> +
> +               /* Flush stale data out of the readahead cache */
> +               __raw_writel(0x100, cbr + BMIPS_RAC_CONFIG);

Hm, according to what I have, bits [6:0] of RAC_CONFIG are R/W
configuration bits, and this will overwrite them:

CFE> dm 0xff400000 4
ff400000: 02a07015                                        ..p.
CFE> sm 0xff400000 0x100 4
ff400000: 02a00000                                        ....

(As far as I can tell, RAC was previously enabled for instruction
cache misses , and now isn't any more for anything, so effectively
disabled?)

Also for BMIPS4350 (and I guess 4380) there seems to be a second
RAC_CONFIG register at 0x8, I guess for the second thread? Does it
need flushing, too?

> +               __raw_readl(cbr + BMIPS_RAC_CONFIG);
> +
> +               return 0;
> +       }
> +
>         return !plat_device_is_coherent(dev) &&
>                (boot_cpu_type() == CPU_R10000 ||
>                 boot_cpu_type() == CPU_R12000 ||
> --
> 2.1.1


Jonas
