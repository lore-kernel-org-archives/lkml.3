Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaJWUFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:05:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaJWUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:05:24 -0400
Date: Thu, 23 Oct 2014 13:05:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1 linux-next] fs/affs/file.c: adding support to
 O_DIRECT
Message-Id: <20141023130524.086f8b07e9d3c6dcf21be761@linux-foundation.org>
In-Reply-To: <1413908891-6038-1-git-send-email-fabf@skynet.be>
References: <1413908891-6038-1-git-send-email-fabf@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 18:28:11 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> Based on ext2_direct_IO
> 
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
> @@ -12,6 +12,7 @@
>   *  affs regular file handling primitives
>   */
>  
> +#include <linux/aio.h>
>  #include "affs.h"
>  
>  #if PAGE_SIZE < 4096
> @@ -392,6 +393,22 @@ static void affs_write_failed(struct address_space *mapping, loff_t to)
>  	}
>  }
>  
> +static ssize_t
> +affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
> +	       loff_t offset)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode *inode = mapping->host;
> +	size_t count = iov_iter_count(iter);
> +	ssize_t ret;
> +
> +	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
> +	if (ret < 0 && (rw & WRITE))
> +		affs_write_failed(mapping, offset + count);
> +	return ret;
> +}
> +
>  static int affs_write_begin(struct file *file, struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned flags,
>  			struct page **pagep, void **fsdata)
> @@ -418,6 +435,7 @@ const struct address_space_operations affs_aops = {
>  	.writepage = affs_writepage,
>  	.write_begin = affs_write_begin,
>  	.write_end = generic_write_end,
> +	.direct_IO = affs_direct_IO,
>  	.bmap = _affs_bmap
>  };

Has this been runtime tested?  If so, please add the results to the
changelog.  Some performance numbers would be useful.

