Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab3BMRxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:53:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46627 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab3BMRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:53:19 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:50:58 -0800
Message-Id: <1360777934-5663-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+fVuAtCX3+9sgMJ8n2sntlOllJyP8fuH4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4714]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 09/85] 9p: Modify the stat structures to use kuid_t and kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

9p has thre strucrtures that can encode inode stat information.  Modify
all of those structures to contain kuid_t and kgid_t values.  Modify
he wire encoders and decoders of those structures to use 'u' and 'g' instead of
'd' in the format string where uids and gids are present.

This results in all kuid and kgid conversion to and from on the wire values
being performed by the same code in protocol.c where the client is known
at the time of the conversion.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/9p/vfs_inode.c   |    6 +++---
 include/net/9p/9p.h |   14 +++++++-------
 net/9p/client.c     |   18 +++++++++++++-----
 net/9p/protocol.c   |   13 +++++++------
 4 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 890bed5..1581fe2 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -228,9 +228,9 @@ v9fs_blank_wstat(struct p9_wstat *wstat)
 	wstat->uid = NULL;
 	wstat->gid = NULL;
 	wstat->muid = NULL;
-	wstat->n_uid = ~0;
-	wstat->n_gid = ~0;
-	wstat->n_muid = ~0;
+	wstat->n_uid = INVALID_UID;
+	wstat->n_gid = INVALID_GID;
+	wstat->n_muid = INVALID_UID;
 	wstat->extension = NULL;
 }
 
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 7184853..27dfe85 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -407,17 +407,17 @@ struct p9_wstat {
 	char *gid;
 	char *muid;
 	char *extension;	/* 9p2000.u extensions */
-	u32 n_uid;		/* 9p2000.u extensions */
-	u32 n_gid;		/* 9p2000.u extensions */
-	u32 n_muid;		/* 9p2000.u extensions */
+	kuid_t n_uid;		/* 9p2000.u extensions */
+	kgid_t n_gid;		/* 9p2000.u extensions */
+	kuid_t n_muid;		/* 9p2000.u extensions */
 };
 
 struct p9_stat_dotl {
 	u64 st_result_mask;
 	struct p9_qid qid;
 	u32 st_mode;
-	u32 st_uid;
-	u32 st_gid;
+	kuid_t st_uid;
+	kgid_t st_gid;
 	u64 st_nlink;
 	u64 st_rdev;
 	u64 st_size;
@@ -471,8 +471,8 @@ struct p9_stat_dotl {
 struct p9_iattr_dotl {
 	u32 valid;
 	u32 mode;
-	u32 uid;
-	u32 gid;
+	kuid_t uid;
+	kgid_t gid;
 	u64 size;
 	u64 atime_sec;
 	u64 atime_nsec;
diff --git a/net/9p/client.c b/net/9p/client.c
index 17855f0..8eb7542 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1711,7 +1711,9 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 		(unsigned long long)ret->qid.path, ret->qid.version, ret->mode,
 		ret->atime, ret->mtime, (unsigned long long)ret->length,
 		ret->name, ret->uid, ret->gid, ret->muid, ret->extension,
-		ret->n_uid, ret->n_gid, ret->n_muid);
+		from_kuid(&init_user_ns, ret->n_uid),
+		from_kgid(&init_user_ns, ret->n_gid),
+		from_kuid(&init_user_ns, ret->n_muid));
 
 	p9_free_req(clnt, req);
 	return ret;
@@ -1765,8 +1767,10 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 		"<<< st_btime_sec=%lld st_btime_nsec=%lld\n"
 		"<<< st_gen=%lld st_data_version=%lld",
 		ret->st_result_mask, ret->qid.type, ret->qid.path,
-		ret->qid.version, ret->st_mode, ret->st_nlink, ret->st_uid,
-		ret->st_gid, ret->st_rdev, ret->st_size, ret->st_blksize,
+		ret->qid.version, ret->st_mode, ret->st_nlink,
+		from_kuid(&init_user_ns, ret->st_uid),
+		from_kgid(&init_user_ns, ret->st_gid),
+		ret->st_rdev, ret->st_size, ret->st_blksize,
 		ret->st_blocks, ret->st_atime_sec, ret->st_atime_nsec,
 		ret->st_mtime_sec, ret->st_mtime_nsec, ret->st_ctime_sec,
 		ret->st_ctime_nsec, ret->st_btime_sec, ret->st_btime_nsec,
@@ -1829,7 +1833,9 @@ int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 		(unsigned long long)wst->qid.path, wst->qid.version, wst->mode,
 		wst->atime, wst->mtime, (unsigned long long)wst->length,
 		wst->name, wst->uid, wst->gid, wst->muid, wst->extension,
-		wst->n_uid, wst->n_gid, wst->n_muid);
+		from_kuid(&init_user_ns, wst->n_uid),
+		from_kgid(&init_user_ns, wst->n_gid),
+		from_kuid(&init_user_ns, wst->n_muid));
 
 	req = p9_client_rpc(clnt, P9_TWSTAT, "dwS", fid->fid, wst->size+2, wst);
 	if (IS_ERR(req)) {
@@ -1858,7 +1864,9 @@ int p9_client_setattr(struct p9_fid *fid, struct p9_iattr_dotl *p9attr)
 		"    valid=%x mode=%x uid=%d gid=%d size=%lld\n"
 		"    atime_sec=%lld atime_nsec=%lld\n"
 		"    mtime_sec=%lld mtime_nsec=%lld\n",
-		p9attr->valid, p9attr->mode, p9attr->uid, p9attr->gid,
+		p9attr->valid, p9attr->mode,
+		from_kuid(&init_user_ns, p9attr->uid),
+		from_kgid(&init_user_ns, p9attr->gid),
 		p9attr->size, p9attr->atime_sec, p9attr->atime_nsec,
 		p9attr->mtime_sec, p9attr->mtime_nsec);
 
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index c289c6c..ab9127e 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -199,11 +199,12 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				    va_arg(ap, struct p9_wstat *);
 
 				memset(stbuf, 0, sizeof(struct p9_wstat));
-				stbuf->n_uid = stbuf->n_gid = stbuf->n_muid =
-									-1;
+				stbuf->n_uid = stbuf->n_muid = INVALID_UID;
+				stbuf->n_gid = INVALID_GID;
+
 				errcode =
 				    p9pdu_readf(pdu, proto_version,
-						"wwdQdddqssss?sddd",
+						"wwdQdddqssss?sugu",
 						&stbuf->size, &stbuf->type,
 						&stbuf->dev, &stbuf->qid,
 						&stbuf->mode, &stbuf->atime,
@@ -316,7 +317,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				memset(stbuf, 0, sizeof(struct p9_stat_dotl));
 				errcode =
 				    p9pdu_readf(pdu, proto_version,
-					"qQdddqqqqqqqqqqqqqqq",
+					"qQdugqqqqqqqqqqqqqqq",
 					&stbuf->st_result_mask,
 					&stbuf->qid,
 					&stbuf->st_mode,
@@ -426,7 +427,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				    va_arg(ap, const struct p9_wstat *);
 				errcode =
 				    p9pdu_writef(pdu, proto_version,
-						 "wwdQdddqssss?sddd",
+						 "wwdQdddqssss?sugu",
 						 stbuf->size, stbuf->type,
 						 stbuf->dev, &stbuf->qid,
 						 stbuf->mode, stbuf->atime,
@@ -504,7 +505,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
 							struct p9_iattr_dotl *);
 
 				errcode = p9pdu_writef(pdu, proto_version,
-							"ddddqqqqq",
+							"ddugqqqqq",
 							p9attr->valid,
 							p9attr->mode,
 							p9attr->uid,
-- 
1.7.5.4

