Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab3BMSBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:01:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59475 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760515Ab3BMR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:04 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:18 -0800
Message-Id: <1360777934-5663-29-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX182kDEcU31iC0JyLQSmodwKhHfvcsv1KOc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 29/85] gfs2: Report quotas in the caller's user namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When a quota is queried return the uid or the gid in the mapped into
the caller's user namespace.  In addition perform the munged version
of the mapping so that instead of -1 a value that does not map is
reported as the overflowuid or the overflowgid.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index dbfacaa..f8279ee 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1509,7 +1509,7 @@ static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lksb.sb_lvbptr;
 	fdq->d_version = FS_DQUOT_VERSION;
 	fdq->d_flags = (type == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
-	fdq->d_id = from_kqid(&init_user_ns, qid);
+	fdq->d_id = from_kqid_munged(current_user_ns(), qid);
 	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit) << sdp->sd_fsb2bb_shift;
 	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn) << sdp->sd_fsb2bb_shift;
 	fdq->d_bcount = be64_to_cpu(qlvb->qb_value) << sdp->sd_fsb2bb_shift;
-- 
1.7.5.4

