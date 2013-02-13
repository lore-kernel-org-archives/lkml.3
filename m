Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab3BMR7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:59:03 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59538 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071Ab3BMR6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:07 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:22 -0800
Message-Id: <1360777934-5663-33-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+ji3ZL16yBFePY+elJvEgJF71PPRIJxRc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 33/85] gfs2: Convert gfs2_quota_refresh to take a kqid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- In quota_refresh_user_store convert the user supplied uid
  into a kqid and pass it to gfs2_quota_refresh.

- In quota_refresh_group_store convert the user supplied gid
  into a kqid and pass it to gfs2_quota_refresh.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |    5 +++--
 fs/gfs2/quota.h |    2 +-
 fs/gfs2/sys.c   |   14 ++++++++++++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 20762ae..47315c0 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1177,13 +1177,14 @@ static int gfs2_quota_sync_timeo(struct super_block *sb, int type)
 	return gfs2_quota_sync(sb, type);
 }
 
-int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id)
+int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_holder q_gh;
 	int error;
 
-	error = qd_get(sdp, user, id, &qd);
+	error = qd_get(sdp, qid.type == USRQUOTA ? QUOTA_USER : QUOTA_GROUP,
+		       from_kqid(&init_user_ns, qid), &qd);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 7f67323..bef805d 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -28,7 +28,7 @@ extern void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 			      u32 uid, u32 gid);
 
 extern int gfs2_quota_sync(struct super_block *sb, int type);
-extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
+extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid);
 
 extern int gfs2_quota_init(struct gfs2_sbd *sdp);
 extern void gfs2_quota_cleanup(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 8056b7b..e6d8d48 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -175,6 +175,7 @@ static ssize_t quota_sync_store(struct gfs2_sbd *sdp, const char *buf,
 static ssize_t quota_refresh_user_store(struct gfs2_sbd *sdp, const char *buf,
 					size_t len)
 {
+	struct kqid qid;
 	int error;
 	u32 id;
 
@@ -183,13 +184,18 @@ static ssize_t quota_refresh_user_store(struct gfs2_sbd *sdp, const char *buf,
 
 	id = simple_strtoul(buf, NULL, 0);
 
-	error = gfs2_quota_refresh(sdp, 1, id);
+	qid = make_kqid(current_user_ns(), USRQUOTA, id);
+	if (!qid_valid(qid))
+		return -EINVAL;
+
+	error = gfs2_quota_refresh(sdp, qid);
 	return error ? error : len;
 }
 
 static ssize_t quota_refresh_group_store(struct gfs2_sbd *sdp, const char *buf,
 					 size_t len)
 {
+	struct kqid qid;
 	int error;
 	u32 id;
 
@@ -198,7 +204,11 @@ static ssize_t quota_refresh_group_store(struct gfs2_sbd *sdp, const char *buf,
 
 	id = simple_strtoul(buf, NULL, 0);
 
-	error = gfs2_quota_refresh(sdp, 0, id);
+	qid = make_kqid(current_user_ns(), GRPQUOTA, id);
+	if (!qid_valid(qid))
+		return -EINVAL;
+
+	error = gfs2_quota_refresh(sdp, qid);
 	return error ? error : len;
 }
 
-- 
1.7.5.4

