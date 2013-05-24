Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3EXDhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:37:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56536 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab3EXDhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:37:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,731,1363104000"; 
   d="scan'208";a="7351858"
Message-ID: <519EDFFC.5020308@cn.fujitsu.com>
Date: Fri, 24 May 2013 11:35:24 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: wsa@the-dreams.de, sonic.zhang@analog.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH RFC v3 2/3] i2c: pxa: convert to devm_* API
References: <1369310408-10348-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369310408-10348-1-git-send-email-libo.chen@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 11:36:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 11:36:24,
	Serialize complete at 2013/05/24 11:36:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,
   I think you can merge patch 1/3 and 2/3, they do the same thing that using  devm_* API to simplify
and make the code clean, and the additional goal is it also can fix a bug. Besides, maybe you need to
change the title and make it clear and self-described.

Thanks,
Gu

On 05/23/2013 08:00 PM, Libo Chen wrote:

> when i2c malloc faild, we should not try to call release_mem_region.
> aovid this, convert them to devm_* API.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/i2c/busses/i2c-pxa.c |   63 ++++++++++--------------------------------
>  1 files changed, 15 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index ea6d45d..7b10102 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1091,10 +1091,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	struct resource *res = NULL;
>  	int ret, irq;
>  
> -	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
> +	i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
>  	if (!i2c) {
> -		ret = -ENOMEM;
> -		goto emalloc;
> +		return -ENOMEM;
>  	}


The {} pair is no longer needed.

>  
>  	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
> @@ -1104,19 +1103,11 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	if (ret > 0)
>  		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>  	if (ret < 0)
> -		goto eclk;
> +		return ret;
>  
> -	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(dev, 0);
> -	if (res == NULL || irq < 0) {
> -		ret = -ENODEV;
> -		goto eclk;
> -	}
> -
> -	if (!request_mem_region(res->start, resource_size(res), res->name)) {
> -		ret = -ENOMEM;
> -		goto eclk;
> -	}
> +	if (irq < 0)
> +		return -ENODEV;
>  
>  	i2c->adap.owner   = THIS_MODULE;
>  	i2c->adap.retries = 5;
> @@ -1126,17 +1117,15 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  
>  	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
>  
> -	i2c->clk = clk_get(&dev->dev, NULL);
> +	i2c->clk = devm_clk_get(&dev->dev, NULL);
>  	if (IS_ERR(i2c->clk)) {
> -		ret = PTR_ERR(i2c->clk);
> -		goto eclk;
> +		return PTR_ERR(i2c->clk);
>  	}

the same.

>  
> -	i2c->reg_base = ioremap(res->start, resource_size(res));
> -	if (!i2c->reg_base) {
> -		ret = -EIO;
> -		goto eremap;
> -	}
> +	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	i2c->reg_base = devm_ioremap_resource(&dev->dev, res);
> +	if (IS_ERR(i2c->reg_base))
> +		return PTR_ERR(i2c->reg_bas);
>  
>  	i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
>  	i2c->reg_idbr = i2c->reg_base + pxa_reg_layout[i2c_type].idbr;
> @@ -1166,10 +1155,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  		i2c->adap.algo = &i2c_pxa_pio_algorithm;
>  	} else {
>  		i2c->adap.algo = &i2c_pxa_algorithm;
> -		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
> -				  dev_name(&dev->dev), i2c);
> +		ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
> +					IRQF_SHARED, dev_name(&dev->dev), i2c);
>  		if (ret)
> -			goto ereqirq;
> +			return ret;
>  	}
>  
>  	i2c_pxa_reset(i2c);
> @@ -1183,7 +1172,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	ret = i2c_add_numbered_adapter(&i2c->adap);
>  	if (ret < 0) {
>  		printk(KERN_INFO "I2C: Failed to add bus\n");
> -		goto eadapt;
> +		return ret;
>  	}
>  	of_i2c_register_devices(&i2c->adap);
>  
> @@ -1198,19 +1187,6 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  #endif
>  	return 0;
>  
> -eadapt:
> -	if (!i2c->use_pio)
> -		free_irq(irq, i2c);
> -ereqirq:
> -	clk_disable(i2c->clk);
> -	iounmap(i2c->reg_base);
> -eremap:
> -	clk_put(i2c->clk);
> -eclk:
> -	kfree(i2c);
> -emalloc:
> -	release_mem_region(res->start, resource_size(res));
> -	return ret;
>  }
>  
>  static int i2c_pxa_remove(struct platform_device *dev)
> @@ -1218,15 +1194,6 @@ static int i2c_pxa_remove(struct platform_device *dev)
>  	struct pxa_i2c *i2c = platform_get_drvdata(dev);
>  
>  	i2c_del_adapter(&i2c->adap);
> -	if (!i2c->use_pio)
> -		free_irq(i2c->irq, i2c);
> -
> -	clk_disable(i2c->clk);
> -	clk_put(i2c->clk);
> -
> -	iounmap(i2c->reg_base);
> -	release_mem_region(i2c->iobase, i2c->iosize);
> -	kfree(i2c);
>  
>  	return 0;
>  }


