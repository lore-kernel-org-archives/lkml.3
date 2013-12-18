Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3LRG5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:09 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50636 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3LRGyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:08 -0500
X-AuditID: 9c93017d-b7c5eae000004296-c7-52b1468d0c4a
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
Subject: [PATCH v3 06/14] mm, hugetlb: remove vma_has_reserves()
Date: Wed, 18 Dec 2013 15:53:52 +0900
Message-Id: <1387349640-8071-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_has_reserves() can be substituted by using return value of
vma_needs_reservation(). If chg returned by vma_needs_reservation()
is 0, it means that vma has reserves. Otherwise, it means that vma don't
have reserves and need a hugepage outside of reserve pool. This definition
is perfectly same as vma_has_reserves(), so remove vma_has_reserves().

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f394454..9d456d4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -469,39 +469,6 @@ void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 		vma->vm_private_data = (void *)0;
 }
 
-/* Returns true if the VMA has associated reserve pages */
-static int vma_has_reserves(struct vm_area_struct *vma, long chg)
-{
-	if (vma->vm_flags & VM_NORESERVE) {
-		/*
-		 * This address is already reserved by other process(chg == 0),
-		 * so, we should decrement reserved count. Without decrementing,
-		 * reserve count remains after releasing inode, because this
-		 * allocated page will go into page cache and is regarded as
-		 * coming from reserved pool in releasing step.  Currently, we
-		 * don't have any other solution to deal with this situation
-		 * properly, so add work-around here.
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
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
@@ -555,10 +522,11 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
-	 * not "stolen". The child may still get SIGKILLed
+	 * not "stolen". The child may still get SIGKILLed.
+	 * chg represents whether current user has a reserved hugepages or not,
+	 * so that we can use it to ensure that reservations are not "stolen".
 	 */
-	if (!vma_has_reserves(vma, chg) &&
-			h->free_huge_pages - h->resv_huge_pages == 0)
+	if (chg && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
@@ -577,7 +545,11 @@ retry_cpuset:
 			if (page) {
 				if (avoid_reserve)
 					break;
-				if (!vma_has_reserves(vma, chg))
+				/*
+				 * chg means whether current user allocates
+				 * a hugepage on the reserved pool or not
+				 */
+				if (chg)
 					break;
 
 				SetPagePrivate(page);
-- 
1.7.9.5

