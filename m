Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3BFDyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:54:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49820 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3BFDyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:54:13 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>
Subject: RE: [PATCH] i2c: davinci: update to devm_* API
Thread-Topic: [PATCH] i2c: davinci: update to devm_* API
Thread-Index: AQHOA3ocdlUEkHb3aECfut0NQ7MivZhqyfmAgAFnr8A=
Date: Wed, 6 Feb 2013 03:53:27 +0000
Message-ID: <A4887BF146CD57468F700B415D2F47015831BD@DBDE01.ent.ti.com>
References: <1360052699-1985-1-git-send-email-manishv.b@ti.com>
 <5110F14D.8090005@ti.com>
In-Reply-To: <5110F14D.8090005@ti.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r163sToZ019713

Hi Sekhar

On Tue, Feb 05, 2013 at 17:17:25, Nori, Sekhar wrote:
> 
> 
> On 2/5/2013 1:54 PM, Vishwanathrao Badarkhe, Manish wrote:
> > Update the code to use devm_* API so that driver core will manage 
> > resources.
> > 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> 
> You can use devm_clk_get() as well. We should also move to runtime 
  PM but that can be a different patch.

Sure, I will apply devm operation for clk_get also in next version.
Ok, will move to runtime PM in a different patch.


Thanks, 
Manish Badarkhe
> > ---
> > :100644 100644 6a0a553... f3dfffb... M	drivers/i2c/busses/i2c-davinci.c
> >  drivers/i2c/busses/i2c-davinci.c |   41 +++++++++++--------------------------
> >  1 files changed, 12 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-davinci.c 
> > b/drivers/i2c/busses/i2c-davinci.c
> > index 6a0a553..f3dfffb 100644
> > --- a/drivers/i2c/busses/i2c-davinci.c
> > +++ b/drivers/i2c/busses/i2c-davinci.c
> > @@ -643,7 +643,7 @@ static int davinci_i2c_probe(struct 
> > platform_device *pdev)  {
> >  	struct davinci_i2c_dev *dev;
> >  	struct i2c_adapter *adap;
> > -	struct resource *mem, *irq, *ioarea;
> > +	struct resource *mem, *irq;
> >  	int r;
> >  
> >  	/* NOTE: driver uses the static register mapping */ @@ -659,17 
> > +659,11 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >  		return -ENODEV;
> >  	}
> >  
> > -	ioarea = request_mem_region(mem->start, resource_size(mem),
> > -				    pdev->name);
> > -	if (!ioarea) {
> > -		dev_err(&pdev->dev, "I2C region already claimed\n");
> > -		return -EBUSY;
> > -	}
> > -
> > -	dev = kzalloc(sizeof(struct davinci_i2c_dev), GFP_KERNEL);
> > +	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_i2c_dev),
> > +			GFP_KERNEL);
> >  	if (!dev) {
> > -		r = -ENOMEM;
> > -		goto err_release_region;
> > +		dev_err(&pdev->dev, "Memory allocation failed\n");
> > +		return -ENOMEM;
> >  	}
> >  
> >  	init_completion(&dev->cmd_complete);
> > @@ -706,15 +700,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >  	}
> >  	clk_prepare_enable(dev->clk);
> >  
> > -	dev->base = ioremap(mem->start, resource_size(mem));
> > +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
> >  	if (!dev->base) {
> >  		r = -EBUSY;
> > -		goto err_mem_ioremap;
> > +		dev_err(&pdev->dev, "I2C region already claimed\n");
> > +		goto err_unuse_clocks;
> >  	}
> >  
> >  	i2c_davinci_init(dev);
> >  
> > -	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
> > +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
> > +			pdev->name, dev);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
> >  		goto err_unuse_clocks;
> > @@ -723,7 +719,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >  	r = i2c_davinci_cpufreq_register(dev);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failed to register cpufreq\n");
> > -		goto err_free_irq;
> > +		goto err_unuse_clocks;
> >  	}
> >  
> >  	adap = &dev->adapter;
> > @@ -740,26 +736,19 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >  	r = i2c_add_numbered_adapter(adap);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failure adding adapter\n");
> > -		goto err_free_irq;
> > +		goto err_unuse_clocks;
> >  	}
> >  	of_i2c_register_devices(adap);
> >  
> >  	return 0;
> >  
> > -err_free_irq:
> > -	free_irq(dev->irq, dev);
> >  err_unuse_clocks:
> > -	iounmap(dev->base);
> > -err_mem_ioremap:
> >  	clk_disable_unprepare(dev->clk);
> >  	clk_put(dev->clk);
> >  	dev->clk = NULL;
> >  err_free_mem:
> >  	platform_set_drvdata(pdev, NULL);
> >  	put_device(&pdev->dev);
> > -	kfree(dev);
> > -err_release_region:
> > -	release_mem_region(mem->start, resource_size(mem));
> >  
> >  	return r;
> >  }
> > @@ -767,7 +756,6 @@ err_release_region:
> >  static int davinci_i2c_remove(struct platform_device *pdev)  {
> >  	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
> > -	struct resource *mem;
> >  
> >  	i2c_davinci_cpufreq_deregister(dev);
> >  
> > @@ -780,12 +768,7 @@ static int davinci_i2c_remove(struct platform_device *pdev)
> >  	dev->clk = NULL;
> >  
> >  	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
> > -	free_irq(dev->irq, dev);
> > -	iounmap(dev->base);
> > -	kfree(dev);
> >  
> > -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	release_mem_region(mem->start, resource_size(mem));
> >  	return 0;
> >  }
> >  
> > 
> 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
