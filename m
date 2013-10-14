Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3JNBnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:43:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56301 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3JNBnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:43:09 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-b9-525b4c2b8b63
Date: Mon, 14 Oct 2013 10:43:21 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Squashfs: Directly decompress into the page cache
 for file data
Message-ID: <20131014014321.GG6847@bbox>
References: <1381472381-3825-1-git-send-email-phillip@squashfs.org.uk>
 <1381472381-3825-4-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381472381-3825-4-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 07:19:40AM +0100, Phillip Lougher wrote:
> This introduces an implementation of squashfs_readpage_block()
> that directly decompresses into the page cache.
> 
> This uses the previously added page handler abstraction to push
> down the necessary kmap_atomic/kunmap_atomic operations on the
> page cache buffers into the decompressors.  This enables
> direct copying into the page cache without using the slow
> kmap/kunmap calls.
> 
> The code detects when multiple threads are racing in
> squashfs_readpage() to decompress the same block, and avoids
> this regression by falling back to using an intermediate
> buffer.
> 
> This patch enhances the performance of Squashfs significantly
> when multiple processes are accessing the filesystem simultaneously
> because it not only reduces memcopying, but it more importantly
> eliminates the lock contention on the intermediate buffer.
> 
> Using single-thread decompression.
> 
>         dd if=file1 of=/dev/null bs=4096 &
>         dd if=file2 of=/dev/null bs=4096 &
>         dd if=file3 of=/dev/null bs=4096 &
>         dd if=file4 of=/dev/null bs=4096
> 
> Before:
> 
> 629145600 bytes (629 MB) copied, 45.8046 s, 13.7 MB/s
> 
> After:
> 
> 629145600 bytes (629 MB) copied, 9.29414 s, 67.7 MB/s

It's really nice!
Below are just nitpicks.

> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---
>  fs/squashfs/Kconfig       |  14 ++++
>  fs/squashfs/Makefile      |   7 +-
>  fs/squashfs/file_direct.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/squashfs/page_actor.c  | 104 +++++++++++++++++++++++++++
>  fs/squashfs/page_actor.h  |  32 +++++++++
>  5 files changed, 334 insertions(+), 1 deletion(-)
>  create mode 100644 fs/squashfs/file_direct.c
>  create mode 100644 fs/squashfs/page_actor.c
> 
> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
> index c70111e..8bc9e6a 100644
> --- a/fs/squashfs/Kconfig
> +++ b/fs/squashfs/Kconfig
> @@ -25,6 +25,20 @@ config SQUASHFS
>  
>  	  If unsure, say N.
>  
> +config SQUASHFS_FILE_DIRECT
> +	bool "Decompress files directly into the page cache"
> +	depends on SQUASHFS
> +	help
> +	  Squashfs has traditionally decompressed file data into an
> +	  intermediate buffer and then memcopied it into the page cache.
> +
> +	  Saying Y here includes support for directly decompressing
> +	  file data into the page cache.  Doing so can significantly
> +	  improve performance because it eliminates a mempcpy and
> +	  it also removes the lock contention on the single buffer.
> +
> +	  If unsure, say N.
> +
>  config SQUASHFS_XATTR
>  	bool "Squashfs XATTR support"
>  	depends on SQUASHFS
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index 14cfc41..deaabc5 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -5,8 +5,13 @@
>  obj-$(CONFIG_SQUASHFS) += squashfs.o
>  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
>  squashfs-y += namei.o super.o symlink.o decompressor.o decompressor_single.o
> -squashfs-y += file_cache.o
>  squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
>  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
> +
> +ifdef CONFIG_SQUASHFS_FILE_DIRECT
> +    squashfs-y += file_direct.o page_actor.o
> +else
> +    squashfs-y += file_cache.o
> +endif
> diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
> new file mode 100644
> index 0000000..f31298e
> --- /dev/null
> +++ b/fs/squashfs/file_direct.c
> @@ -0,0 +1,178 @@
> +/*
> + * Copyright (c) 2013
> + * Phillip Lougher <phillip@squashfs.org.uk>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/vfs.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/pagemap.h>
> +#include <linux/mutex.h>
> +
> +#include "squashfs_fs.h"
> +#include "squashfs_fs_sb.h"
> +#include "squashfs_fs_i.h"
> +#include "squashfs.h"
> +#include "page_actor.h"
> +
> +static int squashfs_read_cache(struct page *target_page, u64 block, int bsize,
> +	int pages, struct page **page);
> +
> +/* Read separately compressed datablock directly into page cache */
> +int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
> +
> +{
> +	struct inode *inode = target_page->mapping->host;
> +	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
> +
> +	int file_end = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
> +	int mask = (1 << (msblk->block_log - PAGE_CACHE_SHIFT)) - 1;
> +	int start_index = target_page->index & ~mask;
> +	int end_index = start_index | mask;
> +	int i, n, pages, missing_pages, bytes, res = -ENOMEM;
> +	struct page **page;
> +	struct squashfs_page_actor *actor;
> +	void *pageaddr;
> +
> +	if (end_index > file_end)
> +		end_index = file_end;
> +
> +	pages = end_index - start_index + 1;
> +
> +	page = kmalloc(sizeof(void *) * pages, GFP_KERNEL);
> +	if (page == NULL)
> +		goto error_out;
> +
> +	/*
> +	 * Create a "page actor" which will kmap and kunmap the
> +	 * page cache pages appropriately within the decompressor
> +	 */
> +	actor = squashfs_page_actor_init_special(page, pages, 0);
> +	if (actor == NULL)
> +		goto error_out2;
> +
> +	/* Try to grab all the pages covered by the Squashfs block */
> +	for (missing_pages = 0, i = 0, n = start_index; i < pages; i++, n++) {
> +		page[i] = (n == target_page->index) ? target_page :
> +			grab_cache_page_nowait(target_page->mapping, n);
> +
> +		if (page[i] == NULL) {
> +			missing_pages++;
> +			continue;
> +		}
> +
> +		if (PageUptodate(page[i])) {
> +			unlock_page(page[i]);
> +			page_cache_release(page[i]);
> +			page[i] = NULL;
> +			missing_pages++;
> +		}
> +	}
> +
> +	if (missing_pages) {
> +		/*
> +		 * Couldn't get one or more pages - probably because we're
> +		 * racing with another thread in squashfs_readpage also
> +		 * trying to grab them.  Fall back to using an intermediate
> +		 * buffer.  Note as this page conflict is mutual, we
> +		 * know all the racing processes will do this.

I think other major reason to be fallback is that we are trying to read page A
because it was reclaimed by VM while other pages in the block remain page cache.
In the case, we will always be fallback and I think normally it's more frequent
than racing case of concurrent read.
But It could save by decompressor_multi.c.

> +		 */
> +		kfree(actor);
> +		return squashfs_read_cache(target_page, block, bsize, pages,

Please handle pages just in case squashfs_read_cache fails.

> +								page);
> +	}

Otherwise, looks good to me. It's really nice abstraction!
Thanks.

-- 
Kind regards,
Minchan Kim
