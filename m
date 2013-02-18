Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3BRBMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:12:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55014 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3BRBMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:12:41 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:05 -0800
Message-Id: <1361149870-27732-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/BnSzF//L0+Ej6xSNQLnL8o7noqdA6xI0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2366]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 12/16] xfs: Remember the kqid for a quota
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Add q_id to struct xfs_quota
- Modify xfs_qm_dqread to take a struct kqid, allowing xfs_qm_dqread to
  set q_id on fresh quota structures.
- Modify xfs_qm_dqget and xfs_qm_init_quota_info to pass a kqid
  to xfs_qm_dqread

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.c |   12 ++++++------
 fs/xfs/xfs_dquot.h |    3 ++-
 fs/xfs/xfs_qm.c    |    9 +++++----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6be5a29..53c8f67 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -581,8 +581,7 @@ xfs_qm_dqtobp(
 int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
-	xfs_dqid_t		id,
-	uint			type,
+	struct kqid		id,
 	uint			flags,
 	struct xfs_dquot	**O_dqpp)
 {
@@ -596,8 +595,9 @@ xfs_qm_dqread(
 
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
-	dqp->dq_flags = type;
-	dqp->q_core.d_id = cpu_to_be32(id);
+	dqp->q_id = id;
+	dqp->dq_flags = xfs_quota_type(id.type);
+	dqp->q_core.d_id = cpu_to_be32(from_kqid(&init_user_ns, id));
 	dqp->q_mount = mp;
 	INIT_LIST_HEAD(&dqp->q_lru);
 	mutex_init(&dqp->q_qlock);
@@ -615,7 +615,7 @@ xfs_qm_dqread(
 	 * Make sure group quotas have a different lock class than user
 	 * quotas.
 	 */
-	if (!(type & XFS_DQ_USER))
+	if (id.type != USRQUOTA)
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
 
 	XFS_STATS_INC(xs_qm_dquot);
@@ -785,7 +785,7 @@ restart:
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqread(mp, qid, flags, &dqp);
 
 	if (ip)
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 3566548..0b6020e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -36,6 +36,7 @@ struct xfs_trans;
  * The incore dquot structure
  */
 typedef struct xfs_dquot {
+	struct kqid      q_id;		/* quota identifier */
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
@@ -138,7 +139,7 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
 				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
-extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
+extern int		xfs_qm_dqread(struct xfs_mount *, struct kqid,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 836d40d..7e19147 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -673,10 +673,11 @@ xfs_qm_init_quotainfo(
 	 * Since we may not have done a quotacheck by this point, just read
 	 * the dquot without attaching it to any hashtables or lists.
 	 */
-	error = xfs_qm_dqread(mp, 0,
-			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
-			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
-			  XFS_DQ_PROJ),
+	error = xfs_qm_dqread(mp,
+			make_kqid(&init_user_ns,
+				  XFS_IS_UQUOTA_RUNNING(mp) ? USRQUOTA :
+				  (XFS_IS_GQUOTA_RUNNING(mp) ? GRPQUOTA :
+				   PRJQUOTA), 0),
 			XFS_QMOPT_DOWARN, &dqp);
 	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
-- 
1.7.5.4

