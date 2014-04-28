Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaD1QoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892AbaD1Qn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:43:58 -0400
Message-ID: <1398703421.24318.262.camel@ul30vt.home>
Subject: Re: [RFC PATCH v5 03/11] VFIO_IOMMU_TYPE1 for platform bus devices
 on ARM
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 10:43:41 -0600
In-Reply-To: <1398700371-20096-4-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1398700371-20096-4-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> This allows to make use of the VFIO_IOMMU_TYPE1 driver with platform
> devices on ARM in addition to PCI. This is required in order to use the
> Exynos SMMU, or ARM SMMU driver with VFIO_IOMMU_TYPE1.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/Kconfig            | 2 +-
>  drivers/vfio/vfio_iommu_type1.c | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index af7b204..3a598ed 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -11,7 +11,7 @@ config VFIO_IOMMU_SPAPR_TCE
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	depends on IOMMU_API
> -	select VFIO_IOMMU_TYPE1 if X86
> +	select VFIO_IOMMU_TYPE1 if X86 || ARM
>  	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
>  	select ANON_INODES
>  	help
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1f90344..4dc989d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -30,6 +30,7 @@
>  #include <linux/iommu.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> +#include <linux/pci.h>		/* pci_bus_type */
>  #include <linux/rbtree.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -721,13 +722,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	INIT_LIST_HEAD(&domain->group_list);
>  	list_add(&group->next, &domain->group_list);
>  
> -	if (!allow_unsafe_interrupts &&
> +#ifdef CONFIG_PCI
> +	if (bus == &pci_bus_type && !allow_unsafe_interrupts &&
>  	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
>  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
>  		       __func__);
>  		ret = -EPERM;
>  		goto out_detach;
>  	}
> +#endif
>  
>  	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
>  		domain->prot |= IOMMU_CACHE;

This is not a PCI specific requirement.  Anything that can support MSI
needs an IOMMU that can provide isolation for both DMA and interrupts.
I think the IOMMU should still be telling us that it has this feature.
Thanks,

Alex

