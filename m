Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914Ab3BMR5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:44 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56438 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab3BMR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:16 -0800
Message-Id: <1360777934-5663-27-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/GWwnkcV9PGKlAa3j7eox0Yauvbzi+dpU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 27/85] gfs2: Remove improper checks in gfs2_set_dqblk.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

In set_dqblk it is an error to look at fdq->d_id or fdq->d_flags.
Userspace quota applications do not set these fields when calling
quotactl(Q_XSETQLIM,...), and the kernel does not set those fields
when quota_setquota calls set_dqblk.

gfs2 never looks at fdq->d_id or fdq->d_flags after checking
to see if they match the id and type supplied to set_dqblk.

No other linux filesystem in set_dqblk looks at either fdq->d_id
or fdq->d_flags.

Therefore remove these bogus checks from gfs2 and allow normal
quota setting applications to work.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index ae55e24..e4f6ccf 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1543,13 +1543,9 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 	switch(qid.type) {
 	case USRQUOTA:
 		type = QUOTA_USER;
-		if (fdq->d_flags != FS_USER_QUOTA)
-			return -EINVAL;
 		break;
 	case GRPQUOTA:
 		type = QUOTA_GROUP;
-		if (fdq->d_flags != FS_GROUP_QUOTA)
-			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
@@ -1557,8 +1553,6 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 
 	if (fdq->d_fieldmask & ~GFS2_FIELDMASK)
 		return -EINVAL;
-	if (fdq->d_id != from_kqid(&init_user_ns, qid))
-		return -EINVAL;
 
 	error = qd_get(sdp, type, from_kqid(&init_user_ns, qid), &qd);
 	if (error)
-- 
1.7.5.4

