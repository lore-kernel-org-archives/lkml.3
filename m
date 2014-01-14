Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaANUyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:54:55 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56759 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaANUyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:54:51 -0500
X-Nat-Received: from [202.181.97.72]:49233 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389732815.16738
To: miklos@szeredi.hu
Cc: john.johansen@canonical.com, mszeredi@suse.cz,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net
Subject: Re: [PATCH 00/11] cross rename v3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
	<201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>
	<CAJfpegs6kzkmJ8NFCuwEBGFgW5toM4X9RC+8JzJPX1V1rMmsow@mail.gmail.com>
	<201401142203.IDB17653.LHVJtFFOSOMQFO@I-love.SAKURA.ne.jp>
	<52D599CC.5050300@canonical.com>
In-Reply-To: <52D599CC.5050300@canonical.com>
Message-Id: <201401150553.CFJ12414.VLOtFOSOQFHJMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 15 Jan 2014 05:53:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14012014 #7326873, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> On 01/14/2014 05:03 AM, Tetsuo Handa wrote:
> > Miklos Szeredi wrote:
> >> On Mon, Jan 13, 2014 at 11:03 PM, Tetsuo Handa
> >> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>> Miklos Szeredi wrote:
> >>>> Cross rename (A, B) is equivalent to plain rename(A, B) + plain rename
> >>>> (B, A) done as a single atomic operation.  If security module allows
> >>>> both then cross rename is allowed.  If at least one is denied then the
> >>>> cross rename is denied.
> >>>
> >>> Yes, the functionality itself is fine. The problem is how LSM users check
> >>> their permissions for the functionality.
> >>>
> >>>>
> >>>> This is prepared for in "[PATCH 06/11] security: add flags to rename
> >>>> hooks" and actually done in "[PATCH 07/11] vfs: add cross-rename".
> >>>>
> >>>> Security people are free to implement a explicit security check for
> >>>> cross rename, but I don't think that is in the scope of this patchset.
> >>>>
> >>> I don't know how their permissions are checked, but I think that
> >>> swapping /A/B and /C/D should check not only
> >>>
> >>>   Remove a name from directory A
> >>>   Add a name to directory C
> >>>
> >>> but also
> >>>
> >>>   Add a name to directory A
> >>>   Remove a name from directory C
> >>>
> >>> using their security labels.
> >>>
> >>> Without making changes to security/*/ directory, SELinux/SMACK/TOMOYO/AppArmor
> >>> might fail to check the latter permissions.
> >>
> >> Those permissions will be checked.   Please see security/security.c in
> >> patch 07/11 of the series.
> >>
> > Oh, I see. But I think that 07/11 is wasteful for security_path_rename() users.
> > Why bother to re-calculate /A/B and /C/D using d_absolute_path()?
> > 
> > I prefer flags argument passed to tomoyo_path_rename(). Untested patch follows.
> > John, what about AppArmor?
> 
> Right policy wise it doesn't make a difference but not having to re-calculate
> the paths would be more efficient.
> 
> I'd re-factor the apparmor bit of the patch differently so that the paths aren't
> recomputed, what is in the patch looks like it should work. In fact I would want
> to do the apparmor refactor as a separate patch so that the internal changes
> needed to take advantage of the LSM change are separate from the LSM change
> it self.
> 
> I've only given the patch a quick once over and not tested it yet, but it looks
> good, so far.

I see. And security_inode_rename() should also receive the flags argument, for
smack_inode_rename() needs no change as it checks MAY_READWRITE permission on
both inodes.

I think below change is fine for SELinux/SMACK/Capability. TOMOYO and AppArmor
want separate patch for RENAME_EXCHANGE handling.

Miklos, can you insert below change between a patch which defines
RENAME_EXCHANGE and a patch which implements RENAME_EXCHANGE functionality?

diff --git a/include/linux/security.h b/include/linux/security.h
index 95cfccc..dbd05ca 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -446,6 +446,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@old_dentry contains the dentry structure of the old link.
  *	@new_dir contains the inode structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@flags contains rename flags.
  *	Return 0 if permission is granted.
  * @path_rename:
  *	Check for permission to rename a file or directory.
@@ -453,6 +454,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@old_dentry contains the dentry structure of the old link.
  *	@new_dir contains the path structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@flags contains rename flags.
  *	Return 0 if permission is granted.
  * @path_chmod:
  *	Check for permission to change DAC's permission of a file or directory.
@@ -1491,7 +1493,8 @@ struct security_operations {
 	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
-			    struct path *new_dir, struct dentry *new_dentry);
+			    struct path *new_dir, struct dentry *new_dentry,
+			    unsigned int flags);
 	int (*path_chmod) (struct path *path, umode_t mode);
 	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
 	int (*path_chroot) (struct path *path);
@@ -1514,7 +1517,8 @@ struct security_operations {
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    umode_t mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
-			     struct inode *new_dir, struct dentry *new_dentry);
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask);
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 4257b7e..2afa7c5 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -315,7 +315,8 @@ static int apparmor_path_link(struct dentry *old_dentry, struct path *new_dir,
 }
 
 static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
-				struct path *new_dir, struct dentry *new_dentry)
+				struct path *new_dir, struct dentry *new_dentry,
+				unsigned int flags)
 {
 	struct aa_profile *profile;
 	int error = 0;
diff --git a/security/capability.c b/security/capability.c
index 8b4f24a..ab2f231 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -176,7 +176,8 @@ static int cap_inode_mknod(struct inode *inode, struct dentry *dentry,
 }
 
 static int cap_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-			    struct inode *new_inode, struct dentry *new_dentry)
+			    struct inode *new_inode, struct dentry *new_dentry,
+			    unsigned int flags)
 {
 	return 0;
 }
@@ -280,7 +281,8 @@ static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
 }
 
 static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
-			   struct path *new_path, struct dentry *new_dentry)
+			   struct path *new_path, struct dentry *new_dentry,
+			   unsigned int flags)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 3dd2258..f90ac9b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -440,15 +440,8 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
 
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->path_rename(new_dir, new_dentry,
-						    old_dir, old_dentry);
-		if (err)
-			return err;
-	}
-
 	return security_ops->path_rename(old_dir, old_dentry, new_dir,
-					 new_dentry);
+					 new_dentry, flags);
 }
 EXPORT_SYMBOL(security_path_rename);
 
@@ -540,15 +533,8 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
 
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->inode_rename(new_dir, new_dentry,
-						     old_dir, old_dentry);
-		if (err)
-			return err;
-	}
-
 	return security_ops->inode_rename(old_dir, old_dentry,
-					   new_dir, new_dentry);
+					  new_dir, new_dentry, flags);
 }
 
 int security_inode_readlink(struct dentry *dentry)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3219560..fffd458 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2714,9 +2714,13 @@ static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t
 }
 
 static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-				struct inode *new_inode, struct dentry *new_dentry)
+				struct inode *new_inode, struct dentry *new_dentry,
+				unsigned int flags)
 {
-	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	int err = may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	if (!err && (flags & RENAME_EXCHANGE))
+		err = may_rename(new_inode, new_dentry, old_inode, old_dentry);
+	return err;
 }
 
 static int selinux_inode_readlink(struct dentry *dentry)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d814e35..623fce6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -697,6 +697,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
  * @old_dentry: unused
  * @new_inode: the new directory
  * @new_dentry: unused
+ * @flags:     rename flags
  *
  * Read and write access is required on both the old and
  * new directories.
@@ -706,7 +707,8 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 static int smack_inode_rename(struct inode *old_inode,
 			      struct dentry *old_dentry,
 			      struct inode *new_inode,
-			      struct dentry *new_dentry)
+			      struct dentry *new_dentry,
+			      unsigned int flags)
 {
 	int rc;
 	char *isp;
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index f0b756e..ac7dd97 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -287,13 +287,15 @@ static int tomoyo_path_link(struct dentry *old_dentry, struct path *new_dir,
  * @old_dentry: Pointer to "struct dentry".
  * @new_parent: Pointer to "struct path".
  * @new_dentry: Pointer to "struct dentry".
+ * @flags:      Rename flags.
  *
  * Returns 0 on success, negative value otherwise.
  */
 static int tomoyo_path_rename(struct path *old_parent,
 			      struct dentry *old_dentry,
 			      struct path *new_parent,
-			      struct dentry *new_dentry)
+			      struct dentry *new_dentry,
+			      unsigned int flags)
 {
 	struct path path1 = { old_parent->mnt, old_dentry };
 	struct path path2 = { new_parent->mnt, new_dentry };
