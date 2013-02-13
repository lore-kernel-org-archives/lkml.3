Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403Ab3BMSOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:14:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59334 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965015Ab3BMR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:56 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 09:51:14 -0800
Message-Id: <1360777934-5663-25-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19sxc2YBugJTarBhaqqkOjKdDfX6Ta1V/4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0622]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 25/85] ocfs2: Compare kuids and kgids using uid_eq and gid_eq
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/file.c         |    8 ++++----
 fs/ocfs2/refcounttree.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8ee9332..0a2924a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1175,14 +1175,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
-	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
+	if ((attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
+	    (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
 		/*
 		 * Gather pointers to quota structures so that allocation /
 		 * freeing of quota structures happens here and not inside
 		 * dquot_transfer() where we have problems with lock ordering
 		 */
-		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
+		if (attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
 			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
@@ -1191,7 +1191,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 				goto bail_unlock;
 			}
 		}
-		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
+		if (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
 			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 30a0550..934a4ac 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4407,7 +4407,7 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
 	 * rights to do so.
 	 */
 	if (preserve) {
-		if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
+		if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_CHOWN))
 			return -EPERM;
 		if (!in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
 			return -EPERM;
-- 
1.7.5.4

