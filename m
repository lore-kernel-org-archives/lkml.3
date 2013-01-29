Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3A2FS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:18:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:62740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3A2FSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:18:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="283386808"
Date: Tue, 29 Jan 2013 07:22:47 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
Message-ID: <20130129052247.GH2239@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
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

We had a discusssion about this with Andy as well. The thing is that there
is no way in current resource to pass DMA request line numbers supported by
the controller to the driver in a generic way. We on the other hand have to
deal this somehow as we have a shared DMA controller on Lynxpoint where the
offset will start from 16 (but it might be something else as well).

Is there something which limits the usage of IORESOUCE_DMA to be only
usable for ISA DMA channels?

We have made supporting code that currently sits in linux-pm/linux-next
tree that parses an ACPI CSRT table and creates the platform devices with
suitable resources here: 13176bbf183c8 (ACPI: add support for CSRT table).

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

Can't the DT version do the same thing and pass IORESOURCE_DMA to the
driver? Or we can check dev->of_node and parse it directly from DT instead
of resource.
