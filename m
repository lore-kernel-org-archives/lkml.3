Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3BRBMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:12:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54467 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3BRBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:57 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:01 -0800
Message-Id: <1361149870-27732-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+VD+nUtw52X04NHNurLReTpIm1VoPZgdU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1242]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 08/16] xfs: Use kprojids when allocating inodes.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

In xfs_create and xfs_symlink compute the desired kprojid and pass it
down into xfs_ialloc.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_inode.c    |    5 +++--
 fs/xfs/xfs_inode.h    |    2 +-
 fs/xfs/xfs_qm.c       |    4 +++-
 fs/xfs/xfs_utils.c    |    2 +-
 fs/xfs/xfs_utils.h    |    2 +-
 fs/xfs/xfs_vnodeops.c |    8 ++++----
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index af5420a..b7c9975 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1163,7 +1163,7 @@ xfs_ialloc(
 	umode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	prid_t		prid,
+	kprojid_t	prid,
 	int		okalloc,
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
@@ -1227,7 +1227,8 @@ xfs_ialloc(
 	/*
 	 * Project ids won't be stored on disk if we are using a version 1 inode.
 	 */
-	if ((prid != 0) && (ip->i_d.di_version == 1))
+	if (!projid_eq(prid, make_kprojid(&init_user_ns, 0)) &&
+	    (ip->i_d.di_version == 1))
 		xfs_bump_ino_vers2(tp, ip);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b82160f..9232c8e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -518,7 +518,7 @@ int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-			   xfs_nlink_t, xfs_dev_t, prid_t, int,
+			   xfs_nlink_t, xfs_dev_t, kprojid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f11e10d..6fce3d3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -777,7 +777,9 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
+	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
+			       make_kprojid(&init_user_ns, 0),
+			       1, ip, &committed);
 	if (error) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT);
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0025c78..f0a9f1d 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -54,7 +54,7 @@ xfs_dir_ialloc(
 	umode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	prid_t		prid,		/* project id */
+	kprojid_t	prid,		/* project id */
 	int		okalloc,	/* ok to allocate new space */
 	xfs_inode_t	**ipp,		/* pointer to inode; it will be
 					   locked. */
diff --git a/fs/xfs/xfs_utils.h b/fs/xfs/xfs_utils.h
index 5eeab46..7757f7c 100644
--- a/fs/xfs/xfs_utils.h
+++ b/fs/xfs/xfs_utils.h
@@ -19,7 +19,7 @@
 #define __XFS_UTILS_H__
 
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, umode_t, xfs_nlink_t,
-				xfs_dev_t, prid_t, int, xfs_inode_t **, int *);
+				xfs_dev_t, kprojid_t, int, xfs_inode_t **, int *);
 extern int xfs_droplink(xfs_trans_t *, xfs_inode_t *);
 extern int xfs_bumplink(xfs_trans_t *, xfs_inode_t *);
 extern void xfs_bump_ino_vers2(xfs_trans_t *, xfs_inode_t *);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index e7b27c8..496460b 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -728,7 +728,7 @@ xfs_create(
 	boolean_t		unlock_dp_on_error = B_FALSE;
 	uint			cancel_flags;
 	int			committed;
-	prid_t			prid;
+	kprojid_t		prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	uint			resblks;
@@ -743,7 +743,7 @@ xfs_create(
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_projid;
 	else
-		prid = XFS_PROJID_DEFAULT;
+		prid = make_kprojid(&init_user_ns, XFS_PROJID_DEFAULT);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
@@ -1379,7 +1379,7 @@ xfs_symlink(
 	int			byte_cnt;
 	int			n;
 	xfs_buf_t		*bp;
-	prid_t			prid;
+	kprojid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
 
@@ -1404,7 +1404,7 @@ xfs_symlink(
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_projid;
 	else
-		prid = XFS_PROJID_DEFAULT;
+		prid = make_kprojid(&init_user_ns, XFS_PROJID_DEFAULT);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
-- 
1.7.5.4

