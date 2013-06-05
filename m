Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3FELxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:53:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45514 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3FELxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:53:23 -0400
Message-ID: <51AF25B8.4090701@ti.com>
Date: Wed, 5 Jun 2013 14:49:12 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Tomi Valkeinen <tomi.valkeinen@iki.fi>
Subject: Re: [PATCH v2 1/2] RTC: rtc-twl: Fix rtc_reg_map initialization
References: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Tested on OMAP4460 SDP - see no issues during boot.

-grygorii

On 04/16/2013 11:30 AM, Peter Ujfalusi wrote:
> Initialize the rtc_reg_map in platform_driver's probe function instead at
> module_init time. This way we can make sure that the twl-core has been already
> probed and initialized (twl_priv->twl_id is valid) since the platform device
> for the RTC driver will be created by the twl-core after it finished it's
> init.
>
> Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
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
>   drivers/rtc/rtc-twl.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> index 8bc6c80..c385e9b 100644
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -469,6 +469,12 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   	if (irq <= 0)
>   		goto out1;
>   
> +	/* Initialize the register map */
> +	if (twl_class_is_4030())
> +		rtc_reg_map = (u8 *)twl4030_rtc_reg_map;
> +	else
> +		rtc_reg_map = (u8 *)twl6030_rtc_reg_map;
> +
>   	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
>   	if (ret < 0)
>   		goto out1;
> @@ -614,11 +620,6 @@ static struct platform_driver twl4030rtc_driver = {
>   
>   static int __init twl_rtc_init(void)
>   {
> -	if (twl_class_is_4030())
> -		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
> -	else
> -		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
> -
>   	return platform_driver_register(&twl4030rtc_driver);
>   }
>   module_init(twl_rtc_init);

