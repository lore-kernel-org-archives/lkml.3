Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaKWW3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 17:29:12 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53670 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKWW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 17:29:09 -0500
MIME-Version: 1.0
In-Reply-To: <1416752468-1626-5-git-send-email-pieter@boesman.nl>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
	<1416752468-1626-5-git-send-email-pieter@boesman.nl>
Date: Sun, 23 Nov 2014 23:29:08 +0100
Message-ID: <CAFLxGvxq3Mr9n8xMO_fPZDhrGmBh=WKyU0+RF13JBdjssX6qfw@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH 4/6] fs/fuse: support compiling out splice
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Pieter Smith <pieter@boesman.nl>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Bertrand Jacquin <beber@meleeweb.net>, Oleg Nesterov <oleg@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Jeff Layton <jlayton@poochiereds.net>,
        Tom Herbert <therbert@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Peter Foley <pefoley2@pefoley.com>,
        Hugh Dickins <hughd@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mel Gorman <mgorman@suse.de>, Matt Turner <mattst88@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, Thomas Graf <tgraf@suug.ch>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Beulich <JBeulich@suse.com>, Willem de Bruijn <willemb@google.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 3:20 PM, Pieter Smith <pieter@boesman.nl> wrote:
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
>  fs/fuse/dev.c      | 4 ++--
>  include/linux/fs.h | 6 ++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ca88731..f8f92a4 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1291,7 +1291,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
>         return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
>  }
>
> -static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
> +static ssize_t __maybe_unused fuse_dev_splice_read(struct file *in, loff_t *ppos,
>                                     struct pipe_inode_info *pipe,
>                                     size_t len, unsigned int flags)
>  {
> @@ -2144,7 +2144,7 @@ const struct file_operations fuse_dev_operations = {
>         .llseek         = no_llseek,
>         .read           = do_sync_read,
>         .aio_read       = fuse_dev_read,
> -       .splice_read    = fuse_dev_splice_read,
> +       .splice_read    = __splice_p(fuse_dev_splice_read),
>         .write          = do_sync_write,
>         .aio_write      = fuse_dev_write,
>         .splice_write   = fuse_dev_splice_write,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a957d43..04c0975 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2443,6 +2443,12 @@ extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
>                         int datasync);
>  extern void block_sync_page(struct page *page);
>
> +#ifdef CONFIG_SYSCALL_SPLICE
> +#define __splice_p(x) x
> +#else
> +#define __splice_p(x) NULL
> +#endif
> +

This needs to go into a different patch.
One logical change per patch please. :-)

-- 
Thanks,
//richard
