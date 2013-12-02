Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3LBKyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:54:40 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43070 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3LBKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:54:37 -0500
Date: Mon, 2 Dec 2013 10:54:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH RESEND] mfd: mc13xxx: Fix null pointer dereference in
 mc13xxx_common_init
Message-ID: <20131202105432.GC29373@lee--X1>
References: <1385805188-5597-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385805188-5597-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Alexander Shiyan wrote:

> If this driver being loaded from devicetree, the pdata is NULL.
> This cause kernel Oops when "fsl,mc13xxx-uses-codec" and/or
> "fsl,mc13xxx-uses-touch" properties is specified.

<snip>

The original code is pretty gross. This stuff shouldn't be identifying
_support_ in Device Tree, then dragging in configuration from platform
code.

Rather than patch it up with little plasters (band aids), can we fix
it properly please?

> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/mc13xxx-core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index dbbf8ee..625633a 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -682,14 +682,14 @@ err_revision:
>  	if (mc13xxx->flags & MC13XXX_USE_ADC)
>  		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
>  
> -	if (mc13xxx->flags & MC13XXX_USE_CODEC)
> +	if ((mc13xxx->flags & MC13XXX_USE_CODEC) && pdata)
>  		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
>  					pdata->codec, sizeof(*pdata->codec));
>  
>  	if (mc13xxx->flags & MC13XXX_USE_RTC)
>  		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
>  
> -	if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
> +	if ((mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN) && pdata)
>  		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
>  				&pdata->touch, sizeof(pdata->touch));
>  
> @@ -701,6 +701,10 @@ err_revision:
>  		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-pwrbutton",
>  				pdata->buttons, sizeof(*pdata->buttons));
>  	} else {
> +		if (mc13xxx->flags & MC13XXX_USE_CODEC)
> +			mc13xxx_add_subdevice(mc13xxx, "%s-codec");
> +		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
> +			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
>  		mc13xxx_add_subdevice(mc13xxx, "%s-regulator");
>  		mc13xxx_add_subdevice(mc13xxx, "%s-led");
>  		mc13xxx_add_subdevice(mc13xxx, "%s-pwrbutton");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
