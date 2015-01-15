Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAODbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 22:31:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbbAODbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 22:31:14 -0500
Date: Thu, 15 Jan 2015 11:28:58 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        vgoyal@redhat.com, dyoung@redhat.com, jerry.hoemann@hp.com,
        tom.vaden@hp.com, rwright@hp.com, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        lisa.mitchell@hp.com, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com, doug.hatch@hp.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        billsumnerlinux@gmail.com, li.zhang6@hp.com
Subject: Re: [PATCH v8 06/10] iommu/vt-d: datatypes and functions used for
 kdump
Message-ID: <20150115032858.GA2461@dhcp-16-105.nay.redhat.com>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-7-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421046388-27925-7-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 at 03:06pm, Li, Zhen-Hua wrote:
> +/*
> + * Interface to the "copy translation tables" set of functions
> + * from mainline code.
> + */
> +static int intel_iommu_load_translation_tables(struct dmar_drhd_unit *drhd,
> +		int g_num_of_iommus)

The argument g_num_of_iommus is the same as the global variable, it's better
to rename it as num_of_iommus. And even it can be removed since you can
just use the global variable g_num_of_iommus in this function.

Argument drhd can be intel_iommu because no other member variable in
drhd is needed.

> +{
> +	struct intel_iommu *iommu;	/* Virt(iommu hardware registers) */
> +	unsigned long long q;		/* quadword scratch */
> +	int ret = 0;			/* Integer return code */
> +	int i = 0;			/* Loop index */
> +	unsigned long flags;
> +
> +	/* Structure so copy_page_addr() can accumulate things
> +	 * over multiple calls and returns
> +	 */
> +	struct copy_page_addr_parms ppa_parms = copy_page_addr_parms_init;
> +	struct copy_page_addr_parms *ppap = &ppa_parms;
> +
> +
> +	iommu = drhd->iommu;
> +	q = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
> +	if (!q)
> +		return -1;
> +
> +	/* If (list needs initializing) do it here */

This initializing should not be here, because it's not only for this
drhd. It should be done in init_dmars().

> +	if (!domain_values_list) {
> +		domain_values_list =
> +			 kcalloc(g_num_of_iommus, sizeof(struct list_head),
> +					GFP_KERNEL);
> +
> +		if (!domain_values_list) {
> +			pr_err("Allocation failed for domain_values_list array\n");
> +			return -ENOMEM;
> +		}
> +		for (i = 0; i < g_num_of_iommus; i++)
> +			INIT_LIST_HEAD(&domain_values_list[i]);
> +	}
> +
> +	spin_lock_irqsave(&iommu->lock, flags);
> +
> +	/* Load the root-entry table from the old kernel
> +	 * foreach context_entry_table in root_entry
> +	 *    foreach context_entry in context_entry_table
> +	 *       foreach level-1 page_table_entry in context_entry
> +	 *          foreach level-2 page_table_entry in level 1 page_table_entry
> +	 *             Above pattern continues up to 6 levels of page tables
> +	 *                Sanity-check the entry
> +	 *                Process the bus, devfn, page_address, page_size
> +	 */
> +	if (!iommu->root_entry) {
> +		iommu->root_entry =
> +			(struct root_entry *)alloc_pgtable_page(iommu->node);
> +		if (!iommu->root_entry) {
> +			spin_unlock_irqrestore(&iommu->lock, flags);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	iommu->root_entry_old_phys = q & VTD_PAGE_MASK;
> +	if (!iommu->root_entry_old_phys) {
> +		pr_err("Could not read old root entry address.");
> +		return -1;
> +	}
> +
> +	iommu->root_entry_old_virt = ioremap_cache(iommu->root_entry_old_phys,
> +						VTD_PAGE_SIZE);
> +	if (!iommu->root_entry_old_virt) {
> +		pr_err("Could not map the old root entry.");
> +		return -ENOMEM;
> +	}
> +
> +	__iommu_load_old_root_entry(iommu);
> +	ret = copy_root_entry_table(iommu, ppap);
> +	__iommu_flush_cache(iommu, iommu->root_entry, PAGE_SIZE);
> +	__iommu_update_old_root_entry(iommu, -1);
> +
> +	spin_unlock_irqrestore(&iommu->lock, flags);
> +
> +	__iommu_free_mapped_mem();
> +
> +	if (ret)
> +		return ret;
> +
> +	ppa_parms.last = 1;
> +	copy_page_addr(0, 0, 0, 0, 0, NULL, ppap);
> +
> +	return 0;
> +}
> +
>  #endif /* CONFIG_CRASH_DUMP */
> -- 
> 2.0.0-rc0
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
