Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaDHTDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556AbaDHTC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:02:58 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com, aarcange@redhat.com,
        mgorman@suse.de, akpm@linux-foundation.org, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com
Subject: [PATCH 3/5] hugetlb: update_and_free_page(): don't clear PG_reserved bit
Date: Tue,  8 Apr 2014 15:02:18 -0400
Message-Id: <1396983740-26047-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1396983740-26047-1-git-send-email-lcapitulino@redhat.com>
References: <1396983740-26047-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugepages pages never get the PG_reserved bit set, so don't clear it. But
add a warning just in case.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/hugetlb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8674eda..c295bba 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -617,8 +617,9 @@ static void update_and_free_page(struct hstate *h, struct page *page)
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
-				1 << PG_active | 1 << PG_reserved |
-				1 << PG_private | 1 << PG_writeback);
+				1 << PG_active | 1 << PG_private |
+				1 << PG_writeback);
+		WARN_ON(PageReserved(&page[i]));
 	}
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
 	set_compound_page_dtor(page, NULL);
-- 
1.8.1.4

