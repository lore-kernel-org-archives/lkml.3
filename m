Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaJVVry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:47:54 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64931 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaJVVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com> <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Oct 2014 14:47:29 -0700
Message-ID: <CALCETrVNEM4JYWam2b5z9FF2wRwUg9xTDz6QsVWcnrKtADsLMA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 2:24 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> Update fuse to translate uids and gids to/from the user namspace
> of the process servicing requests on /dev/fuse. Any ids which do
> not map into the namespace will result in errors. inodes will
> also be marked bad when unmappable ids are received from
> userspace.
>
> Due to security concerns the namespace used should be fixed,
> otherwise a user might be able to gain elevated privileges or
> influence processes that the user would otherwise be unable to
> manipulate. Thus the namespace of the mounting process is used
> for all translations, and this namespace is required to be the
> same as the one in use when /dev/fuse was opened.

Looks generally sensible to me.  I'm not familiar enough with this
code to really review it, though.

>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  fs/fuse/dev.c    |  4 +--
>  fs/fuse/dir.c    | 81 ++++++++++++++++++++++++++++++++++++--------------------
>  fs/fuse/fuse_i.h | 12 ++++++---
>  fs/fuse/inode.c  | 73 +++++++++++++++++++++++++++++++++++++++-----------
>  4 files changed, 121 insertions(+), 49 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 839caebd34f1..03c8785ed731 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -127,8 +127,8 @@ static void __fuse_put_request(struct fuse_req *req)
>
>  static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
>  {
> -       req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
> -       req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> +       req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
> +       req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
>         req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
>  }
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index de1d84af9f7c..123db1e06c78 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -253,9 +253,12 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
>                 if (err || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
>                         goto invalid;
>
> -               fuse_change_attributes(inode, &outarg.attr,
> -                                      entry_attr_timeout(&outarg),
> -                                      attr_version);
> +               err = fuse_change_attributes(inode, &outarg.attr,
> +                                            entry_attr_timeout(&outarg),
> +                                            attr_version);
> +               if (err)
> +                       goto invalid;
> +
>                 fuse_change_entry_timeout(entry, &outarg);
>         } else if (inode) {
>                 fi = get_fuse_inode(inode);
> @@ -340,8 +343,9 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
>         *inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
>                            &outarg->attr, entry_attr_timeout(outarg),
>                            attr_version);
> -       err = -ENOMEM;
> -       if (!*inode) {
> +       if (IS_ERR(*inode)) {
> +               err = PTR_ERR(*inode);
> +               *inode = NULL;
>                 fuse_queue_forget(fc, forget, outarg->nodeid, 1);
>                 goto out;
>         }
> @@ -473,11 +477,11 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
>         ff->open_flags = outopen.open_flags;
>         inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
>                           &outentry.attr, entry_attr_timeout(&outentry), 0);
> -       if (!inode) {
> +       if (IS_ERR(inode)) {
>                 flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
>                 fuse_sync_release(ff, flags);
>                 fuse_queue_forget(fc, forget, outentry.nodeid, 1);
> -               err = -ENOMEM;
> +               err = PTR_ERR(inode);
>                 goto out_err;
>         }
>         kfree(forget);
> @@ -588,9 +592,9 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_req *req,
>
>         inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
>                           &outarg.attr, entry_attr_timeout(&outarg), 0);
> -       if (!inode) {
> +       if (IS_ERR(inode)) {
>                 fuse_queue_forget(fc, forget, outarg.nodeid, 1);
> -               return -ENOMEM;
> +               return PTR_ERR(inode);
>         }
>         kfree(forget);
>
> @@ -905,8 +909,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>         stat->ino = attr->ino;
>         stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
>         stat->nlink = attr->nlink;
> -       stat->uid = make_kuid(&init_user_ns, attr->uid);
> -       stat->gid = make_kgid(&init_user_ns, attr->gid);
> +       stat->uid = inode->i_uid;
> +       stat->gid = inode->i_gid;
>         stat->rdev = inode->i_rdev;
>         stat->atime.tv_sec = attr->atime;
>         stat->atime.tv_nsec = attr->atimensec;
> @@ -969,10 +973,10 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
>                         make_bad_inode(inode);
>                         err = -EIO;
>                 } else {
> -                       fuse_change_attributes(inode, &outarg.attr,
> -                                              attr_timeout(&outarg),
> -                                              attr_version);
> -                       if (stat)
> +                       err = fuse_change_attributes(inode, &outarg.attr,
> +                                                    attr_timeout(&outarg),
> +                                                    attr_version);
> +                       if (!err && stat)
>                                 fuse_fillattr(inode, &outarg.attr, stat);
>                 }
>         }
> @@ -1302,9 +1306,11 @@ static int fuse_direntplus_link(struct file *file,
>                         fi->nlookup++;
>                         spin_unlock(&fc->lock);
>
> -                       fuse_change_attributes(inode, &o->attr,
> -                                              entry_attr_timeout(o),
> -                                              attr_version);
> +                       err = fuse_change_attributes(inode, &o->attr,
> +                                                    entry_attr_timeout(o),
> +                                                    attr_version);
> +                       if (err)
> +                               goto out;
>
>                         /*
>                          * The other branch to 'found' comes via fuse_iget()
> @@ -1322,8 +1328,10 @@ static int fuse_direntplus_link(struct file *file,
>
>         inode = fuse_iget(dir->i_sb, o->nodeid, o->generation,
>                           &o->attr, entry_attr_timeout(o), attr_version);
> -       if (!inode)
> +       if (IS_ERR(inode)) {
> +               err = PTR_ERR(inode);
>                 goto out;
> +       }
>
>         alias = d_materialise_unique(dentry, inode);
>         err = PTR_ERR(alias);
> @@ -1556,17 +1564,25 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
>         return true;
>  }
>
> -static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
> -                          bool trust_local_cmtime)
> +static int iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
> +                          struct fuse_setattr_in *arg, bool trust_local_cmtime)
>  {
>         unsigned ivalid = iattr->ia_valid;
>
>         if (ivalid & ATTR_MODE)
>                 arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
> -       if (ivalid & ATTR_UID)
> -               arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
> -       if (ivalid & ATTR_GID)
> -               arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
> +       if (ivalid & ATTR_UID) {
> +               arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
> +               if (arg->uid == (uid_t)-1)
> +                       return -EINVAL;
> +               arg->valid |= FATTR_UID;
> +       }
> +       if (ivalid & ATTR_GID) {
> +               arg->gid = from_kgid(fc->user_ns, iattr->ia_gid);
> +               if (arg->gid == (gid_t)-1)
> +                       return -EINVAL;
> +               arg->valid |= FATTR_GID;
> +       }
>         if (ivalid & ATTR_SIZE)
>                 arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
>         if (ivalid & ATTR_ATIME) {
> @@ -1588,6 +1604,8 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
>                 arg->ctime = iattr->ia_ctime.tv_sec;
>                 arg->ctimensec = iattr->ia_ctime.tv_nsec;
>         }
> +
> +       return 0;
>  }
>
>  /*
> @@ -1741,7 +1759,9 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
>
>         memset(&inarg, 0, sizeof(inarg));
>         memset(&outarg, 0, sizeof(outarg));
> -       iattr_to_fattr(attr, &inarg, trust_local_cmtime);
> +       err = iattr_to_fattr(fc, attr, &inarg, trust_local_cmtime);
> +       if (err)
> +               goto error;
>         if (file) {
>                 struct fuse_file *ff = file->private_data;
>                 inarg.valid |= FATTR_FH;
> @@ -1778,8 +1798,13 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
>                 /* FIXME: clear I_DIRTY_SYNC? */
>         }
>
> -       fuse_change_attributes_common(inode, &outarg.attr,
> -                                     attr_timeout(&outarg));
> +       err = fuse_change_attributes_common(inode, &outarg.attr,
> +                                           attr_timeout(&outarg));
> +       if (err) {
> +               spin_unlock(&fc->lock);
> +               goto error;
> +       }
> +
>         oldsize = inode->i_size;
>         /* see the comment in fuse_change_attributes() */
>         if (!is_wb || is_truncate || !S_ISREG(inode->i_mode))
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index a3ded071e2c6..81187ba04e4a 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -22,6 +22,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/poll.h>
>  #include <linux/workqueue.h>
> +#include <linux/user_namespace.h>
>  #include <linux/pid_namespace.h>
>
>  /** Max number of pages that can be used in a single read request */
> @@ -387,6 +388,9 @@ struct fuse_conn {
>         /** The group id for this mount */
>         kgid_t group_id;
>
> +       /** The user namespace for this mount */
> +       struct user_namespace *user_ns;
> +
>         /** The pid namespace for this mount */
>         struct pid_namespace *pid_ns;
>
> @@ -713,11 +717,11 @@ void fuse_init_symlink(struct inode *inode);
>  /**
>   * Change attributes of an inode
>   */
> -void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
> -                           u64 attr_valid, u64 attr_version);
> +int fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
> +                          u64 attr_valid, u64 attr_version);
>
> -void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> -                                  u64 attr_valid);
> +int fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> +                                 u64 attr_valid);
>
>  /**
>   * Initialize the client device
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index e137969815a3..b88b5a780228 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -155,11 +155,22 @@ static ino_t fuse_squash_ino(u64 ino64)
>         return ino;
>  }
>
> -void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> -                                  u64 attr_valid)
> +int fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> +                                 u64 attr_valid)
>  {
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_inode *fi = get_fuse_inode(inode);
> +       kuid_t uid;
> +       kgid_t gid;
> +
> +       uid = make_kuid(fc->user_ns, attr->uid);
> +       gid = make_kgid(fc->user_ns, attr->gid);
> +       if (!uid_valid(uid) || !gid_valid(gid)) {
> +               make_bad_inode(inode);
> +               return -EIO;
> +       }
> +       inode->i_uid = uid;
> +       inode->i_gid = gid;
>
>         fi->attr_version = ++fc->attr_version;
>         fi->i_time = attr_valid;
> @@ -167,8 +178,6 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
>         inode->i_ino     = fuse_squash_ino(attr->ino);
>         inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
>         set_nlink(inode, attr->nlink);
> -       inode->i_uid     = make_kuid(&init_user_ns, attr->uid);
> -       inode->i_gid     = make_kgid(&init_user_ns, attr->gid);
>         inode->i_blocks  = attr->blocks;
>         inode->i_atime.tv_sec   = attr->atime;
>         inode->i_atime.tv_nsec  = attr->atimensec;
> @@ -195,26 +204,32 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
>                 inode->i_mode &= ~S_ISVTX;
>
>         fi->orig_ino = attr->ino;
> +       return 0;
>  }
>
> -void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
> -                           u64 attr_valid, u64 attr_version)
> +int fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
> +                          u64 attr_valid, u64 attr_version)
>  {
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_inode *fi = get_fuse_inode(inode);
>         bool is_wb = fc->writeback_cache;
>         loff_t oldsize;
>         struct timespec old_mtime;
> +       int err;
>
>         spin_lock(&fc->lock);
>         if ((attr_version != 0 && fi->attr_version > attr_version) ||
>             test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
>                 spin_unlock(&fc->lock);
> -               return;
> +               return 0;
>         }
>
>         old_mtime = inode->i_mtime;
> -       fuse_change_attributes_common(inode, attr, attr_valid);
> +       err = fuse_change_attributes_common(inode, attr, attr_valid);
> +       if (err) {
> +               spin_unlock(&fc->lock);
> +               return err;
> +       }
>
>         oldsize = inode->i_size;
>         /*
> @@ -249,6 +264,8 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>                 if (inval)
>                         invalidate_inode_pages2(inode->i_mapping);
>         }
> +
> +       return 0;
>  }
>
>  static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
> @@ -302,7 +319,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
>   retry:
>         inode = iget5_locked(sb, nodeid, fuse_inode_eq, fuse_inode_set, &nodeid);
>         if (!inode)
> -               return NULL;
> +               return ERR_PTR(-ENOMEM);
>
>         if ((inode->i_state & I_NEW)) {
>                 inode->i_flags |= S_NOATIME;
> @@ -319,11 +336,23 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
>                 goto retry;
>         }
>
> +       /*
> +        * Must do this before incrementing nlookup, as the caller will
> +        * send a forget for the node if this function fails.
> +        */
> +       if (fuse_change_attributes(inode, attr, attr_valid, attr_version)) {
> +               /*
> +                * inode_make_bad() already called by
> +                * fuse_change_attributes()
> +                */
> +               iput(inode);
> +               return ERR_PTR(-EIO);
> +       }
> +
>         fi = get_fuse_inode(inode);
>         spin_lock(&fc->lock);
>         fi->nlookup++;
>         spin_unlock(&fc->lock);
> -       fuse_change_attributes(inode, attr, attr_valid, attr_version);
>
>         return inode;
>  }
> @@ -496,6 +525,8 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
>         memset(d, 0, sizeof(struct fuse_mount_data));
>         d->max_read = ~0;
>         d->blksize = FUSE_DEFAULT_BLKSIZE;
> +       d->user_id = make_kuid(current_user_ns(), 0);
> +       d->group_id = make_kgid(current_user_ns(), 0);
>
>         while ((p = strsep(&opt, ",")) != NULL) {
>                 int token;
> @@ -578,8 +609,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
>         struct super_block *sb = root->d_sb;
>         struct fuse_conn *fc = get_fuse_conn_super(sb);
>
> -       seq_printf(m, ",user_id=%u", from_kuid_munged(&init_user_ns, fc->user_id));
> -       seq_printf(m, ",group_id=%u", from_kgid_munged(&init_user_ns, fc->group_id));
> +       seq_printf(m, ",user_id=%u",
> +                  from_kuid_munged(fc->user_ns, fc->user_id));
> +       seq_printf(m, ",group_id=%u",
> +                  from_kgid_munged(fc->user_ns, fc->group_id));
>         if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
>                 seq_puts(m, ",default_permissions");
>         if (fc->flags & FUSE_ALLOW_OTHER)
> @@ -618,6 +651,7 @@ void fuse_conn_init(struct fuse_conn *fc)
>         fc->attr_version = 1;
>         get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
>         fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
> +       fc->user_ns = get_user_ns(current_user_ns());
>  }
>  EXPORT_SYMBOL_GPL(fuse_conn_init);
>
> @@ -626,6 +660,8 @@ void fuse_conn_put(struct fuse_conn *fc)
>         if (atomic_dec_and_test(&fc->count)) {
>                 if (fc->destroy_req)
>                         fuse_request_free(fc->destroy_req);
> +               put_user_ns(fc->user_ns);
> +               fc->user_ns = NULL;
>                 put_pid_ns(fc->pid_ns);
>                 fc->pid_ns = NULL;
>                 fc->release(fc);
> @@ -643,12 +679,15 @@ EXPORT_SYMBOL_GPL(fuse_conn_get);
>  static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
>  {
>         struct fuse_attr attr;
> +       struct inode *inode;
> +
>         memset(&attr, 0, sizeof(attr));
>
>         attr.mode = mode;
>         attr.ino = FUSE_ROOT_ID;
>         attr.nlink = 1;
> -       return fuse_iget(sb, 1, 0, &attr, 0, 0);
> +       inode = fuse_iget(sb, 1, 0, &attr, 0, 0);
> +       return IS_ERR(inode) ? NULL : inode;
>  }
>
>  struct fuse_inode_handle {
> @@ -1043,8 +1082,12 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
>         if (!file)
>                 goto err;
>
> -       if ((file->f_op != &fuse_dev_operations) ||
> -           (file->f_cred->user_ns != &init_user_ns))
> +       /*
> +        * Require mount to happen from the same user namespace which
> +        * opened /dev/fuse to prevent potential attacks.
> +        */
> +       if (file->f_op != &fuse_dev_operations ||
> +           file->f_cred->user_ns != current_user_ns())
>                 goto err_fput;
>
>         fc = kmalloc(sizeof(*fc), GFP_KERNEL);
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
