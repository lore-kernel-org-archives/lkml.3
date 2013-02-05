Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3BELr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:47:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48067 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3BELrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:47:55 -0500
Message-ID: <5110F14D.8090005@ti.com>
Date: Tue, 5 Feb 2013 17:17:25 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, <ben-linux@fluff.org>,
        <w.sang@pengutronix.de>
Subject: Re: [PATCH] i2c: davinci: update to devm_* API
References: <1360052699-1985-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1360052699-1985-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2/5/2013 1:54 PM, Vishwanathrao Badarkhe, Manish wrote:
> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

You can use devm_clk_get() as well. We should also move to runtime PM
but that can be a different patch.

Thanks,
Sekhar

> ---
> :100644 100644 6a0a553... f3dfffb... M	drivers/i2c/busses/i2c-davinci.c
>  drivers/i2c/busses/i2c-davinci.c |   41 +++++++++++--------------------------
>  1 files changed, 12 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 6a0a553..f3dfffb 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -643,7 +643,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  {
>  	struct davinci_i2c_dev *dev;
>  	struct i2c_adapter *adap;
> -	struct resource *mem, *irq, *ioarea;
> +	struct resource *mem, *irq;
>  	int r;
>  
>  	/* NOTE: driver uses the static register mapping */
> @@ -659,17 +659,11 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	ioarea = request_mem_region(mem->start, resource_size(mem),
> -				    pdev->name);
> -	if (!ioarea) {
> -		dev_err(&pdev->dev, "I2C region already claimed\n");
> -		return -EBUSY;
> -	}
> -
> -	dev = kzalloc(sizeof(struct davinci_i2c_dev), GFP_KERNEL);
> +	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_i2c_dev),
> +			GFP_KERNEL);
>  	if (!dev) {
> -		r = -ENOMEM;
> -		goto err_release_region;
> +		dev_err(&pdev->dev, "Memory allocation failed\n");
> +		return -ENOMEM;
>  	}
>  
>  	init_completion(&dev->cmd_complete);
> @@ -706,15 +700,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(dev->clk);
>  
> -	dev->base = ioremap(mem->start, resource_size(mem));
> +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
>  	if (!dev->base) {
>  		r = -EBUSY;
> -		goto err_mem_ioremap;
> +		dev_err(&pdev->dev, "I2C region already claimed\n");
> +		goto err_unuse_clocks;
>  	}
>  
>  	i2c_davinci_init(dev);
>  
> -	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
> +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
> +			pdev->name, dev);
>  	if (r) {
>  		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
>  		goto err_unuse_clocks;
> @@ -723,7 +719,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	r = i2c_davinci_cpufreq_register(dev);
>  	if (r) {
>  		dev_err(&pdev->dev, "failed to register cpufreq\n");
> -		goto err_free_irq;
> +		goto err_unuse_clocks;
>  	}
>  
>  	adap = &dev->adapter;
> @@ -740,26 +736,19 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	r = i2c_add_numbered_adapter(adap);
>  	if (r) {
>  		dev_err(&pdev->dev, "failure adding adapter\n");
> -		goto err_free_irq;
> +		goto err_unuse_clocks;
>  	}
>  	of_i2c_register_devices(adap);
>  
>  	return 0;
>  
> -err_free_irq:
> -	free_irq(dev->irq, dev);
>  err_unuse_clocks:
> -	iounmap(dev->base);
> -err_mem_ioremap:
>  	clk_disable_unprepare(dev->clk);
>  	clk_put(dev->clk);
>  	dev->clk = NULL;
>  err_free_mem:
>  	platform_set_drvdata(pdev, NULL);
>  	put_device(&pdev->dev);
> -	kfree(dev);
> -err_release_region:
> -	release_mem_region(mem->start, resource_size(mem));
>  
>  	return r;
>  }
> @@ -767,7 +756,6 @@ err_release_region:
>  static int davinci_i2c_remove(struct platform_device *pdev)
>  {
>  	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
> -	struct resource *mem;
>  
>  	i2c_davinci_cpufreq_deregister(dev);
>  
> @@ -780,12 +768,7 @@ static int davinci_i2c_remove(struct platform_device *pdev)
>  	dev->clk = NULL;
>  
>  	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
> -	free_irq(dev->irq, dev);
> -	iounmap(dev->base);
> -	kfree(dev);
>  
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(mem->start, resource_size(mem));
>  	return 0;
>  }
>  
> 
