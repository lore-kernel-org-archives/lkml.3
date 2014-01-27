Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaA0Dw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 22:52:56 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:27181 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaA0Dwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 22:52:54 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: riel@redhat.com, mgorman@suse.de, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        hughd@google.com, david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, dhillf@gmail.com,
        rientjes@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm, hugetlb: region manipulation functions take resv_map rather list_head
Date: Sun, 26 Jan 2014 19:52:20 -0800
Message-Id: <1390794746-16755-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

To change a protection method for region tracking to find grained one,
we pass the resv_map, instead of list_head, to region manipulation
functions. This doesn't introduce any functional change, and it is just
for preparing a next step.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 mm/hugetlb.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fbed1b7..572866d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -151,8 +151,9 @@ struct file_region {
 	long to;
 };
 
-static long region_add(struct list_head *head, long f, long t)
+static long region_add(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
 
 	/* Locate the region we are either in or before. */
@@ -187,8 +188,9 @@ static long region_add(struct list_head *head, long f, long t)
 	return 0;
 }
 
-static long region_chg(struct list_head *head, long f, long t)
+static long region_chg(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg;
 	long chg = 0;
 
@@ -236,8 +238,9 @@ static long region_chg(struct list_head *head, long f, long t)
 	return chg;
 }
 
-static long region_truncate(struct list_head *head, long end)
+static long region_truncate(struct resv_map *resv, long end)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *trg;
 	long chg = 0;
 
@@ -266,8 +269,9 @@ static long region_truncate(struct list_head *head, long end)
 	return chg;
 }
 
-static long region_count(struct list_head *head, long f, long t)
+static long region_count(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg;
 	long chg = 0;
 
@@ -393,7 +397,7 @@ void resv_map_release(struct kref *ref)
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 
 	/* Clear out any active regions before we release the map. */
-	region_truncate(&resv_map->regions, 0);
+	region_truncate(resv_map, 0);
 	kfree(resv_map);
 }
 
@@ -1152,7 +1156,7 @@ static long vma_needs_reservation(struct hstate *h,
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = inode->i_mapping->private_data;
 
-		return region_chg(&resv->regions, idx, idx + 1);
+		return region_chg(resv, idx, idx + 1);
 
 	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		return 1;
@@ -1162,7 +1166,7 @@ static long vma_needs_reservation(struct hstate *h,
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = vma_resv_map(vma);
 
-		err = region_chg(&resv->regions, idx, idx + 1);
+		err = region_chg(resv, idx, idx + 1);
 		if (err < 0)
 			return err;
 		return 0;
@@ -1178,14 +1182,14 @@ static void vma_commit_reservation(struct hstate *h,
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = inode->i_mapping->private_data;
 
-		region_add(&resv->regions, idx, idx + 1);
+		region_add(resv, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
-		region_add(&resv->regions, idx, idx + 1);
+		region_add(resv, idx, idx + 1);
 	}
 }
 
@@ -2276,7 +2280,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
-			region_count(&resv->regions, start, end);
+			region_count(resv, start, end);
 
 		resv_map_put(vma);
 
@@ -3178,7 +3182,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	if (!vma || vma->vm_flags & VM_MAYSHARE) {
 		resv_map = inode->i_mapping->private_data;
 
-		chg = region_chg(&resv_map->regions, from, to);
+		chg = region_chg(resv_map, from, to);
 
 	} else {
 		resv_map = resv_map_alloc();
@@ -3224,7 +3228,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_add(&resv_map->regions, from, to);
+		region_add(resv_map, from, to);
 	return 0;
 out_err:
 	if (vma)
@@ -3240,7 +3244,7 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 	struct hugepage_subpool *spool = subpool_inode(inode);
 
 	if (resv_map)
-		chg = region_truncate(&resv_map->regions, offset);
+		chg = region_truncate(resv_map, offset);
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
-- 
1.8.1.4

