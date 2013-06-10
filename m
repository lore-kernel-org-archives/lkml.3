Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3FJUNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:13:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:58291 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FJUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:13:52 -0400
Date: Mon, 10 Jun 2013 22:13:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v3 11/27] x86, irq: Add realloc_irq_and_cfg_at()
In-Reply-To: <1370644273-10495-12-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.02.1306102144300.22970@ionos>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org> <1370644273-10495-12-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jun 2013, Yinghai Lu wrote:

> For ioapic hot-add support, it would be easy if we put all irqs
> for that ioapic controller together.
> 
> We can reserve irq range at first, then reallocate those

No. We do not reallocate something which does not exist in the first
place.

> pre-reserved one when it is needed.
> 
> Add realloc_irq_and_cfg_at() to really allocate irq_desc and cfg,
> because pre-reserved only mark bits in allocate_irqs bit maps.
> 
> The reasons for not allocating them during reserving:
> 1. only several pins in ioapic are used, allocate for all pins, will
>    waste memory for not used pins.
> 2. relocate later could make sure irq_desc is allocated on local node ram.
>    as dev->node is set at that point.

This is not relocating. Your changelog sucks as much as your code.
 
> -v2: update changelog by adding reasons, requested by Konrad.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/x86/kernel/apic/io_apic.c | 32 +++++++++++++++++++++++++++++++-
>  include/linux/irq.h            |  5 +++++
>  kernel/irq/irqdesc.c           | 26 ++++++++++++++++++++++++++

No, we do not add new code to the core and use it in the same patch at
some random other place. The core code change wants to be separate and
have a separate changelog.

> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -602,6 +602,11 @@ void irq_free_descs(unsigned int irq, unsigned int cnt);
>  int irq_reserve_irqs(unsigned int from, unsigned int cnt);
>  int __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt);
>  
> +int __irq_realloc_desc(int at, int node, struct module *owner);
> +/* use macros to avoid needing export.h for THIS_MODULE */

You must be kidding. export.h has been split out from module.h exactly
to avoid horrible comments like the above and nonsense like this:

> +#define irq_realloc_desc_at(at, node)	\
> +	__irq_realloc_desc(at, node, THIS_MODULE)
> +

> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 3b9fb92..b48f65b 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -99,6 +99,11 @@ EXPORT_SYMBOL_GPL(nr_irqs);
>  static DEFINE_MUTEX(sparse_irq_lock);
>  static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
>  
> +static bool __irq_is_reserved(int irq)
> +{
> +	return !!test_bit(irq, allocated_irqs);

What's the point of this? Why not use test_bit() directly in the code?

If we really want this to be a function, then it should be inline and
it could do without the pointless and !! nonsense.

>  static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
> @@ -410,6 +415,27 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>  EXPORT_SYMBOL_GPL(__irq_alloc_descs);
>  
>  /**
> + * irq_realloc_desc - allocate irq descriptor for irq that is already reserved

And of course you are documenting crap again.

> + * @irq:	Allocate for specific irq number if irq >= 0
> + * @node:	Preferred node on which the irq descriptor should be allocated
> + * @owner:	Owning module (can be NULL)
> + *
> + * Returns the irq number or error code
> + */
> +int __ref
> +__irq_realloc_desc(int irq, int node, struct module *owner)

What's the point of this line split ?

> +{
> +	if (!__irq_is_reserved(irq))
> +		return -EINVAL;

So this function can operate safely w/o holding sparse_irq_lock?

> +	if (irq_to_desc(irq))
> +		free_desc(irq);

You unconditionally throw away an existing irq descriptor? No, you
should bail out here. The function name is a misnomer as it does not
match the funciton description:

irq_realloc_desc - allocate irq descriptor for irq that is already reserved

You want to allocate an irq descriptor for a reserved irq. That's what
the function is about, not about reallocating an existing irq
descriptor. 

So what you want is:

irq_alloc_reserved_desc - allocate irq descriptor for irq that is already reserved

and then bail out if the irq descriptor already exists.

> +	return alloc_descs(irq, 1, node, owner);

> +EXPORT_SYMBOL_GPL(__irq_realloc_desc);

What's the point of exporting this?

Thanks,

	tglx
