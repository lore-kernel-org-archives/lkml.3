Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687Ab3IDJmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:42:07 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49768 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563Ab3IDJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:42:04 -0400
Date: Wed, 4 Sep 2013 10:41:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org
Subject: Re: [PATCH 1/4] ab8500-charger: Check return value of
 regulator_enable
Message-ID: <20130904094159.GD20150@lee--X1>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Sep 2013, Sachin Kamat wrote:

> Check the return value of regulator_enable to silence the following
> type of warnings:
> drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
> of ‘regulator_enable’, declared with attribute warn_unused_result
> [-Wunused-result]

I think I remember something about it being okay for the regulators to
fail, but that may have been something else. I think I'd be more
comfortable if we just raised a dev_warn() and didn't return early in
the error case.

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/power/ab8500_charger.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index a4c4a10..fec0546 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -1387,7 +1387,12 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
>  		 * the GPADC module independant of the AB8500 chargers
>  		 */
>  		if (!di->vddadc_en_ac) {
> -			regulator_enable(di->regu);
> +			ret = regulator_enable(di->regu);
> +			if (ret) {
> +				dev_err(di->dev,
> +					"Failed to enable regulator\n");
> +				return ret;
> +			}
>  			di->vddadc_en_ac = true;
>  		}
>  
> @@ -1556,7 +1561,12 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  		 * the GPADC module independant of the AB8500 chargers
>  		 */
>  		if (!di->vddadc_en_usb) {
> -			regulator_enable(di->regu);
> +			ret = regulator_enable(di->regu);
> +			if (ret) {
> +				dev_err(di->dev,
> +					"Failed to enable regulator\n");
> +				return ret;
> +			}
>  			di->vddadc_en_usb = true;
>  		}
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
