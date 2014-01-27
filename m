Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaA0DxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 22:53:03 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4653 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaA0Dw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 22:52:59 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: riel@redhat.com, mgorman@suse.de, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        hughd@google.com, david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, dhillf@gmail.com,
        rientjes@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] mm, hugetlb: remove resv_map_put
Date: Sun, 26 Jan 2014 19:52:22 -0800
Message-Id: <1390794746-16755-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

This is a preparation patch to unify the use of vma_resv_map() regardless
of the map type. This patch prepares it by removing resv_map_put(), which
only works for HPAGE_RESV_OWNER's resv_map, not for all resv_maps.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
[Updated changelog]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 mm/hugetlb.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6b40d7e..13edf17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2273,15 +2273,6 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
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
@@ -2298,7 +2289,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		reserve = (end - start) -
 			region_count(resv, start, end);
 
-		resv_map_put(vma);
+		kref_put(&resv->refs, resv_map_release);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -3247,8 +3238,8 @@ int hugetlb_reserve_pages(struct inode *inode,
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
1.8.1.4

