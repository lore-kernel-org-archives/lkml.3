Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbbAWX7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:59:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46669 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbbAWX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:59:16 -0500
Date: Fri, 23 Jan 2015 17:59:11 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH v3 2/2] arm: kernel: fix pci_mmap_page_range() offset
 calculation
Message-ID: <20150123235911.GG13072@google.com>
References: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1415877558-8906-3-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415877558-8906-3-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:19:16AM +0000, Lorenzo Pieralisi wrote:
> The pci_mmap_page_range() API should be written to expect offset
> values representing PCI memory resource addresses as seen by user
> space, through the pci_resource_to_user() API.
> 
> ARM relies on the standard implementation of pci_resource_to_user()
> which actually is an identity map and exports to user space
> PCI memory resources as they are stored in PCI devices resources
> structures, which represent CPU physical addresses (fixed-up using
> BUS to CPU address conversions) not PCI bus addresses.
> 
> Therefore, on ARM platforms where the mapping between CPU and BUS
> address is not a 1:1 the current pci_mmap_page_range() implementation is
> erroneous, in that an additional shift is applied to an already fixed-up
> offset passed from userspace.
> 
> Hence, this patch removes the mem_offset from the pgoff calculation
> since the offset as passed from user space already represents the CPU
> physical address corresponding to the resource to be mapped, ie no
> additional offset should be applied.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  arch/arm/kernel/bios32.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..b56fa2d 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -626,21 +626,15 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
>  int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
>  			enum pci_mmap_state mmap_state, int write_combine)
>  {
> -	struct pci_sys_data *root = dev->sysdata;
> -	unsigned long phys;
> -
> -	if (mmap_state == pci_mmap_io) {
> +	if (mmap_state == pci_mmap_io)
>  		return -EINVAL;
> -	} else {
> -		phys = vma->vm_pgoff + (root->mem_offset >> PAGE_SHIFT);
> -	}
>  
>  	/*
>  	 * Mark this as IO
>  	 */
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  
> -	if (remap_pfn_range(vma, vma->vm_start, phys,
> +	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>  			     vma->vm_end - vma->vm_start,
>  			     vma->vm_page_prot))
>  		return -EAGAIN;
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
