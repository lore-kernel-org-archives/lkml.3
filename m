Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab3BMSA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:00:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59505 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760564Ab3BMR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:05 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:20 -0800
Message-Id: <1360777934-5663-31-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX197NZEGP1cbQ6QwPmiYttCcwJ9q5TcHfDg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 31/85] gfs2: Modify struct gfs2_quota_change_host to use struct kqid
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
 fs/gfs2/quota.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 0e7c982..02913e9 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -71,7 +71,7 @@
 struct gfs2_quota_change_host {
 	u64 qc_change;
 	u32 qc_flags; /* GFS2_QCF_... */
-	u32 qc_id;
+	struct kqid qc_id;
 };
 
 static LIST_HEAD(qd_lru_list);
@@ -1200,7 +1200,9 @@ static void gfs2_quota_change_in(struct gfs2_quota_change_host *qc, const void *
 
 	qc->qc_change = be64_to_cpu(str->qc_change);
 	qc->qc_flags = be32_to_cpu(str->qc_flags);
-	qc->qc_id = be32_to_cpu(str->qc_id);
+	qc->qc_id = make_kqid(&init_user_ns,
+			      (qc->qc_flags & GFS2_QCF_USER)?USRQUOTA:GRPQUOTA,
+			      be32_to_cpu(str->qc_id));
 }
 
 int gfs2_quota_init(struct gfs2_sbd *sdp)
@@ -1264,7 +1266,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 				continue;
 
 			error = qd_alloc(sdp, (qc.qc_flags & GFS2_QCF_USER),
-					 qc.qc_id, &qd);
+					 from_kqid(&init_user_ns, qc.qc_id), &qd);
 			if (error) {
 				brelse(bh);
 				goto fail;
-- 
1.7.5.4

