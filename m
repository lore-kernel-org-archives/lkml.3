Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3FKLaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:30:22 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47108 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3FKLaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <1370929716.14857.8.camel@lcm>
References: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
	<1370824712.22405.18.camel@lcm>
	<CAKYAXd-V9iF0o5nvFyFPgJX0waDLh4c_eNJ7V_o-tbbrtX1JLQ@mail.gmail.com>
	<1370929716.14857.8.camel@lcm>
Date: Tue, 11 Jun 2013 20:30:17 +0900
Message-ID: <CAKYAXd98cgBU_JzL3zx2qT87H-XdqntdKYbCdOsx9gCeDwUO4Q@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH 1/4] f2fs: reorganize the f2fs_setattr() function.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Changman Lee <cm224.lee@samsung.com>
Cc: jaegeuk.kim@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/11, Changman Lee <cm224.lee@samsung.com>:
> On 화, 2013-06-11 at 07:57 +0900, Namjae Jeon wrote:
>> 2013/6/10, Changman Lee <cm224.lee@samsung.com>:
>> > Hello, Namjae
>> Hi. Changman.
>> >
>> > If using ACL, whenever i_mode is changed we should update acl_mode
>> > which
>> > is written to xattr block, too. And vice versa.
>> > Because update_inode() is called at any reason and anytime, so we
>> > should
>> > sync both the moment xattr is written.
>> > We don't hope that only i_mode is written to disk and xattr is not. So
>> > f2fs_setattr is dirty.
>> Yes, agreed this could be issue.
>> >
>> > And, below code has a bug. When error is occurred, inode->i_mode
>> > shouldn't be changed. Please, check one more time, Namjae.
>> And, below code has a bug. When error is occurred, inode->i_mode
>> shouldn't be changed. Please, check one more time, Namjae.
>>
>> This was part of the default code, when ‘acl’ is not set for file’
>> Then, inode should be updated by these conditions (i.e., it covers the
>> ‘chmod’ and ‘setacl’ scenario).
>> When ACL is not present on the file and ‘chmod’ is done, then mode is
>> changed from this part, as f2fs_get_acl() will fail and cause the
>> below code to be executed:
>>
>>     if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
>>              inode->i_mode = fi->i_acl_mode;
>>              clear_inode_flag(fi, FI_ACL_MODE);
>>       }
>>
>> Now, in order to make it consistent and work on all scenario we need
>> to make further change like this in addition to the patch changes.
>> setattr_copy(inode, attr);
>>         if (attr->ia_valid & ATTR_MODE) {
>> +             set_acl_inode(fi, inode->i_mode);
>>               err = f2fs_acl_chmod(inode);
>>               if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
>>
>> Let me know your opinion.
>> Thanks.
>>
>
> setattr_copy changes inode->i_mode, this is not our expectation.
> So I made redundant __setatt_copy that copy attr->mode to
> fi->i_acl_mode.
> When acl_mode is reflected in xattr, acl_mode is copied to
> inode->i_mode.
>
> Agree?
>
Hi Changman.

First, Sorry for interrupt.
I think that inode i_mode should be updated regardless of f2fs_acl_chmod.
Actually I am still not understand the reason why we should use
temporarily acl mode(i_acl_mode).
I wroted the v2 patch to not use i_acl_mode like this.
Am I missing something ?

----------------------------------------------------------------------------------------------------------------
Subject: [PATCH v2] f2fs: reorganize the f2fs_setattr(), f2fs_set_acl,
f2fs_setxattr()
From: Namjae Jeon <namjae.jeon@samsung.com>

Remove the redundant code from f2fs_setattr() function and make it aligned
with usages of generic vfs layer function e.g using the setattr_copy()
instead of using the f2fs specific function.

Also correct the condition for updating the size of file via truncate_setsize().

Also modify the code of f2fs_set_acl and f2fs_setxattr for removing the
redundant code & add the required changes to correct the requested  operations.

Remove the variable "i_acl_mode" from the f2fs_inode_info struct since
i_mode will
hold the latest 'mode' value which can be used for any further
references. And in
order to make 'chmod' work without ACL support, inode i_mode should be first
updated correctly.

Remove the helper functions to access and set the i_acl_mode.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/acl.c   |   23 +++++++++--------------
 fs/f2fs/f2fs.h  |   17 -----------------
 fs/f2fs/file.c  |   48 ++++++------------------------------------------
 fs/f2fs/xattr.c |    9 ++-------
 4 files changed, 17 insertions(+), 80 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 44abc2f..7ebddf1 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -17,9 +17,6 @@
 #include "xattr.h"
 #include "acl.h"

-#define get_inode_mode(i)	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
-					(F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
-
 static inline size_t f2fs_acl_size(int count)
 {
 	if (count <= 4) {
@@ -208,7 +205,6 @@ struct posix_acl *f2fs_get_acl(struct inode
*inode, int type)
 static int f2fs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int name_index;
 	void *value = NULL;
 	size_t size = 0;
@@ -226,9 +222,12 @@ static int f2fs_set_acl(struct inode *inode, int
type, struct posix_acl *acl)
 			error = posix_acl_equiv_mode(acl, &inode->i_mode);
 			if (error < 0)
 				return error;
-			set_acl_inode(fi, inode->i_mode);
-			if (error == 0)
-				acl = NULL;
+			else {
+				inode->i_ctime = CURRENT_TIME;
+				mark_inode_dirty(inode);
+				if (error == 0)
+					acl = NULL;
+			}
 		}
 		break;

@@ -244,10 +243,8 @@ static int f2fs_set_acl(struct inode *inode, int
type, struct posix_acl *acl)

 	if (acl) {
 		value = f2fs_acl_to_disk(acl, &size);
-		if (IS_ERR(value)) {
-			cond_clear_inode_flag(fi, FI_ACL_MODE);
+		if (IS_ERR(value))
 			return (int)PTR_ERR(value);
-		}
 	}

 	error = f2fs_setxattr(inode, name_index, "", value, size);
@@ -256,7 +253,6 @@ static int f2fs_set_acl(struct inode *inode, int
type, struct posix_acl *acl)
 	if (!error)
 		set_cached_acl(inode, type, acl);

-	cond_clear_inode_flag(fi, FI_ACL_MODE);
 	return error;
 }

@@ -299,18 +295,17 @@ int f2fs_acl_chmod(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct posix_acl *acl;
 	int error;
-	umode_t mode = get_inode_mode(inode);

 	if (!test_opt(sbi, POSIX_ACL))
 		return 0;
-	if (S_ISLNK(mode))
+	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;

 	acl = f2fs_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);

-	error = posix_acl_chmod(&acl, GFP_KERNEL, mode);
+	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
 	error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 40b137a..241ba31 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -159,7 +159,6 @@ struct f2fs_inode_info {
 	unsigned char i_advise;		/* use to give file attribute hints */
 	unsigned int i_current_depth;	/* use only in directory structure */
 	unsigned int i_pino;		/* parent inode number */
-	umode_t i_acl_mode;		/* keep file acl mode temporarily */

 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
@@ -857,7 +856,6 @@ static inline int f2fs_clear_bit(unsigned int nr,
char *addr)
 enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
 	FI_INC_LINK,		/* need to increment i_nlink */
-	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
 	FI_DELAY_IPUT,		/* used for the recovery */
 };
@@ -877,21 +875,6 @@ static inline void clear_inode_flag(struct
f2fs_inode_info *fi, int flag)
 	clear_bit(flag, &fi->flags);
 }

-static inline void set_acl_inode(struct f2fs_inode_info *fi, umode_t mode)
-{
-	fi->i_acl_mode = mode;
-	set_inode_flag(fi, FI_ACL_MODE);
-}
-
-static inline int cond_clear_inode_flag(struct f2fs_inode_info *fi, int flag)
-{
-	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
-		clear_inode_flag(fi, FI_ACL_MODE);
-		return 1;
-	}
-	return 0;
-}
-
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index deefd25..4162fbb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -300,37 +300,6 @@ static int f2fs_getattr(struct vfsmount *mnt,
 	return 0;
 }

-#ifdef CONFIG_F2FS_FS_POSIX_ACL
-static void __setattr_copy(struct inode *inode, const struct iattr *attr)
-{
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	unsigned int ia_valid = attr->ia_valid;
-
-	if (ia_valid & ATTR_UID)
-		inode->i_uid = attr->ia_uid;
-	if (ia_valid & ATTR_GID)
-		inode->i_gid = attr->ia_gid;
-	if (ia_valid & ATTR_ATIME)
-		inode->i_atime = timespec_trunc(attr->ia_atime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MTIME)
-		inode->i_mtime = timespec_trunc(attr->ia_mtime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_CTIME)
-		inode->i_ctime = timespec_trunc(attr->ia_ctime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MODE) {
-		umode_t mode = attr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-		set_acl_inode(fi, mode);
-	}
-}
-#else
-#define __setattr_copy setattr_copy
-#endif
-
 int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
@@ -341,24 +310,19 @@ int f2fs_setattr(struct dentry *dentry, struct
iattr *attr)
 	if (err)
 		return err;

-	if ((attr->ia_valid & ATTR_SIZE) &&
-			attr->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attr->ia_size);
+	if ((attr->ia_valid & ATTR_SIZE)) {
+		if (attr->ia_size != i_size_read(inode))
+			truncate_setsize(inode, attr->ia_size);
 		f2fs_truncate(inode);
 		f2fs_balance_fs(F2FS_SB(inode->i_sb));
 	}

-	__setattr_copy(inode, attr);
+	setattr_copy(inode, attr);
+	mark_inode_dirty(inode);

-	if (attr->ia_valid & ATTR_MODE) {
+	if (attr->ia_valid & ATTR_MODE)
 		err = f2fs_acl_chmod(inode);
-		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
-			inode->i_mode = fi->i_acl_mode;
-			clear_inode_flag(fi, FI_ACL_MODE);
-		}
-	}

-	mark_inode_dirty(inode);
 	return err;
 }

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 0b02dce..8f02acf 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -333,7 +333,6 @@ int f2fs_setxattr(struct inode *inode, int
name_index, const char *name,
 			goto exit;
 		}
 		set_new_dnode(&dn, inode, NULL, NULL, fi->i_xattr_nid);
-		mark_inode_dirty(inode);

 		page = new_node_page(&dn, XATTR_NODE_OFFSET);
 		if (IS_ERR(page)) {
@@ -430,12 +429,8 @@ int f2fs_setxattr(struct inode *inode, int
name_index, const char *name,
 	set_page_dirty(page);
 	f2fs_put_page(page, 1);

-	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
-		inode->i_mode = fi->i_acl_mode;
-		inode->i_ctime = CURRENT_TIME;
-		clear_inode_flag(fi, FI_ACL_MODE);
-	}
-	update_inode_page(inode);
+	inode->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(inode);
 	mutex_unlock_op(sbi, ilock);

 	return 0;
-- 
1.7.2.3
