Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaHSW3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:29:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57667 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaHSW3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:29:10 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Chris Zhong <zyw@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org, kever.yang@rock-chips.com,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 4/4] RTC: rk808: add RTC driver for RK808 PMIC RTC
Date: Wed, 20 Aug 2014 00:28:42 +0200
Message-ID: <1517709.ClbTUIzhrF@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53F2431F.3090802@collabora.co.uk>
References: <1408240979-29555-1-git-send-email-zyw@rock-chips.com> <53F2431F.3090802@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

Am Montag, 18. August 2014, 20:17:03 schrieb Javier Martinez Canillas:
> adding Mike Turquette to cc since this is also a clock driver.
> 
> Hello Chris,
> 
> Overall it looks good to me, I've just a comment about the driver structure.
> On 08/17/2014 04:02 AM, Chris Zhong wrote:
> > RK808 PMIC is a MFD with RTC as one of the device. Adding RTC driver
> > for supporting RTC device present inside RK808 PMIC.
> > 
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> > ---
> > 
> >  drivers/rtc/Kconfig     |   11 +
> >  drivers/rtc/Makefile    |    1 +
> >  drivers/rtc/rtc-rk808.c |  564
> >  +++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 576
> >  insertions(+)
> >  create mode 100644 drivers/rtc/rtc-rk808.c
> > 
> > diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> > index a168e96..48f61b2 100644
> > --- a/drivers/rtc/Kconfig
> > +++ b/drivers/rtc/Kconfig
> > @@ -288,6 +288,17 @@ config RTC_DRV_MAX77686
> > 
> >  	  This driver can also be built as a module. If so, the module
> >  	  will be called rtc-max77686.
> > 
> > +config RTC_DRV_RK808
> > +	tristate "Rockchip RK808 RTC"
> > +	depends on MFD_RK808
> > +	help
> > +	  If you say yes here you will get support for the
> > +	  RTC of Rk808 PMIC.
> > +
> > +	  This driver can also be built as a module. If so, the module
> > +	  will be called rtc-rk808.
> > +
> > +
> > 
> >  config RTC_DRV_RS5C372
> >  
> >  	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
> >  	help
> > 
> > diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> > index 56f061c..91fe4647 100644
> > --- a/drivers/rtc/Makefile
> > +++ b/drivers/rtc/Makefile
> > @@ -109,6 +109,7 @@ obj-$(CONFIG_RTC_DRV_PUV3)	+= rtc-puv3.o
> > 
> >  obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
> >  obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
> >  obj-$(CONFIG_RTC_DRV_RC5T583)	+= rtc-rc5t583.o
> > 
> > +obj-$(CONFIG_RTC_DRV_RK808)	+= rtc-rk808.o
> > 
> >  obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
> >  obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
> >  obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
> > 
> > diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
> > new file mode 100644
> > index 0000000..0abb919
> > --- /dev/null
> > +++ b/drivers/rtc/rtc-rk808.c
> > @@ -0,0 +1,564 @@
> > +/*
> > + * RTC driver for Rockchip RK808
> > + *
> > + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> > + *
> > + * Author: Chris Zhong <zyw@rock-chips.com>
> > + * Author: Zhang Qing <zhangqing@rock-chips.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> > for + * more details.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/time.h>
> > +#include <linux/rtc.h>
> > +#include <linux/slab.h>
> > +#include <linux/bcd.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/ioctl.h>
> > +#include <linux/completion.h>
> > +#include <linux/mfd/rk808.h>
> > +#include <linux/delay.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/i2c.h>
> > +#include <linux/irqdomain.h>
> > +#include <linux/clk-provider.h>
> > +
> > +/* RTC_CTRL_REG bitfields */
> > +#define BIT_RTC_CTRL_REG_STOP_RTC_M		0x01
> > +#define BIT_RTC_CTRL_REG_ROUND_30S_M		0x02
> > +#define BIT_RTC_CTRL_REG_AUTO_COMP_M		0x04
> > +#define BIT_RTC_CTRL_REG_MODE_12_24_M		0x08
> > +#define BIT_RTC_CTRL_REG_TEST_MODE_M		0x10
> > +#define BIT_RTC_CTRL_REG_SET_32_COUNTER_M	0x20
> > +#define BIT_RTC_CTRL_REG_GET_TIME_M		0x40
> > +#define BIT_RTC_CTRL_REG_RTC_V_OPT_M		0x80
> > +
> > +/* RTC_STATUS_REG bitfields */
> > +#define BIT_RTC_STATUS_REG_RUN_M		0x02
> > +#define BIT_RTC_STATUS_REG_1S_EVENT_M		0x04
> > +#define BIT_RTC_STATUS_REG_1M_EVENT_M		0x08
> > +#define BIT_RTC_STATUS_REG_1H_EVENT_M		0x10
> > +#define BIT_RTC_STATUS_REG_1D_EVENT_M		0x20
> > +#define BIT_RTC_STATUS_REG_ALARM_M		0x40
> > +#define BIT_RTC_STATUS_REG_POWER_UP_M		0x80
> > +
> > +/* RTC_INTERRUPTS_REG bitfields */
> > +#define BIT_RTC_INTERRUPTS_REG_EVERY_M		0x03
> > +#define BIT_RTC_INTERRUPTS_REG_IT_TIMER_M	0x04
> > +#define BIT_RTC_INTERRUPTS_REG_IT_ALARM_M	0x08
> > +
> > +/* DEVCTRL bitfields */
> > +#define BIT_RTC_PWDN				0x40
> > +
> > +/* REG_SECONDS_REG through REG_YEARS_REG is how many registers? */
> > +#define ALL_TIME_REGS				7
> > +#define ALL_ALM_REGS				6
> > +
> > +#define RTC_SET_TIME_RETRIES	5
> > +#define RTC_GET_TIME_RETRIES	5
> > +
> > +struct rk808_rtc {
> > +	struct rk808 *rk808;
> > +	struct rtc_device *rtc;
> > +	unsigned int alarm_enabled:1;
> > +#ifdef CONFIG_COMMON_CLK
> > +	struct clk_onecell_data clk_data;
> > +	struct clk_hw		clkout1_hw;
> > +	struct clk_hw		clkout2_hw;
> > +#endif
> 
> As I mentioned on a previous review I really think these clocks should be
> managed on a separate clock driver. It's not uncommon for PMIC chips to
> have a bunch of regulators, a RTC and some clock ouputs and usually each
> of these components have their own driver.
> 
> You are already adding a mult-function device driver for this PMIC so is
> just a matter of adding another mfd cell for the clock driver.
> 
> I know that drivers/rtc/rtc-hym8563.c does the same thing and manage both
> a RTC and a clock output but in this case it appears that chip is a plain
> RTC chip with a clock. So I guess in that case it was not worth the
> complexity of adding three drivers (mfd, rtc and clock) for just a simple
> RTC? Arguably even that chip should be seen as a multi-function device
> though but I'll let Mike to judge that. What I really think is that there
> is a reason why we have both drivers/rtc and drivers/clk so we should try
> to keep the needed support in the right place to avoid adding unnecessary
> cross subsystem maintenance burden.

Mike said in the past, that he doesn't require everything that provides a 
clock to be sitting in drivers/clk. This (and the minimal size of the clkout 
of hy8563) let me to decide to put the clkout into the rtc.

For the rk808, I guess it should either be a separate mfd-cell or part of the 
core mfd driver - but not the rtc cell.


Heiko

