Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbbATJcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:32:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:47211 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbATJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:32:09 -0500
Date: Tue, 20 Jan 2015 10:31:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Marc Zyngier <marc.zyngier@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposal about reorganize struct irq_data and struct irq_desc
In-Reply-To: <54BD1256.1020406@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501200950370.5526@nanos>
References: <54BD1256.1020406@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Jiang Liu wrote:

> Hi Thomas and Marc,
> 	During working on the generic MSI support, I have some proposal
> about reorganizing struct irq_data and struct irq_desc. The proposed
> changes are:
> 1) Add a pointer "struct irq_desc *" to struct irq_data, so we could
>    quickly get struct irq_desc from struct irq_data.
> 2) Move "node" from struct irq_data into struct irq_desc, NUMA info
>    should be per-irq instead of per-chip.
> 3) Move "affinity" from struct irq_data into struct irq_desc, NUMA info
>    should be per-irq instead of per-chip.
> 4) Move "msi_desc" from struct irq_data into struct irq_desc. (Not sure
>    whether we should do this. Theoretically we should use
>    irq_data->handler_data to store msi_desc.)

msi_desc belongs to the msi chip, while handler_data is common data.

I had a look at the usage sites of handler_data. Most of them use it
in combination with chained handlers. Some sites use it instead of
chip data and only a few use it for some random other stuff, where the
x86 sites (hpet, ht, iommu ...) will go away with the irqdomain
conversion.

So in the long run we should provide:

   irq_set_chained_handler_and_data(irq, handler, handler_data)

convert everything over and finally remove the direct accessor to
handler_data.

msi_desc in a hierarchical implementation should actually be in
chip_data, but we probably need to keep the msi_desc pointer for
backward compability reasons.

> With above change applied, struct irq_data only hosts per-chip data, and
> struct irq_desc hosts per-irq data. What's your thoughts?

I'm not so happy with exposing irqdesc to random code again. I went a
great way to hide it from abuse.

So I'd rather like to see something like this:

struct irq_common_data {
	unsigned int		state_use_accessors;
	unsigned int		node;
	void			*handler_data;
	cpumask_var_t		affinity;
};

struct irq_data {
	u32			mask;
	unsigned int		irq;
	unsigned long		hwirq;
	struct irq_chip		*chip;
	struct irq_domain	*domain;
#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
	struct irq_data		*parent_data;
#endif
	void			*chip_data;
	struct msi_desc		*msi_desc;
	struct irq_common_data	*common_data;
};

struct irq_desc {
       struct irq_data		irq_data;
       struct common_irq_data	common_data;
       ...
};

Thanks,

	tglx
