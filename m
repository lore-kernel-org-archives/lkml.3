Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LQImp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:42:45 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49387 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3LQImn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:42:43 -0500
Date: Tue, 17 Dec 2013 00:42:38 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, grygorii.strashko@ti.com,
        dwmw2@infradead.org
Subject: Re: [PATCH v3 9/9] mtd: nand: davinci: don't request AEMIF address
 range
Message-ID: <20131217084238.GJ12034@norris-Latitude-E6410>
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1386264358-9738-10-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386264358-9738-10-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 07:25:57PM +0200, Ivan Khoronzhuk wrote:
> The TI AEMIF driver registers are used to setup timings for each chip
> select. The same registers range is used to setup NAND settings.
> The AEMIF and NAND drivers not use the same registers in this range.
> 
> In case with TI AEMIF driver, the memory address range is requested
> already by AEMIF, so we cannot request it twice, just ioremap.
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Reviewed-by: Taras Kondratiuk <taras@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  drivers/mtd/nand/davinci_nand.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index f7b21b8..0cd4dbc 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -636,9 +636,11 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>  	if (IS_ERR(vaddr))
>  		return PTR_ERR(vaddr);
>  
> -	base = devm_ioremap_resource(&pdev->dev, res2);
> -	if (IS_ERR(base))
> -		return PTR_ERR(base);
> +	base = devm_ioremap(&pdev->dev, res2->start, resource_size(res2));

Since it's important that we don't re-introduce the "request resource"
boilerplate later, can you add a comment describing the situation?

> +	if (!base) {
> +		dev_err(&pdev->dev, "ioremap failed for resource %pR\n", res2);
> +		return -EADDRNOTAVAIL;
> +	}
>  
>  	info->dev		= &pdev->dev;
>  	info->base		= base;

Thanks,
Brian
