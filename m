Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553Ab3DHSwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:52:55 -0400
Received: from www.sr71.net ([198.145.64.142]:43172 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762969Ab3DHSwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:52:54 -0400
Message-ID: <51631206.3060605@sr71.net>
Date: Mon, 08 Apr 2013 11:52:54 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3, RFC 31/34] thp: initial implementation of do_huge_linear_fault()
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 04:59 AM, Kirill A. Shutemov wrote:
> +int do_huge_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmd, unsigned int flags)
> +{
> +	unsigned long haddr = address & HPAGE_PMD_MASK;
> +	struct page *cow_page, *page, *dirty_page = NULL;
> +	bool anon = false, fallback = false, page_mkwrite = false;
> +	pgtable_t pgtable = NULL;
> +	struct vm_fault vmf;
> +	int ret;
> +
> +	/* Fallback if vm_pgoff and vm_start are not suitable */
> +	if (((vma->vm_start >> PAGE_SHIFT) & HPAGE_CACHE_INDEX_MASK) !=
> +			(vma->vm_pgoff & HPAGE_CACHE_INDEX_MASK))
> +		return do_fallback(mm, vma, address, pmd, flags);
> +
> +	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
> +		return do_fallback(mm, vma, address, pmd, flags);
> +
> +	if (unlikely(khugepaged_enter(vma)))
> +		return VM_FAULT_OOM;
> +
> +	/*
> +	 * If we do COW later, allocate page before taking lock_page()
> +	 * on the file cache page. This will reduce lock holding time.
> +	 */
> +	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
> +		if (unlikely(anon_vma_prepare(vma)))
> +			return VM_FAULT_OOM;
> +
> +		cow_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
> +				vma, haddr, numa_node_id(), 0);
> +		if (!cow_page) {
> +			count_vm_event(THP_FAULT_FALLBACK);
> +			return do_fallback(mm, vma, address, pmd, flags);
> +		}
> +		count_vm_event(THP_FAULT_ALLOC);
> +		if (mem_cgroup_newpage_charge(cow_page, mm, GFP_KERNEL)) {
> +			page_cache_release(cow_page);
> +			return do_fallback(mm, vma, address, pmd, flags);
> +		}

Ugh.  This is essentially a copy-n-paste of code in __do_fault(),
including the comments.  Is there no way to consolidate the code so that
there's less duplication here?

Part of the reason we have so many bugs in hugetlbfs is that it's really
a forked set of code that does things its own way.  I really hope we're
not going down the road of creating another feature in the same way.

When you copy *this* much code (or any, really), you really need to talk
about it in the patch description.  I was looking at other COW code, and
just happened to stumble on to the __do_fault() code.
