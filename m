Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363Ab3BMSJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:09:12 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60166 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202Ab3BMSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:52:00 -0800
Message-Id: <1360777934-5663-71-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+Q3lYu1CgT4GITDOZBG5lDBYAjIpYJ79A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1221]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 71/85] nfsd: Properly compare and initialize kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Use uid_eq(uid, GLOBAL_ROOT_UID) instead of !uid.
Use gid_eq(gid, GLOBAL_ROOT_GID) instead of !gid.
Use uid_eq(uid, INVALID_UID) instead of uid == -1
Use gid_eq(uid, INVALID_GID) instead of gid == -1
Use uid = GLOBAL_ROOT_UID instead of uid = 0;
Use gid = GLOBAL_ROOT_GID instead of gid = 0;
Use !uid_eq(uid1, uid2) instead of uid1 != uid2.
Use !gid_eq(gid1, gid2) instead of gid1 != gid2.
Use uid_eq(uid1, uid2) instead of uid1 == uid2.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/auth.c        |   10 +++++-----
 fs/nfsd/nfs4recover.c |    4 ++--
 fs/nfsd/nfs4state.c   |    6 +++---
 fs/nfsd/vfs.c         |    8 ++++----
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 4d6642b..06cddd5 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -47,9 +47,9 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		if (!gi)
 			goto oom;
 	} else if (flags & NFSEXP_ROOTSQUASH) {
-		if (!new->fsuid)
+		if (uid_eq(new->fsuid, GLOBAL_ROOT_UID))
 			new->fsuid = exp->ex_anon_uid;
-		if (!new->fsgid)
+		if (gid_eq(new->fsgid, GLOBAL_ROOT_GID))
 			new->fsgid = exp->ex_anon_gid;
 
 		gi = groups_alloc(rqgi->ngroups);
@@ -66,9 +66,9 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		gi = get_group_info(rqgi);
 	}
 
-	if (new->fsuid == (uid_t) -1)
+	if (uid_eq(new->fsuid, INVALID_UID))
 		new->fsuid = exp->ex_anon_uid;
-	if (new->fsgid == (gid_t) -1)
+	if (gid_eq(new->fsgid, INVALID_GID))
 		new->fsgid = exp->ex_anon_gid;
 
 	ret = set_groups(new, gi);
@@ -76,7 +76,7 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	if (ret < 0)
 		goto error;
 
-	if (new->fsuid)
+	if (!uid_eq(new->fsuid, GLOBAL_ROOT_UID))
 		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
 	else
 		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index ba6fdd4..4914af4 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -73,8 +73,8 @@ nfs4_save_creds(const struct cred **original_creds)
 	if (!new)
 		return -ENOMEM;
 
-	new->fsuid = 0;
-	new->fsgid = 0;
+	new->fsuid = GLOBAL_ROOT_UID;
+	new->fsgid = GLOBAL_ROOT_GID;
 	*original_creds = override_creds(new);
 	put_cred(new);
 	return 0;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ac8ed96..0af6d3c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1202,7 +1202,7 @@ static bool groups_equal(struct group_info *g1, struct group_info *g2)
 	if (g1->ngroups != g2->ngroups)
 		return false;
 	for (i=0; i<g1->ngroups; i++)
-		if (GROUP_AT(g1, i) != GROUP_AT(g2, i))
+		if (!gid_eq(GROUP_AT(g1, i), GROUP_AT(g2, i)))
 			return false;
 	return true;
 }
@@ -1227,8 +1227,8 @@ static bool
 same_creds(struct svc_cred *cr1, struct svc_cred *cr2)
 {
 	if ((is_gss_cred(cr1) != is_gss_cred(cr2))
-		|| (cr1->cr_uid != cr2->cr_uid)
-		|| (cr1->cr_gid != cr2->cr_gid)
+		|| (!uid_eq(cr1->cr_uid, cr2->cr_uid))
+		|| (!gid_eq(cr1->cr_gid, cr2->cr_gid))
 		|| !groups_equal(cr1->cr_group_info, cr2->cr_group_info))
 		return false;
 	if (cr1->cr_principal == cr2->cr_principal)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d586117..31ff1d6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -401,8 +401,8 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 
 	/* Revoke setuid/setgid on chown */
 	if (!S_ISDIR(inode->i_mode) &&
-	    (((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid) ||
-	     ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid))) {
+	    (((iap->ia_valid & ATTR_UID) && !uid_eq(iap->ia_uid, inode->i_uid)) ||
+	     ((iap->ia_valid & ATTR_GID) && !gid_eq(iap->ia_gid, inode->i_gid)))) {
 		iap->ia_valid |= ATTR_KILL_PRIV;
 		if (iap->ia_valid & ATTR_MODE) {
 			/* we're setting mode too, just clear the s*id bits */
@@ -1205,7 +1205,7 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	 * send along the gid on create when it tries to implement
 	 * setgid directories via NFS:
 	 */
-	if (current_fsuid() != 0)
+	if (!uid_eq(current_fsuid(), GLOBAL_ROOT_UID))
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
 	if (iap->ia_valid)
 		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
@@ -2150,7 +2150,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 * with NFSv3.
 	 */
 	if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
-	    inode->i_uid == current_fsuid())
+	    uid_eq(inode->i_uid, current_fsuid()))
 		return 0;
 
 	/* This assumes  NFSD_MAY_{READ,WRITE,EXEC} == MAY_{READ,WRITE,EXEC} */
-- 
1.7.5.4

