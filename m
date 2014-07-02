Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaGBUB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:01:26 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:63375 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbaGBUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:01:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IANxjtFNXQBPR/2dsb2JhbABagw2sZQUBAQEBAQEFAW4BmWeBBxd1hDEvI4EaN4guAxUBwHMLhnuFcIkyHYQtBZAFimiLSohAg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS/BFS: use bfs prefix for dump_imap
Date: Wed,  2 Jul 2014 22:00:01 +0200
Message-Id: <1404331201-3662-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All bfs related functions use bfs_ prefix.
This patch also moves extern declaration to bfs.h
and removes prototype from inode.c

This fixes checkpatch warning:
'WARNING: externs should be avoided in .c files'

Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 fs/bfs/bfs.h   | 1 +
 fs/bfs/dir.c   | 4 +---
 fs/bfs/inode.c | 8 +++-----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index f7f87e2..f40006d 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -46,6 +46,7 @@ static inline struct bfs_inode_info *BFS_I(struct inode *inode)
 
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
+extern void bfs_dump_imap(const char *, struct super_block *);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index a399e6d..08063ae 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -75,8 +75,6 @@ const struct file_operations bfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 };
 
-extern void dump_imap(const char *, struct super_block *);
-
 static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 						bool excl)
 {
@@ -110,7 +108,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
         mark_inode_dirty(inode);
-	dump_imap("create", s);
+	bfs_dump_imap("create", s);
 
 	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
 							inode->i_ino);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 7041ac3..90bc079 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -30,8 +30,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block *s);
-
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct bfs_inode *di;
@@ -194,7 +192,7 @@ static void bfs_evict_inode(struct inode *inode)
 			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
-		dump_imap("delete_inode", s);
+		bfs_dump_imap("delete_inode", s);
         }
 
 	/*
@@ -297,7 +295,7 @@ static const struct super_operations bfs_sops = {
 	.statfs		= bfs_statfs,
 };
 
-void dump_imap(const char *prefix, struct super_block *s)
+void bfs_dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
@@ -443,7 +441,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	}
 	brelse(bh);
 	brelse(sbh);
-	dump_imap("read_super", s);
+	bfs_dump_imap("read_super", s);
 	return 0;
 
 out3:
-- 
1.8.4.5

