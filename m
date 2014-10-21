Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaJUUYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbaJUUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:24:48 -0400
Message-ID: <1413923075.4202.186.camel@ul30vt.home>
Subject: Re: [PATCH linux-next] vfio: make vfio build and run on s390
From: Alex Williamson <alex.williamson@redhat.com>
To: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, kvm@vger.kernel.org, agraf@suse.de
Date: Tue, 21 Oct 2014 14:24:35 -0600
In-Reply-To: <1413893068-45404-1-git-send-email-blaschka@linux.vnet.ibm.com>
References: <1413893068-45404-1-git-send-email-blaschka@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 14:04 +0200, Frank Blaschka wrote:
> Introduce platform functions to let vfio announce if INTx is available and
> if PCI BARs are mapable. Also take care vfio_pci_vga_rw is building on
> platforms which do not support I/O ports.
> 
> Signed-off-by: Frank Blaschka <blaschka@linux.vnet.ibm.com>
> ---
>  arch/s390/include/asm/pci.h      |  3 +++
>  drivers/vfio/Kconfig             |  2 +-
>  drivers/vfio/pci/vfio_pci.c      | 33 ++++++++++++++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_rdwr.c |  4 ++++
>  4 files changed, 36 insertions(+), 6 deletions(-)

Arnd Bergmann sent me a patch [1] recently that clued me in to the
IS_ENABLED() build time check that I wonder if if might be more
appropriate here.  I think it could certainly make for cleaner code.

[1] https://lkml.org/lkml/2014/10/9/82

> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 6790d0d..0ca2008 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -12,6 +12,9 @@
>  #include <asm/pci_clp.h>
>  #include <asm/pci_debug.h>
>  
> +#define __ARCH_PCI_NO_BARMAP
> +#define __ARCH_PCI_NO_INTX
> +

We'd drop this

>  #define PCIBIOS_MIN_IO		0x1000
>  #define PCIBIOS_MIN_MEM		0x10000000
>  
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index d8c5763..b93c259 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -16,7 +16,7 @@ config VFIO_SPAPR_EEH
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	depends on IOMMU_API
> -	select VFIO_IOMMU_TYPE1 if X86
> +	select VFIO_IOMMU_TYPE1 if (X86 || S390)
>  	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
>  	select VFIO_SPAPR_EEH if (PPC_POWERNV || PPC_PSERIES)
>  	select ANON_INODES

In drivers/vfio/pci/Kconfig we'd also add something like:

config VFIO_PCI_MMAP
	depends on VFIO_PCI
	def_bool y if !S390

config VFIO_PCI_INTX
	depends on VFIO_PCI
	def_bool y if !S390

These should not be visible config items

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 9558da3..808072f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -210,12 +210,25 @@ error:
>  	return ret;
>  }
>  
> +static int vfio_pci_intx_available(struct pci_dev *pdev)
> +{
> +#ifdef __ARCH_PCI_NO_INTX
> +	return 0;
> +#else
> +	u8 pin;
> +	int rc = 0;
> +
> +	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> +	if (pin)
> +		rc = 1;
> +	return rc;
> +#endif
> +}

This could then be:

static int vfio_pci_intx_available(struct pci_dev *pdev)
{
	u8 pin;

	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
	if (IS_ENABLED(CONFIG_VFIO_PCI_INTX) && pin)
		return 1;

	return 0;
}
> +
>  static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
>  {
>  	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
> -		u8 pin;
> -		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
> -		if (pin)
> +		if (vfio_pci_intx_available(vdev->pdev))
>  			return 1;
>  
>  	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
> @@ -350,6 +363,16 @@ static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
>  	return walk.ret;
>  }
>  
> +static int vfio_pci_bar_mapable(struct pci_dev *pdev, __u32 index, __u64 size)
> +{
> +#ifdef __ARCH_PCI_NO_BARMAP
> +	return 0;
> +#else
> +	return (pci_resource_flags(pdev, index) &
> +		IORESOURCE_MEM && size >= PAGE_SIZE);
> +#endif
> +}
> +

And here it would just be another test:

return (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
	  pci_resource_flags(pdev, index) & IORESOURCE_MEM &&
	  size >= PAGE_SIZE);

For both of these I'm not sure the separate function is really
necessary.

>  static long vfio_pci_ioctl(void *device_data,
>  			   unsigned int cmd, unsigned long arg)
>  {
> @@ -406,9 +429,9 @@ static long vfio_pci_ioctl(void *device_data,
>  
>  			info.flags = VFIO_REGION_INFO_FLAG_READ |
>  				     VFIO_REGION_INFO_FLAG_WRITE;
> -			if (pci_resource_flags(pdev, info.index) &
> -			    IORESOURCE_MEM && info.size >= PAGE_SIZE)
> +			if (vfio_pci_bar_mapable(pdev, info.index, info.size))
>  				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
> +
>  			break;
>  		case VFIO_PCI_ROM_REGION_INDEX:
>  		{
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 210db24..02c5623 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -180,6 +180,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
>  ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			       size_t count, loff_t *ppos, bool iswrite)
>  {
> +#ifdef CONFIG_NO_IOPORT_MAP
> +	return -EINVAL;
> +#else
>  	int ret;
>  	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
>  	void __iomem *iomem = NULL;
> @@ -235,4 +238,5 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>  		*ppos += done;
>  
>  	return done;
> +#endif


Here we could use:

	if (!IS_ENABLED(CONFIG_VFIO_PCI_VGA) || !vdev->has_vga)
                return -EINVAL;

A better option for this one would still probably be for s390 to stub
out the missing io* calls.  Thanks,

Alex

