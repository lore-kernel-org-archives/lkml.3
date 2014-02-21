Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaBUGqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:46:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:24450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbaBUGqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,517,1389772800"; 
   d="scan'208";a="485315071"
Message-ID: <5306F625.5050007@linux.intel.com>
Date: Fri, 21 Feb 2014 14:45:57 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org> <1388707565-16535-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1388707565-16535-3-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/1/3 8:05, Yinghai Lu wrote:
> For ioapic hot-add support, it would be easy if we have continuous
> irq numbers for hot added ioapic controller.
> 
> We can reserve irq range at first, and later allocate desc for those
> pre-reserved irqs when they are needed.
> 
> The reasons for not allocating them during reserving:
> 1. only several pins of one ioapic are used, allocate for all pins, will
>    waste memory for not used pins.
> 2. allocate later when is needed could make sure irq_desc is allocated
>    on local node ram, as dev->node is set at that point.
> 
> -v2: update changelog by adding reasons, requested by Konrad.
> -v3: according to tglx:
>        separate core code change with arch code change.
>        change function name to irq_alloc_reserved_desc.
>        kill __irq_is_reserved().
>        remove not need exports.
>      according to Sebastian:
>        spare one comments by put two functions together.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  include/linux/irq.h  |  3 +++
>  kernel/irq/irqdesc.c | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 0229caf..e5f6493 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -595,10 +595,13 @@ static inline u32 irq_get_trigger_type(unsigned int irq)
>  
>  int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>  		struct module *owner);
> +int __irq_alloc_reserved_desc(int at, int node, struct module *owner);
>  
>  /* use macros to avoid needing export.h for THIS_MODULE */
>  #define irq_alloc_descs(irq, from, cnt, node)	\
>  	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE)
> +#define irq_alloc_reserved_desc_at(at, node)	\
> +	__irq_alloc_reserved_desc(at, node, THIS_MODULE)
>  
>  #define irq_alloc_desc(node)			\
>  	irq_alloc_descs(-1, 0, 1, node)
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index a151db6..1166545 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -410,6 +410,29 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>  EXPORT_SYMBOL_GPL(__irq_alloc_descs);
>  
>  /**
> + * __irq_alloc_reserved_desc - allocate irq descriptor for irq that is already reserved
> + * @irq:	Allocate for specific irq number if irq >= 0
Hi Yinghai
	Should we skip "if irq >= 0" here because irq should have already been
reserved? Or should we add range check for irq?
Thanks!
Gerry

> + * @node:	Preferred node on which the irq descriptor should be allocated
> + * @owner:	Owning module (can be NULL)
> + *
> + * Returns the irq number or error code
> + */
> +int __ref __irq_alloc_reserved_desc(int irq, int node, struct module *owner)
> +{
> +	mutex_lock(&sparse_irq_lock);
> +	if (!test_bit(irq, allocated_irqs)) {
> +		mutex_unlock(&sparse_irq_lock);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&sparse_irq_lock);
> +
> +	if (irq_to_desc(irq))
> +		return irq;
> +
> +	return alloc_descs(irq, 1, node, owner);
> +}
> +
> +/**
>   * irq_reserve_irqs - mark irqs allocated
>   * @from:	mark from irq number
>   * @cnt:	number of irqs to mark
> 
