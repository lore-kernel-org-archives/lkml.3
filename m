Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3GQIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:19:27 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:35964 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab3GQITY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:19:24 -0400
X-Greylist: delayed 1917 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 04:19:24 EDT
Date: Wed, 17 Jul 2013 09:45:33 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        artem.bityutskiy@linux.intel.com, jg1.han@samsung.com, andrew@lunn.ch,
        wfp5p@virginia.edu, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtd: orion_nand: convert to use devm_* APIs
Message-ID: <20130717074533.GA1026@lunn.ch>
References: <CAPgLHd8upcmfnQqHAWnqP7YBVYDVyoYKQ3WCh3c5+uY-EKr1jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8upcmfnQqHAWnqP7YBVYDVyoYKQ3WCh3c5+uY-EKr1jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:09:10AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Convert to use devm_* APIs to avoid resources leak on error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mtd/nand/orion_nand.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index 46f308d..ce711b4 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -85,25 +85,23 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>  	int ret = 0;
>  	u32 val = 0;
>  
> -	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
> +	nc = devm_kzalloc(&pdev->dev,
> +			  sizeof(struct nand_chip) + sizeof(struct mtd_info),
> +			  GFP_KERNEL);
>  	if (!nc) {
>  		printk(KERN_ERR "orion_nand: failed to allocate device structure.\n");
> -		ret = -ENOMEM;
> -		goto no_res;
> +		return -ENOMEM;
>  	}
>  	mtd = (struct mtd_info *)(nc + 1);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		ret = -ENODEV;
> -		goto no_res;
> -	}
> +	if (!res)
> +		return -ENODEV;
>  
> -	io_base = ioremap(res->start, resource_size(res));
> +	io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>  	if (!io_base) {
>  		printk(KERN_ERR "orion_nand: ioremap failed\n");
> -		ret = -EIO;
> -		goto no_res;
> +		return -EIO;

Hi Wei

Thanks for working on this.

The above code can be further simplified:

        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        io_base = devm_ioremap_resource(&pdev->dev, res);
        if (IS_ERR(io_base))
                return PTR_ERR(io_base); 


While you are editing this file, it would be nice to replace all the
printk() statements with dev_err(), dev_info() etc. Please do that as
a separate patch.

Thanks
	Andrew
