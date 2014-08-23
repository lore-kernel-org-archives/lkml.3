Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaHWRQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:16:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50565 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaHWRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:16:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53F8CC58.2030406@roeck-us.net>
Date: Sat, 23 Aug 2014 10:16:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Evgeny Boger <boger@contactless.ru>, linux-watchdog@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for always enabled watchdog timers
References: <1408236338-12555-1-git-send-email-boger@contactless.ru>
In-Reply-To: <1408236338-12555-1-git-send-email-boger@contactless.ru>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2014 05:45 PM, Evgeny Boger wrote:
> From: Evgeny Boger <boger@contactless.ru>
>
> Add option to use with watchdog timers which are always enabled
> in hardware, i.e. there is no way to enable/disable it via GPIO pin.
> The driver will start pinging WDT immediately upon loading
> and will continue to do so even after stopping the watchdog.
>
The headline needs a reference to the affected driver.

Also, please copy the dt mailing list and maintainers.

> Signed-off-by: Evgeny Boger <boger@contactless.ru>
> ---
>   .../devicetree/bindings/watchdog/gpio-wdt.txt      | 14 ++++++-
>   drivers/watchdog/gpio_wdt.c                        | 45 +++++++++++++++++-----
>   2 files changed, 48 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> index 37afec1..1f8ca46 100644
> --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> @@ -12,8 +12,11 @@ Required Properties:
>       the opposite level disables the WDT. Active level is determined
>       by the GPIO flags.
>   - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
> +- always-enabled: Use with wathdog timer which is always enabled

s/wathdog/watchdog/

> +  in hardware, i.e. there is no way to enable/disable it via GPIO pin.
> +  Driver will start pinging WDT immediately upon loading.
>
> -Example:
> +Examples:
>   	watchdog: watchdog {
>   		/* ADM706 */
>   		compatible = "linux,wdt-gpio";
> @@ -21,3 +24,12 @@ Example:
>   		hw_algo = "toggle";
>   		hw_margin_ms = <1600>;
>   	};
> +
> +	watchdog: watchdog {
> +		/* TPS3813 */
> +		compatible = "linux,wdt-gpio";
> +		gpios = <&gpio3 9 GPIO_ACTIVE_LOW>;
> +		hw_algo = "toggle";
> +		hw_margin_ms = <10000>;
> +		always-enabled;
> +	};
> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
> index 220a9e0..29f9bff 100644
> --- a/drivers/watchdog/gpio_wdt.c
> +++ b/drivers/watchdog/gpio_wdt.c
> @@ -37,6 +37,8 @@ struct gpio_wdt_priv {
>   	struct notifier_block	notifier;
>   	struct timer_list	timer;
>   	struct watchdog_device	wdd;
> +	bool		always_enabled;
> +	bool		started;

Please keep indentation aligned with existing code.

>   };
>
>   static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
> @@ -48,10 +50,8 @@ static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
>   		gpio_direction_input(priv->gpio);
>   }
>
> -static int gpio_wdt_start(struct watchdog_device *wdd)
> +static int gpio_wdt_start_timer(struct gpio_wdt_priv *priv)

Unfortunate function name. gpio_wdt_enable would be more appropriate,
or maybe __gpio_wdt_start.

>   {
> -	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
> -
>   	priv->state = priv->active_low;
>   	gpio_direction_output(priv->gpio, priv->state);
>   	priv->last_jiffies = jiffies;
> @@ -60,12 +60,28 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
>   	return 0;
>   }
>
> -static int gpio_wdt_stop(struct watchdog_device *wdd)
> +static int gpio_wdt_start(struct watchdog_device *wdd)
>   {
>   	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
> +	priv->started = true;
> +	if (priv->always_enabled) {
> +		/* harware ping timer is already enabled */

s/harware/hardware/

> +		priv->last_jiffies = jiffies;
> +	} else {
> +		gpio_wdt_start_timer(priv);
> +	}
>
> -	mod_timer(&priv->timer, 0);
> -	gpio_wdt_disable(priv);
> +	return 0;
> +}
> +
> +static int gpio_wdt_stop(struct watchdog_device *wdd)
> +{
> +	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
> +	priv->started = false;
> +	if (!priv->always_enabled) {
> +		mod_timer(&priv->timer, 0);
> +		gpio_wdt_disable(priv);
> +	}
>
>   	return 0;
>   }
> @@ -91,10 +107,12 @@ static void gpio_wdt_hwping(unsigned long data)
>   	struct watchdog_device *wdd = (struct watchdog_device *)data;
>   	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>
> -	if (time_after(jiffies, priv->last_jiffies +
> -		       msecs_to_jiffies(wdd->timeout * 1000))) {
> -		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
> -		return;
> +	if (priv->started) {
> +		if (time_after(jiffies, priv->last_jiffies +
> +			       msecs_to_jiffies(wdd->timeout * 1000))) {
> +			dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
> +			return;
> +		}

No need to add another if and indentation level. Just make it

	if (priv->started &&
	    time_after(jiffies, priv->last_jiffies +
		...

	
>   	}
>
>   	/* Restart timer */
> @@ -197,6 +215,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>   	/* Use safe value (1/2 of real timeout) */
>   	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
>
> +	priv->always_enabled = of_property_read_bool(pdev->dev.of_node,
> +						"always-enabled");
> +
>   	watchdog_set_drvdata(&priv->wdd, priv);
>
>   	priv->wdd.info		= &gpio_wdt_ident;
> @@ -207,6 +228,7 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>   	if (watchdog_init_timeout(&priv->wdd, 0, &pdev->dev) < 0)
>   		priv->wdd.timeout = SOFT_TIMEOUT_DEF;
>
> +	priv->started = false;
>   	setup_timer(&priv->timer, gpio_wdt_hwping, (unsigned long)&priv->wdd);
>
>   	ret = watchdog_register_device(&priv->wdd);
> @@ -218,6 +240,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>   	if (ret)
>   		watchdog_unregister_device(&priv->wdd);
>
> +	if (priv->always_enabled)
> +		gpio_wdt_start_timer(priv);
> +

This will cause a problem if register_reboot_notifier failed. You'll have
to implement proper error handling for this case, something like the following.

	...
	priv->notifier.notifier_call = gpio_wdt_notify_sys;
	ret = register_reboot_notifier(&priv->notifier);
	if (ret)
		goto unregister;

	if (priv->always_enabled)
		gpio_wdt_enable(priv);

	return 0;

unregister:
	watchdog_unregister_device(&priv->wdd);
	return ret;
}

Guenter

