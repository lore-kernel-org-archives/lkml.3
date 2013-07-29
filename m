Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3G2Feo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:34:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47164 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3G2FcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:32:24 -0400
X-AuditID: 9c930197-b7bfbae000000e88-1f-51f5fe65b58a
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
Subject: [PATCH 13/18] mm, hugetlb: grab a page_table_lock after page_cache_release
Date: Mon, 29 Jul 2013 14:32:04 +0900
Message-Id: <1375075929-6119-14-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to grab a page_table_lock when we try to release a page.
So, defer to grab a page_table_lock.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 35ccdad..255bd9e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2630,10 +2630,11 @@ retry_avoidcopy:
 	}
 	spin_unlock(&mm->page_table_lock);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	/* Caller expects lock to be held */
-	spin_lock(&mm->page_table_lock);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
+
+	/* Caller expects lock to be held */
+	spin_lock(&mm->page_table_lock);
 	return 0;
 }
 
-- 
1.7.9.5

