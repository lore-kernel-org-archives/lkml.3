Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3LMO2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:20 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52056 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3LMO2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:17 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 3/5] xfs: add xfs_create_tmpfile() for O_TMPFILE support
Date: Fri, 13 Dec 2013 22:27:51 +0800
Message-Id: <1386944873-16796-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121314-6688-0000-0000-0000047A1EFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

The function is used to create one O_TMPFILE file.
For more info, please refer to:
  http://oss.sgi.com/archives/xfs/2013-08/msg00339.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c      |  106 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h      |    2 +
 fs/xfs/xfs_shared.h     |    4 +-
 fs/xfs/xfs_trans_resv.c |   31 ++++++++++++++
 fs/xfs/xfs_trans_resv.h |    2 +
 5 files changed, 144 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71a8186..48e09c5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1342,6 +1342,112 @@ xfs_create(
 }
 
 int
+xfs_create_tmpfile(
+	struct xfs_inode	*dp,
+	struct xfs_mount	*mp,
+	umode_t			mode,
+	dev_t			rdev,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	uint			cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	*tres;
+	uint			resblks;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	/*
+	 * Make sure that we have allocated dquot(s) on disk.
+	 */
+	error = xfs_qm_vop_dqalloc(dp, mp, xfs_kuid_to_uid(current_fsuid()),
+					xfs_kgid_to_gid(current_fsgid()),
+					xfs_get_initial_prid(dp),
+					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+					&udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	resblks = XFS_IALLOC_SPACE_RES(mp);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
+
+	tres = &M_RES(mp)->tr_create_tmpfile;
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
+	if (error == ENOSPC) {
+		/* No space at all so try a "no-allocation" reservation */
+		resblks = 0;
+		error = xfs_trans_reserve(tp, tres, 0, 0);
+	}
+	if (error) {
+		cancel_flags = 0;
+		goto out_trans_cancel;
+	}
+
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_dir_ialloc(&tp, NULL, mode, 0, rdev,
+				XFS_PROJID_DEFAULT, resblks > 0,
+				&ip, NULL);
+	if (error) {
+		if (error == ENOSPC)
+			goto out_trans_cancel;
+		goto out_trans_abort;
+	}
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+
+	error = xfs_iunlink(tp, ip);
+	if (error)
+		goto out_trans_abort;
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		goto out_release_inode;
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	*ipp = ip;
+	return 0;
+
+ out_trans_abort:
+	cancel_flags |= XFS_TRANS_ABORT;
+ out_trans_cancel:
+	xfs_trans_cancel(tp, cancel_flags);
+ out_release_inode:
+	/*
+	 * Wait until after the current transaction is aborted to
+	 * release the inode.  This prevents recursive transactions
+	 * and deadlocks from xfs_inactive.
+	 */
+	if (ip)
+		IRELE(ip);
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	return error;
+}
+
+int
 xfs_link(
 	xfs_inode_t		*tdp,
 	xfs_inode_t		*sip,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9e6efccb..5699cc6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -323,6 +323,8 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
 			   umode_t mode, xfs_dev_t rdev, struct xfs_inode **ipp);
+int		xfs_create_tmpfile(struct xfs_inode *dp, struct xfs_mount *mp,
+			   umode_t mode, xfs_dev_t rdev, struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
 int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
index 8c5035a1..4484e51 100644
--- a/fs/xfs/xfs_shared.h
+++ b/fs/xfs/xfs_shared.h
@@ -104,7 +104,8 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
 #define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
+#define	XFS_TRANS_CREATE_TMPFILE	44
+#define	XFS_TRANS_TYPE_MAX		44
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -112,6 +113,7 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
 	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
 	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
 	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
 	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
 	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 2fd59c0..04519a9 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -344,6 +344,32 @@ xfs_calc_create_reservation(
 }
 
 /*
+ * For adding an inode to unlinked list we can modify:
+ *    the agi hash list: sector size
+ *    the unlinked inode: inode size
+ */
+STATIC uint
+xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_calc_inode_res(mp, 1);
+}
+
+STATIC uint
+xfs_calc_create_tmpfile_reservation(
+	struct xfs_mount        *mp)
+{
+	uint	res = XFS_DQUOT_LOGRES(mp);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		res += xfs_calc_icreate_resv_alloc(mp);
+	else
+		res += xfs_calc_create_resv_alloc(mp);
+
+	return res + xfs_calc_iunlink_add_reservation(mp);
+}
+
+/*
  * Making a new directory is the same as creating a new file.
  */
 STATIC uint
@@ -729,6 +755,11 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_create_tmpfile.tr_logres =
+			xfs_calc_create_tmpfile_reservation(mp);
+	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
+	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
 	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
 	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index de7de9a..285621d 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -38,6 +38,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_remove;	/* unlink trans */
 	struct xfs_trans_res	tr_symlink;	/* symlink trans */
 	struct xfs_trans_res	tr_create;	/* create trans */
+	struct xfs_trans_res	tr_create_tmpfile; /* create O_TMPFILE trans */
 	struct xfs_trans_res	tr_mkdir;	/* mkdir trans */
 	struct xfs_trans_res	tr_ifree;	/* inode free trans */
 	struct xfs_trans_res	tr_ichange;	/* inode update trans */
@@ -100,6 +101,7 @@ struct xfs_trans_resv {
 #define	XFS_ITRUNCATE_LOG_COUNT		2
 #define XFS_INACTIVE_LOG_COUNT		2
 #define	XFS_CREATE_LOG_COUNT		2
+#define	XFS_CREATE_TMPFILE_LOG_COUNT	2
 #define	XFS_MKDIR_LOG_COUNT		3
 #define	XFS_SYMLINK_LOG_COUNT		3
 #define	XFS_REMOVE_LOG_COUNT		2
-- 
1.7.6.5

