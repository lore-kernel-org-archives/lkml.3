Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaHICui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:50:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63230 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHICuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:50:37 -0400
X-AuditID: cbfee61a-f79e46d00000134f-95-53e58c7cefbc
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 4/5] f2fs: enable inline dir handling
Date: Sat, 09 Aug 2014 10:49:38 +0800
Message-id: <00c201cfb37c$b26f7800$174e6800$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yucGhjEFjBRhzRoqIeg+pLntjqA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd2anqfBBnsmSVlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49rDLsaC
	CVIVf1a0sTQwrhbtYuTkkBAwkfh37wcrhC0mceHeerYuRi4OIYFFjBLN/9+zQjg/GCW2ruti
	AaliE1CRWN7xnwnEFhHwkpi0/wRYnFnAQ6Kx4zvYJGEBe4k5Ow6A1bAIqEqsOAEyiIODV8BS
	4tUSSZAwr4CgxI/J96BatSQ2b2tihbDlJTavecsMcZCCxI6zrxlBWkUE9CTuX1OFKBGX2Hjk
	FssERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNDPpHYw
	rmywOMQowMGoxMO7wuZpsBBrYllxZe4hRgkOZiUR3oWVQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Me32z99QnVQXmi0vcK+36Ei3AayLspV/xd+qx
	raUbv7mdnNobvqFtWTNv2AeRN78f8d27VqB/cFfbiws6jwQur+P9y1lWIZAofmDppv2LV1tO
	czLQnvTlyldbK6HzyjX6DCprYq88XBR9j7/Jw6j/4/ytSvOtq16nXD0e84z937nvb8rWHWu3
	UmIpzkg01GIuKk4EAHsawiFkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add inline dir functions into normal dir ops' function to handle inline ops.
Besides, we enable inline dir mode when a new dir inode is created if
inline_data option is on.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c   | 26 ++++++++++++++++++++++++++
 fs/f2fs/namei.c |  4 ++++
 2 files changed, 30 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 154a5fa..0e681e0 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -201,6 +201,9 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 	unsigned int max_depth;
 	unsigned int level;
 
+	if (f2fs_has_inline_data(dir))
+		return find_in_inline_dir(dir, child, res_page);
+
 	if (npages == 0)
 		return NULL;
 
@@ -227,6 +230,9 @@ struct f2fs_dir_entry *f2fs_parent_dir(struct inode *dir, struct page **p)
 	struct f2fs_dir_entry *de;
 	struct f2fs_dentry_block *dentry_blk;
 
+	if (f2fs_has_inline_data(dir))
+		return f2fs_parent_inline_dir(dir, p);
+
 	page = get_lock_data_page(dir, 0);
 	if (IS_ERR(page))
 		return NULL;
@@ -304,6 +310,9 @@ static int make_empty_dir(struct inode *inode,
 	struct f2fs_dentry_block *dentry_blk;
 	struct f2fs_dir_entry *de;
 
+	if (f2fs_has_inline_data(inode))
+		return make_empty_inline_dir(inode, parent, page);
+
 	dentry_page = get_new_data_page(inode, page, 0, true);
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
@@ -464,6 +473,14 @@ int __f2fs_add_link(struct inode *dir, const struct qstr *name,
 	int err = 0;
 	int i;
 
+	if (f2fs_has_inline_data(dir)) {
+		err = f2fs_add_inline_entry(dir, name, inode);
+		if (!err || err != -EAGAIN)
+			return err;
+		else
+			err = 0;
+	}
+
 	dentry_hash = f2fs_dentry_hash(name);
 	level = 0;
 	current_depth = F2FS_I(dir)->i_current_depth;
@@ -573,6 +590,9 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	int i;
 
+	if (f2fs_has_inline_data(dir))
+		return f2fs_delete_inline_entry(dentry, page, dir, inode);
+
 	lock_page(page);
 	f2fs_wait_on_page_writeback(page, DATA);
 
@@ -631,6 +651,9 @@ bool f2fs_empty_dir(struct inode *dir)
 	struct f2fs_dentry_block *dentry_blk;
 	unsigned long nblock = dir_blocks(dir);
 
+	if (f2fs_has_inline_data(dir))
+		return f2fs_empty_inline_dir(dir);
+
 	for (bidx = 0; bidx < nblock; bidx++) {
 		dentry_page = get_lock_data_page(dir, bidx);
 		if (IS_ERR(dentry_page)) {
@@ -670,6 +693,9 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned int n = ((unsigned long)ctx->pos / NR_DENTRY_IN_BLOCK);
 	unsigned char d_type = DT_UNKNOWN;
 
+	if (f2fs_has_inline_data(inode))
+		return f2fs_read_inline_dir(file, ctx);
+
 	bit_pos = ((unsigned long)ctx->pos % NR_DENTRY_IN_BLOCK);
 
 	/* readahead for multi pages of dir */
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 648b968..06b93ee 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -54,6 +54,10 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 		nid_free = true;
 		goto out;
 	}
+
+	if (test_opt(sbi, INLINE_DATA) && S_ISDIR(inode->i_mode))
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+
 	trace_f2fs_new_inode(inode, 0);
 	mark_inode_dirty(inode);
 	return inode;
-- 
2.0.1.474.g72c7794


