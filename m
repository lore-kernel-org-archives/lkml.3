Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3LRG4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:56:01 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62132 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LRGyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:09 -0500
X-AuditID: 9c93017d-b7c5eae000004296-d5-52b1468e033d
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
Subject: [PATCH v3 11/14] mm, hugetlb: move up anon_vma_prepare()
Date: Wed, 18 Dec 2013 15:53:57 +0900
Message-Id: <1387349640-8071-12-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail with a allocated hugepage, we need some effort to recover
properly. So, it is better not to allocate a hugepage as much as possible.
So move up anon_vma_prepare() which can be failed in OOM situation.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 03ab285..1817720 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2597,6 +2597,17 @@ retry_avoidcopy:
 	spin_unlock(ptl);
 
 	/*
+	 * When the original hugepage is shared one, it does not have
+	 * anon_vma prepared.
+	 */
+	if (unlikely(anon_vma_prepare(vma))) {
+		page_cache_release(old_page);
+		/* Caller expects lock to be held */
+		spin_lock(ptl);
+		return VM_FAULT_OOM;
+	}
+
+	/*
 	 * If the process that created a MAP_PRIVATE mapping is about to
 	 * perform a COW due to a shared page count, attempt to satisfy
 	 * the allocation without using the existing reserves. The pagecache
@@ -2655,18 +2666,6 @@ retry_avoidcopy:
 		return VM_FAULT_SIGBUS;
 	}
 
-	/*
-	 * When the original hugepage is shared one, it does not have
-	 * anon_vma prepared.
-	 */
-	if (unlikely(anon_vma_prepare(vma))) {
-		page_cache_release(new_page);
-		page_cache_release(old_page);
-		/* Caller expects lock to be held */
-		spin_lock(ptl);
-		return VM_FAULT_OOM;
-	}
-
 	copy_user_huge_page(new_page, old_page, address, vma,
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
-- 
1.7.9.5

