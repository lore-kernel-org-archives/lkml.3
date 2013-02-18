Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3BRBLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:11:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54417 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab3BRBL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:29 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:10:54 -0800
Message-Id: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87txpaph4n.fsf@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
X-XM-AID: U2FsdGVkX190gJvGvUtjpquqW4Dtsylw932Bhr9r2Ek=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1678]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 01/16] xfs: Convert uids and gids in xfs acls to/from kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- When reading from disk convert on disk uids and gids to kuids and kgids
- When writing to the disk convert in memory kuids and kgids to uids and gids.
- Don't write e_id as that field only exists when user namespace
  support is disabled.
- Use uid_eq when testing to see if current_fsuid() is allowed to set the
  acls for a file.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_acl.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 1d32f1d..ca2aade 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -64,14 +64,17 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
+			acl_e->e_uid = make_kuid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
+			break;
 		case ACL_GROUP:
-			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			acl_e->e_gid = make_kgid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			acl_e->e_id = ACL_UNDEFINED_ID;
 			break;
 		default:
 			goto fail;
@@ -97,8 +100,20 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		acl_e = &acl->a_entries[i];
 
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
-		ace->ae_id = cpu_to_be32(acl_e->e_id);
 		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
+		case ACL_USER:
+			ace->ae_id = cpu_to_be32(
+				from_kuid(&init_user_ns, acl_e->e_uid));
+			break;
+		case ACL_GROUP:
+			ace->ae_id = cpu_to_be32(
+				from_kgid(&init_user_ns, acl_e->e_gid));
+			break;
+		default:
+			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
+			break;
+		}
 	}
 }
 
@@ -355,7 +370,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		return -EINVAL;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (!value)
-- 
1.7.5.4

