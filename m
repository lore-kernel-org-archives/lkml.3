Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbaGDNX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:23:56 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38361 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGDNXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:23:54 -0400
Message-ID: <53B6AAE4.4020700@collabora.co.uk>
Date: Fri, 04 Jul 2014 15:23:48 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 22/23] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk> <1404467722-26687-23-git-send-email-javier.martinez@collabora.co.uk> <1404474972.14069.20.camel@AMDC1943> <53B6A3A3.9090300@collabora.co.uk> <1404479478.2653.5.camel@AMDC1943>
In-Reply-To: <1404479478.2653.5.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 07/04/2014 03:11 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-07-04 at 14:52 +0200, Javier Martinez Canillas wrote:
>> Hello Krzysztof,
>> 
>> Thanks a lot for your feedback.
>> 
>> On 07/04/2014 01:56 PM, Krzysztof Kozlowski wrote:
>> > On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
>> >> The MAX7802 PMIC has a Real-Time-Clock (RTC) with two alarms.
>> >> This patch adds support for the RTC and is based on a driver
>> >> added by Simon Glass to the Chrome OS kernel 3.8 tree.
>> >> 
>> >> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> >> ---
>> >> 
>> >> Changes since v5: None
>> >> 
>> >> Changes since v4: None
>> >> 
>> >> Changes since v3: None
>> >> ---
>> >>  drivers/rtc/Kconfig        |  10 +
>> >>  drivers/rtc/Makefile       |   1 +
>> >>  drivers/rtc/rtc-max77802.c | 637 +++++++++++++++++++++++++++++++++++++++++++++
>> >>  3 files changed, 648 insertions(+)
>> >>  create mode 100644 drivers/rtc/rtc-max77802.c
>> >> 
>> >> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>> >> index a672dd1..243ac72 100644
>> >> --- a/drivers/rtc/Kconfig
>> >> +++ b/drivers/rtc/Kconfig
>> >> @@ -288,6 +288,16 @@ config RTC_DRV_MAX77686
>> >>  	  This driver can also be built as a module. If so, the module
>> >>  	  will be called rtc-max77686.
>> >>  
>> >> +config RTC_DRV_MAX77802
>> >> +	tristate "Maxim 77802 RTC"
>> >> +	depends on MFD_MAX77686
>> >> +	help
>> >> +	  If you say yes here you will get support for the
>> >> +	  RTC of Maxim MAX77802 PMIC.
>> >> +
>> >> +	  This driver can also be built as a module. If so, the module
>> >> +	  will be called rtc-max77802.
>> >> +
>> >>  config RTC_DRV_RS5C372
>> >>  	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
>> >>  	help
>> >> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>> >> index 70347d0..247de78 100644
>> >> --- a/drivers/rtc/Makefile
>> >> +++ b/drivers/rtc/Makefile
>> >> @@ -81,6 +81,7 @@ obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
>> >>  obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max8997.o
>> >>  obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
>> >>  obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
>> >> +obj-$(CONFIG_RTC_DRV_MAX77802)  += rtc-max77802.o
>> >>  obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
>> >>  obj-$(CONFIG_RTC_DRV_MCP795)	+= rtc-mcp795.o
>> >>  obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
>> >> diff --git a/drivers/rtc/rtc-max77802.c b/drivers/rtc/rtc-max77802.c
>> >> new file mode 100644
>> >> index 0000000..2f4fc2e
>> >> --- /dev/null
>> >> +++ b/drivers/rtc/rtc-max77802.c
>> >> @@ -0,0 +1,637 @@
>> >> +/*
>> >> + * RTC driver for Maxim MAX77802
>> >> + *
>> >> + * Copyright (C) 2013 Google, Inc
>> >> + *
>> >> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> >> + *
>> >> + *  based on rtc-max8997.c
>> >> + *
>> >> + *  This program is free software; you can redistribute  it and/or modify it
>> >> + *  under  the terms of  the GNU General  Public License as published by the
>> >> + *  Free Software Foundation;  either version 2 of the  License, or (at your
>> >> + *  option) any later version.
>> >> + *
>> >> + */
>> >> +
>> >> +#include <linux/slab.h>
>> >> +#include <linux/rtc.h>
>> >> +#include <linux/delay.h>
>> >> +#include <linux/mutex.h>
>> >> +#include <linux/module.h>
>> >> +#include <linux/platform_device.h>
>> >> +#include <linux/mfd/max77686-private.h>
>> >> +#include <linux/irqdomain.h>
>> >> +#include <linux/regmap.h>
>> >> +
>> >> +/* RTC Control Register */
>> >> +#define BCD_EN_SHIFT			0
>> >> +#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
>> >> +#define MODEL24_SHIFT			1
>> >> +#define MODEL24_MASK			(1 << MODEL24_SHIFT)
>> >> +/* RTC Update Register1 */
>> >> +#define RTC_UDR_SHIFT			0
>> >> +#define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
>> >> +#define RTC_RBUDR_SHIFT			4
>> >> +#define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
>> >> +/* WTSR and SMPL Register */
>> >> +#define WTSRT_SHIFT			0
>> >> +#define SMPLT_SHIFT			2
>> >> +#define WTSR_EN_SHIFT			6
>> >> +#define SMPL_EN_SHIFT			7
>> >> +#define WTSRT_MASK			(3 << WTSRT_SHIFT)
>> >> +#define SMPLT_MASK			(3 << SMPLT_SHIFT)
>> >> +#define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
>> >> +#define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
>> >> +/* RTC Hour register */
>> >> +#define HOUR_PM_SHIFT			6
>> >> +#define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
>> >> +/* RTC Alarm Enable */
>> >> +#define ALARM_ENABLE_SHIFT		7
>> >> +#define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
>> >> +
>> >> +/* For the RTCAE1 register, we write this value to enable the alarm */
>> >> +#define ALARM_ENABLE_VALUE		0x77
>> >> +
>> >> +#define MAX77802_RTC_UPDATE_DELAY_US	200
>> >> +#undef MAX77802_RTC_WTSR_SMPL
>> > 
>> > Hmmm... I am not sure what is the purpose of this undef. It disables
>> > some functions below. I saw same code in 77686 RTC driver but this does
>> > not help me :).
>> > 
>> > If this is on purpose can you add a comment explaining the
>> > purpose/cause?
>> > 
>> 
>> This is a left over from when a combined 77686/802 driver was attempted since as
>> you said the 77686 RTC driver does the same.
>> 
>> I just checked MAX77802 data sheet and the MAX77802_RTC_WTSR_SMPL register is to
>> control the SMPL (Sudden Momentary Power Loss) and WTSR (Watchdog Timeout and
>> Software Resets) features.
>> 
>> Now, I wanted to figure out why the 77686 driver unset that register and have
>> those conditionals but git blame shows me that this was already in the original
>> commit that added the driver: fca1dd03 ("rtc: max77686: add Maxim 77686 driver").
>> 
>> Also, I see that the MAX8997 driver (drivers/rtc/rtc-max8997.c) also has a
>> similar register but actually uses it and doesn't have the conditionals if is
>> disabled. But this driver has two module parameters to control if these features
>> are enabled or not (wtsr_en and smpl_en).
>> 
>> If these two features have been disabled since the max77686 driver was merged
>> then I guess that the dead code should be removed from that driver as well? Or
>> do you have more hints about why it has been disabled?
> 
> If the max77802 driver in current form works fine for your setup then I
> think these functions can be removed completely. It should not harm
> since this is dead code anyway and it will simplify the driver.
> 

Agreed, I'll just remove it.

> I think the same applies to max77686 (especially that as you said - this
> is dead since beginning). Just remove it in separate patch.
> 

Ok, I'll add that as a separate cleanup patch in the next version of the series
as well.

> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier

