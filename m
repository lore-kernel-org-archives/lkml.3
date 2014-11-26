Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKZRme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:42:34 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27909 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaKZRmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:42:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19SzLx4MZwuNOB8ekQVmk7BZjty31CbhFk=
X-DKIM: OpenDKIM Filter v2.0.1 titan B3E27624A22
Date: Wed, 26 Nov 2014 12:42:04 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20141126174204.GK22670@titan.lakedaemon.net>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417019010-9220-1-git-send-email-daniel.thompson@linaro.org>
 <1417019010-9220-5-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417019010-9220-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

I've been a bit swamped this cycle and haven't kept as close an eye on
this as I should have. :(  fwiw, it's looking really good.  I have one
question below:

On Wed, Nov 26, 2014 at 04:23:28PM +0000, Daniel Thompson wrote:
> Currently it is not possible to exploit FIQ for systems with a GIC, even if
> the systems are otherwise capable of it. This patch makes it possible
> for IPIs to be delivered using FIQ.
> 
> To do so it modifies the register state so that normal interrupts are
> placed in group 1 and specific IPIs are placed into group 0. It also
> configures the controller to raise group 0 interrupts using the FIQ
> signal. It provides a means for architecture code to define which IPIs
> shall use FIQ and to acknowledge any IPIs that are raised.
> 
> All GIC hardware except GICv1-without-TrustZone support provides a means
> to group exceptions into group 0 and group 1 but the hardware
> functionality is unavailable to the kernel when a secure monitor is
> present because access to the grouping registers are prohibited outside
> "secure world". However when grouping is not available (or in the case
> of early GICv1 implementations is very hard to configure) the code to
> change groups does not deploy and all IPIs will be raised via IRQ.
> 
> It has been tested and shown working on two systems capable of
> supporting grouping (Freescale i.MX6 and STiH416). It has also been
> tested for boot regressions on two systems that do not support grouping
> (vexpress-a9 and Qualcomm Snapdragon 600).
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Jon Medhurst <tixy@linaro.org>
> ---
>  arch/arm/kernel/traps.c         |   5 +-
>  drivers/irqchip/irq-gic.c       | 155 +++++++++++++++++++++++++++++++++++++---
>  include/linux/irqchip/arm-gic.h |   8 +++
>  3 files changed, 158 insertions(+), 10 deletions(-)
...
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 5d72823bc5e9..978e5e48d5c1 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
...
> +/*
> + * Test which group an interrupt belongs to.
> + *
> + * Returns 0 if the controller does not support grouping.
> + */
> +static int gic_get_group_irq(void __iomem *base, unsigned int hwirq)
> +{
> +	unsigned int grp_reg = hwirq / 32 * 4;
> +	u32 grp_val;
> +
> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
> +
> +	return (grp_val >> (hwirq % 32)) & 1;
> +}
...
> @@ -669,7 +802,11 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	dmb(ishst);
>  
>  	/* this always happens on GIC0 */
> -	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
> +	softint = map << 16 | irq;
> +	if (gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
> +		softint |= 0x8000;
> +	writel_relaxed(softint,
> +		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>  
>  	bl_migration_unlock();
>  }

Is it worth the code complication to optimize this if the controller
doesn't support grouping?  Maybe set group_enabled at init so the above
would become:

	softint = map << 16 | irq;
	if (group_enabled &&
	    gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
		softint |= 0x8000;
	writel_relaxed(...);

thx,

Jason.
