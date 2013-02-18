Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3BRBPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:15:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40218 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab3BRBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:44 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:10:58 -0800
Message-Id: <1361149870-27732-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19RDBKeET+9tnF/U8alX1L7VVi9GCoqjNI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4425]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle projids in any user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Convert the userspace value in fa->fsx_projid into a kprojid and
  store it in the variable projid.
- Verify that xfs can store the projid after it is converted into
  xfs's user namespace.
- Replace uses of fa->fsx_projid with projid throughout
  xfs_ioctl_setattr.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 016624b..4a55f50 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -925,6 +925,7 @@ xfs_ioctl_setattr(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
+	kprojid_t		projid = INVALID_PROJID;
 
 	trace_xfs_ioctl_setattr(ip);
 
@@ -934,11 +935,20 @@ xfs_ioctl_setattr(
 		return XFS_ERROR(EIO);
 
 	/*
-	 * Disallow 32bit project ids when projid32bit feature is not enabled.
+	 * Verify the specifid project id is valid.
 	 */
-	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
-			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return XFS_ERROR(EINVAL);
+	if (mask & FSX_PROJID) {
+		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
+		if (!projid_valid(projid))
+			return XFS_ERROR(EINVAL);
+
+		/*
+		 * Disallow 32bit project ids when projid32bit feature is not enabled.
+		 */
+		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
+		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+			return XFS_ERROR(EINVAL);
+	}
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -950,7 +960,7 @@ xfs_ioctl_setattr(
 	 */
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
 		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
-					 VFS_I(ip)->i_gid, fa->fsx_projid,
+					 VFS_I(ip)->i_gid, projid,
 					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
 		if (code)
 			return code;
@@ -986,7 +996,7 @@ xfs_ioctl_setattr(
 	if (mask & FSX_PROJID) {
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    !projid_eq(ip->i_projid, fa->fsx_projid)) {
+		    !projid_eq(ip->i_projid, projid)) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -1104,12 +1114,12 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (!projid_eq(ip->i_projid, fa->fsx_projid)) {
+		if (!projid_eq(ip->i_projid, projid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			xfs_set_projid(ip, fa->fsx_projid);
+			xfs_set_projid(ip, projid);
 
 			/*
 			 * We may have to rev the inode as well as
-- 
1.7.5.4

