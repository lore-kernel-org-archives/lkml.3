Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab3DISOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:14:34 -0400
Received: from mail.ispras.ru ([83.149.199.45]:59151 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764934Ab3DISOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:14:32 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/2] hfsplus: add error propagation to __hfsplus_ext_write_extent()
Date: Tue,  9 Apr 2013 22:14:03 +0400
Message-Id: <1365531243-23775-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365531243-23775-1-git-send-email-khoroshilov@ispras.ru>
References: <1365400526.2673.3.camel@slavad-ubuntu>
 <1365531243-23775-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__hfsplus_ext_write_extent() suppresses errors coming from hfs_brec_find().
The patch implements error code propagation.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfsplus/extents.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index a94f0f7..fed73f7 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -83,7 +83,7 @@ static u32 hfsplus_ext_lastblock(struct hfsplus_extent *ext)
 	return be32_to_cpu(ext->start_block) + be32_to_cpu(ext->block_count);
 }
 
-static void __hfsplus_ext_write_extent(struct inode *inode,
+static int __hfsplus_ext_write_extent(struct inode *inode,
 		struct hfs_find_data *fd)
 {
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
@@ -98,13 +98,13 @@ static void __hfsplus_ext_write_extent(struct inode *inode,
 	res = hfs_brec_find(fd, hfs_find_rec_by_key);
 	if (hip->extent_state & HFSPLUS_EXT_NEW) {
 		if (res != -ENOENT)
-			return;
+			return res;
 		hfs_brec_insert(fd, hip->cached_extents,
 				sizeof(hfsplus_extent_rec));
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
 	} else {
 		if (res)
-			return;
+			return res;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
@@ -117,11 +117,13 @@ static void __hfsplus_ext_write_extent(struct inode *inode,
 	 * to explicily mark the inode dirty, too.
 	 */
 	set_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
+
+	return 0;
 }
 
 static int hfsplus_ext_write_extent_locked(struct inode *inode)
 {
-	int res;
+	int res = 0;
 
 	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
 		struct hfs_find_data fd;
@@ -129,10 +131,10 @@ static int hfsplus_ext_write_extent_locked(struct inode *inode)
 		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
 		if (res)
 			return res;
-		__hfsplus_ext_write_extent(inode, &fd);
+		res = __hfsplus_ext_write_extent(inode, &fd);
 		hfs_find_exit(&fd);
 	}
-	return 0;
+	return res;
 }
 
 int hfsplus_ext_write_extent(struct inode *inode)
@@ -175,8 +177,11 @@ static inline int __hfsplus_ext_cache_extent(struct hfs_find_data *fd,
 
 	WARN_ON(!mutex_is_locked(&hip->extents_lock));
 
-	if (hip->extent_state & HFSPLUS_EXT_DIRTY)
-		__hfsplus_ext_write_extent(inode, fd);
+	if (hip->extent_state & HFSPLUS_EXT_DIRTY) {
+		res = __hfsplus_ext_write_extent(inode, fd);
+		if (res)
+			return res;
+	}
 
 	res = __hfsplus_ext_read_extent(fd, hip->cached_extents, inode->i_ino,
 					block, HFSPLUS_IS_RSRC(inode) ?
-- 
1.7.9.5

