Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab3E3Oxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:53:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:33806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab3E3Oxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:53:34 -0400
Date: Thu, 30 May 2013 16:53:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Tang <dt.tangr@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add TI-Nspire irqchip support
In-Reply-To: <89D06030-E27E-445D-BBB8-45A47CA6C892@gmail.com>
Message-ID: <alpine.LFD.2.02.1305301639560.2905@ionos>
References: <89D06030-E27E-445D-BBB8-45A47CA6C892@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Daniel Tang wrote:
 
> Hi,
> 
> This patch adds a driver for the interrupt controller found in the TI-Nspire calculator series.
> 
> Cheers,
> Daniel Tang

This is NOT a proper changelog.
 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

Also please read through this mail thread:

     https://lkml.org/lkml/2013/5/2/406

and rework your patches against:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core

> +static void __iomem *irq_io_base;
> +static struct irq_domain *zevio_irq_domain;
> +
> +static void zevio_irq_ack(struct irq_data *irqd)
> +{
> +	void __iomem *base = irq_io_base;
> +
> +	if (irqd->hwirq < FIQ_START)
> +		base += IO_IRQ_BASE;
> +	else
> +		base += IO_FIQ_BASE;

This is horrible. If you redo this against the generic irq chip then
provide a separate base with the proper offsets to each chip. So you
can avoid this clumsy conditionals completely.

> +	readl(base + IO_RESET);
> +}
> +
> +static void zevio_irq_unmask(struct irq_data *irqd)
> +{
> +	void __iomem *base = irq_io_base;
> +	int irqnr = irqd->hwirq;
> +
> +	if (irqnr < FIQ_START) {
> +		base += IO_IRQ_BASE;
> +	} else {
> +		irqnr -= MAX_INTRS;
> +		base += IO_FIQ_BASE;
> +	}
> +
> +	writel((1<<irqnr), base + IO_ENABLE);

Replace with the generic function

> +}
> +
> +static void zevio_irq_mask(struct irq_data *irqd)
> +{
> +	void __iomem *base = irq_io_base;
> +	int irqnr = irqd->hwirq;
> +
> +	if (irqnr < FIQ_START) {
> +		base += IO_IRQ_BASE;
> +	} else {
> +		irqnr -= FIQ_START;
> +		base += IO_FIQ_BASE;
> +	}
> +
> +	writel((1<<irqnr), base + IO_DISABLE);

Replace with the generic function

> +static int process_base(void __iomem *base, struct pt_regs *regs)
> +{
> +	int irqnr;
> +
> +
> +	if (!readl(base + IO_STATUS))
> +		return 0;
> +
> +	irqnr = readl(base + IO_CURRENT);
> +	irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
> +	handle_IRQ(irqnr, regs);
> +
> +	return 1;
> +}
> +
> +asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
> +{
> +	while (process_base(irq_io_base + IO_FIQ_BASE, regs))
> +		;

Wheee. That's ugly as hell. Why don't you move the while loop into process_base() ?

Thanks,

	tglx
