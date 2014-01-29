Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaA2Qgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:36:54 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33573 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaA2Qgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:36:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1401290623040.27886@cobra.newdream.net>
References: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net>
	<20140128211021.GB1377@redhat.com>
	<CA+55aFxmQZ+sAC+_a=QXUSVQ1e=cSVkeZVL4d8kawFp9N5eS-w@mail.gmail.com>
	<alpine.DEB.2.00.1401282145410.17720@cobra.newdream.net>
	<alpine.DEB.2.00.1401290623040.27886@cobra.newdream.net>
Date: Wed, 29 Jan 2014 18:36:48 +0200
Message-ID: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for -rc1
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Sage Weil <sage@inktank.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 4:30 PM, Sage Weil <sage@inktank.com> wrote:
> On Tue, 28 Jan 2014, Sage Weil wrote:
>> Hi Linus,
>>
>> On Tue, 28 Jan 2014, Linus Torvalds wrote:
>> > On Tue, Jan 28, 2014 at 1:10 PM, Dave Jones <davej@redhat.com> wrote:
>> > >
>> > > This breaks the build for me.
>> >
>> > It is my merge (Christoph's ACL changes came in today through the VFS
>> > tree from Al).
>> >
>> > I was doing the merges today on my laptop (I had jury duty yesterday
>> > and today), and so I didn't do the allmodconfig build I would normally
>> > do on my (much faster) desktop. Well, actually I did do the full fs
>> > builds for the earlier pulls that actually had some conflicts, but not
>> > for the ceph pull. The conflict was hidden by the fact that the whole
>> > cifs ACL support is new, so there was no data conflict, just a silent
>> > semantic conflict between the new smarter ACL helpers and the new ACL
>> > use in CIFS.
>>
>> s/cifs/ceph/ :)
>>
>> > I'm back home now (yay, all the afternoon cases got settled), and I
>> > see the problem now. I should have done an allmodconfig build
>> > immediately after coming home, but I never even thought of it.
>> >
>> > Anyway, here's an *untested* conversion to the new posix acl helper
>> > infrastructure. I do wonder if ceph_init_acl() could be converted to
>> > posix_acl_create(), right now that part is a "non-conversion" - it's
>> > just made to use __posix_acl_create() that implements the old
>> > interface.
>> >
>> > Al, Christoph, can you please check my conversion for sanity from a
>> > generic posix-acl standpoint?
>> >
>> > Sage, Guangliang, Li, can you check the actual cifs usage/sanity of
>> > the attached patch?
>>
>> Superficially at least the conversion looks okay to me, but it's not
>> passing my smoke test (it's giving me EOPNOTSUPP for chmod and setxattr
>> when setting an ACL).  I'll look at it tomorrow if Guangliang, Li, or Yan
>> don't get there first.
>
> The set_acl inode_operation wasn't getting set, and the prototype needed
> to be adjusted a bit (it doesn't take a dentry anymore).  All seems to be
> well with the below patch.
>
> Thanks!
> sage
>
>
> From 01baa54e113060eb9147548fe7beb572522a645a Mon Sep 17 00:00:00 2001
> From: Sage Weil <sage@inktank.com>
> Date: Wed, 29 Jan 2014 06:22:25 -0800
> Subject: [PATCH] ceph: fix posix ACL hooks
>
> The merge of 7221fe4c2 raced with upstream changes in the generic POSIX
> ACL code (2aeccbe95).  Update Ceph to use the new helpers as well by
> dropping the now-generic functions and setting the set_acl inode op.
>
> Signed-off-by: Sage Weil <sage@inktank.com>
> ---
>  fs/ceph/acl.c   | 112 +++-----------------------------------------------------
>  fs/ceph/dir.c   |   1 +
>  fs/ceph/inode.c |   5 ++-
>  fs/ceph/super.h |   5 +--
>  fs/ceph/xattr.c |   5 ++-
>  5 files changed, 15 insertions(+), 113 deletions(-)
>
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 64fddbc..66d377a 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -107,14 +107,14 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type)
>         return acl;
>  }
>
> -static int ceph_set_acl(struct dentry *dentry, struct inode *inode,
> -                               struct posix_acl *acl, int type)
> +int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>         int ret = 0, size = 0;
>         const char *name = NULL;
>         char *value = NULL;
>         struct iattr newattrs;
>         umode_t new_mode = inode->i_mode, old_mode = inode->i_mode;
> +       struct dentry *dentry = d_find_alias(inode);
>
>         if (acl) {
>                 ret = posix_acl_valid(acl);
> @@ -208,16 +208,15 @@ int ceph_init_acl(struct dentry *dentry, struct inode *inode, struct inode *dir)
>
>         if (IS_POSIXACL(dir) && acl) {
>                 if (S_ISDIR(inode->i_mode)) {
> -                       ret = ceph_set_acl(dentry, inode, acl,
> -                                               ACL_TYPE_DEFAULT);
> +                       ret = ceph_set_acl(inode, acl, ACL_TYPE_DEFAULT);
>                         if (ret)
>                                 goto out_release;
>                 }
> -               ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> +               ret = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
>                 if (ret < 0)
>                         goto out;
>                 else if (ret > 0)
> -                       ret = ceph_set_acl(dentry, inode, acl, ACL_TYPE_ACCESS);
> +                       ret = ceph_set_acl(inode, acl, ACL_TYPE_ACCESS);
>                 else
>                         cache_no_acl(inode);
>         } else {
> @@ -229,104 +228,3 @@ out_release:
>  out:
>         return ret;
>  }
> -
> -int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
> -{
> -       struct posix_acl *acl;
> -       int ret = 0;
> -
> -       if (S_ISLNK(inode->i_mode)) {
> -               ret = -EOPNOTSUPP;
> -               goto out;
> -       }
> -
> -       if (!IS_POSIXACL(inode))
> -               goto out;
> -
> -       acl = ceph_get_acl(inode, ACL_TYPE_ACCESS);
> -       if (IS_ERR_OR_NULL(acl)) {
> -               ret = PTR_ERR(acl);
> -               goto out;
> -       }
> -
> -       ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> -       if (ret)
> -               goto out;
> -       ret = ceph_set_acl(dentry, inode, acl, ACL_TYPE_ACCESS);
> -       posix_acl_release(acl);
> -out:
> -       return ret;
> -}
> -
> -static int ceph_xattr_acl_get(struct dentry *dentry, const char *name,
> -                               void *value, size_t size, int type)
> -{
> -       struct posix_acl *acl;
> -       int ret = 0;
> -
> -       if (!IS_POSIXACL(dentry->d_inode))
> -               return -EOPNOTSUPP;
> -
> -       acl = ceph_get_acl(dentry->d_inode, type);
> -       if (IS_ERR(acl))
> -               return PTR_ERR(acl);
> -       if (acl == NULL)
> -               return -ENODATA;
> -
> -       ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
> -       posix_acl_release(acl);
> -
> -       return ret;
> -}
> -
> -static int ceph_xattr_acl_set(struct dentry *dentry, const char *name,
> -                       const void *value, size_t size, int flags, int type)
> -{
> -       int ret = 0;
> -       struct posix_acl *acl = NULL;
> -
> -       if (!inode_owner_or_capable(dentry->d_inode)) {
> -               ret = -EPERM;
> -               goto out;
> -       }
> -
> -       if (!IS_POSIXACL(dentry->d_inode)) {
> -               ret = -EOPNOTSUPP;
> -               goto out;
> -       }
> -
> -       if (value) {
> -               acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -               if (IS_ERR(acl)) {
> -                       ret = PTR_ERR(acl);
> -                       goto out;
> -               }
> -
> -               if (acl) {
> -                       ret = posix_acl_valid(acl);
> -                       if (ret)
> -                               goto out_release;
> -               }
> -       }
> -
> -       ret = ceph_set_acl(dentry, dentry->d_inode, acl, type);
> -
> -out_release:
> -       posix_acl_release(acl);
> -out:
> -       return ret;
> -}
> -
> -const struct xattr_handler ceph_xattr_acl_default_handler = {
> -       .prefix = POSIX_ACL_XATTR_DEFAULT,
> -       .flags  = ACL_TYPE_DEFAULT,
> -       .get    = ceph_xattr_acl_get,
> -       .set    = ceph_xattr_acl_set,
> -};
> -
> -const struct xattr_handler ceph_xattr_acl_access_handler = {
> -       .prefix = POSIX_ACL_XATTR_ACCESS,
> -       .flags  = ACL_TYPE_ACCESS,
> -       .get    = ceph_xattr_acl_get,
> -       .set    = ceph_xattr_acl_set,
> -};
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 619616d..6da4df8 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1303,6 +1303,7 @@ const struct inode_operations ceph_dir_iops = {
>         .listxattr = ceph_listxattr,
>         .removexattr = ceph_removexattr,
>         .get_acl = ceph_get_acl,
> +       .set_acl = ceph_set_acl,
>         .mknod = ceph_mknod,
>         .symlink = ceph_symlink,
>         .mkdir = ceph_mkdir,
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 6fc10a7..32d519d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -9,6 +9,7 @@
>  #include <linux/namei.h>
>  #include <linux/writeback.h>
>  #include <linux/vmalloc.h>
> +#include <linux/posix_acl.h>
>
>  #include "super.h"
>  #include "mds_client.h"
> @@ -96,6 +97,7 @@ const struct inode_operations ceph_file_iops = {
>         .listxattr = ceph_listxattr,
>         .removexattr = ceph_removexattr,
>         .get_acl = ceph_get_acl,
> +       .set_acl = ceph_set_acl,
>  };
>
>
> @@ -1615,6 +1617,7 @@ static const struct inode_operations ceph_symlink_iops = {
>         .listxattr = ceph_listxattr,
>         .removexattr = ceph_removexattr,
>         .get_acl = ceph_get_acl,
> +       .set_acl = ceph_set_acl,
>  };
>
>  /*
> @@ -1805,7 +1808,7 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
>                 __mark_inode_dirty(inode, inode_dirty_flags);
>
>         if (ia_valid & ATTR_MODE) {
> -               err = ceph_acl_chmod(dentry, inode);
> +               err = posix_acl_chmod(inode, attr->ia_mode);
>                 if (err)
>                         goto out_put;
>         }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index c299f7d..eabf601 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -718,6 +718,7 @@ extern void ceph_queue_writeback(struct inode *inode);
>  extern int ceph_do_getattr(struct inode *inode, int mask);
>  extern int ceph_permission(struct inode *inode, int mask);
>  extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
> +extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
>  extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
>                         struct kstat *stat);
>
> @@ -736,15 +737,13 @@ extern void __init ceph_xattr_init(void);
>  extern void ceph_xattr_exit(void);
>
>  /* acl.c */
> -extern const struct xattr_handler ceph_xattr_acl_access_handler;
> -extern const struct xattr_handler ceph_xattr_acl_default_handler;
>  extern const struct xattr_handler *ceph_xattr_handlers[];
>
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>
>  struct posix_acl *ceph_get_acl(struct inode *, int);
> +int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  int ceph_init_acl(struct dentry *, struct inode *, struct inode *);
> -int ceph_acl_chmod(struct dentry *, struct inode *);
>  void ceph_forget_all_cached_acls(struct inode *inode);
>
>  #else

Sage missed the '#define ceph_set_acl NULL' for the !CEPH_FS_POSIX_ACL
case.  v2 should be in-reply-to this message.

Thanks,

                Ilya
