Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776Ab3BLABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:01:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760018Ab3BLABU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:01:20 -0500
Message-ID: <1360627269.3248.2.camel@bling.home>
Subject: Re: [PATCH 1/2] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Mon, 11 Feb 2013 17:01:09 -0700
In-Reply-To: <51197C6A.5060403@ozlabs.ru>
References: <1360583672-21924-1-git-send-email-aik@ozlabs.ru>
	  <1360583672-21924-2-git-send-email-aik@ozlabs.ru>
	 <1360621003.12392.117.camel@bling.home> <51197C6A.5060403@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 10:19 +1100, Alexey Kardashevskiy wrote:
> On 12/02/13 09:16, Alex Williamson wrote:
> > On Mon, 2013-02-11 at 22:54 +1100, Alexey Kardashevskiy wrote:
> >> @@ -707,11 +709,39 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
> >>   	return tbl;
> >>   }
> >>
> >> +static void group_release(void *iommu_data)
> >> +{
> >> +	struct iommu_table *tbl = iommu_data;
> >> +	tbl->it_group = NULL;
> >> +}
> >> +
> >> +void iommu_register_group(struct iommu_table * tbl,
> >> +		int domain_number, unsigned long pe_num)
> >> +{
> >> +	struct iommu_group *grp;
> >> +
> >> +	grp = iommu_group_alloc();
> >> +	if (IS_ERR(grp)) {
> >> +		pr_info("powerpc iommu api: cannot create new group, err=%ld\n",
> >> +				PTR_ERR(grp));
> >> +		return;
> >> +	}
> >> +	tbl->it_group = grp;
> >> +	iommu_group_set_iommudata(grp, tbl, group_release);
> >> +	iommu_group_set_name(grp, kasprintf(GFP_KERNEL, "domain%d-pe%lx",
> >> +			domain_number, pe_num));
> >> +}
> >> +
> >>   void iommu_free_table(struct iommu_table *tbl, const char *node_name)
> >>   {
> >>   	unsigned long bitmap_sz;
> >>   	unsigned int order;
> >>
> >> +	if (tbl && tbl->it_group) {
> >> +		iommu_group_put(tbl->it_group);
> >> +		BUG_ON(tbl->it_group);
> >> +	}
> >> +
> >>   	if (!tbl || !tbl->it_map) {
> >>   		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
> >>   				node_name);
> >> @@ -876,4 +906,317 @@ void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
> >>   {
> >>   }
> >>
> >> +static enum dma_data_direction tce_direction(unsigned long tce)
> >> +{
> >> +	if ((tce & TCE_PCI_READ) && (tce & TCE_PCI_WRITE))
> >> +		return DMA_BIDIRECTIONAL;
> >> +	else if (tce & TCE_PCI_READ)
> >> +		return DMA_TO_DEVICE;
> >> +	else if (tce & TCE_PCI_WRITE)
> >> +		return DMA_FROM_DEVICE;
> >> +	else
> >> +		return DMA_NONE;
> >> +}
> >> +
> >> +void iommu_flush_tce(struct iommu_table *tbl)
> >> +{
> >> +	/* Flush/invalidate TLB caches if necessary */
> >> +	if (ppc_md.tce_flush)
> >> +		ppc_md.tce_flush(tbl);
> >> +
> >> +	/* Make sure updates are seen by hardware */
> >> +	mb();
> >> +}
> >> +EXPORT_SYMBOL_GPL(iommu_flush_tce);
> >> +
> >> +static long tce_clear_param_check(struct iommu_table *tbl,
> >> +		unsigned long ioba, unsigned long tce_value,
> >> +		unsigned long npages)
> >> +{
> >> +	unsigned long size = npages << IOMMU_PAGE_SHIFT;
> >> +
> >> +	/* ppc_md.tce_free() does not support any value but 0 */
> >> +	if (tce_value)
> >> +		return -EINVAL;
> >> +
> >> +	if (ioba & ~IOMMU_PAGE_MASK)
> >> +		return -EINVAL;
> >> +
> >> +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> >> +			<< IOMMU_PAGE_SHIFT))
> >> +		return -EINVAL;
> >> +
> >> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> >> +		return -EINVAL;
> >> +
> >> +	return 0;
> >
> > Why do these all return long (vs int)?  Is this a POWER-ism?
> 
> No, not really but yeah, I picked it in powerpc code :) I tried to keep 
> them "long" but I noticed "int" below so what is the rule? Change all to int?

I'd say anything that's returning 0/-errno should probably be an int.

> >> +}
> >> +
> >> +static long tce_put_param_check(struct iommu_table *tbl,
> >> +		unsigned long ioba, unsigned long tce)
> >> +{
> >> +	if (!(tce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> >> +		return -EINVAL;
> >> +
> >> +	if (tce & ~(IOMMU_PAGE_MASK | TCE_PCI_WRITE | TCE_PCI_READ))
> >> +		return -EINVAL;
> >> +
> >> +	if (ioba & ~IOMMU_PAGE_MASK)
> >> +		return -EINVAL;
> >> +
> >> +	if ((ioba + IOMMU_PAGE_SIZE) > ((tbl->it_offset + tbl->it_size)
> >> +			<< IOMMU_PAGE_SHIFT))
> >> +		return -EINVAL;
> >> +
> >> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> >> +		return -EINVAL;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static long clear_tce(struct iommu_table *tbl,
> >> +		unsigned long entry, unsigned long pages)
> >> +{
> >> +	unsigned long oldtce;
> >> +	struct page *page;
> >> +	struct iommu_pool *pool;
> >> +
> >> +	for ( ; pages; --pages, ++entry) {
> >> +		pool = get_pool(tbl, entry);
> >> +		spin_lock(&(pool->lock));
> >> +
> >> +		oldtce = ppc_md.tce_get(tbl, entry);
> >> +		if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) {
> >> +			ppc_md.tce_free(tbl, entry, 1);
> >> +
> >> +			page = pfn_to_page(oldtce >> PAGE_SHIFT);
> >> +			WARN_ON(!page);
> >> +			if (page) {
> >> +				if (oldtce & TCE_PCI_WRITE)
> >> +					SetPageDirty(page);
> >> +				put_page(page);
> >> +			}
> >> +		}
> >> +		spin_unlock(&(pool->lock));
> >> +	}
> >> +
> >> +	return 0;
> >
> > No non-zero return, make it void?
> 
> ah, ok. The prototype will change for real mode either way, it will get a 
> "realmode" flag and become able to fail (which will switch the virtual mode).

If you'll use it later on, no need to change it for me.  Thanks,

Alex

