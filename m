Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbaGXLSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:18:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:32664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaGXLSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,723,1400050800"; 
   d="scan'208";a="548340684"
Message-ID: <1406200720.8530.4.camel@smile.fi.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, chiauee85@gmail.com
Date: Thu, 24 Jul 2014 14:18:40 +0300
In-Reply-To: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 18:01 +0800, Kweh Hock Leong wrote:
> From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
> 
> Intel LPSS Baytrail supports two DMA controllers and SPI is only
> using one of the DMA controller. During DMA channel request,
> we need to ensure the requested Tx and Rx channels are from the correct
> DMA controller. Thus, we add extra checking in filter callback funtion
> by matching against the DMA controller device name.

I think this is bot good approach.

I already discussed with Mika how we could do this better for devices in
PCI mode. (Seems you have the problem only in PCI, right?)

So, for PCI case you have to get the device with BDF = BD0, where BDF is
Bus:Device:Function triplet for an SPI controller itself.

I don't know if it's good to enable CONFIG_PCI_QUIRKS and tweak
pci_dev_dma_source. In that case you just call pci_get_dma_source() and
get a PCI device of the DMA.

> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/spi/spi-pxa2xx-dma.c   | 5 +++++
>  drivers/spi/spi-pxa2xx-pci.c   | 3 +++
>  include/linux/spi/pxa2xx_spi.h | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
> index c41ff14..4c4e918 100644
> --- a/drivers/spi/spi-pxa2xx-dma.c
> +++ b/drivers/spi/spi-pxa2xx-dma.c
> @@ -214,6 +214,11 @@ static bool pxa2xx_spi_dma_filter(struct dma_chan *chan, void *param)
>  {
>  	const struct pxa2xx_spi_master *pdata = param;
>  
> +	if (pdata->dma_devname) {
> +		if (strcmp(dev_name(chan->device->dev), pdata->dma_devname))
> +			return false;
> +	}
> +
>  	return chan->chan_id == pdata->tx_chan_id ||
>  	       chan->chan_id == pdata->rx_chan_id;
>  }
> diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
> index c1865c9..7a21bce 100644
> --- a/drivers/spi/spi-pxa2xx-pci.c
> +++ b/drivers/spi/spi-pxa2xx-pci.c
> @@ -21,6 +21,7 @@ struct pxa_spi_info {
>  	int tx_chan_id;
>  	int rx_slave_id;
>  	int rx_chan_id;
> +	char *dma_devname;
>  };
>  
>  static struct pxa_spi_info spi_info_configs[] = {
> @@ -41,6 +42,7 @@ static struct pxa_spi_info spi_info_configs[] = {
>  		.tx_chan_id = 0,
>  		.rx_slave_id = 1,
>  		.rx_chan_id = 1,
> +		.dma_devname = "0000:00:1e.0"
>  	},
>  };
>  
> @@ -72,6 +74,7 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
>  	spi_pdata.rx_slave_id = c->rx_slave_id;
>  	spi_pdata.rx_chan_id = c->rx_chan_id;
>  	spi_pdata.enable_dma = c->rx_slave_id >= 0 && c->tx_slave_id >= 0;
> +	spi_pdata.dma_devname = c->dma_devname;
>  
>  	ssp = &spi_pdata.ssp;
>  	ssp->phys_base = pci_resource_start(dev, 0);
> diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
> index 82d5111..264c3cb 100644
> --- a/include/linux/spi/pxa2xx_spi.h
> +++ b/include/linux/spi/pxa2xx_spi.h
> @@ -34,6 +34,7 @@ struct pxa2xx_spi_master {
>  	int tx_chan_id;
>  	int rx_slave_id;
>  	int tx_slave_id;
> +	char *dma_devname;
>  
>  	/* For non-PXA arches */
>  	struct ssp_device ssp;


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

