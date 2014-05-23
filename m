Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaEWJo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:44:27 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61261 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaEWJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:24 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 12/13] fs: limit filesystem stacking depth
Date: Fri, 23 May 2014 11:43:42 +0200
Message-Id: <1400838223-30844-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a simple read-only counter to super_block that indicates how deep this
is in the stack of filesystems.  Previously ecryptfs was the only stackable
filesystem and it explicitly disallowed multiple layers of itself.

Overlayfs, however, can be stacked recursively and also may be stacked
on top of ecryptfs or vice versa.

To limit the kernel stack usage we must limit the depth of the
filesystem stack.  Initially the limit is set to 2.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/main.c   |  7 +++++++
 fs/overlayfs/super.c | 10 ++++++++++
 include/linux/fs.h   | 11 +++++++++++
 3 files changed, 28 insertions(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 1b119d3bf924..c4cd1fd86cc2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -566,6 +566,13 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;
 	s->s_magic = ECRYPTFS_SUPER_MAGIC;
+	s->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
+
+	rc = -EINVAL;
+	if (s->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+		pr_err("eCryptfs: maximum fs stacking depth exceeded\n");
+		goto out_free;
+	}
 
 	inode = ecryptfs_get_inode(path.dentry->d_inode, s);
 	rc = PTR_ERR(inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fcbd92a14e69..04879abbbf98 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -644,6 +644,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	ufs->lower_namelen = statfs.f_namelen;
 
+	sb->s_stack_depth = max(upperpath.mnt->mnt_sb->s_stack_depth,
+				lowerpath.mnt->mnt_sb->s_stack_depth) + 1;
+
+	err = -EINVAL;
+	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+		pr_err("overlayfs: maximum fs stacking depth exceeded\n");
+		goto out_put_lowerpath;
+	}
+
+
 	ufs->upper_mnt = clone_private_mount(&upperpath);
 	err = PTR_ERR(ufs->upper_mnt);
 	if (IS_ERR(ufs->upper_mnt)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48d3bd908b5d..340c5e3be0d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -266,6 +266,12 @@ struct iattr {
  */
 #include <linux/quota.h>
 
+/*
+ * Maximum number of layers of fs stack.  Needs to be limited to
+ * prevent kernel stack overflow
+ */
+#define FILESYSTEM_MAX_STACK_DEPTH 2
+
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
  *
@@ -1269,6 +1275,11 @@ struct super_block {
 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
 	struct rcu_head		rcu;
+
+	/*
+	 * Indicates how deep in a filesystem stack this SB is
+	 */
+	int s_stack_depth;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.8.1.4

