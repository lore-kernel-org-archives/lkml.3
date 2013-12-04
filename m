Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3LDWqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:46:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:39539 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3LDWqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:46:46 -0500
Date: Wed, 4 Dec 2013 23:46:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Neil Zhang <zhangwm@marvell.com>
cc: mark.rutland@arm.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3] irqchip: mmp: add dt support for wakeup
In-Reply-To: <1386159214-31483-1-git-send-email-zhangwm@marvell.com>
Message-ID: <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Neil Zhang wrote:

> Some of the Marvell SoCs use GIC as its interrupt controller,and ICU
> only used as wakeup logic. When AP subsystem is powered off, GIC will
> lose its context, the PMU will need ICU to wakeup the AP subsystem.
> So add wakeup entry for such kind of usage.

This changelog is useless.

What the heck means: "So add wakeup entry for such kind of usage" ?

To me nothing, and I'm quite familiar with this kinds of problems. So
please explain how someone less familiar with that can decode this?

> @@ -58,6 +60,8 @@ struct mmp_intc_conf {
>  static void __iomem *mmp_icu_base;
>  static struct icu_chip_data icu_data[MAX_ICU_NR];
>  static int max_icu_nr;
> +static u32 irq_for_cp[64];

64 is a magic number pulled out of thin air, right?

> +static u32 irq_for_cp_nr;	/* How many irqs will be routed to cp */

What kind of magic nonsense is that?
  
>  extern void mmp2_clear_pmic_int(void);
>  
> @@ -123,6 +127,50 @@ static void icu_unmask_irq(struct irq_data *d)
>  	}
>  }
>  
> +static int irq_ignore_wakeup(struct icu_chip_data *data, int hwirq)
> +{
> +	int i;
> +
> +	if (hwirq < 0 || hwirq >= data->nr_irqs)
> +		return 1;
> +
> +	for (i = 0; i < irq_for_cp_nr; i++)
> +		if (irq_for_cp[i] == hwirq)
> +			return 1;
> +
> +	return 0;
> +}

Oh, I see. A brilliant workaround for something which is missing at
the caller level.

Why the heck do you add a totally braindead function to your driver,
if you can avoid the call to icu_[un]mask_wakeup() in the first place?

Why on earth is something calling this function, if it's a not
supported property of that particular interrupt line?

  Simply because the call site does not have an indicator to avoid
  that call in the first place.

So why are you not adding a proper mechanism to the caller level to
avoid the call? This problem is not unique to magic marvell chips.

And going through a loop over and over again is very efficient in
terms of code size, cache footprint and power consumption, right?

> +static void icu_mask_irq_wakeup(struct irq_data *d)
> +{
> +	struct icu_chip_data *data = &icu_data[0];
> +	int hwirq = d->hwirq - data->virq_base;
> +	u32 r;
> +
> +	if (irq_ignore_wakeup(data, hwirq))
> +		return;

And you call that loop for every invocation of icu_[un]mask_wakeup().

Intelligent design, right?

Now lets have a look at how this magic loop data is set up:

> +void __init mmp_of_wakeup_init(void)
> +{
	....

> +	/* Get the irq lines for cp */
> +	i = 0;
> +	while (!of_property_read_u32_index(node, "mrvl,intc-for-cp", i, &irq_for_cp[i])) {
> +		writel_relaxed(ICU_CONF_SEAGULL, mmp_icu_base + (irq_for_cp[i] << 2));
> +		i++;
> +	}
> +	irq_for_cp_nr = i;

Amazing.

I can understand the part where you setup the mmp_icu registers for
this.

But recording that information in your own magic array is beyond my
comprehension.

Now lets look at why you are doing this at all.

> +	gic_arch_extn.irq_mask = icu_mask_irq_wakeup;
> +	gic_arch_extn.irq_unmask = icu_unmask_irq_wakeup;

Neil, please do not misunderstand me. You are not responsible for the
gic_arch_extn implementation, but you should have noticed that this
gic_arch_extn thing is ass backwards to begin with.

I'm going to reply in a separate mail on this, because you have
brought this to my attention, but you are not responsible in the first
place for this brainfart.

Thanks,

	tglx
