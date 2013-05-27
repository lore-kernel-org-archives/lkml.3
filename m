Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3E0PdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:33:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61170 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3E0PdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:33:21 -0400
Date: Mon, 27 May 2013 17:33:13 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com
Subject: [RFC PATCH] vfs: add permute operation
Message-ID: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permute the location of files.  E.g.  'permute(A, B, C)' is equivalent to A->B,
B->C and C->A.  This is essentially a series of renames done as a single atomic
operation.

The current implementation allows two or three objects to be permuted.  More
than three would complicate it too much without a clear gain.  All objects have
to be positive and each can be of any type.

This is to serve as a helper to implement whiteouts for overlay/union, but is
expected to be useful for other things as well.

Previous approaches tended to focus on implementing whiteouts as separate
filesystem objects and specialized operations dealing with them.  I think that's
the wrong approach because these objects and code are not generally usable
outside overlay/union implementations.

Whiteouts are needed to "cover" deleted entries in lower filesystems.  They
maybe created in case of an unlink, rmdir or rename.  Whiteouts need to be
replaced when a real object is created in place.  This happens on create, mkdir,
link, rename, etc...

As usual the most complicated operation is rename: a whiteout may need to be
created and may need to be removed as well.  The "empty" target directory may
not actually be empty, as it may contain whiteout files covering all the deleted
entries in that directory, which all need to be removed.  And all of this needs
to be done as an atomic operation.  We could add whiteout support to filesystem
ops to perform the creation or removal of whiteouts atomically, but it would
complicate many filesystem ops needlessly.

Alternatively we can add a generic permute operation and add whiteout support to
the VFS which utilizes this to perform the operations atomically.  To do this
there has to be a temporary "orphan" directory where objects are prepared and
cleaned up.  Hiding this orphan directory from userspace could also be done by
filesystems if necessary.

Here are some examples of doing various operations involving whiteouts.

rmdir(P) where P needs to be whiteout:
  - create-whiteout(orphan/X)
  - permute(orphan/X, P)
  - rmdir(orphan/X)

unlink(P) where P needs to be whiteout (doesn't actually have to use permute):
  - create-whiteout(orphan/X)
  - rename(orphan/X, P)

mkdir(P) where P is currently a whiteout:
  - mkdir(orphan/X)
  - permute(orphan/X, P)
  - unlink(orphan/X)

rename(P, Q) where P needs to be whiteout and Q is negative:
  - create-whiteout(Q)
  - permute(P, Q)

rename(P, Q) where P needs to be whiteout and Q is nondir:
  - create-whiteout(orphan/X)
  - permute(orphan/X, P, Q)
  - unlink(orphan/X)

rename(P, Q) where Q is a directory containing only whiteouts:
  - create-whiteout(orphan/X)
  - permute(orphan/X, P, Q)
  - recursive-remove(orphan/X)

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/x86/syscalls/syscall_64.tbl |    1 
 fs/dcache.c                      |  149 +++++++++++++++++++++++
 fs/ext4/namei.c                  |  175 +++++++++++++++++++++++++++
 fs/internal.h                    |    1 
 fs/namei.c                       |  249 +++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h           |    1 
 include/linux/fs.h               |    6 
 include/linux/syscalls.h         |    3 
 8 files changed, 585 insertions(+)

--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	64	permute			sys_permute
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2316,6 +2316,155 @@ void d_move(struct dentry *dentry, struc
 }
 EXPORT_SYMBOL(d_move);
 
+static void sort_parents3(struct dentry **p)
+{
+	unsigned i;
+
+	/*
+	 * Iterate over all permutations.
+	 */
+	for (i = 0; i < 3; i++) {
+		if (d_ancestor(p[1], p[2]))
+			goto found;
+		swap(p[1], p[2]);
+		if (d_ancestor(p[1], p[2]))
+			goto found;
+		swap(p[0], p[1]);
+	}
+	return;
+
+found:
+	/*
+	 * Now p[1] is ancestor of p[2].  If p[0] is ancestor of p[1] then p[0]
+	 * is the top ancestor.  Otherwise p[1] is the top and the other two
+	 * need sorting.
+	 */
+	if (!d_ancestor(p[0], p[1])) {
+		swap(p[0], p[1]);
+		if (!d_ancestor(p[1], p[2]))
+			swap(p[1], p[2]);
+	}
+}
+
+void sort_parents(struct dentry **p, unsigned *nump)
+{
+	switch (*nump) {
+	case 2:
+		break;
+	case 3:
+		if (p[0] == p[1] || p[0] == p[2] || p[1] == p[2]) {
+			(*nump)--;
+			if (p[0] == p[1])
+				swap(p[1], p[2]);
+			break;
+		}
+		return sort_parents3(p);
+	default:
+		BUG();
+	}
+	if (p[0] == p[1]) {
+		(*nump)--;
+	} else {
+		if (!d_ancestor(p[0], p[1]))
+			swap(p[0], p[1]);
+	}
+}
+
+/*
+ * d_permute - permute dentries
+ * @dentry: array of dentries
+ * @num: size of array
+ *
+ * Do a cyclic permutation of the dentries in the forward direction.  This
+ * is essentially a more general version of d_move().
+ */
+void d_permute(struct dentry **dentry, unsigned num)
+{
+	unsigned i;
+	unsigned next;
+	struct dentry *parent[PERMUTE_MAX];
+	unsigned numparent = num;
+	struct qstr tmp_name;
+	unsigned char tmp_iname[DNAME_INLINE_LEN];
+	struct dentry *tmp_parent;
+	bool tmp_internal = false;
+
+	BUG_ON(num > PERMUTE_MAX);
+
+	write_seqlock(&rename_lock);
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		BUG_ON(!dentry[i]->d_inode);
+		/* No disconnected dentries */
+		BUG_ON(IS_ROOT(dentry[i]));
+		parent[i] = dentry[i]->d_parent;
+	}
+
+	sort_parents(parent, &numparent);
+	for (i = 0; i < numparent; i++)
+		spin_lock_nested(&parent[i]->d_lock, i);
+
+	for (i = 0; i < num; i++) {
+		spin_lock_nested(&dentry[i]->d_lock, PERMUTE_MAX + i);
+		write_seqcount_begin(&dentry[i]->d_seq);
+	}
+
+	/*
+	 * Move the dentry to the target hash queue. Don't bother checking
+	 * for the same hash queue because of how unlikely it is.
+	 */
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		__d_drop(dentry[i]);
+		__d_rehash(dentry[i], d_hash(dentry[next]->d_parent,
+					     dentry[next]->d_name.hash));
+		list_del(&dentry[i]->d_u.d_child);
+	}
+
+	/* Switch the names and the parents */
+	tmp_name = dentry[0]->d_name;
+	tmp_parent = dentry[0]->d_parent;
+	if (!dname_external(dentry[0])) {
+		tmp_internal = true;
+		memcpy(tmp_iname, dentry[0]->d_name.name,
+		       dentry[0]->d_name.len + 1);
+	}
+	for (i = 1; i < num; i++) {
+		dentry[i-1]->d_name = dentry[i]->d_name;
+		if (!dname_external(dentry[i])) {
+			memcpy(dentry[i-1]->d_iname, dentry[i]->d_name.name,
+			       dentry[i]->d_name.len + 1);
+			dentry[i-1]->d_name.name = dentry[i-1]->d_iname;
+		}
+		dentry[i-1]->d_parent = dentry[i]->d_parent;
+	}
+	dentry[num-1]->d_name = tmp_name;
+	if (tmp_internal) {
+		memcpy(dentry[num-1]->d_iname, tmp_iname, tmp_name.len + 1);
+		dentry[num-1]->d_name.name = dentry[num-1]->d_iname;
+	}
+	dentry[num-1]->d_parent = tmp_parent;
+
+	/* And add them back to the (new) parent lists */
+	for (i = 0; i < num; i++) {
+		list_add(&dentry[i]->d_u.d_child,
+			 &dentry[i]->d_parent->d_subdirs);
+		write_seqcount_end(&dentry[i]->d_seq);
+	}
+
+	for (i = 0; i < numparent; i++)
+		spin_unlock(&parent[i]->d_lock);
+
+	for (i = 0; i < num; i++) {
+		fsnotify_d_move(dentry[i]);
+		spin_unlock(&dentry[i]->d_lock);
+	}
+
+	write_sequnlock(&rename_lock);
+}
+
+
 /**
  * d_ancestor - search for an ancestor
  * @p1: ancestor dentry
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3160,6 +3160,180 @@ static int ext4_rename(struct inode *old
 	return retval;
 }
 
+static int ext4_permute(struct dentry **dentry, unsigned int num)
+{
+	struct inode *dir[PERMUTE_MAX];
+	struct inode *inode[PERMUTE_MAX];
+	struct buffer_head *bh[PERMUTE_MAX];
+	struct buffer_head *dir_bh[PERMUTE_MAX];
+	struct ext4_dir_entry_2 *de[PERMUTE_MAX];
+	int parent_inlined[PERMUTE_MAX];
+	int inlined[PERMUTE_MAX];
+	struct ext4_dir_entry_2 *parent_de[PERMUTE_MAX];
+	__le32 tmp_inode;
+	__u8 tmp_file_type;
+	bool sync = 0;
+	bool has_filetype;
+	handle_t *handle;
+	int retval;
+	unsigned i;
+	unsigned next;
+	struct super_block *sb = dentry[0]->d_sb;
+
+	if (WARN_ON(num > PERMUTE_MAX) ||
+	    WARN_ON(num < 2))
+		return -EINVAL;
+
+	for (i = 0; i < num; i++) {
+		parent_inlined[i] = 0;
+		inlined[i] = 0;
+		bh[i] = dir_bh[i] = NULL;
+		inode[i] = dentry[i]->d_inode;
+		dir[i] = dentry[i]->d_parent->d_inode;
+		dquot_initialize(dir[i]);
+		if (IS_DIRSYNC(dir[i]))
+			sync = 1;
+	}
+
+	handle = ext4_journal_start(dir[0], EXT4_HT_DIR,
+				num * EXT4_DATA_TRANS_BLOCKS(sb) +
+				num * EXT4_INDEX_EXTRA_TRANS_BLOCKS + num);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	if (sync)
+		ext4_handle_sync(handle);
+
+	for (i = 0; i < num; i++) {
+		bh[i] = ext4_find_entry(dir[i], &dentry[i]->d_name, &de[i],
+					&inlined[i]);
+
+		retval = -ENOENT;
+		if (!bh[i] || le32_to_cpu(de[i]->inode) != inode[i]->i_ino)
+			goto end_permute;
+	}
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		if (S_ISDIR(inode[i]->i_mode) && dir[i] != dir[next]) {
+			retval = -EIO;
+			dir_bh[i] = ext4_get_first_dir_block(handle, inode[i],
+							&retval, &parent_de[i],
+							&parent_inlined[i]);
+			if (!dir_bh[i])
+				goto end_permute;
+			if (le32_to_cpu(parent_de[i]->inode) != dir[i]->i_ino)
+				goto end_permute;
+			/*
+			 * If moving a dir in place of a non-dir then check for
+			 * the link count limit.
+			 */
+			retval = -EMLINK;
+			if (!S_ISDIR(inode[next]->i_mode) &&
+			    EXT4_DIR_LINK_MAX(dir[next]))
+				goto end_permute;
+
+			BUFFER_TRACE(olddir_bh, "get_write_access");
+			retval = ext4_journal_get_write_access(handle,
+							       dir_bh[i]);
+			if (retval)
+				goto end_permute;
+		}
+		BUFFER_TRACE(new_bh, "get write access");
+		retval = ext4_journal_get_write_access(handle, bh[i]);
+		if (retval)
+			goto end_permute;
+	}
+
+	has_filetype =
+		EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE);
+
+	i = num - 1;
+	tmp_inode = de[i]->inode;
+	tmp_file_type = de[i]->file_type;
+	for (; i > 0; i--) {
+		de[i]->inode = de[i - 1]->inode;
+		if (has_filetype)
+			de[i]->file_type = de[i - 1]->file_type;
+	}
+	de[0]->inode = tmp_inode;
+	if (has_filetype)
+		de[0]->file_type = tmp_file_type;
+
+
+	for (i = 0; i < num; i++) {
+		dir[i]->i_version++;
+		dir[i]->i_ctime = dir[i]->i_mtime = ext4_current_time(dir[i]);
+		ext4_mark_inode_dirty(handle, dir[i]);
+		BUFFER_TRACE(old_bh, "call ext4_handle_dirty_metadata");
+		if (!inlined[i]) {
+			retval = ext4_handle_dirty_dirent_node(handle, dir[i],
+							       bh[i]);
+			if (unlikely(retval)) {
+				ext4_std_error(sb, retval);
+				goto end_permute;
+			}
+		}
+		brelse(bh[i]);
+		bh[i] = NULL;
+
+		/*
+		 * Set the ctime for inodes on permute.
+		 */
+		inode[i]->i_ctime = ext4_current_time(inode[i]);
+		ext4_mark_inode_dirty(handle, inode[i]);
+
+	}
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+
+		if (!dir_bh[i])
+			continue;
+
+		parent_de[i]->inode = cpu_to_le32(dir[next]->i_ino);
+		BUFFER_TRACE(dir_bh[i], "call ext4_handle_dirty_metadata");
+		if (!parent_inlined[i]) {
+			if (is_dx(inode[i])) {
+				retval = ext4_handle_dirty_dx_node(handle,
+							inode[i], dir_bh[i]);
+			} else {
+				retval = ext4_handle_dirty_dirent_node(handle,
+							inode[i], dir_bh[i]);
+			}
+		} else {
+			retval = ext4_mark_inode_dirty(handle, inode[i]);
+		}
+		if (retval) {
+			ext4_std_error(sb, retval);
+			goto end_permute;
+		}
+	}
+	for (i = 0; i < num; i++) {
+		if (S_ISDIR(inode[i]->i_mode)) {
+			next = (i + 1) % num;
+			ext4_dec_count(handle, dir[i]);
+			ext4_inc_count(handle, dir[next]);
+			ext4_update_dx_flag(dir[i]);
+			ext4_update_dx_flag(dir[next]);
+			ext4_mark_inode_dirty(handle, dir[i]);
+			ext4_mark_inode_dirty(handle, dir[next]);
+		}
+	}
+
+
+	retval = 0;
+
+end_permute:
+	for (i = 0; i < num; i++) {
+		brelse(dir_bh[i]);
+		brelse(bh[i]);
+	}
+	ext4_journal_stop(handle);
+
+	return retval;
+}
+
 /*
  * directories can handle most operations...
  */
@@ -3173,6 +3347,7 @@ const struct inode_operations ext4_dir_i
 	.rmdir		= ext4_rmdir,
 	.mknod		= ext4_mknod,
 	.rename		= ext4_rename,
+	.permute	= ext4_permute,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -125,6 +125,7 @@ extern int invalidate_inodes(struct supe
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+extern void sort_parents(struct dentry **p, unsigned *nump);
 
 /*
  * read_write.c
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3932,6 +3932,255 @@ SYSCALL_DEFINE2(rename, const char __use
 	return sys_renameat(AT_FDCWD, oldname, AT_FDCWD, newname);
 }
 
+static int vfs_permute(struct dentry **dentry, unsigned num)
+{
+	int error;
+	struct super_block *sb = dentry[0]->d_sb;
+	unsigned max_links = sb->s_max_links;
+	struct inode *dir;
+	struct inode *next_dir;
+	struct inode *inode;
+	struct inode *next_inode;
+	unsigned i;
+	unsigned j;
+	unsigned next;
+
+	for (i = 0; i < num; i++) {
+		for (j = i + 1; j < num; j++) {
+			if (dentry[i] == dentry[j])
+				return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < num; i++) {
+		dir = dentry[i]->d_parent->d_inode;
+		inode = dentry[i]->d_inode;
+		error = may_delete(dir, dentry[i], S_ISDIR(inode->i_mode));
+		if (error)
+			return error;
+	}
+
+	dir = dentry[0]->d_parent->d_inode;
+	if (!dir->i_op->permute)
+		return -EPERM;
+
+	/*
+	 * If we are going to change the parent - check write permissions,
+	 * we'll need to flip '..'.
+	 */
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		dir = dentry[i]->d_parent->d_inode;
+		next_dir = dentry[next]->d_parent->d_inode;
+		inode = dentry[i]->d_inode;
+		next_inode = dentry[next]->d_inode;
+
+		if (S_ISDIR(inode->i_mode) && dir != next_dir) {
+			error = inode_permission(inode, MAY_WRITE);
+			if (error)
+				return error;
+
+			error = -EMLINK;
+			if (max_links && !S_ISDIR(next_inode->i_mode) &&
+			    next_dir->i_nlink >= max_links)
+				return error;
+		}
+	}
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		dir = dentry[i]->d_parent->d_inode;
+		next_dir = dentry[next]->d_parent->d_inode;
+		error = security_inode_rename(dir, dentry[i],
+					      next_dir, dentry[next]);
+		if (error)
+			return error;
+	}
+
+	for (i = 0; i < num; i++) {
+		error = -EBUSY;
+		if (d_mountpoint(dentry[i]))
+			return error;
+	}
+
+	dir = dentry[0]->d_parent->d_inode;
+	error = dir->i_op->permute(dentry, num);
+	if (error)
+		return error;
+
+	d_permute(dentry, num);
+
+	if (!error) {
+		for (i = 0; i < num; i++) {
+			unsigned prev = (i + num - 1) % num;
+			const unsigned char *old_name;
+			int is_dir = S_ISDIR(dentry[i]->d_inode->i_mode);
+
+			old_name = dentry[prev]->d_name.name;
+			next = (i + 1) % num;
+			dir = dentry[i]->d_parent->d_inode;
+			next_dir = dentry[next]->d_parent->d_inode;
+			fsnotify_move(dir, next_dir, old_name, is_dir, NULL,
+				      dentry[i]);
+		}
+	}
+
+	return error;
+}
+
+static inline unsigned int i_mutex_depth_class(unsigned depth)
+{
+	switch (depth) {
+	case 0:
+		return I_MUTEX_PARENT;
+	case 1:
+		return I_MUTEX_CHILD;
+	case 2:
+		return I_MUTEX_NORMAL;
+	default:
+		BUG();
+	}
+}
+
+SYSCALL_DEFINE6(permute,
+		int, dfd0, const char __user *, name0,
+		int, dfd1, const char __user *, name1,
+		int, dfd2, const char __user *, name2)
+{
+	int dfd[PERMUTE_MAX];
+	const char __user *name[PERMUTE_MAX];
+	struct dentry *dentry[PERMUTE_MAX];
+	struct dentry *dir[PERMUTE_MAX];
+	struct nameidata nd[PERMUTE_MAX];
+	struct filename *fname[PERMUTE_MAX];
+	struct super_block *sb;
+	unsigned num;
+	unsigned numparent;
+	unsigned i;
+	unsigned next;
+	int error;
+
+	dfd[0] = dfd0;
+	dfd[1] = dfd1;
+	dfd[2] = dfd2;
+	name[0] = name0;
+	name[1] = name1;
+	name[2] = name2;
+
+	num = 3;
+	if (name[2] == NULL)
+		num = 2;
+
+	for (i = 0; i < num; i++) {
+		dentry[i] = NULL;
+		fname[i] = NULL;
+	}
+
+	for (i = 0; i < num; i++) {
+		struct filename *fname_res;
+		fname_res = user_path_parent(dfd[i], name[i], &nd[i], 0);
+		if (IS_ERR(fname_res)) {
+			error = PTR_ERR(fname_res);
+			goto exit;
+		}
+		fname[i] = fname_res;
+	}
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		error = -EXDEV;
+		if (nd[i].path.mnt != nd[next].path.mnt)
+			goto exit;
+	}
+
+	for (i = 0; i < num; i++) {
+		dir[i] = nd[i].path.dentry;
+		error = -EBUSY;
+		if (nd[i].last_type != LAST_NORM)
+			goto exit;
+	}
+
+	error = mnt_want_write(nd[0].path.mnt);
+	if (error)
+		goto exit;
+
+	for (i = 0; i < num; i++)
+		nd[i].flags &= ~LOOKUP_PARENT;
+
+	numparent = num;
+	sort_parents(dir, &numparent);
+	sb = dir[0]->d_inode->i_sb;
+	if (numparent > 1)
+		mutex_lock(&sb->s_vfs_rename_mutex);
+
+	for (i = 0; i < numparent; i++) {
+		mutex_lock_nested(&dir[i]->d_inode->i_mutex,
+				  i_mutex_depth_class(i));
+	}
+
+	for (i = 0; i < num; i++) {
+		struct dentry *dentry_res;
+		dentry_res = lookup_hash(&nd[i]);
+		error = PTR_ERR(dentry_res);
+		if (IS_ERR(dentry_res))
+			goto exit3;
+
+		dentry[i] = dentry_res;
+
+		/* source must exist */
+		error = -ENOENT;
+		if (!dentry[i]->d_inode)
+			goto exit3;
+
+		/* unless it is a directory trailing slashes give -ENOTDIR */
+		if (!S_ISDIR(dentry[i]->d_inode->i_mode)) {
+			error = -ENOTDIR;
+			if (nd[i].last.name[nd[i].last.len])
+				goto exit3;
+		}
+	}
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		error = -EINVAL;
+		/* source should not be ancestor or descendant of target */
+		if (d_ancestor(dentry[i], dentry[next]))
+			goto exit3;
+		if (d_ancestor(dentry[next], dentry[i]))
+			goto exit3;
+	}
+
+
+	for (i = 0; i < num; i++) {
+		next = (i + 1) % num;
+		error = security_path_rename(&nd[i].path, dentry[i],
+					     &nd[next].path, dentry[next]);
+		if (error)
+			goto exit3;
+	}
+	error = vfs_permute(dentry, num);
+
+exit3:
+	for (i = 0; i < num; i++)
+		dput(dentry[i]);
+
+	for (i = 0; i < numparent; i++)
+		mutex_unlock(&dir[i]->d_inode->i_mutex);
+
+	if (numparent > 1)
+		mutex_unlock(&sb->s_vfs_rename_mutex);
+
+	mnt_drop_write(nd[0].path.mnt);
+exit:
+	for (i = 0; i < num; i++) {
+		if (fname[i]) {
+			path_put(&nd[i].path);
+			putname(fname[i]);
+		}
+	}
+	return error;
+}
+
 int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen, const char *link)
 {
 	int len;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -293,6 +293,7 @@ extern void dentry_update_name_case(stru
 
 /* used for rename() and baskets */
 extern void d_move(struct dentry *, struct dentry *);
+extern void d_permute(struct dentry **dentry, unsigned num);
 extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
 
 /* appendix may either be NULL or be used for transname suffixes */
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1545,6 +1545,11 @@ struct file_operations {
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
+/*
+ * Things get ugly with permutations involving > 3 dentries, so don't do that
+ */
+#define PERMUTE_MAX 3
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
@@ -1563,6 +1568,7 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
+	int (*permute) (struct dentry **, unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -841,4 +841,7 @@ asmlinkage long sys_process_vm_writev(pi
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_permute(int dfd0, const char __user *name0,
+			    int dfd1, const char __user *name1,
+			    int dfd2, const char __user *name2);
 #endif
