Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaJWIo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:44:26 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:58208 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaJWIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:44:22 -0400
X-ASG-Debug-ID: 1414053858-0759e74a7183ab90002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Thu, 23 Oct 2014 10:44:05 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?utf-8?B?UmVuw6k=?= Moll <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 12/13] power: reset: ltc2952: make trigger input optional
Message-ID: <20141023084404.GD2383@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 12/13] power: reset: ltc2952: make trigger input optional
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
 <1413988270-28092-13-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1413988270-28092-13-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1414053858
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10846
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:31:09PM +0200, Frans Klaver wrote:
> Currently the ltc2952 supports only one button sequence to initiate
> powerdown. This is not always desirable, as even prolonged button
> presses can happen in use.
> 
> Allow ltc2952 users to pick their own power down sequence, by making the
> trigger input optional. Since this still means that the ltc2952 may
> power down the platform if the power button is pressed for about 5
> seconds, we still need to make sure to start the watchdog toggle to
> prolong the system power for as long as we need it.
> 
> This will still allow the system to control power using the kill signal.
> 
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/power/reset/ltc2952-poweroff.c | 87 +++++++++++++++++++++-------------
>  1 file changed, 55 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
> index fda2735..72e3d7f 100644
> --- a/drivers/power/reset/ltc2952-poweroff.c
> +++ b/drivers/power/reset/ltc2952-poweroff.c
> @@ -32,7 +32,9 @@
>   * - trigger (input)
>   *     A level change indicates the shut-down trigger. If it's state reverts
>   *     within the time-out defined by trigger_delay, the shut down is not
> - *     executed.
> + *     executed. If no pin is assigned to this input, the driver will start the
> + *     watchdog toggle immediately. The chip will only power off the system if
> + *     it is requested to do so through the kill line.
>   *
>   * - watchdog (output)
>   *     Once a shut down is triggered, the driver will toggle this signal,
> @@ -116,15 +118,10 @@ static enum hrtimer_restart ltc2952_poweroff_timer_wde(struct hrtimer *timer)
>  	return HRTIMER_RESTART;
>  }
>  
> -static enum hrtimer_restart
> -ltc2952_poweroff_timer_trigger(struct hrtimer *timer)
> +static void ltc2952_poweroff_start_wde(struct ltc2952_poweroff *data)
>  {
> -	struct ltc2952_poweroff *data = to_ltc2952(timer, timer_trigger);
> -	int ret = hrtimer_start(&data->timer_wde,
> -				data->wde_interval, HRTIMER_MODE_REL);
> -
> -	if (ret) {
> -		dev_err(data->dev, "unable to start the timer\n");
> +	if (hrtimer_start(&data->timer_wde, data->wde_interval,
> +			  HRTIMER_MODE_REL)) {
>  		/*
>  		 * The device will not toggle the watchdog reset,
>  		 * thus shut down is only safe if the PowerPath controller
> @@ -133,10 +130,17 @@ ltc2952_poweroff_timer_trigger(struct hrtimer *timer)
>  		 *
>  		 * Only sending a warning as the system will power-off anyway
>  		 */
> +		dev_err(data->dev, "unable to start the timer\n");
>  	}
> +}
>  
> -	dev_info(data->dev, "executing shutdown\n");
> +static enum hrtimer_restart
> +ltc2952_poweroff_timer_trigger(struct hrtimer *timer)
> +{
> +	struct ltc2952_poweroff *data = to_ltc2952(timer, timer_trigger);
>  
> +	ltc2952_poweroff_start_wde(data);
> +	dev_info(data->dev, "executing shutdown\n");
>  	orderly_poweroff(true);
>  
>  	return HRTIMER_NORESTART;
> @@ -190,7 +194,7 @@ static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
>  
>  static int ltc2952_poweroff_init(struct platform_device *pdev)
>  {
> -	int ret, virq;
> +	int ret;
>  	struct ltc2952_poweroff *data = platform_get_drvdata(pdev);
>  
>  	ltc2952_poweroff_default(data);
> @@ -210,29 +214,48 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	data->gpio_trigger = devm_gpiod_get(&pdev->dev, "trigger",
> -					    GPIOD_IN);
> -	if (IS_ERR(ltc2952_data->gpio_trigger)) {
> -		ret = PTR_ERR(ltc2952_data->gpio_trigger);
> -		dev_err(&pdev->dev, "unable to claim gpio \"trigger\"\n");
> -		return ret;
> -	}
> -
> -	virq = gpiod_to_irq(data->gpio_trigger);
> -	if (virq < 0) {
> -		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
> -		return ret;
> +	data->gpio_trigger = devm_gpiod_get(&pdev->dev, "trigger", GPIOD_IN);
> +	if (IS_ERR(data->gpio_trigger)) {
> +		/*
> +		 * It's not a problem if the trigger gpio isn't available, but
> +		 * it is worth a warning if its use was defined in the device
> +		 * tree.
> +		 */
> +		if (PTR_ERR(data->gpio_trigger) != -ENOENT)
> +			dev_err(&pdev->dev,
> +				"unable to claim gpio \"trigger\"\n");
> +		data->gpio_trigger = NULL;
>  	}

I just realized devm_gpiod_get_optional() may be slightly cleaner here,
but the difference isn't that big in the end:

+	data->gpio_trigger = devm_gpiod_get_optional(&pdev->dev, "trigger",
+						     GPIOD_IN);
+	if (IS_ERR(data->gpio_trigger)) {
+		/*
+		 * It's not a problem if the trigger gpio isn't available, but
+		 * it is worth a warning if its use was defined in the device
+		 * tree.
+		 */
+		dev_err(&pdev->dev, "unable to claim gpio \"trigger\"\n");
+		data->gpio_trigger = NULL;
 	}

>  
> -	ret = devm_request_irq(&pdev->dev, virq,
> -			       ltc2952_poweroff_handler,
> -			       (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
> -			       "ltc2952-poweroff",
> -			       data);
> -
> -	if (ret) {
> -		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
> -		return ret;
> +	if (devm_request_irq(&pdev->dev, gpiod_to_irq(data->gpio_trigger),
> +			     ltc2952_poweroff_handler,
> +			     (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
> +			     "ltc2952-poweroff",
> +			     data)) {
> +		/*
> +		 * Some things may have happened:
> +		 * - No trigger input was defined
> +		 * - Claiming the GPIO failed
> +		 * - We could not map to an IRQ
> +		 * - We couldn't register an interrupt handler
> +		 *
> +		 * None of these really are problems, but all of them
> +		 * disqualify the push button from controlling the power.
> +		 *
> +		 * It is therefore important to note that if the ltc2952
> +		 * detects a button press for long enough, it will still start
> +		 * its own powerdown window and cut the power on us if we don't
> +		 * start the watchdog trigger.
> +		 */
> +		if (data->gpio_trigger) {
> +			dev_warn(&pdev->dev,
> +				 "unable to configure the trigger interrupt\n");
> +			devm_gpiod_put(&pdev->dev, data->gpio_trigger);
> +			data->gpio_trigger = NULL;
> +		}
> +		dev_info(&pdev->dev,
> +			 "power down trigger input will not be used\n");
> +		ltc2952_poweroff_start_wde(data);
>  	}
>  
>  	return 0;
> -- 
> 2.1.0
> 
