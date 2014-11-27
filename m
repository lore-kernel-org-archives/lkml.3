Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaK0GdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:33:13 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43050 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaK0GdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:33:10 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/thp: Always allocate transparent hugepages on local node
In-Reply-To: <alpine.DEB.2.10.1411241317430.21237@chino.kir.corp.google.com>
References: <1416838791-30023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141124150342.GA3889@node.dhcp.inet.fi> <alpine.DEB.2.10.1411241317430.21237@chino.kir.corp.google.com>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Thu, 27 Nov 2014 12:02:01 +0530
Message-ID: <87r3wp887y.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112706-0025-0000-0000-000000985C97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Mon, 24 Nov 2014, Kirill A. Shutemov wrote:
>
>> > This make sure that we try to allocate hugepages from local node. If
>> > we can't we fallback to small page allocation based on
>> > mempolicy. This is based on the observation that allocating pages
>> > on local node is more beneficial that allocating hugepages on remote node.
>> 
>> Local node on allocation is not necessary local node for use.
>> If policy says to use a specific node[s], we should follow.
>> 
>
> True, and the interaction between thp and mempolicies is fragile: if a 
> process has a MPOL_BIND mempolicy over a set of nodes, that does not 
> necessarily mean that we want to allocate thp remotely if it will always 
> be accessed remotely.  It's simple to benchmark and show that remote 
> access latency of a hugepage can exceed that of local pages.  MPOL_BIND 
> itself is a policy of exclusion, not inclusion, and it's difficult to 
> define when local pages and its cost of allocation is better than remote 
> thp.
>
> For MPOL_BIND, if the local node is allowed then thp should be forced from 
> that node, if the local node is disallowed then allocate from any node in 
> the nodemask.  For MPOL_INTERLEAVE, I think we should only allocate thp 
> from the next node in order, otherwise fail the allocation and fallback to 
> small pages.  Is this what you meant as well?
>

Something like below

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

	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
		unsigned nid;
		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
		mpol_cond_put(pol);
		page = alloc_page_interleave(gfp, order, nid);
		if (unlikely(!page &&
			     read_mems_allowed_retry(cpuset_mems_cookie)))
			goto retry_cpuset;
		return page;
	}
	nmask = policy_nodemask(gfp, pol);
	if (!nmask || node_isset(node, *nmask)) {
		mpol_cond_put(pol);
		page = alloc_hugepage_exact_node(node, gfp, order);
		if (unlikely(!page &&
			     read_mems_allowed_retry(cpuset_mems_cookie)))
			goto retry_cpuset;
		return page;

	}
	/*
	 * if current node is not part of node mask, try
	 * the allocation from any node, and we can do retry
	 * in that case.
	 */
	page = __alloc_pages_nodemask(gfp, order,
				      policy_zonelist(gfp, pol, node),
				      nmask);
	mpol_cond_put(pol);
	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
		goto retry_cpuset;

	return page;
}

-aneesh

