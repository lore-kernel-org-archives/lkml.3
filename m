Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3JNCLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:11:34 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50013 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3JNCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:11:33 -0400
X-AuditID: 9c93017e-b7c81ae000002d4e-78-525b52d4481b
Date: Mon, 14 Oct 2013 11:11:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Squashfs: Refactor decompressor interface and code
Message-ID: <20131014021145.GH6847@bbox>
References: <1381198450-2202-1-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381198450-2202-1-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:14:10AM +0100, Phillip Lougher wrote:
> The decompressor interface and code was written from
> the point of view of single-threaded operation.  In doing
> so it mixed a lot of single-threaded implementation specific
> aspects into the decompressor code and elsewhere which makes it
> difficult to seamlessly support multiple different decompressor
> implementations.
> 
> This patch does the following:
> 
> 1.  It removes compressor_options parsing from the decompressor
>     init() function.  This allows the decompressor init() function
>     to be dynamically called to instantiate multiple decompressors,
>     without the compressor options needing to be read and parsed each
>     time.
> 
> 2.  It moves threading and all sleeping operations out of the
>     decompressors.  In doing so, it makes the decompressors
>     non-blocking wrappers which only deal with interfacing with
>     the decompressor implementation.
> 
> 3. It splits decompressor.[ch] into decompressor generic functions
>    in decompressor.[ch], and moves the single threaded
>    decompressor implementation into decompressor_single.c.
> 
> The result of this patch is Squashfs should now be able to
> support multiple decompressors by adding new decompressor_xxx.c
> files with specialised implementations of the functions in
> decompressor_single.c
> 
> This has the following functions
> 
> decompressor_create()
>   - Called at mount time to initialise internal decompressor state.
>   - An opaque pointer to the decompressor private state is returned (or error).
>   - The function is called with a pointer to the parsed and swapped comp_opts
>     structure returned by the new decompressor comp_opts() call.
> 
> decompressor_destroy()
>   - Destroy all decompressor private state
>   - kfree the comp_opts buffer
> 
> decompress()
>   - Select a decompressor or create a new decompressor
>   - Call using whatever locking scheme is necessary
> 
> All decompressor implementation specific private state has been moved from the
> squashfs_sb_info structure into the opaque private state returned by
> decompressor_create().   This is deliberate, now all implementation specific
> code has been moved to decompressor_xxx.c, no other code needs to/or should need
> to access anything within it.
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---
>  fs/squashfs/Makefile              |   2 +-
>  fs/squashfs/block.c               |  11 ++--
>  fs/squashfs/decompressor.c        |  47 +++++++++++------
>  fs/squashfs/decompressor.h        |  21 +++-----
>  fs/squashfs/decompressor_single.c | 107 ++++++++++++++++++++++++++++++++++++++
>  fs/squashfs/lzo_wrapper.c         |  24 ++-------
>  fs/squashfs/squashfs.h            |   9 +++-
>  fs/squashfs/squashfs_fs_sb.h      |   3 +-
>  fs/squashfs/super.c               |  10 ++--
>  fs/squashfs/xz_wrapper.c          |  89 +++++++++++++++++--------------
>  fs/squashfs/zlib_wrapper.c        |  50 ++++++------------
>  11 files changed, 237 insertions(+), 136 deletions(-)
>  create mode 100644 fs/squashfs/decompressor_single.c
> 
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index 110b047..c223c84 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -4,7 +4,7 @@
>  
>  obj-$(CONFIG_SQUASHFS) += squashfs.o
>  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
> -squashfs-y += namei.o super.o symlink.o decompressor.o
> +squashfs-y += namei.o super.o symlink.o decompressor.o decompressor_single.o
>  squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
>  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
> diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
> index 41d108e..10993e9 100644
> --- a/fs/squashfs/block.c
> +++ b/fs/squashfs/block.c
> @@ -93,7 +93,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>  	struct buffer_head **bh;
>  	int offset = index & ((1 << msblk->devblksize_log2) - 1);
>  	u64 cur_index = index >> msblk->devblksize_log2;
> -	int bytes, compressed, b = 0, k = 0, page = 0, avail;
> +	int bytes, compressed, b = 0, k = 0, page = 0, avail, i;
>  
>  	bh = kcalloc(((srclength + msblk->devblksize - 1)
>  		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
> @@ -158,6 +158,12 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>  		ll_rw_block(READ, b - 1, bh + 1);
>  	}
>  
> +        for (i = 0; i < b; i++) {
> +                wait_on_buffer(bh[i]);
> +                if (!buffer_uptodate(bh[i]))
> +                        goto block_release;
> +        }

Please, use tab instead of white space.

-- 
Kind regards,
Minchan Kim
