Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab3KFNsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:47 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54726 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab3KFNsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:41 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 09/11] VFS hot tracking, btrfs: Add hot tracking support
Date: Wed,  6 Nov 2013 21:45:42 +0800
Message-Id: <1383745544-391-10-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-0320-0000-0000-000001A3EE4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Introduce one new mount option '-o hot_track',
and add its parsing support.

Its usage looks like:
   mount -o hot_track
   mount -o nouser,hot_track
   mount -o nouser,hot_track,loop
   mount -o hot_track,nouser

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/super.c | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0506f40..b8d8982 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1990,6 +1990,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
+#define BTRFS_MOUNT_HOT_TRACK		(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e913328..69fe31d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -42,6 +42,7 @@
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
 #include <linux/btrfs.h>
+#include <linux/hot_tracking.h>
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -310,6 +311,10 @@ static void btrfs_put_super(struct super_block *sb)
 	 * last process that kept it busy.  Or segfault in the aforementioned
 	 * process...  Whom would you report that to?
 	 */
+
+	/* Hot data tracking */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+		hot_track_exit(sb);
 }
 
 enum {
@@ -323,7 +328,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval,
+	Opt_commit_interval, Opt_hot_track,
 	Opt_err,
 };
 
@@ -366,6 +371,7 @@ static match_table_t tokens = {
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
+	{Opt_hot_track, "hot_track"},
 	{Opt_err, NULL},
 };
 
@@ -676,6 +682,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 			}
 			break;
+		case Opt_hot_track:
+			btrfs_set_opt(info->mount_opt, HOT_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -898,11 +907,20 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+		err = hot_track_init(sb);
+		if (err)
+			goto fail_hot;
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
 
+fail_hot:
+	dput(sb->s_root);
+	sb->s_root = NULL;
 fail_close:
 	close_ctree(fs_info->tree_root);
 	return err;
@@ -1014,6 +1032,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
 		seq_printf(seq, ",commit=%d", info->commit_interval);
+	if (btrfs_test_opt(root, HOT_TRACK))
+		seq_puts(seq, ",hot_track");
 	return 0;
 }
 
-- 
1.7.11.7

