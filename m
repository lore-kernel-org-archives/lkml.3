Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaDQUGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:06:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53141 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaDQUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:06:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
	<87ppkhc4pp.fsf@x220.int.ebiederm.org>
Date: Thu, 17 Apr 2014 13:05:59 -0700
In-Reply-To: <87ppkhc4pp.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 16 Apr 2014 15:03:14 -0700")
Message-ID: <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/5pzJKTo4Fl8i23XJPOMca+mwx5hHF58k=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] Detaching mounts on unlink for 3.15
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 3efe1ac78e996da8e141b86667cc15758aad4366 vfs: Block intuitively in the case of BSD accounting files

This branch contains 3 significant fixes.

- Allowing a file or directory that is only a mountpoint in another
  mount namespace to be renamed or removed.

- Removal of the need to lie to the vfs when a mountpoint has been
  renamed or removed on a remote filesystem.

- Cleaning up a mount in a separate context so that mntput is safe
  to call even from deep on the kernel stack.

Allowing files and directories to be renamed and removed prevents
a DOS attack where an unprivileged user could prevent root from renaming
or deleting files and directories by using them as mountpoints in
another mount namespace.

To verify that nothing significant changed from since the time this code
was written I performed a test merge, and tested the result.   As of
roughly 3.15-rc1 there were no real conflicts just changes in context.

This is the same code I sent a pull request for in the merge window plus
changes to mntput to prevent the class of stack overflow the other
changes made easier to trigger, that was pointed out by Al Viro.

Eric W. Biederman (16):
      vfs: Document the effect of d_revalidate on d_find_alias
      vfs: More precise tests in d_invalidate
      vfs: Don't allow overwriting mounts in the current mount namespace
      vfs: Keep a list of mounts on a mount point
      vfs: factor out lookup_mountpoint from new_mountpoint
      vfs: Add a function to lazily unmount all mounts from any dentry.
      vfs: Lazily remove mounts on unlinked files and directories.
      vfs: Remove unnecessary calls of check_submounts_and_drop
      vfs: Merge check_submounts_and_drop and d_invalidate
      vfs: Make d_invalidate return void
      vfs: Remove d_drop calls from d_revalidate implementations
      proc: Update proc_flush_task_mnt to use d_invalidate
      vfs: Remove useless loop in mntput_no_expire
      vfs: Move autoclose of BSD accounting into a work queue
      vfs: In mntput run deactivate_super on a shallow stack.
      vfs: Block intuitively in the case of BSD accounting files

 fs/afs/dir.c           |   5 --
 fs/btrfs/ioctl.c       |   5 +-
 fs/ceph/dir.c          |   1 -
 fs/cifs/readdir.c      |   6 +--
 fs/dcache.c            | 140 ++++++++++++++++++-------------------------------
 fs/fuse/dir.c          |   7 +--
 fs/gfs2/dentry.c       |   3 --
 fs/kernfs/dir.c        |  11 ----
 fs/mount.h             |  22 ++++++++
 fs/namei.c             |  28 ++++++----
 fs/namespace.c         | 130 +++++++++++++++++++++++++++++++++++++++++----
 fs/nfs/dir.c           |   7 +--
 fs/proc/base.c         |  10 +---
 fs/proc/fd.c           |   2 -
 include/linux/dcache.h |   3 +-
 kernel/acct.c          |  25 +++++++--
 16 files changed, 235 insertions(+), 170 deletions(-)

Eric

---

My merge conflict resolution

__d_move gained an argument, my changes took __d_move out of a conditional.

m_hash went from a struct list to a struct hlist changing nearby code,
and affecting my factoring out of lookup_mountpoint from new_mountpoint.

There was a major refactoring of rename.  As long as d_mountpoint
becomes is_local_mounptoint and detach_mount is added after dont_mount
all is well.

delayed_free was renamed vfsmount_delayed_free

 dcache.c    |    6 +----
 mount.h     |    1 
 namei.c     |    9 +++++++-
 namespace.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 74 insertions(+), 8 deletions(-)

diff --cc fs/dcache.c
index 40707d88a945,5b78bd98649c..0407ed4a2604
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -2701,10 -2631,8 +2663,8 @@@ static struct dentry *__d_unalias(struc
  		goto out_err;
  	m2 = &alias->d_parent->d_inode->i_mutex;
  out_unalias:
- 	if (likely(!d_mountpoint(alias))) {
- 		__d_move(alias, dentry, false);
- 		ret = alias;
- 	}
 -	__d_move(alias, dentry);
++	__d_move(alias, dentry, false);
+ 	ret = alias;
  out_err:
  	spin_unlock(&inode->i_lock);
  	if (m2)
diff --cc fs/mount.h
index d55297f2fa05,4104a3cca238..84c282321d67
--- a/fs/mount.h
+++ b/fs/mount.h
@@@ -19,8 -19,9 +19,9 @@@ struct mnt_pcp 
  };
  
  struct mountpoint {
 -	struct list_head m_hash;
 +	struct hlist_node m_hash;
  	struct dentry *m_dentry;
+ 	struct list_head m_list;
  	int m_count;
  };
  
diff --cc fs/namei.c
index c6157c894fce,384fcc6a5606..38cb09a05765
--- a/fs/namei.c
+++ b/fs/namei.c
@@@ -4101,33 -4045,17 +4104,33 @@@ int vfs_rename(struct inode *old_dir, s
  	if (error)
  		return error;
  
 +	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
  	dget(new_dentry);
 -	lock_two_nondirectories(source, target);
 +	if (!is_dir || (flags & RENAME_EXCHANGE))
 +		lock_two_nondirectories(source, target);
 +	else if (target)
 +		mutex_lock(&target->i_mutex);
  
  	error = -EBUSY;
- 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
+ 	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
  		goto out;
  
 -	error = try_break_deleg(source, delegated_inode);
 -	if (error)
 -		goto out;
 -	if (target) {
 +	if (max_links && new_dir != old_dir) {
 +		error = -EMLINK;
 +		if (is_dir && !new_is_dir && new_dir->i_nlink >= max_links)
 +			goto out;
 +		if ((flags & RENAME_EXCHANGE) && !is_dir && new_is_dir &&
 +		    old_dir->i_nlink >= max_links)
 +			goto out;
 +	}
 +	if (is_dir && !(flags & RENAME_EXCHANGE) && target)
 +		shrink_dcache_parent(new_dentry);
 +	if (!is_dir) {
 +		error = try_break_deleg(source, delegated_inode);
 +		if (error)
 +			goto out;
 +	}
 +	if (target && !new_is_dir) {
  		error = try_break_deleg(target, delegated_inode);
  		if (error)
  			goto out;
@@@ -4142,31 -4064,73 +4145,38 @@@
  	if (error)
  		goto out;
  
 +	if (!(flags & RENAME_EXCHANGE) && target) {
 +		if (is_dir)
 +			target->i_flags |= S_DEAD;
 +		dont_mount(new_dentry);
++		detach_mounts(new_dentry);
 +	}
 +	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE)) {
 +		if (!(flags & RENAME_EXCHANGE))
 +			d_move(old_dentry, new_dentry);
 +		else
 +			d_exchange(old_dentry, new_dentry);
 +	}
+ 	if (target) {
+ 		dont_mount(new_dentry);
+ 		detach_mounts(new_dentry);
+ 	}
+ 	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
+ 		d_move(old_dentry, new_dentry);
  out:
 -	unlock_two_nondirectories(source, target);
 +	if (!is_dir || (flags & RENAME_EXCHANGE))
 +		unlock_two_nondirectories(source, target);
 +	else if (target)
 +		mutex_unlock(&target->i_mutex);
  	dput(new_dentry);
 -	return error;
 -}
 -
 -/**
 - * vfs_rename - rename a filesystem object
 - * @old_dir:	parent of source
 - * @old_dentry:	source
 - * @new_dir:	parent of destination
 - * @new_dentry:	destination
 - * @delegated_inode: returns an inode needing a delegation break
 - *
 - * The caller must hold multiple mutexes--see lock_rename()).
 - *
 - * If vfs_rename discovers a delegation in need of breaking at either
 - * the source or destination, it will return -EWOULDBLOCK and return a
 - * reference to the inode in delegated_inode.  The caller should then
 - * break the delegation and retry.  Because breaking a delegation may
 - * take a long time, the caller should drop all locks before doing
 - * so.
 - *
 - * Alternatively, a caller may pass NULL for delegated_inode.  This may
 - * be appropriate for callers that expect the underlying filesystem not
 - * to be NFS exported.
 - */
 -int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 -	       struct inode *new_dir, struct dentry *new_dentry,
 -	       struct inode **delegated_inode)
 -{
 -	int error;
 -	int is_dir = d_is_directory(old_dentry) || d_is_autodir(old_dentry);
 -	const unsigned char *old_name;
 -
 -	if (old_dentry->d_inode == new_dentry->d_inode)
 - 		return 0;
 - 
 -	error = may_delete(old_dir, old_dentry, is_dir);
 -	if (error)
 -		return error;
 -
 -	if (!new_dentry->d_inode)
 -		error = may_create(new_dir, new_dentry);
 -	else
 -		error = may_delete(new_dir, new_dentry, is_dir);
 -	if (error)
 -		return error;
 -
 -	if (!old_dir->i_op->rename)
 -		return -EPERM;
 -
 -	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
 -
 -	if (is_dir)
 -		error = vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry);
 -	else
 -		error = vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry,delegated_inode);
 -	if (!error)
 +	if (!error) {
  		fsnotify_move(old_dir, new_dir, old_name, is_dir,
 -			      new_dentry->d_inode, old_dentry);
 +			      !(flags & RENAME_EXCHANGE) ? target : NULL, old_dentry);
 +		if (flags & RENAME_EXCHANGE) {
 +			fsnotify_move(new_dir, old_dir, old_dentry->d_name.name,
 +				      new_is_dir, NULL, new_dentry);
 +		}
 +	}
  	fsnotify_oldname_free(old_name);
  
  	return error;
diff --cc fs/namespace.c
index 182bc41cd887,128c051041be..b10db3d69943
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@@ -667,13 -632,47 +668,47 @@@ struct vfsmount *lookup_mnt(struct pat
  	return m;
  }
  
- static struct mountpoint *new_mountpoint(struct dentry *dentry)
+ /*
+  * __is_local_mountpoint - Test to see if dentry is a mountpoint in the
+  *                         current mount namespace.
+  *
+  * The common case is dentries are not mountpoints at all and that
+  * test is handled inline.  For the slow case when we are actually
+  * dealing with a mountpoint of some kind, walk through all of the
+  * mounts in the current mount namespace and test to see if the dentry
+  * is a mountpoint.
+  *
+  * The mount_hashtable is not usable in the context because we
+  * need to identify all mounts that may be in the current mount
+  * namespace not just a mount that happens to have some specified
+  * parent mount.
+  */
+ bool __is_local_mountpoint(struct dentry *dentry)
+ {
+ 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+ 	struct mount *mnt;
+ 	bool is_covered = false;
+ 
+ 	if (!d_mountpoint(dentry))
+ 		goto out;
+ 
+ 	down_read(&namespace_sem);
+ 	list_for_each_entry(mnt, &ns->list, mnt_list) {
+ 		is_covered = (mnt->mnt_mountpoint == dentry);
+ 		if (is_covered)
+ 			break;
+ 	}
+ 	up_read(&namespace_sem);
+ out:
+ 	return is_covered;
+ }
+ 
+ static struct mountpoint *lookup_mountpoint(struct dentry *dentry)
  {
 -	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
 +	struct hlist_head *chain = mp_hash(dentry);
  	struct mountpoint *mp;
- 	int ret;
  
 -	list_for_each_entry(mp, chain, m_hash) {
 +	hlist_for_each_entry(mp, chain, m_hash) {
  		if (mp->m_dentry == dentry) {
  			/* might be worth a WARN_ON() */
  			if (d_unlinked(dentry))
@@@ -682,6 -681,14 +717,14 @@@
  			return mp;
  		}
  	}
+ 	return NULL;
+ }
+ 
+ static struct mountpoint *new_mountpoint(struct dentry *dentry)
+ {
 -	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
++	struct hlist_head *chain = mp_hash(dentry);
+ 	struct mountpoint *mp;
+ 	int ret;
  
  	mp = kmalloc(sizeof(struct mountpoint), GFP_KERNEL);
  	if (!mp)
@@@ -695,7 -702,8 +738,8 @@@
  
  	mp->m_dentry = dentry;
  	mp->m_count = 1;
 -	list_add(&mp->m_hash, chain);
 +	hlist_add_head(&mp->m_hash, chain);
+ 	INIT_LIST_HEAD(&mp->m_list);
  	return mp;
  }
  
@@@ -748,7 -757,8 +793,8 @@@ static void detach_mnt(struct mount *mn
  	mnt->mnt_parent = mnt;
  	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
  	list_del_init(&mnt->mnt_child);
 -	list_del_init(&mnt->mnt_hash);
 +	hlist_del_init_rcu(&mnt->mnt_hash);
+ 	list_del_init(&mnt->mnt_mp_list);
  	put_mountpoint(mnt->mnt_mp);
  	mnt->mnt_mp = NULL;
  }
@@@ -936,9 -943,35 +983,25 @@@ static struct mount *clone_mnt(struct m
  	return ERR_PTR(err);
  }
  
 -static void delayed_free(struct rcu_head *head)
 -{
 -	struct mount *mnt = container_of(head, struct mount, mnt_rcu);
 -	kfree(mnt->mnt_devname);
 -#ifdef CONFIG_SMP
 -	free_percpu(mnt->mnt_pcp);
 -#endif
 -	kmem_cache_free(mnt_cache, mnt);
 -}
 -
+ static void cleanup_mnt(struct mount *mnt)
+ {
+ 	fsnotify_vfsmount_delete(&mnt->mnt);
+ 	dput(mnt->mnt.mnt_root);
+ 	deactivate_super(mnt->mnt.mnt_sb);
+ 	mnt_free_id(mnt);
+ 	complete(mnt->mnt_undone);
 -	call_rcu(&mnt->mnt_rcu, delayed_free);
++	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
+ }
+ 
+ static void cleanup_mnt_work(struct work_struct *work)
+ {
+ 	cleanup_mnt(container_of(work, struct mount, mnt_cleanup_work));
+ }
+ 
  static void mntput_no_expire(struct mount *mnt)
  {
- put_again:
+ 	struct completion undone;
+ 
  	rcu_read_lock();
  	mnt_add_count(mnt, -1);
  	if (likely(mnt->mnt_ns)) { /* shouldn't be the last one */

