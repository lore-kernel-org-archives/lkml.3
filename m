Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbbA0PxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:53:12 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:33854 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbbA0PxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:53:08 -0500
Date: Tue, 27 Jan 2015 16:50:47 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/9] mtd: pxa3xx_nand: add a non mandatory ECC clock
Message-ID: <20150127155047.GB16546@lunn.ch>
References: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
 <1422367816-4257-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422367816-4257-3-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 03:10:09PM +0100, Antoine Tenart wrote:
> Some controllers (as the coming Berlin nand controller) need to enable
> an ECC clock. Add support for this clock in the pxa3xx nand driver, and
> leave it as non mandatory.

Hi Antoine

It would be good to document this clock in the device tree binding.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index d00ac392d1c4..2681ec4abafa 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -180,7 +180,7 @@ struct pxa3xx_nand_info {
>  	struct nand_hw_control	controller;
>  	struct platform_device	 *pdev;
>  
> -	struct clk		*clk;
> +	struct clk		*clk, *ecc_clk;
>  	void __iomem		*mmio_base;
>  	unsigned long		mmio_phys;
>  	struct completion	cmd_complete, dev_ready;
> @@ -1608,7 +1608,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
>  
>  	spin_lock_init(&chip->controller->lock);
>  	init_waitqueue_head(&chip->controller->wq);
> -	info->clk = devm_clk_get(&pdev->dev, NULL);
> +	info->clk = devm_clk_get(&pdev->dev, "nfc");

Does this keep backwards compatibility? Not all the existing users
have there clocks named. What i think happens here is that
of_clk_get_by_name() calls of_property_match_string(np, "clock-names",
name); That returns -EINVAL, and then we ask of_clk_get() to get the
-EINVAL'th clock. I don't think that is going to end well.

I think you need to keep the NULL here, but should use "ecc" for the
second clock and require the use of the clock-names property when an
ecc clock is required.

    Andrew
