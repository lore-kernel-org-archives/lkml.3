Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3EaO7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:59:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3EaO7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:59:25 -0400
Message-ID: <51A8B9EA.6030604@ti.com>
Date: Fri, 31 May 2013 17:55:38 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 11/11] i2c: omap: enhance pinctrl support
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com> <1369995191-20855-12-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1369995191-20855-12-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 01:13 PM, Hebbar Gururaja wrote:
> Amend the I2C omap pin controller to optionally take a pin control
> handle and set the state of the pins to:
>
> - "default" on boot, resume and before performing an i2c transfer
> - "idle" after initial default, after resume default, and after each
> i2c xfer
> - "sleep" on suspend()
>
> By optionally putting the pins into sleep state in the suspend callback
> we can accomplish two things.
> - One is to minimize current leakage from pins and thus save power,
> - second, we can prevent the IP from driving pins output in an
> uncontrolled manner, which may happen if the power domain drops the
> domain regulator.
>
> Note:
> A .suspend & .resume callback is added which simply puts the pins to sleep
> state upon suspend & are moved to default & idle state upon resume.
>
> If any of the above pin states are missing in dt, a warning message
> about the missing state is displayed.
> If certain pin-states are not available, to remove this warning message
> pass respective state name with null phandler.
>
> (Changes based on i2c-nomadik.c)
>
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> ---
> :100644 100644 e02f9e3... 588ba28... M	drivers/i2c/busses/i2c-omap.c
>   drivers/i2c/busses/i2c-omap.c |  112 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 105 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index e02f9e3..588ba28 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -214,7 +214,11 @@ struct omap_i2c_dev {
>   	u16			westate;
>   	u16			errata;
>   
> -	struct pinctrl		*pins;
> +	/* Three pin states - default, idle & sleep */
> +	struct pinctrl			*pinctrl;
> +	struct pinctrl_state		*pins_default;
> +	struct pinctrl_state		*pins_idle;
> +	struct pinctrl_state		*pins_sleep;
>   };
>   
>   static const u8 reg_map_ip_v1[] = {
> @@ -641,6 +645,11 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>   	if (IS_ERR_VALUE(r))
>   		goto out;
>   
The current HWMOD framework configures PINs to enable state before 
enabling the device and
switch PINs to idle state after disabling the device. Why here its done 
in different order?
> +	/* Optionaly enable pins to be muxed in and configured */
> +	if (!IS_ERR(dev->pins_default))
> +		if (pinctrl_select_state(dev->pinctrl, dev->pins_default))
> +			dev_err(dev->dev, "could not set default pins\n");
> +
>   	r = omap_i2c_wait_for_bb(dev);
>   	if (r < 0)
>   		goto out;
> @@ -664,7 +673,13 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>   
>   out:
>   	pm_runtime_mark_last_busy(dev->dev);
> +
>   	pm_runtime_put_autosuspend(dev->dev);
> +	/* Optionally let pins go into idle state */
> +	if (!IS_ERR(dev->pins_idle))
> +		if (pinctrl_select_state(dev->pinctrl, dev->pins_idle))
> +			dev_err(dev->dev, "could not set pins to idle state\n");
> +
>   	return r;
>   }
>   
> @@ -1123,14 +1138,47 @@ omap_i2c_probe(struct platform_device *pdev)
>   		dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
>   	}
>   
> -	dev->pins = devm_pinctrl_get_select_default(&pdev->dev);
> -	if (IS_ERR(dev->pins)) {
> -		if (PTR_ERR(dev->pins) == -EPROBE_DEFER)
> +	dev->pinctrl = devm_pinctrl_get(&pdev->dev);
May be struct device ->pins->p can be used instead of dev->pinctrl?
> +	if (!IS_ERR(dev->pinctrl)) {
> +		dev->pins_default = pinctrl_lookup_state(dev->pinctrl,
> +							 PINCTRL_STATE_DEFAULT);
> +		if (IS_ERR(dev->pins_default))
> +			dev_dbg(&pdev->dev, "could not get default pinstate\n");
> +		else
> +			if (pinctrl_select_state(dev->pinctrl,
> +						 dev->pins_default))
> +				dev_err(&pdev->dev,
> +					"could not set default pinstate\n");
Don't need to set Default pin state
Default pins state is applied by DD framework automatically before 
device probing
and stored in struct device ->pins->default_state
> +
> +		dev->pins_idle = pinctrl_lookup_state(dev->pinctrl,
> +						      PINCTRL_STATE_IDLE);
> +		if (IS_ERR(dev->pins_idle))
> +			dev_dbg(&pdev->dev, "could not get idle pinstate\n");
> +		else
> +			/* If possible, let's idle until the first transfer */
> +			if (pinctrl_select_state(dev->pinctrl, dev->pins_idle))
> +				dev_err(&pdev->dev,
> +					"could not set idle pinstate\n");
> +
> +		dev->pins_sleep = pinctrl_lookup_state(dev->pinctrl,
> +						       PINCTRL_STATE_SLEEP);
> +		if (IS_ERR(dev->pins_sleep))
> +			dev_dbg(&pdev->dev, "could not get sleep pinstate\n");
> +	} else {
> +		if (PTR_ERR(dev->pinctrl) == -EPROBE_DEFER)
>   			return -EPROBE_DEFER;
>   
> -		dev_warn(&pdev->dev, "did not get pins for i2c error: %li\n",
> -			 PTR_ERR(dev->pins));
> -		dev->pins = NULL;
> +		/*
> +		* Since we continue even when pinctrl node is not found,
> +		* Invalidate pins as not available. This is to make sure that
> +		* IS_ERR(pins_xxx) results in failure when used.
> +		*/
> +		dev->pins_default = ERR_PTR(-ENODATA);
> +		dev->pins_idle = ERR_PTR(-ENODATA);
> +		dev->pins_sleep = ERR_PTR(-ENODATA);
> +
> +		dev_dbg(&pdev->dev, "did not get pins for i2c error: %li\n",
> +			PTR_ERR(dev->pinctrl));
>   	}
>   
>   	dev->dev = &pdev->dev;
> @@ -1300,6 +1348,10 @@ static int omap_i2c_runtime_suspend(struct device *dev)
>   		omap_i2c_read_reg(_dev, OMAP_I2C_STAT_REG);
>   	}
>   
> +	if (!IS_ERR(_dev->pins_idle))
> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_idle))
> +			dev_err(dev, "could not set pins to idle state\n");
> +
It's done in omap_i2c_xfer
>   	return 0;
>   }
>   
> @@ -1311,13 +1363,59 @@ static int omap_i2c_runtime_resume(struct device *dev)
>   	if (!_dev->regs)
>   		return 0;
>   
> +	/* Optionally place the pins to the default state */
> +	if (!IS_ERR(_dev->pins_default))
> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_default))
> +			dev_err(dev, "could not set pins to default state\n");
> +
It's done in omap_i2c_xfer
>   	__omap_i2c_init(_dev);
>   
>   	return 0;
>   }
>   #endif /* CONFIG_PM_RUNTIME */
>   
> +#ifdef CONFIG_PM_SLEEP
> +static int omap_i2c_suspend(struct device *dev)
Please, use .suspend_noirq() - it's possible that I2C will be used
even after "device suspend" stage especially on SMP platforms((( ),
but its prohibited to use it after "suspend_noirq" stage (
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
> +
> +	pm_runtime_get_sync(dev);
Here is the better way to detect late I2C activities during suspending:
     i2c_lock_adapter(&_dev->adapter);

     /* Check for active I2C transaction */
     if (atomic_read(&dev->power.usage_count) > 1) {
         dev_info(dev,
              "active I2C transaction detected - suspend aborted\n");
         return -EBUSY;
     }

     i2c_unlock_adapter(&_dev->adapter);
> +	if (omap_i2c_wait_for_bb(_dev) < 0) {
> +		pm_runtime_put_sync(dev);
> +		return -EBUSY;
> +	}
> +	pm_runtime_put_sync(dev);
> +
> +	if (!IS_ERR(_dev->pins_sleep))
> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_sleep))
> +			dev_err(dev, "could not set pins to sleep state\n");
> +
> +	return 0;
> +}
Not sure it's right - Lest assume suspend_noirq() is used here.
Then, at this point, OMAP device framework will disable device 
(_od_suspend_noirq()).
But PINs will be switched to IDLE state before that. Is it ok?
Possibly Kevin could clarify this point?
> +
> +static int omap_i2c_resume(struct device *dev)
Please, use .resume_noirq()
> +{
The same is here - OMAP device framework will enable device 
(_od_suspend_noirq()) here.
But PINs are still in IDLE state???
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
> +
> +	/* First go to the default state */
> +	if (!IS_ERR(_dev->pins_default))
> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_default))
> +			dev_err(dev, "could not set pins to default state\n");
> +
> +	/* Then let's idle the pins until the next transfer happens */
> +	if (!IS_ERR(_dev->pins_idle))
> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_idle))
> +			dev_err(dev, "could not set pins to idle state\n");
> +
This is wrong - at this moment I2C device can be as in Enabled state
as in Disabled
> +	return 0;
> +}
> +#endif
> +
> +
>   static struct dev_pm_ops omap_i2c_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(omap_i2c_suspend, omap_i2c_resume)
>   	SET_RUNTIME_PM_OPS(omap_i2c_runtime_suspend,
>   			   omap_i2c_runtime_resume, NULL)
>   };

