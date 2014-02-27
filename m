Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaB0Oxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:53:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42914 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaB0Oxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:53:49 -0500
Message-ID: <530F51E9.1070703@oracle.com>
Date: Thu, 27 Feb 2014 09:55:37 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: add support for MSI message groups
References: <1393431884-1120-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1393431884-1120-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:24 AM, Roger Pau Monne wrote:
> Add support for MSI message groups for Xen Dom0 using the
> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
>
> In order to keep track of which pirq is the first one in the group all
> pirqs in the MSI group except for the first one have the newly
> introduced PIRQ_MSI_GROUP flag set. This prevents calling
> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
> first pirq in the group.
>
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> ---
> Tested with an Intel ICH8 AHCI SATA controller.
> ---
>   arch/x86/pci/xen.c                   |   29 ++++++++++++++------
>   drivers/xen/events/events_base.c     |   47 +++++++++++++++++++++++-----------
>   drivers/xen/events/events_internal.h |    1 +
>   include/xen/events.h                 |    2 +-
>   include/xen/interface/physdev.h      |    1 +
>   5 files changed, 55 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 103e702..905956f 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -178,6 +178,7 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   	i = 0;
>   	list_for_each_entry(msidesc, &dev->msi_list, list) {
>   		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],
> +					       (type == PCI_CAP_ID_MSI) ? nvec : 1,
>   					       (type == PCI_CAP_ID_MSIX) ?
>   					       "pcifront-msi-x" :
>   					       "pcifront-msi",
> @@ -245,6 +246,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   				"xen: msi already bound to pirq=%d\n", pirq);
>   		}
>   		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,
> +					       (type == PCI_CAP_ID_MSI) ? nvec : 1,
>   					       (type == PCI_CAP_ID_MSIX) ?
>   					       "msi-x" : "msi",
>   					       DOMID_SELF);
> @@ -269,9 +271,6 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   	int ret = 0;
>   	struct msi_desc *msidesc;
>   
> -	if (type == PCI_CAP_ID_MSI && nvec > 1)
> -		return 1;
> -
>   	list_for_each_entry(msidesc, &dev->msi_list, list) {
>   		struct physdev_map_pirq map_irq;
>   		domid_t domid;
> @@ -291,7 +290,10 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   			      (pci_domain_nr(dev->bus) << 16);
>   		map_irq.devfn = dev->devfn;
>   
> -		if (type == PCI_CAP_ID_MSIX) {
> +		if (type == PCI_CAP_ID_MSI && nvec > 1) {
> +			map_irq.type = MAP_PIRQ_TYPE_MULTI_MSI;
> +			map_irq.entry_nr = nvec;


Are we overloading entry_nr here with a different meaning? I thought it 
was meant to be entry number (in MSI-X table for example), not number of 
entries.


> +		} else if (type == PCI_CAP_ID_MSIX) {
>   			int pos;
>   			u32 table_offset, bir;
>   
> @@ -308,6 +310,16 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   		if (pci_seg_supported)
>   			ret = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq,
>   						    &map_irq);
> +		if (type == PCI_CAP_ID_MSI && nvec > 1 && ret) {
> +			/*
> +			 * If MAP_PIRQ_TYPE_MULTI_MSI is not available
> +			 * there's nothing else we can do in this case.
> +			 * Just set ret > 0 so driver can retry with
> +			 * single MSI.
> +			 */
> +			ret = 1;
> +			goto out;
> +		}
>   		if (ret == -EINVAL && !pci_domain_nr(dev->bus)) {
>   			map_irq.type = MAP_PIRQ_TYPE_MSI;
>   			map_irq.index = -1;
> @@ -324,11 +336,10 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>   			goto out;
>   		}
>   
> -		ret = xen_bind_pirq_msi_to_irq(dev, msidesc,
> -					       map_irq.pirq,
> -					       (type == PCI_CAP_ID_MSIX) ?
> -					       "msi-x" : "msi",
> -						domid);
> +		ret = xen_bind_pirq_msi_to_irq(dev, msidesc, map_irq.pirq,
> +		                               (type == PCI_CAP_ID_MSI) ? nvec : 1,
> +		                               (type == PCI_CAP_ID_MSIX) ? "msi-x" : "msi",
> +		                               domid);
>   		if (ret < 0)
>   			goto out;
>   	}
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index f4a9e33..ff20ae2 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -391,10 +391,10 @@ static void xen_irq_init(unsigned irq)
>   	list_add_tail(&info->list, &xen_irq_list_head);
>   }
>   
> -static int __must_check xen_allocate_irq_dynamic(void)
> +static int __must_check xen_allocate_irqs_dynamic(int nvec)
>   {
>   	int first = 0;
> -	int irq;
> +	int i, irq;
>   
>   #ifdef CONFIG_X86_IO_APIC
>   	/*
> @@ -408,14 +408,22 @@ static int __must_check xen_allocate_irq_dynamic(void)
>   		first = get_nr_irqs_gsi();
>   #endif
>   
> -	irq = irq_alloc_desc_from(first, -1);
> +	irq = irq_alloc_descs_from(first, nvec, -1);
>   
> -	if (irq >= 0)
> -		xen_irq_init(irq);
> +	if (irq >= 0) {
> +		for (i = 0; i < nvec; i++)
> +			xen_irq_init(irq + i);
> +	}
>   
>   	return irq;
>   }
>   
> +static inline int __must_check xen_allocate_irq_dynamic(void)
> +{
> +
> +	return xen_allocate_irqs_dynamic(1);
> +}
> +
>   static int __must_check xen_allocate_irq_gsi(unsigned gsi)
>   {
>   	int irq;
> @@ -741,22 +749,25 @@ int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc)
>   }
>   
>   int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> -			     int pirq, const char *name, domid_t domid)
> +			     int pirq, int nvec, const char *name, domid_t domid)
>   {
> -	int irq, ret;
> +	int i, irq, ret;
>   
>   	mutex_lock(&irq_mapping_update_lock);
>   
> -	irq = xen_allocate_irq_dynamic();
> +	irq = xen_allocate_irqs_dynamic(nvec);
>   	if (irq < 0)
>   		goto out;
>   
> -	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
> -			name);
> +	for (i = 0; i < nvec; i++) {
> +		irq_set_chip_and_handler_name(irq + i, &xen_pirq_chip, handle_edge_irq, name);
> +
> +		ret = xen_irq_info_pirq_setup(irq + i, 0, pirq + i, 0, domid,
> +					      i == 0 ? 0 : PIRQ_MSI_GROUP);
> +		if (ret < 0)
> +			goto error_irq;
> +	}
>   
> -	ret = xen_irq_info_pirq_setup(irq, 0, pirq, 0, domid, 0);
> -	if (ret < 0)
> -		goto error_irq;
>   	ret = irq_set_msi_desc(irq, msidesc);
>   	if (ret < 0)
>   		goto error_irq;
> @@ -764,7 +775,8 @@ out:
>   	mutex_unlock(&irq_mapping_update_lock);
>   	return irq;
>   error_irq:
> -	__unbind_from_irq(irq);
> +	for (; i >= 0; i--)
> +		__unbind_from_irq(irq + i);
>   	mutex_unlock(&irq_mapping_update_lock);
>   	return ret;
>   }
> @@ -783,7 +795,12 @@ int xen_destroy_irq(int irq)
>   	if (!desc)
>   		goto out;
>   
> -	if (xen_initial_domain()) {
> +	/*
> +	 * If trying to remove a vector in a MSI group different
> +	 * than the first one skip the PIRQ unmap unless this vector
> +	 * is the first one in the group.
> +	 */
> +	if (xen_initial_domain() && !(info->u.pirq.flags & PIRQ_MSI_GROUP)) {
>   		unmap_irq.pirq = info->u.pirq.pirq;
>   		unmap_irq.domid = info->u.pirq.domid;
>   		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
> diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
> index 677f41a..50c2050a 100644
> --- a/drivers/xen/events/events_internal.h
> +++ b/drivers/xen/events/events_internal.h
> @@ -53,6 +53,7 @@ struct irq_info {
>   
>   #define PIRQ_NEEDS_EOI	(1 << 0)
>   #define PIRQ_SHAREABLE	(1 << 1)
> +#define PIRQ_MSI_GROUP	(1 << 2)
>   
>   struct evtchn_ops {
>   	unsigned (*max_channels)(void);
> diff --git a/include/xen/events.h b/include/xen/events.h
> index c9c85cf..2ae7e03 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -102,7 +102,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
>   int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);
>   /* Bind an PSI pirq to an irq. */
>   int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> -			     int pirq, const char *name, domid_t domid);
> +			     int pirq, int nvec, const char *name, domid_t domid);
>   #endif
>   
>   /* De-allocates the above mentioned physical interrupt. */
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 42721d1..eb13326d 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -131,6 +131,7 @@ struct physdev_irq {
>   #define MAP_PIRQ_TYPE_GSI		0x1
>   #define MAP_PIRQ_TYPE_UNKNOWN		0x2
>   #define MAP_PIRQ_TYPE_MSI_SEG		0x3
> +#define MAP_PIRQ_TYPE_MULTI_MSI		0x4

Formatting.

-boris

>   
>   #define PHYSDEVOP_map_pirq		13
>   struct physdev_map_pirq {

