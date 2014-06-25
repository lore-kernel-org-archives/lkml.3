Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaFYOYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:24:16 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:49849 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757058AbaFYOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:24:15 -0400
Message-ID: <53AADB82.3040808@arm.com>
Date: Wed, 25 Jun 2014 15:24:02 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anup Patel <anup@brainfault.org>
CC: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-4-git-send-email-marc.zyngier@arm.com> <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
In-Reply-To: <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anup,

On 25/06/14 14:56, Anup Patel wrote:
> Hi Marc,
> 
> On Wed, Jun 25, 2014 at 2:58 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> So far, GICv2 has been used in with EOImode == 0. The effect of this
>> mode is to perform the priority drop and the deactivation of the
>> interrupt at the same time.
>>
>> While this works perfectly for Linux (we only have a single priority),
>> it causes issues when an interrupt is forwarded to a guest, and when
>> we want the guest to perform the EOI itself.
>>
>> For this case, the GIC architecture provides EOImode == 1, where:
>> - A write to the EOI register drops the priority of the interrupt and leaves
>> it active. Other interrupts at the same priority level can now be taken,
>> but the active interrupt cannot be taken again
>> - A write to the DIR marks the interrupt as inactive, meaning it can
>> now be taken again.
>>
>> We only enable this feature when booted in HYP mode. Also, as most device
>> trees are broken (they report the CPU interface size to be 4kB, while
>> the GICv2 CPU interface size is 8kB), output a warning if we're booted
>> in HYP mode, and disable the feature.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic.c       | 61 +++++++++++++++++++++++++++++++++++++----
>>  include/linux/irqchip/arm-gic.h |  4 +++
>>  2 files changed, 59 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 508b815..9295bf2 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -45,6 +45,7 @@
>>  #include <asm/irq.h>
>>  #include <asm/exception.h>
>>  #include <asm/smp_plat.h>
>> +#include <asm/virt.h>
>>
>>  #include "irq-gic-common.h"
>>  #include "irqchip.h"
>> @@ -94,6 +95,10 @@ struct irq_chip gic_arch_extn = {
>>         .irq_set_wake   = NULL,
>>  };
>>
>> +static struct irq_chip *gic_chip;
>> +
>> +static bool supports_deactivate = false;
>> +
>>  #ifndef MAX_GIC_NR
>>  #define MAX_GIC_NR     1
>>  #endif
>> @@ -185,6 +190,12 @@ static void gic_eoi_irq(struct irq_data *d)
>>         writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>>  }
>>
>> +static void gic_eoi_dir_irq(struct irq_data *d)
>> +{
>> +       gic_eoi_irq(d);
>> +       writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
>> +}
>> +
>>  static int gic_set_type(struct irq_data *d, unsigned int type)
>>  {
>>         void __iomem *base = gic_dist_base(d);
>> @@ -277,6 +288,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>>                 }
>>                 if (irqnr < 16) {
>>                         writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
>> +                       writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
>>  #ifdef CONFIG_SMP
>>                         handle_IPI(irqnr, regs);
>>  #endif
>> @@ -313,7 +325,7 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>>         chained_irq_exit(chip, desc);
>>  }
>>
>> -static struct irq_chip gic_chip = {
>> +static struct irq_chip gicv1_chip = {
>>         .name                   = "GIC",
>>         .irq_mask               = gic_mask_irq,
>>         .irq_unmask             = gic_unmask_irq,
>> @@ -326,6 +338,19 @@ static struct irq_chip gic_chip = {
>>         .irq_set_wake           = gic_set_wake,
>>  };
>>
>> +static struct irq_chip gicv2_chip = {
>> +       .name                   = "GIC",
>> +       .irq_mask               = gic_mask_irq,
>> +       .irq_unmask             = gic_unmask_irq,
>> +       .irq_eoi                = gic_eoi_dir_irq,
>> +       .irq_set_type           = gic_set_type,
>> +       .irq_retrigger          = gic_retrigger,
>> +#ifdef CONFIG_SMP
>> +       .irq_set_affinity       = gic_set_affinity,
>> +#endif
>> +       .irq_set_wake           = gic_set_wake,
>> +};
>> +
>>  void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>>  {
>>         if (gic_nr >= MAX_GIC_NR)
>> @@ -377,6 +402,16 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>>         writel_relaxed(1, base + GIC_DIST_CTRL);
>>  }
>>
>> +static void gic_cpu_if_up(void)
>> +{
>> +       void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>> +       u32 val = 0;
>> +
>> +       if (supports_deactivate)
>> +               val = GIC_CPU_CTRL_EOImodeNS;
>> +       writel_relaxed(val | 1, cpu_base + GIC_CPU_CTRL);
>> +}
>> +
>>  static void gic_cpu_init(struct gic_chip_data *gic)
>>  {
>>         void __iomem *dist_base = gic_data_dist_base(gic);
>> @@ -402,7 +437,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>         gic_cpu_config(dist_base, NULL);
>>
>>         writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>> -       writel_relaxed(1, base + GIC_CPU_CTRL);
>> +       gic_cpu_if_up();
>>  }
>>
>>  void gic_cpu_if_down(void)
>> @@ -543,7 +578,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>                 writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>>
>>         writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>> -       writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>> +       gic_cpu_if_up();
>>  }
>>
>>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,        void *v)
>> @@ -770,11 +805,11 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>>  {
>>         if (hw < 32) {
>>                 irq_set_percpu_devid(irq);
>> -               irq_set_chip_and_handler(irq, &gic_chip,
>> +               irq_set_chip_and_handler(irq, gic_chip,
>>                                          handle_percpu_devid_irq);
>>                 set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>>         } else {
>> -               irq_set_chip_and_handler(irq, &gic_chip,
>> +               irq_set_chip_and_handler(irq, gic_chip,
>>                                          handle_fasteoi_irq);
>>                 set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>>
>> @@ -951,6 +986,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>
>>         gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
>>
>> +       if (!supports_deactivate)
>> +               gic_chip = &gicv1_chip;
>> +       else
>> +               gic_chip = &gicv2_chip;
>> +
>>         if (of_property_read_u32(node, "arm,routable-irqs",
>>                                  &nr_routable_irqs)) {
>>                 irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
>> @@ -980,7 +1020,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>                 set_handle_irq(gic_handle_irq);
>>         }
>>
>> -       gic_chip.flags |= gic_arch_extn.flags;
>> +       gic_chip->flags |= gic_arch_extn.flags;
>>         gic_dist_init(gic);
>>         gic_cpu_init(gic);
>>         gic_pm_init(gic);
>> @@ -994,6 +1034,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>  {
>>         void __iomem *cpu_base;
>>         void __iomem *dist_base;
>> +       struct resource cu_res;
>>         u32 percpu_offset;
>>         int irq;
>>
>> @@ -1006,6 +1047,14 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>         cpu_base = of_iomap(node, 1);
>>         WARN(!cpu_base, "unable to map gic cpu registers\n");
>>
>> +       of_address_to_resource(node, 1, &cpu_res);
>> +       if (is_hyp_mode_available()) {
> 
> Interrupt deactivation feature is not dependent on whether hyp-mode
> is available or not.

Indeed. But for the Linux use-case, this is a pointless feature, unless
you want to use it for things like threaded interrupts (but that's not
what this patch series is about).

> We can use GICC_DIR even if CPU does not have virtualization
> extension. Also, we can use GICV_DIR when running as Guest or VM.

I know that. But what's the point? The joy of doing two MMIO accesses
instead of one? It is likely to be a net performance loss if you're not
actively using it.

> I think "supports_deactivate" should depend on
> the GIC compatible string.

Probably, but again, what is the point of using it if there is no benefit?

>> +               if (resource_size(&cpu_res) >= SZ_8K)
>> +                       supports_deactivate = true;
>> +               else
>> +                       pr_warn("GIC: CPU interface size is %x, DT is probably wrong\n", (int)resource_size(&cpu_res));
> 
> This will not work on APM X-Gene because, for X-Gene first CPU page
> is at 0x78020000 and second CPU page is at 0x78030000.

Then, as far as I'm concerned, it is not compliant with the architecture
(the GICv2 spec says clearly that GICC_DIR is at offset 0x1000, not
0x10000).

We can work around it, but that's not the purpose of this series.

> Ian had send-out a patch long time back to extend GIC dt-bindings for
> addressing this issue. 
> (http://www.spinics.net/lists/arm-kernel/msg283767.html)

Wow. That's really horrible. Blimey! Ian, you owe me a few beers, just
so I can forget this... ;-)

	M.
-- 
Jazz is not dead. It just smells funny...
