Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaFZU63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:58:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaFZU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:58:28 -0400
Date: Thu, 26 Jun 2014 13:58:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com
Subject: Re: [PATCH 09/15] kexec: Implementation of new syscall
 kexec_file_load
Message-Id: <20140626135826.d1679d6eb5b7bd0f82dd7deb@linux-foundation.org>
In-Reply-To: <1403814824-7587-10-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
	<1403814824-7587-10-git-send-email-vgoyal@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 16:33:38 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> Previous patch provided the interface definition and this patch prvides
> implementation of new syscall.
> 
> Previously segment list was prepared in user space. Now user space just
> passes kernel fd, initrd fd and command line and kernel will create a
> segment list internally.
> 
> This patch contains generic part of the code. Actual segment preparation
> and loading is done by arch and image specific loader. Which comes in
> next patch.
> 
> ...
>
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -6,6 +6,8 @@
>   * Version 2.  See the file COPYING for more details.
>   */
>  
> +#define pr_fmt(fmt)	"kexec: " fmt
> +
>  #include <linux/capability.h>
>  #include <linux/mm.h>
>  #include <linux/file.h>
> @@ -326,6 +328,215 @@ out_free_image:
>  	return ret;
>  }
>  
> +static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
> +{
> +	struct fd f = fdget(fd);
> +	int ret = 0;

unneeded initialisation.

> +	struct kstat stat;
> +	loff_t pos;
> +	ssize_t bytes = 0;
> +
> +	if (!f.file)
> +		return -EBADF;
> +
> +	ret = vfs_getattr(&f.file->f_path, &stat);
> +	if (ret)
> +		goto out;
> +
> +	if (stat.size > INT_MAX) {
> +		ret = -EFBIG;
> +		goto out;
> +	}
> +
> +	/* Don't hand 0 to vmalloc, it whines. */
> +	if (stat.size == 0) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	*buf = vmalloc(stat.size);
> +	if (!*buf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	pos = 0;
> +	while (pos < stat.size) {
> +		bytes = kernel_read(f.file, pos, (char *)(*buf) + pos,
> +				    stat.size - pos);
> +		if (bytes < 0) {
> +			vfree(*buf);
> +			ret = bytes;
> +			goto out;
> +		}
> +
> +		if (bytes == 0)
> +			break;

Here we can get a short read: (pos < stat.size).  Seems to me that it
is risky to return this result to the caller as if all is well.

> +		pos += bytes;
> +	}
> +
> +	*buf_len = pos;
> +out:
> +	fdput(f);
> +	return ret;
> +}
> 
> ...
>

