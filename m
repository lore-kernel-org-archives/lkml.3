Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3AXIBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:01:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:21620 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3AXIBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:01:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="281557144"
Message-ID: <1359014483.12502.94.camel@smile>
Subject: Re: [PATCH v2 4/4] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Thu, 24 Jan 2013 10:01:23 +0200
In-Reply-To: <CAOh2x=mx8n53pU42Xx+J3VgMg+ZAWnSNyuDB-2nm5K67MnMTyQ@mail.gmail.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358955452-20960-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mx8n53pU42Xx+J3VgMg+ZAWnSNyuDB-2nm5K67MnMTyQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 10:37 +0530, Viresh Kumar wrote: 
> On Wed, Jan 23, 2013 at 9:07 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> 
> >  static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >  {
> >         dma_addr_t llp;
> > @@ -410,6 +441,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >                          */
> >                         desc = dwc_first_active(dwc);
> >
> > +                       dwc_update_residue(dwc, desc);
> > +
> >                         if (dwc->tx_node_active != &desc->tx_list) {
> >                                 child = to_dw_desc(dwc->tx_node_active);
> 
> Is there a point updating residue here? I don't have a very good knowledge of
> nollp transfers but this is what i know...
> 
> The above "if" will pass if we are still doing transfers and fail if
> all transfers are done.
> After the end of each LLI we receive an interrupt, where we queue next
> LLI. Better
> would be to initialize dwc->residue at dwc_dostart() with total
> length, start decrementing
> it with desc->len for every lli interrupt we get 

It's mostly okay, but we have to handle few cases:
- we have only first (master) descriptor
- we have a chain of the descriptors: master + children
- we have finished last transfer

>From my point of view we can't fully get rid of dwc_update_residue(),
but modify it a bit (drop away for loop).

> and if call for
> getting residue comes in
> middle of transfer, simple return residue - dwc_get_sent(desc) without
> updating residue
> field...

Where? In the tx_status to call something which returns dwc->residue -
dwc_get_sent() ?

> 
> > @@ -436,6 +469,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >
> >         if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
> >                 dev_vdbg(chan2dev(&dwc->chan), "%s: soft LLP mode\n", __func__);
> > +
> > +               dwc_update_residue(dwc, dwc_first_active(dwc));
> > +
> 
> same is applicable here too and so you can get rid of
> dwc_update_residue() routine.

Same thoughts as above are applicable to this.

> >                 spin_unlock_irqrestore(&dwc->lock, flags);
> >                 return;
> >         }
> > @@ -444,6 +480,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >                         (unsigned long long)llp);
> >
> >         list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
> > +               /* initial residue value */
> > +               dwc->residue = desc->total_len;
> > +
> >                 /* check first descriptors addr */
> >                 if (desc->txd.phys == llp) {
> >                         spin_unlock_irqrestore(&dwc->lock, flags);
> > @@ -453,16 +492,21 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >                 /* check first descriptors llp */
> >                 if (desc->lli.llp == llp) {
> >                         /* This one is currently in progress */
> > +                       dwc->residue -= dwc_get_sent(dwc);
> >                         spin_unlock_irqrestore(&dwc->lock, flags);
> >                         return;
> >                 }
> >
> > -               list_for_each_entry(child, &desc->tx_list, desc_node)
> > +               dwc->residue -= desc->len;
> > +               list_for_each_entry(child, &desc->tx_list, desc_node) {
> >                         if (child->lli.llp == llp) {
> >                                 /* Currently in progress */
> > +                               dwc->residue -= dwc_get_sent(dwc);
> >                                 spin_unlock_irqrestore(&dwc->lock, flags);
> >                                 return;
> >                         }
> > +                       dwc->residue -= child->len;
> > +               }
> >
> >                 /*
> >                  * No descriptors so far seem to be in progress, i.e.
> > @@ -1058,6 +1102,7 @@ dwc_tx_status(struct dma_chan *chan,
> >               struct dma_tx_state *txstate)
> >  {
> >         struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
> > +       unsigned long           flags;
> >         enum dma_status         ret;
> >
> >         ret = dma_cookie_status(chan, cookie, txstate);
> > @@ -1067,8 +1112,12 @@ dwc_tx_status(struct dma_chan *chan,
> >                 ret = dma_cookie_status(chan, cookie, txstate);
> >         }
> >
> > +       spin_lock_irqsave(&dwc->lock, flags);
> > +
> 
> why do you need locking here?

What about the case when one CPU is getting an interrupt and runs
scan_descriptors when the other, for example, in the middle of
tx_status? So, I'm afraid the dma_set_residue(txstate, dwc->residue) is
not atomic and we might end up with random numbers here.

> >         if (ret != DMA_SUCCESS)
> > -               dma_set_residue(txstate, dwc_first_active(dwc)->len);
> > +               dma_set_residue(txstate, dwc->residue);
> > +
> > +       spin_unlock_irqrestore(&dwc->lock, flags);
> >
> >         if (dwc->paused)
> >                 return DMA_PAUSED;
> > diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> > index 833b4cf..88dd8eb 100644
> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -203,6 +203,7 @@ struct dw_dma_chan {
> >         struct list_head        active_list;
> >         struct list_head        queue;
> >         struct list_head        free_list;
> > +       u32                     residue;
> >         struct dw_cyclic_desc   *cdesc;
> >
> >         unsigned int            descs_allocated;

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
