Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612AbaGPRPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:15:18 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43769 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbaGPRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <53C5600C.1080004@linaro.org>
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
	<1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
	<CAB5oZtCk5NwBJF+dBESKGhYabti=EWWtF2jJYK7HdyNHM46nTw@mail.gmail.com>
	<53C4F745.3070701@linaro.org>
	<CAB5oZtBSZJVqyO8GKdKqh0+3=GDkCyuqrAOQhMRxN0JFBnmZ6w@mail.gmail.com>
	<53C54042.2030507@linaro.org>
	<CAB5oZtDy=TDz12_6ua_M3g=bQ+zB6cJTH3bUT9oA8snLDRBMTw@mail.gmail.com>
	<53C5600C.1080004@linaro.org>
Date: Wed, 16 Jul 2014 19:15:12 +0200
Message-ID: <CAB5oZtAt0ZWJB1FOmzaFphM2Y566U73=U+HniPLTm9c1suVqNg@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] arm: KGDB NMI/FIQ support
From: Harro Haan <hrhaan@gmail.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        John Stultz <john.stultz@linaro.org>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 July 2014 19:08, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> On 15/07/14 16:59, Harro Haan wrote:
>> On 15 July 2014 16:52, Daniel Thompson <daniel.thompson@linaro.org> wrote:
>>> On 15/07/14 14:04, Harro Haan wrote:
>>>>> Makes sense.
>>>>>
>>>>> Avoiding this problem on GICv2 is easy (thanks to the aliased intack
>>>>> register) but on iMX.6 we have only a GICv1.
>>>>>
>>>>>
>>>>>> I can reduce the number of occurrences (not prevent it) by adding the
>>>>>> following hack to irq-gic.c
>>>>>> @@ -297,10 +309,12 @@ static asmlinkage void __exception_irq_entry
>>>>>> gic_handle_irq(struct pt_regs *regs
>>>>>>   u32 irqstat, irqnr;
>>>>>>   struct gic_chip_data *gic = &gic_data[0];
>>>>>>   void __iomem *cpu_base = gic_data_cpu_base(gic);
>>>>>>
>>>>>>   do {
>>>>>> + while(readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_PENDING_SET)
>>>>>> & (1 << 30))
>>>>>> +   printk(KERN_ERR "TEMP: gic_handle_irq: wait for FIQ exception\n");
>>>>>>   irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>>>>>>   irqnr = irqstat & ~0x1c00;
>>>>>
>>>>> I've made a more complete attempt to fix this. Could you test the
>>>>> following? (and be prepared to fuzz the line numbers)
>>>>
>>>> Thanks Daniel, I have tested it, see the comments below.
>>>>
>>>>>
>>>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>>>> index 73ae896..309bf2c 100644
>>>>> --- a/drivers/irqchip/irq-gic.c
>>>>> +++ b/drivers/irqchip/irq-gic.c
>>>>> @@ -303,6 +303,28 @@ static int gic_set_wake(struct irq_data *d,
>>>>> unsigned int on)
>>>>>  #define gic_set_wake   NULL
>>>>>  #endif
>>>>>
>>>>> +/* Check for group 0 interrupt spuriously acked as a normal IRQ. This
>>>>> + * workaround will only work for level triggered interrupts (and in
>>>>> + * its current form is actively harmful on systems that don't support
>>>>> + * FIQ).
>>>>> + */
>>>>> +static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32
>>>>> irqstat)
>>>>> +{
>>>>> +       u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>>>>> +
>>>>> +       if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
>>>>> +               return irqnr;
>>>>> +
>>>>> +       if (readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_IGROUP +
>>>>> +                         (irqnr / 32 * 4)) &
>>>>> +           BIT(irqnr % 32))
>>>>> +               return irqnr;
>>>>> +
>>>>> +       /* this interrupt was spurious (needs to be handled as FIQ) */
>>>>> +       writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
>>>>
>>>> This will NOT work, because of the note I mentioned above:
>>>> "The FIQ exception will not occur anymore after gic_handle_irq
>>>> read/acknowledges the FIQ by reading the GIC_CPU_INTACK register"
>>>> So with this code you will say End Of Interrupt at the GIC level,
>>>> without actually handling the interrupt, so you are missing an
>>>> interrupt.
>>>> I did the following test to confirm the missing interrupt:
>>>> I have changed the periodic timer interrupt by an one-shot timer
>>>> interrupt. The one-shot timer interrupt is programmed by the FIQ
>>>> handler for the next FIQ interrupt. As expected: When the problem
>>>> occurs, no more FIQ interrupts are generated.
>>>
>>> Can you confirm whether your timer interrupts are configured level or
>>> edge triggered? Or whether EOIing the GIC causes them to be cleared by
>>> some other means.
>>
>> From page 48 of DDI0407I_cortex_a9_mpcore_r4p1_trm.pdf:
>> Watchdog timers, PPI(3)
>> Each Cortex-A9 processor has its own watchdog timers that can generate
>> interrupts, using ID30.
>>
>> From page 56:
>> PPI[0], [2],and[3]:b11
>> interrupt is rising-edge sensitive.
>
> Thanks. This is clear.
>
>
>>> If we can't get level triggering to work then we have to:
>>>
>>> 1. Write code to jump correctly into FIQ mode.
>>>
>>> 2. Modify the gic's ack_fiq() callback to automatically avoid reading
>>>    intack when the workaround is deployed.
>>>
>>> The above is why I wanted to see if we can make do with level triggering
>>> (and automatic re-triggering for interrupts such as SGIs that are
>>> cleared by EOI).
>>
>> But the re-triggering introduces extra latencies and a lot of use
>> cases of FIQ's try to avoid that.
>
> I'm not really clear why retriggering should be significantly more
> expensive than the dance required to fake up entry the FIQ handler.
>
> On the other hand retriggering allows us to avoid hacks in the FIQ
> handler to stop it acknowledging the interrupt. Given hacks like that
> won't be needed on A7/A15 this seems like a good outcome.
>
> Anyhow I've put together a new version of my earlier patch that I think
> will retrigger all interrupts except SGIs (I'll look at SGIs and
> compatibility with non-Freescale parts only if this improved approach
> works).
>
> Reported-by: Harro Haan <hrhaan@gmail.com>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  drivers/irqchip/irq-gic.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 73ae896..88f92e6 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -303,6 +303,33 @@ static int gic_set_wake(struct irq_data *d,
> unsigned int on)
>  #define gic_set_wake   NULL
>  #endif
>
> +/* This is a software emulation of the Aliased Interrupt Acknowledge
> Register
> + * (GIC_AIAR) found in GICv2+.
> + */
> +static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32
> irqstat)
> +{
> +       u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> +       void __iomem *dist_base = gic_data_dist_base(gic);
> +       u32 offset, mask;
> +
> +       if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
> +               return irqnr;
> +
> +       offset = irqnr / 32 * 4;
> +       mask = 1 << (irqnr % 32);
> +       if (readl_relaxed(dist_base + GIC_DIST_IGROUP + offset) & mask)
> +               return irqnr;
> +
> +       /* this interrupt must be taken as a FIQ so put it back into the
> +        * pending state and end our own servicing of it.
> +        */
> +       writel_relaxed(mask, dist_base + GIC_DIST_PENDING_SET + offset);
> +       readl_relaxed(dist_base + GIC_DIST_PENDING_SET + offset);
> +       writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
> +
> +       return 1023;
> +}
> +
>  static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  {
>         u32 irqstat, irqnr;
> @@ -310,8 +337,10 @@ static void __exception_irq_entry
> gic_handle_irq(struct pt_regs *regs)
>         void __iomem *cpu_base = gic_data_cpu_base(gic);
>
>         do {
> +               local_fiq_disable();
>                 irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
> -               irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> +               irqnr = gic_handle_spurious_group_0(gic, irqstat);
> +               local_fiq_enable();
>
>                 if (likely(irqnr > 15 && irqnr < 1021)) {
>                         irqnr = irq_find_mapping(gic->domain, irqnr);
> --
> 1.9.3
>
>
>

I just tested the above code. This approach also works as expected for
edge sensitive interrupts.
