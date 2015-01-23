Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbbAWPzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:55:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:37321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbAWPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:55:37 -0500
Date: Fri, 23 Jan 2015 16:55:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] genirq: Allow irq_desc to carry the union of
 stacked irq_chip flags
In-Reply-To: <1421246717-11640-3-git-send-email-marc.zyngier@arm.com>
Message-ID: <alpine.DEB.2.11.1501231648110.5526@nanos>
References: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com> <1421246717-11640-3-git-send-email-marc.zyngier@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Marc Zyngier wrote:

> The current infrastructure for stacked domains doesn't propagate
> irq_chip flags, and as we only look at the top-level irq_chip,
> we may miss a number of critical flags.
> 
> This patch accumulates the flags into a new set, stored at the
> irq_desc level, with an additional flag to indicate that this is
> a stack of irqchip. The accessor is updated to return the right one.

>  static inline unsigned long irq_desc_get_chip_flags(struct irq_desc *desc)
>  {
> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
> +	if (desc->chip_flags & IRQCHIP_STACKED_CHIPS)
> +		return desc->chip_flags;
> +#endif
>  	return desc->irq_data.chip->flags;

We can avoid the extra conditional if we just make the accumulated
flags unconditional and collect them even for the !hierarchy case.

Also this patch is missing that chips can be swapped at runtime either
via the normal interfaces or via __irq_set_chip_handler_name_locked().

This needs to be addressed otherwise we might end up looking at the
wrong flags.

Thanks,

	tglx
