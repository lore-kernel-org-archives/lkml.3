Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3BSKeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621Ab3BSKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:09 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/10] GFS2: Clean up freeze code
Date: Tue, 19 Feb 2013 10:07:36 +0000
Message-Id: <1361268460-3092-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freeze code has not been looked at a lot recently. Upstream has
moved on, and this is an attempt to catch us back up again. There
is a vfs level interface for the freeze code which can be called
from our (obsolete, but kept for backward compatibility purposes)
sysfs freeze interface. This means freezing this way vs. doing it
from the ioctl should now work in identical fashion.

As a result of this, the freeze function is only called once
and we can drop our own special purpose code for counting the
number of freezes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 5d129ab..19750bc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -757,10 +757,7 @@ struct gfs2_sbd {
 	unsigned int sd_replayed_blocks;
 
 	/* For quiescing the filesystem */
-
 	struct gfs2_holder sd_freeze_gh;
-	struct mutex sd_freeze_lock;
-	unsigned int sd_freeze_count;
 
 	char sd_fsname[GFS2_FSNAME_LEN];
 	char sd_table_name[GFS2_FSNAME_LEN];
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 0e3554e..5f5aba5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -115,8 +115,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	INIT_LIST_HEAD(&sdp->sd_revoke_list);
 
-	mutex_init(&sdp->sd_freeze_lock);
-
 	return sdp;
 }
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4dfda4c..c075b62 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -663,54 +663,6 @@ out:
 	return error;
 }
 
-/**
- * gfs2_freeze_fs - freezes the file system
- * @sdp: the file system
- *
- * This function flushes data and meta data for all machines by
- * acquiring the transaction log exclusively.  All journals are
- * ensured to be in a clean state as well.
- *
- * Returns: errno
- */
-
-int gfs2_freeze_fs(struct gfs2_sbd *sdp)
-{
-	int error = 0;
-
-	mutex_lock(&sdp->sd_freeze_lock);
-
-	if (!sdp->sd_freeze_count++) {
-		error = gfs2_lock_fs_check_clean(sdp, &sdp->sd_freeze_gh);
-		if (error)
-			sdp->sd_freeze_count--;
-	}
-
-	mutex_unlock(&sdp->sd_freeze_lock);
-
-	return error;
-}
-
-/**
- * gfs2_unfreeze_fs - unfreezes the file system
- * @sdp: the file system
- *
- * This function allows the file system to proceed by unlocking
- * the exclusively held transaction lock.  Other GFS2 nodes are
- * now free to acquire the lock shared and go on with their lives.
- *
- */
-
-void gfs2_unfreeze_fs(struct gfs2_sbd *sdp)
-{
-	mutex_lock(&sdp->sd_freeze_lock);
-
-	if (sdp->sd_freeze_count && !--sdp->sd_freeze_count)
-		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
-
-	mutex_unlock(&sdp->sd_freeze_lock);
-}
-
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 {
 	struct gfs2_dinode *str = buf;
@@ -888,13 +840,6 @@ static void gfs2_put_super(struct super_block *sb)
 	int error;
 	struct gfs2_jdesc *jd;
 
-	/*  Unfreeze the filesystem, if we need to  */
-
-	mutex_lock(&sdp->sd_freeze_lock);
-	if (sdp->sd_freeze_count)
-		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
-	mutex_unlock(&sdp->sd_freeze_lock);
-
 	/* No more recovery requests */
 	set_bit(SDF_NORECOVERY, &sdp->sd_flags);
 	smp_mb();
@@ -985,7 +930,7 @@ static int gfs2_freeze(struct super_block *sb)
 		return -EINVAL;
 
 	for (;;) {
-		error = gfs2_freeze_fs(sdp);
+		error = gfs2_lock_fs_check_clean(sdp, &sdp->sd_freeze_gh);
 		if (!error)
 			break;
 
@@ -1013,7 +958,9 @@ static int gfs2_freeze(struct super_block *sb)
 
 static int gfs2_unfreeze(struct super_block *sb)
 {
-	gfs2_unfreeze_fs(sb->s_fs_info);
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+
+	gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
 	return 0;
 }
 
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index a046468..90e3322 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -46,9 +46,6 @@ extern void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
 			  struct buffer_head *l_bh);
 extern int gfs2_statfs_sync(struct super_block *sb, int type);
 
-extern int gfs2_freeze_fs(struct gfs2_sbd *sdp);
-extern void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
-
 extern struct file_system_type gfs2_fs_type;
 extern struct file_system_type gfs2meta_fs_type;
 extern const struct export_operations gfs2_export_ops;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 8056b7b..462e841 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -91,19 +91,15 @@ static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
 {
-	unsigned int count;
-
-	mutex_lock(&sdp->sd_freeze_lock);
-	count = sdp->sd_freeze_count;
-	mutex_unlock(&sdp->sd_freeze_lock);
+	struct super_block *sb = sdp->sd_vfs;
+	int frozen = (sb->s_writers.frozen == SB_UNFROZEN) ? 0 : 1;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", count);
+	return snprintf(buf, PAGE_SIZE, "%u\n", frozen);
 }
 
 static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 {
-	ssize_t ret = len;
-	int error = 0;
+	int error;
 	int n = simple_strtol(buf, NULL, 0);
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -111,19 +107,21 @@ static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 
 	switch (n) {
 	case 0:
-		gfs2_unfreeze_fs(sdp);
+		error = thaw_super(sdp->sd_vfs);
 		break;
 	case 1:
-		error = gfs2_freeze_fs(sdp);
+		error = freeze_super(sdp->sd_vfs);
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
-	if (error)
+	if (error) {
 		fs_warn(sdp, "freeze %d error %d", n, error);
+		return error;
+	}
 
-	return ret;
+	return len;
 }
 
 static ssize_t withdraw_show(struct gfs2_sbd *sdp, char *buf)
-- 
1.7.4

