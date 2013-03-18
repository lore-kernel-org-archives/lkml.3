Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3CRFu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:50:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45038 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CRFu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:50:56 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b5-5146ab3e69dc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH] f2fs: reduce unncessary locking pages during read
Date: Mon, 18 Mar 2013 14:50:09 +0900
Message-id: <1363585809-8138-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t8zI1271W6BBv/6lS327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK+rT/EWrA1uOLRad8GxlWOXYycHBICJhLvry1ghLDF
	JC7cW8/WxcjFISSwjFFiw7rZjDBFE4/uYIFILGKU6Ny1jhnCaWOSOLFiN1AVBwebgLbE5v0G
	IA0iAswSC6aeZwSpYRbYwShxauIesEnCAk4Sq972s4HYLAKqEquuLwaL8wq4SRx8cApqm67E
	6v/P2SHsI2wSb/eHQtQLSHybfIgFZJeEgKzEpgPMECWSEgdX3GCZwCi4gJFhFaNoakFyQXFS
	epGRXnFibnFpXrpecn7uJkZIaPXtYLx5wPoQYzLQuInMUqLJ+cDQzCuJNzQ2M7IwNTE1NjK3
	NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY1ah5IZq5tMRXj8XX7p8SCu9
	8iGDeijrqgWG3U59MUccp692PzjLqeQMc2f8Noflrs/rlpfdTpK5NTfxq1hg4v31OgJbyu3m
	TNdz9DvD9DNwXeLL5l+Mj4L3PuyPObpOadJpjdiyA8zvKpytk+wSS2tEtKP6zGTePjF30hW6
	5ieZbzTf6GWhEktxRqKhFnNRcSIAD3iaqkMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgK7dardAgwWbZSz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzvq0/xFqwNbji
	0WnfBsZVjl2MnBwSAiYSE4/uYIGwxSQu3FvP1sXIxSEksIhRonPXOmYIp41J4sSK3YxdjBwc
	bALaEpv3G4A0iAgwSyyYep4RpIZZYAejxKmJexhBEsICThKr3vazgdgsAqoSq64vBovzCrhJ
	HHxwihFim67E6v/P2Scwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERy6z6R2MK5s
	sDjEKMDBqMTDa8DjGijEmlhWXJl7iFGCg1lJhLchxC1QiDclsbIqtSg/vqg0J7X4EGMy0PaJ
	zFKiyfnAuMoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbX
	8tfbvz0Qrpa6+dr2g+Q0p65A+bjHf9yFJHkfPL9yjvP453dfC/Y5rp5XGxyVrLTw0/aLvoLM
	2+9sZ/9r4y9a1j2p8pKwutf5i0ou0pu3rHi241X8sqld18o+7dnF+eie5a7DM5w/zXfrvxl2
	okz+dOD2nET/o/8TD+hEnrBdvHeZzuZd170ylFiKMxINtZiLihMBttXmsaECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces redundant locking and unlocking pages during read operations.
In f2fs_readpage, let's use wait_on_page_locked() instead of lock_page.
And then, when we need to modify any data finally, let's lock the page so that
we can avoid lock contention.

[readpage rule]
- The f2fs_readpage returns unlocked page, or released page too in error cases.
- Its caller should handle read error, -EIO, after locking the page, which
  indicates read completion.
- Its caller should check PageUptodate after grab_cache_page.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 12 ++++++-----
 fs/f2fs/data.c       | 58 ++++++++++++++++++++++++++--------------------------
 fs/f2fs/node.c       | 58 +++++++++++++++++++++++++++++++---------------------
 fs/f2fs/recovery.c   | 31 +++++++++++++++++-----------
 4 files changed, 90 insertions(+), 69 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 2b6fc13..d947e66 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -57,13 +57,15 @@ repeat:
 		cond_resched();
 		goto repeat;
 	}
-	if (f2fs_readpage(sbi, page, index, READ_SYNC)) {
-		f2fs_put_page(page, 1);
+	if (PageUptodate(page))
+		goto out;
+
+	if (f2fs_readpage(sbi, page, index, READ_SYNC))
 		goto repeat;
-	}
-	mark_page_accessed(page);
 
-	/* We do not allow returning an errorneous page */
+	lock_page(page);
+out:
+	mark_page_accessed(page);
 	return page;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 277966a..6616137 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -199,12 +199,15 @@ struct page *find_data_page(struct inode *inode, pgoff_t index)
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
-	if (err) {
-		f2fs_put_page(page, 1);
-		return ERR_PTR(err);
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return page;
 	}
-	unlock_page(page);
+
+	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+	wait_on_page_locked(page);
+	if (!PageUptodate(page))
+		return ERR_PTR(-EIO);
 	return page;
 }
 
@@ -241,9 +244,13 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	BUG_ON(dn.data_blkaddr == NULL_ADDR);
 
 	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
-	if (err) {
-		f2fs_put_page(page, 1);
+	if (err)
 		return ERR_PTR(err);
+
+	lock_page(page);
+	if (!PageUptodate(page)) {
+		f2fs_put_page(page, 1);
+		return ERR_PTR(-EIO);
 	}
 	return page;
 }
@@ -283,14 +290,17 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
 	} else {
 		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
-		if (err) {
-			f2fs_put_page(page, 1);
+		if (err)
 			return ERR_PTR(err);
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			f2fs_put_page(page, 1);
+			return ERR_PTR(-EIO);
 		}
 	}
-	SetPageUptodate(page);
 
 	if (new_i_size &&
 		i_size_read(inode) < ((index + 1) << PAGE_CACHE_SHIFT)) {
@@ -325,22 +335,14 @@ static void read_end_io(struct bio *bio, int err)
 
 /*
  * Fill the locked page with data located in the block address.
- * Read operation is synchronous, and caller must unlock the page.
+ * Return unlocked page.
  */
 int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 					block_t blk_addr, int type)
 {
 	struct block_device *bdev = sbi->sb->s_bdev;
-	bool sync = (type == READ_SYNC);
 	struct bio *bio;
 
-	/* This page can be already read by other threads */
-	if (PageUptodate(page)) {
-		if (!sync)
-			unlock_page(page);
-		return 0;
-	}
-
 	down_read(&sbi->bio_sem);
 
 	/* Allocate a new bio */
@@ -354,18 +356,12 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 		kfree(bio->bi_private);
 		bio_put(bio);
 		up_read(&sbi->bio_sem);
+		f2fs_put_page(page, 1);
 		return -EFAULT;
 	}
 
 	submit_bio(type, bio);
 	up_read(&sbi->bio_sem);
-
-	/* wait for read completion if sync */
-	if (sync) {
-		lock_page(page);
-		if (PageError(page))
-			return -EIO;
-	}
 	return 0;
 }
 
@@ -636,18 +632,22 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 		/* Reading beyond i_size is simple: memset to zero */
 		zero_user_segments(page, 0, start, end, PAGE_CACHE_SIZE);
-		return 0;
+		goto out;
 	}
 
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
 		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
-		if (err) {
-			f2fs_put_page(page, 1);
+		if (err)
 			return err;
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			f2fs_put_page(page, 1);
+			return -EIO;
 		}
 	}
+out:
 	SetPageUptodate(page);
 	clear_cold_data(page);
 	return 0;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a3cb1ff..9e6ed67 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -100,10 +100,13 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 		page = grab_cache_page(mapping, index);
 		if (!page)
 			continue;
-		if (f2fs_readpage(sbi, page, index, READ)) {
+		if (PageUptodate(page)) {
 			f2fs_put_page(page, 1);
 			continue;
 		}
+		if (f2fs_readpage(sbi, page, index, READ))
+			continue;
+
 		f2fs_put_page(page, 0);
 	}
 }
@@ -851,8 +854,16 @@ static int read_node_page(struct page *page, int type)
 
 	get_node_info(sbi, page->index, &ni);
 
-	if (ni.blk_addr == NULL_ADDR)
+	if (ni.blk_addr == NULL_ADDR) {
+		f2fs_put_page(page, 1);
 		return -ENOENT;
+	}
+
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return 0;
+	}
+
 	return f2fs_readpage(sbi, page, ni.blk_addr, type);
 }
 
@@ -865,19 +876,18 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 	struct page *apage;
 
 	apage = find_get_page(mapping, nid);
-	if (apage && PageUptodate(apage))
-		goto release_out;
+	if (apage && PageUptodate(apage)) {
+		f2fs_put_page(apage, 0);
+		return;
+	}
 	f2fs_put_page(apage, 0);
 
 	apage = grab_cache_page(mapping, nid);
 	if (!apage)
 		return;
 
-	if (read_node_page(apage, READA))
-		unlock_page(apage);
-
-release_out:
-	f2fs_put_page(apage, 0);
+	if (read_node_page(apage, READA) == 0)
+		f2fs_put_page(apage, 0);
 	return;
 }
 
@@ -892,11 +902,14 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 		return ERR_PTR(-ENOMEM);
 
 	err = read_node_page(page, READ_SYNC);
-	if (err) {
-		f2fs_put_page(page, 1);
+	if (err)
 		return ERR_PTR(err);
-	}
 
+	lock_page(page);
+	if (!PageUptodate(page)) {
+		f2fs_put_page(page, 1);
+		return ERR_PTR(-EIO);
+	}
 	BUG_ON(nid != nid_of_node(page));
 	mark_page_accessed(page);
 	return page;
@@ -928,11 +941,8 @@ repeat:
 		goto page_hit;
 
 	err = read_node_page(page, READ_SYNC);
-	unlock_page(page);
-	if (err) {
-		f2fs_put_page(page, 0);
+	if (err)
 		return ERR_PTR(err);
-	}
 
 	/* Then, try readahead for siblings of the desired node */
 	end = start + MAX_RA_NODE;
@@ -957,6 +967,7 @@ page_hit:
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
+	mark_page_accessed(page);
 	return page;
 }
 
@@ -1473,23 +1484,24 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 	sum_entry = &sum->entries[0];
 
 	for (i = 0; i < last_offset; i++, sum_entry++) {
+		/*
+		 * In order to read next node page,
+		 * we must clear PageUptodate flag.
+		 */
+		ClearPageUptodate(page);
+
 		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
 			goto out;
 
+		lock_page(page);
 		rn = (struct f2fs_node *)page_address(page);
 		sum_entry->nid = rn->footer.nid;
 		sum_entry->version = 0;
 		sum_entry->ofs_in_node = 0;
 		addr++;
-
-		/*
-		 * In order to read next node page,
-		 * we must clear PageUptodate flag.
-		 */
-		ClearPageUptodate(page);
 	}
-out:
 	unlock_page(page);
+out:
 	__free_pages(page, 0);
 	return 0;
 }
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 6b82e20..5c792b7 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -112,11 +112,17 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		if (f2fs_readpage(sbi, page, blkaddr, READ_SYNC))
+		ClearPageUptodate(page);
+		err = f2fs_readpage(sbi, page, blkaddr, READ_SYNC);
+		if (err)
 			goto out;
 
-		if (cp_ver != cpver_of_node(page))
-			goto out;
+		lock_page(page);
+
+		if (cp_ver != cpver_of_node(page)) {
+			err = -EINVAL;
+			goto unlock_out;
+		}
 
 		if (!is_fsync_dnode(page))
 			goto next;
@@ -131,7 +137,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			if (IS_INODE(page) && is_dent_dnode(page)) {
 				if (recover_inode_page(sbi, page)) {
 					err = -ENOMEM;
-					goto out;
+					goto unlock_out;
 				}
 			}
 
@@ -139,14 +145,14 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
 			if (!entry) {
 				err = -ENOMEM;
-				goto out;
+				goto unlock_out;
 			}
 
 			entry->inode = f2fs_iget(sbi->sb, ino_of_node(page));
 			if (IS_ERR(entry->inode)) {
 				err = PTR_ERR(entry->inode);
 				kmem_cache_free(fsync_entry_slab, entry);
-				goto out;
+				goto unlock_out;
 			}
 
 			list_add_tail(&entry->list, head);
@@ -155,15 +161,15 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 		if (IS_INODE(page)) {
 			err = recover_inode(entry->inode, page);
 			if (err)
-				goto out;
+				goto unlock_out;
 		}
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
-		ClearPageUptodate(page);
 	}
-out:
+unlock_out:
 	unlock_page(page);
+out:
 	__free_pages(page, 0);
 	return err;
 }
@@ -316,11 +322,12 @@ static void recover_data(struct f2fs_sb_info *sbi,
 	while (1) {
 		struct fsync_inode_entry *entry;
 
+		ClearPageUptodate(page);
 		if (f2fs_readpage(sbi, page, blkaddr, READ_SYNC))
 			goto out;
 
 		if (cp_ver != cpver_of_node(page))
-			goto out;
+			goto unlock_out;
 
 		entry = get_fsync_inode(head, ino_of_node(page));
 		if (!entry)
@@ -336,10 +343,10 @@ static void recover_data(struct f2fs_sb_info *sbi,
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
-		ClearPageUptodate(page);
 	}
-out:
+unlock_out:
 	unlock_page(page);
+out:
 	__free_pages(page, 0);
 
 	allocate_new_segments(sbi);
-- 
1.8.1.3.566.gaa39828

