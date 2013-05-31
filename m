Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3EaCdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 22:33:32 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:6383 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3EaCdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 22:33:23 -0400
Message-ID: <51A80BF1.4040408@hp.com>
Date: Thu, 30 May 2013 19:33:21 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, konrad.wilk@oracle.com, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 3/2] vfio: Provide module option to disable vfio_iommu_type1
 hugepage support
References: <20130524171613.14229.84050.stgit@bling.home> <20130528162637.28848.76733.stgit@bling.home>
In-Reply-To: <20130528162637.28848.76733.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/2013 9:27 AM, Alex Williamson wrote:
> Add a module option to vfio_iommu_type1 to disable IOMMU hugepage
> support.  This causes iommu_map to only be called with single page
> mappings, disabling the IOMMU driver's ability to use hugepages.
> This option can be enabled by loading vfio_iommu_type1 with
> disable_hugepages=1 or dynamically through sysfs.  If enabled
> dynamically, only new mappings are restricted.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> As suggested by Konrad.  This is cleaner to add as a follow-on
>
>   drivers/vfio/vfio_iommu_type1.c |   11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6654a7e..8a2be4e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -48,6 +48,12 @@ module_param_named(allow_unsafe_interrupts,
>   MODULE_PARM_DESC(allow_unsafe_interrupts,
>   		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
>   
> +static bool disable_hugepages;
> +module_param_named(disable_hugepages,
> +		   disable_hugepages, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(disable_hugepages,
> +		 "Disable VFIO IOMMU support for IOMMU hugepages.");
> +
>   struct vfio_iommu {
>   	struct iommu_domain	*domain;
>   	struct mutex		lock;
> @@ -270,6 +276,11 @@ static long vfio_pin_pages(unsigned long vaddr, long npage,
>   		return -ENOMEM;
>   	}
>   
> +	if (unlikely(disable_hugepages)) {
> +		vfio_lock_acct(1);
> +		return 1;
> +	}
> +
>   	/* Lock all the consecutive pages from pfn_base */
>   	for (i = 1, vaddr += PAGE_SIZE; i < npage; i++, vaddr += PAGE_SIZE) {
>   		unsigned long pfn = 0;
>
> .
>

Tested-by: Chegu Vinod <chegu_vinod@hp.com>

I was able to verify your changes on a 2 Sandybridge-EP socket platform 
and observed about ~7-8% improvement in the netperf's TCP_RR 
performance.  The guest size was small (16vcpu/32GB).

Hopefully these changes also have an indirect benefit of avoiding soft 
lockups on the host side when larger guests (> 256GB ) are rebooted. 
Someone who has ready access to a larger Sandybridge-EP/EX platform can 
verify this.

FYI
Vinod

