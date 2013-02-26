Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab3BZFip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:38:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18376 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3BZFi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:38:29 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-64-512c4a5249e6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: [PATCH 2/2] f2fs: introduce readahead mode of node pages
Date: Tue, 26 Feb 2013 14:37:48 +0900
Message-id: <1361857068-31613-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t8zA90gL51Ag95Wa4s9e0+yWFzeNYfN
	gcnj8ya5AMYoLpuU1JzMstQifbsEroyls7YzFqwxq7j95g57A+NB7S5GTg4JAROJs382MUPY
	YhIX7q1n62Lk4hASWMYoMbP5KjtM0ZezUxkhEosYJVoe9TBBOG1MEl8+7QZq5+BgE9CW2Lzf
	AKRBRCBTYvWll+wgYWYBTYkZT+pAwsICjhJblx8BW8YioCrRMGEzK4jNK+AusfLUbCaIXboS
	q/8/B9vLKeAh0bHoJFi9EFDNj1+LWSFqbrNJdDXXQswRkPg2+RALyCoJAVmJTQegfpGUOLji
	BssERuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUICceIOxvsHrA8xJgONm8gsJZqc
	DwzkvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	nCbve/YwLzvfZa3AnKOdTw/verdBY82HR1FrnG9W9+hdWHU/+gtPQpDt61VsrWtN2sQtczv+
	K0Q9LXgdaS336PBfsSkCJyz+mW26XMR4xUig61HzC1fTe1OWiCvp/j9SstuqWPy0yN+T3wpM
	l09c5fJ7sdmqjbPXJaw9++3Eeacdk94EhL3teKTEUpyRaKjFXFScCAB+smgmWgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jAd0gL51AgyvrTSz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzls7azliwxqzi
	9ps77A2MB7W7GDk5JARMJL6cncoIYYtJXLi3nq2LkYtDSGARo0TLox4mCKeNSeLLp93MXYwc
	HGwC2hKb9xuANIgIZEqsvvSSHSTMLKApMeNJHUhYWMBRYuvyI8wgNouAqkTDhM2sIDavgLvE
	ylOzmSB26Uqs/v+cHcTmFPCQ6Fh0EqxeCKjmx6/FrBMYeRcwMqxiFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECA70Z9I7GFc1WBxiFOBgVOLh1ejQDhRiTSwrrsw9xCjBwawkwsuZARTiTUms
	rEotyo8vKs1JLT7EmAx01URmKdHkfGAU5pXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpi
	SWp2ampBahHMFiYOTqkGRn4Vwyc7Vh2Of/GqyJltWnuzwylO92NPTr25MHuG9mO9PyW2ynPN
	pu5edHfH/Oat1nqmpeeeZG1MLZoWvzpqmdG+UAahW+ohcy53vI7tP+UqqPzgRcNOM8uJDr9d
	hU5klBVtWH1Tz2t+5wKRzzxeMxg+Kv6+eOIAe7NJa+kV1iTvxNN7Ksz5cpRYijMSDbWYi4oT
	AaDQ8WO4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs reads several node pages ahead when get_dnode_of_data is called
with RDONLY_NODE flag.
And, this flag is set by the following functions.
- get_data_block_ro
- get_lock_data_page
- do_write_data_page
- truncate_blocks
- truncate_hole

However, this readahead mechanism is initially introduced for the use of
get_data_block_ro to enhance the sequential read performance.

So, let's clarify all the cases with the additional modes as follows.

enum {
	ALLOC_NODE,	/* allocate a new node page if needed */
	LOOKUP_NODE,	/* look up a node without readahead */
	LOOKUP_NODE_RA,	/*
			 * look up a node with readahead called
			 * by get_datablock_ro.
			 */
}

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c     | 12 ++++++------
 fs/f2fs/f2fs.h     | 12 ++++++++----
 fs/f2fs/file.c     |  8 ++++----
 fs/f2fs/node.c     |  6 +++---
 fs/f2fs/recovery.c |  2 +-
 5 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..277966a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -183,7 +183,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index)
 	f2fs_put_page(page, 0);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, RDONLY_NODE);
+	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
 	if (err)
 		return ERR_PTR(err);
 	f2fs_put_dnode(&dn);
@@ -222,7 +222,7 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	int err;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, RDONLY_NODE);
+	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
 	if (err)
 		return ERR_PTR(err);
 	f2fs_put_dnode(&dn);
@@ -262,7 +262,7 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 	int err;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, 0);
+	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
 	if (err)
 		return ERR_PTR(err);
 
@@ -392,7 +392,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, pgofs, RDONLY_NODE);
+	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
 	if (err)
 		return (err == -ENOENT) ? 0 : err;
 
@@ -443,7 +443,7 @@ int do_write_data_page(struct page *page)
 	int err = 0;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, page->index, RDONLY_NODE);
+	err = get_dnode_of_data(&dn, page->index, LOOKUP_NODE);
 	if (err)
 		return err;
 
@@ -607,7 +607,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	mutex_lock_op(sbi, DATA_NEW);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, 0);
+	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
 	if (err) {
 		mutex_unlock_op(sbi, DATA_NEW);
 		f2fs_put_page(page, 1);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cc2213a..be7ae70 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -125,11 +125,15 @@ static inline int update_sits_in_cursum(struct f2fs_summary_block *rs, int i)
 					 * file keeping -1 as its node offset to
 					 * distinguish from index node blocks.
 					 */
-#define RDONLY_NODE		1	/*
-					 * specify a read-only mode when getting
-					 * a node block. 0 is read-write mode.
-					 * used by get_dnode_of_data().
+enum {
+	ALLOC_NODE,			/* allocate a new node page if needed */
+	LOOKUP_NODE,			/* look up a node without readahead */
+	LOOKUP_NODE_RA,			/*
+					 * look up a node with readahead called
+					 * by get_datablock_ro.
 					 */
+};
+
 #define F2FS_LINK_MAX		32000	/* maximum link count per file */
 
 /* for in-memory extent cache entry */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b7a053d..d4e29a5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -43,7 +43,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 
 	/* block allocation */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, page->index, 0);
+	err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
 	if (err) {
 		mutex_unlock_op(sbi, DATA_NEW);
 		goto out;
@@ -258,7 +258,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
 	mutex_lock_op(sbi, DATA_TRUNC);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, free_from, RDONLY_NODE);
+	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
 	if (err) {
 		if (err == -ENOENT)
 			goto free_next;
@@ -420,7 +420,7 @@ int truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end)
 
 		mutex_lock_op(sbi, DATA_TRUNC);
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
-		err = get_dnode_of_data(&dn, index, RDONLY_NODE);
+		err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
 		if (err) {
 			mutex_unlock_op(sbi, DATA_TRUNC);
 			if (err == -ENOENT)
@@ -504,7 +504,7 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		mutex_lock_op(sbi, DATA_NEW);
 
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
-		ret = get_dnode_of_data(&dn, index, 0);
+		ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
 		if (ret) {
 			mutex_unlock_op(sbi, DATA_NEW);
 			break;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 185454f..e88bf2b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -384,7 +384,7 @@ got:
 /*
  * Caller should call f2fs_put_dnode(dn).
  */
-int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int ro)
+int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct page *npage[4];
@@ -411,7 +411,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int ro)
 	for (i = 1; i <= level; i++) {
 		bool done = false;
 
-		if (!nids[i] && !ro) {
+		if (!nids[i] && mode == ALLOC_NODE) {
 			mutex_lock_op(sbi, NODE_NEW);
 
 			/* alloc new node */
@@ -434,7 +434,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int ro)
 			alloc_nid_done(sbi, nids[i]);
 			mutex_unlock_op(sbi, NODE_NEW);
 			done = true;
-		} else if (ro && i == level && level > 1) {
+		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
 			npage[i] = get_node_page_ra(parent, offset[i - 1]);
 			if (IS_ERR(npage[i])) {
 				err = PTR_ERR(npage[i]);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b235215..6b82e20 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -247,7 +247,7 @@ static void do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 		end = start + ADDRS_PER_BLOCK;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	if (get_dnode_of_data(&dn, start, 0))
+	if (get_dnode_of_data(&dn, start, ALLOC_NODE))
 		return;
 
 	wait_on_page_writeback(dn.node_page);
-- 
1.8.1.3.566.gaa39828

