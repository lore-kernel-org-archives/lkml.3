Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbaAHNy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:54:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbaAHNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:54:23 -0500
Date: Wed, 8 Jan 2014 14:54:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Bob Liu <lliubbo@gmail.com>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140108135422.GJ27937@dhcp22.suse.cz>
References: <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
 <20140106141827.GB27602@dhcp22.suse.cz>
 <CAA_GA1csMEhSYmeS7qgDj7h=Xh2WrsYvirkS55W4Jj3LTHy87A@mail.gmail.com>
 <20140107102212.GC8756@dhcp22.suse.cz>
 <20140107173034.GE8756@dhcp22.suse.cz>
 <CAA_GA1fN5p3-m40Mf3nqFzRrGcJ9ni9Cjs_q4fm1PCLnzW1cEw@mail.gmail.com>
 <20140108100859.GC27937@dhcp22.suse.cz>
 <CAA_GA1emcHt+9zOqAKHPoXLd-ofyfYyuQn9fcdLOox5k7BLgww@mail.gmail.com>
 <20140108124240.GH27937@dhcp22.suse.cz>
 <CAA_GA1dh3TtzGnK0HgAb_Sy6ww5JBaFqmf_YViPKpMCEpzFh4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1dh3TtzGnK0HgAb_Sy6ww5JBaFqmf_YViPKpMCEpzFh4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
the whole thread started here: http://lkml.org/lkml/2014/1/6/217
I guess it makes sense to revert part of the already merged commit with
the following patch. If the BUG_ON triggers again then we should rather
find out why page_address_in_vma fails on anon_vma or f_mapping checks
and not simply paper over it.
---
>From 805035f35e8865f6233f88c78e7063512042afea Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 8 Jan 2014 10:57:41 +0100
Subject: [PATCH] mm: new_vma_page cannot see NULL vma for hugetlb pages

11c731e81bb0 (mm/mempolicy: fix !vma in new_vma_page()) has removed
BUG_ON(!vma) from new_vma_page which is partially correct because
page_address_in_vma will return EFAULT for non-linear mappings and at
least shared shmem might be mapped this way.

The patch also tried to prevent NULL ptr for hugetlb pages which is not
correct AFAICS because hugetlb pages cannot be mapped as VM_NONLINEAR
and other conditions in page_address_in_vma seem to be legit and catch
real bugs.

This patch restores BUG_ON for PageHuge to catch potential issues when
the to-be-migrated page is not setup properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
---
 mm/mempolicy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9e8d2d86978a..1a368cd925ed 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1199,10 +1199,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 	}
 
 	if (PageHuge(page)) {
-		if (vma)
-			return alloc_huge_page_noerr(vma, address, 1);
-		else
-			return NULL;
+		BUG_ON(!vma);
+		return alloc_huge_page_noerr(vma, address, 1);
 	}
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
-- 
1.8.5.2

-- 
Michal Hocko
SUSE Labs
