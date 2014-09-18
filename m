Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbaIRG54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:57:56 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:2451 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbaIRG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:57:54 -0400
Message-ID: <541A826D.1020107@imgtec.com>
Date: Thu, 18 Sep 2014 07:57:49 +0100
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        "John Crispin" <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/24] irqchip: mips-gic: Support local interrupts
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>	<1410825087-5497-22-git-send-email-abrestic@chromium.org>	<54195975.1010209@imgtec.com> <CAL1qeaFt5ZBauD38WMPB7WLkOqkTgtfO-gLKo3of7C_V-53eLA@mail.gmail.com>
In-Reply-To: <CAL1qeaFt5ZBauD38WMPB7WLkOqkTgtfO-gLKo3of7C_V-53eLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 06:40 PM, Andrew Bresticker wrote:
> On Wed, Sep 17, 2014 at 2:50 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
>> On 09/16/2014 12:51 AM, Andrew Bresticker wrote:
>>> The MIPS GIC supports 7 local interrupts, 2 of which are the GIC
>>> local watchdog and count/compare timer.  The remainder are CPU
>>> interrupts which may optionally be re-routed through the GIC.
>>> GIC hardware IRQs 0-6 are now used for local interrupts while
>>> hardware IRQs 7+ are used for external (shared) interrupts.
>>>
>>> Note that the 5 CPU interrupts may not be re-routable through
>>> the GIC.  In that case mapping will fail and the vectors reported
>>> in C0_IntCtl should be used instead.  gic_get_c0_compare_int() and
>>> gic_get_c0_perfcount_int() will return the correct IRQ number to
>>> use for the C0 timer and perfcounter interrupts based on the
>>> routability of those interrupts through the GIC.
>>>
>>> Malta, SEAD-3, and the GIC clockevent driver have been updated
>>> to use local interrupts and the R4K clockevent driver has been
>>> updated to poll for C0 timer interrupts through the GIC when
>>> the GIC is present.
>>>
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>> diff --git a/arch/mips/include/asm/mips-boards/maltaint.h
>>> b/arch/mips/include/asm/mips-boards/maltaint.h
>>> index bdd6f39..38b06a0 100644
>>> --- a/arch/mips/include/asm/mips-boards/maltaint.h
>>> +++ b/arch/mips/include/asm/mips-boards/maltaint.h
>>> @@ -10,6 +10,8 @@
>>>    #ifndef _MIPS_MALTAINT_H
>>>    #define _MIPS_MALTAINT_H
>>>    +#include <asm/gic.h>
>>> +
>>
>> nit: I think gic.h should be split to driver/irqchip/irq-mips-gic.h for
>> private definitions and include/linux/irqchip/irq-mips-gic.h for
>> exported/public definitions.
> Yup, I was planning on doing this in the next series :).  Malta and
> the clockevent/clocksource driver need to get cleaned up first though,
> so that they don't have to use the private register definitions.
>
>>> diff --git a/drivers/irqchip/irq-mips-gic.c
>>> b/drivers/irqchip/irq-mips-gic.c
>>> index 6682a4e..3abe310 100644
>>> --- a/drivers/irqchip/irq-mips-gic.c
>>> +++ b/drivers/irqchip/irq-mips-gic.c
>>> @@ -95,12 +96,39 @@ cycle_t gic_read_compare(void)
>>>    }
>>>    #endif
>>>    +static bool gic_local_irq_is_routable(int intr)
>>> +{
>>> +       u32 vpe_ctl;
>>> +
>>> +       /* All local interrupts are routable in EIC mode. */
>>> +       if (cpu_has_veic)
>>> +               return true;
>>> +
>>> +       GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_CTL), vpe_ctl);
>>> +       switch (intr) {
>>> +       case GIC_LOCAL_INT_TIMER:
>>> +               return vpe_ctl & GIC_VPE_CTL_TIMER_RTBL_MSK;
>>> +       case GIC_LOCAL_INT_PERFCTR:
>>> +               return vpe_ctl & GIC_VPE_CTL_PERFCNT_RTBL_MSK;
>>> +       case GIC_LOCAL_INT_FDC:
>>> +               return vpe_ctl & GIC_VPE_CTL_FDC_RTBL_MSK;
>>> +       case GIC_LOCAL_INT_SWINT0:
>>> +       case GIC_LOCAL_INT_SWINT1:
>>> +               /*
>>> +                * SWINT{0,1} are not routable in non-EIC mode, regardless
>>> +                * of the setting of SWINT_ROUTABLE.
>>> +                */
>>> +               return false;
>>
>> Hmm AFAIK they are routable. Actually from hard reset they're automatically
>> routed to vpe0 pin 0 which caught me a number of times when trying to use
>> software interrupt on hardware that has GIC. When setting software interrupt
>> I was seeing pin 0 going high too and thought it's a hardware bug for a
>> while.
> Interesting, the interAptiv User's Manual I have, in section 9.4.7.1,
> says: "Note that Software Interrupts from the VPE are routed
> internally by the CPU in vectored interrupt mode, and are only routed
> through the GIC when the GIC is in EIC mode, regardless of the
> GIC_VPEi_CTL register."  IIRC, there's a similar statement in the
> proAptiv manual as well.  I didn't play with the SWINT bits myself, so
> I wouldn't be surprised if that's wrong :).
>
>> I think all local interrupts should be masked at GIC initialisation except
>> for timer interrupt. I was preparing a set of patches for GIC but you beat
>> me into it :)
> If SWINT gets routed both through the GIC and directly to the CPU,
> then that's probably the best thing to do.  I suspect we'll also want
> to leave the performance counter interrupt unmasked too, since,
> unfortunately, both the HW perf event driver and oprofile do not use
> the percpu IRQ API.

Yeah probably. I haven't played much with the perf counters to be honest.

>>> @@ -341,12 +342,54 @@ static struct irq_chip gic_edge_irq_controller = {
>>>    #endif
>>>    };
>>>    +static unsigned int gic_get_local_int(void)
>>> +{
>>> +       unsigned long pending, masked;
>>> +
>>> +       GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_PEND), pending);
>>> +       GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_MASK), masked);
>>> +
>>> +       bitmap_and(&pending, &pending, &masked, GIC_NUM_LOCAL_INTRS);
>>> +
>>> +       return find_first_bit(&pending, GIC_NUM_LOCAL_INTRS);
>>> +}
>>> +
>>> +static void gic_mask_local_irq(struct irq_data *d)
>>> +{
>>> +       int intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
>>> +
>>> +       GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK), 1 << intr);
>>> +}
>>> +
>>> +static void gic_unmask_local_irq(struct irq_data *d)
>>> +{
>>> +       int intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
>>> +
>>> +       GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK), 1 << intr);
>>> +}
>>> +
>>> +static struct irq_chip gic_local_irq_controller = {
>>> +       .name                   =       "MIPS GIC Local",
>>> +       .irq_ack                =       gic_mask_local_irq,
>>> +       .irq_mask               =       gic_mask_local_irq,
>>> +       .irq_mask_ack           =       gic_mask_local_irq,
>>> +       .irq_unmask             =       gic_unmask_local_irq,
>>> +       .irq_eoi                =       gic_unmask_local_irq,
>>> +};
>>> +
>>
>> again I don't think irq_ack, irq_mask_ack and irq_eoi are needed.
> Yup, will do.

