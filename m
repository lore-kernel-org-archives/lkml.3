Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3A3Gfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:35:47 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:56687 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3A3Gfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:35:44 -0500
Date: Wed, 30 Jan 2013 01:36:11 -0500
From: Matt Porter <mporter@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 07/14] dmaengine: add
 dma_request_slave_channel_compat()
Message-ID: <20130130063611.GM5256@beef>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
 <1358281974-8411-8-git-send-email-mporter@ti.com>
 <201301232228.46716.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301232228.46716.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 10:28:46PM +0000, Arnd Bergmann wrote:
> On Tuesday 15 January 2013, Matt Porter wrote:
> > Adds a dma_request_slave_channel_compat() wrapper which accepts
> > both the arguments from dma_request_channel() and
> > dma_request_slave_channel(). Based on whether the driver is
> > instantiated via DT, the appropriate channel request call will be
> > made.
> > 
> > This allows for a much cleaner migration of drivers to the
> > dmaengine DT API as platforms continue to be mixed between those
> > that boot using DT and those that do not.
> 
> I noticed today some drivers in linux-next that rely on this patch,
> but the patch itself still missing from -next.
> 
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -1047,6 +1047,16 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
> >  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
> >  struct dma_chan *net_dma_find_channel(void);
> >  #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> > +static inline struct dma_chan
> > +*dma_request_slave_channel_compat(dma_cap_mask_t mask, dma_filter_fn fn,
> > +                                 void *fn_param, struct device *dev,
> > +                                 char *name)
> > +{
> > +       if (dev->of_node)
> > +               return dma_request_slave_channel(dev, name);
> > +       else
> > +               return dma_request_channel(mask, fn, fn_param);
> > +}
> 
> Hmm, dma_request_channel is actually a macro that passes mask by reference,
> presumably because it can get modified by the filter function. Also, there
> may be cases where we do have an of_node but don't use the dma binding
> yet, or where dma_request_slave_channel doesn't actually use DT information
> but rather one of the other methods that Vinod was talking about adding.
> 
> I think what it should look like instead is the below.

Yes, looks correct now, thanks. I've incorporated it into v6.

-Matt

> 
> 	Arnd
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index bfcdecb..b6ffd7d 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -993,6 +993,19 @@ static inline void dma_release_channel(struct dma_chan *chan)
>  }
>  #endif
>  
> +static inline struct dma_chan *__dma_request_slave_channel_compat(dma_cap_mask_t *mask,
> +				dma_filter_fn fn, void *fn_param, struct device *dev,
> +				 char *name)
> +{
> +	struct dma_chan *chan;
> +
> +	chan = dma_request_slave_channel(dev, name);
> +	if (chan)
> +		return chan;
> +
> +	return __dma_request_channel(mask, fn, fn_param);
> +}
> +
>  /* --- DMA device --- */
>  
>  int dma_async_device_register(struct dma_device *device);
> @@ -1001,6 +1014,8 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
>  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
>  struct dma_chan *net_dma_find_channel(void);
>  #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> +#define dma_request_slave_channel_compat(mask, x, y, dev, name) \
> +	 __dma_request_slave_channel_compat(&(mask), x, y, dev, name)
>  
>  /* --- Helper iov-locking functions --- */
>  
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
