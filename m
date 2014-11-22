Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaKVVoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:44:55 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59209 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaKVVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:44:54 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 22 Nov 2014 13:44:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] fs/fuse: support compiling out splice
Message-ID: <20141122214445.GA23711@thin>
References: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
 <1416690001-20817-5-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416690001-20817-5-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 09:59:59PM +0100, Pieter Smith wrote:
> Compile out splice support from fuse when the splice-family of syscalls is not
> supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

This patch needs some additional explanation.  Could you explain in the
commit message why this particular splice_read function (and only the
splice_read function, not the splice_write function) needs compiling
out, when others do not?

- Josh Triplett

> Signed-off-by: Pieter Smith <pieter@boesman.nl>
> ---
>  fs/fuse/dev.c      | 4 ++--
>  include/linux/fs.h | 6 ++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ca88731..f8f92a4 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1291,7 +1291,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
>  	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
>  }
>  
> -static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
> +static ssize_t __maybe_unused fuse_dev_splice_read(struct file *in, loff_t *ppos,
>  				    struct pipe_inode_info *pipe,
>  				    size_t len, unsigned int flags)
>  {
> @@ -2144,7 +2144,7 @@ const struct file_operations fuse_dev_operations = {
>  	.llseek		= no_llseek,
>  	.read		= do_sync_read,
>  	.aio_read	= fuse_dev_read,
> -	.splice_read	= fuse_dev_splice_read,
> +	.splice_read	= __splice_p(fuse_dev_splice_read),
>  	.write		= do_sync_write,
>  	.aio_write	= fuse_dev_write,
>  	.splice_write	= fuse_dev_splice_write,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a957d43..04c0975 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2443,6 +2443,12 @@ extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
>  			int datasync);
>  extern void block_sync_page(struct page *page);
>  
> +#ifdef CONFIG_SYSCALL_SPLICE
> +#define __splice_p(x) x
> +#else
> +#define __splice_p(x) NULL
> +#endif
> +
>  /* fs/splice.c */
>  extern ssize_t generic_file_splice_read(struct file *, loff_t *,
>  		struct pipe_inode_info *, size_t, unsigned int);
> -- 
> 1.9.1
> 
