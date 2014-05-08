Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaEHMOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:14:55 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48609 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaEHMOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:14:54 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 29/32] genirq: Remove irq_reserve_irq[s]
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20140507154340.302183048@linutronix.de>
References: <20140507153622.703412101@linutronix.de>
	<20140507154340.302183048@linutronix.de>
Date: Thu, 08 May 2014 13:14:43 +0100
Message-Id: <20140508121443.4E71CC40D85@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014 15:44:21 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> No more users. And it's not going to come back. If you need
> hotplugable irq chips, use irq domains.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

The ironic thing is that irq_domain may end up bringing this function
back in some form as an optimization for irq_domains that need a
contiguous range, but don't want to allocate all the irq_descs
immediately. But if that happens it will be a very private API and it
doesn't nullify removing the function now.

g.

> ---
>  include/linux/irq.h  |    7 -------
>  kernel/irq/irqdesc.c |   25 -------------------------
>  2 files changed, 32 deletions(-)
> 
> Index: tip/include/linux/irq.h
> ===================================================================
> --- tip.orig/include/linux/irq.h
> +++ tip/include/linux/irq.h
> @@ -617,18 +617,11 @@ int __irq_alloc_descs(int irq, unsigned
>  	irq_alloc_descs(-1, from, cnt, node)
>  
>  void irq_free_descs(unsigned int irq, unsigned int cnt);
> -int irq_reserve_irqs(unsigned int from, unsigned int cnt);
> -
>  static inline void irq_free_desc(unsigned int irq)
>  {
>  	irq_free_descs(irq, 1);
>  }
>  
> -static inline int irq_reserve_irq(unsigned int irq)
> -{
> -	return irq_reserve_irqs(irq, 1);
> -}
> -
>  #ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
>  unsigned int irq_alloc_hwirqs(int cnt, int node);
>  static inline unsigned int irq_alloc_hwirq(int node)
> Index: tip/kernel/irq/irqdesc.c
> ===================================================================
> --- tip.orig/kernel/irq/irqdesc.c
> +++ tip/kernel/irq/irqdesc.c
> @@ -455,31 +455,6 @@ EXPORT_SYMBOL_GPL(irq_free_hwirqs);
>  #endif
>  
>  /**
> - * irq_reserve_irqs - mark irqs allocated
> - * @from:	mark from irq number
> - * @cnt:	number of irqs to mark
> - *
> - * Returns 0 on success or an appropriate error code
> - */
> -int irq_reserve_irqs(unsigned int from, unsigned int cnt)
> -{
> -	unsigned int start;
> -	int ret = 0;
> -
> -	if (!cnt || (from + cnt) > nr_irqs)
> -		return -EINVAL;
> -
> -	mutex_lock(&sparse_irq_lock);
> -	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
> -	if (start == from)
> -		bitmap_set(allocated_irqs, start, cnt);
> -	else
> -		ret = -EEXIST;
> -	mutex_unlock(&sparse_irq_lock);
> -	return ret;
> -}
> -
> -/**
>   * irq_get_next_irq - get next allocated irq number
>   * @offset:	where to start the search
>   *
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

