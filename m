Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaLJXzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:55:07 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47776 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319AbaLJXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:55:04 -0500
Date: Wed, 10 Dec 2014 16:55:00 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com,
        wangyijing@huawei.com, arnd@arndb.de, hanjun.guo@linaro.org,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 2/6] x86, acpi, pci: Move arch-agnostic MMCFG code out of
 arch/x86/ directory
Message-ID: <20141210235500.GA22886@google.com>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
 <1416413091-13452-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416413091-13452-3-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:04:47PM +0100, Tomasz Nowicki wrote:
> MMCFG table seems to be architecture independent and it makes sense
> to share common code across all architectures. The ones that may need
> architectural specific actions have default prototype (__weak).
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> Tested-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/x86/include/asm/pci_x86.h |  29 -----
>  arch/x86/pci/acpi.c            |   1 +
>  arch/x86/pci/init.c            |   1 +
>  arch/x86/pci/mmconfig-shared.c | 200 +---------------------------------
>  arch/x86/pci/mmconfig_32.c     |   1 +
>  arch/x86/pci/mmconfig_64.c     |   1 +
>  drivers/acpi/Makefile          |   1 +
>  drivers/acpi/bus.c             |   1 +
>  drivers/acpi/mmconfig.c        | 242 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mmconfig.h       |  58 ++++++++++
>  include/linux/pci.h            |   8 --
>  11 files changed, 308 insertions(+), 235 deletions(-)
>  create mode 100644 drivers/acpi/mmconfig.c
>  create mode 100644 include/linux/mmconfig.h
> ... 

Much of the code you're moving to drivers/acpi/mmconfig.c is not actually
ACPI-specific and would have to be duplicated for a non-ACPI architecture
that supports ECAM.  Could that code be moved somewhere like
drivers/pci/ecam.c, where it could be shared?

Bjorn

> diff --git a/drivers/acpi/mmconfig.c b/drivers/acpi/mmconfig.c
> new file mode 100644
> index 0000000..d62dccda
> --- /dev/null
> +++ b/drivers/acpi/mmconfig.c
> @@ -0,0 +1,242 @@
> +/*
> + * Arch agnostic low-level direct PCI config space access via MMCONFIG
> + *
> + * Per-architecture code takes care of the mappings, region validation and
> + * accesses themselves.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/rculist.h>
> +#include <linux/mmconfig.h>
> +
> +#define PREFIX "PCI: "
> +
> +static DEFINE_MUTEX(pci_mmcfg_lock);
> +
> +LIST_HEAD(pci_mmcfg_list);
> +
> +static void __init pci_mmconfig_remove(struct pci_mmcfg_region *cfg)
> +{
> +	if (cfg->res.parent)
> +		release_resource(&cfg->res);
> +	list_del(&cfg->list);
> +	kfree(cfg);
> +}
> +
> +void __init free_all_mmcfg(void)
> +{
> +	struct pci_mmcfg_region *cfg, *tmp;
> +
> +	pci_mmcfg_arch_free();
> +	list_for_each_entry_safe(cfg, tmp, &pci_mmcfg_list, list)
> +		pci_mmconfig_remove(cfg);
> +}
> +
> +void list_add_sorted(struct pci_mmcfg_region *new)
> +{
> +	struct pci_mmcfg_region *cfg;
> +
> +	/* keep list sorted by segment and starting bus number */
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
> +		if (cfg->segment > new->segment ||
> +		    (cfg->segment == new->segment &&
> +		     cfg->start_bus >= new->start_bus)) {
> +			list_add_tail_rcu(&new->list, &cfg->list);
> +			return;
> +		}
> +	}
> +	list_add_tail_rcu(&new->list, &pci_mmcfg_list);
> +}
> +
> +struct pci_mmcfg_region *pci_mmconfig_alloc(int segment, int start,
> +					    int end, u64 addr)
> +{
> +	struct pci_mmcfg_region *new;
> +	struct resource *res;
> +
> +	if (addr == 0)
> +		return NULL;
> +
> +	new = kzalloc(sizeof(*new), GFP_KERNEL);
> +	if (!new)
> +		return NULL;
> +
> +	new->address = addr;
> +	new->segment = segment;
> +	new->start_bus = start;
> +	new->end_bus = end;
> +
> +	res = &new->res;
> +	res->start = addr + PCI_MMCFG_BUS_OFFSET(start);
> +	res->end = addr + PCI_MMCFG_BUS_OFFSET(end + 1) - 1;
> +	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +	snprintf(new->name, PCI_MMCFG_RESOURCE_NAME_LEN,
> +		 "PCI MMCONFIG %04x [bus %02x-%02x]", segment, start, end);
> +	res->name = new->name;
> +
> +	return new;
> +}
> +
> +struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
> +					  int end, u64 addr)
> +{
> +	struct pci_mmcfg_region *new;
> +
> +	new = pci_mmconfig_alloc(segment, start, end, addr);
> +	if (new) {
> +		mutex_lock(&pci_mmcfg_lock);
> +		list_add_sorted(new);
> +		mutex_unlock(&pci_mmcfg_lock);
> +
> +		pr_info(PREFIX
> +		       "MMCONFIG for domain %04x [bus %02x-%02x] at %pR "
> +		       "(base %#lx)\n",
> +		       segment, start, end, &new->res, (unsigned long)addr);
> +	}
> +
> +	return new;
> +}
> +
> +int __init pci_mmconfig_inject(struct pci_mmcfg_region *cfg)
> +{
> +	struct pci_mmcfg_region *cfg_conflict;
> +	int err = 0;
> +
> +	mutex_lock(&pci_mmcfg_lock);
> +	cfg_conflict = pci_mmconfig_lookup(cfg->segment, cfg->start_bus);
> +	if (cfg_conflict) {
> +		if (cfg_conflict->end_bus < cfg->end_bus)
> +			pr_info(FW_INFO "MMCONFIG for "
> +				"domain %04x [bus %02x-%02x] "
> +				"only partially covers this bridge\n",
> +				cfg_conflict->segment, cfg_conflict->start_bus,
> +				cfg_conflict->end_bus);
> +		err = -EEXIST;
> +		goto out;
> +	}
> +
> +	if (pci_mmcfg_arch_map(cfg)) {
> +		pr_warn("fail to map MMCONFIG %pR.\n", &cfg->res);
> +		err = -ENOMEM;
> +		goto out;
> +	} else {
> +		list_add_sorted(cfg);
> +		pr_info("MMCONFIG at %pR (base %#lx)\n",
> +			&cfg->res, (unsigned long)cfg->address);
> +
> +	}
> +out:
> +	mutex_unlock(&pci_mmcfg_lock);
> +	return err;
> +}
> +
> +struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
> +{
> +	struct pci_mmcfg_region *cfg;
> +
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +		if (cfg->segment == segment &&
> +		    cfg->start_bus <= bus && bus <= cfg->end_bus)
> +			return cfg;
> +
> +	return NULL;
> +}
> +
> +int __init __weak acpi_mcfg_check_entry(struct acpi_table_mcfg *mcfg,
> +					struct acpi_mcfg_allocation *cfg)
> +{
> +	return 0;
> +}
> +
> +int __init pci_parse_mcfg(struct acpi_table_header *header)
> +{
> +	struct acpi_table_mcfg *mcfg;
> +	struct acpi_mcfg_allocation *cfg_table, *cfg;
> +	unsigned long i;
> +	int entries;
> +
> +	if (!header)
> +		return -EINVAL;
> +
> +	mcfg = (struct acpi_table_mcfg *)header;
> +
> +	/* how many config structures do we have */
> +	free_all_mmcfg();
> +	entries = 0;
> +	i = header->length - sizeof(struct acpi_table_mcfg);
> +	while (i >= sizeof(struct acpi_mcfg_allocation)) {
> +		entries++;
> +		i -= sizeof(struct acpi_mcfg_allocation);
> +	}
> +	if (entries == 0) {
> +		pr_err(PREFIX "MMCONFIG has no entries\n");
> +		return -ENODEV;
> +	}
> +
> +	cfg_table = (struct acpi_mcfg_allocation *) &mcfg[1];
> +	for (i = 0; i < entries; i++) {
> +		cfg = &cfg_table[i];
> +		if (acpi_mcfg_check_entry(mcfg, cfg)) {
> +			free_all_mmcfg();
> +			return -ENODEV;
> +		}
> +
> +		if (pci_mmconfig_add(cfg->pci_segment, cfg->start_bus_number,
> +				   cfg->end_bus_number, cfg->address) == NULL) {
> +			pr_warn(PREFIX "no memory for MCFG entries\n");
> +			free_all_mmcfg();
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* Delete MMCFG information for host bridges */
> +int pci_mmconfig_delete(u16 seg, u8 start, u8 end)
> +{
> +	struct pci_mmcfg_region *cfg;
> +
> +	mutex_lock(&pci_mmcfg_lock);
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +		if (cfg->segment == seg && cfg->start_bus == start &&
> +		    cfg->end_bus == end) {
> +			list_del_rcu(&cfg->list);
> +			synchronize_rcu();
> +			pci_mmcfg_arch_unmap(cfg);
> +			if (cfg->res.parent)
> +				release_resource(&cfg->res);
> +			mutex_unlock(&pci_mmcfg_lock);
> +			kfree(cfg);
> +			return 0;
> +		}
> +	mutex_unlock(&pci_mmcfg_lock);
> +
> +	return -ENOENT;
> +}
> +
> +void __init __weak pci_mmcfg_early_init(void)
> +{
> +
> +}
> +
> +void __init __weak pci_mmcfg_late_init(void)
> +{
> +	struct pci_mmcfg_region *cfg;
> +
> +	acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> +
> +	if (list_empty(&pci_mmcfg_list))
> +		return;
> +
> +	if (!pci_mmcfg_arch_init())
> +		free_all_mmcfg();
> +
> +	list_for_each_entry(cfg, &pci_mmcfg_list, list)
> +		insert_resource(&iomem_resource, &cfg->res);
> +}
> diff --git a/include/linux/mmconfig.h b/include/linux/mmconfig.h
> new file mode 100644
> index 0000000..6ccd1ee
> --- /dev/null
> +++ b/include/linux/mmconfig.h
> @@ -0,0 +1,58 @@
> +#ifndef __MMCONFIG_H
> +#define __MMCONFIG_H
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +#include <linux/acpi.h>
> +
> +#ifdef CONFIG_PCI_MMCONFIG
> +/* "PCI MMCONFIG %04x [bus %02x-%02x]" */
> +#define PCI_MMCFG_RESOURCE_NAME_LEN (22 + 4 + 2 + 2)
> +
> +struct pci_mmcfg_region {
> +	struct list_head list;
> +	struct resource res;
> +	u64 address;
> +	char __iomem *virt;
> +	u16 segment;
> +	u8 start_bus;
> +	u8 end_bus;
> +	char name[PCI_MMCFG_RESOURCE_NAME_LEN];
> +};
> +
> +void pci_mmcfg_early_init(void);
> +void pci_mmcfg_late_init(void);
> +struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus);
> +
> +int pci_parse_mcfg(struct acpi_table_header *header);
> +struct pci_mmcfg_region *pci_mmconfig_alloc(int segment, int start,
> +						   int end, u64 addr);
> +int pci_mmconfig_inject(struct pci_mmcfg_region *cfg);
> +struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
> +						 int end, u64 addr);
> +void list_add_sorted(struct pci_mmcfg_region *new);
> +int acpi_mcfg_check_entry(struct acpi_table_mcfg *mcfg,
> +			  struct acpi_mcfg_allocation *cfg);
> +void free_all_mmcfg(void);
> +int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
> +		       phys_addr_t addr);
> +int pci_mmconfig_delete(u16 seg, u8 start, u8 end);
> +
> +/* Arch specific calls */
> +int pci_mmcfg_arch_init(void);
> +void pci_mmcfg_arch_free(void);
> +int pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg);
> +void pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg);
> +
> +extern struct list_head pci_mmcfg_list;
> +
> +#define PCI_MMCFG_BUS_OFFSET(bus)      ((bus) << 20)
> +#else /* CONFIG_PCI_MMCONFIG */
> +static inline void pci_mmcfg_late_init(void) { }
> +static inline void pci_mmcfg_early_init(void) { }
> +static inline void *pci_mmconfig_lookup(int segment, int bus)
> +{ return NULL; }
> +#endif /* CONFIG_PCI_MMCONFIG */
> +
> +#endif  /* __KERNEL__ */
> +#endif  /* __MMCONFIG_H */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 6afba72..0a8b82e 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1658,14 +1658,6 @@ void pcibios_release_device(struct pci_dev *dev);
>  extern struct dev_pm_ops pcibios_pm_ops;
>  #endif
>  
> -#ifdef CONFIG_PCI_MMCONFIG
> -void __init pci_mmcfg_early_init(void);
> -void __init pci_mmcfg_late_init(void);
> -#else
> -static inline void pci_mmcfg_early_init(void) { }
> -static inline void pci_mmcfg_late_init(void) { }
> -#endif
> -
>  int pci_ext_cfg_avail(void);
>  
>  void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
> -- 
> 1.9.1
> 
