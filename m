Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269Ab3BMSDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:03:08 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34370 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219Ab3BMSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:56 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:07 -0800
Message-Id: <1360777934-5663-78-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19tMqFKCWrMVzn4evJdJvnsJq7FyULkCc8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 78/85] cifs: Modify struct cifs_unix_set_info_args to hold a kuid_t and a kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Use INVALID_UID and INVALID_GID instead of NO_CHANGE_64 to indicate
the value should not be changed.

In cifs_fill_unix_set_info convert from kuids and kgids into uids and
gids that will fit in FILE_UNIX_BASIC_INFO.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsproto.h |    4 ++--
 fs/cifs/cifssmb.c   |   10 ++++++++--
 fs/cifs/dir.c       |   18 +++++++++---------
 fs/cifs/file.c      |    4 ++--
 fs/cifs/inode.c     |   14 +++++++-------
 5 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index feb9b6e..f450f06 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -305,8 +305,8 @@ struct cifs_unix_set_info_args {
 	__u64	atime;
 	__u64	mtime;
 	__u64	mode;
-	__u64	uid;
-	__u64	gid;
+	kuid_t	uid;
+	kgid_t	gid;
 	dev_t	device;
 };
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 76d0d29..00e12f2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5819,8 +5819,14 @@ static void
 cifs_fill_unix_set_info(FILE_UNIX_BASIC_INFO *data_offset,
 			const struct cifs_unix_set_info_args *args)
 {
+	u64 uid = NO_CHANGE_64, gid = NO_CHANGE_64;
 	u64 mode = args->mode;
 
+	if (uid_valid(args->uid))
+		uid = from_kuid(&init_user_ns, args->uid);
+	if (gid_valid(args->gid))
+		gid = from_kgid(&init_user_ns, args->gid);
+
 	/*
 	 * Samba server ignores set of file size to zero due to bugs in some
 	 * older clients, but we should be precise - we use SetFileSize to
@@ -5833,8 +5839,8 @@ cifs_fill_unix_set_info(FILE_UNIX_BASIC_INFO *data_offset,
 	data_offset->LastStatusChange = cpu_to_le64(args->ctime);
 	data_offset->LastAccessTime = cpu_to_le64(args->atime);
 	data_offset->LastModificationTime = cpu_to_le64(args->mtime);
-	data_offset->Uid = cpu_to_le64(args->uid);
-	data_offset->Gid = cpu_to_le64(args->gid);
+	data_offset->Uid = cpu_to_le64(uid);
+	data_offset->Gid = cpu_to_le64(gid);
 	/* better to leave device as zero when it is  */
 	data_offset->DevMajor = cpu_to_le64(MAJOR(args->device));
 	data_offset->DevMinor = cpu_to_le64(MINOR(args->device));
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 8719bbe..1cd0162 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -342,14 +342,14 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 
 		*created |= FILE_CREATED;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			args.uid = (__u64) current_fsuid();
+			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
-				args.gid = (__u64) inode->i_gid;
+				args.gid = inode->i_gid;
 			else
-				args.gid = (__u64) current_fsgid();
+				args.gid = current_fsgid();
 		} else {
-			args.uid = NO_CHANGE_64;
-			args.gid = NO_CHANGE_64;
+			args.uid = INVALID_UID; /* no change */
+			args.gid = INVALID_GID; /* no change */
 		}
 		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid->netfid,
 				       current->tgid);
@@ -588,11 +588,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 			.device	= device_number,
 		};
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			args.uid = (__u64) current_fsuid();
-			args.gid = (__u64) current_fsgid();
+			args.uid = current_fsuid();
+			args.gid = current_fsgid();
 		} else {
-			args.uid = NO_CHANGE_64;
-			args.gid = NO_CHANGE_64;
+			args.uid = INVALID_UID; /* no change */
+			args.gid = INVALID_GID; /* no change */
 		}
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, &args,
 					    cifs_sb->local_nls,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0a6677b..b9baf5f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -487,8 +487,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		 */
 		struct cifs_unix_set_info_args args = {
 			.mode	= inode->i_mode,
-			.uid	= NO_CHANGE_64,
-			.gid	= NO_CHANGE_64,
+			.uid	= INVALID_UID, /* no change */
+			.gid	= INVALID_GID, /* no change */
 			.ctime	= NO_CHANGE_64,
 			.atime	= NO_CHANGE_64,
 			.mtime	= NO_CHANGE_64,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index d4cf750..7376439 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1249,14 +1249,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.device	= 0,
 		};
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			args.uid = (__u64)current_fsuid();
+			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
-				args.gid = (__u64)parent->i_gid;
+				args.gid = parent->i_gid;
 			else
-				args.gid = (__u64)current_fsgid();
+				args.gid = current_fsgid();
 		} else {
-			args.uid = NO_CHANGE_64;
-			args.gid = NO_CHANGE_64;
+			args.uid = INVALID_UID; /* no change */
+			args.gid = INVALID_GID; /* no change */
 		}
 		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
 				       cifs_sb->local_nls,
@@ -2017,12 +2017,12 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_UID)
 		args->uid = attrs->ia_uid;
 	else
-		args->uid = NO_CHANGE_64;
+		args->uid = INVALID_UID; /* no change */
 
 	if (attrs->ia_valid & ATTR_GID)
 		args->gid = attrs->ia_gid;
 	else
-		args->gid = NO_CHANGE_64;
+		args->gid = INVALID_GID; /* no change */
 
 	if (attrs->ia_valid & ATTR_ATIME)
 		args->atime = cifs_UnixTimeToNT(attrs->ia_atime);
-- 
1.7.5.4

