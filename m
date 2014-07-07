Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaGGG2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:28:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51104 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGGG2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:28:10 -0400
Date: Mon, 7 Jul 2014 08:27:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Chris Ball <chris@printf.net>, Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: mxs: fix card detection in case of 'broken-cd' flag
 set
Message-ID: <20140707062755.GE23235@pengutronix.de>
References: <1402412222-18020-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402412222-18020-1-git-send-email-r.peniaev@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:26:42 up 2 days, 17:02, 27 users,  load average: 0.00, 0.03, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:57:02PM +0900, Roman Pen wrote:
> In case of reboot my olinuxino imx23 board does not see
> mmc card any more. mmc_rescan is being called by delayed
> work in loop, but mxs_mmc_get_cd always returns 0, so we
> will never pass the card detection check and will not do
> further card inition.
> 
> This patch is just an attempt to partially revert the patch
> a91fe279ae of Sascha Hauer, where it is claimed that upper
> layer will handle broken card detection using the polling
> logic and MMC_CAP_NEEDS_POLL capability, but seems it is not
> true, because upper logic still expects 1 from 'get_cd'.
> 
> So, here we always return 1 (card present) in case of
> MMC_CAP_NEEDS_POLL capability set.
> 
> Signed-off-by: Roman Pen <r.peniaev@gmail.com>
> CC: Chris Ball <chris@printf.net>
> CC: Sascha Hauer <s.hauer@pengutronix.de>
> CC: Fabio Estevam <fabio.estevam@freescale.com>
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: Ulf Hansson <ulf.hansson@linaro.org>
> CC: linux-mmc@vger.kernel.org
> CC: linux-kernel@vger.kernel.org

I still didn't find the time to take a proper look at it. Since this
fixes a bug for you:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/mmc/host/mxs-mmc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 073e871..9187ce1 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -82,7 +82,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>  	if (ret >= 0)
>  		return ret;
>  
> -	present = !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
> +	present = mmc->caps & MMC_CAP_NEEDS_POLL ||
> +		!(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>  			BM_SSP_STATUS_CARD_DETECT);
>  
>  	if (mmc->caps2 & MMC_CAP2_CD_ACTIVE_HIGH)
> -- 
> 1.9.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
