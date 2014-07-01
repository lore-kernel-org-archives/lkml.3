Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbaGAIZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:25:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56653 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757876AbaGAIYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:24:55 -0400
Message-ID: <53B27049.10302@arm.com>
Date: Tue, 01 Jul 2014 09:24:41 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Anup Patel <anup@brainfault.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-4-git-send-email-marc.zyngier@arm.com> <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com> <alpine.DEB.2.02.1406302006220.8923@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1406302006220.8923@kaball.uk.xensource.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 30/06/14 20:09, Stefano Stabellini wrote:
> On Wed, 25 Jun 2014, Anup Patel wrote:
>> Hi Marc,
>>
>> On Wed, Jun 25, 2014 at 2:58 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> So far, GICv2 has been used in with EOImode == 0. The effect of this
>>> mode is to perform the priority drop and the deactivation of the
>>> interrupt at the same time.
>>>
>>> While this works perfectly for Linux (we only have a single priority),
>>> it causes issues when an interrupt is forwarded to a guest, and when
>>> we want the guest to perform the EOI itself.
>>>
>>> For this case, the GIC architecture provides EOImode == 1, where:
>>> - A write to the EOI register drops the priority of the interrupt and leaves
>>> it active. Other interrupts at the same priority level can now be taken,
>>> but the active interrupt cannot be taken again
>>> - A write to the DIR marks the interrupt as inactive, meaning it can
>>> now be taken again.
>>>
>>> We only enable this feature when booted in HYP mode. Also, as most device
>>> trees are broken (they report the CPU interface size to be 4kB, while
>>> the GICv2 CPU interface size is 8kB), output a warning if we're booted
>>> in HYP mode, and disable the feature.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  drivers/irqchip/irq-gic.c       | 61 +++++++++++++++++++++++++++++++++++++----
>>>  include/linux/irqchip/arm-gic.h |  4 +++
>>>  2 files changed, 59 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index 508b815..9295bf2 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -45,6 +45,7 @@
>>>  #include <asm/irq.h>
>>>  #include <asm/exception.h>
>>>  #include <asm/smp_plat.h>
>>> +#include <asm/virt.h>
>>>
>>>  #include "irq-gic-common.h"
>>>  #include "irqchip.h"
>>> @@ -94,6 +95,10 @@ struct irq_chip gic_arch_extn = {
>>>         .irq_set_wake   = NULL,
>>>  };
>>>
>>> +static struct irq_chip *gic_chip;
>>> +
>>> +static bool supports_deactivate = false;
>>> +
>>>  #ifndef MAX_GIC_NR
>>>  #define MAX_GIC_NR     1
>>>  #endif
>>> @@ -185,6 +190,12 @@ static void gic_eoi_irq(struct irq_data *d)
>>>         writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>>>  }
>>>
>>> +static void gic_eoi_dir_irq(struct irq_data *d)
>>> +{
>>> +       gic_eoi_irq(d);
>>> +       writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
>>> +}
> 
> Would it be better if you moved the gic_eoi_irq call earlier? Maybe
> somewhere in gic_handle_irq?

I'm not sure I see what we'd gain by doing so. Can you elaborate?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
