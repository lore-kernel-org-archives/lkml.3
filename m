Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437Ab3BMSQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:16:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59285 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963Ab3BMR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:54 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:24 -0800
Message-Id: <1360777934-5663-35-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/iaFGBAxvQXrT9nXT4a0PAJTjMoV2uO80=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0048]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 35/85] gfs2: Remove the QUOTA_USER and QUOTA_GROUP defines
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Remove the QUOTA_USER and QUOTA_GRUP defines.  Remove
the last vestigal users of QUOTA_USER and QUOTA_GROUP.

Now that struct kqid is used throughout the gfs2 quota
code the need there is to use QUOTA_USER and QUOTA_GROUP
and the defines are just extraneous and confusing.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8cb4d10..0bbb040 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -65,9 +65,6 @@
 #include "inode.h"
 #include "util.h"
 
-#define QUOTA_USER 1
-#define QUOTA_GROUP 0
-
 struct gfs2_quota_change_host {
 	u64 qc_change;
 	u32 qc_flags; /* GFS2_QCF_... */
@@ -1476,18 +1473,14 @@ static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 	struct gfs2_quota_data *qd;
 	struct gfs2_holder q_gh;
 	int error;
-	int type;
 
 	memset(fdq, 0, sizeof(struct fs_disk_quota));
 
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return -ESRCH; /* Crazy XFS error code */
 
-	if (qid.type == USRQUOTA)
-		type = QUOTA_USER;
-	else if (qid.type == GRPQUOTA)
-		type = QUOTA_GROUP;
-	else
+	if ((qid.type != USRQUOTA) &&
+	    (qid.type != GRPQUOTA))
 		return -EINVAL;
 
 	error = qd_get(sdp, qid, &qd);
@@ -1499,7 +1492,7 @@ static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 
 	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lksb.sb_lvbptr;
 	fdq->d_version = FS_DQUOT_VERSION;
-	fdq->d_flags = (type == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
+	fdq->d_flags = (qid.type == USRQUOTA) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
 	fdq->d_id = from_kqid_munged(current_user_ns(), qid);
 	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit) << sdp->sd_fsb2bb_shift;
 	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn) << sdp->sd_fsb2bb_shift;
@@ -1526,21 +1519,13 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 	int alloc_required;
 	loff_t offset;
 	int error;
-	int type;
 
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return -ESRCH; /* Crazy XFS error code */
 
-	switch(qid.type) {
-	case USRQUOTA:
-		type = QUOTA_USER;
-		break;
-	case GRPQUOTA:
-		type = QUOTA_GROUP;
-		break;
-	default:
+	if ((qid.type != USRQUOTA) &&
+	    (qid.type != GRPQUOTA))
 		return -EINVAL;
-	}
 
 	if (fdq->d_fieldmask & ~GFS2_FIELDMASK)
 		return -EINVAL;
-- 
1.7.5.4

