Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaIHQ5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:57:06 -0400
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:44746 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754391AbaIHQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAFdej02vSm8TbUWGsMr936WN1GNmJ0SBuEKQkKyzKoEjtVmc+g@mail.gmail.com>
References: <1393537013-6264-1-git-send-email-fkan@apm.com>
	<CAFdej02vSm8TbUWGsMr936WN1GNmJ0SBuEKQkKyzKoEjtVmc+g@mail.gmail.com>
Date: Mon, 8 Sep 2014 09:57:01 -0700
Message-ID: <CAL85gmBRUuc3mtOGSkNuspEgkRQe42LV0e=fQfNmwcCicjT=vA@mail.gmail.com>
Subject: Re: [PATCH V3] irqchip:gic: change access of gicc_ctrl register to
 read modify write.
From: Feng Kan <fkan@apm.com>
To: Arun Chandran <achandran@mvista.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, patches <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 1:52 AM, Arun Chandran <achandran@mvista.com> wrote:
> Hi Feng,
>
> Is this patch still needed to fix perf calltrace?
Yes, if the someone decide to run the secure mode of the GIC, which is
what is present in
the kernel tree now.

> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265814.html
>
> On Fri, Feb 28, 2014 at 3:06 AM, Feng Kan <fkan@apm.com> wrote:
>> This change is made to preserve the GIC v2 releated bits in the
>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>> The original code only set the enable/disable group bit in this register.
>> This code will preserve the bypass bits configured by the bootload except
>> the enable/disable bit. The main reason for this change is to allow the
>> bypass bits specified in the v2 spec to remain untouched by the current
>> GIC code. In the X-Gene platform, the bypass functionality is not used
>> and bypass must be disabled at all time.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Acked-by: Anup Patel <apatel@apm.com>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>> V3 Changes:
>>         - Sorry, forgot to change the mask for cpu_init path
>>           assumed bootloader setup bits correctly.
>> V2 Changes:
>>         - only mask off v2 bypass bits
>>  drivers/irqchip/irq-gic.c |   32 +++++++++++++++++++++++++++++---
>>  1 files changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 341c601..3ca7995 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>         void __iomem *dist_base = gic_data_dist_base(gic);
>>         void __iomem *base = gic_data_cpu_base(gic);
>>         unsigned int cpu_mask, cpu = smp_processor_id();
>> +       unsigned int ctrl_mask;
>>         int i;
>>
>>         /*
>> @@ -449,13 +450,29 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>                 writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>
>>         writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>> -       writel_relaxed(1, base + GIC_CPU_CTRL);
>> +
>> +       ctrl_mask = readl(base + GIC_CPU_CTRL);
>
> readl_relaxed() here?
>
>> +
>> +       /* Mask out the gic v2 bypass bits */
>> +       ctrl_mask &= 0x1e0;
>> +
>> +       /* Enable group 0 */
>> +       ctrl_mask |= 0x1;
>> +       writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
>>  }
>>
>>  void gic_cpu_if_down(void)
>>  {
>> +       unsigned int ctrl_mask;
>>         void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>> -       writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
>> +
>> +       ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
> readl_relaxed() here?
>
>> +       /*
>> +        * Disable grp enable bit, leave the bypass bits alone as changing
>> +        * them could leave the system unstable
>> +        */
>> +       ctrl_mask &= 0x1e0;
>> +       writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>>  }
>>
>>  #ifdef CONFIG_CPU_PM
>> @@ -566,6 +583,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>  {
>>         int i;
>>         u32 *ptr;
>> +       unsigned int ctrl_mask;
>>         void __iomem *dist_base;
>>         void __iomem *cpu_base;
>>
>> @@ -590,7 +608,15 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>                 writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>>
>>         writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>> -       writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>> +
>> +       ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
>
> readl_relaxed() here?
Trying to make sure read is completed before write back out to gic.
>
>> +
>> +       /* Mask out the gic v2 bypass bits */
>> +       ctrl_mask &= 0x1e0;
>> +
>> +       /* Enable group 0 */
>> +       ctrl_mask |= 0x1;
>> +       writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>>  }
>>
>
> --Arun
