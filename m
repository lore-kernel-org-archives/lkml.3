Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3COLYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:24:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45772 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab3COLYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:24:17 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: RE: [PATCH V4] i2c: davinci: update to devm_* API
Thread-Topic: [PATCH V4] i2c: davinci: update to devm_* API
Thread-Index: AQHOGZaTRVZTCbSXJEiAjgFMCTy5SZimp45A
Date: Fri, 15 Mar 2013 11:23:52 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701585246@DBDE01.ent.ti.com>
References: <1362483885-16561-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1362483885-16561-1-git-send-email-manishv.b@ti.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram

Added your updated mail id in loop.
Are there any review comments on this patch? Could you please
accept this patch if there are not any review comments?

Thanks 
Manish Badarkhe

On Tue, Mar 05, 2013 at 17:14:45, Vishwanathrao Badarkhe, Manish wrote:
> Update the code to use devm_* API so that driver core will manage resources.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Changes since V3:
>   - Use devm_ioremap_resource API instead of devm_request_and_ioremap.
>   - Update commit message.
>   - Rebase on top of v3.9-rc1 linus tree. 
> Changes since V2:
>   - if "devm_request_and_ioremap" fails return -EADDRNOTAVAIL.
>     instead of -EBUSY.
> Changes since V1:
>   - Rebase on top of v3.8-rc6 of linus tree.
>   - Apply devm operation on clk_get.
> 
> :100644 100644 7d1e590... 1fb5a22... M	drivers/i2c/busses/i2c-davinci.c
>  drivers/i2c/busses/i2c-davinci.c |   49 +++++++++++--------------------------
>  1 files changed, 15 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 7d1e590..1fb5a22 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -643,7 +643,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)  {
>  	struct davinci_i2c_dev *dev;
>  	struct i2c_adapter *adap;
> -	struct resource *mem, *irq, *ioarea;
> +	struct resource *mem, *irq;
>  	int r;
>  
>  	/* NOTE: driver uses the static register mapping */ @@ -659,17 +659,11 @@ static int davinci_i2c_probe(struct platform_device *pdev)
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
> @@ -699,22 +693,24 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  		dev->pdata = &davinci_i2c_platform_data_default;
>  	}
>  
> -	dev->clk = clk_get(&pdev->dev, NULL);
> +	dev->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(dev->clk)) {
>  		r = -ENODEV;
>  		goto err_free_mem;
>  	}
>  	clk_prepare_enable(dev->clk);
>  
> -	dev->base = ioremap(mem->start, resource_size(mem));
> -	if (!dev->base) {
> -		r = -EBUSY;
> -		goto err_mem_ioremap;
> +	dev->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(dev->base)) {
> +		r = PTR_ERR(dev->base);
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
> @@ -740,25 +736,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
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
> -	clk_put(dev->clk);
>  	dev->clk = NULL;
>  err_free_mem:
>  	put_device(&pdev->dev);
> -	kfree(dev);
> -err_release_region:
> -	release_mem_region(mem->start, resource_size(mem));
>  
>  	return r;
>  }
> @@ -766,7 +754,6 @@ err_release_region:
>  static int davinci_i2c_remove(struct platform_device *pdev)  {
>  	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
> -	struct resource *mem;
>  
>  	i2c_davinci_cpufreq_deregister(dev);
>  
> @@ -774,16 +761,10 @@ static int davinci_i2c_remove(struct platform_device *pdev)
>  	put_device(&pdev->dev);
>  
>  	clk_disable_unprepare(dev->clk);
> -	clk_put(dev->clk);
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
> --
> 1.7.4.1
> 
> 


Regards, 
Manish
