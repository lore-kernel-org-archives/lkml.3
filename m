Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaJMRdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:33:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45441 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaJMRdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:33:38 -0400
Message-ID: <1413221607.13530.19.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 6/6] VFS: refactor vfs_read()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 13 Oct 2014 13:33:27 -0400
In-Reply-To: <a375f4a82ebe59912e81ae0704121c8d503adb55.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
	 <a375f4a82ebe59912e81ae0704121c8d503adb55.1412950047.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101317-8236-0000-0000-0000061DEE38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 17:09 +0300, Dmitry Kasatkin wrote: 
> integrity_kernel_read() duplicates the file read operations code
> in vfs_read(). This patch refactors vfs_read() code creating a
> helper function __vfs_read(). It is used by both vfs_read() and
> integrity_kernel_read().
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Al, can we get an ack on this?

thanks,

Mimi

> ---
>  fs/read_write.c           | 24 ++++++++++++++++++------
>  include/linux/fs.h        |  1 +
>  security/integrity/iint.c | 10 +++-------
>  3 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 009d854..f45b2ae 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -412,6 +412,23 @@ ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *p
> 
>  EXPORT_SYMBOL(new_sync_read);
> 
> +ssize_t __vfs_read(struct file *file, char __user *buf, size_t count,
> +		   loff_t *pos)
> +{
> +	ssize_t ret;
> +
> +	if (file->f_op->read)
> +		ret = file->f_op->read(file, buf, count, pos);
> +	else if (file->f_op->aio_read)
> +		ret = do_sync_read(file, buf, count, pos);
> +	else if (file->f_op->read_iter)
> +		ret = new_sync_read(file, buf, count, pos);
> +	else
> +		ret = -EINVAL;
> +
> +	return ret;
> +}
> +
>  ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
>  {
>  	ssize_t ret;
> @@ -426,12 +443,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
>  	ret = rw_verify_area(READ, file, pos, count);
>  	if (ret >= 0) {
>  		count = ret;
> -		if (file->f_op->read)
> -			ret = file->f_op->read(file, buf, count, pos);
> -		else if (file->f_op->aio_read)
> -			ret = do_sync_read(file, buf, count, pos);
> -		else
> -			ret = new_sync_read(file, buf, count, pos);
> +		ret = __vfs_read(file, buf, count, pos);
>  		if (ret > 0) {
>  			fsnotify_access(file);
>  			add_rchar(current, ret);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e11d60c..ac3a36e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1527,6 +1527,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
>  			      struct iovec *fast_pointer,
>  			      struct iovec **ret_pointer);
> 
> +extern ssize_t __vfs_read(struct file *, char __user *, size_t, loff_t *);
>  extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
>  extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
>  extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> index a1f5cd1..e359477 100644
> --- a/security/integrity/iint.c
> +++ b/security/integrity/iint.c
> @@ -184,20 +184,16 @@ int integrity_kernel_read(struct file *file, loff_t offset,
>  {
>  	mm_segment_t old_fs;
>  	char __user *buf = addr;
> -	ssize_t ret = -EINVAL;
> +	ssize_t ret;
> 
>  	if (!(file->f_mode & FMODE_READ))
>  		return -EBADF;
> 
>  	old_fs = get_fs();
>  	set_fs(get_ds());
> -	if (file->f_op->read)
> -		ret = file->f_op->read(file, buf, count, &offset);
> -	else if (file->f_op->aio_read)
> -		ret = do_sync_read(file, buf, count, &offset);
> -	else if (file->f_op->read_iter)
> -		ret = new_sync_read(file, buf, count, &offset);
> +	ret = __vfs_read(file, buf, count, &offset);
>  	set_fs(old_fs);
> +
>  	return ret;
>  }
> 


