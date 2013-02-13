Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036Ab3BMSDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:03:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60199 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965203Ab3BMSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:53 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:12 -0800
Message-Id: <1360777934-5663-83-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+h9Z9Fn9wgn+UtUcZOx73RBn2yfVnZwzU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0124]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 83/85] cifs: Convert struct cifs_sb_info to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifs_fs_sb.h |    8 ++++----
 fs/cifs/cifsfs.c     |   14 ++++++++++----
 fs/cifs/connect.c    |    2 +-
 fs/cifs/misc.c       |    2 +-
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index c865bfd..37e4a72 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -55,10 +55,10 @@ struct cifs_sb_info {
 	unsigned int wsize;
 	unsigned long actimeo; /* attribute cache timeout (jiffies) */
 	atomic_t active;
-	uid_t	mnt_uid;
-	gid_t	mnt_gid;
-	uid_t	mnt_backupuid;
-	gid_t	mnt_backupgid;
+	kuid_t	mnt_uid;
+	kgid_t	mnt_gid;
+	kuid_t	mnt_backupuid;
+	kgid_t	mnt_backupgid;
 	umode_t	mnt_file_mode;
 	umode_t	mnt_dir_mode;
 	unsigned int mnt_cifs_flags;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f653835..1759073 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -376,13 +376,15 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 				   (int)(srcaddr->sa_family));
 	}
 
-	seq_printf(s, ",uid=%u", cifs_sb->mnt_uid);
+	seq_printf(s, ",uid=%u",
+		   from_kuid_munged(&init_user_ns, cifs_sb->mnt_uid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_printf(s, ",forceuid");
 	else
 		seq_printf(s, ",noforceuid");
 
-	seq_printf(s, ",gid=%u", cifs_sb->mnt_gid);
+	seq_printf(s, ",gid=%u",
+		   from_kgid_munged(&init_user_ns, cifs_sb->mnt_gid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
 		seq_printf(s, ",forcegid");
 	else
@@ -437,9 +439,13 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
 		seq_printf(s, ",noperm");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
-		seq_printf(s, ",backupuid=%u", cifs_sb->mnt_backupuid);
+		seq_printf(s, ",backupuid=%u",
+			   from_kuid_munged(&init_user_ns,
+					    cifs_sb->mnt_backupuid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
-		seq_printf(s, ",backupgid=%u", cifs_sb->mnt_backupgid);
+		seq_printf(s, ",backupgid=%u",
+			   from_kgid_munged(&init_user_ns,
+					    cifs_sb->mnt_backupgid));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->wsize);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9bd13a7..01279b8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2743,7 +2743,7 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	if (new->rsize && new->rsize < old->rsize)
 		return 0;
 
-	if (old->mnt_uid != new->mnt_uid || old->mnt_gid != new->mnt_gid)
+	if (!uid_eq(old->mnt_uid, new->mnt_uid) || !gid_eq(old->mnt_gid, new->mnt_gid))
 		return 0;
 
 	if (old->mnt_file_mode != new->mnt_file_mode ||
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3a00c0d..1b15bf8 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -569,7 +569,7 @@ bool
 backup_cred(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
-		if (cifs_sb->mnt_backupuid == current_fsuid())
+		if (uid_eq(cifs_sb->mnt_backupuid, current_fsuid()))
 			return true;
 	}
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
-- 
1.7.5.4

