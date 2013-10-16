Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3JPGjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:39:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42961 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3JPGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:39:50 -0400
Date: Tue, 15 Oct 2013 23:39:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] input: tc3589x-keypad: support probing from device
 tree
Message-ID: <20131016063947.GD4282@core.coreip.homeip.net>
References: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:21:11PM +0200, Linus Walleij wrote:
> Implement device tree probing for the tc3589x keypad driver.
> This is modeled on the STMPE keypad driver and tested on the
> Ux500 TVK1281618 UIB.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Looks good, should I merge it or you want to take it through another
tree??

> ---
>  drivers/input/keyboard/tc3589x-keypad.c | 63 +++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
> index 208de7c..f6ec0d7 100644
> --- a/drivers/input/keyboard/tc3589x-keypad.c
> +++ b/drivers/input/keyboard/tc3589x-keypad.c
> @@ -297,6 +297,62 @@ static void tc3589x_keypad_close(struct input_dev *input)
>  	tc3589x_keypad_disable(keypad);
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct tc3589x_keypad_platform_data *
> +tc3589x_keypad_of_probe(struct device *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct tc3589x_keypad_platform_data *plat;
> +	u32 debounce_ms;
> +	int proplen;
> +
> +	if (!np)
> +		return ERR_PTR(-ENODEV);
> +
> +	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
> +	if (!plat)
> +		return ERR_PTR(-ENOMEM);
> +
> +	of_property_read_u8(np, "keypad,num-columns", &plat->kcol);
> +	of_property_read_u8(np, "keypad,num-rows", &plat->krow);
> +	if (!plat->krow || !plat->kcol ||
> +	     plat->krow > TC_KPD_ROWS || plat->kcol > TC_KPD_COLUMNS) {
> +		dev_err(dev,
> +			"keypad columns/rows not properly specified (%ux%u)\n",
> +			plat->kcol, plat->krow);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (!of_get_property(np, "linux,keymap", &proplen)) {
> +		dev_err(dev, "property linux,keymap not found\n");
> +		return ERR_PTR(-ENOENT);
> +	}
> +
> +	plat->no_autorepeat = of_property_read_bool(np, "linux,no-autorepeat");
> +	plat->enable_wakeup = of_property_read_bool(np, "linux,wakeup");
> +
> +	/* The custom delay format is ms/16 */
> +	of_property_read_u32(np, "debounce-delay-ms", &debounce_ms);
> +	if (debounce_ms)
> +		plat->debounce_period = debounce_ms * 16;
> +	else
> +		plat->debounce_period = TC_KPD_DEBOUNCE_PERIOD;
> +
> +	plat->settle_time = TC_KPD_SETTLE_TIME;
> +	/* FIXME: should be property of the IRQ resource? */
> +	plat->irqtype = IRQF_TRIGGER_FALLING;
> +
> +	return plat;
> +}
> +#else
> +static inline const struct tc3589x_keypad_platform_data *
> +tc3589x_keypad_of_probe(struct device *dev)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +#endif
> +
> +
>  static int tc3589x_keypad_probe(struct platform_device *pdev)
>  {
>  	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
> @@ -307,8 +363,11 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
>  
>  	plat = tc3589x->pdata->keypad;
>  	if (!plat) {
> -		dev_err(&pdev->dev, "invalid keypad platform data\n");
> -		return -EINVAL;
> +		plat = tc3589x_keypad_of_probe(&pdev->dev);
> +		if (IS_ERR(plat)) {
> +			dev_err(&pdev->dev, "invalid keypad platform data\n");
> +			return PTR_ERR(plat);
> +		}
>  	}
>  
>  	irq = platform_get_irq(pdev, 0);
> -- 
> 1.8.3.1
> 

-- 
Dmitry
