Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaCZHfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:35:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10999 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaCZHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:35:22 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c6-533283371b8f
Message-id: <1395819318.31821.1.camel@AMDC1943>
Subject: Re: [PATCH] mfd: max77686: handle IRQs using regmap
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com
Date: Wed, 26 Mar 2014 08:35:18 +0100
In-reply-to: <1395817840-12604-1-git-send-email-r.baldyga@samsung.com>
References: <1395817840-12604-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7rmzUbBBlNmWlssuXiV3eL+16OM
	Fpd3zWGzWHvkLrvFg8M72S32d3YwWpzuZnVg99gz8SSbx51re9g85p0M9OjbsorRY/q8n0we
	nzfJBbBFcdmkpOZklqUW6dslcGXcOXSbqeASX8Wzmz4NjN3cXYycHBICJhL3jp5ggrDFJC7c
	W8/WxcjFISSwlFHi58rvzBDOZ0aJnZ2/WUGqeAX0Jc7c/wHWISxgI3Hr5z1mEJtNwFhi8/Il
	bCC2iICWxJ2P89lBmpkF5jJK7Hj7mREkwSKgKnHgYyMLiM0p4Cbx9/dBoDgH0AZXibdzykDC
	zALqEpPmLWKGuEhJYnd7JztEXF5i85q3zBA3CEr8mHyPZQKjwCwkLbOQlM1CUraAkXkVo2hq
	aXJBcVJ6rpFecWJucWleul5yfu4mRkiof93BuPSY1SFGAQ5GJR5eiz7DYCHWxLLiytxDjBIc
	zEoivEfkjYKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MKp5cOwVX7JNKNznzq+Hizi8JMVkJvpX
	TBG7lJ67rqb/3mu53L3b9vWz/LnfI5jT4ub5R3nLtP2nZx3KlCxMyJ377/Y2zrP3N199zSdS
	lPVj0psD25bduskS+6Rlj4fPN7EHj+8svy593ORd5os7Fx92T4m50BAryneJ147lcOFlIYPP
	939ddT6ixFKckWioxVxUnAgA48QrBFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 08:10 +0100, Robert Baldyga wrote:
> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/mfd/Kconfig                  |    2 +-
>  drivers/mfd/Makefile                 |    2 +-
>  drivers/mfd/max77686-irq.c           |  319 ----------------------------------
>  drivers/mfd/max77686.c               |   54 +++++-
>  drivers/rtc/rtc-max77686.c           |   43 ++++-
>  include/linux/mfd/max77686-private.h |   32 +++-
>  6 files changed, 119 insertions(+), 333 deletions(-)
>  delete mode 100644 drivers/mfd/max77686-irq.c

(...)

> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index 9efe118..b8bc412 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -497,6 +497,25 @@ static struct regmap_config max77686_rtc_regmap_config = {
>  	.val_bits = 8,
>  };
>  
> +static const struct regmap_irq max77686_irqs_rtc[] = {
> +	{ .mask = RTC_INT_RTC60S_MASK, },
> +	{ .mask = RTC_INT_RTCA1_MASK, },
> +	{ .mask = RTC_INT_RTCA2_MASK, },
> +	{ .mask = RTC_INT_SMPL_MASK, },
> +	{ .mask = RTC_INT_RTC1S_MASK, },
> +	{ .mask = RTC_INT_WTSR_MASK, },
> +};
> +
> +static const struct regmap_irq_chip max77686_irq_chip_rtc = {
> +	.name                   = "max77686-rtc",
> +	.status_base            = MAX77686_RTC_INT,
> +	.mask_base              = MAX77686_RTC_INTM,
> +	.mask_invert            = true,
> +	.num_regs               = 2,

I think there is only one RTC interrupt register (RTCINT).

Beside that, everything else looks fine.
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

