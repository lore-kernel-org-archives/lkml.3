Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaGIR6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:58:37 -0400
Received: from sym2.noone.org ([178.63.92.236]:51271 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbaGIR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:58:35 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jul 2014 13:58:35 EDT
Date: Wed, 9 Jul 2014 19:49:39 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Kamil Debski <k.debski@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, t.figa@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH] hwmon: pwm-fan: Add pwm-fan driver
Message-ID: <20140709174939.GE27655@distanz.ch>
References: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-09 at 16:53:20 +0200, Kamil Debski <k.debski@samsung.com> wrote:
> The pwm-fan driver enables control of fans connected to PWM lines.
> This driver uses the PWM framework, so it is compatible with all
> PWM devices that provide drivers through the PWM framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
>  drivers/hwmon/Kconfig                              |    9 +
>  drivers/hwmon/Makefile                             |    1 +
>  drivers/hwmon/pwm-fan.c                            |  199 ++++++++++++++++++++
>  4 files changed, 221 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/pwm-fan.txt
>  create mode 100644 drivers/hwmon/pwm-fan.c

[...]

> diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
> new file mode 100644
> index 0000000..78fa627
> --- /dev/null
> +++ b/drivers/hwmon/pwm-fan.c
> @@ -0,0 +1,199 @@

[...]

> +#ifdef CONFIG_PM_SLEEP
> +static int pwm_fan_suspend(struct device *dev)
> +{
> +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> +
> +	return pwm_config(ctx->pwm, 0, ctx->pwm->period);
> +}
> +
> +static int pwm_fan_resume(struct device *dev)
> +{
> +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> +
> +	return pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);
> +}
> +
> +static SIMPLE_DEV_PM_OPS(pwm_fan_pm, pwm_fan_suspend, pwm_fan_resume);

If you move this out of #ifdef CONFIG_PM_SLEEP, you won't need the
#ifdef around driver.pm below [1]. SIMPLE_DEV_PM_OPS will just define an
empty struct dev_pm_os if CONFIG_PM_LSEEP is not defined.

> +#endif
> +
> +
> +
> +static struct of_device_id of_pwm_fan_match[] = {
> +	{ .compatible = "pwm-fan", },
> +	{},
> +};
> +
> +static struct platform_driver pwm_fan_driver = {
> +	.probe		= pwm_fan_probe,
> +	.remove		= pwm_fan_remove,
> +	.driver	= {
> +		.name		= "pwm-fan",
> +#ifdef CONFIG_PM_SLEEP
> +		.pm		= &pwm_fan_pm,
> +#endif

[1] #ifdef CONFIG_PM_SLEEP not needed with the above change.

> +		.of_match_table	= of_match_ptr(of_pwm_fan_match),
> +	},
> +};
> +
> +module_platform_driver(pwm_fan_driver);
> +
> +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> +MODULE_ALIAS("platform:pwm-fan");
> +MODULE_DESCRIPTION("PWM FAN driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.9.5
