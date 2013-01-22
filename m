Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3AVJWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:22:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:62197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3AVJWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:22:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="280431887"
Message-ID: <1358846546.12502.57.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Tue, 22 Jan 2013 11:22:26 +0200
In-Reply-To: <CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 13:41 +0530, Viresh Kumar wrote: 
> On Mon, Jan 21, 2013 at 2:30 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Currently the driver returns full length of the active descriptor which is
> > wrong. We have to go throught the active descriptor and sum up the length of
> > unsent children in the chain along with the actual data in the DMA channel
> > registers.
> >
> > The cyclic case is not handled by this patch due to len field in the descriptor
> > structure is left untouched by the original code.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 92 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index d1b9ba2..4325c68 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -941,6 +941,97 @@ err_desc_get:
> >         return NULL;
> >  }
> >
> > +/* --------------------- Calculate residue ---------------------------- */
> > +
> > +static inline size_t dwc_get_rest(struct dw_dma_chan *dwc, struct dw_desc *desc)
> > +{
> > +       enum dma_transfer_direction direction = dwc->direction;
> > +
> > +       if (direction == DMA_MEM_TO_DEV || direction == DMA_MEM_TO_MEM)
> > +               return desc->len - (channel_readl(dwc, SAR) - desc->lli.sar);
> > +       else if (direction == DMA_DEV_TO_MEM)
> > +               return desc->len - (channel_readl(dwc, DAR) - desc->lli.dar);
> > +
> > +       return 0;
> > +}
> 
> I agree with Vinod on this routine.

I'm checking this now. But on first glance his proposal is quite better.

> > +static inline size_t dwc_get_residue_in_llp(struct dw_dma_chan *dwc,
> > +                                           struct list_head *active,
> > +                                           struct list_head *head)
> > +{
> > +       size_t residue = dwc_get_rest(dwc, to_dw_desc(active));
> > +
> > +       do {
> > +               active = active->next;
> > +               if (active == head)
> > +                       break;
> > +               residue += to_dw_desc(active)->len;
> > +       } while (true);
> > +
> > +       return residue;
> > +}
> > +
> > +static size_t dwc_calc_residue_llp_hw(struct dw_dma_chan *dwc)
> > +{
> > +       struct dw_desc *desc = dwc_first_active(dwc);
> > +       struct list_head *head = &desc->tx_list, *active;
> > +       dma_addr_t llp = channel_readl(dwc, LLP);
> > +
> > +       /* The transfer didn't start yet */
> > +       if (unlikely(desc->txd.phys == llp))
> > +               return desc->len;
> > +
> > +       /* First descriptor is active */
> > +       if (desc->lli.llp == llp)
> > +               return dwc_get_rest(dwc, desc);
> > +
> > +       /* Somewhere in the middle */
> > +       list_for_each(active, head)
> > +               if (to_dw_desc(active)->lli.llp == llp)
> > +                       return dwc_get_residue_in_llp(dwc, active, head);
> > +
> > +       return 0;
> > +}
> > +
> > +static size_t dwc_calc_residue_llp_sw(struct dw_dma_chan *dwc)
> > +{
> > +       struct dw_desc *desc = dwc_first_active(dwc);
> > +       struct list_head *head = dwc->tx_list, *active;
> > +
> > +       active = dwc->tx_node_active;
> > +
> > +       /* First node is active */
> > +       if (active == head->next)
> > +               return dwc_get_rest(dwc, desc);
> > +
> > +       /* Last node is active */
> > +       if (active == head)
> > +               return dwc_get_rest(dwc, to_dw_desc(active->prev));
> > +
> > +       /* Somewhere in the middle */
> > +       return dwc_get_residue_in_llp(dwc, active, head);
> > +}
> > +
> > +static size_t dwc_get_residue(struct dw_dma_chan *dwc)
> 
> return u32, that's the type of residue field.

Hmm... I didn't remember where I got size_t for that, but you are right.
I'll fix that across the code.

> 
> > +{
> > +       unsigned long flags;
> > +       size_t residue = 0;
> 
> ditto.
> 
> > +
> > +       spin_lock_irqsave(&dwc->lock, flags);
> > +       if (list_empty(&dwc->active_list)) {
> 
> can this every happen?

In the same way as in dwc_scan_descriptors().
For example when transfer is done.

> > +               spin_unlock_irqrestore(&dwc->lock, flags);
> > +               return 0;
> > +       }
> > +
> > +       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags))
> > +               residue = dwc_calc_residue_llp_sw(dwc);
> > +       else if (!test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
> > +               residue = dwc_calc_residue_llp_hw(dwc);
> 
> Hmm. you return zero for cyclic transfers, shouldn't that be the total
> length instead?

Total length is zero as I mentioned in commit message. The cyclic API
should be fixed separately if someone wants to have such functionality
of it.

> Over that, cyclic case can be handled before taking any locks.

Does the user is responsible to follow specific workflow for cyclic API?
However, it isn't related to current topic. I will move it out of
spinlock.

> > +
> > +       spin_unlock_irqrestore(&dwc->lock, flags);
> > +       return residue;
> > +}
> > +
> >  /*
> >   * Fix sconfig's burst size according to dw_dmac. We need to convert them as:
> >   * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3.
> > @@ -1062,7 +1153,7 @@ dwc_tx_status(struct dma_chan *chan,
> >         }
> >
> >         if (ret != DMA_SUCCESS)
> > -               dma_set_residue(txstate, dwc_first_active(dwc)->len);
> > +               dma_set_residue(txstate, dwc_get_residue(dwc));
> 
> Hmm.. After thinking a bit more on this, i am not sure if what u have done is
> the best way of doing it :(

At least it works for us :-)

> 
> Just before above line got executed, we called dwc_scan_descriptors(), which
> also scans through the llis to see where we are.. What about updating
> first->residue
> there, so that we don't traverse it twice?

The dwc_scan_descriptors traverses the chain and returns immediately if
it found a match. But to calculate residue we have to traverse from that
point to the end of the chain along with current DMA register check.

> >
> >         if (dwc->paused)
> >                 return DMA_PAUSED;


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
