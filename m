Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935659Ab3IEJ3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935586Ab3IEJ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/6] GFS2: Don't flag consistency error if first mounter is a spectator
Date: Thu,  5 Sep 2013 10:02:11 +0100
Message-Id: <1378371732-3947-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch checks for the first mounter being a specator. If so, it
makes sure all the journals are clean. If there's a dirty journal,
the mount fails.

Testing results:

# insmod gfs2.ko
# mount -tgfs2 -o spectator /dev/sasdrives/scratch /mnt/gfs2
mount: permission denied
# dmesg | tail -2
[ 3390.655996] GFS2: fsid=MUSKETEER:home: Now mounting FS...
[ 3390.841336] GFS2: fsid=MUSKETEER:home.s: jid=0: Journal is dirty, so the first mounter must not be a spectator.
# mount -tgfs2 /dev/sasdrives/scratch /mnt/gfs2
# umount /mnt/gfs2
# mount -tgfs2 -o spectator /dev/sasdrives/scratch /mnt/gfs2
# ls /mnt/gfs2|wc -l
352
# umount /mnt/gfs2

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 0262c19..19ff5e8 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -646,6 +646,48 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 	return error;
 }
 
+/**
+ * check_journal_clean - Make sure a journal is clean for a spectator mount
+ * @sdp: The GFS2 superblock
+ * @jd: The journal descriptor
+ *
+ * Returns: 0 if the journal is clean or locked, else an error
+ */
+static int check_journal_clean(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd)
+{
+	int error;
+	struct gfs2_holder j_gh;
+	struct gfs2_log_header_host head;
+	struct gfs2_inode *ip;
+
+	ip = GFS2_I(jd->jd_inode);
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_NOEXP |
+				   GL_EXACT | GL_NOCACHE, &j_gh);
+	if (error) {
+		fs_err(sdp, "Error locking journal for spectator mount.\n");
+		return -EPERM;
+	}
+	error = gfs2_jdesc_check(jd);
+	if (error) {
+		fs_err(sdp, "Error checking journal for spectator mount.\n");
+		goto out_unlock;
+	}
+	error = gfs2_find_jhead(jd, &head);
+	if (error) {
+		fs_err(sdp, "Error parsing journal for spectator mount.\n");
+		goto out_unlock;
+	}
+	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
+		error = -EPERM;
+		fs_err(sdp, "jid=%u: Journal is dirty, so the first mounter "
+		       "must not be a spectator.\n", jd->jd_jid);
+	}
+
+out_unlock:
+	gfs2_glock_dq_uninit(&j_gh);
+	return error;
+}
+
 static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct inode *master = sdp->sd_master_dir->d_inode;
@@ -732,8 +774,15 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
 		for (x = 0; x < sdp->sd_journals; x++) {
-			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x),
-						     true);
+			struct gfs2_jdesc *jd = gfs2_jdesc_find(sdp, x);
+
+			if (sdp->sd_args.ar_spectator) {
+				error = check_journal_clean(sdp, jd);
+				if (error)
+					goto fail_jinode_gh;
+				continue;
+			}
+			error = gfs2_recover_journal(jd, true);
 			if (error) {
 				fs_err(sdp, "error recovering journal %u: %d\n",
 				       x, error);
-- 
1.7.4

