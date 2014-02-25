Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaBYJlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:41:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47661 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaBYJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:40:58 -0500
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
Date: Tue, 25 Feb 2014 01:40:50 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87fvn74jj1.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19c0Xj+QlFMxvkzWIJjzTiVKDZBBMiThzA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1257]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSxObfu_01 Obfuscated Sexy Adjective
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 10/12] vfs: Make d_invalidate return void
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that d_invalidate can no longer fail, stop returning a useless
return code.  For the few callers that checked the return code update
remove the handling of d_invalidate failure.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/btrfs/ioctl.c       |    5 +----
 fs/cifs/readdir.c      |    6 +-----
 fs/dcache.c            |   12 +++---------
 fs/fuse/dir.c          |    4 +---
 fs/namei.c             |   10 +++++-----
 fs/nfs/dir.c           |    3 +--
 include/linux/dcache.h |    2 +-
 7 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b0134892dc70..349848bd54e2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2229,9 +2229,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	}
 
 	mutex_lock(&inode->i_mutex);
-	err = d_invalidate(dentry);
-	if (err)
-		goto out_unlock;
+	d_invalidate(dentry);
 
 	down_write(&root->fs_info->subvol_sem);
 
@@ -2316,7 +2314,6 @@ out_release:
 	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
-out_unlock:
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
 		shrink_dcache_sb(root->fs_info->sb);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index b15862e0f68c..d0e9d0169b37 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -87,8 +87,6 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 		return;
 
 	if (dentry) {
-		int err;
-
 		inode = dentry->d_inode;
 		if (inode) {
 			/*
@@ -105,10 +103,8 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 				goto out;
 			}
 		}
-		err = d_invalidate(dentry);
+		d_invalidate(dentry);
 		dput(dentry);
-		if (err)
-			return;
 	}
 
 	/*
diff --git a/fs/dcache.c b/fs/dcache.c
index 5b41205cbf33..5b78bd98649c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1377,27 +1377,21 @@ static void check_and_drop(void *_data)
  * d_invalidate - detach submounts, prune dcache, and drop
  * @dentry: dentry to invalidate (aka detach, prune and drop)
  *
- * Try to invalidate the dentry if it turns out to be
- * possible. If there are reasons not to delete it
- * return -EBUSY. On success return 0.
- *
  * no dcache lock.
  *
  * The final d_drop is done as an atomic operation relative to
  * rename_lock ensuring there are no races with d_set_mounted.  This
  * ensures there are no unhashed dentries on the path to a mountpoint.
  */
-int d_invalidate(struct dentry *dentry)
+void d_invalidate(struct dentry *dentry)
 {
-	int ret = 0;
-
 	/*
 	 * If it's already been dropped, return OK.
 	 */
 	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
 		spin_unlock(&dentry->d_lock);
-		return 0;
+		return;
 	}
 	spin_unlock(&dentry->d_lock);
 
@@ -1432,7 +1426,7 @@ int d_invalidate(struct dentry *dentry)
 	}
 
 out:
-	return ret;
+	return;
 }
 EXPORT_SYMBOL(d_invalidate);
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5192d0a04d20..6e920fadb45d 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1225,9 +1225,7 @@ static int fuse_direntplus_link(struct file *file,
 			d_drop(dentry);
 		} else if (get_node_id(inode) != o->nodeid ||
 			   ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
-			err = d_invalidate(dentry);
-			if (err)
-				goto out;
+			d_invalidate(dentry);
 		} else if (is_bad_inode(inode)) {
 			err = -EIO;
 			goto out;
diff --git a/fs/namei.c b/fs/namei.c
index 3fca30cd448b..384fcc6a5606 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1259,7 +1259,8 @@ static struct dentry *lookup_dcache(struct qstr *name, struct dentry *dir,
 				if (error < 0) {
 					dput(dentry);
 					return ERR_PTR(error);
-				} else if (!d_invalidate(dentry)) {
+				} else {
+					d_invalidate(dentry);
 					dput(dentry);
 					dentry = NULL;
 				}
@@ -1391,10 +1392,9 @@ unlazy:
 			dput(dentry);
 			return status;
 		}
-		if (!d_invalidate(dentry)) {
-			dput(dentry);
-			goto need_lookup;
-		}
+		d_invalidate(dentry);
+		dput(dentry);
+		goto need_lookup;
 	}
 
 	path->mnt = mnt;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index a8a2f7f86c45..a2b2b6d17c1f 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -464,8 +464,7 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry)
 				nfs_setsecurity(dentry->d_inode, entry->fattr, entry->label);
 			goto out;
 		} else {
-			if (d_invalidate(dentry) != 0)
-				goto out;
+			d_invalidate(dentry);
 			dput(dentry);
 		}
 	}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ae77222c3e86..95ddb0bdadb0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -250,7 +250,7 @@ extern struct dentry * d_obtain_alias(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
 extern void shrink_dcache_for_umount(struct super_block *);
-extern int d_invalidate(struct dentry *);
+extern void d_invalidate(struct dentry *);
 
 /* only used at mount-time */
 extern struct dentry * d_make_root(struct inode *);
-- 
1.7.5.4

