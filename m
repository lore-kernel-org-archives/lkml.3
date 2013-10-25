Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3JYUFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:05:43 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:36521 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3JYUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:05:28 -0400
Date: Fri, 25 Oct 2013 23:05:19 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 3/3] Input: twl4030-pwrbutton: simplify driver using
 devm_*
Message-ID: <20131025200519.GF17447@blackmetal.musicnaut.iki.fi>
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382626126-12565-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 04:48:46PM +0200, Sebastian Reichel wrote:
> Use managed irq resource to simplify the driver.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Reviewed-by: Aaro Koskinen <aaro.koskinen@iki.fi>

> ---
>  drivers/input/misc/twl4030-pwrbutton.c | 26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index 48639ff..be1759c 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -58,7 +58,7 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  	int irq = platform_get_irq(pdev, 0);
>  	int err;
>  
> -	pwr = input_allocate_device();
> +	pwr = devm_input_allocate_device(&pdev->dev);
>  	if (!pwr) {
>  		dev_dbg(&pdev->dev, "Can't allocate power button\n");
>  		return -ENOMEM;
> @@ -70,40 +70,23 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  	pwr->phys = "twl4030_pwrbutton/input0";
>  	pwr->dev.parent = &pdev->dev;
>  
> -	err = request_threaded_irq(irq, NULL, powerbutton_irq,
> +	err = devm_request_threaded_irq(&pwr->dev, irq, NULL, powerbutton_irq,
>  			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  			"twl4030_pwrbutton", pwr);
>  	if (err < 0) {
>  		dev_err(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
> -		goto free_input_dev;
> +		return err;
>  	}
>  
>  	err = input_register_device(pwr);
>  	if (err) {
>  		dev_err(&pdev->dev, "Can't register power button: %d\n", err);
> -		goto free_irq;
> +		return err;
>  	}
>  
>  	platform_set_drvdata(pdev, pwr);
>  
>  	return 0;
> -
> -free_irq:
> -	free_irq(irq, pwr);
> -free_input_dev:
> -	input_free_device(pwr);
> -	return err;
> -}
> -
> -static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
> -{
> -	struct input_dev *pwr = platform_get_drvdata(pdev);
> -	int irq = platform_get_irq(pdev, 0);
> -
> -	free_irq(irq, pwr);
> -	input_unregister_device(pwr);
> -
> -	return 0;
>  }
>  
>  #if IS_ENABLED(CONFIG_OF)
> @@ -116,7 +99,6 @@ MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
>  
>  static struct platform_driver twl4030_pwrbutton_driver = {
>  	.probe		= twl4030_pwrbutton_probe,
> -	.remove		= __exit_p(twl4030_pwrbutton_remove),
>  	.driver		= {
>  		.name	= "twl4030_pwrbutton",
>  		.owner	= THIS_MODULE,
> -- 
> 1.8.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
