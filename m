Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3FJW5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:57:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47115 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3FJW5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:57:22 -0400
MIME-Version: 1.0
In-Reply-To: <1370824712.22405.18.camel@lcm>
References: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
	<1370824712.22405.18.camel@lcm>
Date: Tue, 11 Jun 2013 07:57:21 +0900
Message-ID: <CAKYAXd-V9iF0o5nvFyFPgJX0waDLh4c_eNJ7V_o-tbbrtX1JLQ@mail.gmail.com>
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

2013/6/10, Changman Lee <cm224.lee@samsung.com>:
> Hello, Namjae
Hi. Changman.
>
> If using ACL, whenever i_mode is changed we should update acl_mode which
> is written to xattr block, too. And vice versa.
> Because update_inode() is called at any reason and anytime, so we should
> sync both the moment xattr is written.
> We don't hope that only i_mode is written to disk and xattr is not. So
> f2fs_setattr is dirty.
Yes, agreed this could be issue.
>
> And, below code has a bug. When error is occurred, inode->i_mode
> shouldn't be changed. Please, check one more time, Namjae.
And, below code has a bug. When error is occurred, inode->i_mode
shouldn't be changed. Please, check one more time, Namjae.

This was part of the default code, when ‘acl’ is not set for file’
Then, inode should be updated by these conditions (i.e., it covers the
‘chmod’ and ‘setacl’ scenario).
When ACL is not present on the file and ‘chmod’ is done, then mode is
changed from this part, as f2fs_get_acl() will fail and cause the
below code to be executed:

    if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
             inode->i_mode = fi->i_acl_mode;
             clear_inode_flag(fi, FI_ACL_MODE);
      }

Now, in order to make it consistent and work on all scenario we need
to make further change like this in addition to the patch changes.
setattr_copy(inode, attr);
        if (attr->ia_valid & ATTR_MODE) {
+             set_acl_inode(fi, inode->i_mode);
              err = f2fs_acl_chmod(inode);
              if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {

Let me know your opinion.
Thanks.

>
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index deefd25..29cd449 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -352,10 +352,8 @@ int f2fs_setattr(struct dentry *dentry, struct
> iattr *attr)
>
>         if (attr->ia_valid & ATTR_MODE) {
>                 err = f2fs_acl_chmod(inode);
> -               if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
> -                       inode->i_mode = fi->i_acl_mode;
> +               if (err || is_inode_flag_set(fi, FI_ACL_MODE))
>                         clear_inode_flag(fi, FI_ACL_MODE);
> -               }
>         }
>
> Thanks.
>
>
> On 토, 2013-06-08 at 21:25 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Remove the redundant code from this function and make it aligned with
>> usages of latest generic vfs layer function e.g using the setattr_copy()
>> instead of using the f2fs specific function.
>>
>> Also correct the condition for updating the size of file via
>> truncate_setsize().
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> ---
>>  fs/f2fs/acl.c  |    5 +----
>>  fs/f2fs/file.c |   47 +++++------------------------------------------
>>  2 files changed, 6 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
>> index 44abc2f..2d13f44 100644
>> --- a/fs/f2fs/acl.c
>> +++ b/fs/f2fs/acl.c
>> @@ -17,9 +17,6 @@
>>  #include "xattr.h"
>>  #include "acl.h"
>>
>> -#define get_inode_mode(i)	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ?
>> \
>> -					(F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
>> -
>>  static inline size_t f2fs_acl_size(int count)
>>  {
>>  	if (count <= 4) {
>> @@ -299,7 +296,7 @@ int f2fs_acl_chmod(struct inode *inode)
>>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>>  	struct posix_acl *acl;
>>  	int error;
>> -	umode_t mode = get_inode_mode(inode);
>> +	umode_t mode = inode->i_mode;
>>
>>  	if (!test_opt(sbi, POSIX_ACL))
>>  		return 0;
>> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
>> index deefd25..8dfc1da 100644
>> --- a/fs/f2fs/file.c
>> +++ b/fs/f2fs/file.c
>> @@ -300,63 +300,26 @@ static int f2fs_getattr(struct vfsmount *mnt,
>>  	return 0;
>>  }
>>
>> -#ifdef CONFIG_F2FS_FS_POSIX_ACL
>> -static void __setattr_copy(struct inode *inode, const struct iattr
>> *attr)
>> -{
>> -	struct f2fs_inode_info *fi = F2FS_I(inode);
>> -	unsigned int ia_valid = attr->ia_valid;
>> -
>> -	if (ia_valid & ATTR_UID)
>> -		inode->i_uid = attr->ia_uid;
>> -	if (ia_valid & ATTR_GID)
>> -		inode->i_gid = attr->ia_gid;
>> -	if (ia_valid & ATTR_ATIME)
>> -		inode->i_atime = timespec_trunc(attr->ia_atime,
>> -						inode->i_sb->s_time_gran);
>> -	if (ia_valid & ATTR_MTIME)
>> -		inode->i_mtime = timespec_trunc(attr->ia_mtime,
>> -						inode->i_sb->s_time_gran);
>> -	if (ia_valid & ATTR_CTIME)
>> -		inode->i_ctime = timespec_trunc(attr->ia_ctime,
>> -						inode->i_sb->s_time_gran);
>> -	if (ia_valid & ATTR_MODE) {
>> -		umode_t mode = attr->ia_mode;
>> -
>> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>> -			mode &= ~S_ISGID;
>> -		set_acl_inode(fi, mode);
>> -	}
>> -}
>> -#else
>> -#define __setattr_copy setattr_copy
>> -#endif
>> -
>>  int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
>>  {
>>  	struct inode *inode = dentry->d_inode;
>> -	struct f2fs_inode_info *fi = F2FS_I(inode);
>>  	int err;
>>
>>  	err = inode_change_ok(inode, attr);
>>  	if (err)
>>  		return err;
>>
>> -	if ((attr->ia_valid & ATTR_SIZE) &&
>> -			attr->ia_size != i_size_read(inode)) {
>> -		truncate_setsize(inode, attr->ia_size);
>> +	if ((attr->ia_valid & ATTR_SIZE)) {
>> +		if (attr->ia_size != i_size_read(inode))
>> +			truncate_setsize(inode, attr->ia_size);
>>  		f2fs_truncate(inode);
>>  		f2fs_balance_fs(F2FS_SB(inode->i_sb));
>>  	}
>>
>> -	__setattr_copy(inode, attr);
>> +	setattr_copy(inode, attr);
>>
>> -	if (attr->ia_valid & ATTR_MODE) {
>> +	if (attr->ia_valid & ATTR_MODE)
>>  		err = f2fs_acl_chmod(inode);
>> -		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
>> -			inode->i_mode = fi->i_acl_mode;
>> -			clear_inode_flag(fi, FI_ACL_MODE);
>> -		}
>> -	}
>>
>>  	mark_inode_dirty(inode);
>>  	return err;
>
>
>
