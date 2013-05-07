Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3EGJZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:25:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43339 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab3EGJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:25:09 -0400
Date: Tue, 7 May 2013 11:24:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Robin Holt <holt@sgi.com>
Cc: Qing Xu <qingx@marvell.com>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: How does commit 47ec340c not introduce a bug?
Message-ID: <20130507092428.GK23285@pengutronix.de>
References: <20130507091734.GM3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130507091734.GM3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 07, 2013 at 04:17:34AM -0500, Robin Holt wrote:
> I noticed a warning while cross-compiling all arm defconfigs.
> 
> The mmp2_defconfig gave this warning:
> 
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
> 
> This appears to have been introduced by the above commit when !CONFIG_OF
> 
> Looking at this more closely, I am not sure how this was ever intended
> to be handled or how the errors returned in the CONFIG_OF case were
> intended to be handled as the return from max8925_backlight_dt_init is
> always ignored.
> 
> I think this needs some more attention, but do not feel like I know
> enough about it or have any means to test it to weigh in.
> 
> Thanks,
> Robin
> 
> 
> commit 47ec340cb8e232671e7c4a4689ff32c3bdf329da
> Author: Qing Xu <qingx@marvell.com>
> Date:   Mon Feb 4 23:40:45 2013 +0800
> 
>     mfd: max8925: Support dt for backlight
>     
>     Add device tree support in max8925 backlight.
>     
>     Signed-off-by: Qing Xu <qingx@marvell.com>
>     Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
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
> +
> +	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
> +	pdata->dual_string = dual_string;
> +	return 0;
> +}
> +#else
> +#define max8925_backlight_dt_init(x, y)	(-1)
It's probably best to make this:

static inline max8925_backlight_dt_init(struct platform_device *pdev,
				struct max8925_backlight_pdata *pdata)
{
	return -ENODEV;
}

> +#endif
> +
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
> +		max8925_backlight_dt_init(pdev, pdata);
> +	}
> +
>  	if (pdata) {
>  		if (pdata->lxw_scl)
>  			value |= (1 << 7);
> @@ -158,7 +188,6 @@ static int max8925_backlight_probe(struct platform_device *pdev)
>  	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
>  	if (ret < 0)
>  		goto out_brt;
> -
>  	backlight_update_status(bl);
>  	return 0;
>  out_brt:
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
