Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaJUGig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:38:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60767 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJUGie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:38:34 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/6] uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1413871011-4101-3-git-send-email-ankit.jindal@linaro.org>
Date: Tue, 21 Oct 2014 08:38:23 +0200
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6D33D50E-2DD1-482C-B05E-45B237F3B779@codeaurora.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org> <1413871011-4101-3-git-send-email-ankit.jindal@linaro.org>
To: Ankit Jindal <ankit.jindal@linaro.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 21, 2014, at 7:56 AM, Ankit Jindal <ankit.jindal@linaro.org> wrote:

> Currently, three types of mem regions are supported: UIO_MEM_PHYS,
> UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL. Among these UIO_MEM_PHYS helps
> UIO driver export physcial memory to user space as non-cacheable
> user memory. Typcially memory-mapped registers of a device are exported
> to user space as UIO_MEM_PHYS type mem region. The UIO_MEM_PHYS type
> is not efficient if dma-capable devices are capable of maintaining coherency
> with CPU caches.
> 
> This patch adds new type UIO_MEM_PHYS_CACHE for mem regions to enable
> cacheable access to physical memory from user space.
> 
> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
> ---
> drivers/uio/uio.c          |   11 ++++++++---
> include/linux/uio_driver.h |    1 +
> 2 files changed, 9 insertions(+), 3 deletions(-)

Rather than adding a new type, why not allow the driver to set the pgprot value, this way one has full control and we don’t need to keep adding types for various different cache attributions in the future.

- k

> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 97e6444..120a84b 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -644,7 +644,7 @@ static const struct vm_operations_struct uio_physical_vm_ops = {
> #endif
> };
> 
> -static int uio_mmap_physical(struct vm_area_struct *vma)
> +static int uio_mmap_physical(struct vm_area_struct *vma, bool cacheable)
> {
> 	struct uio_device *idev = vma->vm_private_data;
> 	int mi = uio_find_mem_index(vma);
> @@ -659,7 +659,9 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
> 		return -EINVAL;
> 
> 	vma->vm_ops = &uio_physical_vm_ops;
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +
> +	if (!cacheable)
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> 
> 	/*
> 	 * We cannot use the vm_iomap_memory() helper here,
> @@ -707,10 +709,13 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
> 
> 	switch (idev->info->mem[mi].memtype) {
> 	case UIO_MEM_PHYS:
> -		return uio_mmap_physical(vma);
> +		return uio_mmap_physical(vma, false);
> 	case UIO_MEM_LOGICAL:
> 	case UIO_MEM_VIRTUAL:
> 		return uio_mmap_logical(vma);
> +	case UIO_MEM_PHYS_CACHE:
> +		return uio_mmap_physical(vma, true);
> +
> 	default:
> 		return -EINVAL;
> 	}
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 1ad4724..40ca3f3 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -118,6 +118,7 @@ extern void uio_event_notify(struct uio_info *info);
> #define UIO_MEM_PHYS	1
> #define UIO_MEM_LOGICAL	2
> #define UIO_MEM_VIRTUAL 3
> +#define UIO_MEM_PHYS_CACHE	4
> 
> /* defines for uio_port->porttype */
> #define UIO_PORT_NONE	0
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

