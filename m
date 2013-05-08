Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3EHA5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:57:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11983 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3EHA5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:57:19 -0400
X-AuditID: cbfee68f-b7f066d000003683-49-5189a2edeceb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: cover free_nid management with spin_lock
Date: Wed, 08 May 2013 09:56:10 +0900
Message-id: <1367974571-29255-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zY923izoDDeZtELW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6N/4hLWgk7pilVL
	7zE1MDaLdTFyckgImEgcPnaDDcIWk7hwbz2QzcUhJLCMUWLPuqcsMEXLPq9hgUhMZ5RoefWO
	ESQhJNDGJHFtT2EXIwcHm4C2xOb9BiBhEQFmiQVTzzOC1DMLTGCU+L/oPdggYQFniYbVnWA2
	i4CqxOstT8Dm8Aq4S0x63Qe1TFdi9f/n7CDNEgL32STa9p9lhmgQkPg2+RALyDIJAVmJTQeY
	IeolJQ6uuMEygVFwASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQEOzfwXj3gPUhxmSg
	cROZpUST84EhnFcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxomSISULPe4rin8IyNe0PvhI99NFtvhYkwPTklwuBpg0LdrSql4mdLaldUp7fYbk
	Ff/TIp0nuR7ffVcaeKrTzFiq/rylhbnprp+PXnF5S3Le3dZuOl1d630Bs2O7wKSoLA25Lxf6
	lkz+NefeSTPhE1pvNiqo6F47UJOU+V7wN9v6IPXPW+yfKrEUZyQaajEXFScCAHRtkxtXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd23izoDDVb2Clpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jRP3EJa0GndMWqpfeYGhibxboYOTkkBEwkln1ewwJhi0lcuLeerYuRi0NI
	YDqjRMurd4wgCSGBNiaJa3sKuxg5ONgEtCU27zcACYsIMEssmHqeEaSeWWACo8T/Re/BBgkL
	OEs0rO4Es1kEVCVeb3kCNodXwF1i0us+qGW6Eqv/P2efwMi9gJFhFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwgD+T3sG4qsHiEKMAB6MSD68Fd2egEGtiWXFl7iFGCQ5mJRHesgKgEG9K
	YmVValF+fFFpTmrxIcZkoO0TmaVEk/OB0ZdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYz1Bgf2Xrw1QyBZ5slMrjZL85kfc4N+llX/WXmsavKZp9+vzeEX
	OjVffdW5/05G1bNFd00KVUzQybilIPtR1YPJkqEnZJVxyoycqIi1hh8ULuwtj1jiJ/Rj+rWb
	GuJ93yNe+788s/PturNrWQo0JukWnU2Yo20oF/Ekh6MkolnGb2LbpJC99ixKLMUZiYZazEXF
	iQBNAbQctAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After build_free_nids() searches free nid candidates from nat pages and
current journal blocks, it checks all the candidates if they are allocated
so that the nat cache has its nid with an allocated block address.

In this procedure, previously we used
    list_for_each_entry_safe(fnid, next_fnid, &nm_i->free_nid_list, list).
But, this is not covered by free_nid_list_lock, resulting in null pointer bug.

This patch moves this checking routine inside add_free_nid() in order not to use
the spin_lock.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e42934e..3df43b4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1249,9 +1249,11 @@ static void __del_from_free_nid_list(struct free_nid *i)
 	kmem_cache_free(free_nid_slab, i);
 }
 
-static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
+static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 {
 	struct free_nid *i;
+	struct nat_entry *ne;
+	bool allocated = false;
 
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
 		return -1;
@@ -1259,6 +1261,18 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 	/* 0 nid should not be used */
 	if (nid == 0)
 		return 0;
+
+	if (!build)
+		goto retry;
+
+	/* do not add allocated nids */
+	read_lock(&nm_i->nat_tree_lock);
+	ne = __lookup_nat_cache(nm_i, nid);
+	if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
+		allocated = true;
+	read_unlock(&nm_i->nat_tree_lock);
+	if (allocated)
+		return 0;
 retry:
 	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
 	if (!i) {
@@ -1309,7 +1323,7 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
 		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR) {
-			if (add_free_nid(nm_i, start_nid) < 0)
+			if (add_free_nid(nm_i, start_nid, true) < 0)
 				break;
 		}
 	}
@@ -1317,7 +1331,6 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
 
 static void build_free_nids(struct f2fs_sb_info *sbi)
 {
-	struct free_nid *fnid, *next_fnid;
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
@@ -1354,22 +1367,11 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 		block_t addr = le32_to_cpu(nat_in_journal(sum, i).block_addr);
 		nid = le32_to_cpu(nid_in_journal(sum, i));
 		if (addr == NULL_ADDR)
-			add_free_nid(nm_i, nid);
+			add_free_nid(nm_i, nid, true);
 		else
 			remove_free_nid(nm_i, nid);
 	}
 	mutex_unlock(&curseg->curseg_mutex);
-
-	/* remove the free nids from current allocated nids */
-	list_for_each_entry_safe(fnid, next_fnid, &nm_i->free_nid_list, list) {
-		struct nat_entry *ne;
-
-		read_lock(&nm_i->nat_tree_lock);
-		ne = __lookup_nat_cache(nm_i, fnid->nid);
-		if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
-			remove_free_nid(nm_i, fnid->nid);
-		read_unlock(&nm_i->nat_tree_lock);
-	}
 }
 
 /*
@@ -1659,7 +1661,7 @@ flush_now:
 		}
 
 		if (nat_get_blkaddr(ne) == NULL_ADDR &&
-				add_free_nid(NM_I(sbi), nid) <= 0) {
+				add_free_nid(NM_I(sbi), nid, false) <= 0) {
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
-- 
1.8.1.3.566.gaa39828

