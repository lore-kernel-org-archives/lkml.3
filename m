Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3CZRAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:00:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:51102 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3CZRAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="219083107"
Message-ID: <1364317183.6652.31.camel@smile>
Subject: Re: [PATCH v2 3/4] dw_dmac: make wrapper on
 of_dma_controller_register()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Tue, 26 Mar 2013 18:59:43 +0200
In-Reply-To: <5151B91B.7060404@metafoo.de>
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1364309637-25860-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <5151B91B.7060404@metafoo.de>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 16:04 +0100, Lars-Peter Clausen wrote: 
> On 03/26/2013 03:53 PM, Andy Shevchenko wrote:
> > This patch introduces new method dw_dma_of_controller_register() and adds
> > checks of the of_node presence together with CONFIG_OF before calling the
> > wrapper. It helps to distinguish the real -ENODEV return code of fake one when
> > of_dma_controller_register is not implemented.
> 
> If CONFIG_OF is not set the of_node of the device will always be NULL. Which
> means of_dma_controller_register() will only be called if it is implemented.
> So you'll never get the -ENODEV from the of_dma_controller_register() stub.

Thanks for clarification, I'll update the patch.


> 
> - Lars
> 
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 274fd7d..c1f017b 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -1303,6 +1303,16 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
> >  	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
> >  }
> >  
> > +static void dw_dma_of_controller_register(struct dw_dma *dw)
> > +{
> > +	struct device *dev = dw->dma.dev;
> > +	int err;
> > +
> > +	err = of_dma_controller_register(dev->of_node, dw_dma_of_xlate, dw);
> > +	if (err)
> > +		dev_err(dev, "could not register of_dma_controller\n");
> > +}
> > +
> >  /* --------------------- Cyclic DMA API extensions -------------------- */
> >  
> >  /**
> > @@ -1843,13 +1853,8 @@ static int dw_probe(struct platform_device *pdev)
> >  
> >  	dma_async_device_register(&dw->dma);
> >  
> > -	if (pdev->dev.of_node) {
> > -		err = of_dma_controller_register(pdev->dev.of_node,
> > -						 dw_dma_of_xlate, dw);
> > -		if (err && err != -ENODEV)
> > -			dev_err(&pdev->dev,
> > -				"could not register of_dma_controller\n");
> > -	}
> > +	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
> > +		dw_dma_of_controller_register(dw);
> >  
> >  	return 0;
> >  }
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
