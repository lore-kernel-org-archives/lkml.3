Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966082Ab3HIJ1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:27:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53871 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965917Ab3HIJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:27:16 -0400
X-AuditID: 9c930197-b7b44ae00000347f-ab-5204b5ed2b15
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 12/20] mm, hugetlb: remove vma_has_reserves()
Date: Fri,  9 Aug 2013 18:26:30 +0900
Message-Id: <1376040398-11212-13-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_has_reserves() can be substituted by using return value of
vma_needs_reservation(). If chg returned by vma_needs_reservation()
is 0, it means that vma has reserves. Otherwise, it means that vma don't
have reserves and need a hugepage outside of reserve pool. This definition
is perfectly same as vma_has_reserves(), so remove vma_has_reserves().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e6c0c77..22ceb04 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -473,39 +473,6 @@ void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 		vma->vm_private_data = (void *)0;
 }
 
-/* Returns true if the VMA has associated reserve pages */
-static int vma_has_reserves(struct vm_area_struct *vma, long chg)
-{
-	if (vma->vm_flags & VM_NORESERVE) {
-		/*
-		 * This address is already reserved by other process(chg == 0),
-		 * so, we should decreament reserved count. Without
-		 * decreamenting, reserve count is remained after releasing
-		 * inode, because this allocated page will go into page cache
-		 * and is regarded as coming from reserved pool in releasing
-		 * step. Currently, we don't have any other solution to deal
-		 * with this situation properly, so add work-around here.
-		 */
-		if (vma->vm_flags & VM_MAYSHARE && chg == 0)
-			return 1;
-		else
-			return 0;
-	}
-
-	/* Shared mappings always use reserves */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return 1;
-
-	/*
-	 * Only the process that called mmap() has reserves for
-	 * private mappings.
-	 */
-	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
-		return 1;
-
-	return 0;
-}
-
 static void copy_gigantic_page(struct page *dst, struct page *src)
 {
 	int i;
@@ -580,8 +547,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_reserves(vma, chg) &&
-			h->free_huge_pages - h->resv_huge_pages == 0)
+	if (chg && h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
@@ -600,7 +566,7 @@ retry_cpuset:
 			if (page) {
 				if (avoid_reserve)
 					break;
-				if (!vma_has_reserves(vma, chg))
+				if (chg)
 					break;
 
 				SetPagePrivate(page);
-- 
1.7.9.5

