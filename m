Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3KYJWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:22:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40082 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3KYJWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:22:31 -0500
Message-ID: <529316D3.8030301@arm.com>
Date: Mon, 25 Nov 2013 09:22:27 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anup Patel <anup@brainfault.org>
CC: Feng Kan <fkan@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Vinayak Kale <vinayak.kale@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "Kumar, Satendra" <Satendra.Kumar@lsi.com>, Loc Ho <lho@apm.com>
Subject: Re: [PATCH 1/1] irq-gic: add capability to set bypass flag in GIC
References: <1384897358-22940-1-git-send-email-fkan@apm.com> <528C95D2.5090200@arm.com> <CAAhSdy2e_zmVEBsKLOC0DjHLL=dxDn9g4vV7sfs0jfSmPvEOow@mail.gmail.com>
In-Reply-To: <CAAhSdy2e_zmVEBsKLOC0DjHLL=dxDn9g4vV7sfs0jfSmPvEOow@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 25 Nov 2013 09:22:28.0287 (UTC) FILETIME=[DC35ECF0:01CEE9BF]
X-MC-Unique: 113112509222900101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/13 08:41, Anup Patel wrote:
> On Wed, Nov 20, 2013 at 4:28 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> [dropping <patches@apm.com> from the CC list, as someone seems to have
>>  tripped on the config file, and I'm tired of getting bounces]
>>
>> Feng,
>>
>> On 19/11/13 21:42, Feng Kan wrote:
>>> The GIC-400 implementation allows for FIQ and IRQ bypass. In the
>>> X-Gene implementation, the FIQ bypass must be enabled at all time.
>>> Otherwise, some PPI will appear as FIQ and cause kernel problem.
>>
>> How comes? Are only PPIs affected? When you say "some PPIs", can you be
>> more specific?
>>
>>> Signed-off-by: Feng Kan <fkan@apm.com>
>>> ---
>>>  drivers/irqchip/irq-gic.c       |   15 +++++++++++----
>>>  include/linux/irqchip/arm-gic.h |    4 ++--
>>>  2 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index d0e9480..aa7342e 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -65,6 +65,7 @@ struct gic_chip_data {
>>>  #endif
>>>       struct irq_domain *domain;
>>>       unsigned int gic_irqs;
>>> +     unsigned int bypass_flag;
>>>  #ifdef CONFIG_GIC_NON_BANKED
>>>       void __iomem *(*get_base)(union gic_base *);
>>>  #endif
>>> @@ -450,7 +451,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>>
>>>       writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>>> -     writel_relaxed(1, base + GIC_CPU_CTRL);
>>> +     writel_relaxed(gic->bypass_flag | 1, base + GIC_CPU_CTRL);
>>>  }
>>>
>>>  void gic_cpu_if_down(void)
>>> @@ -591,7 +592,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>>>
>>>       writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>>> -     writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>>> +     writel_relaxed(gic_data[gic_nr].bypass_flag | 1, cpu_base + GIC_CPU_CTRL);
>>>  }
>>>
>>>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,      void *v)
>>> @@ -733,7 +734,8 @@ const struct irq_domain_ops gic_irq_domain_ops = {
>>>
>>>  void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>>                          void __iomem *dist_base, void __iomem *cpu_base,
>>> -                        u32 percpu_offset, struct device_node *node)
>>> +                        u32 percpu_offset, u32 bypass_val,
>>> +                        struct device_node *node)
>>>  {
>>>       irq_hw_number_t hwirq_base;
>>>       struct gic_chip_data *gic;
>>> @@ -821,6 +823,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>>
>>>       set_handle_irq(gic_handle_irq);
>>>
>>> +     gic->bypass_flag = (bypass_val & 0xf) << 4;
>>
>> Beware, the top 2 bits are reserved on GICv1, and shouldn't be messed with.
>>
>>>       gic_chip.flags |= gic_arch_extn.flags;
>>>       gic_dist_init(gic);
>>>       gic_cpu_init(gic);
>>> @@ -835,6 +838,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
>>>       void __iomem *cpu_base;
>>>       void __iomem *dist_base;
>>>       u32 percpu_offset;
>>> +     u32 bypass_val;
>>>       int irq;
>>>
>>>       if (WARN_ON(!node))
>>> @@ -849,7 +853,10 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
>>>       if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>>>               percpu_offset = 0;
>>>
>>> -     gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
>>> +     if (of_property_read_u32(node, "bypass-flags", &bypass_val))
>>> +             bypass_val = 0;
>>
>> [adding Mark on Cc, so he can comment on the DT parts]
>>
>> Where's the DT documentation update? Also, as this is an
>> implementation-specific quirk, you should consider using a separate
>> compatible string and move the handling of this issue into some X-Gene
>> specific code.
> 
> Adding separate compatible string for X-Gene specific GIC will break
> VGIC code for X-Gene because VGIC code looks for DT node compatible
> to "arm,cortex-a15-gic". We don't want to break currently working VGIC
> code for X-Gene.

I'm sure you could manage adding another compat string to the vgic code...

> The Legacy-IRQ bypass disable and Legacy-FIQ bypass disable is a
> feature of GIC-400 and its not X-Gene specific. The only difference in X-Gene
> is that we use PPI31 (Legacy-IRQ) for timer and PPI28 (Legacy-FIQ) for perf

Amazing. Someone managed to push the weird-o-meter one level higher.
Were you *that* short on PPIs that you had to use these two?

> event. The issue is that IRQBypDisGrp0, FIQBypDisGrp0, IRQBypDisGrp1
> and FIQBypDisGrp1 bits are 0 by default and for X-Gene we need to set
> these bits to 1 so that GIC-400 does not bypass PPI31 (Legacy-IRQ) and
> PPI28 (Legacy-FIQ).
> 
> We should have more cleaner and optional device tree binding for GIC
> which can help us set IRQBypDisGrp0, FIQBypDisGrp0, IRQBypDisGrp1
> and FIQBypDisGrp1 bits for X-Gene.

Well, here's an alternative approach for you. As you said, this is in no
way X-Gene specific, so maybe we should address it directly in the GIC
code. Just hook something in the irq_mask/irq_unmask methods, so we can
detect the use of these two PPIs, and toggle the bypass flags
accordingly bits accordingly.

	M.
-- 
Jazz is not dead. It just smells funny...

