Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3IXUyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:54:32 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:35620 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3IXUya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:54:30 -0400
MIME-Version: 1.0
From: Russ Knize <Russ.Knize@motorola.com>
Date: Tue, 24 Sep 2013 15:53:56 -0500
Message-ID: <CAGfvh62J=rkvAw_nxEt1CSE9EhDQqnow+waQJ_gNt1YmkrD9wg@mail.gmail.com>
Subject: Re: [RFC 1/1] f2fs: don't GC or take an fs_lock from f2fs_initxattrs()
To: Russ Knize <rknize@gmail.com>
Cc: "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an alternate solution to the deadlock problem I mentioned in
my previous patch.

On Tue, Sep 24, 2013 at 3:49 PM, Russ Knize <rknize@gmail.com> wrote:
> From: Russ Knize <Russ.Knize@motorola.com>
>
> f2fs_initxattrs() is called internally from within F2FS and should
> not call functions that are used by VFS handlers.  This avoids
> certain deadlocks:
>
> - vfs_create()
>  - f2fs_create() <-- takes an fs_lock
>   - f2fs_add_link()
>    - __f2fs_add_link()
>     - init_inode_metadata()
>      - f2fs_init_security()
>       - security_inode_init_security()
>        - f2fs_initxattrs()
>         - f2fs_setxattr() <-- also takes an fs_lock
>
> If the caller happens to grab the same fs_lock from the pool in both
> places, they will deadlock.  There are also deadlocks involving
> multiple threads and mutexes:
>
> - f2fs_write_begin()
>  - f2fs_balance_fs() <-- takes gc_mutex
>   - f2fs_gc()
>    - write_checkpoint()
>     - block_operations()
>      - mutex_lock_all() <-- blocks trying to grab all fs_locks
>
> - f2fs_mkdir() <-- takes an fs_lock
>  - __f2fs_add_link()
>   - f2fs_init_security()
>    - security_inode_init_security()
>     - f2fs_initxattrs()
>      - f2fs_setxattr()
>       - f2fs_balance_fs() <-- blocks trying to take gc_mutex
>
> Signed-off-by: Russ Knize <Russ.Knize@motorola.com>
> ---
>  fs/f2fs/xattr.c |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
>
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 1ac8a5f..3d900ea 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -154,6 +154,9 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
>  }
>
>  #ifdef CONFIG_F2FS_FS_SECURITY
> +static int __f2fs_setxattr(struct inode *inode, int name_index,
> +                       const char *name, const void *value, size_t value_len,
> +                       struct page *ipage);
>  static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>                 void *page)
>  {
> @@ -161,7 +164,7 @@ static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>         int err = 0;
>
>         for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -               err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
> +               err = __f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
>                                 xattr->name, xattr->value,
>                                 xattr->value_len, (struct page *)page);
>                 if (err < 0)
> @@ -469,16 +472,15 @@ cleanup:
>         return error;
>  }
>
> -int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> -                       const void *value, size_t value_len, struct page *ipage)
> +static int __f2fs_setxattr(struct inode *inode, int name_index,
> +                       const char *name, const void *value, size_t value_len,
> +                       struct page *ipage)
>  {
> -       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>         struct f2fs_inode_info *fi = F2FS_I(inode);
>         struct f2fs_xattr_entry *here, *last;
>         void *base_addr;
>         int found, newsize;
>         size_t name_len;
> -       int ilock;
>         __u32 new_hsize;
>         int error = -ENOMEM;
>
> @@ -493,10 +495,6 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
>         if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN(inode))
>                 return -ERANGE;
>
> -       f2fs_balance_fs(sbi);
> -
> -       ilock = mutex_lock_op(sbi);
> -
>         base_addr = read_all_xattrs(inode, ipage);
>         if (!base_addr)
>                 goto exit;
> @@ -578,7 +576,24 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
>         else
>                 update_inode_page(inode);
>  exit:
> -       mutex_unlock_op(sbi, ilock);
>         kzfree(base_addr);
>         return error;
>  }
> +
> +int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> +                       const void *value, size_t value_len, struct page *ipage)
> +{
> +       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +       int ilock;
> +       int err;
> +
> +       f2fs_balance_fs(sbi);
> +
> +       ilock = mutex_lock_op(sbi);
> +
> +       err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
> +
> +       mutex_unlock_op(sbi, ilock);
> +
> +       return err;
> +}
> --
> 1.7.10.4
>
