Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbbAVH2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:28:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAVH2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:28:48 -0500
Date: Thu, 22 Jan 2015 08:28:39 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma: imx-sdma: switch to dynamic context mode after
 script loaded
Message-ID: <20150122072839.GO12209@pengutronix.de>
References: <1421899177-30406-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421899177-30406-1-git-send-email-b38343@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:23:20 up 98 days, 18:37, 123 users,  load average: 0.01, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:59:37AM +0800, Robin Gong wrote:
> Below comments got from Page4724 of Reference Manual of i.mx6q:
> http://cache.freescale.com/files/32bit/doc/ref_manual/IMX6DQRM.pdf
> 
> --"Static context mode should be used for the first channel called
> after reset to ensure that the all context RAM for that channel is
> initialized during the context SAVE phase when the channel is
> done or yields. Subsequent calls to the same channel or
> different channels may use any of the dynamic context modes.
> This will ensure that all context locations for the bootload
> channel are initialized, and prevent undefined values in context
> RAM from being loaded during the context restore if the
> channel is re-started later"
> 
> Unfortunately, the rule was broken by commit(5b28aa319bba96987316425a1131813d87cbab35)
> .This patch just take them back.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  drivers/dma/imx-sdma.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index d0df198..d84b7a8 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -330,6 +330,8 @@ struct sdma_engine {
>  	const struct sdma_driver_data	*drvdata;
>  };
>  
> +static bool channel0_first;

Nah, don't break the multi instance capability of drivers without a
reason. Don't use global static variables in driver context.

> +
>  static struct sdma_driver_data sdma_imx31 = {
>  	.chnenbl0 = SDMA_CHNENBL0_IMX31,
>  	.num_events = 32,
> @@ -531,6 +533,12 @@ static int sdma_run_channel0(struct sdma_engine *sdma)
>  		dev_err(sdma->dev, "Timeout waiting for CH0 ready\n");
>  	}
>  
> +	if (!channel0_first) {
> +		/* Set bits of CONFIG register with given context switching mode */
> +		writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
> +		channel0_first = true;
> +	}

You don't need a variable. How about:

	if (readl(sdma->regs + SDMA_H_CONFIG) == 0)
		writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
