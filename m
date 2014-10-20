Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaJTVxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:53:52 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58134 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaJTVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:53:50 -0400
Date: Mon, 20 Oct 2014 14:53:45 -0700
From: josh@joshtriplett.org
To: Pieter Smith <pieter@boesman.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: Moved sendfile syscall to own source file
Message-ID: <20141020215345.GA8929@cloud>
References: <1413841443-1165-1-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413841443-1165-1-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:43:01PM +0200, Pieter Smith wrote:
> Part of the tinification effort. Splitting out the sendfile syscall
> allows optional compilation in the succeeding patch.
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>

Seems fine in general.  One minor nit below, and with that,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  fs/Makefile     |   3 +-
>  fs/read_write.c | 176 -------------------------------------------------
>  fs/sendfile.c   | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+), 178 deletions(-)
>  create mode 100644 fs/sendfile.c
> 
> diff --git a/fs/Makefile b/fs/Makefile
> index 90c8852..1e3423f 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -5,7 +5,7 @@
>  # Rewritten to use lists instead of if-statements.
>  # 
>  
> -obj-y :=	open.o read_write.o file_table.o super.o \
> +obj-y :=	open.o read_write.o sendfile.o file_table.o super.o \
>  		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
>  		ioctl.o readdir.o select.o dcache.o inode.o \
>  		attr.o bad_inode.o file.o filesystems.o namespace.o \
> @@ -18,7 +18,6 @@ obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
>  else
>  obj-y +=	no-block.o
>  endif
> -

Unrelated whitespace change.

>  obj-$(CONFIG_PROC_FS) += proc_namespace.o
>  
>  obj-y				+= notify/
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 009d854..fc27a01 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1188,179 +1188,3 @@ COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
>  	return __compat_sys_pwritev64(fd, vec, vlen, pos);
>  }
>  #endif
> -
> -static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
> -		  	   size_t count, loff_t max)
> -{
> -	struct fd in, out;
> -	struct inode *in_inode, *out_inode;
> -	loff_t pos;
> -	loff_t out_pos;
> -	ssize_t retval;
> -	int fl;
> -
> -	/*
> -	 * Get input file, and verify that it is ok..
> -	 */
> -	retval = -EBADF;
> -	in = fdget(in_fd);
> -	if (!in.file)
> -		goto out;
> -	if (!(in.file->f_mode & FMODE_READ))
> -		goto fput_in;
> -	retval = -ESPIPE;
> -	if (!ppos) {
> -		pos = in.file->f_pos;
> -	} else {
> -		pos = *ppos;
> -		if (!(in.file->f_mode & FMODE_PREAD))
> -			goto fput_in;
> -	}
> -	retval = rw_verify_area(READ, in.file, &pos, count);
> -	if (retval < 0)
> -		goto fput_in;
> -	count = retval;
> -
> -	/*
> -	 * Get output file, and verify that it is ok..
> -	 */
> -	retval = -EBADF;
> -	out = fdget(out_fd);
> -	if (!out.file)
> -		goto fput_in;
> -	if (!(out.file->f_mode & FMODE_WRITE))
> -		goto fput_out;
> -	retval = -EINVAL;
> -	in_inode = file_inode(in.file);
> -	out_inode = file_inode(out.file);
> -	out_pos = out.file->f_pos;
> -	retval = rw_verify_area(WRITE, out.file, &out_pos, count);
> -	if (retval < 0)
> -		goto fput_out;
> -	count = retval;
> -
> -	if (!max)
> -		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
> -
> -	if (unlikely(pos + count > max)) {
> -		retval = -EOVERFLOW;
> -		if (pos >= max)
> -			goto fput_out;
> -		count = max - pos;
> -	}
> -
> -	fl = 0;
> -#if 0
> -	/*
> -	 * We need to debate whether we can enable this or not. The
> -	 * man page documents EAGAIN return for the output at least,
> -	 * and the application is arguably buggy if it doesn't expect
> -	 * EAGAIN on a non-blocking file descriptor.
> -	 */
> -	if (in.file->f_flags & O_NONBLOCK)
> -		fl = SPLICE_F_NONBLOCK;
> -#endif
> -	file_start_write(out.file);
> -	retval = do_splice_direct(in.file, &pos, out.file, &out_pos, count, fl);
> -	file_end_write(out.file);
> -
> -	if (retval > 0) {
> -		add_rchar(current, retval);
> -		add_wchar(current, retval);
> -		fsnotify_access(in.file);
> -		fsnotify_modify(out.file);
> -		out.file->f_pos = out_pos;
> -		if (ppos)
> -			*ppos = pos;
> -		else
> -			in.file->f_pos = pos;
> -	}
> -
> -	inc_syscr(current);
> -	inc_syscw(current);
> -	if (pos > max)
> -		retval = -EOVERFLOW;
> -
> -fput_out:
> -	fdput(out);
> -fput_in:
> -	fdput(in);
> -out:
> -	return retval;
> -}
> -
> -SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd, off_t __user *, offset, size_t, count)
> -{
> -	loff_t pos;
> -	off_t off;
> -	ssize_t ret;
> -
> -	if (offset) {
> -		if (unlikely(get_user(off, offset)))
> -			return -EFAULT;
> -		pos = off;
> -		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
> -		if (unlikely(put_user(pos, offset)))
> -			return -EFAULT;
> -		return ret;
> -	}
> -
> -	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> -}
> -
> -SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count)
> -{
> -	loff_t pos;
> -	ssize_t ret;
> -
> -	if (offset) {
> -		if (unlikely(copy_from_user(&pos, offset, sizeof(loff_t))))
> -			return -EFAULT;
> -		ret = do_sendfile(out_fd, in_fd, &pos, count, 0);
> -		if (unlikely(put_user(pos, offset)))
> -			return -EFAULT;
> -		return ret;
> -	}
> -
> -	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> -}
> -
> -#ifdef CONFIG_COMPAT
> -COMPAT_SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd,
> -		compat_off_t __user *, offset, compat_size_t, count)
> -{
> -	loff_t pos;
> -	off_t off;
> -	ssize_t ret;
> -
> -	if (offset) {
> -		if (unlikely(get_user(off, offset)))
> -			return -EFAULT;
> -		pos = off;
> -		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
> -		if (unlikely(put_user(pos, offset)))
> -			return -EFAULT;
> -		return ret;
> -	}
> -
> -	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> -}
> -
> -COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
> -		compat_loff_t __user *, offset, compat_size_t, count)
> -{
> -	loff_t pos;
> -	ssize_t ret;
> -
> -	if (offset) {
> -		if (unlikely(copy_from_user(&pos, offset, sizeof(loff_t))))
> -			return -EFAULT;
> -		ret = do_sendfile(out_fd, in_fd, &pos, count, 0);
> -		if (unlikely(put_user(pos, offset)))
> -			return -EFAULT;
> -		return ret;
> -	}
> -
> -	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> -}
> -#endif
> diff --git a/fs/sendfile.c b/fs/sendfile.c
> new file mode 100644
> index 0000000..4ceccd4
> --- /dev/null
> +++ b/fs/sendfile.c
> @@ -0,0 +1,200 @@
> +/*
> + *  linux/fs/sendfile.c
> + *
> + *  Copyright (C) 1991, 1992  Linus Torvalds
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/stat.h>
> +#include <linux/fcntl.h>
> +#include <linux/file.h>
> +#include <linux/uio.h>
> +#include <linux/aio.h>
> +#include <linux/fsnotify.h>
> +#include <linux/security.h>
> +#include <linux/export.h>
> +#include <linux/syscalls.h>
> +#include <linux/pagemap.h>
> +#include <linux/splice.h>
> +#include <linux/compat.h>
> +#include "internal.h"
> +
> +#include <linux/uaccess.h>
> +#include <asm/unistd.h>
> +
> +
> +static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
> +			   size_t count, loff_t max)
> +{
> +	struct fd in, out;
> +	struct inode *in_inode, *out_inode;
> +	loff_t pos;
> +	loff_t out_pos;
> +	ssize_t retval;
> +	int fl;
> +
> +	/*
> +	 * Get input file, and verify that it is ok..
> +	 */
> +	retval = -EBADF;
> +	in = fdget(in_fd);
> +	if (!in.file)
> +		goto out;
> +	if (!(in.file->f_mode & FMODE_READ))
> +		goto fput_in;
> +	retval = -ESPIPE;
> +	if (!ppos) {
> +		pos = in.file->f_pos;
> +	} else {
> +		pos = *ppos;
> +		if (!(in.file->f_mode & FMODE_PREAD))
> +			goto fput_in;
> +	}
> +	retval = rw_verify_area(READ, in.file, &pos, count);
> +	if (retval < 0)
> +		goto fput_in;
> +	count = retval;
> +
> +	/*
> +	 * Get output file, and verify that it is ok..
> +	 */
> +	retval = -EBADF;
> +	out = fdget(out_fd);
> +	if (!out.file)
> +		goto fput_in;
> +	if (!(out.file->f_mode & FMODE_WRITE))
> +		goto fput_out;
> +	retval = -EINVAL;
> +	in_inode = file_inode(in.file);
> +	out_inode = file_inode(out.file);
> +	out_pos = out.file->f_pos;
> +	retval = rw_verify_area(WRITE, out.file, &out_pos, count);
> +	if (retval < 0)
> +		goto fput_out;
> +	count = retval;
> +
> +	if (!max)
> +		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
> +
> +	if (unlikely(pos + count > max)) {
> +		retval = -EOVERFLOW;
> +		if (pos >= max)
> +			goto fput_out;
> +		count = max - pos;
> +	}
> +
> +	fl = 0;
> +#if 0
> +	/*
> +	 * We need to debate whether we can enable this or not. The
> +	 * man page documents EAGAIN return for the output at least,
> +	 * and the application is arguably buggy if it doesn't expect
> +	 * EAGAIN on a non-blocking file descriptor.
> +	 */
> +	if (in.file->f_flags & O_NONBLOCK)
> +		fl = SPLICE_F_NONBLOCK;
> +#endif
> +	file_start_write(out.file);
> +	retval = do_splice_direct(in.file, &pos, out.file, &out_pos, count, fl);
> +	file_end_write(out.file);
> +
> +	if (retval > 0) {
> +		add_rchar(current, retval);
> +		add_wchar(current, retval);
> +		fsnotify_access(in.file);
> +		fsnotify_modify(out.file);
> +		out.file->f_pos = out_pos;
> +		if (ppos)
> +			*ppos = pos;
> +		else
> +			in.file->f_pos = pos;
> +	}
> +
> +	inc_syscr(current);
> +	inc_syscw(current);
> +	if (pos > max)
> +		retval = -EOVERFLOW;
> +
> +fput_out:
> +	fdput(out);
> +fput_in:
> +	fdput(in);
> +out:
> +	return retval;
> +}
> +
> +SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd, off_t __user *, offset, size_t, count)
> +{
> +	loff_t pos;
> +	off_t off;
> +	ssize_t ret;
> +
> +	if (offset) {
> +		if (unlikely(get_user(off, offset)))
> +			return -EFAULT;
> +		pos = off;
> +		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
> +		if (unlikely(put_user(pos, offset)))
> +			return -EFAULT;
> +		return ret;
> +	}
> +
> +	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> +}
> +
> +SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count)
> +{
> +	loff_t pos;
> +	ssize_t ret;
> +
> +	if (offset) {
> +		if (unlikely(copy_from_user(&pos, offset, sizeof(loff_t))))
> +			return -EFAULT;
> +		ret = do_sendfile(out_fd, in_fd, &pos, count, 0);
> +		if (unlikely(put_user(pos, offset)))
> +			return -EFAULT;
> +		return ret;
> +	}
> +
> +	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> +}
> +
> +#ifdef CONFIG_COMPAT
> +COMPAT_SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd,
> +		compat_off_t __user *, offset, compat_size_t, count)
> +{
> +	loff_t pos;
> +	off_t off;
> +	ssize_t ret;
> +
> +	if (offset) {
> +		if (unlikely(get_user(off, offset)))
> +			return -EFAULT;
> +		pos = off;
> +		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
> +		if (unlikely(put_user(pos, offset)))
> +			return -EFAULT;
> +		return ret;
> +	}
> +
> +	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> +}
> +
> +COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
> +		compat_loff_t __user *, offset, compat_size_t, count)
> +{
> +	loff_t pos;
> +	ssize_t ret;
> +
> +	if (offset) {
> +		if (unlikely(copy_from_user(&pos, offset, sizeof(loff_t))))
> +			return -EFAULT;
> +		ret = do_sendfile(out_fd, in_fd, &pos, count, 0);
> +		if (unlikely(put_user(pos, offset)))
> +			return -EFAULT;
> +		return ret;
> +	}
> +
> +	return do_sendfile(out_fd, in_fd, NULL, count, 0);
> +}
> +#endif
> -- 
> 1.9.1
> 
