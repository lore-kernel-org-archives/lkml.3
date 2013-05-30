Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967901Ab3E3IUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:20:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967723Ab3E3IUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:20:37 -0400
Date: Thu, 30 May 2013 10:20:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/memory-hotplug: fix lowmem count overflow when
 offline pages
Message-ID: <20130530082034.GA8596@dhcp22.suse.cz>
References: <1369214970-1526-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130522104937.GC19989@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522104937.GC19989@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-05-13 12:49:37, Michal Hocko wrote:
> On Wed 22-05-13 17:29:27, Wanpeng Li wrote:
> > Logic memory-remove code fails to correctly account the Total High Memory 
> > when a memory block which contains High Memory is offlined as shown in the
> > example below. The following patch fixes it.
> > 
> > cat /proc/meminfo 
> > MemTotal:        7079452 kB
> > MemFree:         5805976 kB
> > Buffers:           94372 kB
> > Cached:           872000 kB
> > SwapCached:            0 kB
> > Active:           626936 kB
> > Inactive:         519236 kB
> > Active(anon):     180780 kB
> > Inactive(anon):   222944 kB
> > Active(file):     446156 kB
> > Inactive(file):   296292 kB
> > Unevictable:           0 kB
> > Mlocked:               0 kB
> > HighTotal:       7294672 kB
> > HighFree:        5181024 kB
> > LowTotal:       4294752076 kB
> > LowFree:          624952 kB
> 
> Ok, so the HighTotal is higher than MemTotal but it would have been more
> straightforward to show number of HighTotal before hotremove, show how
> much memory has been removed and the number after.
> 
> It is not clear which stable kernels need this fix as well.
> 
> > 
> > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> 
> Anyway
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
> with a nit pick bellow
> 
> > ---
> >  mm/page_alloc.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 98cbdf6..80474b2 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6140,6 +6140,10 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
> >  		list_del(&page->lru);
> >  		rmv_page_order(page);
> >  		zone->free_area[order].nr_free--;
> > +#ifdef CONFIG_HIGHMEM
> > +		if (PageHighMem(page))
> > +			totalhigh_pages -= 1 << order;
> > +#endif

Hmm, it seems that my old gcc (4.3.4) doesn't like this.
mm/page_alloc.c:6202: error: lvalue required as left operand of assignment

I am not sure this is a compiler bug because PAGEFLAG_FALSE is clearly
returning 0 which should make the whole if a no-op... But maybe we
shouldn't be more clever than compiler.

Andrew, could you fold this follow up fix for
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch

Sorr about the confusion I brought to this.
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 717286e..c164e5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6198,8 +6198,10 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+#ifdef CONFIG_HIGHMEM
 		if (PageHighMem(page))
 			totalhigh_pages -= 1 << order;
+#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);

-- 
Michal Hocko
SUSE Labs
