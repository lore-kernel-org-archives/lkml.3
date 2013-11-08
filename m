Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3KHIYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:24:00 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42383 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KHIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:23:56 -0500
X-AuditID: 9c93017d-b7b56ae0000066c1-80-527c9f9af365
Date: Fri, 8 Nov 2013 17:23:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Squashfs: Directly decompress into the page cache
 for file data (V2)
Message-ID: <20131108082354.GD4038@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-7-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383855865-4683-7-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 08:24:25PM +0000, Phillip Lougher wrote:
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
> 
> V2:
>   * update comment adding failure to grab pages could be
>     because we've been VM reclaimed, but the other pages are
>     still in the page cache and uptodate.
>   * Make Kconfig option a choice, making the either-other nature of
>     the option more explicit, and also tidying up the ifdef in the
>     Makefile
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---
>  fs/squashfs/Kconfig       |   28 +++++++
>  fs/squashfs/Makefile      |    4 +-
>  fs/squashfs/file_direct.c |  178 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/squashfs/page_actor.c  |  104 ++++++++++++++++++++++++++
>  fs/squashfs/page_actor.h  |   32 ++++++++
>  5 files changed, 345 insertions(+), 1 deletion(-)
>  create mode 100644 fs/squashfs/file_direct.c
>  create mode 100644 fs/squashfs/page_actor.c
> 
> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
> index c92c75f..3a21adf 100644
> --- a/fs/squashfs/Kconfig
> +++ b/fs/squashfs/Kconfig
> @@ -26,6 +26,34 @@ config SQUASHFS
>  	  If unsure, say N.
>  
>  choice
> +	prompt "File decompression options"
> +	depends on SQUASHFS
> +	help
> +	  Squashfs now supports two options for decompressing file
> +	  data.  Traditionally Squashfs has decompressed into an
> +	  intermediate buffer and then memcopied it into the page cache.
> +	  Squashfs now supports the ability to decompress directly into
> +	  the page cache.
> +
> +	  If unsure, select "Decompress file data into an intermediate buffer"
> +
> +config SQUASHFS_FILE_CACHE
> +	bool "Decompress file data into an intermediate buffer"
> +	help
> +	  Decompress file data into an intermediate buffer and then
> +	  memcopy it into the page cache.
> +
> +config SQUASHFS_FILE_DIRECT
> +	bool "Decompress files directly into the page cache"
> +	help
> +	  Directly decompress file data into the page cache.
> +	  Doing so can significantly improve performance because
> +	  it eliminates a mempcpy and it also removes the lock contention

                          memcpy

> +	  on the single buffer.
> +
> +endchoice
> +
> +choice
>  	prompt "Decompressor parallelisation options"
>  	depends on SQUASHFS
>  	help
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index 908c0d9..4132520 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -4,7 +4,9 @@
>  
>  obj-$(CONFIG_SQUASHFS) += squashfs.o
>  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
> -squashfs-y += namei.o super.o symlink.o decompressor.o file_cache.c
> +squashfs-y += namei.o super.o symlink.o decompressor.o
> +squashfs-$(CONFIG_SQUASHFS_FILE_CACHE) += file_cache.o
> +squashfs-$(CONFIG_SQUASHFS_FILE_DIRECT) += file_direct.o page_actor.o
>  squashfs-$(CONFIG_SQUASHFS_DECOMP_SINGLE) += decompressor_single.o
>  squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI) += decompressor_multi.o
>  squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU) += decompressor_multi_percpu.o
> diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
> new file mode 100644
> index 0000000..d020d94
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
> +		 * Couldn't get one or more pages, this page has either
> +		 * been VM reclaimed, but others are still in the page cache
> +		 * and uptodate, or we're racing with another thread in
> +		 * squashfs_readpage also trying to grab them.  Fall back to
> +		 * using an intermediate buffer.
> +		 */
> +		kfree(actor);
> +		return squashfs_read_cache(target_page, block, bsize, pages,
> +								page);
> +	}
> +
> +	/* Decompress directly into the page cache buffers */
> +	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
> +	if (res < 0)
> +		goto mark_errored;
> +
> +	/* Last page may have trailing bytes not filled */
> +	bytes = res % PAGE_CACHE_SIZE;
> +	if (bytes) {
> +		pageaddr = kmap_atomic(page[pages - 1]);
> +		memset(pageaddr + bytes, 0, PAGE_CACHE_SIZE - bytes);
> +		kunmap_atomic(pageaddr);
> +	}
> +
> +	/* Mark pages as uptodate, unlock and release */
> +	for (i = 0; i < pages; i++) {
> +		flush_dcache_page(page[i]);
> +		SetPageUptodate(page[i]);
> +		unlock_page(page[i]);
> +		if (page[i] != target_page)
> +			page_cache_release(page[i]);
> +	}
> +
> +	kfree(actor);
> +	kfree(page);
> +
> +	return 0;
> +
> +mark_errored:
> +	/* Decompression failed, mark pages as errored.  Target_page is
> +	 * dealt with by the caller
> +	 */
> +	for (i = 0; i < pages; i++) {
> +		if (page[i] == target_page)
> +			continue;
> +		pageaddr = kmap_atomic(page[i]);
> +		memset(pageaddr, 0, PAGE_CACHE_SIZE);

Do we need page zeroing?
If others see !PG_uptodate, it will retry to read so I guess we don't need it.

> +		kunmap_atomic(pageaddr);
> +		flush_dcache_page(page[i]);
> +		SetPageError(page[i]);
> +		unlock_page(page[i]);
> +		page_cache_release(page[i]);
> +	}
> +
> +	kfree(actor);
> +error_out2:
> +	kfree(page);
> +error_out:
> +	return res;
> +}
> +
> +
> +static int squashfs_read_cache(struct page *target_page, u64 block, int bsize,
> +	int pages, struct page **page)
> +{
> +	struct inode *i = target_page->mapping->host;
> +	struct squashfs_cache_entry *buffer = squashfs_get_datablock(i->i_sb,
> +						 block, bsize);
> +	int bytes = buffer->length, res = buffer->error, n, offset = 0;
> +	void *pageaddr;
> +
> +	if (res) {
> +		ERROR("Unable to read page, block %llx, size %x\n", block,
> +			bsize);
> +		goto out;
> +	}
> +
> +	for (n = 0; n < pages && bytes > 0; n++,
> +			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
> +		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);
> +
> +		if (page[n] == NULL)
> +			continue;
> +
> +		pageaddr = kmap_atomic(page[n]);
> +		squashfs_copy_data(pageaddr, buffer, offset, avail);
> +		memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
> +		kunmap_atomic(pageaddr);
> +		flush_dcache_page(page[n]);
> +		SetPageUptodate(page[n]);
> +		unlock_page(page[n]);
> +		if (page[n] != target_page)
> +			page_cache_release(page[n]);
> +	}
> +
> +out:
> +	squashfs_cache_put(buffer);

Nitpick:

It would be better to free page in caller rather than caller if the function
return error?

> +	kfree(page);
> +	return res;
> +}
> diff --git a/fs/squashfs/page_actor.c b/fs/squashfs/page_actor.c
> new file mode 100644
> index 0000000..8e754ff
> --- /dev/null
> +++ b/fs/squashfs/page_actor.c
> @@ -0,0 +1,104 @@
> +/*
> + * Copyright (c) 2013
> + * Phillip Lougher <phillip@squashfs.org.uk>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/pagemap.h>
> +#include "page_actor.h"
> +
> +/* Implementation of page_actor for decompressing into intermediate buffer */
> +static void *cache_first_page(struct squashfs_page_actor *actor)
> +{
> +	actor->next_page = 1;
> +	return actor->buffer[0];
> +}
> +
> +static void *cache_next_page(struct squashfs_page_actor *actor)
> +{
> +	if (actor->next_page == actor->pages)
> +		return NULL;
> +
> +	return actor->buffer[actor->next_page++];
> +}
> +
> +static void cache_finish_page(struct squashfs_page_actor *actor)
> +{
> +	/* empty */
> +}
> +
> +struct squashfs_page_actor *squashfs_page_actor_init(void **buffer,
> +	int pages, int length)
> +{
> +	struct squashfs_page_actor *actor = kmalloc(sizeof(*actor), GFP_KERNEL);
> +
> +	if (actor == NULL)
> +		return NULL;
> +
> +	if (length)
> +		actor->length = length;
> +	else
> +		actor->length = pages * PAGE_CACHE_SIZE;
> +	actor->buffer = buffer;
> +	actor->pages = pages;
> +	actor->next_page = 0;
> +
> +	actor->squashfs_first_page = cache_first_page;
> +	actor->squashfs_next_page = cache_next_page;
> +	actor->squashfs_finish_page = cache_finish_page;
> +	return actor;
> +}
> +
> +/* Implementation of page_actor for decompressing directly into page cache */
> +static void *direct_first_page(struct squashfs_page_actor *actor)
> +{
> +	actor->next_page = 1;
> +	return actor->pageaddr = kmap_atomic(actor->page[0]);
> +}


Just my two cents

It makes new rule that we shouldn't call blocking function during page
enumerating with page_actor. Somewhere comment about that will be helpful.

> +
> +static void *direct_next_page(struct squashfs_page_actor *actor)
> +{
> +	if (actor->pageaddr)
> +		kunmap_atomic(actor->pageaddr);
> +
> +	if (actor->next_page == actor->pages) {
> +		actor->pageaddr = NULL;
> +		return NULL;
> +	}
> +
> +	return actor->pageaddr = kmap_atomic(actor->page[actor->next_page++]);
> +}
> +
> +static void direct_finish_page(struct squashfs_page_actor *actor)
> +{
> +	if (actor->pageaddr)
> +		kunmap_atomic(actor->pageaddr);
> +}
> +
> +
> +struct squashfs_page_actor *squashfs_page_actor_init_special(struct page **page,
> +	int pages, int length)
> +{
> +	struct squashfs_page_actor *actor = kmalloc(sizeof(*actor), GFP_KERNEL);
> +
> +	if (actor == NULL)
> +		return NULL;
> +
> +	if (length)
> +		actor->length = length;
> +	else
> +		actor->length = pages * PAGE_CACHE_SIZE;
> +	actor->page = page;
> +	actor->pages = pages;
> +	actor->next_page = 0;
> +	actor->pageaddr = NULL;
> +
> +	actor->squashfs_first_page = direct_first_page;
> +	actor->squashfs_next_page = direct_next_page;
> +	actor->squashfs_finish_page = direct_finish_page;
> +	return actor;
> +}
> diff --git a/fs/squashfs/page_actor.h b/fs/squashfs/page_actor.h
> index 19a66a3..22731c7 100644
> --- a/fs/squashfs/page_actor.h
> +++ b/fs/squashfs/page_actor.h
> @@ -8,6 +8,7 @@
>   * the COPYING file in the top-level directory.
>   */
>  
> +#ifndef CONFIG_SQUASHFS_FILE_DIRECT
>  struct squashfs_page_actor {
>  	void	**page;
>  	int	pages;
> @@ -51,4 +52,35 @@ static inline void squashfs_finish_page(struct squashfs_page_actor *actor)
>  {
>  	/* empty */
>  }
> +#else
> +struct squashfs_page_actor {
> +	union {
> +		void		**buffer;
> +		struct page	**page;
> +	};
> +	void	*pageaddr;
> +	void    *(*squashfs_first_page)(struct squashfs_page_actor *);
> +	void    *(*squashfs_next_page)(struct squashfs_page_actor *);
> +	void    (*squashfs_finish_page)(struct squashfs_page_actor *);
> +	int	pages;
> +	int	length;
> +	int	next_page;
> +};
> +
> +extern struct squashfs_page_actor *squashfs_page_actor_init(void **, int, int);
> +extern struct squashfs_page_actor *squashfs_page_actor_init_special(struct page
> +							 **, int, int);
> +static inline void *squashfs_first_page(struct squashfs_page_actor *actor)
> +{
> +	return actor->squashfs_first_page(actor);
> +}
> +static inline void *squashfs_next_page(struct squashfs_page_actor *actor)
> +{
> +	return actor->squashfs_next_page(actor);
> +}
> +static inline void squashfs_finish_page(struct squashfs_page_actor *actor)
> +{
> +	actor->squashfs_finish_page(actor);
> +}
> +#endif
>  #endif

Most of thing from me are just nitpicks.
Looks great to me.

Thanks, Phillip.

Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
