Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaBYUT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:19:28 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:57330 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752598AbaBYUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <53048882.9070706@arm.com>
References: <1392761550-11662-1-git-send-email-fkan@apm.com>
	<53048882.9070706@arm.com>
Date: Tue, 25 Feb 2014 12:19:25 -0800
Message-ID: <CAL85gmBjdBWv-aMAGQtufmJUSKanzPoXa0QfHo756KM+E0orqA@mail.gmail.com>
Subject: Re: [PATCH] irqchip:gic: change access of gicc_ctrl register to read
 modify write.
From: Feng Kan <fkan@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.dev" <tglx@linutronix.dev>,
        "patches@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 2:33 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Feng,
>
> On 18/02/14 22:12, Feng Kan wrote:
>> This change is made to preserve the GIC v2 releated bits in the
>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>> The original code only set the enable/disable group bit in this register.
>> This code will preserve all other bits configured by the bootload except
>
> This "all other bits" in itself is a major problem, see below.
>
>> the enable/disable bit. The main reason for this change is to allow the
>> bypass bits specified in the v2 spec to remain untouched by the current
>> GIC code. In the X-Gene platform, the bypass functionality is not used
>> and bypass must be disabled at all time.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Acked-by: Anup Patel <apatel@apm.com>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  drivers/irqchip/irq-gic.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 341c601..9adc3e1 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>       void __iomem *dist_base = gic_data_dist_base(gic);
>>       void __iomem *base = gic_data_cpu_base(gic);
>>       unsigned int cpu_mask, cpu = smp_processor_id();
>> +     unsigned int ctrl_mask;
>>       int i;
>>
>>       /*
>> @@ -449,13 +450,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>
>>       writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(1, base + GIC_CPU_CTRL);
>> +
>> +     ctrl_mask = readl(base + GIC_CPU_CTRL);
>> +     ctrl_mask |= 0x1;
>> +     writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
>
> So what if the firmware used a different EOImode? We would end up in a
> situation where we don't deactivate the interrupts anymore. Not good.
Is there an case where the EOI mode usage would change on the fly?
Bootloader's job would be to setup the bits so the kernel would work properly.
Do you have a case in mind that would violate this setup?
>
> You should only preserve the bits that actually matter, and that won't
> have an impact with the way the kernel works.


>
>>  }
>>
>>  void gic_cpu_if_down(void)
>>  {
>> +     unsigned int ctrl_mask;
>>       void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>> -     writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
>> +
>> +     ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
>> +     ctrl_mask &= 0xfffffffe;
>
> nit: use
>
>         ctlr_mask &= ~1;
>
> in order to be consistent with the rest of the code.
>
>> +     writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>>  }
>>
>>  #ifdef CONFIG_CPU_PM
>> @@ -566,6 +574,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>  {
>>       int i;
>>       u32 *ptr;
>> +     unsigned int ctrl_mask;
>>       void __iomem *dist_base;
>>       void __iomem *cpu_base;
>>
>> @@ -590,7 +599,10 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>>
>>       writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>> +
>> +     ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
>> +     ctrl_mask |= 0x1;
>> +     writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>>  }
>>
>>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,      void *v)
>>
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
