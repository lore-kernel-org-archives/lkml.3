Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575Ab3DBQSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:18:22 -0400
Received: from 8bytes.org ([85.214.48.195]:54061 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564Ab3DBQSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:18:18 -0400
Date: Tue, 2 Apr 2013 18:18:13 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: stuart.yoder@freescale.com, scottwood@freescale.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Message-ID: <20130402161812.GI15687@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 18:18:16 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b04c823678963886232
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Alex Williamson

Alex, can you please review the iommu-group part of this patch?

My comments so far are below:

On Fri, Mar 29, 2013 at 01:24:02AM +0530, Varun Sethi wrote:
> +config FSL_PAMU
> +	bool "Freescale IOMMU support"
> +	depends on PPC_E500MC
> +	select IOMMU_API
> +	select GENERIC_ALLOCATOR
> +	help
> +	  Freescale PAMU support.

A bit lame for a help text. Can you elaborate more what PAMU is and when
it should be enabled?

> +int pamu_enable_liodn(int liodn)
> +{
> +	struct paace *ppaace;
> +
> +	ppaace = pamu_get_ppaace(liodn);
> +	if (!ppaace) {
> +		pr_err("Invalid primary paace entry\n");
> +		return -ENOENT;
> +	}
> +
> +	if (!get_bf(ppaace->addr_bitfields, PPAACE_AF_WSE)) {
> +		pr_err("liodn %d not configured\n", liodn);
> +		return -EINVAL;
> +	}
> +
> +	/* Ensure that all other stores to the ppaace complete first */
> +	mb();
> +
> +	ppaace->addr_bitfields |= PAACE_V_VALID;
> +	mb();

Why is it sufficient to set the bit in a variable when enabling liodn
but when disabling it set_bf needs to be called? This looks a bit
assymetric.

> +/* Derive the window size encoding for a particular PAACE entry */
> +static unsigned int map_addrspace_size_to_wse(phys_addr_t addrspace_size)
> +{
> +	/* Bug if not a power of 2 */
> +	BUG_ON((addrspace_size & (addrspace_size - 1)));

Please use is_power_of_2 here.

> +
> +	/* window size is 2^(WSE+1) bytes */
> +	return __ffs(addrspace_size >> PAMU_PAGE_SHIFT) + PAMU_PAGE_SHIFT - 1;

The PAMU_PAGE_SHIFT shifting and adding looks redundant.

> +	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
> +		pr_err("window size too small or not a power of two %llx\n", win_size);
> +		return -EINVAL;
> +	}
> +
> +	if (win_addr & (win_size - 1)) {
> +		pr_err("window address is not aligned with window size\n");
> +		return -EINVAL;
> +	}

Again, use is_power_of_2 instead of hand-coding.

> +	if (~stashid != 0)
> +		set_bf(paace->impl_attr, PAACE_IA_CID, stashid);
> +
> +	smp_wmb();
> +
> +	if (enable)
> +		paace->addr_bitfields |= PAACE_V_VALID;

Havn't you written a helper funtion to set this bit?

> +irqreturn_t pamu_av_isr(int irq, void *arg)
> +{
> +	struct pamu_isr_data *data = arg;
> +	phys_addr_t phys;
> +	unsigned int i, j;
> +
> +	pr_emerg("fsl-pamu: access violation interrupt\n");
> +
> +	for (i = 0; i < data->count; i++) {
> +		void __iomem *p = data->pamu_reg_base + i * PAMU_OFFSET;
> +		u32 pics = in_be32(p + PAMU_PICS);
> +
> +		if (pics & PAMU_ACCESS_VIOLATION_STAT) {
> +			pr_emerg("POES1=%08x\n", in_be32(p + PAMU_POES1));
> +			pr_emerg("POES2=%08x\n", in_be32(p + PAMU_POES2));
> +			pr_emerg("AVS1=%08x\n", in_be32(p + PAMU_AVS1));
> +			pr_emerg("AVS2=%08x\n", in_be32(p + PAMU_AVS2));
> +			pr_emerg("AVA=%016llx\n", make64(in_be32(p + PAMU_AVAH),
> +				in_be32(p + PAMU_AVAL)));
> +			pr_emerg("UDAD=%08x\n", in_be32(p + PAMU_UDAD));
> +			pr_emerg("POEA=%016llx\n", make64(in_be32(p + PAMU_POEAH),
> +				in_be32(p + PAMU_POEAL)));
> +
> +			phys = make64(in_be32(p + PAMU_POEAH),
> +				in_be32(p + PAMU_POEAL));
> +
> +			/* Assume that POEA points to a PAACE */
> +			if (phys) {
> +				u32 *paace = phys_to_virt(phys);
> +
> +				/* Only the first four words are relevant */
> +				for (j = 0; j < 4; j++)
> +					pr_emerg("PAACE[%u]=%08x\n", j, in_be32(paace + j));
> +			}
> +		}
> +	}
> +
> +	panic("\n");

A kernel panic seems like an over-reaction to an access violation.
Besides the device that caused the violation the system should still
work, no?

> +#define make64(high, low) (((u64)(high) << 32) | (low))

You redefined this make64 here.

> +static int map_subwins(int liodn, struct fsl_dma_domain *dma_domain)
> +{
> +	struct dma_window *sub_win_ptr =
> +				&dma_domain->win_arr[0];
> +	int i, ret;
> +	unsigned long rpn;
> +
> +	for (i = 0; i < dma_domain->win_cnt; i++) {
> +		if (sub_win_ptr[i].valid) {
> +			rpn = sub_win_ptr[i].paddr >>
> +				 PAMU_PAGE_SHIFT;
> +			spin_lock(&iommu_lock);

IOMMU code might run in interrupt context, so please use
spin_lock_irqsave for the iommu_lock.

> +static void detach_device(struct device *dev, struct fsl_dma_domain *dma_domain)
> +{
> +	struct device_domain_info *info;
> +	struct list_head *entry, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dma_domain->domain_lock, flags);
> +	/* Remove the device from the domain device list */
> +	if (!list_empty(&dma_domain->devices)) {
> +		list_for_each_safe(entry, tmp, &dma_domain->devices) {
> +			info = list_entry(entry, struct device_domain_info, link);
> +			if (!dev || (info->dev == dev))
> +				remove_device_ref(info, dma_domain->win_cnt);
> +		}
> +	}
> +	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);

list_empty check is not needed. You can also use
list_for_each_entry_safe.

> +static void attach_device(struct fsl_dma_domain *dma_domain, int liodn, struct device *dev)
> +{
> +	struct device_domain_info *info, *old_domain_info;
> +
> +	spin_lock(&device_domain_lock);
> +	/*
> +	 * Check here if the device is already attached to domain or not.
> +	 * If the device is already attached to a domain detach it.
> +	 */
> +	old_domain_info = find_domain(dev);
> +	if (old_domain_info && old_domain_info->domain != dma_domain) {
> +		spin_unlock(&device_domain_lock);
> +		detach_device(dev, old_domain_info->domain);
> +		spin_lock(&device_domain_lock);
> +	}
> +
> +	info = kmem_cache_zalloc(iommu_devinfo_cache, GFP_KERNEL);
> +
> +	info->dev = dev;
> +	info->liodn = liodn;
> +	info->domain = dma_domain;
> +
> +	list_add(&info->link, &dma_domain->devices);
> +	/*
> +	 * In case of devices with multiple LIODNs just store
> +	 * the info for the first LIODN as all
> +	 * LIODNs share the same domain
> +	 */
> +	if (!old_domain_info)
> +		dev->archdata.iommu_domain = info;
> +	spin_unlock(&device_domain_lock);

Don't you have to tell the hardware that a device was added to a domain?
I don't see that, what I am missing?

> +static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
> +{
> +	pci_dev_put(*from);
> +	*from = to;
> +}

Hmm, looks like this function is re-implemented in a few IOMMU drivers.
Want to use the chance to consolidate these implementations?


	Joerg


