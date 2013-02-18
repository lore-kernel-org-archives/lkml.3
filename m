Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab3BRBLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:11:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40186 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab3BRBLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:10:57 -0800
Message-Id: <1361149870-27732-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19NxPVZ/PYB8sChFASX5PtaetiUEMzm5gk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4658]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 04/16] xfs: Update inode uids, gids, and projids to be kuids, kgids, and kprojids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Update i_projid on struct xfs_inode to be of type  kprojid_t.

Update the logic in xfs_iread when the values are read from
disk to convert their on-disk values into the internal kernel
representation.

Update xfs_set_projid, xfs_set_uid, and xfs_set_gid to convert
from the internal kernel representation to the on-disk values
when updating the on-disk fields.

Update comparisons against these fields to use uid_eq, gid_eq
and projid_eq.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c   |    6 +++---
 fs/xfs/xfs_inode.c    |   14 ++++++++------
 fs/xfs/xfs_inode.h    |   15 ++++++++-------
 fs/xfs/xfs_ioctl.c    |    8 ++++----
 fs/xfs/xfs_itable.c   |   10 ++++++----
 fs/xfs/xfs_qm.c       |   20 ++++++++++----------
 fs/xfs/xfs_rename.c   |    2 +-
 fs/xfs/xfs_vnodeops.c |    2 +-
 8 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eba1dbd..0583649 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1202,15 +1202,15 @@ xfs_inode_match_id(
 	struct xfs_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
-	    VFS_I(ip)->i_uid != eofb->eof_uid)
+	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
-	    VFS_I(ip)->i_gid != eofb->eof_gid)
+	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
-	    ip->i_projid != eofb->eof_prid)
+	    !projid_eq(ip->i_projid, eofb->eof_prid))
 		return 0;
 
 	return 1;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 846166d..af5420a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1014,10 +1014,11 @@ xfs_iread(
 	if (dip->di_mode) {
 		xfs_dinode_from_disk(&ip->i_d, dip);
 
-		ip->i_projid = ((projid_t)ip->i_d.di_projid_hi << 16) |
-					  ip->i_d.di_projid_lo;
-		VFS_I(ip)->i_uid = ip->i_d.di_uid;
-		VFS_I(ip)->i_gid = ip->i_d.di_gid;
+		ip->i_projid = make_kprojid(&init_user_ns,
+					    ((projid_t)ip->i_d.di_projid_hi << 16) |
+					    ip->i_d.di_projid_lo);
+		VFS_I(ip)->i_uid = make_kuid(&init_user_ns, ip->i_d.di_uid);
+		VFS_I(ip)->i_gid = make_kgid(&init_user_ns, ip->i_d.di_gid);
 
 		error = xfs_iformat(ip, dip);
 		if (error)  {
@@ -1056,7 +1057,7 @@ xfs_iread(
 	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
-		xfs_set_projid(ip, 0);
+		xfs_set_projid(ip, make_kprojid(&init_user_ns, 0));
 	}
 
 	ip->i_delayed_blks = 0;
@@ -2845,7 +2846,8 @@ xfs_iflush_int(
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 			memset(&(dip->di_pad[0]), 0,
 			      sizeof(dip->di_pad));
-			ASSERT(ip->i_projid == 0);
+			ASSERT(projid_eq(ip->i_projid,
+					 make_kprojid(&init_user_ns, 0)));
 		}
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f503aed..b82160f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -244,7 +244,7 @@ typedef struct xfs_inode {
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
-	projid_t		i_projid;	/* Project id */
+	kprojid_t		i_projid;	/* project id */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
@@ -363,23 +363,24 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 
 static inline void
 xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
+		kprojid_t kprojid)
 {
-	ip->i_projid = projid;
+	projid_t projid = from_kprojid(&init_user_ns, kprojid);
+	ip->i_projid = kprojid;
 	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
 	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
 }
 
-static inline void xfs_set_uid(struct xfs_inode *ip, uid_t uid)
+static inline void xfs_set_uid(struct xfs_inode *ip, kuid_t uid)
 {
 	VFS_I(ip)->i_uid = uid;
-	ip->i_d.di_uid = uid;
+	ip->i_d.di_uid = from_kuid(&init_user_ns, uid);
 }
 
-static inline void xfs_set_gid(struct xfs_inode *ip, gid_t gid)
+static inline void xfs_set_gid(struct xfs_inode *ip, kgid_t gid)
 {
 	VFS_I(ip)->i_gid = gid;
-	ip->i_d.di_gid = gid;
+	ip->i_d.di_gid = from_kgid(&init_user_ns, gid);
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index db274d4..016624b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -815,7 +815,7 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = ip->i_projid;
+	fa.fsx_projid = from_kprojid_munged(current_user_ns(), ip->i_projid);
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -975,7 +975,7 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current_fsuid() != VFS_I(ip)->i_uid && !capable(CAP_FOWNER)) {
+	if (!uid_eq(current_fsuid(), VFS_I(ip)->i_uid) && !capable(CAP_FOWNER)) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
@@ -986,7 +986,7 @@ xfs_ioctl_setattr(
 	if (mask & FSX_PROJID) {
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    ip->i_projid != fa->fsx_projid) {
+		    !projid_eq(ip->i_projid, fa->fsx_projid)) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -1104,7 +1104,7 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (ip->i_projid != fa->fsx_projid) {
+		if (!projid_eq(ip->i_projid, fa->fsx_projid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a9e07dd..f639773 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -64,6 +64,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct xfs_bstat	*buf;		/* return buffer */
 	int			error = 0;	/* error value */
+	projid_t		projid;
 
 	*stat = BULKSTAT_RV_NOTHING;
 
@@ -91,12 +92,13 @@ xfs_bulkstat_one_int(
 	 * further change.
 	 */
 	buf->bs_nlink = dic->di_nlink;
-	buf->bs_projid_lo = (u16)(ip->i_projid & 0xffff);
-	buf->bs_projid_hi = (u16)(ip->i_projid >> 16);
+	projid = from_kprojid_munged(current_user_ns(), ip->i_projid);
+	buf->bs_projid_lo = (u16)(projid & 0xffff);
+	buf->bs_projid_hi = (u16)(projid >> 16);
 	buf->bs_ino = ino;
 	buf->bs_mode = dic->di_mode;
-	buf->bs_uid = VFS_I(ip)->i_uid;
-	buf->bs_gid = VFS_I(ip)->i_gid;
+	buf->bs_uid = from_kuid_munged(current_user_ns(), VFS_I(ip)->i_uid);
+	buf->bs_gid = from_kgid_munged(current_user_ns(), VFS_I(ip)->i_gid);
 	buf->bs_size = dic->di_size;
 	buf->bs_atime.tv_sec = dic->di_atime.t_sec;
 	buf->bs_atime.tv_nsec = dic->di_atime.t_nsec;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c1310ed..f11e10d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1650,7 +1650,7 @@ xfs_qm_vop_dqalloc(
 
 	uq = gq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (VFS_I(ip)->i_uid != uid) {
+		if (!uid_eq(VFS_I(ip)->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1685,7 +1685,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (VFS_I(ip)->i_gid != gid) {
+		if (!gid_eq(VFS_I(ip)->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
 						 XFS_DQ_GROUP,
@@ -1705,7 +1705,7 @@ xfs_qm_vop_dqalloc(
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (ip->i_projid != prid) {
+		if (!projid_eq(ip->i_projid, prid)) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
@@ -1806,7 +1806,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    VFS_I(ip)->i_uid != (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
+	    !uid_eq(VFS_I(ip)->i_uid, (uid_t)be32_to_cpu(udqp->q_core.d_id))) {
 		delblksudq = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1820,12 +1820,12 @@ xfs_qm_vop_chown_reserve(
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
 		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		     ip->i_projid != be32_to_cpu(gdqp->q_core.d_id))
+		    !projid_eq(ip->i_projid, be32_to_cpu(gdqp->q_core.d_id)))
 			prjflags = XFS_QMOPT_ENOSPC;
 
 		if (prjflags ||
 		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
-		     VFS_I(ip)->i_gid != be32_to_cpu(gdqp->q_core.d_id))) {
+		     !gid_eq(VFS_I(ip)->i_gid, be32_to_cpu(gdqp->q_core.d_id)))) {
 			delblksgdq = gdqp;
 			if (delblks) {
 				ASSERT(ip->i_gdquot);
@@ -1909,7 +1909,7 @@ xfs_qm_vop_create_dqattach(
 	if (udqp) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(XFS_IS_UQUOTA_ON(mp));
-		ASSERT(VFS_I(ip)->i_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(uid_eq(VFS_I(ip)->i_uid, be32_to_cpu(udqp->q_core.d_id)));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
@@ -1917,9 +1917,9 @@ xfs_qm_vop_create_dqattach(
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			VFS_I(ip)->i_gid : ip->i_projid) ==
-				be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(XFS_IS_GQUOTA_ON(mp) ?
+		       gid_eq(VFS_I(ip)->i_gid, be32_to_cpu(gdqp->q_core.d_id)):
+		       projid_eq(ip->i_projid, be32_to_cpu(gdqp->q_core.d_id)));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 89981bb..9cc22b2 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -171,7 +171,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (target_dp->i_projid != src_ip->i_projid))) {
+		     !projid_eq(target_dp->i_projid, src_ip->i_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 7a2c2a0..e7b27c8 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1305,7 +1305,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (tdp->i_projid != sip->i_projid))) {
+		     !projid_eq(tdp->i_projid, sip->i_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
-- 
1.7.5.4

