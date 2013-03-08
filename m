Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3CHTvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:51:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23385 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3CHTvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:51:33 -0500
Date: Fri, 8 Mar 2013 14:50:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 10/26] x86, irq: Convert irq_2_pin list to generic list
Message-ID: <20130308195055.GD6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-11-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360351703-20571-11-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:28:07AM -0800, Yinghai Lu wrote:
> Now irq_2_pin list is own grown list.

I think you meant to say 'has its own list'. Not sure how
its growing?

> We can use generic list to replace it so we could generic helper
> functions to operate it.

You need to put the verb a bit earlier. Perhaps:

".. generic list to replace so that we can operate using
generic helper functions."

> 
> Also make free_irq_cfg() free irq_2_pin list to support coming ioapic
> hotplug.

If you have them ready - could you say the titles of the patches here?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>  arch/x86/include/asm/hw_irq.h  |    2 +-
>  arch/x86/kernel/apic/io_apic.c |   22 ++++++++++++----------
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 10a78c3..69743f8 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -121,7 +121,7 @@ struct irq_2_irte {
>   * Most irqs are mapped 1:1 with pins.
>   */
>  struct irq_cfg {
> -	struct irq_pin_list	*irq_2_pin;
> +	struct list_head	irq_2_pin;
>  	cpumask_var_t		domain;
>  	cpumask_var_t		old_domain;
>  	u8			vector;
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 4c1a726..d2b4988 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -66,7 +66,7 @@
>  #define __apicdebuginit(type) static type __init
>  
>  #define for_each_irq_pin(entry, head) \
> -	for (entry = head; entry; entry = entry->next)
> +	list_for_each_entry(entry, &head, list)
>  
>  /*
>   *      Is the SiS APIC rmw bug present ?
> @@ -176,8 +176,8 @@ void mp_save_irq(struct mpc_intsrc *m)
>  }
>  
>  struct irq_pin_list {
> +	struct list_head list;
>  	int apic, pin;
> -	struct irq_pin_list *next;
>  };
>  
>  static struct irq_pin_list *alloc_irq_pin_list(int node)
> @@ -213,6 +213,7 @@ int __init arch_early_irq_init(void)
>  	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
>  
>  	for (i = 0; i < count; i++) {
> +		INIT_LIST_HEAD(&cfg[i].irq_2_pin);
>  		irq_set_chip_data(i, &cfg[i]);
>  		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
>  		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
> @@ -245,6 +246,7 @@ static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
>  		goto out_cfg;
>  	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
>  		goto out_domain;
> +	INIT_LIST_HEAD(&cfg->irq_2_pin);
>  	return cfg;
>  out_domain:
>  	free_cpumask_var(cfg->domain);
> @@ -255,11 +257,15 @@ out_cfg:
>  
>  static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
>  {
> +	struct irq_pin_list *entry, *tmp;
> +
>  	if (!cfg)
>  		return;
>  	irq_set_chip_data(at, NULL);
>  	free_cpumask_var(cfg->domain);
>  	free_cpumask_var(cfg->old_domain);
> +	list_for_each_entry_safe(entry, tmp, &cfg->irq_2_pin, list)
> +		kfree(entry);
>  	kfree(cfg);
>  }
>  
> @@ -420,15 +426,12 @@ static void ioapic_mask_entry(int apic, int pin)
>   */
>  static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
>  {
> -	struct irq_pin_list **last, *entry;
> +	struct irq_pin_list *entry;
>  
>  	/* don't allow duplicates */
> -	last = &cfg->irq_2_pin;
> -	for_each_irq_pin(entry, cfg->irq_2_pin) {
> +	for_each_irq_pin(entry, cfg->irq_2_pin)
>  		if (entry->apic == apic && entry->pin == pin)
>  			return 0;
> -		last = &entry->next;
> -	}
>  
>  	entry = alloc_irq_pin_list(node);
>  	if (!entry) {
> @@ -439,7 +442,7 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
>  	entry->apic = apic;
>  	entry->pin = pin;
>  
> -	*last = entry;
> +	list_add_tail(&entry->list, &cfg->irq_2_pin);
>  	return 0;
>  }
>  
> @@ -1622,8 +1625,7 @@ __apicdebuginit(void) print_IO_APICs(void)
>  		cfg = irq_get_chip_data(irq);
>  		if (!cfg)
>  			continue;
> -		entry = cfg->irq_2_pin;
> -		if (!entry)
> +		if (list_empty(&cfg->irq_2_pin))
>  			continue;
>  		printk(KERN_DEBUG "IRQ%d ", irq);
>  		for_each_irq_pin(entry, cfg->irq_2_pin)
> -- 
> 1.7.10.4
> 
