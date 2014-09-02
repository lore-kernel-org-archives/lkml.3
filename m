Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaIBTeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:34:17 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40917 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754581AbaIBTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:34:16 -0400
Date: Tue, 2 Sep 2014 20:33:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v11 06/19] irqchip: gic: Provide support for interrupt
	grouping
Message-ID: <20140902193355.GW30401@n2100.arm.linux.org.uk>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-7-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409662853-29313-7-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:00:40PM +0100, Daniel Thompson wrote:
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4b959e6..423707c 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -41,6 +41,9 @@
>  #include <linux/irqchip/arm-gic.h>
>  
>  #include <asm/cputype.h>
> +#ifdef CONFIG_FIQ
> +#include <asm/fiq.h>
> +#endif

Is there much advantage to this ifdef over providing a dummy asm/fiq.h
in ARM64?

>  #include <asm/irq.h>
>  #include <asm/exception.h>
>  #include <asm/smp_plat.h>
> @@ -68,6 +71,9 @@ struct gic_chip_data {
>  #ifdef CONFIG_GIC_NON_BANKED
>  	void __iomem *(*get_base)(union gic_base *);
>  #endif
> +#ifdef CONFIG_FIQ
> +	bool fiq_enable;
> +#endif
>  };
>  
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> @@ -131,6 +137,16 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
>  #define gic_set_base_accessor(d, f)
>  #endif
>  
> +#ifdef CONFIG_FIQ
> +static inline bool gic_data_fiq_enable(struct gic_chip_data *data)
> +{
> +	return data->fiq_enable;
> +}
> +#else
> +static inline bool gic_data_fiq_enable(
> +		struct gic_chip_data *data) { return false; }

I really hate this style.  Just lay it out as a normal function.

> +	/*
> +	 * If grouping is not available (not implemented or prohibited by
> +	 * security mode) these registers a read-as-zero/write-ignored.
> +	 * However as a precaution we restore the reset default regardless of
> +	 * the result of the test.
> +	 */

Have we found that this additional complexity is actually necessary?
If not, we're over-engineering the code, making it more complex (and
hence more likely to be buggy) for very little reason.

Last night, I booted an unconditional version of this on OMAP3430, and
OMAP4430.  It's also been booted on the range of iMX6 CPUs.  Nothing
here has shown any signs of problems to having these registers written.

> +	/*
> +	 * Set EnableGrp1/EnableGrp0 (bit 1 and 0) or EnableGrp (bit 0 only,
> +	 * bit 1 ignored)
> +	 */
> +	if (gic_data_fiq_enable(gic))
> +		writel_relaxed(3, base + GIC_DIST_CTRL);
> +	else
> +		writel_relaxed(1, base + GIC_DIST_CTRL);

If we are going to do this conditionally, and the only thing which
is variable is the value to be written, I much prefer the conditional
bit to be on the value and not the write.  The compiler doesn't always
optimise these things very well.  So:

	writel_relaxed(gic_data_fiq_enable(gic) ? 3 : 1, base + GIC_DIST_CTRL);

works well enough for me.  If you feel better by using a temporary
local, that works for me too.

> +	if (gic_data_fiq_enable(gic))
> +		writel_relaxed(0x1f, base + GIC_CPU_CTRL);
> +	else
> +		writel_relaxed(1, base + GIC_CPU_CTRL);

Same here.

> @@ -485,7 +564,10 @@ static void gic_dist_restore(unsigned int gic_nr)
>  		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
>  			dist_base + GIC_DIST_ENABLE_SET + i * 4);
>  
> -	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
> +	if (gic_data_fiq_enable(&gic_data[gic_nr]))
> +		writel_relaxed(3, dist_base + GIC_DIST_CTRL);
> +	else
> +		writel_relaxed(1, dist_base + GIC_DIST_CTRL);

And here.

> @@ -542,7 +624,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	writel_relaxed(0x1f, cpu_base + GIC_CPU_CTRL);

Interestingly, here you write 0x1f unconditionally.
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
> @@ -604,6 +686,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  {
>  	int cpu;
>  	unsigned long flags, map = 0;
> +	unsigned long softint;
>  
>  	raw_spin_lock_irqsave(&irq_controller_lock, flags);
>  
> @@ -618,7 +701,11 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	dmb(ishst);
>  
>  	/* this always happens on GIC0 */
> -	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
> +	softint = map << 16 | irq;
> +	if (gic_data_fiq_enable(&gic_data[0]))
> +		softint |= 0x8000;

I guess that this always has to be done conditionally.  I'd prefer this
test to be done slightly differently (and we might as well wrap in a bit
of patch 9 here):

	if (sgi_is_nonsecure(irq, &gic_data[0]))
		softint |= 0x8000;

which follows the true purpose of that bit.  This bit only has effect if
we are running in secure mode, where it must match the status of the
target interrupt (as programmed into GIC_DIST_IGROUP).

We probably should do this based on a bitmask of SGIs in the
gic_chip_data, which is initialised according to how we've been able
to setup the GIC_DIST_IGROUP register(s).

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
