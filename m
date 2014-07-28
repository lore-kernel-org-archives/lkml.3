Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaG1J2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:28:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:1406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaG1J2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:28:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="579942479"
Date: Mon, 28 Jul 2014 12:28:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Message-ID: <20140728092808.GI1857@lahna.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
 <20140725090714.GY1857@lahna.fi.intel.com>
 <20140725095559.GA1857@lahna.fi.intel.com>
 <5426556.OzZIXLrofJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5426556.OzZIXLrofJ@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:19:02PM +0200, Arnd Bergmann wrote:
> On Friday 25 July 2014 12:55:59 Mika Westerberg wrote:
> > On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> > > On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > > > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> > > > > > All you need to do is change your filter function to take the
> > > > > > slave id from pxa_spi_info and stick it in there, e.g.
> > > > > > 
> > > > > > static bool pxa2xx_spi_dw_dma_filter(struct dma_chan *chan, void *param)
> > > > > > {       
> > > > > >         const struct pxa2xx_spi_master *pdata = param;
> > > > > >         struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> > > > > >         
> > > > > >         dwc->request_line = fargs->req;
> > > > > >         dwc->src_master = 0;
> > > > > >         dwc->dst_master = 0;
> > > > > >         
> > > > > >         return 1;
> > > > > > }           
> > > > > 
> > > > > Oh man. That makes pxa2xx_spi dependent on a certain specific DMA engine
> > > > > driver.
> > > > 
> > > > I think you can improve this by putting the filter function (and a pointer
> > > > to it) into the pxa2xx_spi_master data provided by the PCI driver.
> > > 
> > > Indeed, that looks better. It still makes the PCI part of the driver
> > > dependent on a particular DMA engine driver but is certainly better than
> > > the core pxa2xx_spi driver.
> > 
> > Something like this?
> > 
> > Hock Leong / Chiaue Ee, are you able to check if this works on your BYT
> > machines?
> 
> I think I found a small bug, and one detail that could be improved.
> 
> > @@ -321,12 +310,14 @@ int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
> >  		return -ENOMEM;
> >  
> >  	drv_data->tx_chan = dma_request_slave_channel_compat(mask,
> > -				pxa2xx_spi_dma_filter, pdata, dev, "tx");
> > +				pdata->dma_filter, pdata->dma_filter_param,
> > +				dev, "tx");
> >  	if (!drv_data->tx_chan)
> >  		return -ENODEV;
> 
> If you change this part to pass '(void *)info->tx_slave_id' rather than
> pdata->dma_filter_param, you can simplify the next code:

OK

> > +static bool pxa2xx_spi_pci_dma_filter(struct dma_chan *chan, void *param)
> > +{
> > +	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> > +	const struct pxa_spi_info *info = param;
> > +
> > +	if (chan->chan_id == info->tx_chan_id)
> > +		dwc->request_line = info->tx_slave_id;
> > +	else if (chan->chan_id == info->rx_chan_id)
> > +		dwc->request_line = info->rx_slave_id;
> > +	else
> > +		return false;
> > +
> > +	dwc->src_master = 0;
> > +	dwc->dst_master = 0;
> > +
> > +	return true;
> > +}
> 
> to disregard the tx_chan_id, which is really arbitrary as far as I can tell.
> 
> What I think you got wrong here (by following my bad advice) is the master
> number. Looking at the code for dw_dma, I think src_master needs to be '1'
> for your driver.

Right, I just copied your example. I'll change it to '1' in the next
revision.
