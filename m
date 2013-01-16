Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3APJsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:48:45 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33570 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab3APJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:48:43 -0500
MIME-Version: 1.0
In-Reply-To: <1358327443-10562-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358327443-10562-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 16 Jan 2013 15:18:42 +0530
X-Google-Sender-Auth: -IiIKJbozHyG4wIyvgQ0ybraDl8
Message-ID: <CAOh2x=k2M_U_f4ztjCkO5rxGg=-P-5ghHKXPJHNVkWq8=-jqYg@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: switch to use dma_pool API
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 2:40 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> It makes the code cleaner and allows developer not to worry about cache
> coherency issues. The price for this is a bit slower access to the descriptor
> structures.

A good patch to have. But i would write subject as:

DMAENGINE: dw_dmac: Allocate dma descriptors from DMA_COHERENT memory

Currently descriptors are allocated from normal cacheable memory and that slows
down filling the descriptors, as we need to call cache_coherency
routines afterwards.
It would be better to allocate memory for these descriptors from DMA_COHERENT
memory. This would make code much cleaner too.

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> @@ -777,24 +753,17 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,

>         prev->lli.llp = 0;
> -       dma_sync_single_for_device(chan2parent(chan),
> -                       prev->txd.phys, sizeof(prev->lli),
> -                       DMA_TO_DEVICE);
>

delete this blank line too.

>         first->txd.flags = flags;
>         first->len = len;

> @@ -968,9 +929,6 @@ slave_sg_fromdev_fill_desc:
>                 prev->lli.ctllo |= DWC_CTLL_INT_EN;
>
>         prev->lli.llp = 0;
> -       dma_sync_single_for_device(chan2parent(chan),
> -                       prev->txd.phys, sizeof(prev->lli),
> -                       DMA_TO_DEVICE);
>

ditto

>         first->len = total_len;
>
> @@ -1125,7 +1083,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
> +               memset(desc, 0, sizeof(struct dw_desc));
> +

why do we need this? We always fill all fields of this structure, isn't it?

> @@ -1171,14 +1128,10 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
>         spin_unlock_irqrestore(&dwc->lock, flags);
>
>         dev_dbg(chan2dev(chan), "%s: allocated %d descriptors\n", __func__, i);
> -

leave this poor blank line as is :)

>         return i;
>
>  err_desc_alloc:
> -       kfree(desc);
> -
>         dev_info(chan2dev(chan), "only allocated %d descriptors\n", i);
> -

ditto

>         return i;
>  }
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
