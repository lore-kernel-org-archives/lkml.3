Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaJNQfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:35:44 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:37924 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbaJNQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:35:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8NAIJQPVRbtAZ+/2dsb2JhbABbgw5TWLh2BQFzkkGHVYEWFwF9hDAvI4EaN4hCAbdOjxsshiCJOWyEUgWGLYskhGqHEIEuhnOEO4k1gUdtgUU7L4EPgTsBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2 linux-next] fs/affs/amigaffs.c: use va_format instead of buffer/vnsprintf
Date: Tue, 14 Oct 2014 18:35:34 +0200
Message-Id: <1413304534-7000-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Remove ErrorBuffer and use %pV
-Add __printf to enable argument mistmatch warnings

Original-patch-by: Joe Perches <joe@perches.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: add __printf (suggested by Joe Perches)

 fs/affs/affs.h     |  2 ++
 fs/affs/amigaffs.c | 28 +++++++++++++---------------
 fs/affs/file.c     | 16 ++++++++++------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 9bca881..ff44ff3 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -135,8 +135,10 @@ extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
 extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
+__printf(3, 4)
 extern void	affs_error(struct super_block *sb, const char *function,
 			   const char *fmt, ...);
+__printf(3, 4)
 extern void	affs_warning(struct super_block *sb, const char *function,
 			     const char *fmt, ...);
 extern bool	affs_nofilenametruncate(const struct dentry *dentry);
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index abc8539..9643bdd 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-static char ErrorBuffer[256];
-
 /*
  * Functions for accessing Amiga-FFS structures.
  */
@@ -444,30 +442,30 @@ mode_to_prot(struct inode *inode)
 void
 affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
-
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
-	va_end(args);
+	struct va_format vaf;
+	va_list args;
 
-	pr_crit("error (device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	if (!(sb->s_flags & MS_RDONLY))
 		pr_warn("Remounting filesystem read-only\n");
 	sb->s_flags |= MS_RDONLY;
+	va_end(args);
 }
 
 void
 affs_warning(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
+	struct va_format vaf;
+	va_list args;
 
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	va_end(args);
-
-	pr_warn("(device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
 }
 
 bool
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 1ed590a..cdc6a2b 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -355,7 +355,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%x)", bh_result->b_blocknr);
+			affs_warning(sb, "get_block", "block already set (%lx)",
+				     (unsigned long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -377,7 +378,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb,"get_block","strange block request %d", block);
+	affs_error(inode->i_sb, "get_block", "strange block request %d",
+		   (int)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -867,8 +869,9 @@ affs_truncate(struct inode *inode)
 	// lock cache
 	ext_bh = affs_get_extblock(inode, ext);
 	if (IS_ERR(ext_bh)) {
-		affs_warning(sb, "truncate", "unexpected read error for ext block %u (%d)",
-			     ext, PTR_ERR(ext_bh));
+		affs_warning(sb, "truncate",
+			     "unexpected read error for ext block %u (%ld)",
+			     (unsigned int)ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -914,8 +917,9 @@ affs_truncate(struct inode *inode)
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
-				affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
-					     ext, PTR_ERR(bh));
+				affs_warning(sb, "truncate",
+					     "unexpected read error for last block %u (%ld)",
+					     (unsigned int)ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
-- 
1.9.3

