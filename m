Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3AJWuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:50:03 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:59927 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3AJWuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:50:00 -0500
Date: Thu, 10 Jan 2013 17:54:34 -0500
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 05/16] ARM: edma: add AM33XX crossbar event support
Message-ID: <20130110225434.GT14660@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-6-git-send-email-mporter@ti.com>
 <508D12DC.8010400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508D12DC.8010400@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 04:41:24PM +0530, Sekhar Nori wrote:
> On 10/18/2012 6:56 PM, Matt Porter wrote:
> > Adds support for the per-EDMA channel event mux. This is required
> > for any peripherals using DMA crossbar mapped events.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/common/edma.c             |   63 +++++++++++++++++++++++++++++++++++-
> >  include/linux/platform_data/edma.h |    1 +
> >  2 files changed, 63 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> > index 6d2a590..b761b7a 100644
> > --- a/arch/arm/common/edma.c
> > +++ b/arch/arm/common/edma.c
> > @@ -1425,6 +1425,53 @@ static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> >  	return 0;
> >  }
> >  
> > +static int edma_xbar_event_map(struct device *dev,
> > +			       struct device_node *node,
> > +			       struct edma_soc_info *pdata, int len)
> > +{
> > +	int ret = 0;
> > +	int i;
> > +	struct resource res;
> > +	void *xbar;
> > +	s16 (*xbar_chans)[2];
> > +	u32 shift, offset, mux;
> > +
> > +	xbar_chans = devm_kzalloc(dev,
> > +				  len/sizeof(s16) + 2*sizeof(s16),
> > +				  GFP_KERNEL);
> > +	if (!xbar_chans)
> > +		return -ENOMEM;
> > +
> > +	ret = of_address_to_resource(node, 1, &res);
> > +	if (IS_ERR_VALUE(ret))
> > +		return -EIO;
> > +
> > +	xbar = devm_ioremap(dev, res.start, resource_size(&res));
> > +	if (!xbar)
> > +		return -EIO;
> 
> -ENOMEM is more appropiate for ioremap failures.

Fixed in v4.

> 
> > +
> > +	ret = edma_of_read_u32_to_s16_array(node,
> > +					    "ti,edma-xbar-event-map",
> > +					    (s16 *)xbar_chans,
> > +					    len/sizeof(u32));
> > +	if (IS_ERR_VALUE(ret))
> > +		return -EIO;
> > +
> > +	for (i = 0; xbar_chans[i][0] != -1; i++) {
> > +		shift = (xbar_chans[i][1] % 4) * 8;
> > +		offset = xbar_chans[i][1] >> 2;
> > +		offset <<= 2;
> > +		mux = __raw_readl((void *)((u32)xbar + offset));
> 
> Dont use __raw* variants of io accessors. There will be ordering issues
> on ARMv7.

Fixed in v4.

> 
> > +		mux &= (~(0xff << shift));
> > +		mux |= (xbar_chans[i][0] << shift);
> 
> Unnecessary parens above.

Fixed in v4.

> 
> > +		__raw_writel(mux, (void *)((u32)xbar + offset));
> > +	}
> > +
> > +	pdata->xbar_chans = xbar_chans;
> > +
> > +	return 0;
> > +}
> > +
> >  static int edma_of_parse_dt(struct device *dev,
> >  			    struct device_node *node,
> >  			    struct edma_soc_info *pdata)
> > @@ -1453,7 +1500,6 @@ static int edma_of_parse_dt(struct device *dev,
> >  	pdata->n_slot = value;
> >  
> >  	pdata->n_cc = 1;
> > -	/* This is unused */
> 
> The comment should have not been part of 4/16?

Correct. I moved the change to the correct patch in v4.

> 
> Thanks,
> Sekhar
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
