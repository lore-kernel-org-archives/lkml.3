Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBZKFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:05:12 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:49598 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751127AbaBZKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:05:05 -0500
Message-ID: <530DBC4C.9050802@arm.com>
Date: Wed, 26 Feb 2014 10:05:00 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH] irqchip:gic: change access of gicc_ctrl register to read
 modify write.
References: <1392761550-11662-1-git-send-email-fkan@apm.com> <53048882.9070706@arm.com> <CAL85gmBjdBWv-aMAGQtufmJUSKanzPoXa0QfHo756KM+E0orqA@mail.gmail.com>
In-Reply-To: <CAL85gmBjdBWv-aMAGQtufmJUSKanzPoXa0QfHo756KM+E0orqA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing tglx's email address so he too can enjoy the fun...]

On 25/02/14 20:19, Feng Kan wrote:
> On Wed, Feb 19, 2014 at 2:33 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Hi Feng,
>>
>> On 18/02/14 22:12, Feng Kan wrote:
>>> This change is made to preserve the GIC v2 releated bits in the
>>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>>> The original code only set the enable/disable group bit in this register.
>>> This code will preserve all other bits configured by the bootload except
>>
>> This "all other bits" in itself is a major problem, see below.
>>
>>> the enable/disable bit. The main reason for this change is to allow the
>>> bypass bits specified in the v2 spec to remain untouched by the current
>>> GIC code. In the X-Gene platform, the bypass functionality is not used
>>> and bypass must be disabled at all time.
>>>
>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>> Acked-by: Anup Patel <apatel@apm.com>
>>> Signed-off-by: Feng Kan <fkan@apm.com>
>>> ---
>>>  drivers/irqchip/irq-gic.c | 18 +++++++++++++++---
>>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index 341c601..9adc3e1 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>>       void __iomem *dist_base = gic_data_dist_base(gic);
>>>       void __iomem *base = gic_data_cpu_base(gic);
>>>       unsigned int cpu_mask, cpu = smp_processor_id();
>>> +     unsigned int ctrl_mask;
>>>       int i;
>>>
>>>       /*
>>> @@ -449,13 +450,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>>
>>>       writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>>> -     writel_relaxed(1, base + GIC_CPU_CTRL);
>>> +
>>> +     ctrl_mask = readl(base + GIC_CPU_CTRL);
>>> +     ctrl_mask |= 0x1;
>>> +     writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
>>
>> So what if the firmware used a different EOImode? We would end up in a
>> situation where we don't deactivate the interrupts anymore. Not good.
> Is there an case where the EOI mode usage would change on the fly?
> Bootloader's job would be to setup the bits so the kernel would work properly.

If you trust bootloaders to get anything right, you shouldn't ever touch
the Linux IRQ code.

Since the ancient times, bootloaders have been known to be part of a
conspiracy aiming to destroy Mankind and rule the Earth. Bootloaders are
the Orcs of software. It's been scientifically proven that they are
responsible for climate change. Seen the floods in England? Bootloaders.
Exploding volcanoes? Bootloaders. The flat tire on your bike?
Bootloaders. Enough said.

> Do you have a case in mind that would violate this setup?

What if your bootloader is actually a small RT kernel that uses
interrupt nesting (hence EOImode==1 to be able to split deactivation
from priority drop)? ECOS/RedBoot anyone?

Do you think for a second that this thing will kindly reset EIOmode to
zero just because it loads a Linux kernel? See the above.

Remember this code is used on a lot of fairly insane platforms. You
*must* be extremely conservative in any change you make.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
