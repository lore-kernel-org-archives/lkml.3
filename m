Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3D2KWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:22:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30932 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3D2KWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:22:07 -0400
X-AuditID: cbfee68d-b7f016d000007930-7a-517e49c9218a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: check truncation of mapping after lock_page
Date: Mon, 29 Apr 2013 19:20:57 +0900
Message-id: <1367230857-10030-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zQ92TnnWBBlMPSFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHk0D/2gvcaFSd3
	BjYwPlToYuTgkBAwkXh6R7eLkRPIFJO4cG89WxcjF4eQwDJGiY9rljJBJEwkJnQ+ZIRITGeU
	mLh5PhOE08YksXH5bTaQSWwC2hKb9xuANIgIMEssmHoerIFZYAKjxP9F71lAEsICThKHFuxk
	BbFZBFQl7nVOZwexeQXcJWYc6mWG2KYrsfr/c3aQZgmB+2wSe7dtZ4JoEJD4NvkQC8TZshKb
	DkDVS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIQHYu4Px9gHrQ4zJ
	QOMmMkuJJucDAzivJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYzZf6oCqqzP3CzuylGV0pDWmWwx5fdZ4z5zdnWR0usGLccj2V8Vc25dEt+4+62r
	VdrlqXfPzb32OWfu1bMTbx8+XVimaHz0X/nv7fs1ur2de1q/F06u2Wc4X53n9FqDjMeZ30M3
	W0rwMNa0Grjy9h3gD7A781/FSzEqrGBTl9rsyuDqHeL1/5RYijMSDbWYi4oTAQwBfwlWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2TnnWBBu3PRSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4cugfe8F7jYqTOwMbGB8qdDFyckgImEhM6HzICGGLSVy4t56ti5GLQ0hg
	OqPExM3zmSCcNiaJjctvA2U4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBZwk
	Di3YyQpiswioStzrnM4OYvMKuEvMONTLDLFNV2L1/+fsExi5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIDvBn0jsYVzVYHGIU4GBU4uEN2FwbKMSaWFZcmXuIUYKDWUmE94xjXaAQ
	b0piZVVqUX58UWlOavEhxmSg7ROZpUST84HRl1cSb2hsYmZkaWRmYWRibk6asJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjB6M++cVdNfO8TbfxyS+rDxeh/dbuPWa65nnVgVuScp4k2h1
	6eSRZxwpmas3Tdgo+3BdQuoj2xePGdilH+zN7XlWlslovfSEQvybojcn1bsVa0/q6bBceDDT
	4mDP/0kJaZ58stbhrbIhdz8mJ5zb5ZgbLdQ/RyDkuvqm8ttirs9Trs77c4H/thJLcUaioRZz
	UXEiAGmLmRy0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call lock_page when we need to update a page after readpage.
Between grab and lock page, the page can be truncated by other thread.
So, we should check the page after lock_page whether it was truncated or not.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  4 ++++
 fs/f2fs/data.c       | 18 +++++++++++++++---
 fs/f2fs/file.c       |  4 ++++
 fs/f2fs/node.c       | 20 ++++++++++++++++----
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 590ea50..b1de01d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -65,6 +65,10 @@ repeat:
 		goto repeat;
 
 	lock_page(page);
+	if (page->mapping != mapping) {
+		f2fs_put_page(page, 1);
+		goto repeat;
+	}
 out:
 	mark_page_accessed(page);
 	return page;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index eba7e84..2db9380 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -240,7 +240,7 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 
 	if (dn.data_blkaddr == NULL_ADDR)
 		return ERR_PTR(-ENOENT);
-
+repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -260,6 +260,10 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
+	if (page->mapping != mapping) {
+		f2fs_put_page(page, 1);
+		goto repeat;
+	}
 	return page;
 }
 
@@ -291,7 +295,7 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 		}
 	}
 	f2fs_put_dnode(&dn);
-
+repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -311,6 +315,10 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 			f2fs_put_page(page, 1);
 			return ERR_PTR(-EIO);
 		}
+		if (page->mapping != mapping) {
+			f2fs_put_page(page, 1);
+			goto repeat;
+		}
 	}
 
 	if (new_i_size &&
@@ -611,7 +619,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	*fsdata = NULL;
 
 	f2fs_balance_fs(sbi);
-
+repeat:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
@@ -656,6 +664,10 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 			f2fs_put_page(page, 1);
 			return -EIO;
 		}
+		if (page->mapping != mapping) {
+			f2fs_put_page(page, 1);
+			goto repeat;
+		}
 	}
 out:
 	SetPageUptodate(page);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9dfcdab..3e2c2cb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -217,6 +217,10 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 		return;
 
 	lock_page(page);
+	if (page->mapping != inode->i_mapping) {
+		f2fs_put_page(page, 1);
+		return;
+	}
 	wait_on_page_writeback(page);
 	zero_user(page, offset, PAGE_CACHE_SIZE - offset);
 	set_page_dirty(page);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index aede910..6ff0172 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -674,6 +674,7 @@ fail:
 int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct address_space *node_mapping = sbi->node_inode->i_mapping;
 	int err = 0, cont = 1;
 	int level, offset[4], noffset[4];
 	unsigned int nofs = 0;
@@ -684,7 +685,7 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 	trace_f2fs_truncate_inode_blocks_enter(inode, from);
 
 	level = get_node_path(from, offset, noffset);
-
+restart:
 	page = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(page)) {
 		trace_f2fs_truncate_inode_blocks_exit(inode, PTR_ERR(page));
@@ -748,6 +749,10 @@ skip_partial:
 		if (offset[1] == 0 &&
 				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
 			lock_page(page);
+			if (page->mapping != node_mapping) {
+				f2fs_put_page(page, 1);
+				goto restart;
+			}
 			wait_on_page_writeback(page);
 			rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
 			set_page_dirty(page);
@@ -916,7 +921,7 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 	struct address_space *mapping = sbi->node_inode->i_mapping;
 	struct page *page;
 	int err;
-
+repeat:
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -932,6 +937,10 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
+	if (page->mapping != mapping) {
+		f2fs_put_page(page, 1);
+		goto repeat;
+	}
 got_it:
 	BUG_ON(nid != nid_of_node(page));
 	mark_page_accessed(page);
@@ -955,7 +964,7 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	nid = get_nid(parent, start, false);
 	if (!nid)
 		return ERR_PTR(-ENOENT);
-
+repeat:
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -981,7 +990,10 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	blk_finish_plug(&plug);
 
 	lock_page(page);
-
+	if (page->mapping != mapping) {
+		f2fs_put_page(page, 1);
+		goto repeat;
+	}
 page_hit:
 	if (!PageUptodate(page)) {
 		f2fs_put_page(page, 1);
-- 
1.8.1.3.566.gaa39828

