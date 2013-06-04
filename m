Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3FDXjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:39:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42248 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751494Ab3FDXjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:39:42 -0400
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] jfs: Reduce object size when CONFIG_PRINTK=n
Date: Tue,  4 Jun 2013 16:39:16 -0700
Message-Id: <14427e90798e11d5a51dff663278bd10df081554.1370388945.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370388945.git.joe@perches.com>
References: <cover.1370388945.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the jfs_error format and arguments to be
optimized away when not using printk.

Reduces object size ~3KB

    $ grep -E "CONFIG_PRINTK|CONFIG_JFS" .config
    # CONFIG_PRINTK is not set
    CONFIG_JFS_FS=y
    CONFIG_JFS_POSIX_ACL=y
    CONFIG_JFS_SECURITY=y
    # CONFIG_JFS_DEBUG is not set
    CONFIG_JFS_STATISTICS=y

$ size fs/jfs/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 136521	   1408	    520	 138449	  21cd1	fs/jfs/built-in.o.new
 139834	   1408	    552	 141794	  229e2	fs/jfs/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jfs/jfs_superblock.h | 16 +++++++++++++++-
 fs/jfs/super.c          |  4 ++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_superblock.h b/fs/jfs/jfs_superblock.h
index 04847b8..85b1b31 100644
--- a/fs/jfs/jfs_superblock.h
+++ b/fs/jfs/jfs_superblock.h
@@ -108,8 +108,22 @@ struct jfs_superblock {
 
 extern int readSuper(struct super_block *, struct buffer_head **);
 extern int updateSuper(struct super_block *, uint);
+extern void jfs_handle_error(struct super_block *sb);
 __printf(2, 3)
-extern void jfs_error(struct super_block *, const char *, ...);
+extern void _jfs_error(struct super_block *, const char *, ...);
+
+#ifdef CONFIG_PRINTK
+#define jfs_error(sb, fmt, ...)			\
+	_jfs_error(sb, fmt, ##__VA_ARGS__)
+#else
+#define jfs_error(sb, fmt, ...)			\
+do {						\
+	if (0)					\
+		printk(fmt, ##__VA_ARGS__);	\
+	jfs_handle_error(sb);			\
+} while (0)
+#endif
+
 extern int jfs_mount(struct super_block *);
 extern int jfs_mount_rw(struct super_block *, int);
 extern int jfs_umount(struct super_block *);
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 6669aa2..08a826e 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -70,7 +70,7 @@ module_param(jfsloglevel, int, 0644);
 MODULE_PARM_DESC(jfsloglevel, "Specify JFS loglevel (0, 1 or 2)");
 #endif
 
-static void jfs_handle_error(struct super_block *sb)
+void jfs_handle_error(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
@@ -92,7 +92,7 @@ static void jfs_handle_error(struct super_block *sb)
 	/* nothing is done for continue beyond marking the superblock dirty */
 }
 
-void jfs_error(struct super_block *sb, const char *fmt, ...)
+void _jfs_error(struct super_block *sb, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-- 
1.8.1.2.459.gbcd45b4.dirty

