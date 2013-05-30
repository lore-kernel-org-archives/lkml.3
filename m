Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3E3V34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:29:56 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53717 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3E3V3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:29:49 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCHv4 6/6] irqchip: TI-Nspire irqchip support
To: Daniel Tang <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1369480087-24786-7-git-send-email-dt.tangr@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <1369480087-24786-7-git-send-email-dt.tangr@gmail.com>
Date: Thu, 30 May 2013 22:29:45 +0100
Message-Id: <20130530212945.C026C3E0A90@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 May 2013 21:08:07 +1000, Daniel Tang <dt.tangr@gmail.com> wrote:
> Add support for the interrupt controller on TI-Nspires.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
[...]
> +static void nspire_irq_ack(struct irq_data *irqd)
> +{
> +	void __iomem *base = irq_io_base;
> +
> +	if (irqd->hwirq < FIQ_START)
> +		base += IO_IRQ_BASE;
> +	else
> +		base += IO_FIQ_BASE;
> +
> +	readl(base + IO_RESET);
> +}
> +
> +static void nspire_irq_unmask(struct irq_data *irqd)
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
> +}
> +
> +static void nspire_irq_mask(struct irq_data *irqd)
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
> +}
> +
> +static struct irq_chip nspire_irq_chip = {
> +	.name		= "nspire_irq",
> +	.irq_ack	= nspire_irq_ack,
> +	.irq_mask	= nspire_irq_mask,
> +	.irq_unmask	= nspire_irq_unmask,
> +};

Should be using irq_generic_chip here. There is no need to reimplement
the above ack, mask and unmask functions. You should find the
irq_alloc_domain_generic_chips() patch in the tip tree irq/for-arm
branch. That branch is staged for merging in v3.11

Otherwise the patch looks good.

g.

