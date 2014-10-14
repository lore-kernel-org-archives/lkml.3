Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaJNVgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:36:08 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38675 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaJNVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:36:07 -0400
Date: Tue, 14 Oct 2014 23:35:03 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com, jg1.han@samsung.com,
        andrew@lunn.ch, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: fix error code path in probe
Message-ID: <20141014213503.GD5331@lunn.ch>
References: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:16:38PM +0200, Michael Opdenacker wrote:
> This replaces kzalloc() and ioremap() calls by
> the corresponding devm_ functions in the probe() routine,
> which automatically release the corresponding resources
> when probe() fails or when the device is removed.
> 
> This simplifies the error management code and
> fixes a bug reported by "make coccicheck":
> 
> if "board = devm_kzalloc()" fails, the probe()
> function jumps incorrectly to label "no_res" and
> therefore returns without running "iounmap()"
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/mtd/nand/orion_nand.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index 471b4df3a5ac..a9c2bde16c25 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -19,7 +19,7 @@
>  #include <linux/mtd/partitions.h>
>  #include <linux/clk.h>
>  #include <linux/err.h>
> -#include <asm/io.h>
> +#include <linux/io.h>
>  #include <asm/sizes.h>
>  #include <linux/platform_data/mtd-orion_nand.h>
>  
> @@ -85,32 +85,30 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>  	int ret = 0;
>  	u32 val = 0;
>  
> -	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
> +	nc = devm_kzalloc(&pdev->dev,
> +			sizeof(struct nand_chip) + sizeof(struct mtd_info),
> +			GFP_KERNEL);
>  	if (!nc) {
> -		ret = -ENOMEM;
> -		goto no_res;
> +		return -ENOMEM;
>  	}
>  	mtd = (struct mtd_info *)(nc + 1);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> -		ret = -ENODEV;
> -		goto no_res;
> +		return -ENODEV;
>  	}
>  
> -	io_base = ioremap(res->start, resource_size(res));
> +	io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>  	if (!io_base) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
> -		ret = -EIO;
> -		goto no_res;
> +		return -EIO;
>  	}

Hi Michael

It is quite a common pattern to use:

        res = platform_get_resource(dev, IORESOURCE_MEM, 0);
        c->membase = devm_ioremap_resource(&dev->dev, res);
        if (IS_ERR(c->membase))
	   return PTR_ERR(c->membase)

which is more compact.

>  
>  	if (pdev->dev.of_node) {
>  		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
>  					GFP_KERNEL);
>  		if (!board) {
> -			ret = -ENOMEM;
> -			goto no_res;
> +			return -ENOMEM;
>  		}

Doesn't this now break the coding style? No need to have the {} since
it is a single statement.

   Andrew
