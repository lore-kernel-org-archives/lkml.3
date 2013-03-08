Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CHGSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:18:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1395 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3CHGSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:18:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 22:18:22 -0800
Message-ID: <513982AB.2050506@nvidia.com>
Date: Fri, 8 Mar 2013 15:18:19 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v5] pwm_bl: Add support for backlight enable regulator
References: <1362690968-24854-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1362690968-24854-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 06:16 AM, Andrew Chew wrote:
> The backlight enable regulator is specified in the device tree node for
> backlight.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> Renamed en_supply to enable_supply to match the corresponding device tree
> property.
>
> Removed unnecessary check for pb->enable_supply validity.  This supply
> is mandatory, and probe will fail if it is not provided.
>
> Renamed the tracking bool from en_supply_enabled to enabled so that it's
> more generic.  Encapsulated pwm_enable() and pwm_disable() calls into the
> enabled check so that we never unnecessarily turn on or off the pwm if
> it's already been turned on or off.
>
>   .../bindings/video/backlight/pwm-backlight.txt     |   14 +++++
>   drivers/video/backlight/pwm_bl.c                   |   56 ++++++++++++++++----
>   2 files changed, 60 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> index 1e4fc72..7e2e089 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -10,6 +10,11 @@ Required properties:
>         last value in the array represents a 100% duty cycle (brightest).
>     - default-brightness-level: the default brightness level (index into the
>         array defined by the "brightness-levels" property)
> +  - enable-supply: A phandle to the regulator device tree node. This
> +      regulator will be turned on and off as the pwm is enabled and disabled.
> +      Many backlights are enabled via a GPIO. In this case, we instantiate
> +      a fixed regulator and give that to enable-supply. If a regulator
> +      is not needed, then provide a dummy fixed regulator.
>
>   Optional properties:
>     - pwm-names: a list of names for the PWM devices specified in the
> @@ -19,10 +24,19 @@ Optional properties:
>
>   Example:
>
> +	bl_en: fixed-regulator {
> +                compatible = "regulator-fixed";
> +                regulator-name = "bl-en-supply";
> +                regulator-boot-on;
> +                gpio = <&some_gpio>;
> +                enable-active-high;
> +	};
> +
>   	backlight {
>   		compatible = "pwm-backlight";
>   		pwms = <&pwm 0 5000000>;
>
>   		brightness-levels = <0 4 8 16 32 64 128 255>;
>   		default-brightness-level = <6>;
> +		enable-supply = <&bl_en>;
>   	};
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 069983c..c517d4a 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -20,10 +20,13 @@
>   #include <linux/pwm.h>
>   #include <linux/pwm_backlight.h>
>   #include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
>
>   struct pwm_bl_data {
>   	struct pwm_device	*pwm;
>   	struct device		*dev;
> +	bool			enabled;
> +	struct regulator	*enable_supply;
>   	unsigned int		period;
>   	unsigned int		lth_brightness;
>   	unsigned int		*levels;
> @@ -35,6 +38,38 @@ struct pwm_bl_data {
>   	void			(*exit)(struct device *);
>   };
>
> +static void pwm_backlight_enable(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> +
> +	/* Bail if we are already enabled. */
> +	if (pb->enabled)
> +		return;
> +
> +	pwm_enable(pb->pwm);
> +
> +	if (regulator_enable(pb->enable_supply) != 0)
> +		dev_warn(&bl->dev, "Failed to enable regulator");
> +
> +	pb->enabled = true;
> +}
> +
> +static void pwm_backlight_disable(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> +
> +	/* Bail if we are already disabled. */
> +	if (!pb->enabled)
> +		return;
> +
> +	if (regulator_disable(pb->enable_supply) != 0)
> +		dev_warn(&bl->dev, "Failed to disable regulator");
> +
> +	pwm_disable(pb->pwm);
> +
> +	pb->enabled = false;
> +}
> +
>   static int pwm_backlight_update_status(struct backlight_device *bl)
>   {
>   	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> @@ -52,7 +87,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>
>   	if (brightness == 0) {
>   		pwm_config(pb->pwm, 0, pb->period);
> -		pwm_disable(pb->pwm);
> +		pwm_backlight_disable(bl);
>   	} else {
>   		int duty_cycle;
>
> @@ -66,7 +101,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>   		duty_cycle = pb->lth_brightness +
>   		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
>   		pwm_config(pb->pwm, duty_cycle, pb->period);
> -		pwm_enable(pb->pwm);
> +		pwm_backlight_enable(bl);
>   	}
>
>   	if (pb->notify_after)
> @@ -145,12 +180,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
>   		data->max_brightness--;
>   	}
>
> -	/*
> -	 * TODO: Most users of this driver use a number of GPIOs to control
> -	 *       backlight power. Support for specifying these needs to be
> -	 *       added.
> -	 */
> -
>   	return 0;
>   }
>
> @@ -213,6 +242,13 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>   	pb->exit = data->exit;
>   	pb->dev = &pdev->dev;
>
> +	pb->enable_supply = devm_regulator_get(&pdev->dev, "enable");
> +	if (IS_ERR(pb->enable_supply)) {
> +		ret = PTR_ERR(pb->enable_supply);
> +		pb->enable_supply = NULL;

I don't think you need to set enable_supply to NULL since probe will 
fail anyway.

> +		goto err_alloc;
> +	}
> +
>   	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
>   	if (IS_ERR(pb->pwm)) {
>   		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
> @@ -268,7 +304,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>
>   	backlight_device_unregister(bl);
>   	pwm_config(pb->pwm, 0, pb->period);
> -	pwm_disable(pb->pwm);
> +	pwm_backlight_disable(bl);
>   	if (pb->exit)
>   		pb->exit(&pdev->dev);
>   	return 0;
> @@ -283,7 +319,7 @@ static int pwm_backlight_suspend(struct device *dev)
>   	if (pb->notify)
>   		pb->notify(pb->dev, 0);
>   	pwm_config(pb->pwm, 0, pb->period);
> -	pwm_disable(pb->pwm);
> +	pwm_backlight_disable(bl);
>   	if (pb->notify_after)
>   		pb->notify_after(pb->dev, 0);
>   	return 0;
>

Thierry might have other remarks, but this looks good globally to me, so

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Alex.

