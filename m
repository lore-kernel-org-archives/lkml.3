Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3DYLCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:02:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53932 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab3DYLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:02:44 -0400
X-AuditID: cbfee68f-b7f066d000003683-a5-51790d5193dc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: enhnace alloc_nid and build_free_nids flows
Date: Thu, 25 Apr 2013 20:01:37 +0900
Message-id: <1366887697-24627-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zY91A3spAg5mnFC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgylj58yNzwUXNiv+L
	5RoYjyh2MXJySAiYSFw/OoMZwhaTuHBvPRuILSSwjFFi/wrfLkYOsJrzu9K7GLmAwosYJea1
	PGaEcNqYJD6v3cEKUsQmoC2xeb8BSK+IALPEgqnnwWqYBSYwSvxf9J4FJCEs4Caxoe0f2AIW
	AVWJ/U0/wOK8Au4S765chTpCV2L1/+fsIDangIfElr89TBAHuUs86NoHVfOdTeLEpVyIOQIS
	3yYfYoE4VFZi0wGoEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyRY
	+3cw3j1gfYgxGWjcRGYp0eR8YLDnlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoFRZMqSmztCfgYxGP07Wdh6ZOLtf+yHGlu8DN9uPL1ZaZlZyvFw
	qZDgwD2vOdYc61OYc83mdrlqqtOxgzt7WnP0HBcvXb/emueGjaUsc/uLKb/anNcxqEVIixuf
	K66am1H6jnF3m+rhotrCpLP7GJfeVvg1vcvs27eOn5qRoovscg9qH98X2DxDiaU4I9FQi7mo
	OBEAV/IkumwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd1A3spAg9tvhCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xY+fMjc8FFzYr/i+UaGI8odjFycEgImEic35XexcgJZIpJXLi3nq2LkYtD
	SGARo8S8lseMEE4bk8TntTtYQRrYBLQlNu83AGkQEWCWWDD1PFgNs8AERon/i96zgCSEBdwk
	NrT9YwOxWQRUJfY3/QCL8wq4S7y7cpUZYpuuxOr/z9lBbE4BD4ktf3uYQGwhoJoHXfuYJzDy
	LmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHA/PpHcwrmqwOMQowMGoxMMr8Ko8UIg1
	say4MvcQowQHs5IIL/OPikAh3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgfGal5JvKGxiZmR
	pZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MDLam06Krm3hWl4xZ1rn58Wf
	ylnurv4YVRR9lEF3sckOpQv2iyeemLPsiG1ls5CFmO05uW1V8d+W/WMuWDDliqx14r7gYt9j
	PMxPPEPnS0ifSLrTv7bkxc5D707uT3cSf2fs+GqF6t1/6s/yl7DLFSvk20+X7f/hkKxYMruN
	K/6i7VLJkxwxskosxRmJhlrMRcWJABvGrUXLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid build_free_nid lock contention, let's change the order of
function calls as follows.

At first, check whether there is enough free nids.
 - If available, just get a free nid with spin_lock without any overhead.
 - Otherwise, conduct build_free_nids.
  : scan nat pages, journal nat entries, and nat cache entries.

We should consider carefullly not to serve free nids intermediately made by
build_free_nids.
We can get stable free nids only after build_free_nids is done.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h |  2 +-
 fs/f2fs/node.c | 82 ++++++++++++++++++++++++++--------------------------------
 2 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6283c8d..20aab02 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -190,7 +190,6 @@ static inline void set_raw_extent(struct extent_info *ext,
 struct f2fs_nm_info {
 	block_t nat_blkaddr;		/* base disk address of NAT */
 	nid_t max_nid;			/* maximum possible node ids */
-	nid_t init_scan_nid;		/* the first nid to be scanned */
 	nid_t next_scan_nid;		/* the next nid to be scanned */
 
 	/* NAT cache management */
@@ -360,6 +359,7 @@ struct f2fs_sb_info {
 	struct mutex writepages;		/* mutex for writepages() */
 	unsigned char next_lock_num;		/* round-robin global locks */
 	int por_doing;				/* recovery is doing or not */
+	int on_build_free_nids;			/* build_free_nids is doing */
 
 	/* for orphan inode management */
 	struct list_head orphan_inode_list;	/* orphan inode list */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c8f48d4..aede910 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1309,14 +1309,14 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	nid_t nid = 0;
-	bool is_cycled = false;
-	int fcnt = 0;
-	int i;
+	int fcnt = 0, i = 0;
+	nid_t nid = nm_i->next_scan_nid;
 
-	nid = nm_i->next_scan_nid;
-	nm_i->init_scan_nid = nid;
+	/* Enough entries */
+	if (nm_i->fcnt > NAT_ENTRY_PER_BLOCK)
+		return;
 
+	/* readahead nat pages to be scanned */
 	ra_nat_pages(sbi, nid);
 
 	while (1) {
@@ -1326,19 +1326,15 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 		f2fs_put_page(page, 1);
 
 		nid += (NAT_ENTRY_PER_BLOCK - (nid % NAT_ENTRY_PER_BLOCK));
-
-		if (nid >= nm_i->max_nid) {
+		if (nid >= nm_i->max_nid)
 			nid = 0;
-			is_cycled = true;
-		}
-		if (fcnt > MAX_FREE_NIDS)
-			break;
-		if (is_cycled && nm_i->init_scan_nid <= nid)
+
+		if (i++ == FREE_NID_PAGES)
 			break;
 	}
 
-	/* go to the next nat page in order to reuse free nids first */
-	nm_i->next_scan_nid = nm_i->init_scan_nid + NAT_ENTRY_PER_BLOCK;
+	/* go to the next free nat pages to find free nids abundantly */
+	nm_i->next_scan_nid = nid;
 
 	/* find free nids from current sum_pages */
 	mutex_lock(&curseg->curseg_mutex);
@@ -1375,41 +1371,36 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 	struct free_nid *i = NULL;
 	struct list_head *this;
 retry:
-	mutex_lock(&nm_i->build_lock);
-	if (!nm_i->fcnt) {
-		/* scan NAT in order to build free nid list */
-		build_free_nids(sbi);
-		if (!nm_i->fcnt) {
-			mutex_unlock(&nm_i->build_lock);
-			return false;
-		}
-	}
-	mutex_unlock(&nm_i->build_lock);
+	if (sbi->total_valid_node_count + 1 >= nm_i->max_nid)
+		return false;
 
-	/*
-	 * We check fcnt again since previous check is racy as
-	 * we didn't hold free_nid_list_lock. So other thread
-	 * could consume all of free nids.
-	 */
 	spin_lock(&nm_i->free_nid_list_lock);
-	if (!nm_i->fcnt) {
-		spin_unlock(&nm_i->free_nid_list_lock);
-		goto retry;
-	}
 
-	BUG_ON(list_empty(&nm_i->free_nid_list));
-	list_for_each(this, &nm_i->free_nid_list) {
-		i = list_entry(this, struct free_nid, list);
-		if (i->state == NID_NEW)
-			break;
-	}
+	/* We should not use stale free nids created by build_free_nids */
+	if (nm_i->fcnt && !sbi->on_build_free_nids) {
+		BUG_ON(list_empty(&nm_i->free_nid_list));
+		list_for_each(this, &nm_i->free_nid_list) {
+			i = list_entry(this, struct free_nid, list);
+			if (i->state == NID_NEW)
+				break;
+		}
 
-	BUG_ON(i->state != NID_NEW);
-	*nid = i->nid;
-	i->state = NID_ALLOC;
-	nm_i->fcnt--;
+		BUG_ON(i->state != NID_NEW);
+		*nid = i->nid;
+		i->state = NID_ALLOC;
+		nm_i->fcnt--;
+		spin_unlock(&nm_i->free_nid_list_lock);
+		return true;
+	}
 	spin_unlock(&nm_i->free_nid_list_lock);
-	return true;
+
+	/* Let's scan nat pages and its caches to get free nids */
+	mutex_lock(&nm_i->build_lock);
+	sbi->on_build_free_nids = 1;
+	build_free_nids(sbi);
+	sbi->on_build_free_nids = 0;
+	mutex_unlock(&nm_i->build_lock);
+	goto retry;
 }
 
 /*
@@ -1696,7 +1687,6 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	spin_lock_init(&nm_i->free_nid_list_lock);
 	rwlock_init(&nm_i->nat_tree_lock);
 
-	nm_i->init_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
 	nm_i->next_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
 	nm_i->bitmap_size = __bitmap_size(sbi, NAT_BITMAP);
 	version_bitmap = __bitmap_ptr(sbi, NAT_BITMAP);
-- 
1.8.1.3.566.gaa39828

