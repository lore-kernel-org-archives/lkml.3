Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3BKWRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:17:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab3BKWRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:17:01 -0500
Message-ID: <1360621003.12392.117.camel@bling.home>
Subject: Re: [PATCH 1/2] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Mon, 11 Feb 2013 15:16:43 -0700
In-Reply-To: <1360583672-21924-2-git-send-email-aik@ozlabs.ru>
References: <1360583672-21924-1-git-send-email-aik@ozlabs.ru>
	 <1360583672-21924-2-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 22:54 +1100, Alexey Kardashevskiy wrote:
> This patch initializes IOMMU groups based on the IOMMU
> configuration discovered during the PCI scan on POWERNV
> (POWER non virtualized) platform. The IOMMU groups are
> to be used later by VFIO driver (PCI pass through).
> 
> It also implements an API for mapping/unmapping pages for
> guest PCI drivers and providing DMA window properties.
> This API is going to be used later by QEMU-VFIO to handle
> h_put_tce hypercalls from the KVM guest.
> 
> The iommu_put_tce_user_mode() does only a single page mapping
> as an API for adding many mappings at once is going to be
> added later.
> 
> Although this driver has been tested only on the POWERNV
> platform, it should work on any platform which supports
> TCE tables. As h_put_tce hypercall is received by the host
> kernel and processed by the QEMU (what involves calling
> the host kernel again), performance is not the best -
> circa 220MB/s on 10Gb ethernet network.
> 
> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
> option and configure VFIO as required.
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Yay, it's not dead! ;)

I'd love some kind of changelog to know what to look for in here,
especially given 2mo since the last version.

> ---
>  arch/powerpc/include/asm/iommu.h            |   15 ++
>  arch/powerpc/kernel/iommu.c                 |  343 +++++++++++++++++++++++++++
>  arch/powerpc/platforms/powernv/pci-ioda.c   |    1 +
>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |    5 +-
>  arch/powerpc/platforms/powernv/pci.c        |    3 +
>  drivers/iommu/Kconfig                       |    8 +
>  6 files changed, 374 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> index cbfe678..900294b 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -76,6 +76,9 @@ struct iommu_table {
>  	struct iommu_pool large_pool;
>  	struct iommu_pool pools[IOMMU_NR_POOLS];
>  	unsigned long *it_map;       /* A simple allocation bitmap for now */
> +#ifdef CONFIG_IOMMU_API
> +	struct iommu_group *it_group;
> +#endif
>  };
>  
>  struct scatterlist;
> @@ -98,6 +101,8 @@ extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
>   */
>  extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
>  					    int nid);
> +extern void iommu_register_group(struct iommu_table * tbl,
> +				 int domain_number, unsigned long pe_num);
>  
>  extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
>  			struct scatterlist *sglist, int nelems,
> @@ -147,5 +152,15 @@ static inline void iommu_restore(void)
>  }
>  #endif
>  
> +/* The API to support IOMMU operations for VFIO */
> +extern long iommu_clear_tce_user_mode(struct iommu_table *tbl,
> +		unsigned long ioba, unsigned long tce_value,
> +		unsigned long npages);
> +extern long iommu_put_tce_user_mode(struct iommu_table *tbl,
> +		unsigned long ioba, unsigned long tce);
> +
> +extern void iommu_flush_tce(struct iommu_table *tbl);
> +extern long iommu_lock_table(struct iommu_table *tbl, bool lock);
> +
>  #endif /* __KERNEL__ */
>  #endif /* _ASM_IOMMU_H */
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index 7c309fe..b4fdabc 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -37,6 +37,7 @@
>  #include <linux/fault-inject.h>
>  #include <linux/pci.h>
>  #include <linux/kvm_host.h>
> +#include <linux/iommu.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/iommu.h>
> @@ -45,6 +46,7 @@
>  #include <asm/kdump.h>
>  #include <asm/fadump.h>
>  #include <asm/vio.h>
> +#include <asm/tce.h>
>  
>  #define DBG(...)
>  
> @@ -707,11 +709,39 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
>  	return tbl;
>  }
>  
> +static void group_release(void *iommu_data)
> +{
> +	struct iommu_table *tbl = iommu_data;
> +	tbl->it_group = NULL;
> +}
> +
> +void iommu_register_group(struct iommu_table * tbl,
> +		int domain_number, unsigned long pe_num)
> +{
> +	struct iommu_group *grp;
> +
> +	grp = iommu_group_alloc();
> +	if (IS_ERR(grp)) {
> +		pr_info("powerpc iommu api: cannot create new group, err=%ld\n",
> +				PTR_ERR(grp));
> +		return;
> +	}
> +	tbl->it_group = grp;
> +	iommu_group_set_iommudata(grp, tbl, group_release);
> +	iommu_group_set_name(grp, kasprintf(GFP_KERNEL, "domain%d-pe%lx",
> +			domain_number, pe_num));
> +}
> +
>  void iommu_free_table(struct iommu_table *tbl, const char *node_name)
>  {
>  	unsigned long bitmap_sz;
>  	unsigned int order;
>  
> +	if (tbl && tbl->it_group) {
> +		iommu_group_put(tbl->it_group);
> +		BUG_ON(tbl->it_group);
> +	}
> +
>  	if (!tbl || !tbl->it_map) {
>  		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
>  				node_name);
> @@ -876,4 +906,317 @@ void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  }
>  
> +static enum dma_data_direction tce_direction(unsigned long tce)
> +{
> +	if ((tce & TCE_PCI_READ) && (tce & TCE_PCI_WRITE))
> +		return DMA_BIDIRECTIONAL;
> +	else if (tce & TCE_PCI_READ)
> +		return DMA_TO_DEVICE;
> +	else if (tce & TCE_PCI_WRITE)
> +		return DMA_FROM_DEVICE;
> +	else
> +		return DMA_NONE;
> +}
> +
> +void iommu_flush_tce(struct iommu_table *tbl)
> +{
> +	/* Flush/invalidate TLB caches if necessary */
> +	if (ppc_md.tce_flush)
> +		ppc_md.tce_flush(tbl);
> +
> +	/* Make sure updates are seen by hardware */
> +	mb();
> +}
> +EXPORT_SYMBOL_GPL(iommu_flush_tce);
> +
> +static long tce_clear_param_check(struct iommu_table *tbl,
> +		unsigned long ioba, unsigned long tce_value,
> +		unsigned long npages)
> +{
> +	unsigned long size = npages << IOMMU_PAGE_SHIFT;
> +
> +	/* ppc_md.tce_free() does not support any value but 0 */
> +	if (tce_value)
> +		return -EINVAL;
> +
> +	if (ioba & ~IOMMU_PAGE_MASK)
> +		return -EINVAL;
> +
> +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> +			<< IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	return 0;

Why do these all return long (vs int)?  Is this a POWER-ism?

> +}
> +
> +static long tce_put_param_check(struct iommu_table *tbl,
> +		unsigned long ioba, unsigned long tce)
> +{
> +	if (!(tce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return -EINVAL;
> +
> +	if (tce & ~(IOMMU_PAGE_MASK | TCE_PCI_WRITE | TCE_PCI_READ))
> +		return -EINVAL;
> +
> +	if (ioba & ~IOMMU_PAGE_MASK)
> +		return -EINVAL;
> +
> +	if ((ioba + IOMMU_PAGE_SIZE) > ((tbl->it_offset + tbl->it_size)
> +			<< IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static long clear_tce(struct iommu_table *tbl,
> +		unsigned long entry, unsigned long pages)
> +{
> +	unsigned long oldtce;
> +	struct page *page;
> +	struct iommu_pool *pool;
> +
> +	for ( ; pages; --pages, ++entry) {
> +		pool = get_pool(tbl, entry);
> +		spin_lock(&(pool->lock));
> +
> +		oldtce = ppc_md.tce_get(tbl, entry);
> +		if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) {
> +			ppc_md.tce_free(tbl, entry, 1);
> +
> +			page = pfn_to_page(oldtce >> PAGE_SHIFT);
> +			WARN_ON(!page);
> +			if (page) {
> +				if (oldtce & TCE_PCI_WRITE)
> +					SetPageDirty(page);
> +				put_page(page);
> +			}
> +		}
> +		spin_unlock(&(pool->lock));
> +	}
> +
> +	return 0;

No non-zero return, make it void?

> +}
> +
> +long iommu_clear_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	long ret;
> +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> +
> +	ret = tce_clear_param_check(tbl, ioba, tce_value, npages);
> +	if (!ret)
> +		ret = clear_tce(tbl, entry, npages);
> +
> +	if (ret < 0)
> +		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%ld\n",
> +				__func__, ioba, tce_value, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_clear_tce_user_mode);
> +
> +/* hwaddr is a virtual address here, tce_build converts it to physical */
> +static long do_tce_build(struct iommu_table *tbl, unsigned long entry,
> +		unsigned long hwaddr, enum dma_data_direction direction)
> +{
> +	long ret = -EBUSY;
> +	unsigned long oldtce;
> +	struct iommu_pool *pool = get_pool(tbl, entry);
> +
> +	spin_lock(&(pool->lock));
> +
> +	oldtce = ppc_md.tce_get(tbl, entry);
> +	/* Add new entry if it is not busy */
> +	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		ret = ppc_md.tce_build(tbl, entry, 1, hwaddr, direction, NULL);
> +
> +	spin_unlock(&(pool->lock));
> +
> +	if (unlikely(ret))
> +		pr_err("iommu_tce: %s failed on hwaddr=%lx ioba=%lx kva=%lx ret=%ld\n",
> +				__func__, hwaddr, entry << IOMMU_PAGE_SHIFT,
> +				hwaddr, ret);
> +
> +	return ret;
> +}
> +
> +static int put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
> +		unsigned long tce)
> +{
> +	int ret;

Now we're back to returning ints.

> +	struct page *page = NULL;
> +	unsigned long hwaddr, offset = tce & IOMMU_PAGE_MASK & ~PAGE_MASK;
> +	enum dma_data_direction direction = tce_direction(tce);
> +
> +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> +			direction != DMA_TO_DEVICE, &page);
> +	if (unlikely(ret != 1)) {
> +		pr_err("iommu_tce: get_user_pages_fast failed tce=%lx ioba=%lx ret=%d\n",
> +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> +		return -EFAULT;
> +	}
> +	hwaddr = (unsigned long) page_address(page) + offset;
> +
> +	ret = do_tce_build(tbl, entry, hwaddr, direction);
> +	if (ret)
> +		put_page(page);
> +
> +	return ret;
> +}
> +
> +long iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
> +		unsigned long tce)
> +{
> +	long ret;

Oops, back to longs.

> +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> +
> +	ret = tce_put_param_check(tbl, ioba, tce);
> +	if (!ret)
> +		ret = put_tce_user_mode(tbl, entry, tce);
> +
> +	if (ret < 0)
> +		pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
> +				__func__, ioba, tce, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
> +
> +/*
> + * Helpers to do locked pages accounting.
> + * Called from ioctl so down_write_trylock is not necessary.
> + */
> +static void lock_acct(long npage)
> +{
> +	if (!current->mm)
> +		return; /* process exited */
> +
> +	down_write(&current->mm->mmap_sem);
> +	current->mm->locked_vm += npage;
> +	up_write(&current->mm->mmap_sem);
> +}
> +
> +/*
> + * iommu_lock_table - Start/stop using the table by VFIO
> + * @tbl: Pointer to the IOMMU table
> + * @lock: true when VFIO starts using the table
> + */
> +long iommu_lock_table(struct iommu_table *tbl, bool lock)
> +{
> +	unsigned long sz = (tbl->it_size + 7) >> 3;
> +	unsigned long locked, lock_limit;
> +
> +	if (lock) {
> +		/*
> +		 * Account for locked pages
> +		 * The worst case is when every IOMMU page
> +		 * is mapped to separate system page
> +		 */
> +		locked = current->mm->locked_vm + tbl->it_size;
> +		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +		if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> +			pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
> +					rlimit(RLIMIT_MEMLOCK));
> +			return -ENOMEM;
> +		}
> +
> +		if (tbl->it_offset == 0)
> +			clear_bit(0, tbl->it_map);
> +
> +		if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
> +			pr_err("iommu_tce: it_map is not empty");
> +			return -EBUSY;
> +		}
> +
> +		lock_acct(tbl->it_size);
> +		memset(tbl->it_map, 0xff, sz);
> +	}
> +
> +	/* Clear TCE table */
> +	clear_tce(tbl, tbl->it_offset, tbl->it_size);
> +
> +	if (!lock) {
> +		lock_acct(-tbl->it_size);
> +		memset(tbl->it_map, 0, sz);
> +
> +		/* Restore bit#0 set by iommu_init_table() */
> +		if (tbl->it_offset == 0)
> +			set_bit(0, tbl->it_map);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iommu_lock_table);
> +
> +int iommu_add_device(struct device *dev)
> +{
> +	struct iommu_table *tbl;
> +	int ret = 0;
> +
> +	if (WARN_ON(dev->iommu_group)) {
> +		pr_warn("iommu_tce: device %s is already in iommu group %d, skipping\n",
> +				dev_name(dev),
> +				iommu_group_id(dev->iommu_group));
> +		return -EBUSY;
> +	}
> +
> +	tbl = get_iommu_table_base(dev);
> +	if (!tbl) {
> +		pr_debug("iommu_tce: skipping device %s with no tbl\n",
> +				dev_name(dev));
> +		return 0;
> +	}
> +
> +	pr_debug("iommu_tce: adding %s to iommu group %d\n",
> +			dev_name(dev), iommu_group_id(tbl->it_group));
> +
> +	ret = iommu_group_add_device(tbl->it_group, dev);
> +	if (ret < 0)
> +		pr_err("iommu_tce: %s has not been added, ret=%d\n",
> +				dev_name(dev), ret);
> +
> +	return ret;
> +}
> +
> +void iommu_del_device(struct device *dev)
> +{
> +	iommu_group_remove_device(dev);
> +}
> +
> +static int iommu_bus_notifier(struct notifier_block *nb,
> +			      unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		return iommu_add_device(dev);
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		iommu_del_device(dev);
> +		return 0;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static struct notifier_block tce_iommu_bus_nb = {
> +	.notifier_call = iommu_bus_notifier,
> +};
> +
> +static int __init tce_iommu_init(void)
> +{
> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> +
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> +	return 0;
> +}
> +
> +arch_initcall(tce_iommu_init);
> +
>  #endif /* CONFIG_IOMMU_API */
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 8e90e89..04dbc49 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -522,6 +522,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
>  			| TCE_PCI_SWINV_PAIR;
>  	}
>  	iommu_init_table(tbl, phb->hose->node);
> +	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
>  
>  	if (pe->pdev)
>  		set_iommu_table_base(&pe->pdev->dev, tbl);
> diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> index abe6780..7ce75b0 100644
> --- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> +++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> @@ -87,8 +87,11 @@ static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb) { }
>  static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
>  					 struct pci_dev *pdev)
>  {
> -	if (phb->p5ioc2.iommu_table.it_map == NULL)
> +	if (phb->p5ioc2.iommu_table.it_map == NULL) {
>  		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
> +		iommu_register_group(&phb->p5ioc2.iommu_table,
> +				pci_domain_nr(phb->hose->bus), phb->opal_id);
> +	}
>  
>  	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
>  }
> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> index f60a188..d112701 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -20,6 +20,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/msi.h>
> +#include <linux/iommu.h>
>  
>  #include <asm/sections.h>
>  #include <asm/io.h>
> @@ -503,6 +504,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
>  	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
>  				  be32_to_cpup(sizep), 0);
>  	iommu_init_table(tbl, hose->node);
> +	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
>  
>  	/* Deal with SW invalidated TCEs when needed (BML way) */
>  	swinvp = of_get_property(hose->dn, "linux,tce-sw-invalidate-info",
> @@ -631,3 +633,4 @@ void __init pnv_pci_init(void)
>  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
>  #endif
>  }
> +

stray newline

> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index e39f9db..ce6b186 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -187,4 +187,12 @@ config EXYNOS_IOMMU_DEBUG
>  
>  	  Say N unless you need kernel log message for IOMMU debugging
>  
> +config SPAPR_TCE_IOMMU
> +	bool "sPAPR TCE IOMMU Support"
> +	depends on PPC_POWERNV
> +	select IOMMU_API
> +	help
> +	  Enables bits of IOMMU API required by VFIO. The iommu_ops is
> +	  still not implemented.
> +
>  endif # IOMMU_SUPPORT

Looks mostly ok to me other than the minor notes.  As mentioned
previously, this one needs to go in through power maintainers before I
can include 2/2 .  Thanks,

Alex



