Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3CKQjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:39:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CKQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:39:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: Re: [PATCH 4/6] mfd: max8925: support dt for backlight
Date: Mon, 11 Mar 2013 16:39:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org, Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org> <1359992448-22229-4-git-send-email-haojian.zhuang@linaro.org>
In-Reply-To: <1359992448-22229-4-git-send-email-haojian.zhuang@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111639.00553.arnd@arndb.de>
X-Provags-ID: V02:K0:9F8N1auF4yMO9lRQGpoUEwHMj616wD7YWXp/JxvnhvJ
 Hh64pGWIAuxFeLsW9SESXu77P5zPKdTEdTqHYE7GKyPaNwKoPY
 fqTY+gnpeL1KI/6yNVngn80EXEmjd/FDdpZ0M+1sPFxyTn0T2F
 8ytVN12NS4jrJy3pDl7gArL++eJIOBZ/yRjI0auIYMTOutgJUo
 wJjRXHDBCjLDvQmHTGX5wqbhI3x34rW0m4uPwewUROCQj1cz9+
 O2lZMAiKr4p5lvvmp4dsZnyBabg/gTBGKxI783haXSqCWVgQ1e
 YtXRxzjO1c7NmPnQfZI5kfnWw7V2NO/UvsjI4TKPRzqAyptiFP
 0SSztLHZNSkQ7JMdZjfM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013, Haojian Zhuang wrote:
> From: Qing Xu <qingx@marvell.com>
> 
> Add device tree support in max8925 backlight.
> 
> Signed-off-by: Qing Xu <qingx@marvell.com>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Sorry, but after finding a build warning in this patch, I looked closer and
found more issues. I would recommend reverting this patch.

> diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
> index 2c9bce0..5ca11b0 100644
> --- a/drivers/video/backlight/max8925_bl.c
> +++ b/drivers/video/backlight/max8925_bl.c
> @@ -101,6 +101,29 @@ static const struct backlight_ops max8925_backlight_ops = {
>  	.get_brightness	= max8925_backlight_get_brightness,
>  };
>  
> +#ifdef CONFIG_OF
> +static int max8925_backlight_dt_init(struct platform_device *pdev,
> +			      struct max8925_backlight_pdata *pdata)
> +{
> +	struct device_node *nproot = pdev->dev.parent->of_node, *np;
> +	int dual_string;
> +
> +	if (!nproot)
> +		return -ENODEV;
> +	np = of_find_node_by_name(nproot, "backlight");
> +	if (!np) {
> +		dev_err(&pdev->dev, "failed to find backlight node\n");
> +		return -ENODEV;
> +	}

It is nonsense to look at the device node for the parent and then find
the child by using of_find_node_by_name(). What you should do instead
is ensure that the backlight platform device gets connected to the
DT device node by the MFD core. I did not think I'd use the ab8500
driver as a positive example, but it gets this right by using the
of_compatible member for the mfd_cell.

> +
> +	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
> +	pdata->dual_string = dual_string;

For boolean values, we should use of_property_read_bool, which checks
the presence of the property and returns "true" if it exists and false
otherwise. There is no need to assign a value to the property that way,
and it's more consistent with other drivers.

> +	return 0;
> +}
> +#else
> +#define max8925_backlight_dt_init(x, y)	(-1)
> +#endif

As I suggested in my earlier patch, the #ifdef is not necessary. I suggested
using "if (IS_ENABLED(CONFIG_OF))" earlier, but it's actually simpler
to just return from this function if no node was found. of_find_node_by_name
is already defined to an empty function returning NULL when CONFIG_OF
is turned off.

>  static int max8925_backlight_probe(struct platform_device *pdev)
>  {
>  	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
> @@ -147,6 +170,13 @@ static int max8925_backlight_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, bl);
>  
>  	value = 0;
> +	if (pdev->dev.parent->of_node && !pdata) {
> +		pdata = devm_kzalloc(&pdev->dev,
> +				     sizeof(struct max8925_backlight_pdata),
> +				     GFP_KERNEL);

Using a dynamic allocation for pdata is way overkill here, since the data is
only used in one place below and then never again. A proper method to
do this would be

	if (of_property_read_bool(pdev->dev.of_node, "maxim,max8925-dual-string"))
		value |= 2;

No need to have a separate function or complex parsing at all, and if CONFIG_OF
is disabled, the code goes away entirely.


> +		max8925_backlight_dt_init(pdev, pdata);
> +	}

Note that when you have a function whose return value is never checked, it
should not return errors but just "void".

> @@ -158,7 +188,6 @@ static int max8925_backlight_probe(struct platform_device *pdev)
>  	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
>  	if (ret < 0)
>  		goto out_brt;
> -
>  	backlight_update_status(bl);
>  	return 0;
>  out_brt:

Finally, there is no reason to remove the empty line. If it was a good idea
to remove it, that should probably be a separate patch to clean up the coding
style.

	Arnd
