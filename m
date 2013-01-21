Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3AUJqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:46:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:23486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3AUJqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:46:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="279690593"
Message-ID: <1358761551.12502.39.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 21 Jan 2013 11:45:51 +0200
In-Reply-To: <20130121084924.GA26562@intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130121084924.GA26562@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 00:49 -0800, Vinod Koul wrote: 
> On Mon, Jan 21, 2013 at 11:00:44AM +0200, Andy Shevchenko wrote:
> > Currently the driver returns full length of the active descriptor which is
> > wrong. We have to go throught the active descriptor and sum up the length of
> > unsent children in the chain along with the actual data in the DMA channel
> why do you mean by children here?

The list nodes chained under (active) &desc->tx_list.

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
> >  	return NULL;
> >  }
> >  
> > +/* --------------------- Calculate residue ---------------------------- */
> > +
> > +static inline size_t dwc_get_rest(struct dw_dma_chan *dwc, struct dw_desc *desc)
> > +{
> > +	enum dma_transfer_direction direction = dwc->direction;
> > +
> > +	if (direction == DMA_MEM_TO_DEV || direction == DMA_MEM_TO_MEM)
> > +		return desc->len - (channel_readl(dwc, SAR) - desc->lli.sar);
> > +	else if (direction == DMA_DEV_TO_MEM)
> > +		return desc->len - (channel_readl(dwc, DAR) - desc->lli.dar);
> > +
> > +	return 0;
> hmmm, why not use BLOCK_TS value. That way you dont need to look at direction
> and along with burst can easily calculate residue...

Do you mean to read CTL hi/lo and do

desc->len - ctlhi.block_ts * ctllo.src_tr_width?

I think it could be not precise when memory-to-peripheral transfer is
going on. In that case you probably will have src_tr_width like 32 bits,
meanwhile peripheral may receive only byte stream.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
