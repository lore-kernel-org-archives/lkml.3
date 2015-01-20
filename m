Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbbATHQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:16:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbATHQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:16:23 -0500
Date: Tue, 20 Jan 2015 08:16:14 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] dma: imx-sdma: switch to dynamic context mode after
 script loaded
Message-ID: <20150120071614.GI18220@pengutronix.de>
References: <1421125757-10794-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421125757-10794-1-git-send-email-b38343@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:06:06 up 96 days, 18:19, 114 users,  load average: 0.06, 0.05,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 01:09:17PM +0800, Robin Gong wrote:
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
>  drivers/dma/imx-sdma.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index d0df198..510e463 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1323,6 +1323,10 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
>  	sdma_load_script(sdma, ram_code,
>  			header->ram_code_size,
>  			addr->ram_code_start_addr);
> +
> +	/* Set bits of CONFIG register with given context switching mode */
> +	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
> +

You move the CONFIG register initialization to a place which may never
be called. Look at the top of sdma_load_firmware:

	if (!fw) {
		dev_info(sdma->dev, "external firmware not found, using ROM firmware\n");
		/* In this case we just use the ROM firmware. */
		return;
	}

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
