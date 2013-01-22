Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3AVIMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:12:01 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39630 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3AVIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 22 Jan 2013 13:41:58 +0530
X-Google-Sender-Auth: 8jbC_1p-gUgYi5Wj0fJ8YVsDBK0
Message-ID: <CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 2:30 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Currently the driver returns full length of the active descriptor which is
> wrong. We have to go throught the active descriptor and sum up the length of
> unsent children in the chain along with the actual data in the DMA channel
> registers.
>
> The cyclic case is not handled by this patch due to len field in the descriptor
> structure is left untouched by the original code.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 92 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d1b9ba2..4325c68 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -941,6 +941,97 @@ err_desc_get:
>         return NULL;
>  }
>
> +/* --------------------- Calculate residue ---------------------------- */
> +
> +static inline size_t dwc_get_rest(struct dw_dma_chan *dwc, struct dw_desc *desc)
> +{
> +       enum dma_transfer_direction direction = dwc->direction;
> +
> +       if (direction == DMA_MEM_TO_DEV || direction == DMA_MEM_TO_MEM)
> +               return desc->len - (channel_readl(dwc, SAR) - desc->lli.sar);
> +       else if (direction == DMA_DEV_TO_MEM)
> +               return desc->len - (channel_readl(dwc, DAR) - desc->lli.dar);
> +
> +       return 0;
> +}

I agree with Vinod on this routine.

> +static inline size_t dwc_get_residue_in_llp(struct dw_dma_chan *dwc,
> +                                           struct list_head *active,
> +                                           struct list_head *head)
> +{
> +       size_t residue = dwc_get_rest(dwc, to_dw_desc(active));
> +
> +       do {
> +               active = active->next;
> +               if (active == head)
> +                       break;
> +               residue += to_dw_desc(active)->len;
> +       } while (true);
> +
> +       return residue;
> +}
> +
> +static size_t dwc_calc_residue_llp_hw(struct dw_dma_chan *dwc)
> +{
> +       struct dw_desc *desc = dwc_first_active(dwc);
> +       struct list_head *head = &desc->tx_list, *active;
> +       dma_addr_t llp = channel_readl(dwc, LLP);
> +
> +       /* The transfer didn't start yet */
> +       if (unlikely(desc->txd.phys == llp))
> +               return desc->len;
> +
> +       /* First descriptor is active */
> +       if (desc->lli.llp == llp)
> +               return dwc_get_rest(dwc, desc);
> +
> +       /* Somewhere in the middle */
> +       list_for_each(active, head)
> +               if (to_dw_desc(active)->lli.llp == llp)
> +                       return dwc_get_residue_in_llp(dwc, active, head);
> +
> +       return 0;
> +}
> +
> +static size_t dwc_calc_residue_llp_sw(struct dw_dma_chan *dwc)
> +{
> +       struct dw_desc *desc = dwc_first_active(dwc);
> +       struct list_head *head = dwc->tx_list, *active;
> +
> +       active = dwc->tx_node_active;
> +
> +       /* First node is active */
> +       if (active == head->next)
> +               return dwc_get_rest(dwc, desc);
> +
> +       /* Last node is active */
> +       if (active == head)
> +               return dwc_get_rest(dwc, to_dw_desc(active->prev));
> +
> +       /* Somewhere in the middle */
> +       return dwc_get_residue_in_llp(dwc, active, head);
> +}
> +
> +static size_t dwc_get_residue(struct dw_dma_chan *dwc)

return u32, that's the type of residue field.

> +{
> +       unsigned long flags;
> +       size_t residue = 0;

ditto.

> +
> +       spin_lock_irqsave(&dwc->lock, flags);
> +       if (list_empty(&dwc->active_list)) {

can this every happen?

> +               spin_unlock_irqrestore(&dwc->lock, flags);
> +               return 0;
> +       }
> +
> +       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags))
> +               residue = dwc_calc_residue_llp_sw(dwc);
> +       else if (!test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
> +               residue = dwc_calc_residue_llp_hw(dwc);

Hmm. you return zero for cyclic transfers, shouldn't that be the total
length instead?

Over that, cyclic case can be handled before taking any locks.

> +
> +       spin_unlock_irqrestore(&dwc->lock, flags);
> +       return residue;
> +}
> +
>  /*
>   * Fix sconfig's burst size according to dw_dmac. We need to convert them as:
>   * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3.
> @@ -1062,7 +1153,7 @@ dwc_tx_status(struct dma_chan *chan,
>         }
>
>         if (ret != DMA_SUCCESS)
> -               dma_set_residue(txstate, dwc_first_active(dwc)->len);
> +               dma_set_residue(txstate, dwc_get_residue(dwc));

Hmm.. After thinking a bit more on this, i am not sure if what u have done is
the best way of doing it :(

Just before above line got executed, we called dwc_scan_descriptors(), which
also scans through the llis to see where we are.. What about updating
first->residue
there, so that we don't traverse it twice?

>
>         if (dwc->paused)
>                 return DMA_PAUSED;
> --
> 1.7.10.4
>
