Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457Ab3BMRwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:52:47 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53457 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3BMRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:52:45 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@inktank.com>
Date: Wed, 13 Feb 2013 09:50:52 -0800
Message-Id: <1360777934-5663-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+rAnxMDhGpJ7PsNp/99YJfYJpMhrCoKMM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4425]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 03/85] ceph: Translate inode uid and gid attributes to/from kuids and kgids.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- In fill_inode() transate uids and gids in the initial user namespace
  into kuids and kgids stored in inode->i_uid and inode->i_gid.

- In ceph_setattr() if they have changed convert inode->i_uid and
  inode->i_gid into initial user namespace uids and gids for
  transmission.

Cc: Sage Weil <sage@inktank.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ceph/inode.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2971eaa..40e0787 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -612,8 +612,8 @@ static int fill_inode(struct inode *inode,
 
 	if ((issued & CEPH_CAP_AUTH_EXCL) == 0) {
 		inode->i_mode = le32_to_cpu(info->mode);
-		inode->i_uid = le32_to_cpu(info->uid);
-		inode->i_gid = le32_to_cpu(info->gid);
+		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(info->uid));
+		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(info->gid));
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     inode->i_uid, inode->i_gid);
 	}
@@ -1570,8 +1570,9 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
-			   attr->ia_uid != inode->i_uid) {
-			req->r_args.setattr.uid = cpu_to_le32(attr->ia_uid);
+			   !uid_eq(attr->ia_uid, inode->i_uid)) {
+			req->r_args.setattr.uid = cpu_to_le32(
+				from_kuid(&init_user_ns, attr->ia_uid));
 			mask |= CEPH_SETATTR_UID;
 			release |= CEPH_CAP_AUTH_SHARED;
 		}
@@ -1583,8 +1584,9 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_gid = attr->ia_gid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
-			   attr->ia_gid != inode->i_gid) {
-			req->r_args.setattr.gid = cpu_to_le32(attr->ia_gid);
+			   !gid_eq(attr->ia_gid, inode->i_gid)) {
+			req->r_args.setattr.gid = cpu_to_le32(
+				from_kgid(&init_user_ns, attr->ia_gid));
 			mask |= CEPH_SETATTR_GID;
 			release |= CEPH_CAP_AUTH_SHARED;
 		}
-- 
1.7.5.4

