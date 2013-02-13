Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071Ab3BMSWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:22:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56473 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab3BMR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:42 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:51:00 -0800
Message-Id: <1360777934-5663-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19t2JHBQIztI2KfqNTIh6wdQSNZv7R5bys=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 11/85] 9p: Modify struct v9fs_session_info to use a kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Change struct v9fs_session_info and the code that popluates it to use
kuids and kgids.  When parsing the 9p mount options convert the
dfltuid, dflutgid, and the session uid from the current user namespace
into kuids and kgids.  Modify V9FS_DEFUID and V9FS_DEFGUID to be kuid
and kgid values.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/9p/v9fs.c |   30 +++++++++++++++++++++++++-----
 fs/9p/v9fs.h |   10 +++++-----
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d64967c..58e6cbc 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -161,7 +161,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				ret = r;
 				continue;
 			}
-			v9ses->dfltuid = option;
+			v9ses->dfltuid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(v9ses->dfltuid)) {
+				p9_debug(P9_DEBUG_ERROR,
+					 "uid field, but not a uid?\n");
+				ret = -EINVAL;
+				continue;
+			}
 			break;
 		case Opt_dfltgid:
 			r = match_int(&args[0], &option);
@@ -171,7 +177,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				ret = r;
 				continue;
 			}
-			v9ses->dfltgid = option;
+			v9ses->dfltgid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(v9ses->dfltgid)) {
+				p9_debug(P9_DEBUG_ERROR,
+					 "gid field, but not a gid?\n");
+				ret = -EINVAL;
+				continue;
+			}
 			break;
 		case Opt_afid:
 			r = match_int(&args[0], &option);
@@ -248,8 +260,9 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 			else if (strcmp(s, "client") == 0) {
 				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			} else {
+				uid_t uid;
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				v9ses->uid = simple_strtoul(s, &e, 10);
+				uid = simple_strtoul(s, &e, 10);
 				if (*e != '\0') {
 					ret = -EINVAL;
 					pr_info("Unknown access argument %s\n",
@@ -257,6 +270,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 					kfree(s);
 					goto free_and_return;
 				}
+				v9ses->uid = make_kuid(current_user_ns(), uid);
+				if (!uid_valid(v9ses->uid)) {
+					ret = -EINVAL;
+					pr_info("Uknown uid %s\n", s);
+					kfree(s);
+					goto free_and_return;
+				}
 			}
 
 			kfree(s);
@@ -319,7 +339,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	list_add(&v9ses->slist, &v9fs_sessionlist);
 	spin_unlock(&v9fs_sessionlist_lock);
 
-	v9ses->uid = ~0;
+	v9ses->uid = INVALID_UID;
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
 
@@ -364,7 +384,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 
 		v9ses->flags &= ~V9FS_ACCESS_MASK;
 		v9ses->flags |= V9FS_ACCESS_ANY;
-		v9ses->uid = ~0;
+		v9ses->uid = INVALID_UID;
 	}
 	if (!v9fs_proto_dotl(v9ses) ||
 		!((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_CLIENT)) {
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 34c59f1..a8e127c 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -109,9 +109,9 @@ struct v9fs_session_info {
 	char *uname;		/* user name to mount as */
 	char *aname;		/* name of remote hierarchy being mounted */
 	unsigned int maxdata;	/* max data for client interface */
-	unsigned int dfltuid;	/* default uid/muid for legacy support */
-	unsigned int dfltgid;	/* default gid for legacy support */
-	u32 uid;		/* if ACCESS_SINGLE, the uid that has access */
+	kuid_t dfltuid;		/* default uid/muid for legacy support */
+	kgid_t dfltgid;		/* default gid for legacy support */
+	kuid_t uid;		/* if ACCESS_SINGLE, the uid that has access */
 	struct p9_client *clnt;	/* 9p client */
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct backing_dev_info bdi;
@@ -165,8 +165,8 @@ extern struct inode *v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses,
 #define V9FS_PORT	564
 #define V9FS_DEFUSER	"nobody"
 #define V9FS_DEFANAME	""
-#define V9FS_DEFUID	(-2)
-#define V9FS_DEFGID	(-2)
+#define V9FS_DEFUID	KUIDT_INIT(-2)
+#define V9FS_DEFGID	KGIDT_INIT(-2)
 
 static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 {
-- 
1.7.5.4

