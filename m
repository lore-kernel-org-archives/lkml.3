Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3L0JSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:18:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10168 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3L0JSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:18:31 -0500
X-AuditID: cbfee68e-b7f566d000002344-1e-52bd45df5464
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: handle errors correctly during f2fs_reserve_block
Date: Fri, 27 Dec 2013 18:17:09 +0900
Message-id: <1388135829-21292-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ937rnuDDNb8Z7G4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6O/+wZzwWPViocT
	GtkaGPvluhg5OSQETCSenXvBBmGLSVy4tx7I5uIQEljGKHFqWzcrTNGF/feYIBKLGCXO/e9m
	h3CamSSmXZvE2MXIwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBaRGWMBD4lpzDkgN
	i4CqxJK995hBbF4Bd4lru88wQyzTltj2fCJYr4TAYzaJXU23WSAaBCS+TT4ENkdCQFZi0wGo
	ekmJgytusExgFFzAyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIyQE+3Yw3jxgfYgxGWjc
	RGYp0eR8YAjnlcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGeX81Uld/3HPz4rcXmu/55WYvPBVSeHvu87NeO33nJnY1ml/w4bPqSfHfP7du7t6c
	w2ui72w71Rk1o2Cz2aaPE479+dj6Xv8U5y65i8+36p7a+LfEvvyU56Wliye9vFqnZS6pZzX5
	gsz0uc/uqb3WPfnj3KmJVeZvdPMPri77xJcUtqt6/QzulmlKLMUZiYZazEXFiQDIQfa5VwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd37rnuDDP4EWVzf9ZfJ4tIid4s9
	e0+yWFzeNYfNgcVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtExJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9I
	EFyPkQEaSFjHmNHffYO54LFqxcMJjWwNjP1yXYycHBICJhIX9t9jgrDFJC7cW8/WxcjFISSw
	iFHi3P9udginmUli2rVJjF2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUBqhAU8
	JK4154DUsAioSizZe48ZxOYVcJe4tvsMM8QybYltzycyTmDkXsDIsIpRNLUguaA4KT3XSK84
	Mbe4NC9dLzk/dxMjOLyfSe9gXNVgcYhRgINRiYfXYcOeICHWxLLiytxDjBIczEoivE02e4OE
	eFMSK6tSi/Lji0pzUosPMSYDbZ/ILCWanA+MvbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYIx6JXXm6HQr6b7vrzw3ePuyP16z7Ngk7rceBy5uPcE+0+uA
	S9nLyayu/5gzo4049ulrXWHfcEd2t+IUjy7PkC8dSw8/XlT5ySnK7cAbA5vXfrLPjxmyZspE
	Pfzdo8O+35Y1/uKd6dtvJJfarDuy5d7pgpkf1gpcsm2Qm2yQJr+2emueg16nlr0SS3FGoqEW
	c1FxIgA44QW3swIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_dnode_of_data nullifies inode and node page when error is occurred.

There are two cases that passes inode page into get_dnode_of_data().

1. make_empty_dir()
    -> get_new_data_page()
      -> f2fs_reserve_block(ipage)
	-> get_dnode_of_data()

2. f2fs_convert_inline_data()
    -> __f2fs_convert_inline_data()
      -> f2fs_reserve_block(ipage)
	-> get_dnode_of_data()

This patch adds correct error handling codes when get_dnode_of_data() returns
an error.

At first, f2fs_reserve_block() calls f2fs_put_dnode() whenever reserve_new_block
returns an error.
So, the rule of f2fs_reserve_block() is to nullify inode page when there is any
error internally.

Finally, two callers of f2fs_reserve_block() should call f2fs_put_dnode()
appropriately if they got an error since successful f2fs_reserve_block().

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c   | 29 ++++++++++++++++++++---------
 fs/f2fs/dir.c    |  7 ++++---
 fs/f2fs/inline.c |  6 ++----
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fc7a28c..63d1902 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -258,13 +258,16 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
 	bool need_put = dn->inode_page ? false : true;
 	int err;
 
+	/* if inode_page exists, index should be zero */
+	f2fs_bug_on(!need_put && index);
+
 	err = get_dnode_of_data(dn, index, ALLOC_NODE);
 	if (err)
 		return err;
+
 	if (dn->data_blkaddr == NULL_ADDR)
 		err = reserve_new_block(dn);
-
-	if (need_put)
+	if (err || need_put)
 		f2fs_put_dnode(dn);
 	return err;
 }
@@ -510,10 +513,10 @@ repeat:
  *
  * Also, caller should grab and release a rwsem by calling f2fs_lock_op() and
  * f2fs_unlock_op().
- * Note that, npage is set only by make_empty_dir.
+ * Note that, ipage is set only by make_empty_dir.
  */
 struct page *get_new_data_page(struct inode *inode,
-		struct page *npage, pgoff_t index, bool new_i_size)
+		struct page *ipage, pgoff_t index, bool new_i_size)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
@@ -521,14 +524,16 @@ struct page *get_new_data_page(struct inode *inode,
 	struct dnode_of_data dn;
 	int err;
 
-	set_new_dnode(&dn, inode, npage, npage, 0);
+	set_new_dnode(&dn, inode, ipage, NULL, 0);
 	err = f2fs_reserve_block(&dn, index);
 	if (err)
 		return ERR_PTR(err);
 repeat:
 	page = grab_cache_page(mapping, index);
-	if (!page)
-		return ERR_PTR(-ENOMEM);
+	if (!page) {
+		err = -ENOMEM;
+		goto put_err;
+	}
 
 	if (PageUptodate(page))
 		return page;
@@ -540,11 +545,13 @@ repeat:
 		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 								READ_SYNC);
 		if (err)
-			return ERR_PTR(err);
+			goto put_err;
+
 		lock_page(page);
 		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 1);
-			return ERR_PTR(-EIO);
+			err = -EIO;
+			goto put_err;
 		}
 		if (unlikely(page->mapping != mapping)) {
 			f2fs_put_page(page, 1);
@@ -560,6 +567,10 @@ repeat:
 		mark_inode_dirty_sync(inode);
 	}
 	return page;
+
+put_err:
+	f2fs_put_dnode(&dn);
+	return ERR_PTR(err);
 }
 
 static int __allocate_data_block(struct dnode_of_data *dn)
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 6da77e5..f815ca0 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -342,11 +342,11 @@ static struct page *init_inode_metadata(struct inode *inode,
 
 		err = f2fs_init_acl(inode, dir, page);
 		if (err)
-			goto error;
+			goto put_error;
 
 		err = f2fs_init_security(inode, dir, name, page);
 		if (err)
-			goto error;
+			goto put_error;
 
 		wait_on_page_writeback(page);
 	} else {
@@ -370,8 +370,9 @@ static struct page *init_inode_metadata(struct inode *inode,
 	}
 	return page;
 
-error:
+put_error:
 	f2fs_put_page(page, 1);
+error:
 	remove_inode_page(inode);
 	return ERR_PTR(err);
 }
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index bcc6f65..afbdf87 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -81,10 +81,9 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	 * i_addr[0] is not used for inline data,
 	 * so reserving new block will not destroy inline data
 	 */
-	set_new_dnode(&dn, inode, ipage, ipage, 0);
+	set_new_dnode(&dn, inode, ipage, NULL, 0);
 	err = f2fs_reserve_block(&dn, 0);
 	if (err) {
-		f2fs_put_page(ipage, 1);
 		f2fs_unlock_op(sbi);
 		return err;
 	}
@@ -111,9 +110,8 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	stat_dec_inline_inode(inode);
 
 	sync_inode_page(&dn);
-	f2fs_put_page(ipage, 1);
+	f2fs_put_dnode(&dn);
 	f2fs_unlock_op(sbi);
-
 	return err;
 }
 
-- 
1.8.4.474.g128a96c

