Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab3BMR5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:45 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56451 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393Ab3BMR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:41 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:21 -0800
Message-Id: <1360777934-5663-32-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX188RCjzQ/lRL17juSYabuBDvaN6ipdCWRE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0520]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 32/85] gfs2: Modify qdsb_get to take a struct kqid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 02913e9..20762ae 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -464,12 +464,13 @@ static void qd_unlock(struct gfs2_quota_data *qd)
 	qd_put(qd);
 }
 
-static int qdsb_get(struct gfs2_sbd *sdp, int user, u32 id,
+static int qdsb_get(struct gfs2_sbd *sdp, struct kqid qid,
 		    struct gfs2_quota_data **qdp)
 {
 	int error;
 
-	error = qd_get(sdp, user, id, qdp);
+	error = qd_get(sdp, qid.type == USRQUOTA ? QUOTA_USER : QUOTA_GROUP,
+		       from_kqid(&init_user_ns, qid), qdp);
 	if (error)
 		return error;
 
@@ -518,20 +519,20 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return 0;
 
-	error = qdsb_get(sdp, QUOTA_USER, ip->i_inode.i_uid, qd);
+	error = qdsb_get(sdp, make_kqid_uid(ip->i_inode.i_uid), qd);
 	if (error)
 		goto out;
 	ip->i_res->rs_qa_qd_num++;
 	qd++;
 
-	error = qdsb_get(sdp, QUOTA_GROUP, ip->i_inode.i_gid, qd);
+	error = qdsb_get(sdp, make_kqid_gid(ip->i_inode.i_gid), qd);
 	if (error)
 		goto out;
 	ip->i_res->rs_qa_qd_num++;
 	qd++;
 
 	if (uid != NO_UID_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
-		error = qdsb_get(sdp, QUOTA_USER, uid, qd);
+		error = qdsb_get(sdp, make_kqid_uid(uid), qd);
 		if (error)
 			goto out;
 		ip->i_res->rs_qa_qd_num++;
@@ -539,7 +540,7 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	}
 
 	if (gid != NO_GID_QUOTA_CHANGE && gid != ip->i_inode.i_gid) {
-		error = qdsb_get(sdp, QUOTA_GROUP, gid, qd);
+		error = qdsb_get(sdp, make_kqid_gid(gid), qd);
 		if (error)
 			goto out;
 		ip->i_res->rs_qa_qd_num++;
-- 
1.7.5.4

