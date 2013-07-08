Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3GHFca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:32:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40256 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3GHFc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:32:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51DA4ED9.60903@jp.fujitsu.com>
Date: Mon, 08 Jul 2013 14:32:09 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
In-Reply-To: <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/02 4:32), Michael Holzheu wrote:
> For zfcpdump we can't map the HSA storage because it is only available
> via a read interface. Therefore, for the new vmcore mmap feature we have
> introduce a new mechanism to create mappings on demand.
>
> This patch introduces a new architecture function remap_oldmem_pfn_range()
> that should be used to create mappings with remap_pfn_range() for oldmem
> areas that can be directly mapped. For zfcpdump this is everything besides
> of the HSA memory. For the areas that are not mapped by remap_oldmem_pfn_range()
> a generic vmcore a new generic vmcore fault handler mmap_vmcore_fault()
> is called.
>

This fault handler is only for s390 specific issue. Other architectures don't need
this for the time being.

Also, from the same reason, I'm doing this review based on source code only.
I cannot run the fault handler on meaningful system, which is currently s390 only.

I'm also concerned about the fault handler covers a full range of vmcore, which
could hide some kind of mmap() bug that results in page fault.

So, the fault handler should be enclosed by ifdef CONFIG_S390 for the time being.

> This handler works as follows:
>
> * Get already available or new page from page cache (find_or_create_page)
> * Check if /proc/vmcore page is filled with data (PageUptodate)
> * If yes:
>    Return that page
> * If no:
>    Fill page using __vmcore_read(), set PageUptodate, and return page
>

It seems good to me on this page-in logic.

<cut>
> @@ -225,6 +250,48 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>   	return acc;
>   }
>
> +static ssize_t read_vmcore(struct file *file, char __user *buffer,
> +			   size_t buflen, loff_t *fpos)
> +{
> +	return __read_vmcore(buffer, buflen, fpos, 1);
> +}
> +
> +/*
> + * The vmcore fault handler uses the page cache and fills data using the
> + * standard __vmcore_read() function.
> + */

Could you describe usecase of this fault handler on s390?

> +static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	struct address_space *mapping = vma->vm_file->f_mapping;
> +	pgoff_t index = vmf->pgoff;
> +	struct page *page;
> +	loff_t src;
> +	char *buf;
> +	int rc;
> +

You should check where faulting address points to valid range.
If the fault happens on invalid range, return VM_FAULT_SIGBUS.

On s390 case, I think the range except for HSA should be thought of as invalid.

> +	page = find_or_create_page(mapping, index, GFP_KERNEL);
> +	if (!page)
> +		return VM_FAULT_OOM;
> +	if (!PageUptodate(page)) {
> +		src = index << PAGE_CACHE_SHIFT;

src = (loff_t)index << PAGE_CACHE_SHIFT;

loff_t has long long while index has unsigned long.
On s390 both might have the same byte length.

Also I prefer offset to src, but this is minor suggestion.

> +		buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);

I found page_to_virt() macro.

> +		rc = __read_vmcore(buf, PAGE_SIZE, &src, 0);
> +		if (rc < 0) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			return (rc == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
> +		}
> +		SetPageUptodate(page);
> +	}
> +	unlock_page(page);
> +	vmf->page = page;
> +	return 0;
> +}
> +
> +static const struct vm_operations_struct vmcore_mmap_ops = {
> +	.fault = mmap_vmcore_fault,
> +};
> +
>   static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>   {
>   	size_t size = vma->vm_end - vma->vm_start;
> @@ -242,6 +309,7 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>
>   	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
>   	vma->vm_flags |= VM_MIXEDMAP;
> +	vma->vm_ops = &vmcore_mmap_ops;
>
>   	len = 0;
>

-- 
Thanks.
HATAYAMA, Daisuke

