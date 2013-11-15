Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3KOW4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:56:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:29147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3KOWz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:55:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,710,1378882800"; 
   d="scan'208";a="434314945"
Subject: [v3][PATCH 1/2] mm: hugetlbfs: Add VM_BUG_ON()s to catch non-hugetlbfs pages
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 15 Nov 2013 14:55:52 -0800
References: <20131115225550.737E5C33@viggo.jf.intel.com>
In-Reply-To: <20131115225550.737E5C33@viggo.jf.intel.com>
Message-Id: <20131115225552.6DCE2E1B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Changes from v2:
 * Removed the VM_BUG_ON() from copy_huge_page() since the
   next patch makes it able to handle non-hugetlbfs pages

--

Dave Jiang reported that he was seeing oopses when running
NUMA systems and default_hugepagesz=1G.  I traced the issue down
to migrate_page_copy() trying to use the same code for hugetlb
pages and transparent hugepages.  It should not have been trying
to pass thp pages in there.

So, add a VM_BUG_ON()s for the next hapless developer that
tries to use page_hstate() on a non-hugetlbfs page.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>

---

 linux.git-davehans/include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/hugetlb.h~bug-not-hugetlbfs-in-copy_huge_page include/linux/hugetlb.h
--- linux.git/include/linux/hugetlb.h~bug-not-hugetlbfs-in-copy_huge_page	2013-11-15 14:44:41.550357120 -0800
+++ linux.git-davehans/include/linux/hugetlb.h	2013-11-15 14:44:41.553357255 -0800
@@ -355,6 +355,7 @@ static inline pte_t arch_make_huge_pte(p
 
 static inline struct hstate *page_hstate(struct page *page)
 {
+	VM_BUG_ON(!PageHuge(page));
 	return size_to_hstate(PAGE_SIZE << compound_order(page));
 }
 
_
