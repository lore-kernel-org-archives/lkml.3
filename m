Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966296Ab3HIJ2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:28:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42785 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965956Ab3HIJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:27:17 -0400
X-AuditID: 9c930197-b7b44ae00000347f-b2-5204b5eeca8f
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
Subject: [PATCH v2 15/20] mm, hugetlb: remove a check for return value of alloc_huge_page()
Date: Fri,  9 Aug 2013 18:26:33 +0900
Message-Id: <1376040398-11212-16-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, alloc_huge_page() only return -ENOSPEC if failed.
So, we don't worry about other return value.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc666cf..24de2ca 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2544,7 +2544,6 @@ retry_avoidcopy:
 	new_page = alloc_huge_page(vma, address, use_reserve);
 
 	if (IS_ERR(new_page)) {
-		long err = PTR_ERR(new_page);
 		page_cache_release(old_page);
 
 		/*
@@ -2573,10 +2572,7 @@ retry_avoidcopy:
 
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
-		if (err == -ENOMEM)
-			return VM_FAULT_OOM;
-		else
-			return VM_FAULT_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -2707,11 +2703,7 @@ retry:
 
 		page = alloc_huge_page(vma, address, use_reserve);
 		if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
-			if (ret == -ENOMEM)
-				ret = VM_FAULT_OOM;
-			else
-				ret = VM_FAULT_SIGBUS;
+			ret = VM_FAULT_SIGBUS;
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
-- 
1.7.9.5

