Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3KVThS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:37:18 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:33964 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755840Ab3KVThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:37:09 -0500
MIME-Version: 1.0
In-Reply-To: <528C95D2.5090200@arm.com>
References: <1384897358-22940-1-git-send-email-fkan@apm.com>
	<528C95D2.5090200@arm.com>
Date: Fri, 22 Nov 2013 11:37:08 -0800
Message-ID: <CAL85gmD9sxyn9ELNQePbCYAAnovSE_vgbdYZccrkTdX1YPRhiA@mail.gmail.com>
Subject: Re: [PATCH 1/1] irq-gic: add capability to set bypass flag in GIC
From: Feng Kan <fkan@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>       set_handle_irq(gic_handle_irq);
>>
>> +     gic->bypass_flag = (bypass_val & 0xf) << 4;

>Beware, the top 2 bits are reserved on GICv1, and shouldn't be messed with.

The only time those bits are touched are when the dts is modified with the
bypass flag. Otherwise those bits remain untouched as before.


>> -     gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
>> +     if (of_property_read_u32(node, "bypass-flags", &bypass_val))
>> +             bypass_val = 0;
>
> [adding Mark on Cc, so he can comment on the DT parts]
>
> Where's the DT documentation update? Also, as this is an
> implementation-specific quirk, you should consider using a separate
> compatible string and move the handling of this issue into some X-Gene
> specific code.

Yes, the only way to do that nicely would be to add another irq-xgene file.
Since I see little of gic specific implementation in the irq-gic file. To add
another irq-xgene file for one change seems excessive at the time. Given
that in v2 these bypass bits are added, is it better to check for v2 dts
property before modify the CPU_CTRL register?

>
>> +     gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, bypass_val, node);
>>
>>       if (parent) {
>>               irq = irq_of_parse_and_map(node, 0);
>> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
>> index 0e5d9ec..999515b 100644
>> --- a/include/linux/irqchip/arm-gic.h
>> +++ b/include/linux/irqchip/arm-gic.h
>> @@ -64,14 +64,14 @@ struct device_node;
>>  extern struct irq_chip gic_arch_extn;
>>
>>  void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
>> -                 u32 offset, struct device_node *);
>> +                 u32 offset, u32 bypass_val, struct device_node *);
>>  void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
>>  void gic_cpu_if_down(void);
>>
>>  static inline void gic_init(unsigned int nr, int start,
>>                           void __iomem *dist , void __iomem *cpu)
>>  {
>> -     gic_init_bases(nr, start, dist, cpu, 0, NULL);
>> +     gic_init_bases(nr, start, dist, cpu, 0, 0, NULL);
>>  }
>>
>>  #endif /* __ASSEMBLY */
>>
>
> Cheers,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
