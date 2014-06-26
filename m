Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaFZMtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:49:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51138 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaFZMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:49:14 -0400
Message-ID: <1403786949.2017.66.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/1] ima: fix fallback to use new_sync_read()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Thu, 26 Jun 2014 08:49:09 -0400
In-Reply-To: <ffb4808ed8ce0dddbc96c566ccca2c9b39005643.1403616439.git.d.kasatkin@samsung.com>
References: <ffb4808ed8ce0dddbc96c566ccca2c9b39005643.1403616439.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062612-8236-0000-0000-00000365CEFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 16:27 +0300, Dmitry Kasatkin wrote: 
> 3.16 commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
> 'switch simple generic_file_aio_read() users to ->read_iter()'
> replaced ->aio_read with ->read_iter in most of the file systems
> and introduced new_sync_read() as a replacement for do_sync_read().
> 
> Most of file systems set '->read' and ima_kernel_read is not affected.
> When ->read is not set, this patch adopts fallback call changes from the
> vfs_read.

So every time there are changes in vfs_read(), we're going to have to
play catch up.  A better solution would be to refactor vfs_read() so
that we could call it.

Mimi


> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/ima_crypto.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index ccd0ac8..b126a78 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -40,19 +40,19 @@ static int ima_kernel_read(struct file *file, loff_t offset,
>  {
>  	mm_segment_t old_fs;
>  	char __user *buf = addr;
> -	ssize_t ret;
> +	ssize_t ret = -EINVAL;
> 
>  	if (!(file->f_mode & FMODE_READ))
>  		return -EBADF;
> -	if (!file->f_op->read && !file->f_op->aio_read)
> -		return -EINVAL;
> 
>  	old_fs = get_fs();
>  	set_fs(get_ds());
>  	if (file->f_op->read)
>  		ret = file->f_op->read(file, buf, count, &offset);
> -	else
> +	else if (file->f_op->aio_read)
>  		ret = do_sync_read(file, buf, count, &offset);
> +	else if (file->f_op->read_iter)
> +		ret = new_sync_read(file, buf, count, &offset);
>  	set_fs(old_fs);
>  	return ret;
>  }


