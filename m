Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbaGYJ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:57:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:61007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaGYJ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,730,1400050800"; 
   d="scan'208";a="578837030"
Date: Fri, 25 Jul 2014 12:55:59 +0300
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
Message-ID: <20140725095559.GA1857@lahna.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
 <5574058.fMy2hcvT92@wuerfel>
 <20140725082249.GX1857@lahna.fi.intel.com>
 <7309109.iKHmHOxjzD@wuerfel>
 <20140725090714.GY1857@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725090714.GY1857@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> > > > All you need to do is change your filter function to take the
> > > > slave id from pxa_spi_info and stick it in there, e.g.
> > > > 
> > > > static bool pxa2xx_spi_dw_dma_filter(struct dma_chan *chan, void *param)
> > > > {       
> > > >         const struct pxa2xx_spi_master *pdata = param;
> > > >         struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> > > >         
> > > >         dwc->request_line = fargs->req;
> > > >         dwc->src_master = 0;
> > > >         dwc->dst_master = 0;
> > > >         
> > > >         return 1;
> > > > }           
> > > 
> > > Oh man. That makes pxa2xx_spi dependent on a certain specific DMA engine
> > > driver.
> > 
> > I think you can improve this by putting the filter function (and a pointer
> > to it) into the pxa2xx_spi_master data provided by the PCI driver.
> 
> Indeed, that looks better. It still makes the PCI part of the driver
> dependent on a particular DMA engine driver but is certainly better than
> the core pxa2xx_spi driver.

Something like this?

Hock Leong / Chiaue Ee, are you able to check if this works on your BYT
machines?

diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
index c41ff148a2b4..5d46972ffc40 100644
--- a/drivers/spi/spi-pxa2xx-dma.c
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -157,7 +157,6 @@ static struct dma_async_tx_descriptor *
 pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
 			   enum dma_transfer_direction dir)
 {
-	struct pxa2xx_spi_master *pdata = drv_data->master_info;
 	struct chip_data *chip = drv_data->cur_chip;
 	enum dma_slave_buswidth width;
 	struct dma_slave_config cfg;
@@ -184,7 +183,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
 		cfg.dst_addr = drv_data->ssdr_physical;
 		cfg.dst_addr_width = width;
 		cfg.dst_maxburst = chip->dma_burst_size;
-		cfg.slave_id = pdata->tx_slave_id;
 
 		sgt = &drv_data->tx_sgt;
 		nents = drv_data->tx_nents;
@@ -193,7 +191,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
 		cfg.src_addr = drv_data->ssdr_physical;
 		cfg.src_addr_width = width;
 		cfg.src_maxburst = chip->dma_burst_size;
-		cfg.slave_id = pdata->rx_slave_id;
 
 		sgt = &drv_data->rx_sgt;
 		nents = drv_data->rx_nents;
@@ -210,14 +207,6 @@ pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
 				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 }
 
-static bool pxa2xx_spi_dma_filter(struct dma_chan *chan, void *param)
-{
-	const struct pxa2xx_spi_master *pdata = param;
-
-	return chan->chan_id == pdata->tx_chan_id ||
-	       chan->chan_id == pdata->rx_chan_id;
-}
-
 bool pxa2xx_spi_dma_is_possible(size_t len)
 {
 	return len <= MAX_DMA_LEN;
@@ -321,12 +310,14 @@ int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
 		return -ENOMEM;
 
 	drv_data->tx_chan = dma_request_slave_channel_compat(mask,
-				pxa2xx_spi_dma_filter, pdata, dev, "tx");
+				pdata->dma_filter, pdata->dma_filter_param,
+				dev, "tx");
 	if (!drv_data->tx_chan)
 		return -ENODEV;
 
 	drv_data->rx_chan = dma_request_slave_channel_compat(mask,
-				pxa2xx_spi_dma_filter, pdata, dev, "rx");
+				pdata->dma_filter, pdata->dma_filter_param,
+				dev, "rx");
 	if (!drv_data->rx_chan) {
 		dma_release_channel(drv_data->tx_chan);
 		drv_data->tx_chan = NULL;
diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index c1865c92ccb9..aee3aa9365cf 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -8,6 +8,9 @@
 #include <linux/module.h>
 #include <linux/spi/pxa2xx_spi.h>
 
+#include <linux/dmaengine.h>
+#include "../../drivers/dma/dw/regs.h"
+
 enum {
 	PORT_CE4100,
 	PORT_BYT,
@@ -23,6 +26,24 @@ struct pxa_spi_info {
 	int rx_chan_id;
 };
 
+static bool pxa2xx_spi_pci_dma_filter(struct dma_chan *chan, void *param)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	const struct pxa_spi_info *info = param;
+
+	if (chan->chan_id == info->tx_chan_id)
+		dwc->request_line = info->tx_slave_id;
+	else if (chan->chan_id == info->rx_chan_id)
+		dwc->request_line = info->rx_slave_id;
+	else
+		return false;
+
+	dwc->src_master = 0;
+	dwc->dst_master = 0;
+
+	return true;
+}
+
 static struct pxa_spi_info spi_info_configs[] = {
 	[PORT_CE4100] = {
 		.type = PXA25x_SSP,
@@ -67,10 +88,9 @@ static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
 	spi_pdata.num_chipselect = (c->num_chipselect > 0) ?
 					c->num_chipselect : dev->devfn;
-	spi_pdata.tx_slave_id = c->tx_slave_id;
-	spi_pdata.tx_chan_id = c->tx_chan_id;
-	spi_pdata.rx_slave_id = c->rx_slave_id;
-	spi_pdata.rx_chan_id = c->rx_chan_id;
+
+	spi_pdata.dma_filter = pxa2xx_spi_pci_dma_filter;
+	spi_pdata.dma_filter_param = c;
 	spi_pdata.enable_dma = c->rx_slave_id >= 0 && c->tx_slave_id >= 0;
 
 	ssp = &spi_pdata.ssp;
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index fe792106bdc5..256c0abbddd2 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1062,8 +1062,6 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 
 	pdata->num_chipselect = 1;
 	pdata->enable_dma = true;
-	pdata->tx_chan_id = -1;
-	pdata->rx_chan_id = -1;
 
 	return pdata;
 }
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 82d5111cd0c2..2eb00920c169 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -23,6 +23,8 @@
 #define PXA2XX_CS_ASSERT (0x01)
 #define PXA2XX_CS_DEASSERT (0x02)
 
+struct dma_chan;
+
 /* device.platform_data for SSP controller devices */
 struct pxa2xx_spi_master {
 	u32 clock_enable;
@@ -30,10 +32,8 @@ struct pxa2xx_spi_master {
 	u8 enable_dma;
 
 	/* DMA engine specific config */
-	int rx_chan_id;
-	int tx_chan_id;
-	int rx_slave_id;
-	int tx_slave_id;
+	bool (*dma_filter)(struct dma_chan *chan, void *param);
+	void *dma_filter_param;
 
 	/* For non-PXA arches */
 	struct ssp_device ssp;
-- 
2.0.1

