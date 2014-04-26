Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaDZIqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:46:11 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:11128 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbaDZIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:46:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIQAKZxW1NXQCJ0/2dsb2JhbABZgwarfwEBAwQBmXECAoEOF3SCUxMcIxiBAiQTiEUBywaFWoNdhSKEQAEDjnuKDwGSXIMzOw
Date: Sat, 26 Apr 2014 10:48:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, "Dave.Kleikamp" <shaggy@kernel.org>
Subject: [PATCH 1/1] fs/jfs/super.c: remove 0 assignement to static + code
 clean-up
Message-Id: <20140426104806.024d5b0803e4acbf7c36e71f@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Static values are automatically initialized to NULL
-Coalesce format fragments
-Remove unnecessary {}
-Small typo fixes
-Fix lines > 80 characters

Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/super.c | 45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 97f7fda..d1096fe 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -50,14 +50,14 @@ MODULE_DESCRIPTION("The Journaled Filesystem (JFS)");
 MODULE_AUTHOR("Steve Best/Dave Kleikamp/Barry Arndt, IBM");
 MODULE_LICENSE("GPL");
 
-static struct kmem_cache * jfs_inode_cachep;
+static struct kmem_cache *jfs_inode_cachep;
 
 static const struct super_operations jfs_super_operations;
 static const struct export_operations jfs_export_operations;
 static struct file_system_type jfs_fs_type;
 
 #define MAX_COMMIT_THREADS 64
-static int commit_threads = 0;
+static int commit_threads;
 module_param(commit_threads, int, 0);
 MODULE_PARM_DESC(commit_threads, "Number of commit threads");
 
@@ -84,8 +84,7 @@ static void jfs_handle_error(struct super_block *sb)
 		panic("JFS (device %s): panic forced after error\n",
 			sb->s_id);
 	else if (sbi->flag & JFS_ERR_REMOUNT_RO) {
-		jfs_err("ERROR: (device %s): remounting filesystem "
-			"as read-only\n",
+		jfs_err("ERROR: (device %s): remounting filesystem as read-only\n",
 			sb->s_id);
 		sb->s_flags |= MS_RDONLY;
 	}
@@ -363,12 +362,10 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 			 * -> user has more control over the online trimming
 			 */
 			sbi->minblks_trim = 64;
-			if (blk_queue_discard(q)) {
+			if (blk_queue_discard(q))
 				*flag |= JFS_DISCARD;
-			} else {
-				pr_err("JFS: discard option " \
-					"not supported on device\n");
-			}
+			else
+				pr_err("JFS: discard option not supported on device\n");
 			break;
 		}
 
@@ -385,15 +382,14 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 				sbi->minblks_trim = simple_strtoull(
 					minblks_trim, &minblks_trim, 0);
 			} else {
-				pr_err("JFS: discard option " \
-					"not supported on device\n");
+				pr_err("JFS: discard option not supported on device\n");
 			}
 			break;
 		}
 
 		default:
-			printk("jfs: Unrecognized mount option \"%s\" "
-					" or missing value\n", p);
+			printk("jfs: Unrecognized mount option \"%s\" or missing value\n",
+			       p);
 			goto cleanup;
 		}
 	}
@@ -419,14 +415,12 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 	int ret;
 
 	sync_filesystem(sb);
-	if (!parse_options(data, sb, &newLVSize, &flag)) {
+	if (!parse_options(data, sb, &newLVSize, &flag))
 		return -EINVAL;
-	}
 
 	if (newLVSize) {
 		if (sb->s_flags & MS_RDONLY) {
-			pr_err("JFS: resize requires volume" \
-				" to be mounted read-write\n");
+			pr_err("JFS: resize requires volume to be mounted read-write\n");
 			return -EROFS;
 		}
 		rc = jfs_extendfs(sb, newLVSize, 0);
@@ -452,9 +446,8 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 	}
 	if ((!(sb->s_flags & MS_RDONLY)) && (*flags & MS_RDONLY)) {
 		rc = dquot_suspend(sb, -1);
-		if (rc < 0) {
+		if (rc < 0)
 			return rc;
-		}
 		rc = jfs_umount_rw(sb);
 		JFS_SBI(sb)->flag = flag;
 		return rc;
@@ -487,7 +480,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!new_valid_dev(sb->s_bdev->bd_dev))
 		return -EOVERFLOW;
 
-	sbi = kzalloc(sizeof (struct jfs_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(struct jfs_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
 
@@ -548,9 +541,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	rc = jfs_mount(sb);
 	if (rc) {
-		if (!silent) {
+		if (!silent)
 			jfs_err("jfs_mount failed w/return code = %d", rc);
-		}
 		goto out_mount_failed;
 	}
 	if (sb->s_flags & MS_RDONLY)
@@ -587,7 +579,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Page cache is indexed by long.
 	 * I would use MAX_LFS_FILESIZE, but it's only half as big
 	 */
-	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, (u64)sb->s_maxbytes);
+	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1,
+			     (u64)sb->s_maxbytes);
 #endif
 	sb->s_time_gran = 1;
 	return 0;
@@ -597,9 +590,8 @@ out_no_root:
 
 out_no_rw:
 	rc = jfs_umount(sb);
-	if (rc) {
+	if (rc)
 		jfs_err("jfs_umount failed with return code %d", rc);
-	}
 out_mount_failed:
 	filemap_write_and_wait(sbi->direct_inode->i_mapping);
 	truncate_inode_pages(sbi->direct_inode->i_mapping, 0);
@@ -924,7 +916,8 @@ static int __init init_jfs_fs(void)
 		commit_threads = MAX_COMMIT_THREADS;
 
 	for (i = 0; i < commit_threads; i++) {
-		jfsCommitThread[i] = kthread_run(jfs_lazycommit, NULL, "jfsCommit");
+		jfsCommitThread[i] = kthread_run(jfs_lazycommit, NULL,
+						 "jfsCommit");
 		if (IS_ERR(jfsCommitThread[i])) {
 			rc = PTR_ERR(jfsCommitThread[i]);
 			jfs_err("init_jfs_fs: fork failed w/rc = %d", rc);
-- 
1.8.4.5

