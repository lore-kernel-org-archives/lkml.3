Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaKZPs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:48:58 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42009 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaKZPs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:48:57 -0500
Message-ID: <5475F65F.4030905@linaro.org>
Date: Wed, 26 Nov 2014 15:48:47 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Sander <tim@krieglstein.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3.18-rc3 v9 3/5] irqchip: gic: Introduce plumbing for
 IPI FIQ
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-4-git-send-email-daniel.thompson@linaro.org> <1678979.dHizJmHVtD@dabox>
In-Reply-To: <1678979.dHizJmHVtD@dabox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 15:09, Tim Sander wrote:
> I would be quite happy if grouping support for gic would be mainlined.
> Then only the dance to get the old gic version 1 working with fiqs would be 
> needed...

You mention "the dance"...

Are you familiar with this work from Marek Vasut?
  https://lkml.org/lkml/2014/7/15/550

Marek blushed a bit when it was written and it wasn't very popular in
code review... however it does arranges memory to mapped in a manner
that allows FIQ to be deployed by the kernel on early gic v1 devices.


>> +/*
>> + * Shift an interrupt between Group 0 and Group 1.
>> + *
>> + * In addition to changing the group we also modify the priority to
>> + * match what "ARM strongly recommends" for a system where no Group 1
>> + * interrupt must ever preempt a Group 0 interrupt.
>> + *
>> + * If is safe to call this function on systems which do not support
>> + * grouping (it will have no effect).
>> + */
>> +static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
>> +				int group)
>> +{
>> +	unsigned int grp_reg = hwirq / 32 * 4;
>> +	u32 grp_mask = BIT(hwirq % 32);
>> +	u32 grp_val;
>> +
>> +	unsigned int pri_reg = (hwirq / 4) * 4;
>> +	u32 pri_mask = BIT(7 + ((hwirq % 4) * 8));
>> +	u32 pri_val;
>> +
>> +	/*
>> +	 * Systems which do not support grouping will have not have
>> +	 * the EnableGrp1 bit set.
>> +	 */
>> +	if (!(GICD_ENABLE_GRP1 & readl_relaxed(base + GIC_DIST_CTRL)))
>> +		return;
>> +
>> +	raw_spin_lock(&irq_controller_lock);
>> +
> Assumption: The interrupt in question is not masked over here?

At present this function is called only during initialization and all
interrupts are globally disabled at that stage in the boot.


>> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
>> +	pri_val = readl_relaxed(base + GIC_DIST_PRI + pri_reg);
>> +
>> +	if (group) {
>> +		grp_val |= grp_mask;
>> +		pri_val |= pri_mask;
>> +	} else {
>> +		grp_val &= ~grp_mask;
>> +		pri_val &= ~pri_mask;
>> +	}
>> +
>> +	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
> If the assumption is true, then there is a race if the interrupt in question 
> hits here with undefined priority setting. Recomended workaround would be
> masking the interrupt in question.

An interesting question!

Firstly, as mentioned above, such a race is impossible with the code
proposed so far.

I do have some code sitting written by untested that makes it possible
to set the group based on a flag passed during request_irq() (something
requested by tglx in a review from a month or two back). That also means
the interrupt is disabled during the call.

I think that means that neither now nor in the immediate future would
such a race be possible.


Daniel.
