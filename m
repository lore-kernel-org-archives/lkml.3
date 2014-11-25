Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaKYORJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:17:09 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33866 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKYORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:17:06 -0500
Date: Tue, 25 Nov 2014 15:17:13 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Pieter Smith <pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>, fuse-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] fs/fuse: support compiling out splice
Message-ID: <20141125141713.GA9137@tucsk.suse.de>
References: <1416899996-21315-1-git-send-email-pieter@boesman.nl>
 <1416899996-21315-5-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416899996-21315-5-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimming CC.  Please do the same for other patches.  I for one am not
interested in the general tinification discussion]

On Tue, Nov 25, 2014 at 08:19:39AM +0100, Pieter Smith wrote:
> To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> struct is exported by fs/splice. The goal of the larger patch set is to
> completely compile out fs/splice, so uses of the exported struct need to be
> compiled out along with fs/splice.
> 
> This patch therefore compiles out splice support in fs/fuse when
> CONFIG_SYSCALL_SPLICE is undefined.
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>
> ---
>  fs/fuse/dev.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ca88731..e984302 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1191,8 +1191,9 @@ __releases(fc->lock)
>   * request_end().  Otherwise add it to the processing list, and set
>   * the 'sent' flag.
>   */
> -static ssize_t fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> -				struct fuse_copy_state *cs, size_t nbytes)
> +static ssize_t __maybe_unused
> +fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> +		 struct fuse_copy_state *cs, size_t nbytes)

fuse_dev_do_read() is definitely going to remain used.  So no point in adding
__maybe_unused.

>  {
>  	int err;
>  	struct fuse_req *req;
> @@ -1291,6 +1292,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
>  	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
>  }
>  
> +#ifdef CONFIG_SYSCALL_SPLICE
>  static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
>  				    struct pipe_inode_info *pipe,
>  				    size_t len, unsigned int flags)
> @@ -1368,6 +1370,9 @@ out:
>  	kfree(bufs);
>  	return ret;
>  }
> +#else /* CONFIG_SYSCALL_SPLICE */
> +#define fuse_dev_splice_read NULL
> +#endif

This looks fine.

Thanks,
Miklos

>  
>  static int fuse_notify_poll(struct fuse_conn *fc, unsigned int size,
>  			    struct fuse_copy_state *cs)
> -- 
> 2.1.0
> 
