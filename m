Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3JWFuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:50:19 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53439 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3JWFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131022153313.GA11923@infradead.org>
References: <20131022153313.GA11923@infradead.org>
Date: Wed, 23 Oct 2013 07:50:17 +0200
Message-ID: <CAFLxGvwk0gbejxk6hmnu+Cw=TgXGh0=MKgSyKtm7nTVJiBBgeg@mail.gmail.com>
Subject: Re: [PATCH, RFC] what's the point of mtd_inodefs?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 5:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> I've been looking at mtdchar as part of a bigger series touching all
> kidns of places and really wonder what the point of mtd_inodefs is.

As far I can tell it was introduced because of that issue:
http://lists.infradead.org/pipermail/linux-mtd/2010-April/029593.html

> We use it to make the file->f_mapping of the mtdchar device point to
> the mapping of it's inodes, but there's nothing special happening with
> mtd_inodefs inodes.  It seems to me like simply switching the
> backing_dev_info to the mtd one, similarly to what we do for /dev/mem
> and friends would be enough for mtdchar.
>
> If this works for the intended use case I'd love to add this series
> to my to be posted series as it would simplify it greatly.
>
>
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 684bfa3..a7c9f37 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -48,7 +48,6 @@ static DEFINE_MUTEX(mtd_mutex);
>   */
>  struct mtd_file_info {
>         struct mtd_info *mtd;
> -       struct inode *ino;
>         enum mtd_file_modes mode;
>  };
>
> @@ -58,10 +57,6 @@ static loff_t mtdchar_lseek(struct file *file, loff_t offset, int orig)
>         return fixed_size_llseek(file, offset, orig, mfi->mtd->size);
>  }
>
> -static int count;
> -static struct vfsmount *mnt;
> -static struct file_system_type mtd_inodefs_type;
> -
>  static int mtdchar_open(struct inode *inode, struct file *file)
>  {
>         int minor = iminor(inode);
> @@ -69,7 +64,6 @@ static int mtdchar_open(struct inode *inode, struct file *file)
>         int ret = 0;
>         struct mtd_info *mtd;
>         struct mtd_file_info *mfi;
> -       struct inode *mtd_ino;
>
>         pr_debug("MTD_open\n");
>
> @@ -77,60 +71,42 @@ static int mtdchar_open(struct inode *inode, struct file *file)
>         if ((file->f_mode & FMODE_WRITE) && (minor & 1))
>                 return -EACCES;
>
> -       ret = simple_pin_fs(&mtd_inodefs_type, &mnt, &count);
> -       if (ret)
> -               return ret;
> -
>         mutex_lock(&mtd_mutex);
> -       mtd = get_mtd_device(NULL, devnum);
>
> +       mtd = get_mtd_device(NULL, devnum);
>         if (IS_ERR(mtd)) {
>                 ret = PTR_ERR(mtd);
> -               goto out;
> +               goto out_unlock;
>         }
>
>         if (mtd->type == MTD_ABSENT) {
>                 ret = -ENODEV;
> -               goto out1;
> -       }
> -
> -       mtd_ino = iget_locked(mnt->mnt_sb, devnum);
> -       if (!mtd_ino) {
> -               ret = -ENOMEM;
> -               goto out1;
> +               goto out_put_device;
>         }
> -       if (mtd_ino->i_state & I_NEW) {
> -               mtd_ino->i_private = mtd;
> -               mtd_ino->i_mode = S_IFCHR;
> -               mtd_ino->i_data.backing_dev_info = mtd->backing_dev_info;
> -               unlock_new_inode(mtd_ino);
> -       }
> -       file->f_mapping = mtd_ino->i_mapping;
>
>         /* You can't open it RW if it's not a writeable device */
>         if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
>                 ret = -EACCES;
> -               goto out2;
> +               goto out_put_device;
>         }
>
>         mfi = kzalloc(sizeof(*mfi), GFP_KERNEL);
>         if (!mfi) {
>                 ret = -ENOMEM;
> -               goto out2;
> +               goto out_put_device;
>         }
> -       mfi->ino = mtd_ino;
>         mfi->mtd = mtd;
> +
>         file->private_data = mfi;
> +       file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> +
>         mutex_unlock(&mtd_mutex);
>         return 0;
>
> -out2:
> -       iput(mtd_ino);
> -out1:
> +out_put_device:
>         put_mtd_device(mtd);
> -out:
> +out_unlock:
>         mutex_unlock(&mtd_mutex);
> -       simple_release_fs(&mnt, &count);
>         return ret;
>  } /* mtdchar_open */
>
> @@ -147,12 +123,9 @@ static int mtdchar_close(struct inode *inode, struct file *file)
>         if ((file->f_mode & FMODE_WRITE))
>                 mtd_sync(mtd);
>
> -       iput(mfi->ino);
> -
>         put_mtd_device(mtd);
>         file->private_data = NULL;
>         kfree(mfi);
> -       simple_release_fs(&mnt, &count);
>
>         return 0;
>  } /* mtdchar_close */
> @@ -1147,24 +1120,6 @@ static const struct file_operations mtd_fops = {
>  #endif
>  };
>
> -static const struct super_operations mtd_ops = {
> -       .drop_inode = generic_delete_inode,
> -       .statfs = simple_statfs,
> -};
> -
> -static struct dentry *mtd_inodefs_mount(struct file_system_type *fs_type,
> -                               int flags, const char *dev_name, void *data)
> -{
> -       return mount_pseudo(fs_type, "mtd_inode:", &mtd_ops, NULL, MTD_INODE_FS_MAGIC);
> -}
> -
> -static struct file_system_type mtd_inodefs_type = {
> -       .name = "mtd_inodefs",
> -       .mount = mtd_inodefs_mount,
> -       .kill_sb = kill_anon_super,
> -};
> -MODULE_ALIAS_FS("mtd_inodefs");
> -
>  int __init init_mtdchar(void)
>  {
>         int ret;
> @@ -1174,26 +1129,12 @@ int __init init_mtdchar(void)
>         if (ret < 0) {
>                 pr_err("Can't allocate major number %d for MTD\n",
>                        MTD_CHAR_MAJOR);
> -               return ret;
>         }
> -
> -       ret = register_filesystem(&mtd_inodefs_type);
> -       if (ret) {
> -               pr_err("Can't register mtd_inodefs filesystem, error %d\n",
> -                      ret);
> -               goto err_unregister_chdev;
> -       }
> -
> -       return ret;
> -
> -err_unregister_chdev:
> -       __unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
>         return ret;
>  }
>
>  void __exit cleanup_mtdchar(void)
>  {
> -       unregister_filesystem(&mtd_inodefs_type);
>         __unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
>  }
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/



-- 
Thanks,
//richard
