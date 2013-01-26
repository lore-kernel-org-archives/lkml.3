Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3AZCX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:23:26 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54342 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AZCXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:23:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com>
Date: Fri, 25 Jan 2013 18:23:12 -0800
In-Reply-To: <87ehh8it9s.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 25 Jan 2013 18:15:43 -0800")
Message-ID: <87obgchecv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19d8rViN1c7z6Xc3V4aJ3coIF1fh42xqvc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0041]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 4/6] userns: Allow the userns root to mount of devpts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- The context in which devpts is mounted has no effect on the creation
  of ptys as the /dev/ptmx interface has been used by unprivileged
  users for many years.

- Only support unprivileged mounts in combination with the newinstance
  option to ensure that mounting of /dev/pts in a user namespace will
  not allow the options of an existing mount of devpts to be modified.

- Create /dev/pts/ptmx as the root user in the user namespace that
  mounts devpts so that it's permissions to be changed.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/devpts/inode.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 472e6be..073d30b 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -243,6 +243,13 @@ static int mknod_ptmx(struct super_block *sb)
 	struct dentry *root = sb->s_root;
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 	struct pts_mount_opts *opts = &fsi->mount_opts;
+	kuid_t root_uid;
+	kgid_t root_gid;
+
+	root_uid = make_kuid(current_user_ns(), 0);
+	root_gid = make_kgid(current_user_ns(), 0);
+	if (!uid_valid(root_uid) || !gid_valid(root_gid))
+		return -EINVAL;
 
 	mutex_lock(&root->d_inode->i_mutex);
 
@@ -273,6 +280,8 @@ static int mknod_ptmx(struct super_block *sb)
 
 	mode = S_IFCHR|opts->ptmxmode;
 	init_special_inode(inode, mode, MKDEV(TTYAUX_MAJOR, 2));
+	inode->i_uid = root_uid;
+	inode->i_gid = root_gid;
 
 	d_add(dentry, inode);
 
@@ -438,6 +447,12 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
 	if (error)
 		return ERR_PTR(error);
 
+	/* Require newinstance for all user namespace mounts to ensure
+	 * the mount options are not changed.
+	 */
+	if ((current_user_ns() != &init_user_ns) && !opts.newinstance)
+		return ERR_PTR(-EINVAL);
+
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, flags, NULL);
 	else
@@ -491,6 +506,9 @@ static struct file_system_type devpts_fs_type = {
 	.name		= "devpts",
 	.mount		= devpts_mount,
 	.kill_sb	= devpts_kill_sb,
+#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
+#endif
 };
 
 /*
-- 
1.7.5.4

