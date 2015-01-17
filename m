Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbbAQACI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:02:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbAQACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:02:05 -0500
Date: Fri, 16 Jan 2015 16:02:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/thp: Allocate transparent hugepages on local node
Message-Id: <20150116160204.544e2bcf9627f5a4043ebf8d@linux-foundation.org>
In-Reply-To: <1421393196-20915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1421393196-20915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 12:56:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> This make sure that we try to allocate hugepages from local node if
> allowed by mempolicy. If we can't, we fallback to small page allocation
> based on mempolicy. This is based on the observation that allocating pages
> on local node is more beneficial than allocating hugepages on remote node.

The changelog is a bit incomplete.  It doesn't describe the current
behaviour, nor what is wrong with it.  What are the before-and-after
effects of this change?

And what might be the user-visible effects?

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2030,6 +2030,46 @@ retry_cpuset:
>  	return page;
>  }
>  
> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
> +				unsigned long addr, int order)

alloc_pages_vma() is nicely documented.  alloc_hugepage_vma() is not
documented at all.  This makes it a bit had for readers to work out the
difference!

Is it possible to scrunch them both into the same function?  Probably
too messy?

> +{
> +	struct page *page;
> +	nodemask_t *nmask;
> +	struct mempolicy *pol;
> +	int node = numa_node_id();
> +	unsigned int cpuset_mems_cookie;
> +
> +retry_cpuset:
> +	pol = get_vma_policy(vma, addr);
> +	cpuset_mems_cookie = read_mems_allowed_begin();
> +
> +	if (pol->mode != MPOL_INTERLEAVE) {
> +		/*
> +		 * For interleave policy, we don't worry about
> +		 * current node. Otherwise if current node is
> +		 * in nodemask, try to allocate hugepage from
> +		 * current node. Don't fall back to other nodes
> +		 * for THP.
> +		 */

This code isn't "interleave policy".  It's everything *but* interleave
policy.  Comment makes no sense!

> +		nmask = policy_nodemask(gfp, pol);
> +		if (!nmask || node_isset(node, *nmask)) {
> +			mpol_cond_put(pol);
> +			page = alloc_pages_exact_node(node, gfp, order);
> +			if (unlikely(!page &&
> +				     read_mems_allowed_retry(cpuset_mems_cookie)))
> +				goto retry_cpuset;
> +			return page;
> +		}
> +	}
> +	mpol_cond_put(pol);
> +	/*
> +	 * if current node is not part of node mask, try
> +	 * the allocation from any node, and we can do retry
> +	 * in that case.
> +	 */
> +	return alloc_pages_vma(gfp, order, vma, addr, node);
> +}

