Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaIKGnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:43:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:32054 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaIKGnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="476810109"
Date: Thu, 11 Sep 2014 11:50:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mark Brown <broonie@kernel.org>, Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Alan Cox <alan@linux.jf.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/12] spi/pxa2xx: Don't use slave_id of
 dma_slave_config
Message-ID: <20140911062024.GG3131@intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-9-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-9-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:29:19PM +0300, Andy Shevchenko wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> That field has been deprecated in favour of getting the necessary
> information from ACPI/DT.
> 
> However, we still need to deal systems that are PCI only (no ACPI to back
> up). In order to support such systems, we allow the DMA filter function and
> its corresponding parameter via pxa2xx_spi_master platform data. Then when
> the pxa2xx_spi_dma_setup() doesn't find the channel via ACPI, it falls back
> to use the given filter function.

This fails to apply for me, was it based on dmaengine tree or spi?

-- 
~Vinod

> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/spi/spi-pxa2xx-dma.c   | 15 ++--------
>  drivers/spi/spi-pxa2xx-pci.c   | 64 +++++++++++++++++++++++++++++++-----------
>  drivers/spi/spi-pxa2xx.c       |  2 --
>  include/linux/spi/pxa2xx_spi.h |  9 +++---
>  4 files changed, 54 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
> index c41ff14..62a9297 100644
> --- a/drivers/spi/spi-pxa2xx-dma.c
> +++ b/drivers/spi/spi-pxa2xx-dma.c
> @@ -157,7 +157,6 @@ static struct dma_async_tx_descriptor *
>  pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
>  			   enum dma_transfer_direction dir)
>  {
> -	struct pxa2xx_spi_master *pdata = drv_data->master_info;
>  	struct chip_data *chip = drv_data->cur_chip;
>  	enum dma_slave_buswidth width;
>  	struct dma_slave_config cfg;
> @@ -184,7 +183,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
>  		cfg.dst_addr = drv_data->ssdr_physical;
>  		cfg.dst_addr_width = width;
>  		cfg.dst_maxburst = chip->dma_burst_size;
> -		cfg.slave_id = pdata->tx_slave_id;
>  
>  		sgt = &drv_data->tx_sgt;
>  		nents = drv_data->tx_nents;
> @@ -193,7 +191,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
>  		cfg.src_addr = drv_data->ssdr_physical;
>  		cfg.src_addr_width = width;
>  		cfg.src_maxburst = chip->dma_burst_size;
> -		cfg.slave_id = pdata->rx_slave_id;
>  
>  		sgt = &drv_data->rx_sgt;
>  		nents = drv_data->rx_nents;
> @@ -210,14 +207,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
>  				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  }
>  
> -static bool pxa2xx_spi_dma_filter(struct dma_chan *chan, void *param)
> -{
> -	const struct pxa2xx_spi_master *pdata = param;
> -
> -	return chan->chan_id == pdata->tx_chan_id ||
> -	       chan->chan_id == pdata->rx_chan_id;
> -}
> -
>  bool pxa2xx_spi_dma_is_possible(size_t len)
>  {
>  	return len <= MAX_DMA_LEN;
> @@ -321,12 +310,12 @@ int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
>  		return -ENOMEM;
>  
>  	drv_data->tx_chan = dma_request_slave_channel_compat(mask,
> -				pxa2xx_spi_dma_filter, pdata, dev, "tx");
> +				pdata->dma_filter, pdata->tx_param, dev, "tx");
>  	if (!drv_data->tx_chan)
>  		return -ENODEV;
>  
>  	drv_data->rx_chan = dma_request_slave_channel_compat(mask,
> -				pxa2xx_spi_dma_filter, pdata, dev, "rx");
> +				pdata->dma_filter, pdata->rx_param, dev, "rx");
>  	if (!drv_data->rx_chan) {
>  		dma_release_channel(drv_data->tx_chan);
>  		drv_data->tx_chan = NULL;
> diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
> index 20ebbc7..0424b67 100644
> --- a/drivers/spi/spi-pxa2xx-pci.c
> +++ b/drivers/spi/spi-pxa2xx-pci.c
> @@ -10,6 +10,9 @@
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
>  
> +#include <linux/dmaengine.h>
> +#include <linux/platform_data/dma-dw.h>
> +
>  enum {
>  	PORT_CE4100,
>  	PORT_BYT,
> @@ -19,33 +22,41 @@ struct pxa_spi_info {
>  	enum pxa_ssp_type type;
>  	int port_id;
>  	int num_chipselect;
> -	int tx_slave_id;
> -	int tx_chan_id;
> -	int rx_slave_id;
> -	int rx_chan_id;
>  	unsigned long max_clk_rate;
> +
> +	/* DMA channel request parameters */
> +	void *tx_param;
> +	void *rx_param;
>  };
>  
> +static struct dw_dma_slave byt_tx_param = { .dst_id = 0 };
> +static struct dw_dma_slave byt_rx_param = { .src_id = 1 };
> +
> +static bool lpss_dma_filter(struct dma_chan *chan, void *param)
> +{
> +	struct dw_dma_slave *dws = param;
> +
> +	if (dws->dma_dev != chan->device->dev)
> +		return false;
> +
> +	chan->private = dws;
> +	return true;
> +}
> +
>  static struct pxa_spi_info spi_info_configs[] = {
>  	[PORT_CE4100] = {
>  		.type = PXA25x_SSP,
>  		.port_id =  -1,
>  		.num_chipselect = -1,
> -		.tx_slave_id = -1,
> -		.tx_chan_id = -1,
> -		.rx_slave_id = -1,
> -		.rx_chan_id = -1,
>  		.max_clk_rate = 3686400,
>  	},
>  	[PORT_BYT] = {
>  		.type = LPSS_SSP,
>  		.port_id = 0,
>  		.num_chipselect = 1,
> -		.tx_slave_id = 0,
> -		.tx_chan_id = 0,
> -		.rx_slave_id = 1,
> -		.rx_chan_id = 1,
>  		.max_clk_rate = 50000000,
> +		.tx_param = &byt_tx_param,
> +		.rx_param = &byt_rx_param,
>  	},
>  };
>  
> @@ -59,6 +70,7 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
>  	struct ssp_device *ssp;
>  	struct pxa_spi_info *c;
>  	char buf[40];
> +	struct pci_dev *dma_dev;
>  
>  	ret = pcim_enable_device(dev);
>  	if (ret)
> @@ -73,11 +85,29 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
>  	memset(&spi_pdata, 0, sizeof(spi_pdata));
>  	spi_pdata.num_chipselect = (c->num_chipselect > 0) ?
>  					c->num_chipselect : dev->devfn;
> -	spi_pdata.tx_slave_id = c->tx_slave_id;
> -	spi_pdata.tx_chan_id = c->tx_chan_id;
> -	spi_pdata.rx_slave_id = c->rx_slave_id;
> -	spi_pdata.rx_chan_id = c->rx_chan_id;
> -	spi_pdata.enable_dma = c->rx_slave_id >= 0 && c->tx_slave_id >= 0;
> +
> +	dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
> +
> +	if (c->tx_param) {
> +		struct dw_dma_slave *slave = c->tx_param;
> +
> +		slave->dma_dev = &dma_dev->dev;
> +		slave->src_master = 1;
> +		slave->dst_master = 0;
> +	}
> +
> +	if (c->rx_param) {
> +		struct dw_dma_slave *slave = c->rx_param;
> +
> +		slave->dma_dev = &dma_dev->dev;
> +		slave->src_master = 1;
> +		slave->dst_master = 0;
> +	}
> +
> +	spi_pdata.dma_filter = lpss_dma_filter;
> +	spi_pdata.tx_param = c->tx_param;
> +	spi_pdata.rx_param = c->rx_param;
> +	spi_pdata.enable_dma = c->rx_param && c->tx_param;
>  
>  	ssp = &spi_pdata.ssp;
>  	ssp->phys_base = pci_resource_start(dev, 0);
> diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
> index fe79210..256c0ab 100644
> --- a/drivers/spi/spi-pxa2xx.c
> +++ b/drivers/spi/spi-pxa2xx.c
> @@ -1062,8 +1062,6 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
>  
>  	pdata->num_chipselect = 1;
>  	pdata->enable_dma = true;
> -	pdata->tx_chan_id = -1;
> -	pdata->rx_chan_id = -1;
>  
>  	return pdata;
>  }
> diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
> index 82d5111..d5a3165 100644
> --- a/include/linux/spi/pxa2xx_spi.h
> +++ b/include/linux/spi/pxa2xx_spi.h
> @@ -23,6 +23,8 @@
>  #define PXA2XX_CS_ASSERT (0x01)
>  #define PXA2XX_CS_DEASSERT (0x02)
>  
> +struct dma_chan;
> +
>  /* device.platform_data for SSP controller devices */
>  struct pxa2xx_spi_master {
>  	u32 clock_enable;
> @@ -30,10 +32,9 @@ struct pxa2xx_spi_master {
>  	u8 enable_dma;
>  
>  	/* DMA engine specific config */
> -	int rx_chan_id;
> -	int tx_chan_id;
> -	int rx_slave_id;
> -	int tx_slave_id;
> +	bool (*dma_filter)(struct dma_chan *chan, void *param);
> +	void *tx_param;
> +	void *rx_param;
>  
>  	/* For non-PXA arches */
>  	struct ssp_device ssp;
> -- 
> 2.1.0
> 

-- 
