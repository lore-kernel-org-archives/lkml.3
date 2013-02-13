Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411Ab3BMSQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:16:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59303 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006Ab3BMR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:26 -0800
Message-Id: <1360777934-5663-37-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18VaOrFlO7gV/99abG35QGE0yzWztqxncE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 37/85] gfs2: Use uid_eq and gid_eq where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Where kuid_t values are compared use uid_eq and where kgid_t values
are compared use gid_eq.  This is unfortunately necessary because
of the type safety that keeps someone from accidentally mixing
kuids and kgids with other types.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/acl.c   |    2 +-
 fs/gfs2/inode.c |   19 +++++++++++--------
 fs/gfs2/quota.c |    6 ++++--
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index f850020..f69ac0a 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -237,7 +237,7 @@ static int gfs2_xattr_system_set(struct dentry *dentry, const char *name,
 		return -EINVAL;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+	if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_FOWNER))
 		return -EPERM;
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ce07ce4..bb7c754 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -368,10 +368,11 @@ static void munge_mode_uid_gid(const struct gfs2_inode *dip,
 			       struct inode *inode)
 {
 	if (GFS2_SB(&dip->i_inode)->sd_args.ar_suiddir &&
-	    (dip->i_inode.i_mode & S_ISUID) && dip->i_inode.i_uid) {
+	    (dip->i_inode.i_mode & S_ISUID) &&
+	    !uid_eq(dip->i_inode.i_uid, GLOBAL_ROOT_UID)) {
 		if (S_ISDIR(inode->i_mode))
 			inode->i_mode |= S_ISUID;
-		else if (dip->i_inode.i_uid != current_fsuid())
+		else if (!uid_eq(dip->i_inode.i_uid, current_fsuid()))
 			inode->i_mode &= ~07111;
 		inode->i_uid = dip->i_inode.i_uid;
 	} else
@@ -978,8 +979,8 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		return -EPERM;
 
 	if ((dip->i_inode.i_mode & S_ISVTX) &&
-	    dip->i_inode.i_uid != current_fsuid() &&
-	    ip->i_inode.i_uid != current_fsuid() && !capable(CAP_FOWNER))
+	    !uid_eq(dip->i_inode.i_uid, current_fsuid()) &&
+	    !uid_eq(ip->i_inode.i_uid, current_fsuid()) && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (IS_APPEND(&dip->i_inode))
@@ -1589,16 +1590,17 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	nuid = attr->ia_uid;
 	ngid = attr->ia_gid;
 
-	if (!(attr->ia_valid & ATTR_UID) || ouid == nuid)
+	if (!(attr->ia_valid & ATTR_UID) || uid_eq(ouid, nuid))
 		ouid = nuid = NO_UID_QUOTA_CHANGE;
-	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
+	if (!(attr->ia_valid & ATTR_GID) || gid_eq(ogid, ngid))
 		ogid = ngid = NO_GID_QUOTA_CHANGE;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
 	if (error)
 		return error;
 
-	if (ouid != NO_UID_QUOTA_CHANGE || ogid != NO_GID_QUOTA_CHANGE) {
+	if (!uid_eq(ouid, NO_UID_QUOTA_CHANGE) ||
+	    !gid_eq(ogid, NO_GID_QUOTA_CHANGE)) {
 		error = gfs2_quota_check(ip, nuid, ngid);
 		if (error)
 			goto out_gunlock_q;
@@ -1612,7 +1614,8 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (error)
 		goto out_end_trans;
 
-	if (ouid != NO_UID_QUOTA_CHANGE || ogid != NO_GID_QUOTA_CHANGE) {
+	if (!uid_eq(ouid, NO_UID_QUOTA_CHANGE) ||
+	    !gid_eq(ogid, NO_GID_QUOTA_CHANGE)) {
 		u64 blocks = gfs2_get_inode_blocks(&ip->i_inode);
 		gfs2_quota_change(ip, -blocks, ouid, ogid);
 		gfs2_quota_change(ip, blocks, nuid, ngid);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 87f2740..afd2e5d 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -525,7 +525,8 @@ int gfs2_quota_hold(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 	ip->i_res->rs_qa_qd_num++;
 	qd++;
 
-	if (uid != NO_UID_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
+	if (!uid_eq(uid, NO_UID_QUOTA_CHANGE) &&
+	    !uid_eq(uid, ip->i_inode.i_uid)) {
 		error = qdsb_get(sdp, make_kqid_uid(uid), qd);
 		if (error)
 			goto out;
@@ -533,7 +534,8 @@ int gfs2_quota_hold(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 		qd++;
 	}
 
-	if (gid != NO_GID_QUOTA_CHANGE && gid != ip->i_inode.i_gid) {
+	if (!gid_eq(gid, NO_GID_QUOTA_CHANGE) &&
+	    !gid_eq(gid, ip->i_inode.i_gid)) {
 		error = qdsb_get(sdp, make_kqid_gid(gid), qd);
 		if (error)
 			goto out;
-- 
1.7.5.4

