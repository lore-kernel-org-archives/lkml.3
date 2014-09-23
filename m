Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaIWMbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:31:11 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65023 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaIWMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:31:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingchang Lu <jingchang.lu@freescale.com>, vinod.koul@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G support in big-endian model
Date: Tue, 23 Sep 2014 14:30:30 +0200
Message-ID: <45444544.Xl4NeUiTm0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>
References: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W0su7TT2nHlSeJgJyqi7A9e+7sS7e8PGMIePJnCV6gG
 iT09E/A0W1FeQP1yQ5KMb+XUOEPoSCZbC++2wCm5jr27dmHU0L
 XYP/ZkUgSSpGqNyFfQ7IMvOirG5z9reCk4c1+4xUgjscf8kbJm
 DA5cvtdjVOZWrJ71j5FbyZu0ES2weDsVDrN8R6y6YiwH7Cu+U6
 lSvrb5yP3kVDvGGBZU5ZBroDlP5xxERcwLEyY5ip+Lv3gn7m3E
 IVF0Uz5SDT6XcDbWtODoa/1qqQ6hF68QMDZKz/+Udc5UqAT0Jh
 jiK//dJQ/Pq0L5pHnzf3kRHmn+zf0qqSSW543QQmP+cF5M4BdZ
 Meuhlw+N/ln9xdTn1Q7s=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 17:15:19 Jingchang Lu wrote:
> @@ -459,20 +480,27 @@ static void fill_tcd_params(struct fsl_edma_engine *edma,
>         u16 csr = 0;
>  
>         /*
> -        * eDMA hardware SGs require the TCD parameters stored in memory
> -        * the same endian as the eDMA module so that they can be loaded
> -        * automatically by the engine
> +        * eDMA hardware SGs requires the TCDs to be auto loaded
> +        * in the same endian as the core whenver the eDAM engine's
> +        * register endian. So we don't swap the value, waitting
> +        * for fsl_set_tcd_params doing the swap.
>          */

This makes no sense: how would the eDMA hardware know what endianess
the CPU is using to write this data? Have you tried this running on
the same hardware with both big-endian and little-endian kernels?

Also, you access this as little-endian data unconditionally rather
than cpu-endian as the comment suggests, maybe that is what you meant
here?

> -       edma_writel(edma, src, &(tcd->saddr));
> -       edma_writel(edma, dst, &(tcd->daddr));
> -       edma_writew(edma, attr, &(tcd->attr));
> -       edma_writew(edma, EDMA_TCD_SOFF_SOFF(soff), &(tcd->soff));
> -       edma_writel(edma, EDMA_TCD_NBYTES_NBYTES(nbytes), &(tcd->nbytes));
> -       edma_writel(edma, EDMA_TCD_SLAST_SLAST(slast), &(tcd->slast));
> -       edma_writew(edma, EDMA_TCD_CITER_CITER(citer), &(tcd->citer));
> -       edma_writew(edma, EDMA_TCD_DOFF_DOFF(doff), &(tcd->doff));
> -       edma_writel(edma, EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga), &(tcd->dlast_sga));
> -       edma_writew(edma, EDMA_TCD_BITER_BITER(biter), &(tcd->biter));
> +       writel(src, &(tcd->saddr));
> +       writel(dst, &(tcd->daddr));
> +
> +       writew(attr, &(tcd->attr));

You seem to have another preexisting bug: The tcd pointer actually does not
point to mmio registers here at all, but instead points to memory that
has been returned from dma_pool_alloc. It is not valid to use writel()
on such memory, that is only meant to work on real MMIO registers.

You should use regular assignments to the registers here, e.g.
	
	tcd->saddr = cpu_to_le32(src);
	tcd->daddr = cpu_to_le32(dst);
	...

	Arnd
