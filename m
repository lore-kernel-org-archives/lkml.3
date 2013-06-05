Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3FESDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:03:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36727 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3FESDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:03:20 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@iki.fi>
Subject: Re: [PATCH v2 1/2] RTC: rtc-twl: Fix rtc_reg_map initialization
References: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 05 Jun 2013 11:03:16 -0700
In-Reply-To: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com> (Peter
	Ujfalusi's message of "Tue, 16 Apr 2013 10:30:12 +0200")
Message-ID: <8738swwi3f.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Ujfalusi <peter.ujfalusi@ti.com> writes:

> Initialize the rtc_reg_map in platform_driver's probe function instead at
> module_init time. This way we can make sure that the twl-core has been already
> probed and initialized (twl_priv->twl_id is valid) since the platform device
> for the RTC driver will be created by the twl-core after it finished it's
> init.
>
> Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Tested-by: Kevin Hilman <khilman@linaro.org>

Confirmed this fixes some init problems when using DT boot on OMAP3.

Peter, you might want to resend (with acks collected) and be sure that
it's sent to Andrew Morton who is maintaining drivers/rtc currently.

Kevin

> ---
> Hi,
>
> As Tomi commented on the first version:
> www.spinics.net/lists/linux-omap/msg90064.html
> www.spinics.net/lists/linux-omap/msg90066.html
>
> I have separated the actual fix from the module_platform_driver() conversion.
>
> Regards,
> Peter
>
>  drivers/rtc/rtc-twl.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> index 8bc6c80..c385e9b 100644
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -469,6 +469,12 @@ static int twl_rtc_probe(struct platform_device *pdev)
>  	if (irq <= 0)
>  		goto out1;
>  
> +	/* Initialize the register map */
> +	if (twl_class_is_4030())
> +		rtc_reg_map = (u8 *)twl4030_rtc_reg_map;
> +	else
> +		rtc_reg_map = (u8 *)twl6030_rtc_reg_map;
> +
>  	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
>  	if (ret < 0)
>  		goto out1;
> @@ -614,11 +620,6 @@ static struct platform_driver twl4030rtc_driver = {
>  
>  static int __init twl_rtc_init(void)
>  {
> -	if (twl_class_is_4030())
> -		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
> -	else
> -		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
> -
>  	return platform_driver_register(&twl4030rtc_driver);
>  }
>  module_init(twl_rtc_init);
