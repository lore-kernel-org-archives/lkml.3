Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaJTFWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:22:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:59967 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaJTFTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:50 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 04/11] f2fs: avoid deadlock on init_inode_metadata
Date: Sun, 19 Oct 2014 22:19:32 -0700
Message-Id: <1413782379-11758-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, init_inode_metadata does not hold any parent directory's inode
page. So, f2fs_init_acl can grab its parent inode page without any problem.
But, when we use inline_dentry, that page is grabbed during f2fs_add_link,
so that we can fall into deadlock condition like below.

INFO: task mknod:11006 blocked for more than 120 seconds.
      Tainted: G           OE  3.17.0-rc1+ #13
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mknod           D ffff88003fc94580     0 11006  11004 0x00000000
 ffff880007717b10 0000000000000002 ffff88003c323220 ffff880007717fd8
 0000000000014580 0000000000014580 ffff88003daecb30 ffff88003c323220
 ffff88003fc94e80 ffff88003ffbb4e8 ffff880007717ba0 0000000000000002
Call Trace:
 [<ffffffff8173dc40>] ? bit_wait+0x50/0x50
 [<ffffffff8173d4cd>] io_schedule+0x9d/0x130
 [<ffffffff8173dc6c>] bit_wait_io+0x2c/0x50
 [<ffffffff8173da3b>] __wait_on_bit_lock+0x4b/0xb0
 [<ffffffff811640a7>] __lock_page+0x67/0x70
 [<ffffffff810acf50>] ? autoremove_wake_function+0x40/0x40
 [<ffffffff811652cc>] pagecache_get_page+0x14c/0x1e0
 [<ffffffffa029afa9>] get_node_page+0x59/0x130 [f2fs]
 [<ffffffffa02a63ad>] read_all_xattrs+0x24d/0x430 [f2fs]
 [<ffffffffa02a6ca2>] f2fs_getxattr+0x52/0xe0 [f2fs]
 [<ffffffffa02a7481>] f2fs_get_acl+0x41/0x2d0 [f2fs]
 [<ffffffff8122d847>] get_acl+0x47/0x70
 [<ffffffff8122db5a>] posix_acl_create+0x5a/0x150
 [<ffffffffa02a7759>] f2fs_init_acl+0x29/0xcb [f2fs]
 [<ffffffffa0286a8d>] init_inode_metadata+0x5d/0x340 [f2fs]
 [<ffffffffa029253a>] f2fs_add_inline_entry+0x12a/0x2e0 [f2fs]
 [<ffffffffa0286ea5>] __f2fs_add_link+0x45/0x4a0 [f2fs]
 [<ffffffffa028b5b6>] ? f2fs_new_inode+0x146/0x220 [f2fs]
 [<ffffffffa028b816>] f2fs_mknod+0x86/0xf0 [f2fs]
 [<ffffffff811e3ec1>] vfs_mknod+0xe1/0x160
 [<ffffffff811e4b26>] SyS_mknod+0x1f6/0x200
 [<ffffffff81741d7f>] tracesys+0xe1/0xe6

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/acl.c    | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/f2fs/acl.h    |   5 +-
 fs/f2fs/dir.c    |  10 ++--
 fs/f2fs/f2fs.h   |   2 +-
 fs/f2fs/inline.c |   6 +--
 fs/f2fs/xattr.c  |   6 +--
 fs/f2fs/xattr.h  |   6 ++-
 7 files changed, 157 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 83b9b5a..6207455 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -162,7 +162,8 @@ fail:
 	return ERR_PTR(-EINVAL);
 }
 
-struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
+static struct posix_acl *__f2fs_get_acl(struct inode *inode, int type,
+						struct page *dpage)
 {
 	int name_index = F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT;
 	void *value = NULL;
@@ -172,12 +173,13 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 	if (type == ACL_TYPE_ACCESS)
 		name_index = F2FS_XATTR_INDEX_POSIX_ACL_ACCESS;
 
-	retval = f2fs_getxattr(inode, name_index, "", NULL, 0);
+	retval = f2fs_getxattr(inode, name_index, "", NULL, 0, dpage);
 	if (retval > 0) {
 		value = kmalloc(retval, GFP_F2FS_ZERO);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
-		retval = f2fs_getxattr(inode, name_index, "", value, retval);
+		retval = f2fs_getxattr(inode, name_index, "", value,
+							retval, dpage);
 	}
 
 	if (retval > 0)
@@ -194,6 +196,11 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
+struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
+{
+	return __f2fs_get_acl(inode, type, NULL);
+}
+
 static int __f2fs_set_acl(struct inode *inode, int type,
 			struct posix_acl *acl, struct page *ipage)
 {
@@ -249,12 +256,137 @@ int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	return __f2fs_set_acl(inode, type, acl, NULL);
 }
 
-int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
+/*
+ * Most part of f2fs_acl_clone, f2fs_acl_create_masq, f2fs_acl_create
+ * are copied from posix_acl.c
+ */
+static struct posix_acl *f2fs_acl_clone(const struct posix_acl *acl,
+							gfp_t flags)
+{
+	struct posix_acl *clone = NULL;
+
+	if (acl) {
+		int size = sizeof(struct posix_acl) + acl->a_count *
+				sizeof(struct posix_acl_entry);
+		clone = kmemdup(acl, size, flags);
+		if (clone)
+			atomic_set(&clone->a_refcount, 1);
+	}
+	return clone;
+}
+
+static int f2fs_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
+{
+	struct posix_acl_entry *pa, *pe;
+	struct posix_acl_entry *group_obj = NULL, *mask_obj = NULL;
+	umode_t mode = *mode_p;
+	int not_equiv = 0;
+
+	/* assert(atomic_read(acl->a_refcount) == 1); */
+
+	FOREACH_ACL_ENTRY(pa, acl, pe) {
+		switch(pa->e_tag) {
+		case ACL_USER_OBJ:
+			pa->e_perm &= (mode >> 6) | ~S_IRWXO;
+			mode &= (pa->e_perm << 6) | ~S_IRWXU;
+			break;
+
+		case ACL_USER:
+		case ACL_GROUP:
+			not_equiv = 1;
+			break;
+
+		case ACL_GROUP_OBJ:
+			group_obj = pa;
+			break;
+
+		case ACL_OTHER:
+			pa->e_perm &= mode | ~S_IRWXO;
+			mode &= pa->e_perm | ~S_IRWXO;
+			break;
+
+		case ACL_MASK:
+			mask_obj = pa;
+			not_equiv = 1;
+			break;
+
+		default:
+			return -EIO;
+		}
+	}
+
+	if (mask_obj) {
+		mask_obj->e_perm &= (mode >> 3) | ~S_IRWXO;
+		mode &= (mask_obj->e_perm << 3) | ~S_IRWXG;
+	} else {
+		if (!group_obj)
+			return -EIO;
+		group_obj->e_perm &= (mode >> 3) | ~S_IRWXO;
+		mode &= (group_obj->e_perm << 3) | ~S_IRWXG;
+	}
+
+	*mode_p = (*mode_p & ~S_IRWXUGO) | mode;
+        return not_equiv;
+}
+
+static int f2fs_acl_create(struct inode *dir, umode_t *mode,
+		struct posix_acl **default_acl, struct posix_acl **acl,
+		struct page *dpage)
+{
+	struct posix_acl *p;
+	int ret;
+
+	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
+		goto no_acl;
+
+	p = __f2fs_get_acl(dir, ACL_TYPE_DEFAULT, dpage);
+	if (IS_ERR(p)) {
+		if (p == ERR_PTR(-EOPNOTSUPP))
+			goto apply_umask;
+		return PTR_ERR(p);
+	}
+
+	if (!p)
+		goto apply_umask;
+
+	*acl = f2fs_acl_clone(p, GFP_NOFS);
+	if (!*acl)
+		return -ENOMEM;
+
+	ret = f2fs_acl_create_masq(*acl, mode);
+	if (ret < 0) {
+		posix_acl_release(*acl);
+		return -ENOMEM;
+	}
+
+	if (ret == 0) {
+		posix_acl_release(*acl);
+		*acl = NULL;
+	}
+
+	if (!S_ISDIR(*mode)) {
+		posix_acl_release(p);
+		*default_acl = NULL;
+	} else {
+		*default_acl = p;
+	}
+	return 0;
+
+apply_umask:
+	*mode &= ~current_umask();
+no_acl:
+	*default_acl = NULL;
+	*acl = NULL;
+	return 0;
+}
+
+int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage,
+							struct page *dpage)
 {
-	struct posix_acl *default_acl, *acl;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
 	int error = 0;
 
-	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	error = f2fs_acl_create(dir, &inode->i_mode, &default_acl, &acl, dpage);
 	if (error)
 		return error;
 
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index e086465..997ca8e 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -38,14 +38,15 @@ struct f2fs_acl_header {
 
 extern struct posix_acl *f2fs_get_acl(struct inode *, int);
 extern int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-extern int f2fs_init_acl(struct inode *, struct inode *, struct page *);
+extern int f2fs_init_acl(struct inode *, struct inode *, struct page *,
+							struct page *);
 #else
 #define f2fs_check_acl	NULL
 #define f2fs_get_acl	NULL
 #define f2fs_set_acl	NULL
 
 static inline int f2fs_init_acl(struct inode *inode, struct inode *dir,
-							struct page *page)
+				struct page *ipage, struct page *dpage)
 {
 	return 0;
 }
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 644b480..334e227 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -362,8 +362,8 @@ static int make_empty_dir(struct inode *inode,
 	return 0;
 }
 
-struct page *init_inode_metadata(struct inode *inode,
-		struct inode *dir, const struct qstr *name)
+struct page *init_inode_metadata(struct inode *inode, struct inode *dir,
+			const struct qstr *name, struct page *dpage)
 {
 	struct page *page;
 	int err;
@@ -379,7 +379,7 @@ struct page *init_inode_metadata(struct inode *inode,
 				goto error;
 		}
 
-		err = f2fs_init_acl(inode, dir, page);
+		err = f2fs_init_acl(inode, dir, page, dpage);
 		if (err)
 			goto put_error;
 
@@ -540,7 +540,7 @@ add_dentry:
 	f2fs_wait_on_page_writeback(dentry_page, DATA);
 
 	down_write(&F2FS_I(inode)->i_sem);
-	page = init_inode_metadata(inode, dir, name);
+	page = init_inode_metadata(inode, dir, name, NULL);
 	if (IS_ERR(page)) {
 		err = PTR_ERR(page);
 		goto fail;
@@ -579,7 +579,7 @@ int f2fs_do_tmpfile(struct inode *inode, struct inode *dir)
 	int err = 0;
 
 	down_write(&F2FS_I(inode)->i_sem);
-	page = init_inode_metadata(inode, dir, NULL);
+	page = init_inode_metadata(inode, dir, NULL, NULL);
 	if (IS_ERR(page)) {
 		err = PTR_ERR(page);
 		goto fail;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6aad6e0..d4dcd93 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1247,7 +1247,7 @@ void set_de_type(struct f2fs_dir_entry *, struct inode *);
 struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *, const void *,
 			struct f2fs_dir_entry *, __u8 (*)[F2FS_SLOT_LEN]);
 struct page *init_inode_metadata(struct inode *, struct inode *,
-							const struct qstr *);
+			const struct qstr *, struct page *);
 void update_parent_metadata(struct inode *, struct inode *, unsigned int);
 int room_for_filename(const void *, int, int);
 void f2fs_drop_nlink(struct inode *, struct inode *, struct page *);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 6fbdce7..3d44947 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -429,14 +429,14 @@ int f2fs_add_inline_entry(struct inode *dir, const struct qstr *name,
 		goto out;
 	}
 
-	f2fs_wait_on_page_writeback(ipage, NODE);
-
 	down_write(&F2FS_I(inode)->i_sem);
-	page = init_inode_metadata(inode, dir, name);
+	page = init_inode_metadata(inode, dir, name, ipage);
 	if (IS_ERR(page)) {
 		err = PTR_ERR(page);
 		goto fail;
 	}
+
+	f2fs_wait_on_page_writeback(ipage, NODE);
 	de = &dentry_blk->dentry[bit_pos];
 	de->hash_code = name_hash;
 	de->name_len = cpu_to_le16(namelen);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index deca872..5072bf9 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -83,7 +83,7 @@ static int f2fs_xattr_generic_get(struct dentry *dentry, const char *name,
 	}
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
-	return f2fs_getxattr(dentry->d_inode, type, name, buffer, size);
+	return f2fs_getxattr(dentry->d_inode, type, name, buffer, size, NULL);
 }
 
 static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
@@ -398,7 +398,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 }
 
 int f2fs_getxattr(struct inode *inode, int index, const char *name,
-		void *buffer, size_t buffer_size)
+		void *buffer, size_t buffer_size, struct page *ipage)
 {
 	struct f2fs_xattr_entry *entry;
 	void *base_addr;
@@ -412,7 +412,7 @@ int f2fs_getxattr(struct inode *inode, int index, const char *name,
 	if (len > F2FS_NAME_LEN)
 		return -ERANGE;
 
-	base_addr = read_all_xattrs(inode, NULL);
+	base_addr = read_all_xattrs(inode, ipage);
 	if (!base_addr)
 		return -ENOMEM;
 
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index 34ab7db..969d792 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -115,7 +115,8 @@ extern const struct xattr_handler *f2fs_xattr_handlers[];
 
 extern int f2fs_setxattr(struct inode *, int, const char *,
 				const void *, size_t, struct page *, int);
-extern int f2fs_getxattr(struct inode *, int, const char *, void *, size_t);
+extern int f2fs_getxattr(struct inode *, int, const char *, void *,
+						size_t, struct page *);
 extern ssize_t f2fs_listxattr(struct dentry *, char *, size_t);
 #else
 
@@ -126,7 +127,8 @@ static inline int f2fs_setxattr(struct inode *inode, int index,
 	return -EOPNOTSUPP;
 }
 static inline int f2fs_getxattr(struct inode *inode, int index,
-		const char *name, void *buffer, size_t buffer_size)
+			const char *name, void *buffer,
+			size_t buffer_size, struct page *dpage)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.1.1

