Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3EaMG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:06:56 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64323 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3EaMGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:06:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] Add TI-Nspire irqchip support
To: Thomas Gleixner <tglx@linutronix.de>, Daniel Tang <dt.tangr@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1305301639560.2905@ionos>
References: <89D06030-E27E-445D-BBB8-45A47CA6C892@gmail.com> <alpine.LFD.2.02.1305301639560.2905@ionos>
Date: Fri, 31 May 2013 13:06:47 +0100
Message-Id: <20130531120647.149FF3E0901@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 16:53:31 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 30 May 2013, Daniel Tang wrote:
>  
> > Hi,
> > 
> > This patch adds a driver for the interrupt controller found in the TI-Nspire calculator series.
> > 
> > Cheers,
> > Daniel Tang
> 
> This is NOT a proper changelog.

Hi Daniel,

What is the SoC used in the Nspire? Is it something custom for the
calculator, or does it use an existing SoC? I'm just surprised that this
device needs a new interrupt controller driver rather than one of the
drivers that is already in the tree.

If it is a new device, then that is fine, but you should follow the
discussion that Thomas pointed you at below.

g.

>  
> > Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> 
> Also please read through this mail thread:
> 
>      https://lkml.org/lkml/2013/5/2/406
> 
> and rework your patches against:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
> 
> > +static void __iomem *irq_io_base;
> > +static struct irq_domain *zevio_irq_domain;
> > +
> > +static void zevio_irq_ack(struct irq_data *irqd)
> > +{
> > +	void __iomem *base = irq_io_base;
> > +
> > +	if (irqd->hwirq < FIQ_START)
> > +		base += IO_IRQ_BASE;
> > +	else
> > +		base += IO_FIQ_BASE;
> 
> This is horrible. If you redo this against the generic irq chip then
> provide a separate base with the proper offsets to each chip. So you
> can avoid this clumsy conditionals completely.
> 
> > +	readl(base + IO_RESET);
> > +}
> > +
> > +static void zevio_irq_unmask(struct irq_data *irqd)
> > +{
> > +	void __iomem *base = irq_io_base;
> > +	int irqnr = irqd->hwirq;
> > +
> > +	if (irqnr < FIQ_START) {
> > +		base += IO_IRQ_BASE;
> > +	} else {
> > +		irqnr -= MAX_INTRS;
> > +		base += IO_FIQ_BASE;
> > +	}
> > +
> > +	writel((1<<irqnr), base + IO_ENABLE);
> 
> Replace with the generic function
> 
> > +}
> > +
> > +static void zevio_irq_mask(struct irq_data *irqd)
> > +{
> > +	void __iomem *base = irq_io_base;
> > +	int irqnr = irqd->hwirq;
> > +
> > +	if (irqnr < FIQ_START) {
> > +		base += IO_IRQ_BASE;
> > +	} else {
> > +		irqnr -= FIQ_START;
> > +		base += IO_FIQ_BASE;
> > +	}
> > +
> > +	writel((1<<irqnr), base + IO_DISABLE);
> 
> Replace with the generic function
> 
> > +static int process_base(void __iomem *base, struct pt_regs *regs)
> > +{
> > +	int irqnr;
> > +
> > +
> > +	if (!readl(base + IO_STATUS))
> > +		return 0;
> > +
> > +	irqnr = readl(base + IO_CURRENT);
> > +	irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
> > +	handle_IRQ(irqnr, regs);
> > +
> > +	return 1;
> > +}
> > +
> > +asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
> > +{
> > +	while (process_base(irq_io_base + IO_FIQ_BASE, regs))
> > +		;
> 
> Wheee. That's ugly as hell. Why don't you move the while loop into process_base() ?
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
