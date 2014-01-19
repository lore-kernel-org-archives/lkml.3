Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaASThK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:37:10 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:47936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaASThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:37:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: mt9p031: Check return value of clk_prepare_enable/clk_set_rate
Date: Sun, 19 Jan 2014 20:37:49 +0100
Message-ID: <2163823.ZEyLsU58On@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.25-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1389950253-31251-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1389950253-31251-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Friday 17 January 2014 14:47:33 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> clk_set_rate(), clk_prepare_enable() functions can fail, so check the return
> values to avoid surprises.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/i2c/mt9p031.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e5ddf47..dbe34d7 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -222,12 +222,15 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
> 
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
>  	struct mt9p031_platform_data *pdata = mt9p031->pdata;
> +	int ret;
> 
>  	mt9p031->clk = devm_clk_get(&client->dev, NULL);
>  	if (IS_ERR(mt9p031->clk))
>  		return PTR_ERR(mt9p031->clk);
> 
> -	clk_set_rate(mt9p031->clk, pdata->ext_freq);
> +	ret = clk_set_rate(mt9p031->clk, pdata->ext_freq);
> +	if (ret < 0)
> +		return ret;
> 
>  	mt9p031->pll.ext_clock = pdata->ext_freq;
>  	mt9p031->pll.pix_clock = pdata->target_freq;
> @@ -286,8 +289,11 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
>  		return ret;
> 
>  	/* Emable clock */
> -	if (mt9p031->clk)
> -		clk_prepare_enable(mt9p031->clk);
> +	if (mt9p031->clk) {
> +		ret = clk_prepare_enable(mt9p031->clk);
> +		if (ret)
> +			return ret;

You should call regulator_bulk_disable() in the error path to cancel the 
previous regulator_bulk_enable() call.

> +	}
> 
>  	/* Now RESET_BAR must be high */
>  	if (gpio_is_valid(mt9p031->reset)) {
-- 
Regards,

Laurent Pinchart

