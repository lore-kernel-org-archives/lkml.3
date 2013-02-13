Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab3BMRxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:53:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56632 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923Ab3BMRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:53:08 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:50:57 -0800
Message-Id: <1360777934-5663-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+dT6I2S9QMWlr1m0uUaVpHRnx1198X3Es=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3911]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 08/85] 9p: Transmit kuid and kgid values
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Modify the p9_client_rpc format specifiers of every function that
directly transmits a uid or a gid from 'd' to 'u' or 'g' as
appropriate.

Modify those same functions to take kuid_t and kgid_t parameters
instead of uid_t and gid_t parameters.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/9p/v9fs.c            |    2 +-
 include/net/9p/client.h |   10 +++++-----
 net/9p/client.c         |   25 +++++++++++++------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d934f04..4e0bd9d 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -375,7 +375,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		v9ses->flags &= ~V9FS_ACL_MASK;
 	}
 
-	fid = p9_client_attach(v9ses->clnt, NULL, v9ses->uname, ~0,
+	fid = p9_client_attach(v9ses->clnt, NULL, v9ses->uname, INVALID_UID,
 							v9ses->aname);
 	if (IS_ERR(fid)) {
 		retval = PTR_ERR(fid);
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index fc9b90b..6b031ab 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -220,17 +220,17 @@ void p9_client_destroy(struct p9_client *clnt);
 void p9_client_disconnect(struct p9_client *clnt);
 void p9_client_begin_disconnect(struct p9_client *clnt);
 struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
-					char *uname, u32 n_uname, char *aname);
+				char *uname, kuid_t n_uname, char *aname);
 struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 		char **wnames, int clone);
 int p9_client_open(struct p9_fid *fid, int mode);
 int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
 							char *extension);
 int p9_client_link(struct p9_fid *fid, struct p9_fid *oldfid, char *newname);
-int p9_client_symlink(struct p9_fid *fid, char *name, char *symname, gid_t gid,
+int p9_client_symlink(struct p9_fid *fid, char *name, char *symname, kgid_t gid,
 							struct p9_qid *qid);
 int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
-		gid_t gid, struct p9_qid *qid);
+		kgid_t gid, struct p9_qid *qid);
 int p9_client_clunk(struct p9_fid *fid);
 int p9_client_fsync(struct p9_fid *fid, int datasync);
 int p9_client_remove(struct p9_fid *fid);
@@ -250,9 +250,9 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 							u64 request_mask);
 
 int p9_client_mknod_dotl(struct p9_fid *oldfid, char *name, int mode,
-			dev_t rdev, gid_t gid, struct p9_qid *);
+			dev_t rdev, kgid_t gid, struct p9_qid *);
 int p9_client_mkdir_dotl(struct p9_fid *fid, char *name, int mode,
-				gid_t gid, struct p9_qid *);
+				kgid_t gid, struct p9_qid *);
 int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status);
 int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *fl);
 struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
diff --git a/net/9p/client.c b/net/9p/client.c
index 34d4176..17855f0 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1100,7 +1100,7 @@ void p9_client_begin_disconnect(struct p9_client *clnt)
 EXPORT_SYMBOL(p9_client_begin_disconnect);
 
 struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
-	char *uname, u32 n_uname, char *aname)
+	char *uname, kuid_t n_uname, char *aname)
 {
 	int err = 0;
 	struct p9_req_t *req;
@@ -1117,7 +1117,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 		goto error;
 	}
 
-	req = p9_client_rpc(clnt, P9_TATTACH, "ddss?d", fid->fid,
+	req = p9_client_rpc(clnt, P9_TATTACH, "ddss?u", fid->fid,
 			afid ? afid->fid : P9_NOFID, uname, aname, n_uname);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -1270,7 +1270,7 @@ error:
 EXPORT_SYMBOL(p9_client_open);
 
 int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
-		gid_t gid, struct p9_qid *qid)
+		kgid_t gid, struct p9_qid *qid)
 {
 	int err = 0;
 	struct p9_client *clnt;
@@ -1279,13 +1279,14 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
 
 	p9_debug(P9_DEBUG_9P,
 			">>> TLCREATE fid %d name %s flags %d mode %d gid %d\n",
-			ofid->fid, name, flags, mode, gid);
+			ofid->fid, name, flags, mode,
+		 	from_kgid(&init_user_ns, gid));
 	clnt = ofid->clnt;
 
 	if (ofid->mode != -1)
 		return -EINVAL;
 
-	req = p9_client_rpc(clnt, P9_TLCREATE, "dsddd", ofid->fid, name, flags,
+	req = p9_client_rpc(clnt, P9_TLCREATE, "dsddg", ofid->fid, name, flags,
 			mode, gid);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -1358,7 +1359,7 @@ error:
 }
 EXPORT_SYMBOL(p9_client_fcreate);
 
-int p9_client_symlink(struct p9_fid *dfid, char *name, char *symtgt, gid_t gid,
+int p9_client_symlink(struct p9_fid *dfid, char *name, char *symtgt, kgid_t gid,
 		struct p9_qid *qid)
 {
 	int err = 0;
@@ -1369,7 +1370,7 @@ int p9_client_symlink(struct p9_fid *dfid, char *name, char *symtgt, gid_t gid,
 			dfid->fid, name, symtgt);
 	clnt = dfid->clnt;
 
-	req = p9_client_rpc(clnt, P9_TSYMLINK, "dssd", dfid->fid, name, symtgt,
+	req = p9_client_rpc(clnt, P9_TSYMLINK, "dssg", dfid->fid, name, symtgt,
 			gid);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2106,7 +2107,7 @@ error:
 EXPORT_SYMBOL(p9_client_readdir);
 
 int p9_client_mknod_dotl(struct p9_fid *fid, char *name, int mode,
-			dev_t rdev, gid_t gid, struct p9_qid *qid)
+			dev_t rdev, kgid_t gid, struct p9_qid *qid)
 {
 	int err;
 	struct p9_client *clnt;
@@ -2116,7 +2117,7 @@ int p9_client_mknod_dotl(struct p9_fid *fid, char *name, int mode,
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TMKNOD fid %d name %s mode %d major %d "
 		"minor %d\n", fid->fid, name, mode, MAJOR(rdev), MINOR(rdev));
-	req = p9_client_rpc(clnt, P9_TMKNOD, "dsdddd", fid->fid, name, mode,
+	req = p9_client_rpc(clnt, P9_TMKNOD, "dsdddg", fid->fid, name, mode,
 		MAJOR(rdev), MINOR(rdev), gid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -2137,7 +2138,7 @@ error:
 EXPORT_SYMBOL(p9_client_mknod_dotl);
 
 int p9_client_mkdir_dotl(struct p9_fid *fid, char *name, int mode,
-				gid_t gid, struct p9_qid *qid)
+				kgid_t gid, struct p9_qid *qid)
 {
 	int err;
 	struct p9_client *clnt;
@@ -2146,8 +2147,8 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, char *name, int mode,
 	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TMKDIR fid %d name %s mode %d gid %d\n",
-		 fid->fid, name, mode, gid);
-	req = p9_client_rpc(clnt, P9_TMKDIR, "dsdd", fid->fid, name, mode,
+		 fid->fid, name, mode, from_kgid(&init_user_ns, gid));
+	req = p9_client_rpc(clnt, P9_TMKDIR, "dsdg", fid->fid, name, mode,
 		gid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-- 
1.7.5.4

