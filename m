Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBXHTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:19:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64883 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXHTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:19:44 -0500
X-AuditID: cbfee68f-b7f156d00000276c-d5-530af28ce9b1
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: introduce a radix_tree for the free_nid list
Date: Mon, 24 Feb 2014 16:18:03 +0900
Message-id: <1393226284-22447-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd2eT1zBBk8nM1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXF/93u2gvvKFXOv
	vmVvYHws28XIySEhYCJxaMtPJghbTOLCvfVsXYxcHEICyxglThy/zwhT9PfodFaIxHRGia9H
	fzFCOJ1MEudmbgXKcHCwCWhLbN5vANIgIsAssWDqebAaZoEJjBL/F71nAUkIC7hLfPs2mw3E
	ZhFQlXg0ZzKYzQsUX7trASvENm2Jbc8ngjVLCNxmkzhx4j9Ug4DEt8mHWECWSQjISmw6wAxR
	LylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihARh/w7GuwesDzEmA42b
	yCwlmpwPDOK8knhDYzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cC4KuvXofbKtCPBr4L0nraclztebntxyqQara0HNiVtZBXksbkvwbQtz29Lm3K2bVfW
	vdKm9cs/qj67/ujaPwHxif7yEs8XOggE2q7tzU2dvEVt7YmvbxcITL2unOD4U499xV3deXfv
	7xUxC7jGt5nHct9yF5UJ6xvL9MUS/s67sFzhbjKzLpe0EktxRqKhFnNRcSIA4/YBwlgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd3uT1zBBrsfWVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxf/d7toL7yhVzr75lb2B8LNvFyMkhIWAi8ffodFYIW0ziwr31bF2MXBxC
	AtMZJb4e/cUI4XQySZybuRWoioODTUBbYvN+A5AGEQFmiQVTz4PVMAtMYJT4v+g9C0hCWMBd
	4tu32WwgNouAqsSjOZPBbF6g+NpdC6C2aUtsez6RcQIj9wJGhlWMoqkFyQXFSem5RnrFibnF
	pXnpesn5uZsYwSH+THoH46oGi0OMAhyMSjy8EtVcwUKsiWXFlbmHGCU4mJVEeH/cBwrxpiRW
	VqUW5ccXleakFh9iTAbaPpFZSjQ5Hxh/eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8s
	Sc1OTS1ILYLZwsTBKdXAqGgg9H7ufdWJy7qD9v+xVs62z7rxZsEBW/dPH2++b3tyO3DS4diQ
	TfukNkx7vjSoVkujWSusgfXyuoCPCs9nrLI+9rQvbE/Cvu/auUe1JY9M+5tb/Tl0Jfu/lU6q
	pzg2fhMIeeCnbx70q2tyashnZfYyPUe3vS3mgecKC4PUz0X6rZm8/4HeDCWW4oxEQy3mouJE
	AIadDcC1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a radix tree for the list of free_nids, which enhances
the performance on free nid management.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/node.c | 36 +++++++++++++++++-------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c56e67b..11fd8be 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -247,6 +247,7 @@ struct f2fs_nm_info {
 	struct list_head dirty_nat_entries; /* cached nat entry list (dirty) */
 
 	/* free node ids management */
+	struct radix_tree_root free_nid_root;/* root of the free_nid cache */
 	struct list_head free_nid_list;	/* a list for free nids */
 	spinlock_t free_nid_list_lock;	/* protect free nid list */
 	unsigned int fcnt;		/* the number of free node id */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 431bcb4..1f9cf21 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1269,21 +1269,17 @@ const struct address_space_operations f2fs_node_aops = {
 	.releasepage	= f2fs_release_node_page,
 };
 
-static struct free_nid *__lookup_free_nid_list(nid_t n, struct list_head *head)
+static struct free_nid *__lookup_free_nid_list(struct f2fs_nm_info *nm_i,
+						nid_t n)
 {
-	struct list_head *this;
-	struct free_nid *i;
-	list_for_each(this, head) {
-		i = list_entry(this, struct free_nid, list);
-		if (i->nid == n)
-			return i;
-	}
-	return NULL;
+	return radix_tree_lookup(&nm_i->free_nid_root, n);
 }
 
-static void __del_from_free_nid_list(struct free_nid *i)
+static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
+						struct free_nid *i)
 {
 	list_del(&i->list);
+	radix_tree_delete(&nm_i->free_nid_root, i->nid);
 	kmem_cache_free(free_nid_slab, i);
 }
 
@@ -1304,7 +1300,8 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 		/* do not add allocated nids */
 		read_lock(&nm_i->nat_tree_lock);
 		ne = __lookup_nat_cache(nm_i, nid);
-		if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
+		if (ne &&
+			(!ne->checkpointed || nat_get_blkaddr(ne) != NULL_ADDR))
 			allocated = true;
 		read_unlock(&nm_i->nat_tree_lock);
 		if (allocated)
@@ -1316,7 +1313,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 	i->state = NID_NEW;
 
 	spin_lock(&nm_i->free_nid_list_lock);
-	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
+	if (radix_tree_insert(&nm_i->free_nid_root, i->nid, i)) {
 		spin_unlock(&nm_i->free_nid_list_lock);
 		kmem_cache_free(free_nid_slab, i);
 		return 0;
@@ -1331,9 +1328,9 @@ static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct free_nid *i;
 	spin_lock(&nm_i->free_nid_list_lock);
-	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
+	i = __lookup_free_nid_list(nm_i, nid);
 	if (i && i->state == NID_NEW) {
-		__del_from_free_nid_list(i);
+		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
 	}
 	spin_unlock(&nm_i->free_nid_list_lock);
@@ -1457,9 +1454,9 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
 	struct free_nid *i;
 
 	spin_lock(&nm_i->free_nid_list_lock);
-	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
+	i = __lookup_free_nid_list(nm_i, nid);
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
-	__del_from_free_nid_list(i);
+	__del_from_free_nid_list(nm_i, i);
 	spin_unlock(&nm_i->free_nid_list_lock);
 }
 
@@ -1475,10 +1472,10 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 		return;
 
 	spin_lock(&nm_i->free_nid_list_lock);
-	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
+	i = __lookup_free_nid_list(nm_i, nid);
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
-		__del_from_free_nid_list(i);
+		__del_from_free_nid_list(nm_i, i);
 	} else {
 		i->state = NID_NEW;
 		nm_i->fcnt++;
@@ -1812,6 +1809,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nm_i->fcnt = 0;
 	nm_i->nat_cnt = 0;
 
+	INIT_RADIX_TREE(&nm_i->free_nid_root, GFP_ATOMIC);
 	INIT_LIST_HEAD(&nm_i->free_nid_list);
 	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
 	INIT_LIST_HEAD(&nm_i->nat_entries);
@@ -1865,7 +1863,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	spin_lock(&nm_i->free_nid_list_lock);
 	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
 		f2fs_bug_on(i->state == NID_ALLOC);
-		__del_from_free_nid_list(i);
+		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
 	}
 	f2fs_bug_on(nm_i->fcnt);
-- 
1.8.4.474.g128a96c

