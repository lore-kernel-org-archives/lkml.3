Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935674Ab3DIJBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:01:34 -0400
Received: from sauhun.de ([89.238.76.85]:34475 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935514Ab3DIJAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:00:36 -0400
Date: Tue, 9 Apr 2013 11:00:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [1/7] i2c-designware: move to managed functions (devm_*)
Message-ID: <20130409090032.GA28509@the-dreams.de>
References: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -108,32 +108,27 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		return irq; /* -ENXIO */
>  	}
>  
> -	ioarea = request_mem_region(mem->start, resource_size(mem),
> -			pdev->name);
> -	if (!ioarea) {
> -		dev_err(&pdev->dev, "I2C region already claimed\n");
> -		return -EBUSY;
> -	}
> +	dev = devm_kzalloc(&pdev->dev, sizeof(struct dw_i2c_dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
>  
> -	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
> -	if (!dev) {
> -		r = -ENOMEM;
> -		goto err_release_region;
> +	dev->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(dev->base)) {
> +		dev_err(&pdev->dev, "I2C region already claimed\n");

No dev_err here. The devm function will print out errors already.

> @@ -164,13 +152,14 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	}
>  	r = i2c_dw_init(dev);
>  	if (r)
> -		goto err_iounmap;
> +		return r;
>  
>  	i2c_dw_disable_int(dev);
> -	r = request_irq(dev->irq, i2c_dw_isr, IRQF_SHARED, pdev->name, dev);
> +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_dw_isr, IRQF_SHARED,
> +			pdev->name, dev);

Is it ensured that no interrupts will happen during remove? Because the
adapter will be deleted before devm will free the interrupt.

Thanks,

   Wolfram

