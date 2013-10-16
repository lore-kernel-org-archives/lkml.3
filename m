Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392Ab3JPJXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:23:16 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49656 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253Ab3JPJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:23:14 -0400
Date: Wed, 16 Oct 2013 10:23:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: tc3589x: detect the precise version
Message-ID: <20131016092310.GD19112@lee--X1>
References: <1381871640-22262-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381871640-22262-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Linus Walleij wrote:

> Instead of detecting the "tc3589x" and hard-coding the number of
> GPIO pins to 24, encode all the possible subtypes and set the
> number of GPIO pins from the type.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/tc3589x.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
> index 70f4909f..0eabbb0 100644
> --- a/drivers/mfd/tc3589x.c
> +++ b/drivers/mfd/tc3589x.c
> @@ -16,6 +16,19 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/tc3589x.h>
>  
> +/**
> + * enum tc3589x_version - indicates the TC3589x version
> + */
> +enum tc3589x_version {
> +	TC3589X_TC35890,
> +	TC3589X_TC35892,
> +	TC3589X_TC35893,
> +	TC3589X_TC35894,
> +	TC3589X_TC35895,
> +	TC3589X_TC35896,
> +	TC3589X_UNKNOWN,
> +};
> +
>  #define TC3589x_CLKMODE_MODCTL_SLEEP		0x0
>  #define TC3589x_CLKMODE_MODCTL_OPERATION	(1 << 0)
>  
> @@ -361,7 +374,33 @@ static int tc3589x_probe(struct i2c_client *i2c,
>  	tc3589x->i2c = i2c;
>  	tc3589x->pdata = pdata;
>  	tc3589x->irq_base = pdata->irq_base;
> -	tc3589x->num_gpio = id->driver_data;
> +
> +	switch (id->driver_data) {
> +	case TC3589X_TC35890:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	case TC3589X_TC35892:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	case TC3589X_TC35893:
> +		tc3589x->num_gpio = 20;
> +		break;
> +	case TC3589X_TC35894:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	case TC3589X_TC35895:
> +		tc3589x->num_gpio = 20;
> +		break;
> +	case TC3589X_TC35896:
> +		tc3589x->num_gpio = 20;
> +		break;
> +	case TC3589X_UNKNOWN:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	default:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	}
>  
>  	i2c_set_clientdata(i2c, tc3589x);
>  
> @@ -432,7 +471,13 @@ static int tc3589x_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend, tc3589x_resume);
>  
>  static const struct i2c_device_id tc3589x_id[] = {
> -	{ "tc3589x", 24 },
> +	{ "tc35890", TC3589X_TC35890 },
> +	{ "tc35892", TC3589X_TC35892 },
> +	{ "tc35893", TC3589X_TC35893 },
> +	{ "tc35894", TC3589X_TC35894 },
> +	{ "tc35895", TC3589X_TC35895 },
> +	{ "tc35896", TC3589X_TC35896 },
> +	{ "tc3589x", TC3589X_UNKNOWN },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, tc3589x_id);

This is an awful lot of code for what we're trying to achieve. I
propose two alternitives:

  1. I guess that other OSes will need to capture the same
  information, so wouldn't it be prudant to do so via a DT property?
  That way it's just a one or two liner.

Or:

  2. As we're only using .driver_data for num_gpio at this time, just
  place them in tc3589x_id as you have done for tc3589x.

Or, my least favourate alternitive, but still an improvment with
regards to saving code:

  3. Again, as all of this extra code is only used for pulling out
  num_gpio, group the devices by num_gpio:

> +	switch (id->driver_data) {
> +	case TC3589X_TC35893:
> +	case TC3589X_TC35895:
> +	case TC3589X_TC35896:
> +		tc3589x->num_gpio = 20;
> +		break;
> +	case TC3589X_TC35890:
> +	case TC3589X_TC35892:
> +	case TC3589X_TC35894:
> +	case TC3589X_UNKNOWN:
> +	default:
> +		tc3589x->num_gpio = 24;
> +		break;
> +	}

My personal preference is 1 and 2 in equal measure.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
