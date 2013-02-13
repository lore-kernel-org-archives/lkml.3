Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222Ab3BMSC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:02:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34225 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965195Ab3BMSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:05 -0800
Message-Id: <1360777934-5663-76-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19zuos3GoAeQnqeP7BG1nezTTcwK+NFzag=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 76/85] cifs: Use kuids and kgids SID to uid/gid mapping
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Update id_mode_to_cifs_acl to take a kuid_t and a kgid_t.

Replace NO_CHANGE_32 with INVALID_UID and INVALID_GID, and tests for
NO_CHANGE_32 with uid_valid and gid_valid.

Carefully unpack the value returned from request_key.  memcpy the
value into the expected type.  The convert the uid/gid into a
kuid/kgid.  And then only if the result is a valid kuid or kgid update
fuid/fgid.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsacl.c   |   43 +++++++++++++++++++++++++++++--------------
 fs/cifs/cifspdu.h   |    1 -
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/inode.c     |    8 ++++----
 4 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index aaaf5ce..f1e3f25 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -266,8 +266,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
-	uid_t fuid = cifs_sb->mnt_uid;
-	gid_t fgid = cifs_sb->mnt_gid;
+	kuid_t fuid = cifs_sb->mnt_uid;
+	kgid_t fgid = cifs_sb->mnt_gid;
 
 	/*
 	 * If we have too many subauthorities, then something is really wrong.
@@ -306,10 +306,21 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		goto out_key_put;
 	}
 
-	if (sidtype == SIDOWNER)
-		memcpy(&fuid, &sidkey->payload.value, sizeof(uid_t));
-	else
-		memcpy(&fgid, &sidkey->payload.value, sizeof(gid_t));
+	if (sidtype == SIDOWNER) {
+		kuid_t uid;
+		uid_t id;
+		memcpy(&id, &sidkey->payload.value, sizeof(uid_t));
+		uid = make_kuid(&init_user_ns, id);
+		if (uid_valid(uid))
+			fuid = uid;
+	} else {
+		kgid_t gid;
+		gid_t id;
+		memcpy(&id, &sidkey->payload.value, sizeof(gid_t));
+		gid = make_kgid(&init_user_ns, id);
+		if (gid_valid(gid))
+			fgid = gid;
+	}
 
 out_key_put:
 	key_put(sidkey);
@@ -776,7 +787,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 
 /* Convert permission bits from mode to equivalent CIFS ACL */
 static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
-	__u32 secdesclen, __u64 nmode, uid_t uid, gid_t gid, int *aclflag)
+	__u32 secdesclen, __u64 nmode, kuid_t uid, kgid_t gid, int *aclflag)
 {
 	int rc = 0;
 	__u32 dacloffset;
@@ -808,17 +819,19 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		*aclflag = CIFS_ACL_DACL;
 	} else {
 		memcpy(pnntsd, pntsd, secdesclen);
-		if (uid != NO_CHANGE_32) { /* chown */
+		if (uid_valid(uid)) { /* chown */
+			uid_t id;
 			owner_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
 					le32_to_cpu(pnntsd->osidoffset));
 			nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!nowner_sid_ptr)
 				return -ENOMEM;
-			rc = id_to_sid(uid, SIDOWNER, nowner_sid_ptr);
+			id = from_kuid(&init_user_ns, uid);
+			rc = id_to_sid(id, SIDOWNER, nowner_sid_ptr);
 			if (rc) {
 				cFYI(1, "%s: Mapping error %d for owner id %d",
-						__func__, rc, uid);
+						__func__, rc, id);
 				kfree(nowner_sid_ptr);
 				return rc;
 			}
@@ -826,17 +839,19 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			kfree(nowner_sid_ptr);
 			*aclflag = CIFS_ACL_OWNER;
 		}
-		if (gid != NO_CHANGE_32) { /* chgrp */
+		if (gid_valid(gid)) { /* chgrp */
+			gid_t id;
 			group_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
 					le32_to_cpu(pnntsd->gsidoffset));
 			ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!ngroup_sid_ptr)
 				return -ENOMEM;
-			rc = id_to_sid(gid, SIDGROUP, ngroup_sid_ptr);
+			id = from_kgid(&init_user_ns, gid);
+			rc = id_to_sid(id, SIDGROUP, ngroup_sid_ptr);
 			if (rc) {
 				cFYI(1, "%s: Mapping error %d for group id %d",
-						__func__, rc, gid);
+						__func__, rc, id);
 				kfree(ngroup_sid_ptr);
 				return rc;
 			}
@@ -1004,7 +1019,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 /* Convert mode bits to an ACL so we can update the ACL on the server */
 int
 id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
-			uid_t uid, gid_t gid)
+			kuid_t uid, kgid_t gid)
 {
 	int rc = 0;
 	int aclflag = CIFS_ACL_DACL; /* default flag to set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index b9d59a9..e996ff6 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -277,7 +277,6 @@
 #define CIFS_NO_HANDLE        0xFFFF
 
 #define NO_CHANGE_64          0xFFFFFFFFFFFFFFFFULL
-#define NO_CHANGE_32          0xFFFFFFFFUL
 
 /* IPC$ in ASCII */
 #define CIFS_IPC_RESOURCE "\x49\x50\x43\x24"
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1988c1b..0060ec2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -161,7 +161,7 @@ extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
 extern int id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64,
-					uid_t, gid_t);
+					kuid_t, kgid_t);
 extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 					const char *, u32 *);
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index d7ea2a6..d4cf750 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2090,8 +2090,8 @@ static int
 cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 {
 	unsigned int xid;
-	uid_t uid = NO_CHANGE_32;
-	gid_t gid = NO_CHANGE_32;
+	kuid_t uid = INVALID_UID;
+	kgid_t gid = INVALID_GID;
 	struct inode *inode = direntry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
@@ -2150,7 +2150,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 #ifdef CONFIG_CIFS_ACL
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-		if (uid != NO_CHANGE_32 || gid != NO_CHANGE_32) {
+		if (uid_valid(uid) || gid_valid(gid)) {
 			rc = id_mode_to_cifs_acl(inode, full_path, NO_CHANGE_64,
 							uid, gid);
 			if (rc) {
@@ -2174,7 +2174,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 #ifdef CONFIG_CIFS_ACL
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 			rc = id_mode_to_cifs_acl(inode, full_path, mode,
-						NO_CHANGE_32, NO_CHANGE_32);
+						INVALID_UID, INVALID_GID);
 			if (rc) {
 				cFYI(1, "%s: Setting ACL failed with error: %d",
 					__func__, rc);
-- 
1.7.5.4

