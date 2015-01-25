Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbbAYPDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 10:03:13 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59746 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbAYPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 10:03:10 -0500
Message-ID: <54C505A7.6000506@linaro.org>
Date: Sun, 25 Jan 2015 16:03:03 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
References: <cover.1421821466.git.baruch@tkos.co.il> <762d81b2cf12922ba28fb58b3ea4d5b7072abefb.1421821466.git.baruch@tkos.co.il> <54C0F30F.9060607@linaro.org> <20150125144656.GO2555@sapphire.tkos.co.il>
In-Reply-To: <20150125144656.GO2555@sapphire.tkos.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2015 03:46 PM, Baruch Siach wrote:
> Hi Daniel,
>
> On Thu, Jan 22, 2015 at 01:54:39PM +0100, Daniel Lezcano wrote:
>> On 01/21/2015 07:36 AM, Baruch Siach wrote:
>>> + * Based on:
>>> + *	Allwinner SoCs hstimer driver
>>
>> If this is based on the Allwinnner driver, may be you can have a look at the
>> patchset sent by Maxim to make sure your implementation is complete ?
>>
>> https://lkml.org/lkml/2015/1/11/52
>
> Thanks for the tip. I'll take the applicable parts from that series.
>
> [...]
>
>>> +static void __iomem *timer_base;
>>> +static u32 ticks_per_jiffy;
>>
>> Mind to encapsulate those global variables in a structure and use
>> container_of to access those fields like:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/clocksource/mtk_timer.c#n56
>>
>> ?
>
> The trouble is that the sched_clock callback (digicolor_timer_sched_read)
> needs a static timer_base to find the timer counter. Do you think adding a
> structure is worth it only for ticks_per_jiffy?

Well you will have to define the global variable for this structure. So 
you should be able to access the timer base directly. I agree it is not 
perfect but at least that will encapsulate the code for the clockevents 
side.

>>> +static void digicolor_clkevt_mode(enum clock_event_mode mode,
>>> +				  struct clock_event_device *clk)
>>> +{
>>> +	switch (mode) {
>>> +	case CLOCK_EVT_MODE_PERIODIC:
>>> +		writeb(0, timer_base + CONTROL(TIMER_C));
>>
>> Even if that sounds overkill, please replace '0', '1' with whatever macro
>> name (eg. TIMER_DISABLE/ENABLE).
>
> Will do for the entire file.
>
> [...]
>
>>> +static struct irqaction digicolor_timer_irq = {
>>> +	.name = "digicolor_timerC",
>>> +	.flags = IRQF_TIMER | IRQF_IRQPOLL,
>>> +	.handler = digicolor_timer_interrupt,
>>> +	.dev_id = &digicolor_clockevent,
>>> +};
>>
>> The current trend is to use 'request_irq', so no such structure
>> declaration/initialization is needed.
>
> Thanks. Will do.
>
>>> +	writel(~0, timer_base + COUNT(TIMER_B));
>>
>> s/~0/UINT_MAX/ ?
>
> Ack.
>
> Thanks for reviewing. I'll post an updated series shortly.

Ok, thanks.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

