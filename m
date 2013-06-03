Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3FCS7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab3FCS7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:59:14 -0400
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 1/2] selinux: merge selinux_inode_permission and inode_has_perm
Date: Mon,  3 Jun 2013 14:59:00 -0400
Message-Id: <1370285941-18367-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

selinux_inode_permission had some heavy lifting done to make it more
performance polite.  But it still does largely the same thing as
inode_has_perm.  So move that work into inode_has_perm and call
inode_has_perm from selinux_inode_permission.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/selinux/hooks.c | 92 ++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 50 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5c6f2cd..cfecb52 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1494,17 +1494,41 @@ static int task_has_system(struct task_struct *tsk,
 			    SECCLASS_SYSTEM, perms, NULL);
 }
 
+static noinline int audit_inode_permission(struct inode *inode,
+					   struct common_audit_data *adp,
+					   u32 perms, u32 audited, u32 denied,
+					   unsigned flags)
+{
+	struct common_audit_data ad;
+	struct inode_security_struct *isec = inode->i_security;
+	int rc;
+
+	if (!adp) {
+		ad.type = LSM_AUDIT_DATA_INODE;
+		ad.u.inode = inode;
+		adp = &ad;
+	}
+
+	rc = slow_avc_audit(current_sid(), isec->sid, isec->sclass, perms,
+			    audited, denied, adp, flags);
+	if (rc)
+		return rc;
+	return 0;
+}
+
 /* Check whether a task has a particular permission to an inode.
    The 'adp' parameter is optional and allows other audit
    data to be passed (e.g. the dentry). */
 static int inode_has_perm(const struct cred *cred,
 			  struct inode *inode,
-			  u32 perms,
+			  u32 perms, u32 dontaudit,
 			  struct common_audit_data *adp,
 			  unsigned flags)
 {
 	struct inode_security_struct *isec;
-	u32 sid;
+	struct av_decision avd;
+	u32 sid, denied, audited;
+	int rc, rc2;
 
 	validate_creds(cred);
 
@@ -1514,6 +1538,14 @@ static int inode_has_perm(const struct cred *cred,
 	sid = cred_sid(cred);
 	isec = inode->i_security;
 
+	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
+	audited = avc_audit_required(perms, &avd, rc, dontaudit, &denied);
+	if (likely(!audited))
+		return rc;
+
+	rc2 = audit_inode_permission(inode, adp, perms, audited, denied, flags);
+	if (rc2)
+		return rc2;
 	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
 
@@ -1529,7 +1561,7 @@ static inline int dentry_has_perm(const struct cred *cred,
 
 	ad.type = LSM_AUDIT_DATA_DENTRY;
 	ad.u.dentry = dentry;
-	return inode_has_perm(cred, inode, av, &ad, 0);
+	return inode_has_perm(cred, inode, av, 0, &ad, 0);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -1544,7 +1576,7 @@ static inline int path_has_perm(const struct cred *cred,
 
 	ad.type = LSM_AUDIT_DATA_PATH;
 	ad.u.path = *path;
-	return inode_has_perm(cred, inode, av, &ad, 0);
+	return inode_has_perm(cred, inode, av, 0, &ad, 0);
 }
 
 /* Check whether a task can use an open file descriptor to
@@ -1580,7 +1612,7 @@ static int file_has_perm(const struct cred *cred,
 	/* av is zero if only checking access to the descriptor. */
 	rc = 0;
 	if (av)
-		rc = inode_has_perm(cred, inode, av, &ad, 0);
+		rc = inode_has_perm(cred, inode, av, 0, &ad, 0);
 
 out:
 	return rc;
@@ -2635,64 +2667,24 @@ static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *na
 	return dentry_has_perm(cred, dentry, FILE__READ);
 }
 
-static noinline int audit_inode_permission(struct inode *inode,
-					   u32 perms, u32 audited, u32 denied,
-					   unsigned flags)
-{
-	struct common_audit_data ad;
-	struct inode_security_struct *isec = inode->i_security;
-	int rc;
-
-	ad.type = LSM_AUDIT_DATA_INODE;
-	ad.u.inode = inode;
-
-	rc = slow_avc_audit(current_sid(), isec->sid, isec->sclass, perms,
-			    audited, denied, &ad, flags);
-	if (rc)
-		return rc;
-	return 0;
-}
-
 static int selinux_inode_permission(struct inode *inode, int mask)
 {
 	const struct cred *cred = current_cred();
-	u32 perms;
-	bool from_access;
+	u32 perms, dontaudit = 0;
 	unsigned flags = mask & MAY_NOT_BLOCK;
-	struct inode_security_struct *isec;
-	u32 sid;
-	struct av_decision avd;
-	int rc, rc2;
-	u32 audited, denied;
 
-	from_access = mask & MAY_ACCESS;
+	if (mask & MAY_ACCESS)
+		dontaudit = FILE__AUDIT_ACCESS;
+
 	mask &= (MAY_READ|MAY_WRITE|MAY_EXEC|MAY_APPEND);
 
 	/* No permission to check.  Existence test. */
 	if (!mask)
 		return 0;
 
-	validate_creds(cred);
-
-	if (unlikely(IS_PRIVATE(inode)))
-		return 0;
-
 	perms = file_mask_to_av(inode->i_mode, mask);
 
-	sid = cred_sid(cred);
-	isec = inode->i_security;
-
-	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
-	audited = avc_audit_required(perms, &avd, rc,
-				     from_access ? FILE__AUDIT_ACCESS : 0,
-				     &denied);
-	if (likely(!audited))
-		return rc;
-
-	rc2 = audit_inode_permission(inode, perms, audited, denied, flags);
-	if (rc2)
-		return rc2;
-	return rc;
+	return inode_has_perm(cred, inode, perms, dontaudit, NULL, flags);
 }
 
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
-- 
1.8.2.1

