Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaEBKuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:50:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:39812 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:50:05 -0400
Date: Fri, 2 May 2014 12:50:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] irq: Add new reserved_irqs clear/mark functions
In-Reply-To: <1398986302-30455-7-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1405021120191.6261@ionos.tec.linutronix.de>
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org> <1398986302-30455-7-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Yinghai Lu wrote:
> Prepare for ioapic hotplug.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/irq.h  |  3 +++
>  kernel/irq/irqdesc.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 02dc0e4..2ba3245 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -603,6 +603,9 @@ static inline u32 irq_get_trigger_type(unsigned int irq)
>  	return d ? irqd_get_trigger_type(d) : 0;
>  }
>  
> +int irq_clear_reserved_irqs(unsigned int from, unsigned int cnt);
> +int irq_mark_reserved_irqs(int irq, unsigned int from, unsigned int cnt);
> +
>  int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>  		struct module *owner);
>  
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 49bf891..865ebc0 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -97,6 +97,7 @@ int nr_irqs = NR_IRQS;
>  EXPORT_SYMBOL_GPL(nr_irqs);
>  
>  static DEFINE_MUTEX(sparse_irq_lock);
> +static DECLARE_BITMAP(reserved_irqs, IRQ_BITMAP_BITS);
>  static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
>  
>  #ifdef CONFIG_SPARSE_IRQ
> @@ -400,6 +401,73 @@ err:
>  EXPORT_SYMBOL_GPL(__irq_alloc_descs);
>  
>  /**
> + * irq_clear_reserved_irqs - clear irqs reserved
> + * @from:	clear from irq number
> + * @cnt:	number of irqs to clear
> + *
> + * Returns 0 on success or an appropriate error code
> + */
> +int irq_clear_reserved_irqs(unsigned int from, unsigned int cnt)
> +{
> +	if (!cnt || (from + cnt) > nr_irqs)
> +		return -EINVAL;
> +
> +	mutex_lock(&sparse_irq_lock);
> +	bitmap_clear(reserved_irqs, from, cnt);
> +	mutex_unlock(&sparse_irq_lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * irq_mark_reserved_irqs - mark irqs reserved
> + * @irq:	Allocate for specific irq number if irq >= 0
> + * @from:	mark from irq number
> + * @cnt:	number of irqs to mark
> + *
> + * Returns the first irq number or error code
> + */
> +int irq_mark_reserved_irqs(int irq, unsigned int from, unsigned int cnt)
> +{
> +	unsigned int start, reserve;
> +	int ret;
> +
> +	if (!cnt)
> +		return -EINVAL;
> +
> +	if (irq >= 0) {
> +		if (from > irq)
> +			return -EINVAL;
> +		from = irq;
> +	}
> +
> +	mutex_lock(&sparse_irq_lock);
> +	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> +						from, cnt, 0);
> +	ret = -EEXIST;
> +	if (irq >= 0 && start != irq)
> +		goto err;
> +
> +	if (start + cnt > nr_irqs) {
> +		ret = irq_expand_nr_irqs(start + cnt);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	reserve = bitmap_find_next_zero_area(reserved_irqs, nr_irqs, start,
> +						cnt, 0);
> +	if (reserve == start) {
> +		ret = start;
> +		bitmap_set(reserved_irqs, start, cnt);
> +	} else
> +		ret = -EEXIST;

And what exactly is the point of this exercise?

Something calls irq_mark_reserved_irqs() which sets the bits in
reserved_irqs and then before the irqs are allocated for the reserved
range some random driver allocates an MSI IRQ and that calls
alloc_irq() which will happily take an interrupt out of the reserved
area.

This is beyond sloppy. Go and find something to hack on which fits
your incompetence. "Hello world!" might be a good starting point.

My patience with you is finally exhausted. I'm not longer going to
deal with you and waste my precious time.

Send your future patches to /dev/null right away as they are going to
end up via procmail there anyway. Spare the bandwidth.

Thanks,

	tglx







