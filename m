Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaD1JNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:13:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37253 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaD1JNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:13:47 -0400
Date: Mon, 28 Apr 2014 11:13:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Daniel Willmann <daniel@totalueberwachung.de>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] mmc: mxs: fix card detection function for broken card
 detect
Message-ID: <20140428091341.GA5918@pengutronix.de>
References: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:52:55 up 5 days,  2:24, 40 users,  load average: 0.04, 0.09, 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 11:59:18PM +0200, Daniel Willmann wrote:
> Return -ENOSYS in get_cd if broken-cd is specified in the device tree.
> 
> Commit a91fe279ae75 (mmc: mxs: use standard flag for broken card
> detection) sets MMC_CAP_NEEDS_POLL when broken-cd is specified. This
> driver sets this flag unconditionally as it does not support a card
> detect interrupt. Instead, broken-cd means that there is no card detect
> signal connected.
> 
> The mmc core checks the get_cd function return value to determine if a
> card is present. Only for a non-zero return value it will attempt to
> initialize the card. So retuning -ENOSYS will allow the card to be
> initialized.
> For comparison, mmc_gpio_get_cd in slot-gpio.c also returns -ENOSYS if
> the card detect GPIO is not valid.

Short answer for fixing this regression:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Long answer:

This is broken in the MMC OF parser. When the parser finds the
'broken-cd' property it just sets the MMC_CAP_NEEDS_POLL flag. This is
wrong.  broken-cd means that we cannot rely on any card detection, but
instead have to talk to the card to find out if it's available.
Currently there is no flag to signal this situation, so the host driver
has to handle this by returning true in the get_cd callback, just like
the patch below does.

IMO the correct solution would be to add a MMC_CAP_CD_NEEDS_TALK_TO_CARD
flag to the core.

Sascha

> 
> Signed-off-by: Daniel Willmann <daniel@totalueberwachung.de>
> ---
> This might be relevant for stable kernels. The patch was tested with 3.14.1 on
> olinuxino nano.
> 
>  drivers/mmc/host/mxs-mmc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 073e871a0fc8..babfea03ba8a 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -70,6 +70,7 @@ struct mxs_mmc_host {
>  	unsigned char			bus_width;
>  	spinlock_t			lock;
>  	int				sdio_irq_en;
> +	bool				broken_cd;
>  };
>  
>  static int mxs_mmc_get_cd(struct mmc_host *mmc)
> @@ -78,6 +79,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>  	struct mxs_ssp *ssp = &host->ssp;
>  	int present, ret;
>  
> +	if (host->broken_cd)
> +		return -ENOSYS;
> +
>  	ret = mmc_gpio_get_cd(mmc);
>  	if (ret >= 0)
>  		return ret;
> @@ -568,6 +572,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id =
>  			of_match_device(mxs_mmc_dt_ids, &pdev->dev);
> +	struct device_node *np = pdev->dev.of_node;
>  	struct mxs_mmc_host *host;
>  	struct mmc_host *mmc;
>  	struct resource *iores;
> @@ -634,6 +639,8 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>  	mmc->caps = MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
>  		    MMC_CAP_SDIO_IRQ | MMC_CAP_NEEDS_POLL;
>  
> +	host->broken_cd = of_property_read_bool(np, "broken-cd");
> +
>  	mmc->f_min = 400000;
>  	mmc->f_max = 288000000;
>  
> -- 
> 1.8.4.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
