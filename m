Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaF0JTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:19:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0JTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:19:19 -0400
Date: Fri, 27 Jun 2014 11:19:17 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/2] mxc_nand: use our own read_page function
Message-ID: <20140627091917.GD20413@pengutronix.de>
References: <1403815368-29469-1-git-send-email-m.grzeschik@pengutronix.de>
 <1403815368-29469-2-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403815368-29469-2-git-send-email-m.grzeschik@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:17:55 up 65 days,  2:49, 59 users,  load average: 0,20, 0,16,
 0,15
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:42:48PM +0200, Michael Grzeschik wrote:
> The current approach of the read_page function is to iterate over all
> subpages and call the correct_data function. The correct_data function
> currently does the same. It iterates over all subpages and checks for
> correctable and uncorrectable data. This redundant call for each
> subpage leads to miscalculations.
> 
> This patch changes the driver to use its own read_page function in which
> we call the correct_data function only once per page. With that we do
> the failure and correct statistics counting inside this function.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/mtd/nand/mxc_nand.c | 73 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index 7fd495e..09e3682 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c

[snip]

> @@ -673,15 +728,21 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
>  	do {
>  		err = ecc_stat & ecc_bit_mask;
>  		if (err > err_limit) {
> -			printk(KERN_WARNING "UnCorrectable RS-ECC Error\n");
> -			return -1;
> +			broken++;
>  		} else {
>  			ret += err;
>  		}
>  		ecc_stat >>= 4;
>  	} while (--no_subpages);
>  
> -	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
> +	mtd->ecc_stats.corrected += ret;
> +	if (ret)
> +		printk("%d Symbol Correctable RS-ECC Error\n", ret);

This was ment to be pr_debug as before.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
