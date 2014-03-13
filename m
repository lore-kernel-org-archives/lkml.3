Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaCMLDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:03:46 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61116 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaCMLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140313003740.GL18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
	<20140312181925.GK18016@ZenIV.linux.org.uk>
	<CANq1E4QSFjDiYVmfrNJFfK6zW_HhSBd5d0QF-2t48DzUP+B6pw@mail.gmail.com>
	<20140313003740.GL18016@ZenIV.linux.org.uk>
Date: Thu, 13 Mar 2014 12:03:43 +0100
Message-ID: <CANq1E4T2toUqeLjPwNht_VSzRMRdS0VHHA3a+5BPKVDTREKT3A@mail.gmail.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al

On Thu, Mar 13, 2014 at 1:37 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 12, 2014 at 11:30:09PM +0100, David Herrmann wrote:
>> Please see:
>>   shmem_zero_setup()
>>     shmem_file_setup()
>>       __shmem_file_setup()
>>         alloc_file()
>>
>> shmem_zero_setup() is used by /dev/zero (drivers/char/mem.c) and
>> mmap(MAP_ANON). So yes, we do call mmap() on these files.
>
> We do, but how do you get anything even attempt deny_write_access() on
> those?  And what would the semantics of that be, anyway?

I haven't found any such path either. Just wanted to point it out in
case you missed these.

> diff --git a/fs/file_table.c b/fs/file_table.c
> index 5b24008..ce1504f 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -178,47 +177,12 @@ struct file *alloc_file(struct path *path, fmode_t mode,
>         file->f_mapping = path->dentry->d_inode->i_mapping;
>         file->f_mode = mode;
>         file->f_op = fop;
> -
> -       /*
> -        * These mounts don't really matter in practice
> -        * for r/o bind mounts.  They aren't userspace-
> -        * visible.  We do this for consistency, and so
> -        * that we can do debugging checks at __fput()
> -        */
> -       if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
> -               file_take_write(file);
> -               WARN_ON(mnt_clone_write(path->mnt));
> -       }
>         if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
>                 i_readcount_inc(path->dentry->d_inode);
>         return file;
>  }
>  EXPORT_SYMBOL(alloc_file);
>
> -/**
> - * drop_file_write_access - give up ability to write to a file
> - * @file: the file to which we will stop writing
> - *
> - * This is a central place which will give up the ability
> - * to write to @file, along with access to write through
> - * its vfsmount.
> - */
> -static void drop_file_write_access(struct file *file)
> -{
> -       struct vfsmount *mnt = file->f_path.mnt;
> -       struct dentry *dentry = file->f_path.dentry;
> -       struct inode *inode = dentry->d_inode;
> -
> -       put_write_access(inode);
> -
> -       if (special_file(inode->i_mode))
> -               return;
> -       if (file_check_writeable(file) != 0)
> -               return;
> -       __mnt_drop_write(mnt);
> -       file_release_write(file);
> -}
> -
>  /* the real guts of fput() - releasing the last reference to file
>   */
>  static void __fput(struct file *file)
> @@ -253,8 +217,10 @@ static void __fput(struct file *file)
>         put_pid(file->f_owner.pid);
>         if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
>                 i_readcount_dec(inode);
> -       if (file->f_mode & FMODE_WRITE)
> -               drop_file_write_access(file);
> +       if (file->f_mode & FMODE_WRITER) {
> +               put_write_access(inode);
> +               __mnt_drop_write(mnt);
> +       }
>         file->f_path.dentry = NULL;
>         file->f_path.mnt = NULL;
>         file->f_inode = NULL;
> diff --git a/fs/open.c b/fs/open.c
> index b9ed8b2..ea765e4 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -632,35 +632,6 @@ out:
>         return error;
>  }
>
> -/*
> - * You have to be very careful that these write
> - * counts get cleaned up in error cases and
> - * upon __fput().  This should probably never
> - * be called outside of __dentry_open().
> - */
> -static inline int __get_file_write_access(struct inode *inode,
> -                                         struct vfsmount *mnt)
> -{
> -       int error;
> -       error = get_write_access(inode);
> -       if (error)
> -               return error;
> -       /*
> -        * Do not take mount writer counts on
> -        * special files since no writes to
> -        * the mount itself will occur.
> -        */
> -       if (!special_file(inode->i_mode)) {
> -               /*
> -                * Balanced in __fput()
> -                */
> -               error = __mnt_want_write(mnt);
> -               if (error)
> -                       put_write_access(inode);
> -       }
> -       return error;
> -}
> -
>  int open_check_o_direct(struct file *f)
>  {
>         /* NB: we're sure to have correct a_ops only after f_op->open */
> @@ -690,12 +661,15 @@ static int do_dentry_open(struct file *f,
>
>         path_get(&f->f_path);
>         inode = f->f_inode = f->f_path.dentry->d_inode;
> -       if (f->f_mode & FMODE_WRITE) {
> -               error = __get_file_write_access(inode, f->f_path.mnt);
> -               if (error)
> +       if ((f->f_mode & FMODE_WRITE) && !special_file(inode->i_mode)) {
> +               error = get_write_access(inode);
> +               if (unlikely(error))
> +                       goto cleanup_file;
> +               error = __mnt_want_write(f->f_path.mnt);
> +               if (unlikely(error)) {
> +                       put_write_access(inode);
>                         goto cleanup_file;
> -               if (!special_file(inode->i_mode))
> -                       file_take_write(f);

+                f->f_mode |= FMODE_WRITER;

Apart from that, the patch looks fine to me. In fact, if anyone wanted
the FMODE_WRITER behavior for alloc_file(), they can do that
themselves after it returns.
>From a first glance you could splitt of the removal of
DEBUG_WRITECOUNT into a separate patch. Makes reviewing easier.

Thanks
David
