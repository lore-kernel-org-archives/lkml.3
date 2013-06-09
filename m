Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3FITN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 15:13:59 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54416 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562Ab3FITN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 15:13:57 -0400
Date: Sun, 9 Jun 2013 21:13:40 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v3 11/27] x86, irq: Add realloc_irq_and_cfg_at()
Message-ID: <20130609191339.GG2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-12-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-12-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:57PM -0700, Yinghai Lu wrote:
> For ioapic hot-add support, it would be easy if we put all irqs
> for that ioapic controller together.
> 
> We can reserve irq range at first, then reallocate those
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
> 
> -v2: update changelog by adding reasons, requested by Konrad.

I think it will be better to split out the gen irq changes out of x86 / apic
specific code. 

I don't what to say. You are worried about the extra unused memory in case
of irq_desc right? The OF code has more or less the same problem. They use
irq_of_parse_and_map() / irq_create_mapping() to create a mapping between
virq (the linux number) and hw-irq (pin on the irq chip). This mapping is
created once the irq chip is detected. They don't care about virqs (aka 
linux numbers) to be in a row and they allocate all of irqdesc at once.

Once you get irqdomain to be used within ioapic, then your "linux irq
number" vs "hw irq number" should disapper. Plus you can remove the whole
gsi_number thingy. And then you start working on getting irqdesc allocated
later, say at request_irq() time and free at free_irq().

However I am not sure if this is worth it. The advantage would be that you
would once one infrastcuture for linux-number vs hw-number mapping and the
delayed irqdesc allocate + numa node rellocating.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/x86/kernel/apic/io_apic.c | 32 +++++++++++++++++++++++++++++++-
>  include/linux/irq.h            |  5 +++++
>  kernel/irq/irqdesc.c           | 26 ++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 670c538..a157a56 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -301,6 +301,36 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
>  	irq_free_desc(at);
>  }
>  
> +static struct irq_cfg *realloc_irq_and_cfg_at(unsigned int at, int node)
> +{
> +	struct irq_desc *desc = irq_to_desc(at);
> +	struct irq_cfg *cfg;
> +	int res;
> +
> +	if (desc) {
> +		if (irq_desc_get_irq_data(desc)->node == node)
> +			return alloc_irq_and_cfg_at(at, node);
> +
> +		cfg = irq_desc_get_chip_data(desc);
> +		if (cfg) {
> +			/* shared irq */
> +			if (!list_empty(&cfg->irq_2_pin))
> +				return cfg;
> +			free_irq_cfg(at, cfg);
> +		}
> +	}
> +
> +	res = irq_realloc_desc_at(at, node);
> +	if (res >= 0) {
> +		cfg = alloc_irq_cfg(at, node);
> +		if (cfg) {
> +			irq_set_chip_data(at, cfg);
> +			return cfg;
> +		}
> +	}

This looks somehow hackish. If irqdesc exists on another node then it
looks here like you overwrite it with a new one but __irq_realloc_desc()
deallocates the old one. As I said, this looks very hackish.

> +
> +	return alloc_irq_and_cfg_at(at, node);
> +}
>  
>  struct io_apic {
>  	unsigned int index;
> @@ -3352,7 +3382,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
>  static int
>  io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
>  {
> -	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
> +	struct irq_cfg *cfg = realloc_irq_and_cfg_at(irq, node);
>  	int ret;
>  
>  	if (!cfg)
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 4e0fcbb..9c6c047 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -602,6 +602,11 @@ void irq_free_descs(unsigned int irq, unsigned int cnt);
>  int irq_reserve_irqs(unsigned int from, unsigned int cnt);
>  int __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt);
>  
> +int __irq_realloc_desc(int at, int node, struct module *owner);
> +/* use macros to avoid needing export.h for THIS_MODULE */
If you put this in line with the other functions, you wouldn't need to
copy the comment.

> +#define irq_realloc_desc_at(at, node)	\
> +	__irq_realloc_desc(at, node, THIS_MODULE)
> +
>  static inline void irq_free_desc(unsigned int irq)
>  {
>  	irq_free_descs(irq, 1);
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

This is not reserved, this is allocated.

> +}
> +
>  #ifdef CONFIG_SPARSE_IRQ
>  
>  static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
> @@ -410,6 +415,27 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>  EXPORT_SYMBOL_GPL(__irq_alloc_descs);
>  
>  /**
> + * irq_realloc_desc - allocate irq descriptor for irq that is already reserved
> + * @irq:	Allocate for specific irq number if irq >= 0
> + * @node:	Preferred node on which the irq descriptor should be allocated
> + * @owner:	Owning module (can be NULL)
> + *
> + * Returns the irq number or error code
> + */
> +int __ref
> +__irq_realloc_desc(int irq, int node, struct module *owner)
> +{
> +	if (!__irq_is_reserved(irq))
> +		return -EINVAL;

I don't like the part where it is named reserved but means allocated

> +
> +	if (irq_to_desc(irq))
> +		free_desc(irq);

and free if it is already avaiable because it should not be allocated.

> +
> +	return alloc_descs(irq, 1, node, owner);
> +}
> +EXPORT_SYMBOL_GPL(__irq_realloc_desc);

Sebastian
