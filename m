Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaIIK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:57:14 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:52965 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaIIK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:57:12 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <CAFdej03AmUn92sSH=7Hfk0+yWEFWaywJt63DjeTc+nHSZeb61A@mail.gmail.com>
References: <1393537013-6264-1-git-send-email-fkan@apm.com>
	<CAFdej02vSm8TbUWGsMr936WN1GNmJ0SBuEKQkKyzKoEjtVmc+g@mail.gmail.com>
	<CAL85gmBRUuc3mtOGSkNuspEgkRQe42LV0e=fQfNmwcCicjT=vA@mail.gmail.com>
	<CAFdej03AmUn92sSH=7Hfk0+yWEFWaywJt63DjeTc+nHSZeb61A@mail.gmail.com>
Date: Tue, 9 Sep 2014 16:27:11 +0530
X-Google-Sender-Auth: H4XcSK0akDEihBs7djXsfbGVyC0
Message-ID: <CAKZGPAObTe2L6YkBfWMAfeVqTbjE2UbHTO=QCLx6pWD-D2RM4A@mail.gmail.com>
Subject: Re: [PATCH V3] irqchip:gic: change access of gicc_ctrl register to
 read modify write.
From: Arun KS <arunks.linux@gmail.com>
To: Arun Chandran <achandran@mvista.com>
Cc: Feng Kan <fkan@apm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vinayak Kale <vkale@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Tue, Sep 9, 2014 at 11:31 AM, Arun Chandran <achandran@mvista.com> wrote:
> On Mon, Sep 8, 2014 at 10:27 PM, Feng Kan <fkan@apm.com> wrote:
>> On Mon, Sep 8, 2014 at 1:52 AM, Arun Chandran <achandran@mvista.com> wrote:
>>> Hi Feng,
>>>
>>> Is this patch still needed to fix perf calltrace?
>> Yes, if the someone decide to run the secure mode of the GIC, which is
>> what is present in
>> the kernel tree now.
>>
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265814.html
>>>
>>> On Fri, Feb 28, 2014 at 3:06 AM, Feng Kan <fkan@apm.com> wrote:
>>>> This change is made to preserve the GIC v2 releated bits in the
>>>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>>>> The original code only set the enable/disable group bit in this register.
>>>> This code will preserve the bypass bits configured by the bootload except
>>>> the enable/disable bit. The main reason for this change is to allow the
>>>> bypass bits specified in the v2 spec to remain untouched by the current
>>>> GIC code. In the X-Gene platform, the bypass functionality is not used
>>>> and bypass must be disabled at all time.
>>>>
>>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>>> Acked-by: Anup Patel <apatel@apm.com>
>>>> Signed-off-by: Feng Kan <fkan@apm.com>
>>>> ---
>>>> V3 Changes:
>>>>         - Sorry, forgot to change the mask for cpu_init path
>>>>           assumed bootloader setup bits correctly.
>>>> V2 Changes:
>>>>         - only mask off v2 bypass bits
>>>>  drivers/irqchip/irq-gic.c |   32 +++++++++++++++++++++++++++++---
>>>>  1 files changed, 29 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>>> index 341c601..3ca7995 100644
>>>> --- a/drivers/irqchip/irq-gic.c
>>>> +++ b/drivers/irqchip/irq-gic.c
>>>> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>>>         void __iomem *dist_base = gic_data_dist_base(gic);
>>>>         void __iomem *base = gic_data_cpu_base(gic);
>>>>         unsigned int cpu_mask, cpu = smp_processor_id();
>>>> +       unsigned int ctrl_mask;
>>>>         int i;
>>>>
>>>>         /*
>>>> @@ -449,13 +450,29 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>>>                 writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>>>
>>>>         writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>>>> -       writel_relaxed(1, base + GIC_CPU_CTRL);
>>>> +
>>>> +       ctrl_mask = readl(base + GIC_CPU_CTRL);
>>>
>>> readl_relaxed() here?
>>>
>>>> +
>>>> +       /* Mask out the gic v2 bypass bits */
>>>> +       ctrl_mask &= 0x1e0;
>>>> +
>>>> +       /* Enable group 0 */
>>>> +       ctrl_mask |= 0x1;
>>>> +       writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
>>>>  }
>>>>
>>>>  void gic_cpu_if_down(void)
>>>>  {
>>>> +       unsigned int ctrl_mask;
>>>>         void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>>>> -       writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
>>>> +
>>>> +       ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
>>> readl_relaxed() here?
>>>
>>>> +       /*
>>>> +        * Disable grp enable bit, leave the bypass bits alone as changing
>>>> +        * them could leave the system unstable
>>>> +        */
>>>> +       ctrl_mask &= 0x1e0;
>>>> +       writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>>>>  }
>>>>
>>>>  #ifdef CONFIG_CPU_PM
>>>> @@ -566,6 +583,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>>>  {
>>>>         int i;
>>>>         u32 *ptr;
>>>> +       unsigned int ctrl_mask;
>>>>         void __iomem *dist_base;
>>>>         void __iomem *cpu_base;
>>>>
>>>> @@ -590,7 +608,15 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>>>                 writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>>>>
>>>>         writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>>>> -       writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>>>> +
>>>> +       ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
>>>
>>> readl_relaxed() here?
>> Trying to make sure read is completed before write back out to gic.
>>>
>
> Will the cpu reorder  readl_relaxed() and a writel_relaxed() calls?
>
> val = readl_relaxed(reg1);
> val += 1;
> wrietl_relaxed(val, reg1);
>
> In the above code reg1 getting 'val+1' is not guaranteed?

reg1 getting 'val+1' is guaranteed because of the address dependency.
If we use writel instead of writel_relaxed(), there will be a dsb()
instruction inserted before actual write.
That is, all write operations before dsb() on all cores will be
committed. The processors stall during this period.
dsb also waits for any TLB or cache maintenance operations to finish
across cores/clusters.

In this scenario it is okey to use _relaxed(). I might be wrong, in
that case some experts will correct me here.

The rule is like writel() handle write buffer flushing by default. And
for performance related areas use _relaxed variants.

Thanks,
Arun KS

>
> --Arun
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
