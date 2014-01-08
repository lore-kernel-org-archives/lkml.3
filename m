Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaAHFqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 00:46:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49802 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaAHFqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 00:46:24 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-3f-52cce62e957e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: improve write performance under frequent fsync calls
Date: Wed, 08 Jan 2014 14:45:01 +0900
Message-id: <1389159902-25491-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA129Z2eCDOa/NLe4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Pv2z3mggvyFY1z
	HrI3MF6Q7GLk5JAQMJH42vqNCcIWk7hwbz1bFyMXh5DAMkaJXf0vGWGK5iz5zASRmM4ocffl
	XnYIp5lJYvGHZUAtHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgL+Ek19q9lA
	bBYBVYnuvevB4rwC7hK7LnawQWzTltj2fCJYs4TAfTaJaVP6WCAaBCS+TT7EArJMQkBWYtMB
	Zoh6SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJAh7dzDePmB9iDEZ
	aNxEZinR5HxgEOeVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6MJj57j+xqjXqOTR3N+uD+dFCO6msv+fdazyb/67vu2LFMXqag06/Lz4Htygif2
	9MU3Gcaf7v0tOWZekmj72vPkWeXjdusuZ2ybGqjckOzKWXsn7aLutYIp67fIrN4S6cXz7rz2
	jeO7xXddLl41S2Dysww/mws6h7+8XM58M67125LHCRul7vAosRRnJBpqMRcVJwIAVjKfDVgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV29Z2eCDK5vM7a4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGj79s95oIL8hWNcx6yNzBekOxi5OSQEDCRmLPkMxOELSZx4d56ti5GLg4h
	gemMEndf7mWHcJqZJBZ/WAaU4eBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwKSEBbw
	l2jqW80GYrMIqEp0710PFucVcJfYdbGDDWKbtsS25xMZJzByL2BkWMUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHOLPpHYwrmywOMQowMGoxMN7Q+1MkBBrYllxZe4hRgkOZiURXvcHQCHe
	lMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnA+MvryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYZR7v4cpff7HOXqgltKOp6bPAFwmuBaaTDlYnyL5dGROZk7eC
	cfo5B6M12+8Fbjvkt/tGQFbJksUZLDl1Vaf/B71IXmW0g+/I6n03OK/wrd6bfcpxscNRL/e2
	tLWzds1T12cTYTM8bh0Z/OEYV2Ppp3M3/2vUfS3dnmKTZ3LBdEP8Jq8SoSYZJZbijERDLeai
	4kQAzZW5C7UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When considering a bunch of data writes with very frequent fsync calls, we
are able to think the following performance regression.

N: Node IO, D: Data IO, IO scheduler: cfq

Issue    pending IOs
	 D1 D2 D3 D4
 D1         D2 D3 D4 N1
 D2            D3 D4 N1 N2
 N1            D3 D4 N2 D1
 --> N1 can be selected by cfq becase of the same priority of N and D.
     Then D3 and D4 would be delayed, resuling in performance degradation.

So, when processing the fsync call, it'd better give higher priority to data IOs
than node IOs by assigning WRITE and WRITE_SYNC respectively.
This patch improves the random wirte performance with frequent fsync calls by up
to 10%.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    | 4 ++--
 fs/f2fs/file.c    | 2 +-
 fs/f2fs/node.c    | 7 ++++++-
 fs/f2fs/segment.c | 8 ++------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 07a7ae0..b69f190 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1118,8 +1118,8 @@ int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
-void write_node_page(struct f2fs_sb_info *, struct page *, unsigned int,
-					block_t, block_t *);
+void write_node_page(struct f2fs_sb_info *, struct page *,
+		struct f2fs_io_info *, unsigned int, block_t, block_t *);
 void write_data_page(struct page *, struct dnode_of_data *, block_t *,
 					struct f2fs_io_info *);
 void rewrite_data_page(struct page *, block_t, struct f2fs_io_info *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c77ad4d..14511b0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -115,7 +115,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	int ret = 0;
 	bool need_cp = false;
 	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
+		.sync_mode = WB_SYNC_NONE,
 		.nr_to_write = LONG_MAX,
 		.for_reclaim = 0,
 	};
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0230326..b8c9301 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1194,6 +1194,10 @@ static int f2fs_write_node_page(struct page *page,
 	nid_t nid;
 	block_t new_addr;
 	struct node_info ni;
+	struct f2fs_io_info fio = {
+		.type = NODE,
+		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC: WRITE,
+	};
 
 	if (unlikely(sbi->por_doing))
 		goto redirty_out;
@@ -1218,7 +1222,7 @@ static int f2fs_write_node_page(struct page *page,
 
 	mutex_lock(&sbi->node_write);
 	set_page_writeback(page);
-	write_node_page(sbi, page, nid, ni.blk_addr, &new_addr);
+	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
 	set_node_addr(sbi, &ni, new_addr);
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
 	mutex_unlock(&sbi->node_write);
@@ -1253,6 +1257,7 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
 	/* if mounting is failed, skip writing node pages */
 	wbc->nr_to_write = 3 * max_hw_blocks(sbi);
+	wbc->sync_mode = WB_SYNC_NONE;
 	sync_node_pages(sbi, 0, wbc);
 	wbc->nr_to_write = nr_to_write - (3 * max_hw_blocks(sbi) -
 						wbc->nr_to_write);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 555ae76..5f84639 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -924,16 +924,12 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 }
 
 void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
+		struct f2fs_io_info *fio,
 		unsigned int nid, block_t old_blkaddr, block_t *new_blkaddr)
 {
 	struct f2fs_summary sum;
-	struct f2fs_io_info fio = {
-		.type = NODE,
-		.rw = WRITE_SYNC,
-	};
-
 	set_summary(&sum, nid, 0, 0);
-	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, &fio);
+	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, fio);
 }
 
 void write_data_page(struct page *page, struct dnode_of_data *dn,
-- 
1.8.4.474.g128a96c

