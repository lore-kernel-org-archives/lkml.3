Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3IYXt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:49:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60262 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYXtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:49:55 -0400
Message-ID: <524376A0.7020405@linaro.org>
Date: Thu, 26 Sep 2013 01:49:52 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de> <5242F434.7060702@linaro.org> <20130925153207.GG16106@pengutronix.de>
In-Reply-To: <20130925153207.GG16106@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 05:32 PM, Uwe Kleine-König wrote:
> Hello Daniel,
> 
> On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
>> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>> ---
>>> I'm not sure that the way I implemented if a given timer is used as
>>> clock_source or clock_event_device is robust. Does it need locking?
>>> The reason to create a timer device for each timer instead of a single
>>> device of all of them is that it makes it cleaner to specify irqs and
>>> clks which each timer has one of each respectively. I didn't find an
>>> example, but while looking I wondered if in zevio-timer.c a single timer
>>> can really support both clock_event and clocksource.
>>>
>>> I guess for inclusion I need to write a document describing the
>>> of-binding. I will include that in the next iteration.
>>
>> Right and a nice description of the timer would be valuable.
> in the binding document or the commit log?

commit log.

>> The first letter of the description should be in capital "Provide".
>>
>>> checkpatch wails that the description of CLKSRC_EFM32 is too short. I
>>> think it's OK though.
>>>
>>> Best regards
>>> Uwe
>>>
>>>  drivers/clocksource/Kconfig      |   8 ++
>>>  drivers/clocksource/Makefile     |   1 +
>>>  drivers/clocksource/time-efm32.c | 274 +++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 283 insertions(+)
>>>  create mode 100644 drivers/clocksource/time-efm32.c
>>>
>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>>> index 41c6946..410b152 100644
>>> --- a/drivers/clocksource/Kconfig
>>> +++ b/drivers/clocksource/Kconfig
>>> @@ -70,6 +70,14 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
>>>  	help
>>>  	  Use the always on PRCMU Timer as sched_clock
>>>  
>>> +config CLKSRC_EFM32
>>> +	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
>>> +	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
>>> +	default ARCH_EFM32
>>> +	help
>>> +	  Support to use the timers of EFM32 SoCs as clock source and clock
>>> +	  event device.
>>> +
>>
>> No option for the timer. It must be selected by the platform.
> It is. If ARCH_EFM32=y there is no prompt and the "default ARCH_EFM32"
> makes it true.

ok, with that but if ARCH_EFM32=no, you can enable it manually. AFAIK,
we want to prevent this and let the correct arch to enable it.

John ?

>>>  config ARM_ARCH_TIMER
>>>  	bool
>>>  	select CLKSRC_OF if OF
>>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
>>> index 704d6d3..33621ef 100644
>>> --- a/drivers/clocksource/Makefile
>>> +++ b/drivers/clocksource/Makefile
>>> @@ -27,6 +27,7 @@ obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
>>>  obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
>>>  obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
>>>  obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
>>> +obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
>>>  obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
>>>  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
>>>  obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
>>> diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
>>> new file mode 100644
>>> index 0000000..6ead8d7
>>> --- /dev/null
>>> +++ b/drivers/clocksource/time-efm32.c
>>> @@ -0,0 +1,274 @@
>>> +/*
>>> + * Copyright (C) 2013 Pengutronix
>>> + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it under
>>> + * the terms of the GNU General Public License version 2 as published by the
>>> + * Free Software Foundation.
>>> + */
>>> +
>>> +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/clocksource.h>
>>> +#include <linux/clockchips.h>
>>> +#include <linux/irq.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/of_irq.h>
>>> +#include <linux/clk.h>
>>> +
>>> +#define TIMERn_CTRL			0x00
>>> +#define TIMERn_CTRL_PRESC(val)			(((val) & 0xf) << 24)
>>
>> You can replace all binary shift with the BIT macro.
> The BIT macro only can define values that have a single bit set. So it
> doesn't help for the definition of the TIMERn_CTRL_PRESC macro and most
> others. And then I prefer to have a common way to define the register
> descriptions.

Ok.

>>> +#define TIMERn_CTRL_PRESC_1024			TIMERn_CTRL_PRESC(10)
>>> +#define TIMERn_CTRL_CLKSEL(val)			(((val) & 0x3) << 16)
>>> +#define TIMERn_CTRL_CLKSEL_PRESCHFPERCLK	TIMERn_CTRL_CLKSEL(0)
>>> +#define TIMERn_CTRL_OSMEN			0x00000010
>>> +#define TIMERn_CTRL_MODE(val)			(((val) & 0x3) <<  0)
>>> +#define TIMERn_CTRL_MODE_UP			TIMERn_CTRL_MODE(0)
>>> +#define TIMERn_CTRL_MODE_DOWN			TIMERn_CTRL_MODE(1)
>>> +
>>> +#define TIMERn_CMD			0x04
>>> +#define TIMERn_CMD_START			0x1
>>> +#define TIMERn_CMD_STOP				0x2
>>> +
>>> +#define TIMERn_IEN			0x0c
>>> +#define TIMERn_IF			0x10
>>> +#define TIMERn_IFS			0x14
>>> +#define TIMERn_IFC			0x18
>>> +#define TIMERn_IRQ_UF				0x2
>>> +#define TIMERn_IRQ_OF				0x1
>>
>> I see a wrong alignment with the values. May be it is due to my mailer.
> Maybe that's because the patch has one char more (the +) before the
> tabs, that make things look wrong sometimes. In the file it looks ok.

Ok.

>>> +
>>> +#define TIMERn_TOP			0x1c
>>> +#define TIMERn_CNT			0x24
>>> +
>>> +#define TIMER_CLOCKSOURCE	0
>>> +#define TIMER_CLOCKEVENT	1
>>
>> I don't see these macro used anywhere.
> Right, pre-dt cruft.
> 
>>> +struct efm32_clock_event_ddata {
>>
>> The structure name looks a bit long to me.
>>
>>> +	struct clock_event_device evtdev;
>>> +	void __iomem *base;
>>> +	unsigned periodic_top;
>>> +};
>>> +static void efm32_clock_event_set_mode(enum clock_event_mode mode,
>>> +				       struct clock_event_device *evtdev)
>>> +{
>>> +	struct efm32_clock_event_ddata *ddata =
>>> +		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
>>
>> Wouldn't be worth to check the previous mode of the timer before
>> switching to a mode where it is already ?
> This isn't a hot path, is it? IIRC this function is called exactly
> twice. And I think it still needs stopping at least in some cases. Then
> it's more complicated and so not worth the effort.

Ok.

>>> +	switch (mode) {
>>> +	case CLOCK_EVT_MODE_PERIODIC:
>>> +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
>>> +		writel_relaxed(ddata->periodic_top, ddata->base + TIMERn_TOP);
>>> +		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
>>> +			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
>>> +			       TIMERn_CTRL_MODE_DOWN,
>>> +			       ddata->base + TIMERn_CTRL);
>>> +		writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
>>> +		break;
>>> +
>>> +	case CLOCK_EVT_MODE_ONESHOT:
>>> +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
>>> +		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
>>> +			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
>>> +			       TIMERn_CTRL_OSMEN |
>>> +			       TIMERn_CTRL_MODE_DOWN,
>>> +			       ddata->base + TIMERn_CTRL);
>>> +		break;
>>
>> IMO, these two routines are similar enough to factor them out in a
>> single function.
> I don't know what you want here? A #define for the common bits? I like
> being explicit here to not have to jump around to verify the settings
> with the hardware reference manual.

Never mind, I missed one line when reading the CLOCK_EVT_MODE_PERIODIC
and the CLOCK_EVT_MODE_ONESHOT blocks. At the first glance, they looked
very similar and I thought they can be factored out into a function.

>>> +	case CLOCK_EVT_MODE_UNUSED:
>>> +	case CLOCK_EVT_MODE_SHUTDOWN:
>>> +		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
>>> +		break;
>>> +
>>> +	case CLOCK_EVT_MODE_RESUME:
>>> +		break;
>>> +	}
>>> +}
>>> +
>>> +static int efm32_clock_event_set_next_event(unsigned long evt,
>>> +					    struct clock_event_device *evtdev)
>>> +{
>>> +	struct efm32_clock_event_ddata *ddata =
>>> +		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
>>> +
>>> +	writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
>>> +	writel_relaxed(evt, ddata->base + TIMERn_CNT);
>>> +	writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static irqreturn_t efm32_clock_event_handler(int irq, void *dev_id)
>>> +{
>>> +	struct efm32_clock_event_ddata *ddata = dev_id;
>>> +
>>> +	writel_relaxed(TIMERn_IRQ_UF, ddata->base + TIMERn_IFC);
>>> +
>>> +	ddata->evtdev.event_handler(&ddata->evtdev);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static struct efm32_clock_event_ddata clock_event_ddata = {
>>> +	.evtdev = {
>>> +		.name = "efm32 clockevent",
>>> +		.features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_MODE_PERIODIC,
>>> +		.set_mode = efm32_clock_event_set_mode,
>>> +		.set_next_event = efm32_clock_event_set_next_event,
>>> +		.rating = 200,
>>> +	},
>>> +};
>>> +
>>> +static struct irqaction efm32_clock_event_irq = {
>>> +	.name = "efm32 clockevent",
>>> +	.flags = IRQF_TIMER,
>>> +	.handler = efm32_clock_event_handler,
>>> +	.dev_id = &clock_event_ddata,
>>> +};
>>
>> Function name looks a bit long.
> Which function? I prefer having a unique prefix for the driver + an
> accurate description. All lines affected by "efm32_clock_event_handler"
> don't even need to be broken, so IMO it's OK like that.

Well, replacing clock_event/clockevent by clkevt and clocksource by
clksrc would have made the functions name shorter. But it is a personal
preference, feel free to ignore it if you prefer your naming convention.

[ ... ]

>>> +
>>> +static void __init efm32_timer_init(struct device_node *np)
>>> +{
>>> +	static int has_clocksource, has_clockevent;
>>> +	int ret;
>>> +
>>> +	if (!has_clocksource) {
>>> +		ret = efm32_clocksource_init(np);
>>> +		if (!ret) {
>>> +			has_clocksource = 1;
>>> +			return;
>>> +		}
>>> +	}
>>> +
>>> +	if (!has_clockevent) {
>>> +		ret = efm32_clockevent_init(np);
>>> +		if (!ret) {
>>> +			has_clockevent = 1;
>>> +			return;
>>> +		}
>>> +	}
>>> +}
>>
>> I don't get the purpose of this initialization, can you explain ?
> An efm32 SoC has four timer blocks. A single block can only be used for
> one of clocksource or clockevent device and having more than one
> clocksource or clockevent device doesn't make sense. So this routine
> asserts that the first timer is used as clocksource and the second as
> clockevent device. The others are unused.

Shouldn't be up to the dt to give the timers you want ?


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

