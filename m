Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852Ab3E1Qm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:42:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934805Ab3E1QmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:42:25 -0400
Date: Tue, 28 May 2013 12:42:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, chegu_vinod@hp.com
Subject: Re: [PATCH 3/2] vfio: Provide module option to disable
 vfio_iommu_type1 hugepage support
Message-ID: <20130528164214.GC6073@phenom.dumpdata.com>
References: <20130524171613.14229.84050.stgit@bling.home>
 <20130528162637.28848.76733.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528162637.28848.76733.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:27:52AM -0600, Alex Williamson wrote:
> Add a module option to vfio_iommu_type1 to disable IOMMU hugepage
> support.  This causes iommu_map to only be called with single page
> mappings, disabling the IOMMU driver's ability to use hugepages.
> This option can be enabled by loading vfio_iommu_type1 with
> disable_hugepages=1 or dynamically through sysfs.  If enabled
> dynamically, only new mappings are restricted.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---

> 
> As suggested by Konrad.  This is cleaner to add as a follow-on
> 
>  drivers/vfio/vfio_iommu_type1.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6654a7e..8a2be4e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -48,6 +48,12 @@ module_param_named(allow_unsafe_interrupts,
>  MODULE_PARM_DESC(allow_unsafe_interrupts,
>  		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
>  
> +static bool disable_hugepages;
> +module_param_named(disable_hugepages,
> +		   disable_hugepages, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(disable_hugepages,
> +		 "Disable VFIO IOMMU support for IOMMU hugepages.");
> +
>  struct vfio_iommu {
>  	struct iommu_domain	*domain;
>  	struct mutex		lock;
> @@ -270,6 +276,11 @@ static long vfio_pin_pages(unsigned long vaddr, long npage,
>  		return -ENOMEM;
>  	}
>  
> +	if (unlikely(disable_hugepages)) {
> +		vfio_lock_acct(1);
> +		return 1;
> +	}
> +
>  	/* Lock all the consecutive pages from pfn_base */
>  	for (i = 1, vaddr += PAGE_SIZE; i < npage; i++, vaddr += PAGE_SIZE) {
>  		unsigned long pfn = 0;
> 
