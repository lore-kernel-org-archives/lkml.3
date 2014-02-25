Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBYJjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:39:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34146 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:39:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
Date: Tue, 25 Feb 2014 01:38:58 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87zjlf4jm5.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+hte4HLqamZVCv8xcgOrroOf2dFbz4utI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4989]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 07/12] vfs: Lazily remove mounts on unlinked files and directories.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the introduction of mount namespaces and bind mounts it became
possible to access files and directories that on some paths are mount
points but are not mount points on other paths.  It is very confusing
when rm -rf somedir returns -EBUSY simply because somedir is mounted
somewhere else.  With the addition of user namespaces allowing
unprivileged mounts this condition has gone from annoying to allowing
a DOS attack on other users in the system.

The possibility for mischief is removed by updating the vfs to support
rename, unlink and rmdir on a dentry that is a mountpoint and by
lazily unmounting mountpoints on deleted dentries.

In particular this change allows rename, unlink and rmdir system calls
on a dentry without a mountpoint in the current mount namespace to
succeed, and it allows rename, unlink, and rmdir performed on a
distributed filesystem to update the vfs cache even if when there is a
mount in some namespace on the original dentry.

There are two common patterns of maintaining mounts: Mounts on trusted
paths with the parent directory of the mount point and all ancestory
directories up to / owned by root and modifiable only by root
(i.e. /media/xxx, /dev, /dev/pts, /proc, /sys, /sys/fs/cgroup/{cpu,
cpuacct, ...}, /usr, /usr/local).  Mounts on unprivileged directories
maintained by fusermount.

In the case of mounts in trusted directories owned by root and
modifiable only by root the current parent directory permissions are
sufficient to ensure a mount point on a trusted path is not removed
or renamed by anyone other than root, even if there is a context
where the there are no mount points to prevent this.

In the case of mounts in directories owned by less privileged users
races with users modifying the path of a mount point are already a
danger.  fusermount already uses a combination of chdir,
/proc/<pid>/fd/NNN, and UMOUNT_NOFOLLOW to prevent these races.  The
removable of global rename, unlink, and rmdir protection really adds
nothing new to consider only a widening of the attack window, and
fusermount is already safe against unprivileged users modifying the
directory simultaneously.

In principle for perfect userspace programs returning -EBUSY for
unlink, rmdir, and rename of dentires that have mounts in the local
namespace is actually unnecessary.  Unfortunately not all userspace
programs are perfect so retaining -EBUSY for unlink, rmdir and rename
of dentries that have mounts in the current mount namespace plays an
important role of maintaining consistency with historical behavior and
making imperfect userspace applications hard to exploit.

v2: Remove spurious old_dentry.
v3: Optimized shrink_submounts_and_drop
    Removed unsued afs label
v4: Simplified the changes to check_submounts_and_drop
    Do not rename check_submounts_and_drop shrink_submounts_and_drop
    Document what why we need atomicity in check_submounts_and_drop
    Rely on the parent inode mutex to make d_revalidate and d_invalidate
    an atomic unit.
v5: Refcount the mountpoint to detach in case of simultaneous
    renames.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/dcache.c |   60 ++++++++++++++++++++++++++++++++--------------------------
 fs/namei.c  |   18 ++++++++--------
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b0add629f5fe..27585b1dd6f1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1374,36 +1374,39 @@ void shrink_dcache_for_umount(struct super_block *sb)
 	}
 }
 
-static enum d_walk_ret check_and_collect(void *_data, struct dentry *dentry)
+struct detach_data {
+	struct select_data select;
+	struct dentry *mountpoint;
+};
+static enum d_walk_ret detach_and_collect(void *_data, struct dentry *dentry)
 {
-	struct select_data *data = _data;
+	struct detach_data *data = _data;
 
 	if (d_mountpoint(dentry)) {
-		data->found = -EBUSY;
+		__dget_dlock(dentry);
+		data->mountpoint = dentry;
 		return D_WALK_QUIT;
 	}
 
-	return select_collect(_data, dentry);
+	return select_collect(&data->select, dentry);
 }
 
 static void check_and_drop(void *_data)
 {
-	struct select_data *data = _data;
+	struct detach_data *data = _data;
 
-	if (d_mountpoint(data->start))
-		data->found = -EBUSY;
-	if (!data->found)
-		__d_drop(data->start);
+	if (!data->mountpoint && !data->select.found)
+		__d_drop(data->select.start);
 }
 
 /**
- * check_submounts_and_drop - prune dcache, check for submounts and drop
+ * check_submounts_and_drop - detach submounts, prune dcache, and drop
  *
- * All done as a single atomic operation relative to has_unlinked_ancestor().
- * Returns 0 if successfully unhashed @parent.  If there were submounts then
- * return -EBUSY.
+ * The final d_drop is done as an atomic operation relative to
+ * rename_lock ensuring there are no races with d_set_mounted.  This
+ * ensures there are no unhashed dentries on the path to a mountpoint.
  *
- * @dentry: dentry to prune and drop
+ * @dentry: dentry to detach, prune and drop
  */
 int check_submounts_and_drop(struct dentry *dentry)
 {
@@ -1416,19 +1419,24 @@ int check_submounts_and_drop(struct dentry *dentry)
 	}
 
 	for (;;) {
-		struct select_data data;
+		struct detach_data data;
 
-		INIT_LIST_HEAD(&data.dispose);
-		data.start = dentry;
-		data.found = 0;
+		data.mountpoint = NULL;
+		INIT_LIST_HEAD(&data.select.dispose);
+		data.select.start = dentry;
+		data.select.found = 0;
 
-		d_walk(dentry, &data, check_and_collect, check_and_drop);
-		ret = data.found;
+		d_walk(dentry, &data, detach_and_collect, check_and_drop);
 
-		if (!list_empty(&data.dispose))
-			shrink_dentry_list(&data.dispose);
+		if (data.select.found)
+			shrink_dentry_list(&data.select.dispose);
 
-		if (ret <= 0)
+		if (data.mountpoint) {
+			detach_mounts(data.mountpoint);
+			dput(data.mountpoint);
+		}
+
+		if (!data.mountpoint && !data.select.found)
 			break;
 
 		cond_resched();
@@ -2640,10 +2648,8 @@ static struct dentry *__d_unalias(struct inode *inode,
 		goto out_err;
 	m2 = &alias->d_parent->d_inode->i_mutex;
 out_unalias:
-	if (likely(!d_mountpoint(alias))) {
-		__d_move(alias, dentry);
-		ret = alias;
-	}
+	__d_move(alias, dentry);
+	ret = alias;
 out_err:
 	spin_unlock(&inode->i_lock);
 	if (m2)
diff --git a/fs/namei.c b/fs/namei.c
index 4e6fe16ef488..3fca30cd448b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3509,8 +3509,6 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 	error = -EBUSY;
 	if (is_local_mountpoint(dentry))
 		goto out;
-	if (d_mountpoint(dentry))
-		goto out;
 
 	error = security_inode_rmdir(dir, dentry);
 	if (error)
@@ -3523,6 +3521,7 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	dentry->d_inode->i_flags |= S_DEAD;
 	dont_mount(dentry);
+	detach_mounts(dentry);
 
 out:
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -3624,7 +3623,7 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode **delegate
 		return -EPERM;
 
 	mutex_lock(&target->i_mutex);
-	if (is_local_mountpoint(dentry) || d_mountpoint(dentry))
+	if (is_local_mountpoint(dentry))
 		error = -EBUSY;
 	else {
 		error = security_inode_unlink(dir, dentry);
@@ -3633,8 +3632,10 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode **delegate
 			if (error)
 				goto out;
 			error = dir->i_op->unlink(dir, dentry);
-			if (!error)
+			if (!error) {
 				dont_mount(dentry);
+				detach_mounts(dentry);
+			}
 		}
 	}
 out:
@@ -4005,8 +4006,6 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	error = -EBUSY;
 	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
 		goto out;
-	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
-		goto out;
 
 	error = -EMLINK;
 	if (max_links && !target && new_dir != old_dir &&
@@ -4022,6 +4021,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (target) {
 		target->i_flags |= S_DEAD;
 		dont_mount(new_dentry);
+		detach_mounts(new_dentry);
 	}
 out:
 	if (target)
@@ -4051,8 +4051,6 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
 	error = -EBUSY;
 	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
 		goto out;
-	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
-		goto out;
 
 	error = try_break_deleg(source, delegated_inode);
 	if (error)
@@ -4066,8 +4064,10 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
 	if (error)
 		goto out;
 
-	if (target)
+	if (target) {
 		dont_mount(new_dentry);
+		detach_mounts(new_dentry);
+	}
 	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
 		d_move(old_dentry, new_dentry);
 out:
-- 
1.7.5.4

