Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab3EWN6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:51 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61010 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab3EWN6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:48 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/4] f2fs: optimize several routines in node.h
Date: Thu, 23 May 2013 22:58:40 +0900
Message-Id: <1369317520-14414-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

There are various functions with common code which could be separated
out to make common routines. So, made new routines and in order to
retain the same call path and no major changes, written some macros
to access those routines.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.h |   68 ++++++++++++++++----------------------------------------
 1 file changed, 19 insertions(+), 49 deletions(-)

diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 0a2d72f..37e1b90 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -275,25 +275,20 @@ static inline nid_t get_nid(struct page *p, int off, bool i)
  *  - Mark cold node blocks in their node footer
  *  - Mark cold data pages in page cache
  */
-static inline int is_cold_file(struct inode *inode)
-{
-	return F2FS_I(inode)->i_advise & FADVISE_COLD_BIT;
-}
-
-static inline void set_cold_file(struct inode *inode)
-{
-	F2FS_I(inode)->i_advise |= FADVISE_COLD_BIT;
-}
 
-static inline int is_cp_file(struct inode *inode)
+static inline int is_file(struct inode *inode, int type)
 {
-	return F2FS_I(inode)->i_advise & FADVISE_CP_BIT;
+	return F2FS_I(inode)->i_advise & type;
 }
 
-static inline void set_cp_file(struct inode *inode)
+static inline void set_file(struct inode *inode, int type)
 {
-	F2FS_I(inode)->i_advise |= FADVISE_CP_BIT;
+	F2FS_I(inode)->i_advise |= type;
 }
+#define is_cold_file(inode)	is_file(inode, FADVISE_COLD_BIT)
+#define is_cp_file(inode)	is_file(inode, FADVISE_CP_BIT)
+#define set_cold_file(inode)	set_file(inode, FADVISE_COLD_BIT)
+#define set_cp_file(inode)	set_file(inode, FADVISE_CP_BIT)
 
 static inline int is_cold_data(struct page *page)
 {
@@ -310,29 +305,15 @@ static inline void clear_cold_data(struct page *page)
 	ClearPageChecked(page);
 }
 
-static inline int is_cold_node(struct page *page)
-{
-	void *kaddr = page_address(page);
-	struct f2fs_node *rn = (struct f2fs_node *)kaddr;
-	unsigned int flag = le32_to_cpu(rn->footer.flag);
-	return flag & (0x1 << COLD_BIT_SHIFT);
-}
-
-static inline unsigned char is_fsync_dnode(struct page *page)
-{
-	void *kaddr = page_address(page);
-	struct f2fs_node *rn = (struct f2fs_node *)kaddr;
-	unsigned int flag = le32_to_cpu(rn->footer.flag);
-	return flag & (0x1 << FSYNC_BIT_SHIFT);
-}
-
-static inline unsigned char is_dent_dnode(struct page *page)
+static inline int is_node(struct page *page, int type)
 {
 	void *kaddr = page_address(page);
 	struct f2fs_node *rn = (struct f2fs_node *)kaddr;
-	unsigned int flag = le32_to_cpu(rn->footer.flag);
-	return flag & (0x1 << DENT_BIT_SHIFT);
+	return le32_to_cpu(rn->footer.flag) & (1 << type);
 }
+#define is_cold_node(page)    is_node(page, COLD_BIT_SHIFT)
+#define is_fsync_dnode(page)  is_node(page, FSYNC_BIT_SHIFT)
+#define is_dent_dnode(page)   is_node(page, DENT_BIT_SHIFT)
 
 static inline void set_cold_node(struct inode *inode, struct page *page)
 {
@@ -346,26 +327,15 @@ static inline void set_cold_node(struct inode *inode, struct page *page)
 	rn->footer.flag = cpu_to_le32(flag);
 }
 
-static inline void set_fsync_mark(struct page *page, int mark)
+static inline void set_mark(struct page *page, int mark, int type)
 {
-	void *kaddr = page_address(page);
-	struct f2fs_node *rn = (struct f2fs_node *)kaddr;
-	unsigned int flag = le32_to_cpu(rn->footer.flag);
-	if (mark)
-		flag |= (0x1 << FSYNC_BIT_SHIFT);
-	else
-		flag &= ~(0x1 << FSYNC_BIT_SHIFT);
-	rn->footer.flag = cpu_to_le32(flag);
-}
-
-static inline void set_dentry_mark(struct page *page, int mark)
-{
-	void *kaddr = page_address(page);
-	struct f2fs_node *rn = (struct f2fs_node *)kaddr;
+	struct f2fs_node *rn = (struct f2fs_node *)page_address(page);
 	unsigned int flag = le32_to_cpu(rn->footer.flag);
 	if (mark)
-		flag |= (0x1 << DENT_BIT_SHIFT);
+		flag |= (0x1 << type);
 	else
-		flag &= ~(0x1 << DENT_BIT_SHIFT);
+		flag &= ~(0x1 << type);
 	rn->footer.flag = cpu_to_le32(flag);
 }
+#define set_dentry_mark(page, mark)	set_mark(page, mark, DENT_BIT_SHIFT)
+#define set_fsync_mark(page, mark)	set_mark(page, mark, FSYNC_BIT_SHIFT)
-- 
1.7.9.5

