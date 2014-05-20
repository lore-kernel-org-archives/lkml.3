Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaETMKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:10:45 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38178 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaETMKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:10:44 -0400
Date: Tue, 20 May 2014 13:10:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sameo@linux.intel.com,
        broonie@linaro.org, ckeepax@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] extcon: arizona: support inverted jack detect switch
Message-ID: <20140520121019.GJ24991@lee--X1>
References: <20140520115632.GA13900@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520115632.GA13900@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Richard Fitzgerald wrote:

> Add pdata option for inverted jack detect switch that
> opens when jack is inserted.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c   |   29 +++++++++++++++++++++--------
>  include/linux/mfd/arizona/pdata.h |    3 +++

For the MFD part:
  Acked-by: Lee Jones <lee.jones@linaro.org>

>  2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 98a14f6..af926b9 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -962,10 +962,16 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
>  
>  	if (arizona->pdata.jd_gpio5) {
>  		mask = ARIZONA_MICD_CLAMP_STS;
> -		present = 0;
> +		if (arizona->pdata.jd_invert)
> +			present = ARIZONA_MICD_CLAMP_STS;
> +		else
> +			present = 0;
>  	} else {
>  		mask = ARIZONA_JD1_STS;
> -		present = ARIZONA_JD1_STS;
> +		if (arizona->pdata.jd_invert)
> +			present = 0;
> +		else
> +			present = ARIZONA_JD1_STS;
>  	}
>  
>  	ret = regmap_read(arizona->regmap, ARIZONA_AOD_IRQ_RAW_STATUS, &val);
> @@ -1096,6 +1102,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  	struct arizona_pdata *pdata = &arizona->pdata;
>  	struct arizona_extcon_info *info;
>  	unsigned int val;
> +	unsigned int clamp_mode;
>  	int jack_irq_fall, jack_irq_rise;
>  	int ret, mode, i, j;
>  
> @@ -1302,16 +1309,22 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  			regmap_write(arizona->regmap, ARIZONA_GPIO5_CTRL,
>  				     val);
>  
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_MICD_CLAMP_CONTROL,
> -					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x9);
> +			if (arizona->pdata.jd_invert)
> +				clamp_mode = 0xb;
> +			else
> +				clamp_mode = 0x9;
>  		} else {
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_MICD_CLAMP_CONTROL,
> -					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x4);
> +			if (arizona->pdata.jd_invert)
> +				clamp_mode = 0x5;
> +			else
> +				clamp_mode = 0x4;
>  		}
>  
>  		regmap_update_bits(arizona->regmap,
> +				   ARIZONA_MICD_CLAMP_CONTROL,
> +				   ARIZONA_MICD_CLAMP_MODE_MASK, clamp_mode);
> +
> +		regmap_update_bits(arizona->regmap,
>  				   ARIZONA_JACK_DETECT_DEBOUNCE,
>  				   ARIZONA_MICD_CLAMP_DB,
>  				   ARIZONA_MICD_CLAMP_DB);
> diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
> index 12a5c13..4578c72 100644
> --- a/include/linux/mfd/arizona/pdata.h
> +++ b/include/linux/mfd/arizona/pdata.h
> @@ -127,6 +127,9 @@ struct arizona_pdata {
>  	/** Internal pull on GPIO5 is disabled when used for jack detection */
>  	bool jd_gpio5_nopull;
>  
> +	/** set to true if jackdet contact opens on insert */
> +	bool jd_invert;
> +
>  	/** Use the headphone detect circuit to identify the accessory */
>  	bool hpdet_acc_id;
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
