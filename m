Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085Ab3BMR7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:59:01 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56925 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075Ab3BMR6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:07 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:23 -0800
Message-Id: <1360777934-5663-34-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19k64bl6e/G/N9vfmKSWADcSyZtTZI6RG0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4710]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 34/85] gfs2: Store qd_id in struct gfs2_quota_data as a struct kqid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Change qd_id in struct gfs2_qutoa_data to struct kqid.
- Remove the now unnecessary QDF_USER bit field in qd_flags.
- Propopoage this change through the code generally making
  things simpler along the way.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/incore.h |    3 +-
 fs/gfs2/quota.c  |   69 +++++++++++++++++++----------------------------------
 2 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c373a24..5b298bd 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -391,7 +391,6 @@ struct gfs2_revoke_replay {
 };
 
 enum {
-	QDF_USER		= 0,
 	QDF_CHANGE		= 1,
 	QDF_LOCKED		= 2,
 	QDF_REFRESH		= 3,
@@ -403,7 +402,7 @@ struct gfs2_quota_data {
 
 	atomic_t qd_count;
 
-	u32 qd_id;
+	struct kqid qd_id;
 	unsigned long qd_flags;		/* QDF_... */
 
 	s64 qd_change;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 47315c0..8cb4d10 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -122,8 +122,9 @@ out:
 
 static u64 qd2index(struct gfs2_quota_data *qd)
 {
-	return (2 * (u64)qd->qd_id) +
-		test_bit(QDF_USER, &qd->qd_flags) ? 0 : 1;
+	struct kqid qid = qd->qd_id;
+	return (2 * (u64)from_kqid(&init_user_ns, qid)) +
+		(qid.type == USRQUOTA) ? 0 : 1;
 }
 
 static u64 qd2offset(struct gfs2_quota_data *qd)
@@ -136,7 +137,7 @@ static u64 qd2offset(struct gfs2_quota_data *qd)
 	return offset;
 }
 
-static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
+static int qd_alloc(struct gfs2_sbd *sdp, struct kqid qid,
 		    struct gfs2_quota_data **qdp)
 {
 	struct gfs2_quota_data *qd;
@@ -147,9 +148,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 		return -ENOMEM;
 
 	atomic_set(&qd->qd_count, 1);
-	qd->qd_id = id;
-	if (user)
-		set_bit(QDF_USER, &qd->qd_flags);
+	qd->qd_id = qid;
 	qd->qd_slot = -1;
 	INIT_LIST_HEAD(&qd->qd_reclaim);
 
@@ -167,7 +166,7 @@ fail:
 	return error;
 }
 
-static int qd_get(struct gfs2_sbd *sdp, int user, u32 id,
+static int qd_get(struct gfs2_sbd *sdp, struct kqid qid,
 		  struct gfs2_quota_data **qdp)
 {
 	struct gfs2_quota_data *qd = NULL, *new_qd = NULL;
@@ -179,8 +178,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id,
 		found = 0;
 		spin_lock(&qd_lru_lock);
 		list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
-			if (qd->qd_id == id &&
-			    !test_bit(QDF_USER, &qd->qd_flags) == !user) {
+			if (qid_eq(qd->qd_id, qid)) {
 				if (!atomic_read(&qd->qd_count) &&
 				    !list_empty(&qd->qd_reclaim)) {
 					/* Remove it from reclaim list */
@@ -214,7 +212,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id,
 			return 0;
 		}
 
-		error = qd_alloc(sdp, user, id, &new_qd);
+		error = qd_alloc(sdp, qid, &new_qd);
 		if (error)
 			return error;
 	}
@@ -469,8 +467,7 @@ static int qdsb_get(struct gfs2_sbd *sdp, struct kqid qid,
 {
 	int error;
 
-	error = qd_get(sdp, qid.type == USRQUOTA ? QUOTA_USER : QUOTA_GROUP,
-		       from_kqid(&init_user_ns, qid), qdp);
+	error = qd_get(sdp, qid, qdp);
 	if (error)
 		return error;
 
@@ -574,18 +571,10 @@ static int sort_qd(const void *a, const void *b)
 	const struct gfs2_quota_data *qd_a = *(const struct gfs2_quota_data **)a;
 	const struct gfs2_quota_data *qd_b = *(const struct gfs2_quota_data **)b;
 
-	if (!test_bit(QDF_USER, &qd_a->qd_flags) !=
-	    !test_bit(QDF_USER, &qd_b->qd_flags)) {
-		if (test_bit(QDF_USER, &qd_a->qd_flags))
-			return -1;
-		else
-			return 1;
-	}
-	if (qd_a->qd_id < qd_b->qd_id)
+	if (qid_lt(qd_a->qd_id, qd_b->qd_id))
 		return -1;
-	if (qd_a->qd_id > qd_b->qd_id)
+	if (qid_lt(qd_b->qd_id, qd_a->qd_id))
 		return 1;
-
 	return 0;
 }
 
@@ -602,9 +591,9 @@ static void do_qc(struct gfs2_quota_data *qd, s64 change)
 	if (!test_bit(QDF_CHANGE, &qd->qd_flags)) {
 		qc->qc_change = 0;
 		qc->qc_flags = 0;
-		if (test_bit(QDF_USER, &qd->qd_flags))
+		if (qd->qd_id.type == USRQUOTA)
 			qc->qc_flags = cpu_to_be32(GFS2_QCF_USER);
-		qc->qc_id = cpu_to_be32(qd->qd_id);
+		qc->qc_id = cpu_to_be32(from_kqid(&init_user_ns, qd->qd_id));
 	}
 
 	x = be64_to_cpu(qc->qc_change) + change;
@@ -1047,8 +1036,8 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 
 	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\n",
 	       sdp->sd_fsname, type,
-	       (test_bit(QDF_USER, &qd->qd_flags)) ? "user" : "group",
-	       qd->qd_id);
+	       (qd->qd_id.type == USRQUOTA) ? "user" : "group",
+	       from_kqid(&init_user_ns, qd->qd_id));
 
 	return 0;
 }
@@ -1070,8 +1059,8 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 	for (x = 0; x < ip->i_res->rs_qa_qd_num; x++) {
 		qd = ip->i_res->rs_qa_qd[x];
 
-		if (!((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
-		      (qd->qd_id == gid && !test_bit(QDF_USER, &qd->qd_flags))))
+		if (!(qid_eq(qd->qd_id, make_kqid_uid(uid)) ||
+		      qid_eq(qd->qd_id, make_kqid_gid(gid))))
 			continue;
 
 		value = (s64)be64_to_cpu(qd->qd_qb.qb_value);
@@ -1081,10 +1070,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
-			quota_send_warning(make_kqid(&init_user_ns,
-						     test_bit(QDF_USER, &qd->qd_flags) ?
-						     USRQUOTA : GRPQUOTA,
-						     qd->qd_id),
+			quota_send_warning(qd->qd_id,
 					   sdp->sd_vfs->s_dev, QUOTA_NL_BHARDWARN);
 
 			error = -EDQUOT;
@@ -1094,10 +1080,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 			   time_after_eq(jiffies, qd->qd_last_warn +
 					 gfs2_tune_get(sdp,
 						gt_quota_warn_period) * HZ)) {
-			quota_send_warning(make_kqid(&init_user_ns,
-						     test_bit(QDF_USER, &qd->qd_flags) ?
-						     USRQUOTA : GRPQUOTA,
-						     qd->qd_id),
+			quota_send_warning(qd->qd_id,
 					   sdp->sd_vfs->s_dev, QUOTA_NL_BSOFTWARN);
 			error = print_message(qd, "warning");
 			qd->qd_last_warn = jiffies;
@@ -1121,8 +1104,8 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 	for (x = 0; x < ip->i_res->rs_qa_qd_num; x++) {
 		qd = ip->i_res->rs_qa_qd[x];
 
-		if ((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
-		    (qd->qd_id == gid && !test_bit(QDF_USER, &qd->qd_flags))) {
+		if (qid_eq(qd->qd_id, make_kqid_uid(uid)) ||
+		    qid_eq(qd->qd_id, make_kqid_gid(gid))) {
 			do_qc(qd, change);
 		}
 	}
@@ -1183,8 +1166,7 @@ int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid)
 	struct gfs2_holder q_gh;
 	int error;
 
-	error = qd_get(sdp, qid.type == USRQUOTA ? QUOTA_USER : QUOTA_GROUP,
-		       from_kqid(&init_user_ns, qid), &qd);
+	error = qd_get(sdp, qid, &qd);
 	if (error)
 		return error;
 
@@ -1267,8 +1249,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			if (!qc.qc_change)
 				continue;
 
-			error = qd_alloc(sdp, (qc.qc_flags & GFS2_QCF_USER),
-					 from_kqid(&init_user_ns, qc.qc_id), &qd);
+			error = qd_alloc(sdp, qc.qc_id, &qd);
 			if (error) {
 				brelse(bh);
 				goto fail;
@@ -1509,7 +1490,7 @@ static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 	else
 		return -EINVAL;
 
-	error = qd_get(sdp, type, from_kqid(&init_user_ns, qid), &qd);
+	error = qd_get(sdp, qid, &qd);
 	if (error)
 		return error;
 	error = do_glock(qd, FORCE, &q_gh);
@@ -1564,7 +1545,7 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 	if (fdq->d_fieldmask & ~GFS2_FIELDMASK)
 		return -EINVAL;
 
-	error = qd_get(sdp, type, from_kqid(&init_user_ns, qid), &qd);
+	error = qd_get(sdp, qid, &qd);
 	if (error)
 		return error;
 
-- 
1.7.5.4

