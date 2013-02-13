Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002Ab3BMRx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:53:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56785 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988Ab3BMRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:53:24 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:50:59 -0800
Message-Id: <1360777934-5663-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19UGlqaR0+0z8JIvkultkhWU56Y33WpPjE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0017]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 10/85] 9p: Modify struct 9p_fid to use a kuid_t not a uid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Change struct 9p_fid and it's associated functions to
use kuid_t's instead of uid_t.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/9p/fid.c             |   17 +++++++++--------
 fs/9p/v9fs.c            |    2 +-
 include/net/9p/client.h |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index da8eefb..afd4724 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -74,19 +74,20 @@ int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
  *
  */
 
-static struct p9_fid *v9fs_fid_find(struct dentry *dentry, u32 uid, int any)
+static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 {
 	struct v9fs_dentry *dent;
 	struct p9_fid *fid, *ret;
 
 	p9_debug(P9_DEBUG_VFS, " dentry: %s (%p) uid %d any %d\n",
-		 dentry->d_name.name, dentry, uid, any);
+		 dentry->d_name.name, dentry, from_kuid(&init_user_ns, uid),
+		 any);
 	dent = (struct v9fs_dentry *) dentry->d_fsdata;
 	ret = NULL;
 	if (dent) {
 		spin_lock(&dent->lock);
 		list_for_each_entry(fid, &dent->fidlist, dlist) {
-			if (any || fid->uid == uid) {
+			if (any || uid_eq(fid->uid, uid)) {
 				ret = fid;
 				break;
 			}
@@ -126,7 +127,7 @@ err_out:
 }
 
 static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
-					       uid_t uid, int any)
+					       kuid_t uid, int any)
 {
 	struct dentry *ds;
 	char **wnames, *uname;
@@ -233,7 +234,7 @@ err_out:
 
 struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 {
-	uid_t uid;
+	kuid_t uid;
 	int  any, access;
 	struct v9fs_session_info *v9ses;
 
@@ -253,7 +254,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 		break;
 
 	default:
-		uid = ~0;
+		uid = INVALID_UID;
 		any = 0;
 		break;
 	}
@@ -272,7 +273,7 @@ struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 	return ret;
 }
 
-static struct p9_fid *v9fs_fid_clone_with_uid(struct dentry *dentry, uid_t uid)
+static struct p9_fid *v9fs_fid_clone_with_uid(struct dentry *dentry, kuid_t uid)
 {
 	struct p9_fid *fid, *ret;
 
@@ -289,7 +290,7 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	int err;
 	struct p9_fid *fid;
 
-	fid = v9fs_fid_clone_with_uid(dentry, 0);
+	fid = v9fs_fid_clone_with_uid(dentry, GLOBAL_ROOT_UID);
 	if (IS_ERR(fid))
 		goto error_out;
 	/*
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 4e0bd9d..d64967c 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -387,7 +387,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_SINGLE)
 		fid->uid = v9ses->uid;
 	else
-		fid->uid = ~0;
+		fid->uid = INVALID_UID;
 
 #ifdef CONFIG_9P_FSCACHE
 	/* register the session for caching */
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 6b031ab..5ff70f4 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -187,7 +187,7 @@ struct p9_fid {
 	int mode;
 	struct p9_qid qid;
 	u32 iounit;
-	uid_t uid;
+	kuid_t uid;
 
 	void *rdir;
 
-- 
1.7.5.4

