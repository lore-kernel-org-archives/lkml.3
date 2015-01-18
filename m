Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbbARPtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:49:00 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58550 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbARPs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:48:58 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/thp: Allocate transparent hugepages on local node
In-Reply-To: <20150116160204.544e2bcf9627f5a4043ebf8d@linux-foundation.org>
References: <1421393196-20915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20150116160204.544e2bcf9627f5a4043ebf8d@linux-foundation.org>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Sun, 18 Jan 2015 21:18:50 +0530
Message-ID: <871tms3x99.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011815-0017-0000-0000-00000350D9FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 16 Jan 2015 12:56:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>
>> This make sure that we try to allocate hugepages from local node if
>> allowed by mempolicy. If we can't, we fallback to small page allocation
>> based on mempolicy. This is based on the observation that allocating pages
>> on local node is more beneficial than allocating hugepages on remote node.
>
> The changelog is a bit incomplete.  It doesn't describe the current
> behaviour, nor what is wrong with it.  What are the before-and-after
> effects of this change?
>
> And what might be the user-visible effects?

How about ?

With this patch applied we may find transparent huge page allocation
failures if the current node doesn't have enough freee hugepages.
Before this patch such failures result in us retrying the allocation on
other nodes in the numa node mask.


>
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -2030,6 +2030,46 @@ retry_cpuset:
>>  	return page;
>>  }
>>  
>> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>> +				unsigned long addr, int order)
>
> alloc_pages_vma() is nicely documented.  alloc_hugepage_vma() is not
> documented at all.  This makes it a bit had for readers to work out the
> difference!
>
> Is it possible to scrunch them both into the same function?  Probably
> too messy?


/**
 * alloc_hugepage_vma: Allocate a hugepage for a VMA
 * @gfp:
 *   %GFP_USER	  user allocation.
 *   %GFP_KERNEL  kernel allocations,
 *   %GFP_HIGHMEM highmem/user allocations,
 *   %GFP_FS	  allocation should not call back into a file system.
 *   %GFP_ATOMIC  don't sleep.
 *
 * @vma:   Pointer to VMA or NULL if not available.
 * @addr:  Virtual Address of the allocation. Must be inside the VMA.
 * @order: Order of the hugepage for gfp allocation.
 *
 * This functions allocate a huge page from the kernel page pool and applies
 * a NUMA policy associated with the VMA or the current process.
 * For policy other than %MPOL_INTERLEAVE, we make sure we allocate hugepage
 * only from the current node if the current node is part of the node mask.
 * If we can't allocate a hugepage we fail the allocation and don' try to fallback
 * to other nodes in the node mask. If the current node is not part of node mask
 * or if the NUMA policy is MPOL_INTERLEAVE we use the allocator that can
 * fallback to nodes in the policy node mask.
 *
 * When VMA is not NULL caller must hold down_read on the mmap_sem of the
 * mm_struct of the VMA to prevent it from going away. Should be used for
 * all allocations for pages that will be mapped into
 * user space. Returns NULL when no page can be allocated.
 *
 * Should be called with the mm_sem of the vma hold.
 */

>
>> +{
>> +	struct page *page;
>> +	nodemask_t *nmask;
>> +	struct mempolicy *pol;
>> +	int node = numa_node_id();
>> +	unsigned int cpuset_mems_cookie;
>> +
>> +retry_cpuset:
>> +	pol = get_vma_policy(vma, addr);
>> +	cpuset_mems_cookie = read_mems_allowed_begin();
>> +
>> +	if (pol->mode != MPOL_INTERLEAVE) {
>> +		/*
>> +		 * For interleave policy, we don't worry about
>> +		 * current node. Otherwise if current node is
>> +		 * in nodemask, try to allocate hugepage from
>> +		 * current node. Don't fall back to other nodes
>> +		 * for THP.
>> +		 */
>
> This code isn't "interleave policy".  It's everything *but* interleave
> policy.  Comment makes no sense!
>

I moved the comment before the if check

struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
				unsigned long addr, int order)
{
	struct page *page;
	nodemask_t *nmask;
	struct mempolicy *pol;
	int node = numa_node_id();
	unsigned int cpuset_mems_cookie;

retry_cpuset:
	pol = get_vma_policy(vma, addr);
	cpuset_mems_cookie = read_mems_allowed_begin();
	/*
	 * For interleave policy, we don't worry about
	 * current node. Otherwise if current node is
	 * in nodemask, try to allocate hugepage from
	 * the current node. Don't fall back to other nodes
	 * for THP.
	 */
	if (pol->mode == MPOL_INTERLEAVE)
		goto alloc_with_fallback;
	nmask = policy_nodemask(gfp, pol);
	if (!nmask || node_isset(node, *nmask)) {
		mpol_cond_put(pol);
		page = alloc_pages_exact_node(node, gfp, order);
		if (unlikely(!page &&
			     read_mems_allowed_retry(cpuset_mems_cookie)))
			goto retry_cpuset;
		return page;
	}
alloc_with_fallback:
	mpol_cond_put(pol);
	/*
	 * if current node is not part of node mask, try
	 * the allocation from any node, and we can do retry
	 * in that case.
	 */
	return alloc_pages_vma(gfp, order, vma, addr, node);
}

