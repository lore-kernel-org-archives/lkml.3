Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbaGYIXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:23:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:10376 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaGYIW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="575280529"
Date: Fri, 25 Jul 2014 11:22:49 +0300
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
Message-ID: <20140725082249.GX1857@lahna.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
 <20140724140620.GP1857@lahna.fi.intel.com>
 <20140725071138.GU1857@lahna.fi.intel.com>
 <5574058.fMy2hcvT92@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5574058.fMy2hcvT92@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 09:58:42AM +0200, Arnd Bergmann wrote:
> On Friday 25 July 2014 10:11:38 Mika Westerberg wrote:
> > On Thu, Jul 24, 2014 at 05:06:20PM +0300, Mika Westerberg wrote:
> > > > On a related note, there seems to be a bug in this driver, which
> > > > attempts to set the slave_id through dmaengine_slave_config(), which
> > > > is wrong in both cases, ACPI and filter functions.
> > > 
> > > Good point. We will fix this, thanks.
> > 
> > I take that back. How we are supposed to set the slave_id if we don't
> > have request line information available (from ACPI or DT)?
> 
> If you don't have the request line information, you are screwed and you
> can't set it from either the filter function or slave_config.
> 
> However, it looks like you do have it, at least this is what the
> code tells me:
> 
> static struct pxa_spi_info spi_info_configs[] = {
>         [PORT_CE4100] = {
> 		...
>         },
>         [PORT_BYT] = {
>                 .type = LPSS_SSP,
>                 .port_id = 0,
>                 .num_chipselect = 1,
>                 .tx_slave_id = 0,
>                 .tx_chan_id = 0,
>                 .rx_slave_id = 1,
>                 .rx_chan_id = 1,
>         },
> };

That's right we do have it.

> All you need to do is change your filter function to take the
> slave id from pxa_spi_info and stick it in there, e.g.
> 
> static bool pxa2xx_spi_dw_dma_filter(struct dma_chan *chan, void *param)
> {       
>         const struct pxa2xx_spi_master *pdata = param;
>         struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
>         
>         dwc->request_line = fargs->req;
>         dwc->src_master = 0;
>         dwc->dst_master = 0;
>         
>         return 1;
> }           

Oh man. That makes pxa2xx_spi dependent on a certain specific DMA engine
driver.

> Note that the filter function by definition is specific to the dma
> controller, not the dma slave (that's why most people define it in
> the dmaengine driver), and the pxa2xx_spi_dma_filter() function used
> in spi-pxa2xx-dma.c looks like it was written for another dma engine:

I wonder what's the rationale that passing slave_id with
dma_slave_config is wrong? The current code works fine with that and is
is independent of the DMA engine driver (even though we know that it is
going to be dw-dma).

The dw-dma handles slave_id in its implementation of
dmaengine_slave_config().
