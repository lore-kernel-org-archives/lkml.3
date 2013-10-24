Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3JXJUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:20:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:34631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3JXJUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:20:15 -0400
Date: Thu, 24 Oct 2013 11:20:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sricharan R <r.sricharan@ti.com>
cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, linux@arm.linux.org.uk, tony@atomide.com,
        rnayak@ti.com, marc.zyngier@arm.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, mark.rutland@arm.com
Subject: Re: [RFC PATCH 2/6] DRIVERS: IRQCHIP: CROSSBAR: Add support for
 Crossbar IP
In-Reply-To: <1380549564-31045-3-git-send-email-r.sricharan@ti.com>
Message-ID: <alpine.DEB.2.02.1310241112310.4983@ionos.tec.linutronix.de>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-3-git-send-email-r.sricharan@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Sricharan R wrote:
> +/*
> + * @int_max: maximum number of supported interrupts
> + * @irq_map: array of interrupts to crossbar number mapping
> + * @crossbar_base: crossbar base address
> + * @register_offsets: offsets for each irq number
> + */
> +struct crossbar_device {
> +	uint int_max;
> +	uint *irq_map;

Why do you need another map here?

Isn't the linear_revmap of the irqdomain sufficient?

> +static inline const u32 allocate_free_irq(int cb_no)
> +{
> +	int i;
> +
> +	for (i = 0; i < cb->int_max; i++) {
> +		if (cb->irq_map[i] == IRQ_FREE) {
> +			cb->irq_map[i] = cb_no;
> +			return i;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +static int crossbar_domain_xlate(struct irq_domain *d,
> +				 struct device_node *controller,
> +				 const u32 *intspec, unsigned int intsize,
> +				 unsigned long *out_hwirq,
> +				 unsigned int *out_type)
> +{
> +	return allocate_free_irq(intspec[1]) + GIC_IRQ_START;

Mooo. In the error case you return:

      -ENODEV + GIC_IRQ_START == -19 + 32 == 13

Yikes.

> +
> +	/*
> +	 * Register offsets are not linear because of the
> +	 * reserved irqs. so find and store the offsets once.
> +	 */
> +	for (i = 0; i < max; i++) {
> +		if (!cb->irq_map[i])
> +			continue;
> +
> +		cb->register_offsets[i] = reserved;
> +		reserved += size;

I'm amazed by such a brilliant hardware design.

Thanks,

	tglx
