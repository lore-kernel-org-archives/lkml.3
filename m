Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaKZQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:58:24 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:52768
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbaKZQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:58:22 -0500
From: Tim Sander <tim@krieglstein.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3.18-rc3 v9 3/5] irqchip: gic: Introduce plumbing for IPI FIQ
Date: Wed, 26 Nov 2014 17:58:19 +0100
Message-ID: <1494053.N1Xc171oq1@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5475F65F.4030905@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1678979.dHizJmHVtD@dabox> <5475F65F.4030905@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. November 2014, 15:48:47 schrieb Daniel Thompson:
> On 26/11/14 15:09, Tim Sander wrote:
> > I would be quite happy if grouping support for gic would be mainlined.
> > Then only the dance to get the old gic version 1 working with fiqs would
> > be
> > needed...
> 
> You mention "the dance"...
> 
> Are you familiar with this work from Marek Vasut?
>   https://lkml.org/lkml/2014/7/15/550
The world is a small place isn't it. Unfortunatly yes.. and that is not 
because Marek is a not a nice guy (quite in contrary) but the way it solves 
the problem we had with the GIC in the socfpga. There should have been some 
pins from the FPGA fabric to the "legacy" FIQ interrupt "pins" of the core. 
Unfortunatly these where forgotten...

Marek had also an aproach similar to yours checking if the irq is wrongly 
signalled. In our workload the performance was much to worse to consider it a 
solution (which is contrary to Harro Haan's findings but we have a magnitude 
higher FIQ load). So he got a hint from a french guy (forgot the name) who had 
the idea to use a non-secure mapping to read the irq id as fiq id's must not be 
read in non-secure reads.

This leads to the question i was also asking Marc Zyngier at LinuxCon: if this 
aproach is mainlinable in any way.

And just to get the message out there, espcially to ARM: yes there are users 
of FIQ interrupts which wan't to use Linux in combination with FIQ's and who 
don't wan't to resort to Cortex R cores without a MMU. And seeing that ARM is 
deprecating the use of FIQ on ARM64 i wonder how a solution to have IRQ's not
masked by Linux looks in this for upcoming processor generations.
 
> Marek blushed a bit when it was written and it wasn't very popular in
> code review... however it does arranges memory to mapped in a manner
> that allows FIQ to be deployed by the kernel on early gic v1 devices.
In a way i made him indirectly do it by asking the right questions to the 
silicon vendor.

> >> +/*
> >> + * Shift an interrupt between Group 0 and Group 1.
> >> + *
> >> + * In addition to changing the group we also modify the priority to
> >> + * match what "ARM strongly recommends" for a system where no Group 1
> >> + * interrupt must ever preempt a Group 0 interrupt.
> >> + *
> >> + * If is safe to call this function on systems which do not support
> >> + * grouping (it will have no effect).
> >> + */
> >> +static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
> >> +				int group)
> >> +{
> >> +	unsigned int grp_reg = hwirq / 32 * 4;
> >> +	u32 grp_mask = BIT(hwirq % 32);
> >> +	u32 grp_val;
> >> +
> >> +	unsigned int pri_reg = (hwirq / 4) * 4;
> >> +	u32 pri_mask = BIT(7 + ((hwirq % 4) * 8));
> >> +	u32 pri_val;
> >> +
> >> +	/*
> >> +	 * Systems which do not support grouping will have not have
> >> +	 * the EnableGrp1 bit set.
> >> +	 */
> >> +	if (!(GICD_ENABLE_GRP1 & readl_relaxed(base + GIC_DIST_CTRL)))
> >> +		return;
> >> +
> >> +	raw_spin_lock(&irq_controller_lock);
> >> +
> > 
> > Assumption: The interrupt in question is not masked over here?
> 
> At present this function is called only during initialization and all
> interrupts are globally disabled at that stage in the boot.
> 
> >> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
> >> +	pri_val = readl_relaxed(base + GIC_DIST_PRI + pri_reg);
> >> +
> >> +	if (group) {
> >> +		grp_val |= grp_mask;
> >> +		pri_val |= pri_mask;
> >> +	} else {
> >> +		grp_val &= ~grp_mask;
> >> +		pri_val &= ~pri_mask;
> >> +	}
> >> +
> >> +	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
> > 
> > If the assumption is true, then there is a race if the interrupt in
> > question hits here with undefined priority setting. Recomended workaround
> > would be masking the interrupt in question.
> 
> An interesting question!
> 
> Firstly, as mentioned above, such a race is impossible with the code
> proposed so far.
> 
> I do have some code sitting written by untested that makes it possible
> to set the group based on a flag passed during request_irq() (something
> requested by tglx in a review from a month or two back). That also means
> the interrupt is disabled during the call.
> 
> I think that means that neither now nor in the immediate future would
> such a race be possible.
> 
> 
> Daniel.

