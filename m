Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaGMOdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:33:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54621 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaGMOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:32:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <53C2984E.4010400@jp.fujitsu.com>
Date: Sun, 13 Jul 2014 23:31:42 +0900
From: =?ISO-2022-JP?B?IkhhdGF5YW1hLCBEYWlzdWtlLxskQkgqOzMbKEIgGyRCQmdKZRsoQg==?=
	 =?ISO-2022-JP?B?Ig==?= <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mmap_vmcore: skip non-ram pages reported by hypervisors
References: <1405068552-19453-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405068552-19453-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delayed responce...

(2014/07/11 17:49), Vitaly Kuznetsov wrote:
> We have a special check in read_vmcore() handler to check if the page was
> reported as ram or not by the hypervisor (pfn_is_ram()). However, when
> vmcore is read with mmap() no such check is performed. That can lead to
> unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
> mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
> enormous load in both DomU and Dom0.
> 
> Fix the issue by mapping each non-ram page to the zero page. Keep direct
> path with remap_oldmem_pfn_range() to avoid looping through all pages on
> bare metal.
> 
> The issue can also be solved by overriding remap_oldmem_pfn_range() in
> xen-specific code, as remap_oldmem_pfn_range() was been designed for.
> That, however, would involve non-obvious xen code path for all x86 builds
> with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
> code on x86 arch from doing the same override.
> 
> Changes from v3:
> - multi line comment style changes
> - minor code style changes
> 
> Changes from v2:
> - make remap_oldmem_pfn_checked() interface exactly match
>    remap_oldmem_pfn_range()
> - unmap mapped part inside remap_oldmem_pfn_checked() in case of failure so
>    we don't need to take care of it in mmap_vmcore()
> - create vmcore_remap_oldmem_pfn() wrapper
> 
> Changes from v1:
> - comment style changes
> - change remap_oldmem_pfn_checked() interface to closer match the
>    remap_oldmem_pfn() interface
> - preserve formal parameters within the loop, make the loop conditions
>    easier to understand
> - use my_zero_pfn() for the zero page
> - return remapped length instead of new offset
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>   fs/proc/vmcore.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 80 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 382aa89..405a409 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -328,6 +328,83 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
>    * virtually contiguous user-space in ELF layout.
>    */
>   #ifdef CONFIG_MMU
> +/*
> + * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
> + * reported as not being ram with the zero page.
> + *
> + * @vma: vm_area_struct describing requested mapping
> + * @from: start remapping from
> + * @pfn: page frame number to start remapping to
> + * @size: remapping size
> + * @prot: protection bits
> + *
> + * Returns zero on success, -EAGAIN on failure.
> + */
> +int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
> +			     unsigned long pfn, unsigned long size,
> +			     pgprot_t prot)
> +{
> +	size_t map_size;

unsigned long is better? At least all the occurences of this variable in
this function is used as unsigned long.

> +	unsigned long pos_start, pos_end, pos;
> +	unsigned long zeropage_pfn = my_zero_pfn(0);
> +	u64 len = 0;
> +
> +	pos_start = pfn;
> +	pos_end = pfn + (size >> PAGE_SHIFT);
> +
> +	for (pos = pos_start; pos < pos_end; ++pos) {
> +		if (!pfn_is_ram(pos)) {
> +			/*
> +			 * We hit a page which is not ram. Remap the continuous
> +			 * region between pos_start and pos-1 and replace
> +			 * the non-ram page at pos with the zero page.
> +			 */
> +			if (pos > pos_start) {
> +				/* Remap continuous region */
> +				map_size = (pos - pos_start) << PAGE_SHIFT;
> +				if (remap_oldmem_pfn_range(vma, from + len,
> +							   pos_start, map_size,
> +							   prot))
> +					goto fail;
> +				len += map_size;
> +			}
> +			/* Remap the zero page */
> +			if (remap_oldmem_pfn_range(vma, from + len,
> +						   zeropage_pfn,
> +						   PAGE_SIZE, prot))
> +				goto fail;
> +			len += PAGE_SIZE;
> +			pos_start = pos + 1;
> +		}
> +	}
> +	if (pos > pos_start) {
> +		/* Remap the rest */
> +		map_size = (pos - pos_start) << PAGE_SHIFT;
> +		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
> +					   map_size, vma->vm_page_prot))

                                                  Is prot correct here?

> +			goto fail;
> +		len += map_size;
> +	}
> +	return 0;
> +fail:
> +	do_munmap(vma->vm_mm, from, len);
> +	return -EAGAIN;
> +}
> +
> +int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
> +			    unsigned long from, unsigned long pfn,
> +			    unsigned long size, pgprot_t prot)
> +{
> +	/*
> +	 * Check if oldmem_pfn_is_ram was registered to avoid
> +	 * looping over all pages without a reason.
> +	 */
> +	if (oldmem_pfn_is_ram)
> +		return remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
> +	else
> +		return remap_oldmem_pfn_range(vma, from, pfn, size, prot);
> +}
> +
>   static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>   {
>   	size_t size = vma->vm_end - vma->vm_start;
> @@ -387,9 +464,9 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>   
>   			tsz = min_t(size_t, m->offset + m->size - start, size);
>   			paddr = m->paddr + start - m->offset;
> -			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
> -						   paddr >> PAGE_SHIFT, tsz,
> -						   vma->vm_page_prot))
> +			if (vmcore_remap_oldmem_pfn(vma, vma->vm_start + len,
> +						    paddr >> PAGE_SHIFT, tsz,
> +						    vma->vm_page_prot))
>   				goto fail;
>   			size -= tsz;
>   			start += tsz;
> 

It looks to me good other than the above two comments.

Thanks.
HATAYAMA, Daisuke

