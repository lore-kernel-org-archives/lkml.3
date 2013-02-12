Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322Ab3BLQSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:18:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:44476 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab3BLQSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:18:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="201515947"
Date: Tue, 12 Feb 2013 07:53:34 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130212155334.GK3789@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:29:43AM +0530, Viresh Kumar wrote:
> Next time, please direct these mails to my Linaro id :)
> 
> On Mon, Jan 28, 2013 at 4:34 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On some hardware configurations we have got the request line with the offset.
> > The patch introduces convert_slave_id() helper for that cases. The request line
> > base is got from the platform device resources provided by the IORESOURCE_DMA
> > type.
> 
> @Vinod: Is IORESOURCE_DMA suitable for this purpose?
Looks unlikely...

But why do we need this in first place?

I know this is due to common platform probe. Clearly one size not fitting all.
If you had dedicated PCI probe you wouldnt worrry right?

--
~Vinod
> 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c      |   13 +++++++++++++
> >  drivers/dma/dw_dmac_regs.h |    1 +
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 3155c11..8484ca1 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -995,6 +995,13 @@ static inline void convert_burst(u32 *maxburst)
> >                 *maxburst = 0;
> >  }
> >
> > +static inline void convert_slave_id(struct dw_dma_chan *dwc)
> > +{
> > +       struct dw_dma *dw = to_dw_dma(dwc->chan.device);
> > +
> > +       dwc->dma_sconfig.slave_id -= dw->request_line_base;
> > +}
> > +
> >  static int
> >  set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
> >  {
> > @@ -1009,6 +1016,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
> >
> >         convert_burst(&dwc->dma_sconfig.src_maxburst);
> >         convert_burst(&dwc->dma_sconfig.dst_maxburst);
> > +       convert_slave_id(dwc);
> >
> >         return 0;
> >  }
> > @@ -1717,6 +1725,11 @@ static int dw_probe(struct platform_device *pdev)
> >                 memcpy(dw->data_width, pdata->data_width, 4);
> >         }
> >
> > +       /* Get the base request line if set */
> > +       io = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> > +       if (io)
> > +               dw->request_line_base = (unsigned int)io->start;
> > +
> 
> How will it work in case of DT?
> 
> >         /* Calculate all channel mask before DMA setup */
> >         dw->all_chan_mask = (1 << nr_channels) - 1;
> >
> > diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> > index 88dd8eb..3eeb766 100644
> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -248,6 +248,7 @@ struct dw_dma {
> >         /* hardware configuration */
> >         unsigned char           nr_masters;
> >         unsigned char           data_width[4];
> > +       unsigned int            request_line_base;
> >
> >         struct dw_dma_chan      chan[0];
> >  };
> 
> --
> viresh
