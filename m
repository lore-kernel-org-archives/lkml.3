Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaAaRim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:38:42 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23219 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019AbaAaRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:37:03 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: riel@redhat.com, mgorman@suse.de, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        hughd@google.com, david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, dhillf@gmail.com,
        rientjes@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] mm, hugetlb: fix race in region tracking
Date: Fri, 31 Jan 2014 09:36:43 -0800
Message-Id: <1391189806-13319-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391189806-13319-1-git-send-email-davidlohr@hp.com>
References: <1391189806-13319-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

There is a race condition if we map a same file on different processes.
Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only the,
mmap_sem (exclusively). This doesn't prevent other tasks from modifying the
region structure, so it can be modified by two processes concurrently.

To solve this, introduce a spinlock to resv_map and make region manipulation
function grab it before they do actual work.

Acked-by: David Gibson <david@gibson.dropbear.id.au>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/hugetlb.h |  1 +
 mm/hugetlb.c            | 58 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f62c2f6..5b337cf 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -27,6 +27,7 @@ struct hugepage_subpool {
 
 struct resv_map {
 	struct kref refs;
+	spinlock_t lock;
 	struct list_head regions;
 };
 extern struct resv_map *resv_map_alloc(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dca03a6..3c03c7f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -135,15 +135,8 @@ static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
  * Region tracking -- allows tracking of reservations and instantiated pages
  *                    across the pages in a mapping.
  *
- * The region data structures are protected by a combination of the mmap_sem
- * and the hugetlb_instantiation_mutex.  To access or modify a region the caller
- * must either hold the mmap_sem for write, or the mmap_sem for read and
- * the hugetlb_instantiation_mutex:
- *
- *	down_write(&mm->mmap_sem);
- * or
- *	down_read(&mm->mmap_sem);
- *	mutex_lock(&hugetlb_instantiation_mutex);
+ * The region data structures are embedded into a resv_map and
+ * protected by a resv_map's lock
  */
 struct file_region {
 	struct list_head link;
@@ -156,6 +149,7 @@ static long region_add(struct resv_map *resv, long f, long t)
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
 
+	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
 	list_for_each_entry(rg, head, link)
 		if (f <= rg->to)
@@ -185,15 +179,18 @@ static long region_add(struct resv_map *resv, long f, long t)
 	}
 	nrg->from = f;
 	nrg->to = t;
+	spin_unlock(&resv->lock);
 	return 0;
 }
 
 static long region_chg(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
-	struct file_region *rg, *nrg;
+	struct file_region *rg, *nrg = NULL;
 	long chg = 0;
 
+retry:
+	spin_lock(&resv->lock);
 	/* Locate the region we are before or in. */
 	list_for_each_entry(rg, head, link)
 		if (f <= rg->to)
@@ -203,15 +200,21 @@ static long region_chg(struct resv_map *resv, long f, long t)
 	 * Subtle, allocate a new region at the position but make it zero
 	 * size such that we can guarantee to record the reservation. */
 	if (&rg->link == head || t < rg->from) {
-		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
-		if (!nrg)
-			return -ENOMEM;
-		nrg->from = f;
-		nrg->to   = f;
-		INIT_LIST_HEAD(&nrg->link);
-		list_add(&nrg->link, rg->link.prev);
+		if (!nrg) {
+			spin_unlock(&resv->lock);
+			nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
+			if (!nrg)
+				return -ENOMEM;
+
+			nrg->from = f;
+			nrg->to   = f;
+			INIT_LIST_HEAD(&nrg->link);
+			goto retry;
+		}
 
-		return t - f;
+		list_add(&nrg->link, rg->link.prev);
+		chg = t - f;
+		goto out_nrg;
 	}
 
 	/* Round our left edge to the current segment if it encloses us. */
@@ -224,7 +227,7 @@ static long region_chg(struct resv_map *resv, long f, long t)
 		if (&rg->link == head)
 			break;
 		if (rg->from > t)
-			return chg;
+			goto out;
 
 		/* We overlap with this area, if it extends further than
 		 * us then we must extend ourselves.  Account for its
@@ -235,6 +238,14 @@ static long region_chg(struct resv_map *resv, long f, long t)
 		}
 		chg -= rg->to - rg->from;
 	}
+
+out:
+	spin_unlock(&resv->lock);
+	/*  We already know we raced and no longer need the new region */
+	kfree(nrg);
+	return chg;
+out_nrg:
+	spin_unlock(&resv->lock);
 	return chg;
 }
 
@@ -244,12 +255,13 @@ static long region_truncate(struct resv_map *resv, long end)
 	struct file_region *rg, *trg;
 	long chg = 0;
 
+	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
 	list_for_each_entry(rg, head, link)
 		if (end <= rg->to)
 			break;
 	if (&rg->link == head)
-		return 0;
+		goto out;
 
 	/* If we are in the middle of a region then adjust it. */
 	if (end > rg->from) {
@@ -266,6 +278,9 @@ static long region_truncate(struct resv_map *resv, long end)
 		list_del(&rg->link);
 		kfree(rg);
 	}
+
+out:
+	spin_unlock(&resv->lock);
 	return chg;
 }
 
@@ -275,6 +290,7 @@ static long region_count(struct resv_map *resv, long f, long t)
 	struct file_region *rg;
 	long chg = 0;
 
+	spin_lock(&resv->lock);
 	/* Locate each segment we overlap with, and count that overlap. */
 	list_for_each_entry(rg, head, link) {
 		long seg_from;
@@ -290,6 +306,7 @@ static long region_count(struct resv_map *resv, long f, long t)
 
 		chg += seg_to - seg_from;
 	}
+	spin_unlock(&resv->lock);
 
 	return chg;
 }
@@ -387,6 +404,7 @@ struct resv_map *resv_map_alloc(void)
 		return NULL;
 
 	kref_init(&resv_map->refs);
+	spin_lock_init(&resv_map->lock);
 	INIT_LIST_HEAD(&resv_map->regions);
 
 	return resv_map;
-- 
1.8.1.4

