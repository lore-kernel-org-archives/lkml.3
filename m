Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3LRGyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:54:16 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62132 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3LRGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:07 -0500
X-AuditID: 9c93017d-b7c5eae000004296-c3-52b1468c10e9
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
Subject: [PATCH v3 04/14] mm, hugetlb: remove resv_map_put()
Date: Wed, 18 Dec 2013 15:53:50 +0900
Message-Id: <1387349640-8071-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In following patch, I change vma_resv_map() to return resv_map
for all case. This patch prepares it by removing resv_map_put() which
doesn't works properly with following change, because it works only for
HPAGE_RESV_OWNER's resv_map, not for all resv_maps.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cf0eaff..ef70b6f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2282,15 +2282,6 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 		kref_get(&resv->refs);
 }
 
-static void resv_map_put(struct vm_area_struct *vma)
-{
-	struct resv_map *resv = vma_resv_map(vma);
-
-	if (!resv)
-		return;
-	kref_put(&resv->refs, resv_map_release);
-}
-
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -2307,7 +2298,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		reserve = (end - start) -
 			region_count(resv, start, end);
 
-		resv_map_put(vma);
+		kref_put(&resv->refs, resv_map_release);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -3245,8 +3236,8 @@ int hugetlb_reserve_pages(struct inode *inode,
 		region_add(resv_map, from, to);
 	return 0;
 out_err:
-	if (vma)
-		resv_map_put(vma);
+	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		kref_put(&resv_map->refs, resv_map_release);
 	return ret;
 }
 
-- 
1.7.9.5

