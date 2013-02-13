Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3BMRw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:52:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46461 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3BMRwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:52:53 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@inktank.com>
Date: Wed, 13 Feb 2013 09:50:54 -0800
Message-Id: <1360777934-5663-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/9yj//HC2QDbrk+Hrfis3pzZ57fKvrGrE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3277]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 05/85] ceph: Convert kuids and kgids before printing them.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Before printing kuid and kgids values convert them into
the initial user namespace.

Cc: Sage Weil <sage@inktank.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ceph/caps.c  |    3 ++-
 fs/ceph/inode.c |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 39eb466..ae2be69 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2362,7 +2362,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
 		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
-		     inode->i_uid, inode->i_gid);
+		     from_kuid(&init_user_ns, inode->i_uid),
+		     from_kgid(&init_user_ns, inode->i_gid));
 	}
 
 	if ((issued & CEPH_CAP_LINK_EXCL) == 0)
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 40e0787..d45895f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -615,7 +615,8 @@ static int fill_inode(struct inode *inode,
 		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(info->uid));
 		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(info->gid));
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
-		     inode->i_uid, inode->i_gid);
+		     from_kuid(&init_user_ns, inode->i_uid),
+		     from_kgid(&init_user_ns, inode->i_gid));
 	}
 
 	if ((issued & CEPH_CAP_LINK_EXCL) == 0)
@@ -1565,7 +1566,8 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (ia_valid & ATTR_UID) {
 		dout("setattr %p uid %d -> %d\n", inode,
-		     inode->i_uid, attr->ia_uid);
+		     from_kuid(&init_user_ns, inode->i_uid),
+		     from_kuid(&init_user_ns, attr->ia_uid));
 		if (issued & CEPH_CAP_AUTH_EXCL) {
 			inode->i_uid = attr->ia_uid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
@@ -1579,7 +1581,8 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 	if (ia_valid & ATTR_GID) {
 		dout("setattr %p gid %d -> %d\n", inode,
-		     inode->i_gid, attr->ia_gid);
+		     from_kgid(&init_user_ns, inode->i_gid),
+		     from_kgid(&init_user_ns, attr->ia_gid));
 		if (issued & CEPH_CAP_AUTH_EXCL) {
 			inode->i_gid = attr->ia_gid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
-- 
1.7.5.4

