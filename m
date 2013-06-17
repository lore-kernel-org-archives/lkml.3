Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3FQMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:09:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31070 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab3FQMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:09:18 -0400
X-AuditID: cbfee68e-b7f276d000002279-1c-51befc5a6494
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: recover wrong pino after checkpoint during fsync
Date: Mon, 17 Jun 2013 21:09:04 +0900
Message-id: <1371470944-15012-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t8zY92oP/sCDd4+0bK4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+NG82fGgqsaFXd2
	uzUw7lHsYuTgkBAwkdjaKNXFyAlkiklcuLeerYuRi0NIYBmjxPHLc9ghEiYSq6btZASxhQSm
	M0o0/hSEKGpjkri35g4byCA2AW2JzfsNQGpEBJglFkw9zwhSwywwgVHi/6L3LCAJYQF3iedd
	b1lB6lkEVCV+3WUCCfMChWfM2Ay1S1di0YmDrCC9EgK32SQmTnrCBpJgERCQ+Db5EAvE0bIS
	mw4wQ9RLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghwde3g/HmAetD
	jMlA4yYyS4km5wODN68k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjAtETmcuXqbwv2Ryxcl3OzZuffho62c7Zssre6QV728S5lTZOOFKBAu3xWRn
	M88JrP7yJatmn5cRvfh7Q4n423UuHs7X2Q40n3po+zPjteZzKbGym7vYXPiOvv+tN3vq54dv
	sxNymS8p7pvG3dJ+eebqp5s/K122uMd9WUzypqpHeuB+/tkLtx5QYinOSDTUYi4qTgQAkWH6
	L1QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd2oP/sCDeZ3qFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxo/kzY8FVjYo7u90aGPcodjFyckgImEismraTEcIWk7hwbz0biC0kMJ1R
	ovGnYBcjF5DdxiRxb80doAQHB5uAtsTm/QYgNSICzBILpp5nBKlhFpjAKPF/0XsWkISwgLvE
	8663rCD1LAKqEr/uMoGEeYHCM2ZsZofYpSux6MRB1gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBAf3M+kdjKsaLA4xCnAwKvHwctTtCxRiTSwrrsw9xCjBwawkwhs7ESjEm5JY
	WZValB9fVJqTWnyIMRlo+URmKdHkfGDk5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDY2ZeSN/cGZ2FnzLUlxyaL1x+Q/+C6ZWzKcnH5JbJ2Rw1OTxlslTz
	/NVeuSf2NFqt6C+Ye+1x4oLlEZw3L55xkT0od2XPRLGU+LZynvqiTSfvVK0VSe342DLxj4D4
	70NqKkuF/ovuYjpkJWajkBrwesPjieZHT51eX81lJuH1ZbG4uPtz7ddzbJVYijMSDbWYi4oT
	AXGFKZ+yAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a file is linked, f2fs loose its parent inode number so that fsync calls
for the linked file should do checkpoint all the time.
But, if we can recover its parent inode number after the checkpoint, we can
adjust roll-forward mechanism for the further fsync calls, which is able to
improve the fsync performance significatly.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c     |  2 +-
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/file.c    | 31 ++++++++++++++++++++++++++++++-
 fs/f2fs/namei.c   |  2 +-
 fs/f2fs/node.h    | 15 +++++++++++----
 fs/f2fs/segment.c |  2 +-
 6 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 69ca049..4f21452 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -356,7 +356,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 	 * We lost i_pino from now on.
 	 */
 	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK)) {
-		set_cp_file(inode);
+		file_lost_pino(inode);
 		inc_nlink(inode);
 	}
 	return page;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3e7cb33..863a5e91 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -151,7 +151,7 @@ struct extent_info {
  * i_advise uses FADVISE_XXX_BIT. We can add additional hints later.
  */
 #define FADVISE_COLD_BIT	0x01
-#define FADVISE_CP_BIT		0x02
+#define FADVISE_LOST_PINO_BIT	0x02
 
 struct f2fs_inode_info {
 	struct inode vfs_inode;		/* serve a vfs inode */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fda226f..d2d2b7d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -102,6 +102,24 @@ static const struct vm_operations_struct f2fs_file_vm_ops = {
 	.remap_pages	= generic_file_remap_pages,
 };
 
+static int get_parent_ino(struct inode *inode, nid_t *pino)
+{
+	struct dentry *dentry;
+
+	inode = igrab(inode);
+	dentry = d_find_any_alias(inode);
+	iput(inode);
+	if (!dentry)
+		return 0;
+
+	inode = igrab(dentry->d_parent->d_inode);
+	dput(dentry);
+
+	*pino = inode->i_ino;
+	iput(inode);
+	return 1;
+}
+
 int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
@@ -134,7 +152,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
 		need_cp = true;
-	else if (is_cp_file(inode))
+	else if (file_wrong_pino(inode))
 		need_cp = true;
 	else if (!space_for_roll_forward(sbi))
 		need_cp = true;
@@ -142,8 +160,19 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		need_cp = true;
 
 	if (need_cp) {
+		nid_t pino;
+
 		/* all the dirty node pages should be flushed for POR */
 		ret = f2fs_sync_fs(inode->i_sb, 1);
+		if (file_wrong_pino(inode) && inode->i_nlink == 1 &&
+					get_parent_ino(inode, &pino)) {
+			F2FS_I(inode)->i_pino = pino;
+			file_got_pino(inode);
+			mark_inode_dirty_sync(inode);
+			ret = f2fs_write_inode(inode, NULL);
+			if (ret)
+				goto out;
+		}
 	} else {
 		/* if there is no written node page, write its inode page */
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 810444e..64c0716 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -112,7 +112,7 @@ static inline void set_cold_files(struct f2fs_sb_info *sbi, struct inode *inode,
 	int count = le32_to_cpu(sbi->raw_super->extension_count);
 	for (i = 0; i < count; i++) {
 		if (is_multimedia_file(name, extlist[i])) {
-			set_cold_file(inode);
+			file_set_cold(inode);
 			break;
 		}
 	}
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index a503661..c65fb4f 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -285,10 +285,17 @@ static inline void set_file(struct inode *inode, int type)
 	F2FS_I(inode)->i_advise |= type;
 }
 
-#define is_cold_file(inode)	is_file(inode, FADVISE_COLD_BIT)
-#define is_cp_file(inode)	is_file(inode, FADVISE_CP_BIT)
-#define set_cold_file(inode)	set_file(inode, FADVISE_COLD_BIT)
-#define set_cp_file(inode)	set_file(inode, FADVISE_CP_BIT)
+static inline void clear_file(struct inode *inode, int type)
+{
+	F2FS_I(inode)->i_advise &= ~type;
+}
+
+#define file_is_cold(inode)	is_file(inode, FADVISE_COLD_BIT)
+#define file_wrong_pino(inode)	is_file(inode, FADVISE_LOST_PINO_BIT)
+#define file_set_cold(inode)	set_file(inode, FADVISE_COLD_BIT)
+#define file_lost_pino(inode)	set_file(inode, FADVISE_LOST_PINO_BIT)
+#define file_clear_cold(inode)	clear_file(inode, FADVISE_COLD_BIT)
+#define file_got_pino(inode)	clear_file(inode, FADVISE_LOST_PINO_BIT)
 
 static inline int is_cold_data(struct page *page)
 {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b15debc..0e1a60a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -796,7 +796,7 @@ static int __get_segment_type_6(struct page *page, enum page_type p_type)
 
 		if (S_ISDIR(inode->i_mode))
 			return CURSEG_HOT_DATA;
-		else if (is_cold_data(page) || is_cold_file(inode))
+		else if (is_cold_data(page) || file_is_cold(inode))
 			return CURSEG_COLD_DATA;
 		else
 			return CURSEG_WARM_DATA;
-- 
1.8.3.1.437.g0dbd812

