Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3BRBN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:13:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55046 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3BRBMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:12:42 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:06 -0800
Message-Id: <1361149870-27732-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18FOUlsXxWwxpoPnIfN7lF92NSuciGsOyQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4592]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 13/16] xfs: Use q_id instead of q_core.d_id.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Use qid_lt on q_id when compariting two quota entries for order.
- Use qid_eq or !qid_eq when comparing a quota entry for equality or inequality.
- Use is_superquota when testing for the magic quota id of 0.
- Use make_kqid_uid, make_kqid_gid, and make_kqid_projid when comparing
  a quota id against a uids, gids, or projids as appropriate.
- For tracing use from_kqid and map to the init user namespace.
  Tracers outside of the initial user namespace are not allowed.

- For generating ondisk values continue to use q_core.d_id.
- For cases where we want an index and don't care which quota
  it is continue to use be32_to_cpu(...->q_core.d_id)

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.c       |    3 +--
 fs/xfs/xfs_qm.c          |   18 +++++++++---------
 fs/xfs/xfs_trace.h       |    2 +-
 fs/xfs/xfs_trans_dquot.c |    8 ++------
 4 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 53c8f67..6f6e6ea 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1092,8 +1092,7 @@ xfs_dqlock2(
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
-		if (be32_to_cpu(d1->q_core.d_id) >
-		    be32_to_cpu(d2->q_core.d_id)) {
+		if (qid_lt(d2->q_id, d1->q_id)) {
 			mutex_lock(&d2->q_qlock);
 			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_NESTED);
 		} else {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7e19147..60444b0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -407,7 +407,7 @@ xfs_qm_dqattach_one(
 		 * hold the ilock.
 		 */
 		dqp = udqhint->q_gdquot;
-		if (dqp && qid_eq(make_kqid(&init_user_ns, id.type, be32_to_cpu(dqp->q_core.d_id)), id)) {
+		if (dqp && qid_eq(dqp->q_id, id)) {
 			ASSERT(*IO_idqpp == NULL);
 
 			*IO_idqpp = xfs_qm_dqhold(dqp);
@@ -1057,7 +1057,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_core.d_id) {
+	if (!is_superquota(dqp->q_id, &init_user_ns)) {
 		xfs_qm_adjust_dqlimits(mp, &dqp->q_core);
 		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
 	}
@@ -1805,7 +1805,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    !uid_eq(VFS_I(ip)->i_uid, (uid_t)be32_to_cpu(udqp->q_core.d_id))) {
+	    !qid_eq(make_kqid_uid(VFS_I(ip)->i_uid), udqp->q_id)) {
 		delblksudq = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1819,12 +1819,12 @@ xfs_qm_vop_chown_reserve(
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
 		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		    !projid_eq(ip->i_projid, be32_to_cpu(gdqp->q_core.d_id)))
+		    !qid_eq(make_kqid_projid(ip->i_projid), gdqp->q_id))
 			prjflags = XFS_QMOPT_ENOSPC;
 
 		if (prjflags ||
 		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
-		     !gid_eq(VFS_I(ip)->i_gid, be32_to_cpu(gdqp->q_core.d_id)))) {
+		     !qid_eq(make_kqid_gid(VFS_I(ip)->i_gid), gdqp->q_id))) {
 			delblksgdq = gdqp;
 			if (delblks) {
 				ASSERT(ip->i_gdquot);
@@ -1908,7 +1908,7 @@ xfs_qm_vop_create_dqattach(
 	if (udqp) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(XFS_IS_UQUOTA_ON(mp));
-		ASSERT(uid_eq(VFS_I(ip)->i_uid, be32_to_cpu(udqp->q_core.d_id)));
+		ASSERT(qid_eq(make_kqid_uid(VFS_I(ip)->i_uid), udqp->q_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
@@ -1916,9 +1916,9 @@ xfs_qm_vop_create_dqattach(
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT(XFS_IS_GQUOTA_ON(mp) ?
-		       gid_eq(VFS_I(ip)->i_gid, be32_to_cpu(gdqp->q_core.d_id)):
-		       projid_eq(ip->i_projid, be32_to_cpu(gdqp->q_core.d_id)));
+		ASSERT(qid_eq(XFS_IS_GQUOTA_ON(mp) ?
+			      make_kqid_gid(VFS_I(ip)->i_gid) :
+			      make_kqid_projid(ip->i_projid), gdqp->q_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2e137d4..3cda9b4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -712,7 +712,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 	), \
 	TP_fast_assign(
 		__entry->dev = dqp->q_mount->m_super->s_dev;
-		__entry->id = be32_to_cpu(dqp->q_core.d_id);
+		__entry->id = from_kqid(&init_user_ns, dqp->q_id);
 		__entry->flags = dqp->dq_flags;
 		__entry->nrefs = dqp->q_nrefs;
 		__entry->res_bcount = dqp->q_res_bcount;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0c7fa54..5e5fdfe 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -578,11 +578,7 @@ xfs_quota_warn(
 	/* no warnings for project quotas - we just return ENOSPC later */
 	if (dqp->dq_flags & XFS_DQ_PROJ)
 		return;
-	quota_send_warning(make_kqid(&init_user_ns,
-				     (dqp->dq_flags & XFS_DQ_USER) ?
-				     USRQUOTA : GRPQUOTA,
-				     be32_to_cpu(dqp->q_core.d_id)),
-			   mp->m_super->s_dev, type);
+	quota_send_warning(dqp->q_id, mp->m_super->s_dev, type);
 }
 
 /*
@@ -638,7 +634,7 @@ xfs_trans_dqresv(
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
-	    dqp->q_core.d_id &&
+	    !is_superquota(dqp->q_id, &init_user_ns) &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
 	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
-- 
1.7.5.4

