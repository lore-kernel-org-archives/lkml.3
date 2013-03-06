Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3CFNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:55:39 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49557 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3CFNzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:55:37 -0500
Date: Wed, 6 Mar 2013 08:56:05 -0500
From: Matt Porter <mporter@ti.com>
To: Balaji T K <balajitk@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH v2 2/3] mmc: omap_hsmmc: Skip
 platform_get_resource_byname() for dt case
Message-ID: <20130306135605.GK6209@beef>
References: <1362518004-7083-1-git-send-email-mporter@ti.com>
 <1362518004-7083-3-git-send-email-mporter@ti.com>
 <513747C5.6080507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513747C5.6080507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 07:12:29PM +0530, Balaji T K wrote:
> On Wednesday 06 March 2013 02:43 AM, Matt Porter wrote:
> >From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >
> >MMC driver probe will abort for DT case because of failed
> >platform_get_resource_byname() lookup. Fix it by skipping resource
> >byname lookup for device tree build.
> >
> >Issue is hidden because hwmod popullates the IO resources which
> >helps to succeed platform_get_resource_byname() and probe.
> >
> 
> Hi Matt,
> Could you please drop this patch from the current series,
> since this patch causes regression on omap3,4 platform
> which are not yet dma dt adapted.
> It is best to send this patch along with Jon Hunter dma dt series,
> which adds dt dma support and mmc dma data. DMA dt series is needed
> any way before hwmod cleanup can happen.

*sigh* ok, I should have never split this stuff out from the am33xx
series. Will do.

-Matt

> >Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >---
> >  drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++++-------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> >
> >diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> >index e79b12d..8ae1225 100644
> >--- a/drivers/mmc/host/omap_hsmmc.c
> >+++ b/drivers/mmc/host/omap_hsmmc.c
> >@@ -1896,21 +1896,23 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
> >
> >  	omap_hsmmc_conf_bus_power(host);
> >
> >-	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> >-	if (!res) {
> >-		dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> >-		ret = -ENXIO;
> >-		goto err_irq;
> >-	}
> >-	tx_req = res->start;
> >+	if (!pdev->dev.of_node) {
> >+		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> >+		if (!res) {
> >+			dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> >+			ret = -ENXIO;
> >+			goto err_irq;
> >+		}
> >+		tx_req = res->start;
> >
> >-	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> >-	if (!res) {
> >-		dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> >-		ret = -ENXIO;
> >-		goto err_irq;
> >+		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> >+		if (!res) {
> >+			dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> >+			ret = -ENXIO;
> >+			goto err_irq;
> >+		}
> >+		rx_req = res->start;
> >  	}
> >-	rx_req = res->start;
> >
> >  	dma_cap_zero(mask);
> >  	dma_cap_set(DMA_SLAVE, mask);
> >
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
