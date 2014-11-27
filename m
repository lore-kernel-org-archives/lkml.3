Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaK0Tmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:42:36 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54308 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaK0Tme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:42:34 -0500
Message-ID: <54777EA1.3030508@linaro.org>
Date: Thu, 27 Nov 2014 19:42:25 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc4 v10 4/6] irqchip: gic: Introduce plumbing for
 IPI FIQ
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417019010-9220-1-git-send-email-daniel.thompson@linaro.org> <1417019010-9220-5-git-send-email-daniel.thompson@linaro.org> <20141126174204.GK22670@titan.lakedaemon.net> <54772975.9090908@linaro.org> <20141127180633.GM22670@titan.lakedaemon.net>
In-Reply-To: <20141127180633.GM22670@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 18:06, Jason Cooper wrote:
> Daniel,
> 
> On Thu, Nov 27, 2014 at 01:39:01PM +0000, Daniel Thompson wrote:
>> On 26/11/14 17:42, Jason Cooper wrote:
>>> On Wed, Nov 26, 2014 at 04:23:28PM +0000, Daniel Thompson wrote:
>>>> Currently it is not possible to exploit FIQ for systems with a GIC, even if
>>>> the systems are otherwise capable of it. This patch makes it possible
>>>> for IPIs to be delivered using FIQ.
>>>>
>>>> To do so it modifies the register state so that normal interrupts are
>>>> placed in group 1 and specific IPIs are placed into group 0. It also
>>>> configures the controller to raise group 0 interrupts using the FIQ
>>>> signal. It provides a means for architecture code to define which IPIs
>>>> shall use FIQ and to acknowledge any IPIs that are raised.
>>>>
>>>> All GIC hardware except GICv1-without-TrustZone support provides a means
>>>> to group exceptions into group 0 and group 1 but the hardware
>>>> functionality is unavailable to the kernel when a secure monitor is
>>>> present because access to the grouping registers are prohibited outside
>>>> "secure world". However when grouping is not available (or in the case
>>>> of early GICv1 implementations is very hard to configure) the code to
>>>> change groups does not deploy and all IPIs will be raised via IRQ.
>>>>
>>>> It has been tested and shown working on two systems capable of
>>>> supporting grouping (Freescale i.MX6 and STiH416). It has also been
>>>> tested for boot regressions on two systems that do not support grouping
>>>> (vexpress-a9 and Qualcomm Snapdragon 600).
>>>>
>>>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Tested-by: Jon Medhurst <tixy@linaro.org>
>>>> ---
>>>>  arch/arm/kernel/traps.c         |   5 +-
>>>>  drivers/irqchip/irq-gic.c       | 155 +++++++++++++++++++++++++++++++++++++---
>>>>  include/linux/irqchip/arm-gic.h |   8 +++
>>>>  3 files changed, 158 insertions(+), 10 deletions(-)
>>> ...
>>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>>> index 5d72823bc5e9..978e5e48d5c1 100644
>>>> --- a/drivers/irqchip/irq-gic.c
>>>> +++ b/drivers/irqchip/irq-gic.c
>>> ...
>>>> +/*
>>>> + * Test which group an interrupt belongs to.
>>>> + *
>>>> + * Returns 0 if the controller does not support grouping.
>>>> + */
>>>> +static int gic_get_group_irq(void __iomem *base, unsigned int hwirq)
>>>> +{
>>>> +	unsigned int grp_reg = hwirq / 32 * 4;
>>>> +	u32 grp_val;
>>>> +
>>>> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
>>>> +
>>>> +	return (grp_val >> (hwirq % 32)) & 1;
>>>> +}
>>> ...
>>>> @@ -669,7 +802,11 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>>>  	dmb(ishst);
>>>>  
>>>>  	/* this always happens on GIC0 */
>>>> -	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>>>> +	softint = map << 16 | irq;
>>>> +	if (gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
>>>> +		softint |= 0x8000;
>>>> +	writel_relaxed(softint,
>>>> +		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>>>>  
>>>>  	bl_migration_unlock();
>>>>  }
>>>
>>> Is it worth the code complication to optimize this if the controller
>>> doesn't support grouping?  Maybe set group_enabled at init so the above
>>> would become:
>>>
>>> 	softint = map << 16 | irq;
>>> 	if (group_enabled &&
>>> 	    gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
>>> 		softint |= 0x8000;
>>> 	writel_relaxed(...);
>>
>> No objections.
>>
>> However given this code always calls gic_get_group_irq() with irq < 16
>> we might be able to do better even than this. The lower 16-bits of
>> IGROUP[0] are constant after boot so if we keep a shadow copy around
>> instead of just a boolean then we can avoid the register read on all
>> code paths.
> 
> Hmm, I'd look at that as a performance enhancement.  I'm more concerned
> about performance regressions for current users of the gic (non-group
> enabled).

"Current users of the gic" doesn't imply "non-group enabled". Whether or
not grouping is enabled is a property of the hardware or (secure)
bootloader.

If we are seriously worried about a performance regression here we
actually have to care about both cases.


> Let's go ahead and do the change (well, a working facsimile) I suggested
> above, and we can do a follow on patch to increase performance for the
> group enabled use case.

Hmnnn...

I've have a new patch ready to go that shadows the IGROUP[0]. Its looks
OK to me and I think it is actually fewer lines of code than v10 because
we can remove gic_get_group_irq() completely.

The code in question ends up looking like:

 	softint = map << 16 | irq;
 	if (gic->igroup0_shadow & BIT(irq))
 		softint |= 0x8000;
 	writel_relaxed(...);

This should end up with the same (data) cache profile as your proposal
in the non-group case and should normally be a win for the grouped case.
I even remembered an informative comment to make clear the use of
shadowing is as an optimization and nothing to do with working around
stupid hardware ;-).

I hope you don't mind but I'm about to share a patchset based on the
above so you can see it in full and decide if you like it. I don't
object to adding an extra boolean (and will do that if you don't like
the above) but I think this code is better.


> If there's no objections, I'd like to try to get this in for v3.19, but
> it's really late.  So we'll see how it goes.

I like that too. I also agree its pretty late and that's one of the
reasons why I'm turning round new patchsets for each bit of feedback.


Daniel.

