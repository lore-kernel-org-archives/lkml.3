Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3BRBML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:12:11 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51226 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3BRBMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:12:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:03 -0800
Message-Id: <1361149870-27732-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18c41e80rqJav7QDzaIBwBpH0Itmkard9s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 10/16] xfs: Push struct kqid into xfs_qm_scall_qmlim and xfs_qm_scall_getquota
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- In xfs_qm_scall_getquota map the quota id into the callers
  user namespace in the returned struct fs_disk_quota

- Add a helper is_superquota and use it in xfs_qm_scall_setqlimi
  to see if we are setting the superusers quota limit.  Setting
  the superuses quota limit on xfs sets the default quota limits
  for all users.

- Move xfs_quota_type into xfs_qm_syscalls.c where it is now used.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.h       |    6 ++++++
 fs/xfs/xfs_qm.h          |    4 ++--
 fs/xfs/xfs_qm_syscalls.c |   40 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_quotaops.c    |   20 ++------------------
 4 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c694a84..2c197da 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -163,4 +163,10 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 
 extern const struct xfs_buf_ops xfs_dquot_buf_ops;
 
+/* Is this root's quota in the specified user namespace? */
+static inline bool is_superquota(struct kqid id, struct user_namespace *ns)
+{
+	return qid_eq(id, make_kqid(ns, id.type, 0));
+}
+
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 44b858b..ce478dc 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -114,9 +114,9 @@ extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
 
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(xfs_mount_t *, uint);
-extern int		xfs_qm_scall_getquota(xfs_mount_t *, xfs_dqid_t, uint,
+extern int		xfs_qm_scall_getquota(xfs_mount_t *, struct kqid,
 					fs_disk_quota_t *);
-extern int		xfs_qm_scall_setqlim(xfs_mount_t *, xfs_dqid_t, uint,
+extern int		xfs_qm_scall_setqlim(xfs_mount_t *, struct kqid,
 					fs_disk_quota_t *);
 extern int		xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
 extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5f53e75..5666b1c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -48,6 +48,19 @@ STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
 STATIC uint	xfs_qm_export_flags(uint);
 STATIC uint	xfs_qm_export_qtype_flags(uint);
 
+STATIC int
+xfs_quota_type(int type)
+{
+	switch (type) {
+	case USRQUOTA:
+		return XFS_DQ_USER;
+	case GRPQUOTA:
+		return XFS_DQ_GROUP;
+	default:
+		return XFS_DQ_PROJ;
+	}
+}
+
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
  * gdquots. Called only at unmount time.
@@ -473,8 +486,7 @@ xfs_qm_scall_getqstat(
 int
 xfs_qm_scall_setqlim(
 	xfs_mount_t		*mp,
-	xfs_dqid_t		id,
-	uint			type,
+	struct kqid		id,
 	fs_disk_quota_t		*newlim)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
@@ -483,12 +495,16 @@ xfs_qm_scall_setqlim(
 	xfs_trans_t		*tp;
 	int			error;
 	xfs_qcnt_t		hard, soft;
+	bool			superquota;
 
 	if (newlim->d_fieldmask & ~XFS_DQ_MASK)
 		return EINVAL;
 	if ((newlim->d_fieldmask & XFS_DQ_MASK) == 0)
 		return 0;
 
+	/* Is this quota id for root? */
+	superquota = is_superquota(id, &init_user_ns);
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
 	if ((error = xfs_trans_reserve(tp, 0, sizeof(xfs_disk_dquot_t) + 128,
 				      0, 0, XFS_DEFAULT_LOG_COUNT))) {
@@ -508,7 +524,9 @@ xfs_qm_scall_setqlim(
 	 * Get the dquot (locked), and join it to the transaction.
 	 * Allocate the dquot if this doesn't exist.
 	 */
-	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
+	if ((error = xfs_qm_dqget(mp, NULL, from_kqid(&init_user_ns, id),
+				  xfs_quota_type(id.type),
+				  XFS_QMOPT_DQALLOC, &dqp))) {
 		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 		ASSERT(error != ENOENT);
 		goto out_unlock;
@@ -528,7 +546,7 @@ xfs_qm_scall_setqlim(
 	if (hard == 0 || hard >= soft) {
 		ddq->d_blk_hardlimit = cpu_to_be64(hard);
 		ddq->d_blk_softlimit = cpu_to_be64(soft);
-		if (id == 0) {
+		if (superquota) {
 			q->qi_bhardlimit = hard;
 			q->qi_bsoftlimit = soft;
 		}
@@ -544,7 +562,7 @@ xfs_qm_scall_setqlim(
 	if (hard == 0 || hard >= soft) {
 		ddq->d_rtb_hardlimit = cpu_to_be64(hard);
 		ddq->d_rtb_softlimit = cpu_to_be64(soft);
-		if (id == 0) {
+		if (superquota) {
 			q->qi_rtbhardlimit = hard;
 			q->qi_rtbsoftlimit = soft;
 		}
@@ -561,7 +579,7 @@ xfs_qm_scall_setqlim(
 	if (hard == 0 || hard >= soft) {
 		ddq->d_ino_hardlimit = cpu_to_be64(hard);
 		ddq->d_ino_softlimit = cpu_to_be64(soft);
-		if (id == 0) {
+		if (superquota) {
 			q->qi_ihardlimit = hard;
 			q->qi_isoftlimit = soft;
 		}
@@ -579,7 +597,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & FS_DQ_RTBWARNS)
 		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rtbwarns);
 
-	if (id == 0) {
+	if (superquota) {
 		/*
 		 * Timelimits for the super user set the relative time
 		 * the other users can be over quota for this file system.
@@ -717,8 +735,7 @@ error0:
 int
 xfs_qm_scall_getquota(
 	struct xfs_mount	*mp,
-	xfs_dqid_t		id,
-	uint			type,
+	struct kqid		id,
 	struct fs_disk_quota	*dst)
 {
 	struct xfs_dquot	*dqp;
@@ -729,7 +746,8 @@ xfs_qm_scall_getquota(
 	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
 	 * exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+	error = xfs_qm_dqget(mp, NULL, from_kqid(&init_user_ns, id),
+			     xfs_quota_type(id.type), 0, &dqp);
 	if (error)
 		return error;
 
@@ -745,7 +763,7 @@ xfs_qm_scall_getquota(
 	memset(dst, 0, sizeof(*dst));
 	dst->d_version = FS_DQUOT_VERSION;
 	dst->d_flags = xfs_qm_export_qtype_flags(dqp->q_core.d_flags);
-	dst->d_id = be32_to_cpu(dqp->q_core.d_id);
+	dst->d_id = from_kqid_munged(current_user_ns(), id);
 	dst->d_blk_hardlimit =
 		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
 	dst->d_blk_softlimit =
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 71926d6..4d88faa 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -27,20 +27,6 @@
 #include "xfs_qm.h"
 #include <linux/quota.h>
 
-
-STATIC int
-xfs_quota_type(int type)
-{
-	switch (type) {
-	case USRQUOTA:
-		return XFS_DQ_USER;
-	case GRPQUOTA:
-		return XFS_DQ_GROUP;
-	default:
-		return XFS_DQ_PROJ;
-	}
-}
-
 STATIC int
 xfs_fs_get_xstate(
 	struct super_block	*sb,
@@ -107,8 +93,7 @@ xfs_fs_get_dqblk(
 	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
 
-	return -xfs_qm_scall_getquota(mp, from_kqid(&init_user_ns, qid),
-				      xfs_quota_type(qid.type), fdq);
+	return -xfs_qm_scall_getquota(mp, qid, fdq);
 }
 
 STATIC int
@@ -126,8 +111,7 @@ xfs_fs_set_dqblk(
 	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
 
-	return -xfs_qm_scall_setqlim(mp, from_kqid(&init_user_ns, qid),
-				     xfs_quota_type(qid.type), fdq);
+	return -xfs_qm_scall_setqlim(mp, qid, fdq);
 }
 
 const struct quotactl_ops xfs_quotactl_operations = {
-- 
1.7.5.4

