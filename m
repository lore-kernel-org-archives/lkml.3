Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3GIQCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:02:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3GIQCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:02:41 -0400
Message-ID: <51DC341D.20901@suse.de>
Date: Tue, 09 Jul 2013 18:02:37 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120306 Thunderbird/10.0.3
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 5/8] powerpc: add real mode support for dma operations
 on powernv
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-6-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1373123227-22969-6-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 05:07 PM, Alexey Kardashevskiy wrote:
> The existing TCE machine calls (tce_build and tce_free) only support
> virtual mode as they call __raw_writeq for TCE invalidation what
> fails in real mode.
>
> This introduces tce_build_rm and tce_free_rm real mode versions
> which do mostly the same but use "Store Doubleword Caching Inhibited
> Indexed" instruction for TCE invalidation.

So would always using stdcix have any bad side effects?


Alex

>
> This new feature is going to be utilized by real mode support of VFIO.
>
> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
> ---
>   arch/powerpc/include/asm/machdep.h        | 12 ++++++++++
>   arch/powerpc/platforms/powernv/pci-ioda.c | 26 +++++++++++++++------
>   arch/powerpc/platforms/powernv/pci.c      | 38 ++++++++++++++++++++++++++-----
>   arch/powerpc/platforms/powernv/pci.h      |  2 +-
>   4 files changed, 64 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
> index 92386fc..0c19eef 100644
> --- a/arch/powerpc/include/asm/machdep.h
> +++ b/arch/powerpc/include/asm/machdep.h
> @@ -75,6 +75,18 @@ struct machdep_calls {
>   				    long index);
>   	void		(*tce_flush)(struct iommu_table *tbl);
>
> +	/* _rm versions are for real mode use only */
> +	int		(*tce_build_rm)(struct iommu_table *tbl,
> +				     long index,
> +				     long npages,
> +				     unsigned long uaddr,
> +				     enum dma_data_direction direction,
> +				     struct dma_attrs *attrs);
> +	void		(*tce_free_rm)(struct iommu_table *tbl,
> +				    long index,
> +				    long npages);
> +	void		(*tce_flush_rm)(struct iommu_table *tbl);
> +
>   	void __iomem *	(*ioremap)(phys_addr_t addr, unsigned long size,
>   				   unsigned long flags, void *caller);
>   	void		(*iounmap)(volatile void __iomem *token);
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 2931d97..2797dec 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -68,6 +68,12 @@ define_pe_printk_level(pe_err, KERN_ERR);
>   define_pe_printk_level(pe_warn, KERN_WARNING);
>   define_pe_printk_level(pe_info, KERN_INFO);
>
> +static inline void rm_writed(unsigned long paddr, u64 val)
> +{
> +	__asm__ __volatile__("sync; stdcix %0,0,%1"
> +		: : "r" (val), "r" (paddr) : "memory");
> +}
> +
>   static int pnv_ioda_alloc_pe(struct pnv_phb *phb)
>   {
>   	unsigned long pe;
> @@ -442,7 +448,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb, struct pci_dev *pdev
>   }
>
>   static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
> -					 u64 *startp, u64 *endp)
> +					 u64 *startp, u64 *endp, bool rm)
>   {
>   	u64 __iomem *invalidate = (u64 __iomem *)tbl->it_index;
>   	unsigned long start, end, inc;
> @@ -471,7 +477,10 @@ static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
>
>           mb(); /* Ensure above stores are visible */
>           while (start<= end) {
> -                __raw_writeq(start, invalidate);
> +		if (rm)
> +			rm_writed((unsigned long) invalidate, start);
> +		else
> +			__raw_writeq(start, invalidate);
>                   start += inc;
>           }
>
> @@ -483,7 +492,7 @@ static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
>
>   static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
>   					 struct iommu_table *tbl,
> -					 u64 *startp, u64 *endp)
> +					 u64 *startp, u64 *endp, bool rm)
>   {
>   	unsigned long start, end, inc;
>   	u64 __iomem *invalidate = (u64 __iomem *)tbl->it_index;
> @@ -502,22 +511,25 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
>   	mb();
>
>   	while (start<= end) {
> -		__raw_writeq(start, invalidate);
> +		if (rm)
> +			rm_writed((unsigned long) invalidate, start);
> +		else
> +			__raw_writeq(start, invalidate);
>   		start += inc;
>   	}
>   }
>
>   void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
> -				 u64 *startp, u64 *endp)
> +				 u64 *startp, u64 *endp, bool rm)
>   {
>   	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
>   					      tce32_table);
>   	struct pnv_phb *phb = pe->phb;
>
>   	if (phb->type == PNV_PHB_IODA1)
> -		pnv_pci_ioda1_tce_invalidate(tbl, startp, endp);
> +		pnv_pci_ioda1_tce_invalidate(tbl, startp, endp, rm);
>   	else
> -		pnv_pci_ioda2_tce_invalidate(pe, tbl, startp, endp);
> +		pnv_pci_ioda2_tce_invalidate(pe, tbl, startp, endp, rm);
>   }
>
>   static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> index e16b729..280f614 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -336,7 +336,7 @@ struct pci_ops pnv_pci_ops = {
>
>   static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
>   			 unsigned long uaddr, enum dma_data_direction direction,
> -			 struct dma_attrs *attrs)
> +			 struct dma_attrs *attrs, bool rm)
>   {
>   	u64 proto_tce;
>   	u64 *tcep, *tces;
> @@ -358,12 +358,19 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
>   	 * of flags if that becomes the case
>   	 */
>   	if (tbl->it_type&  TCE_PCI_SWINV_CREATE)
> -		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1);
> +		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
>
>   	return 0;
>   }
>
> -static void pnv_tce_free(struct iommu_table *tbl, long index, long npages)
> +static int pnv_tce_build_vm(struct iommu_table *tbl, long index, long npages,
> +			    unsigned long uaddr, enum dma_data_direction direction,
> +			    struct dma_attrs *attrs)
> +{
> +	return pnv_tce_build(tbl, index, npages, uaddr, direction, attrs, false);
> +}
> +
> +static void pnv_tce_free(struct iommu_table *tbl, long index, long npages, bool rm)
>   {
>   	u64 *tcep, *tces;
>
> @@ -373,7 +380,12 @@ static void pnv_tce_free(struct iommu_table *tbl, long index, long npages)
>   		*(tcep++) = 0;
>
>   	if (tbl->it_type&  TCE_PCI_SWINV_FREE)
> -		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1);
> +		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
> +}
> +
> +static void pnv_tce_free_vm(struct iommu_table *tbl, long index, long npages)
> +{
> +	pnv_tce_free(tbl, index, npages, false);
>   }
>
>   static unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
> @@ -381,6 +393,18 @@ static unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
>   	return ((u64 *)tbl->it_base)[index - tbl->it_offset];
>   }
>
> +static int pnv_tce_build_rm(struct iommu_table *tbl, long index, long npages,
> +			    unsigned long uaddr, enum dma_data_direction direction,
> +			    struct dma_attrs *attrs)
> +{
> +	return pnv_tce_build(tbl, index, npages, uaddr, direction, attrs, true);
> +}
> +
> +static void pnv_tce_free_rm(struct iommu_table *tbl, long index, long npages)
> +{
> +	pnv_tce_free(tbl, index, npages, true);
> +}
> +
>   void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
>   			       void *tce_mem, u64 tce_size,
>   			       u64 dma_offset)
> @@ -545,8 +569,10 @@ void __init pnv_pci_init(void)
>
>   	/* Configure IOMMU DMA hooks */
>   	ppc_md.pci_dma_dev_setup = pnv_pci_dma_dev_setup;
> -	ppc_md.tce_build = pnv_tce_build;
> -	ppc_md.tce_free = pnv_tce_free;
> +	ppc_md.tce_build = pnv_tce_build_vm;
> +	ppc_md.tce_free = pnv_tce_free_vm;
> +	ppc_md.tce_build_rm = pnv_tce_build_rm;
> +	ppc_md.tce_free_rm = pnv_tce_free_rm;
>   	ppc_md.tce_get = pnv_tce_get;
>   	ppc_md.pci_probe_mode = pnv_pci_probe_mode;
>   	set_pci_dma_ops(&dma_iommu_ops);
> diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
> index 25d76c4..6799374 100644
> --- a/arch/powerpc/platforms/powernv/pci.h
> +++ b/arch/powerpc/platforms/powernv/pci.h
> @@ -158,6 +158,6 @@ extern void pnv_pci_init_p5ioc2_hub(struct device_node *np);
>   extern void pnv_pci_init_ioda_hub(struct device_node *np);
>   extern void pnv_pci_init_ioda2_phb(struct device_node *np);
>   extern void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
> -					u64 *startp, u64 *endp);
> +					u64 *startp, u64 *endp, bool rm);
>
>   #endif /* __POWERNV_PCI_H */

