Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaGOOxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:53:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57936 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:53:12 -0400
Message-ID: <53C54042.2030507@linaro.org>
Date: Tue, 15 Jul 2014 15:52:50 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Harro Haan <hrhaan@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
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
Subject: Re: [PATCH v8 0/4] arm: KGDB NMI/FIQ support
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>	<1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>	<CAB5oZtCk5NwBJF+dBESKGhYabti=EWWtF2jJYK7HdyNHM46nTw@mail.gmail.com>	<53C4F745.3070701@linaro.org> <CAB5oZtBSZJVqyO8GKdKqh0+3=GDkCyuqrAOQhMRxN0JFBnmZ6w@mail.gmail.com>
In-Reply-To: <CAB5oZtBSZJVqyO8GKdKqh0+3=GDkCyuqrAOQhMRxN0JFBnmZ6w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:04, Harro Haan wrote:
>> Makes sense.
>>
>> Avoiding this problem on GICv2 is easy (thanks to the aliased intack
>> register) but on iMX.6 we have only a GICv1.
>>
>>
>>> I can reduce the number of occurrences (not prevent it) by adding the
>>> following hack to irq-gic.c
>>> @@ -297,10 +309,12 @@ static asmlinkage void __exception_irq_entry
>>> gic_handle_irq(struct pt_regs *regs
>>>   u32 irqstat, irqnr;
>>>   struct gic_chip_data *gic = &gic_data[0];
>>>   void __iomem *cpu_base = gic_data_cpu_base(gic);
>>>
>>>   do {
>>> + while(readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_PENDING_SET)
>>> & (1 << 30))
>>> +   printk(KERN_ERR "TEMP: gic_handle_irq: wait for FIQ exception\n");
>>>   irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>>>   irqnr = irqstat & ~0x1c00;
>>
>> I've made a more complete attempt to fix this. Could you test the
>> following? (and be prepared to fuzz the line numbers)
> 
> Thanks Daniel, I have tested it, see the comments below.
> 
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 73ae896..309bf2c 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -303,6 +303,28 @@ static int gic_set_wake(struct irq_data *d,
>> unsigned int on)
>>  #define gic_set_wake   NULL
>>  #endif
>>
>> +/* Check for group 0 interrupt spuriously acked as a normal IRQ. This
>> + * workaround will only work for level triggered interrupts (and in
>> + * its current form is actively harmful on systems that don't support
>> + * FIQ).
>> + */
>> +static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32
>> irqstat)
>> +{
>> +       u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>> +
>> +       if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
>> +               return irqnr;
>> +
>> +       if (readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_IGROUP +
>> +                         (irqnr / 32 * 4)) &
>> +           BIT(irqnr % 32))
>> +               return irqnr;
>> +
>> +       /* this interrupt was spurious (needs to be handled as FIQ) */
>> +       writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
> 
> This will NOT work, because of the note I mentioned above:
> "The FIQ exception will not occur anymore after gic_handle_irq
> read/acknowledges the FIQ by reading the GIC_CPU_INTACK register"
> So with this code you will say End Of Interrupt at the GIC level,
> without actually handling the interrupt, so you are missing an
> interrupt.
> I did the following test to confirm the missing interrupt:
> I have changed the periodic timer interrupt by an one-shot timer
> interrupt. The one-shot timer interrupt is programmed by the FIQ
> handler for the next FIQ interrupt. As expected: When the problem
> occurs, no more FIQ interrupts are generated.

Can you confirm whether your timer interrupts are configured level or
edge triggered? Or whether EOIing the GIC causes them to be cleared by
some other means.

A level triggered interrupt that hasn't been serviced should return the
pending state (shouldn't it?).


>> +       return 1023;
>> +}
>> +
>>  static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>>  {
>>         u32 irqstat, irqnr;
>> @@ -310,8 +332,10 @@ static void __exception_irq_entry
>> gic_handle_irq(struct pt_regs *regs)
>>         void __iomem *cpu_base = gic_data_cpu_base(gic);
>>
>>         do {
>> +               local_fiq_disable();
> 
> It is a bit weird to disable the "Non-Maskable Interrupt" at every
> interrupt, because of a problem that occurs once every few thousand
> interrupts

Given that simply reading from GIC_CPU_INTACK has significantly
interferes with FIQ reception means that I'm not too worried about this.

Note also that leaving the FIQ unmasked increases worst case latency
here because once we get a group 0 interrupt back from intack then
spurious entry to the FIQ handler (which would see an ACK of 1023) just
wastes cycles.


>>                 irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>> -               irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>> +               irqnr = gic_handle_spurious_group_0(gic, irqstat);
>> +               local_fiq_enable();
>>
>>                 if (likely(irqnr > 15 && irqnr < 1021)) {
>>                         irqnr = irq_find_mapping(gic->domain, irqnr);
> 
> 
> The following type of changes could fix the problem for me:
> 
> @@ -290,19 +290,66 @@ static int gic_set_wake(struct irq_data *d,
> unsigned int on)
> 
>  #else
>  #define gic_set_wake NULL
>  #endif
> 
> +extern void (*fiq_handler)(void);
> +
> +/* Check for group 0 interrupt spuriously acked as a normal IRQ. This
> + * workaround will only work for level triggered interrupts (and in
> + * its current form is actively harmful on systems that don't support
> + * FIQ).
> + */
> +static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32 irqstat)
> +{
> + u32 irqnr = irqstat & ~0x1c00;
> +
> + if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
> + return irqnr;
> +
> + if (readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_IGROUP +
> +  (irqnr / 32 * 4)) & BIT(irqnr % 32))
> + return irqnr;
> +
> + /*
> + * The FIQ should be disabled before the next FIQ interrupt occurs,
> + * so this only works when the next FIQ interrupt is not "too fast"
> + * after the previous one.
> + */
> + local_fiq_disable();
> +
> + /*
> + * Notes:
> + * - The FIQ exception will not occur anymore for this current
> + *   interrupt, because gic_handle_irq has already read/acknowledged
> + *   the GIC_CPU_INTACK register. So handle the FIQ here.
> + * - The fiq_handler below should not call ack_fiq and eoi_fiq,
> + *   because rereading the GIC_CPU_INTACK register returns spurious
> + *   interrupt ID 0x3FF. So probably you will have to add sometime like
> + *   the following to fiq_handler:
> + *   u32 cpsr, irqstat;
> + *   __asm__("mrs %0, cpsr" : "=r" (cpsr));
> + *   if ((cpsr & MODE_MASK) == FIQ_MODE)
> + *   irqstat = ack_fiq();
> + */
> + (*fiq_handler)();

Any portable approach would have to switch to FIQ mode to run the
handler in order to provide the proper register banks for FIQ handlers
written in assembler.

If we can't get level triggering to work then we have to:

1. Write code to jump correctly into FIQ mode.

2. Modify the gic's ack_fiq() callback to automatically avoid reading
   intack when the workaround is deployed.

The above is why I wanted to see if we can make do with level triggering
(and automatic re-triggering for interrupts such as SGIs that are
cleared by EOI).


