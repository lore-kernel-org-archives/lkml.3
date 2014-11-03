Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaKCWvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:51:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:55842 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaKCWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:51:51 -0500
Date: Mon, 3 Nov 2014 23:51:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        jason@lakedaemon.net, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        liviu.dudau@arm.com, Harish.Kasiviswanathan@amd.com,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
In-Reply-To: <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com>
Message-ID: <alpine.DEB.2.11.1411032300160.5308@nanos>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, suravee.suthikulpanit@amd.com wrote:
> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +	int pos;
> +	struct v2m_data *v2m = container_of(chip, struct v2m_data, msi_chip);
> +
> +	spin_lock(&v2m->msi_cnt_lock);

Why do you need an extra lock here? Is that stuff not serialized from
the msi_chip layer already?

If not, why don't we have the serialization there instead of forcing
every callback to implement its own?

> +	pos = irq - v2m->spi_start;

So this assumes that @irq is the hwirq number, right? How does the
calling function know about that? It should only have knowledge about
the virq number if I'm not missing something.

And if I'm missing something, then that msi_chip stuff is seriously
broken.

> +	if (pos >= 0 && pos < v2m->nr_spis)

So you simply avoid the clear bitmap instead of yelling loudly about
being called with completely wrong data?

I would not be surprised if that is related to my question above.

> +		bitmap_clear(v2m->bm, pos, 1);

> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +				struct msi_desc *desc)
> +{
> +	int hwirq, virq, offset;
> +	struct v2m_data *v2m = container_of(chip, struct v2m_data, msi_chip);
> +
> +	if (!desc)
> +		return -EINVAL;

Why on earth does every callback of msi_chip have to check for this?

> +	spin_lock(&v2m->msi_cnt_lock);
> +	offset = bitmap_find_free_region(v2m->bm, v2m->nr_spis, 0);
> +	spin_unlock(&v2m->msi_cnt_lock);
> +	if (offset < 0)
> +		return offset;
> +
> +	hwirq = v2m->spi_start + offset;
> +	virq = __irq_domain_alloc_irqs(v2m->domain, hwirq,
> +				       1, NUMA_NO_NODE, v2m, true);
> +	if (virq < 0) {
> +		gicv2m_teardown_msi_irq(chip, hwirq);
> +		return virq;
> +	}
> +
> +	irq_domain_set_hwirq_and_chip(v2m->domain, virq, hwirq,
> +				&v2m_chip, v2m);
> +
> +	irq_set_msi_desc(hwirq, desc);
> +	irq_set_irq_type(hwirq, IRQ_TYPE_EDGE_RISING);

Sure both calls work perfectly fine as long as virq == hwirq, right?

> +	return 0;

Q: How does this populate virq to the caller? 
A: Not at all
Q: How does the caller know which virq this function assigned?
A: Not at all
Q: How does the device driver know which virq to request?
A: Not at all
Q: Was this patch ever properly tested?
A: Not at all.

I do not care at all how YOU waste your time. But I care very much
about the fact that YOU are wasting MY precious time by exposing me to
your patch trainwrecks. 

Thanks,

	tglx
