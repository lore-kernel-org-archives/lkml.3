Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3KGOmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:42:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10342 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3KGOmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:42:12 -0500
X-IronPort-AV: E=Sophos;i="4.93,652,1378857600"; 
   d="scan'208";a="71600978"
Message-ID: <1383835328.32399.45.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v9 03/18] arm/xen,arm64/xen: introduce p2m
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>
Date: Thu, 7 Nov 2013 14:42:08 +0000
In-Reply-To: <1382698313-13161-3-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
	 <1382698313-13161-3-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 11:51 +0100, Stefano Stabellini wrote:
> Introduce physical to machine and machine to physical tracking
> mechanisms based on rbtrees for arm/xen and arm64/xen.
> 
> We need it because any guests on ARM are an autotranslate guests,
> therefore a physical address is potentially different from a machine
> address. When programming a device to do DMA, we need to be
> extra-careful to use machine addresses rather than physical addresses to
> program the device. Therefore we need to know the physical to machine
> mappings.
> 
> For the moment we assume that dom0 starts with a 1:1 physical to machine
> mapping, in other words physical addresses correspond to machine
> addresses. However when mapping a foreign grant reference, obviously the
> 1:1 model doesn't work anymore. So at the very least we need to be able
> to track grant mappings.
> 
> We need locking to protect accesses to the two trees.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Changes in v8:
> - move pfn_to_mfn and mfn_to_pfn to page.h as static inline functions;
> - no need to walk the tree if phys_to_mach.rb_node is NULL;
> - correctly handle multipage p2m entries;
> - substitute the spin_lock with a rwlock.
> ---
>  arch/arm/include/asm/xen/page.h |   49 ++++++++--
>  arch/arm/xen/Makefile           |    2 +-
>  arch/arm/xen/p2m.c              |  208 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/xen/Makefile         |    2 +-
>  4 files changed, 252 insertions(+), 9 deletions(-)
>  create mode 100644 arch/arm/xen/p2m.c
> 
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 359a7b5..d1b5dd5 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -7,11 +7,10 @@
>  #include <linux/pfn.h>
>  #include <linux/types.h>
>  
> +#include <xen/xen.h>
>  #include <xen/interface/grant_table.h>
>  
> -#define pfn_to_mfn(pfn)			(pfn)
>  #define phys_to_machine_mapping_valid(pfn) (1)
> -#define mfn_to_pfn(mfn)			(mfn)
>  #define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
>  
>  #define pte_mfn	    pte_pfn
> @@ -32,6 +31,44 @@ typedef struct xpaddr {
>  
>  #define INVALID_P2M_ENTRY      (~0UL)
>  
> +unsigned long __pfn_to_mfn(unsigned long pfn);
> +unsigned long __mfn_to_pfn(unsigned long mfn);
> +extern struct rb_root phys_to_mach;
> +
> +static inline unsigned long pfn_to_mfn(unsigned long pfn)
> +{
> +	unsigned long mfn;
> +	
> +	if (phys_to_mach.rb_node != NULL) {
> +		mfn = __pfn_to_mfn(pfn);
> +		if (mfn != INVALID_P2M_ENTRY)
> +			return mfn;
> +	}
> +
> +	if (xen_initial_domain())
> +		return pfn;
> +	else
> +		return INVALID_P2M_ENTRY;

This breaks domU ballooning (for some reason only on 64-bit, I've no
clue why not 32-bit).

decrease_reservation does pfn_to_mfn in order to release the page, and
this ends up passing INVALID_P2M_ENTRY, which the hypervisor rightly
rejects.

> +static inline unsigned long mfn_to_pfn(unsigned long mfn)
> +{
> +	unsigned long pfn;
> +
> +	if (phys_to_mach.rb_node != NULL) {
> +		pfn = __mfn_to_pfn(mfn);
> +		if (pfn != INVALID_P2M_ENTRY)
> +			return pfn;
> +	}
> +
> +	if (xen_initial_domain())
> +		return mfn;
> +	else
> +		return INVALID_P2M_ENTRY;

Same here I think.

Both of these should unconditionally return their inputs for !
xen_initial_domain() I think. I presume hys_to_mach.rb_node != NULL
should never trigger for a domU?

> +static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
> +{
> +	struct rb_node **link = &phys_to_mach.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct xen_p2m_entry *entry;
> +	int rc = 0;
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct xen_p2m_entry, rbnode_phys);
> +
> +		if (new->mfn == entry->mfn)
> +			goto err_out;
> +		if (new->pfn == entry->pfn)
> +			goto err_out;
> +
> +		if (new->pfn < entry->pfn)
> +			link = &(*link)->rb_left;
> +		else
> +			link = &(*link)->rb_right;
> +	}

Are there really no helpers for walking an rbtree?

> +	rb_link_node(&new->rbnode_phys, parent, link);
> +	rb_insert_color(&new->rbnode_phys, &phys_to_mach);
> +	goto out;
> +
> +err_out:
> +	rc = -EINVAL;
> +	pr_warn("%s: cannot add pfn=%pa -> mfn=%pa: pfn=%pa -> mfn=%pa already exists\n",
> +			__func__, &new->pfn, &new->mfn, &entry->pfn, &entry->mfn);
> +out:
> +	return rc;
> +}
> +
> +unsigned long __pfn_to_mfn(unsigned long pfn)
> +{
> +	struct rb_node *n = phys_to_mach.rb_node;
> +	struct xen_p2m_entry *entry;
> +	unsigned long irqflags;
> +
> +	read_lock_irqsave(&p2m_lock, irqflags);
> +	while (n) {
> +		entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
> +		if (entry->pfn <= pfn &&
> +				entry->pfn + entry->nr_pages > pfn) {
> +			read_unlock_irqrestore(&p2m_lock, irqflags);
> +			return entry->mfn + (pfn - entry->pfn);
> +		}
> +		if (pfn < entry->pfn)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +	}
> +	read_unlock_irqrestore(&p2m_lock, irqflags);
> +
> +	return INVALID_P2M_ENTRY;
> +}
> +EXPORT_SYMBOL_GPL(__pfn_to_mfn);
> +
> +static int xen_add_mach_to_phys_entry(struct xen_p2m_entry *new)
> +{
> +	struct rb_node **link = &mach_to_phys.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct xen_p2m_entry *entry;
> +	int rc = 0;
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct xen_p2m_entry, rbnode_mach);
> +
> +		if (new->mfn == entry->mfn)
> +			goto err_out;
> +		if (new->pfn == entry->pfn)
> +			goto err_out;
> +
> +		if (new->mfn < entry->mfn)
> +			link = &(*link)->rb_left;
> +		else
> +			link = &(*link)->rb_right;
> +	}

This looks close to identical to the one in xen_add_phys_to_mach_entry.
You could combine them with a simple "lookup mfn" boolean.


> +	rb_link_node(&new->rbnode_mach, parent, link);
> +	rb_insert_color(&new->rbnode_mach, &mach_to_phys);
> +	goto out;
> +
> +err_out:
> +	rc = -EINVAL;
> +	pr_warn("%s: cannot add pfn=%pa -> mfn=%pa: pfn=%pa -> mfn=%pa already exists\n",
> +			__func__, &new->pfn, &new->mfn, &entry->pfn, &entry->mfn);
> +out:
> +	return rc;
> +}
> +
> +unsigned long __mfn_to_pfn(unsigned long mfn)
> +{
> +	struct rb_node *n = mach_to_phys.rb_node;
> +	struct xen_p2m_entry *entry;
> +	unsigned long irqflags;
> +
> +	read_lock_irqsave(&p2m_lock, irqflags);
> +	while (n) {
> +		entry = rb_entry(n, struct xen_p2m_entry, rbnode_mach);
> +		if (entry->mfn <= mfn &&
> +				entry->mfn + entry->nr_pages > mfn) {
> +			read_unlock_irqrestore(&p2m_lock, irqflags);
> +			return entry->pfn + (mfn - entry->mfn);
> +		}
> +		if (mfn < entry->mfn)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +	}

and this looks basically identical to __pfn_to_mfn in the same way.

> +	read_unlock_irqrestore(&p2m_lock, irqflags);
> +
> +	return INVALID_P2M_ENTRY;
> +}
> +EXPORT_SYMBOL_GPL(__mfn_to_pfn);
> +

Ian.

