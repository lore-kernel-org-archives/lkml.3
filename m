Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaGDJKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:10:21 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:38365 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGDJKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:10:15 -0400
Date: Fri, 4 Jul 2014 11:10:00 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3] i2c: busses: i2c-pxa.c:  Fix for possible null
 pointer dereferenc
Message-ID: <20140704091000.GA4738@lianli>
References: <1404418756-10550-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1404418756-10550-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404418756-10550-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rickard,

Since this is a probe function there is also no need to release the devm_*
resources in the i2c_pxa_remove function, this leads to double free.

Also I have a few nit-pick comments below.

On Thu, Jul 03, 2014 at 10:19:16PM +0200, Rickard Strandqvist wrote:
> Fix for possible null pointer dereferenc, and there is a risk for memory leak if something unexpected happens and the function returns.
> It now use Managed Device Resource instead.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index be671f7..2edb633 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1141,10 +1141,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	struct resource *res = NULL;
>  	int ret, irq;
>  
> -	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
> +	i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
>  	if (!i2c) {
>  		ret = -ENOMEM;
> -		goto emalloc;
> +		goto err_nothing_to_release;

Perhaps its a good idea to return directly here, then the label
err_nothing_to_release can be removed.

>  	}
>  
>  	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
> @@ -1154,18 +1154,19 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	if (ret > 0)
>  		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>  	if (ret < 0)
> -		goto eclk;
> +		goto err_nothing_to_release;

Same here.

>  
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(dev, 0);
>  	if (res == NULL || irq < 0) {
>  		ret = -ENODEV;
> -		goto eclk;
> +		goto err_nothing_to_release;

Same here.

>  	}
>  
> -	if (!request_mem_region(res->start, resource_size(res), res->name)) {
> +	if (!devm_request_mem_region(&dev->dev, res->start,
> +				resource_size(res), res->name)) {
>  		ret = -ENOMEM;
> -		goto eclk;
> +		goto emalloc;

We could also return directly here since the release_mem_region call should
be removed, as mentioned in Jingoos reply.

>  	}
>  
>  	i2c->adap.owner   = THIS_MODULE;
> @@ -1176,16 +1177,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  
>  	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
>  
> -	i2c->clk = clk_get(&dev->dev, NULL);
> +	i2c->clk = devm_clk_get(&dev->dev, NULL);
>  	if (IS_ERR(i2c->clk)) {
>  		ret = PTR_ERR(i2c->clk);
> -		goto eclk;
> +		goto emalloc;

Same here.

>  	}
>  
> -	i2c->reg_base = ioremap(res->start, resource_size(res));
> -	if (!i2c->reg_base) {
> +	i2c->reg_base = devm_ioremap_resource(&adev->dev, res));
> +	if (IS_ERR(i2c->reg_base)) {
>  		ret = -EIO;
> -		goto eremap;
> +		goto emalloc;

Same here.

>  	}
>  
>  	i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
> @@ -1227,10 +1228,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  		i2c->adap.algo = &i2c_pxa_pio_algorithm;
>  	} else {
>  		i2c->adap.algo = &i2c_pxa_algorithm;
> -		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
> -				  dev_name(&dev->dev), i2c);
> +		ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
> +				 IRQF_SHARED, dev_name(&dev->dev), i2c);
>  		if (ret)
> -			goto ereqirq;
> +			goto emalloc;

Same here.

>  	}
>  
>  	i2c_pxa_reset(i2c);
> @@ -1261,15 +1262,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  eadapt:
>  	if (!i2c->use_pio)
>  		free_irq(irq, i2c);

The free_irq() call should also be removed since devm_request_irq() was used.

> -ereqirq:
> -	clk_disable_unprepare(i2c->clk);
> -	iounmap(i2c->reg_base);
> -eremap:
> -	clk_put(i2c->clk);
> -eclk:
> -	kfree(i2c);
>  emalloc:
>  	release_mem_region(res->start, resource_size(res));
> +err_nothing_to_release:
>  	return ret;
>  }
>

Best regards,

Emil Goode
