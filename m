Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3GaILi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:11:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3GaILe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:11:34 -0400
Date: Wed, 31 Jul 2013 09:11:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/18] mm: numa: Do not migrate or account for hinting
 faults on the zero page
Message-ID: <20130731081130.GF2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-5-git-send-email-mgorman@suse.de>
 <20130717110053.GD17211@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130717110053.GD17211@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:00:53PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 04:20:06PM +0100, Mel Gorman wrote:
> > The zero page is not replicated between nodes and is often shared
> > between processes. The data is read-only and likely to be cached in
> > local CPUs if heavily accessed meaning that the remote memory access
> > cost is less of a concern. This patch stops accounting for numa hinting
> > faults on the zero page in both terms of counting faults and scheduling
> > tasks on nodes.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  mm/huge_memory.c | 9 +++++++++
> >  mm/memory.c      | 7 ++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index e4a79fa..ec938ed 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1302,6 +1302,15 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
> >  
> >  	page = pmd_page(pmd);
> >  	get_page(page);
> > +
> > +	/*
> > +	 * Do not account for faults against the huge zero page. The read-only
> > +	 * data is likely to be read-cached on the local CPUs and it is less
> > +	 * useful to know about local versus remote hits on the zero page.
> > +	 */
> > +	if (is_huge_zero_pfn(page_to_pfn(page)))
> > +		goto clear_pmdnuma;
> > +
> >  	src_nid = numa_node_id();
> >  	count_vm_numa_event(NUMA_HINT_FAULTS);
> >  	if (src_nid == page_to_nid(page))
> 
> And because of:
> 
>   5918d10 thp: fix huge zero page logic for page with pfn == 0
> 

Yes. Thanks.

-- 
Mel Gorman
SUSE Labs
