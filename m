Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab3IFHCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:02:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33917 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3IFHCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:02:52 -0400
Date: Fri, 6 Sep 2013 08:02:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, dwmw2@infradead.org
Subject: Re: [PATCH v2 1/4] ab8500-charger: Check return value of
 regulator_enable
Message-ID: <20130906070248.GB32654@lee--X1>
References: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Sachin Kamat wrote:

> Check the return value of regulator_enable to silence the following
> type of warnings:
> drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
> of ‘regulator_enable’, declared with attribute warn_unused_result
> [-Wunused-result]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
> Compile tested.
> Changes since v1:
>  * converted dev_err and return to dev_warn as suggested by Lee Jones.
> ---
>  drivers/power/ab8500_charger.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index a4c4a10..0d355a9 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -1387,8 +1387,14 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
>  		 * the GPADC module independant of the AB8500 chargers
>  		 */
>  		if (!di->vddadc_en_ac) {
> -			regulator_enable(di->regu);
> -			di->vddadc_en_ac = true;
> +			ret = regulator_enable(di->regu);
> +			if (ret) {
> +				dev_warn(di->dev,
> +					"Failed to enable regulator\n");
> +				di->vddadc_en_ac = false;

Isn't di->vddadc_en_ac already false?

Or you wouldn't have made it into the if().

> +			} else {
> +				di->vddadc_en_ac = true;
> +			}
>  		}
>  
>  		/* Check if the requested voltage or current is valid */
> @@ -1556,8 +1562,14 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  		 * the GPADC module independant of the AB8500 chargers
>  		 */
>  		if (!di->vddadc_en_usb) {
> -			regulator_enable(di->regu);
> -			di->vddadc_en_usb = true;
> +			ret = regulator_enable(di->regu);
> +			if (ret) {
> +				dev_warn(di->dev,
> +					"Failed to enable regulator\n");
> +				di->vddadc_en_usb = false;

Same thing here.

> +			} else {
> +				di->vddadc_en_usb = true;
> +			}
>  		}
>  
>  		/* Enable USB charging */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
