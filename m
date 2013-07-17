Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab3GQE2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:28:12 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53648 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3GQE2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAB+TZU9Q5tE0J-hxe=m_h0ubzyuH2saSR1Z=a2MPytUv6UBzBQ@mail.gmail.com>
References: <CAB+TZU8yjFacc2kFu-QX4QYbAT2=Fw5qZ9r1XBPEKWPPVXk=kQ@mail.gmail.com>
	<CAB+TZU9Q5tE0J-hxe=m_h0ubzyuH2saSR1Z=a2MPytUv6UBzBQ@mail.gmail.com>
Date: Wed, 17 Jul 2013 05:28:08 +0100
Message-ID: <CAB3wodeHMKYq6i5jawJJJ9fFM7n0XJq4AS2qO7JQs8-VgBivYw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] Dual Squashfs: multicore implementation
From: Phillip Lougher <phillip.lougher@gmail.com>
To: mani <manishrma@gmail.com>
Cc: phillip@squashfs.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2013 19:48, mani <manishrma@gmail.com> wrote:
>
> From 19c055d73cee8e65f8c24393450014b3560a8c6a Mon Sep 17 00:00:00 2001
> From: Manish Sharma <manishrma@gmail.com>
> Date: Mon, 1 Apr 2013 12:52:35 +0530
> Subject: [RFC PATCH 1/1] Dual Squashfs: multicore implementation

Mani,

Please don't send me the same patch twice in two days.... I received
the patch the first time.  I do have a day job (and Squashfs isn't
it), and so you shouldn't expect a response in one day.  The patch is
queued for review as time permits.

Cheers

Phillip

>
> The basic idea includes getting big requests by using readpages and
> then decompressing two blocks on each core.
> This implementation gives 50% improvement for the sequential file reads.
> 1.Split the two chunks based on the squashfs block size in readpages
> 2.Removed the locks of the decompressor(zlib/lzo) for percpu.
> 3.Increase the number of the data cache to per cpu.
> Points to consider:-
> 1. Need a lot of memory for the mutiple cache & multiple workspaces.
> 2. All the cpu will be too busy to process all the requests. cpu %usage
> increase.
> 3. Own queue method is implemented can be replaced with workqueues.
> 4. percpu data strucutures can be used.
>
> Signed-off-by: Manish Sharma <manishrma@gmail.com>
> ---
>  fs/squashfs/Kconfig          |   23 +++
>  fs/squashfs/Makefile         |    1 +
>  fs/squashfs/file.c           |  250 ++++++++++++++++++++++++++++
>  fs/squashfs/lzo_wrapper.c    |  113 ++++++++++++-
>  fs/squashfs/squashfs_fs_sb.h |    6 +-
>  fs/squashfs/super.c          |   59 ++++++-
>  fs/squashfs/tegra_mp.c       |  368
> ++++++++++++++++++++++++++++++++++++++++++
>  fs/squashfs/tegra_mp.h       |   58 +++++++
>  fs/squashfs/zlib_wrapper.c   |  160 +++++++++++++++++-
>  9 files changed, 1030 insertions(+), 8 deletions(-)
>  create mode 100644 fs/squashfs/tegra_mp.c
>  create mode 100644 fs/squashfs/tegra_mp.h
>
> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
> index c70111e..ffcf730 100644
> --- a/fs/squashfs/Kconfig
> +++ b/fs/squashfs/Kconfig
> @@ -121,3 +121,26 @@ config SQUASHFS_FRAGMENT_CACHE_SIZE
>
>        Note there must be at least one cached fragment.  Anything
>        much more than three will probably not make much difference.
> +
> +config SQUASHFS_READPAGES_ENABLE
> +    bool "Enable Readpages for Squashfs"
> +    depends on SQUASHFS
> +    default n
> +    help
> +      Saying Y here enables readpages functionality.
> +      If unsure, say N.
> +
> +config SQUASHFS_MPCORE
> +    bool "Include Multi Core support in SquashFS file systems"
> +    depends on SQUASHFS && SQUASHFS_READPAGES_ENABLE
> +    default n
> +    select SQUASHFS_4K_DEVBLK_SIZE
> +    select TEGRA_MPCORE
> +    help
> +      Saying Y here includes support for Multi Core in SquashFS file
> systems
> +      Multi Core supports creates the different kernel threads to improve
> the
> +      SquashFS boot time performance.
> +      This implementation is independent of the TEGRA board anyway as of
> now.
> +      If unsure, say N.
> +
> +
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index 110b047..0b99517 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -9,3 +9,4 @@ squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
>  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
> +squashfs-$(CONFIG_SQUASHFS_MPCORE) += tegra_mp.o
> diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
> index 8ca62c2..c134e13 100644
> --- a/fs/squashfs/file.c
> +++ b/fs/squashfs/file.c
> @@ -38,6 +38,11 @@
>   * Larger files use multiple slots, with 1.75 TiB files using all 8 slots.
>   * The index cache is designed to be memory efficient, and by default uses
>   * 16 KiB.
> + *
> + * manish.s2@samsung.com
> + * Added support for readpages for getting the bigger requests.
> + * Added Multithread support for the bigger chunks > squashfs block size
> + *
>   */
>
>  #include <linux/fs.h>
> @@ -53,6 +58,22 @@
>  #include "squashfs_fs_i.h"
>  #include "squashfs.h"
>
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +#include "tegra_mp.h"
> +
> +
> +extern struct squashfs_queue *to_reader_1;
> +#endif /* CONFIG_SQUASHFS_MPCORE*/
> +
> +
> +
> +#ifdef CONFIG_SQUASHFS_READPAGES_ENABLE
> +#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
> +#define list_to_page_index(pos, head, index) \
> +                for (pos = list_entry((head)->prev, struct page, lru);
> pos->index != index;\
> +                    pos = list_entry((pos)->prev, struct page, lru))
> +#endif
> +
>  /*
>   * Locate cache slot in range [offset, index] for specified inode.  If
>   * there's more than one return the slot closest to index.
> @@ -494,8 +515,237 @@ out:
>
>      return 0;
>  }
> +#ifdef CONFIG_SQUASHFS_READPAGES_ENABLE
> +
> +/*
> + * copy of squashfs_readpage function for
> + * supports
> + * readpages & Multicore implementation
> + */
> +int read_this_page(struct file *file, struct page *page)
> +{
> +    struct inode *inode = page->mapping->host;
> +    struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
> +    int bytes, i, offset = 0, sparse = 0;
> +    struct squashfs_cache_entry *buffer = NULL;
> +    void *pageaddr;
> +
> +    int mask = (1 << (msblk->block_log - PAGE_CACHE_SHIFT)) - 1;
> +    int index = page->index >> (msblk->block_log - PAGE_CACHE_SHIFT);
> +    int start_index = page->index & ~mask;
> +    int end_index = start_index | mask;
> +    int file_end = i_size_read(inode) >> msblk->block_log;
> +
> +    TRACE("Entered read_this_page, page index %lx, start block %llx\n",
> +                page->index, squashfs_i(inode)->start);
> +
> +
> +    if (page->index >= ((i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
> +                    PAGE_CACHE_SHIFT)){
> +        goto out;
> +    }
> +
> +    if (index < file_end || squashfs_i(inode)->fragment_block ==
> +                    SQUASHFS_INVALID_BLK) {
> +        /*
> +         * Reading a datablock from disk.  Need to read block list
> +         * to get location and block size.
> +         */
> +        u64 block = 0;
> +        int bsize = read_blocklist(inode, index, &block);
> +        if (bsize < 0)
> +            goto error_out;
> +
> +
> +        if (bsize == 0) { /* hole */
> +            bytes = index == file_end ?
> +                (i_size_read(inode) & (msblk->block_size - 1)) :
> +                 msblk->block_size;
> +            sparse = 1;
> +        } else {
> +            /*
> +             * Read and decompress datablock.
> +             */
> +            buffer = squashfs_get_datablock(inode->i_sb,
> +                                block, bsize);
> +            if (buffer->error) {
> +                ERROR("Unable to read page, block %llx, size %x"
> +                    "\n", block, bsize);
> +                squashfs_cache_put(buffer);
> +                goto error_out;
> +            }
> +            bytes = buffer->length;
> +        }
> +    } else {
> +        /*
> +         * Datablock is stored inside a fragment (tail-end packed
> +         * block).
> +         */
> +        buffer = squashfs_get_fragment(inode->i_sb,
> +                squashfs_i(inode)->fragment_block,
> +                squashfs_i(inode)->fragment_size);
> +
> +        if (buffer->error) {
> +            ERROR("Unable to read page, block %llx, size %x\n",
> +                squashfs_i(inode)->fragment_block,
> +                squashfs_i(inode)->fragment_size);
> +            squashfs_cache_put(buffer);
> +            goto error_out;
> +        }
> +        bytes = i_size_read(inode) & (msblk->block_size - 1);
> +        offset = squashfs_i(inode)->fragment_offset;
> +    }
> +
> +    /*
> +     * Loop copying datablock into pages.  As the datablock likely covers
> +     * many PAGE_CACHE_SIZE pages (default block size is 128 KiB)
> explicitly
> +     * grab the pages from the page cache, except for the page that we've
> +     * been called to fill.
> +     */
> +    for (i = start_index; i <= end_index && bytes > 0; i++,
> +            bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
> +        struct page *push_page;
> +        int avail = sparse ? 0 : min_t(int, bytes, PAGE_CACHE_SIZE);
> +
> +        TRACE("bytes %d, i %d, available_bytes %d\n", bytes, i, avail);
> +
> +        push_page = (i == page->index) ? page :
> +            grab_cache_page_nowait(page->mapping, i);
> +
> +        if (!push_page)
> +            continue;
> +
> +        if (PageUptodate(push_page))
> +            goto skip_page;
> +
> +        pageaddr = kmap_atomic(push_page);
> +        squashfs_copy_data(pageaddr, buffer, offset, avail);
> +        memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
> +        kunmap_atomic(pageaddr);
> +        flush_dcache_page(push_page);
> +        SetPageUptodate(push_page);
> +skip_page:
> +        unlock_page(push_page);
> +        if (i != page->index)
> +            page_cache_release(push_page);
> +    }
> +
> +    if (!sparse)
> +        squashfs_cache_put(buffer);
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    page_cache_release(page);
> +#endif
> +
> +    return 0;
> +
> +error_out:
> +    SetPageError(page);
> +out:
> +    pageaddr = kmap_atomic(page);
> +    memset(pageaddr, 0, PAGE_CACHE_SIZE);
> +    kunmap_atomic(pageaddr);
> +    flush_dcache_page(page);
> +    if (!PageError(page))
> +        SetPageUptodate(page);
> +    unlock_page(page);
> +
> +    return 0;
> +}
> +
> +/*
> + * readpages implementation and Multi Core implementation
> + * for squashfs
> + *
> + */
> +static int squashfs_readpages(struct file *filp, struct address_space
> *mapping,
> +    struct list_head *pages, unsigned nr_pages)
> +{
> +    unsigned page_idx;
> +
> +
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    unsigned first_page_idx;
> +    int err;
> +    unsigned long index = 0;
> +    struct squashfs_sb_info *msblk =
> filp->f_path.dentry->d_inode->i_sb->s_fs_info;
> +    unsigned int pages_per_block;
> +
> +    pages_per_block = (msblk->block_size/(PAGE_CACHE_SIZE));
> +
> +#ifdef DEBUG
> +    printk(KERN_EMERG"[%d]%s %d %d Ino %lu \n", current->pid, __FUNCTION__,
> nr_pages, pages_per_block, filp->f_path.dentry->d_inode->i_ino);
> +#endif
> +
> +    if (nr_pages > pages_per_block) {
> +
> +            /*Here we will grab the page and put into queue */
> +            for (first_page_idx = 0, page_idx = 0; page_idx < nr_pages; ) {
> +
> +                struct page *page = NULL;
> +
> +                if (first_page_idx == page_idx) {
> +                    page = list_to_page(pages);
> +                    prefetchw(&page->flags);
> +                    list_del(&page->lru);
> +                    /* Add this page to page-cache */
> +                    /*err = add_to_page_cache_lru(page, mapping,
> page->index, GFP_KERNEL);*/
> +                    err = add_to_page_cache(page, mapping, page->index,
> GFP_KERNEL);
> +                    if (unlikely(err)) {
> +                        /*printk(KERN_EMERG "releasing page cache \n");*/
> +                        page_cache_release(page);
> +                        page_idx += 1;
> +                        first_page_idx = page_idx;
> +                        continue;
> +                    }
> +                    page_idx += pages_per_block;
> +                    index = page->index;
> +                    if (queue_put(to_reader_1, filp, page))
> +                        break;
> +                } else {
> +
> +                    page = grab_cache_page_nowait(mapping, (index +
> page_idx));
> +                    if (unlikely(!page)) {
> +                        /*Need to do error checking here*/
> +                        page_idx += 1;
> +                        continue;
> +                        /*return -ENOMEM;*/
> +                    } else {
> +                        page_idx += pages_per_block;
> +                        queue_put(to_reader_1, filp, page);
> +                    }
> +
> +                }
> +
> +            }
> +
> +            work_on_queue(to_reader_1);
> +    } else
> +
> +#endif /* CONFIG_SQUASHFS_MPCORE */
> +    {
> +        /* readpages Implementation */
> +        for (page_idx = 0; page_idx < nr_pages; page_idx++) {
> +                struct page *page = list_to_page(pages);
> +                prefetchw(&page->flags);
> +                list_del(&page->lru);
> +                /*if (!add_to_page_cache_lru(page, mapping,    page->index,
> GFP_KERNEL)) {*/
> +                if (!add_to_page_cache(page, mapping,    page->index,
> GFP_KERNEL)) {
> +                    squashfs_readpage(filp, page);
> +                }
> +                page_cache_release(page);
> +        }
> +    }
> +
> +
> +    /*always return 0 as readpages either writes to a page or release it*/
> +    return 0;
> +}
> +#endif
>
>
>  const struct address_space_operations squashfs_aops = {
> +#ifdef CONFIG_SQUASHFS_READPAGES_ENABLE
> +    .readpages = squashfs_readpages,
> +#endif
>      .readpage = squashfs_readpage
>  };
> diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
> index 00f4dfc..4bcdf64 100644
> --- a/fs/squashfs/lzo_wrapper.c
> +++ b/fs/squashfs/lzo_wrapper.c
> @@ -37,7 +37,114 @@ struct squashfs_lzo {
>      void    *output;
>  };
>
> -static void *lzo_init(struct squashfs_sb_info *msblk, void *buff, int len)
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +static void *lzo_init(struct squashfs_sb_info *msblk)
> +{
> +    unsigned int i = 0;
> +    int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);
> +    unsigned int processors = num_online_cpus();
> +
> +    /* Initialization of the lzo streams */
> +    struct squashfs_lzo *stream = kmalloc(processors * sizeof(stream),
> GFP_KERNEL);
> +    if (NULL == stream) {
> +        ERROR("Failed to allocate zlib stream\n");
> +        goto failed;
> +    }
> +    for_each_online_cpu(i) {
> +        stream[i].input = vmalloc(block_size);
> +        if (stream[i].input == NULL)
> +            goto failed;
> +        stream[i].output = vmalloc(block_size);
> +        if (stream[i].output == NULL)
> +            goto failed;
> +    }
> +    return stream;
> +
> +failed:
> +    ERROR("Failed to allocate lzo workspace\n");
> +    i = 0;
> +    for_each_online_cpu(i) {
> +        if (stream[i].input)
> +            vfree(stream[i].input);
> +    }
> +    if (stream)
> +        kfree(stream);
> +    return NULL;
> +}
> +
> +
> +static void lzo_free(void *strm)
> +{
> +    unsigned int i = 0;
> +    struct squashfs_lzo *stream = strm;
> +
> +    if (stream) {
> +        for_each_online_cpu(i) {
> +            if (stream[i].input)
> +                vfree(stream[i].input);
> +            if (stream[i].output)
> +                vfree(stream[i].output);
> +        }
> +        kfree(stream);
> +    }
> +    strm = NULL;
> +}
> +
> +static int lzo_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> +    struct buffer_head **bh, int b, int offset, int length, int srclength,
> +    int pages)
> +{
> +    unsigned int pid = smp_processor_id();
> +    struct squashfs_lzo *stream = msblk->stream;
> +    void *buff = stream[pid].input;
> +    int avail, i, bytes = length, res;
> +    size_t out_len = srclength;
> +
> +    mutex_lock(&msblk->read_data_mutex[pid]);
> +
> +    for (i = 0; i < b; i++) {
> +        wait_on_buffer(bh[i]);
> +        if (!buffer_uptodate(bh[i]))
> +            goto block_release;
> +
> +        avail = min(bytes, msblk->devblksize - offset);
> +        memcpy(buff, bh[i]->b_data + offset, avail);
> +        buff += avail;
> +        bytes -= avail;
> +        offset = 0;
> +        put_bh(bh[i]);
> +    }
> +
> +    res = lzo1x_decompress_safe(stream[pid].input, (size_t)length,
> +                    stream[pid].output, &out_len);
> +    if (res != LZO_E_OK)
> +        goto failed;
> +
> +    res = bytes = (int)out_len;
> +    for (i = 0, buff = stream[pid].output; bytes && i < pages; i++) {
> +        avail = min_t(int, bytes, PAGE_CACHE_SIZE);
> +        memcpy(buffer[i], buff, avail);
> +        buff += avail;
> +        bytes -= avail;
> +    }
> +
> +    mutex_unlock(&msblk->read_data_mutex[pid]);
> +    return res;
> +
> +block_release:
> +    for (; i < b; i++)
> +        put_bh(bh[i]);
> +
> +failed:
> +    mutex_unlock(&msblk->read_data_mutex[pid]);
> +
> +    ERROR("lzo decompression failed, data probably corrupt\n");
> +    return -EIO;
> +}
> +
> +#else /* MPCORE*/
> +
> +static void *lzo_init(struct squashfs_sb_info *msblk)
>  {
>      int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);
>
> @@ -58,7 +165,7 @@ failed2:
>  failed:
>      ERROR("Failed to allocate lzo workspace\n");
>      kfree(stream);
> -    return ERR_PTR(-ENOMEM);
> +    return NULL;
>  }
>
>
> @@ -125,6 +232,8 @@ failed:
>      return -EIO;
>  }
>
> +#endif /*MPCORE*/
> +
>  const struct squashfs_decompressor squashfs_lzo_comp_ops = {
>      .init = lzo_init,
>      .free = lzo_free,
> diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
> index 52934a2..bd39cd5 100644
> --- a/fs/squashfs/squashfs_fs_sb.h
> +++ b/fs/squashfs/squashfs_fs_sb.h
> @@ -63,7 +63,11 @@ struct squashfs_sb_info {
>      __le64                    *id_table;
>      __le64                    *fragment_index;
>      __le64                    *xattr_id_table;
> -    struct mutex                read_data_mutex;
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    struct mutex        *read_data_mutex;
> +#else
> +    struct mutex        read_data_mutex;
> +#endif /*MPCORE*/
>      struct mutex                meta_index_mutex;
>      struct meta_index            *meta_index;
>      void                    *stream;
> diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
> index 260e392..2484a67 100644
> --- a/fs/squashfs/super.c
> +++ b/fs/squashfs/super.c
> @@ -25,6 +25,8 @@
>   * This file implements code to read the superblock, read and initialise
>   * in-memory structures at mount time, and all the VFS glue code to
> register
>   * the filesystem.
> + * manish.s2 : added support for multicore
> + *            : Added generic decompression selection with multicore
>   */
>
>  #include <linux/fs.h>
> @@ -43,6 +45,9 @@
>  #include "squashfs.h"
>  #include "decompressor.h"
>  #include "xattr.h"
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +#include "tegra_mp.h"
> +#endif
>
>  static struct file_system_type squashfs_fs_type;
>  static const struct super_operations squashfs_super_ops;
> @@ -85,7 +90,10 @@ static int squashfs_fill_super(struct super_block *sb,
> void *data, int silent)
>      unsigned int fragments;
>      u64 lookup_table_start, xattr_id_table_start, next_table;
>      int err;
> -
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    unsigned int i = 0;
> +    unsigned int processors = num_online_cpus();
> +#endif
>      TRACE("Entered squashfs_fill_superblock\n");
>
>      sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
> @@ -98,7 +106,20 @@ static int squashfs_fill_super(struct super_block *sb,
> void *data, int silent)
>      msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
>      msblk->devblksize_log2 = ffz(~msblk->devblksize);
>
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    /* Initialization of mutex for each core */
> +    i = 0;
> +    msblk->read_data_mutex = kmalloc((processors)*sizeof(struct mutex),
> GFP_KERNEL);
> +    if (NULL == msblk->read_data_mutex) {
> +        ERROR("unable to allocate Mutex Mem \n");
> +        goto failed_mount;
> +    }
> +    for_each_online_cpu(i) {
> +        mutex_init(&msblk->read_data_mutex[i]);
> +    }
> +#else /*MPCORE */
>      mutex_init(&msblk->read_data_mutex);
> +#endif /*MPCORE */
>      mutex_init(&msblk->meta_index_mutex);
>
>      /*
> @@ -205,13 +226,21 @@ static int squashfs_fill_super(struct super_block *sb,
> void *data, int silent)
>      if (msblk->block_cache == NULL)
>          goto failed_mount;
>
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    /* Allocate read_page block */
> +    msblk->read_page = squashfs_cache_init("data", processors,
> (msblk->block_size));
> +    if (msblk->read_page == NULL) {
> +        ERROR("Failed to allocate read_page block\n");
> +        goto failed_mount;
> +    }
> +#else
>      /* Allocate read_page block */
>      msblk->read_page = squashfs_cache_init("data", 1, msblk->block_size);
>      if (msblk->read_page == NULL) {
>          ERROR("Failed to allocate read_page block\n");
>          goto failed_mount;
>      }
> -
> +#endif
>      msblk->stream = squashfs_decompressor_init(sb, flags);
>      if (IS_ERR(msblk->stream)) {
>          err = PTR_ERR(msblk->stream);
> @@ -446,7 +475,26 @@ static int __init init_squashfs_fs(void)
>          destroy_inodecache();
>          return err;
>      }
> -
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +/*M.S the size of different cache */
> +/*fragment_buffer_size = msblk->block_size;
> +data_buffer_size = msblk->block_size;
> +metadata_buffer_size = SQUASHFS_METADATA_SIZE;
> +queue_buffer_size = data_buffer_size;
> +pages_per_block = (msblk->block_size/(PAGE_CACHE_SIZE));*/
> +/*
> +* queue_buffer_size = fragment_buffer_size + data_buffer_size +
> metadata_buffer_size;
> +* M.S :- As of now we don't need that much big size of queue
> +* 1. we are currently working on offsets equal to number of pages in the
> block size
> +* so we will take the size of the queue equal to data_buffer_size only
> +* 2. The metadata requests are same as previous no threading.
> +* 3. We reduced the queue size further to 64
> +* As of now max queue request will not be more than 64.
> +*/
> +/* M.S Adding Threads here */
> +initialise_threads(SQFS_QBUFFER_SIZE);
> +
> +#endif
>      printk(KERN_INFO "squashfs: version 4.0 (2009/01/31) "
>          "Phillip Lougher\n");
>
> @@ -456,6 +504,11 @@ static int __init init_squashfs_fs(void)
>
>  static void __exit exit_squashfs_fs(void)
>  {
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +    printk(KERN_INFO"%s \n", __FUNCTION__);
> +    /*MS Adding the exiting code */
> +    exit_threads();
> +#endif
>      unregister_filesystem(&squashfs_fs_type);
>      destroy_inodecache();
>  }
> diff --git a/fs/squashfs/tegra_mp.c b/fs/squashfs/tegra_mp.c
> new file mode 100644
> index 0000000..1d7e03f
> --- /dev/null
> +++ b/fs/squashfs/tegra_mp.c
> @@ -0,0 +1,368 @@
> +/**
> +* @file:        tegra_mp.c
> +* @brief:        Multi Core support for squashFS
> +* Copyright:  Copyright(C) Samsung India Pvt. Ltd 2011. All Rights
> Reserved.
> +* @author:      SISC: manish.s2
> +* @date:        2011/03/10
> +* @History:
> +*        v1.1a is stable & support dual core.
> +*        v1.2  added multi core support.
> +*        v1.8  Fix the bug for the queue fill ptr overrun
> +*/
> +
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/cpumask.h>
> +#include <linux/cpu.h>
> +#include <linux/slab.h>
> +
> +#include "squashfs_fs_i.h"
> +#include "squashfs.h"
> +#include "tegra_mp.h"
> +
> +
> +struct squashfs_queue *to_reader_1;
> +static struct task_struct **thread;
> +
> +extern int read_this_page(struct file *file, struct page *page);
> +
> +int queue_fini(struct squashfs_queue *queue)
> +{
> +
> +    if (queue == NULL) {
> +        printk(KERN_INFO "ERROR: Wrong queue ptr\n");
> +        return -EFAULT;
> +    }
> +
> +
> +    if (NULL != queue->data) {
> +        kfree(queue->data);
> +        queue->data = NULL;
> +    }
> +
> +    if (NULL != queue->cpu) {
> +        kfree(queue->cpu);
> +        queue = NULL;
> +    }
> +    if (NULL != queue) {
> +        kfree(queue);
> +        queue = NULL;
> +    }
> +
> +    return 0;
> +}
> +
> +struct squashfs_queue *queue_init(int size)
> +{
> +
> +    unsigned int i = 0;
> +    int processors;
> +    struct squashfs_queue *queue = NULL;
> +
> +#ifdef DEBUG
> +    printk(KERN_INFO "[%s] size %d \n", __FUNCTION__, size + 1);
> +#endif
> +
> +    processors = num_online_cpus();
> +
> +    queue = (struct squashfs_queue *)kmalloc(sizeof(struct squashfs_queue),
> GFP_KERNEL);
> +    if (queue == NULL) {
> +        printk(KERN_INFO "Out of memory in queue_init\n");
> +        return NULL;
> +    }
> +
> +    queue->data = (struct squashfs_qdata *)kmalloc((sizeof(struct
> squashfs_qdata) * (size + 1)), GFP_KERNEL);
> +    if (NULL == queue->data) {
> +        printk(KERN_INFO "unable to get the memory \n");
> +        queue_fini(queue);
> +        return NULL;
> +    }
> +
> +    queue->cpu = kmalloc(processors * (sizeof(int)), GFP_KERNEL);
> +    if (NULL == queue->cpu) {
> +        printk(KERN_INFO "unable to get the memory for cpu \n");
> +        queue_fini(queue);
> +        return NULL;
> +    }
> +
> +
> +    for_each_online_cpu(i) {
> +        queue->cpu[i] = 0;
> +    }
> +
> +    queue->size = size + 1;
> +    queue->readp = queue->writep = 0;
> +    queue->empty = 1;
> +    queue->full = 0;
> +    queue->stop = 0;
> +    init_waitqueue_head(&queue->wait_queue);
> +    spin_lock_init(&queue->lock);
> +
> +    return queue;
> +}
> +
> +
> +int queue_put(struct squashfs_queue *queue, void *filp, void *page)
> +{
> +    int processor_id = 0;
> +    unsigned int i = 0;
> +    spin_lock(&queue->lock);
> +
> +    processor_id = raw_smp_processor_id();
> +
> +    if (((queue->writep + 1) % queue->size) == queue->readp) {
> +#ifdef DEBUG
> +        printk(KERN_INFO "[%d] Queue is  full: page %lu \n", current->pid,
> ((struct page *)page)->index);
> +#endif
> +        queue->full = 1;
> +        spin_unlock(&queue->lock);
> +
> +        for_each_online_cpu(i) {
> +            if (i != processor_id) {
> +                queue->cpu[i] = 1;
> +            }
> +
> +        }
> +        wake_up(&queue->wait_queue);
> +        wait_event_timeout(queue->wait_queue, !queue->full,
> msecs_to_jiffies(100));
> +        spin_lock(&queue->lock);
> +        if (((queue->writep + 1) % queue->size) == queue->readp) {
> +#ifdef DEBUG
> +            printk(KERN_EMERG "[%d] Queue is still full: page %lu \n",
> current->pid, ((struct page *)page)->index);
> +            printk(KERN_EMERG "[%d] Check threads \n", current->pid);
> +#endif
> +            spin_unlock(&queue->lock);
> +            return -1;
> +        }
> +        processor_id = raw_smp_processor_id();
> +    }
> +
> +    queue->data[queue->writep].filp = filp;
> +    queue->data[queue->writep].page = page;
> +    queue->writep = ((queue->writep + 1) % queue->size);
> +    queue->empty = 0;
> +
> +#ifdef DEBUG
> +    printk(KERN_EMERG "[%d]queue put w%d:r%d page %lu \n", current->pid,
> queue->writep, queue->readp, ((struct page *)page)->index);
> +#endif
> +
> +    for_each_online_cpu(i) {
> +        if (i != processor_id) {
> +            /*printk(KERN_INFO"waking up %d processor \n",i);*/
> +            queue->cpu[i] = 1;
> +        }
> +
> +    }
> +    spin_unlock(&queue->lock);
> +    wake_up(&queue->wait_queue);
> +    return 0;
> +}
> +
> +
> +int queue_get(struct squashfs_queue *queue, int id, struct squashfs_qdata
> *data)
> +{
> +    /*struct squashfs_qdata  *data;*/
> +    int processor_id = 0;
> +#ifdef DEBUG
> +    printk(KERN_INFO "queue get %d \n", raw_smp_processor_id());
> +#endif
> +    spin_lock(&queue->lock);
> +    processor_id = raw_smp_processor_id();
> +
> +        /* wait here if queue is empty */
> +        if (queue->readp == queue->writep) {
> +
> +            if (1 == id) {
> +                queue->empty = 1;
> +                queue->full = 0;
> +                spin_unlock(&queue->lock);
> +                wake_up(&queue->wait_queue);
> +                return -1;
> +            }
> +
> +#ifdef DEBUG
> +            printk(KERN_EMERG "[%d] Need to wait here as queue is empty
> \n", current->pid);
> +#endif
> +            queue->empty = 1;
> +            queue->full = 0;
> +            queue->cpu[processor_id] = 0;
> +            wake_up(&queue->wait_queue);
> +            spin_unlock(&queue->lock);
> +            wait_event_interruptible(queue->wait_queue,
> queue->cpu[processor_id]);
> +
> +            /* After the thread gets out from wait queue */
> +            spin_lock(&queue->lock);
> +            if (queue->stop || (queue->readp == queue->writep)) {
> +                queue->empty = 1;
> +                queue->full = 0;
> +                wake_up(&queue->wait_queue);
> +                spin_unlock(&queue->lock);
> +#ifdef DEBUG
> +                printk(KERN_INFO " Thread%ld %s \n", current->cpus_allowed,
> (queue->stop ? "should stop" : "queue is empty"));
> +#endif
> +                return -1;
> +            }
> +        }
> +
> +
> +    data->filp = queue->data[queue->readp].filp;
> +    data->page = queue->data[queue->readp].page;
> +    queue->data[queue->readp].filp = NULL;
> +    queue->data[queue->readp].page = NULL;
> +    queue->readp = (queue->readp + 1) % queue->size;
> +    queue->full = 0;
> +#ifdef DEBUG
> +    printk(KERN_EMERG "[%d]queue get w%d:r%d  page %lu \n", \
> +        current->pid, queue->writep, queue->readp, ((struct page
> *)data->page)->index);
> +#endif
> +    spin_unlock(&queue->lock);
> +    wake_up(&queue->wait_queue);
> +
> +
> +    return 0;
> +}
> +
> +
> +
> +void squashfs_thread(void *arg)
> +{
> +
> +    struct squashfs_qdata data;
> +    int ret = 0;
> +
> +    set_user_nice(current, -20);
> +    printk(KERN_INFO "### Started squashfs thread_%d \n",
> raw_smp_processor_id());
> +    while (!kthread_should_stop()) {
> +
> +
> +        ret = queue_get(to_reader_1, 0, &data);
> +        if (unlikely(0 > ret)) {
> +            if (to_reader_1->stop) {
> +                printk(KERN_INFO"ERROR : We are seeing the stop being
> set\n");
> +                break;
> +            } else {
> +                continue;
> +            }
> +        } else {
> +#ifdef DEBUG
> +            /* Can remove this as its for error checking */
> +            if ((NULL != data.filp) && (NULL != data.page)) {
> +                printk(KERN_INFO "here it is page index %ld \n",
> data.page->index);
> +                read_this_page(data.filp, data.page);
> +            } else {
> +                printk(KERN_INFO"Ptr is NULL \n");
> +            }
> +#else
> +            read_this_page(data.filp, data.page);
> +#endif
> +
> +
> +        }
> +
> +    }
> +    printk(KERN_INFO"SquashFS Thread : I am dying!\n");
> +
> +}
> +
> +void squashfs_process_data(void)
> +{
> +
> +    struct squashfs_qdata data;
> +    int ret = 0;
> +
> +    while (1) {
> +
> +
> +        ret = queue_get(to_reader_1, 1, &data);
> +        if (unlikely(0 > ret)) {
> +#ifdef DEBUG
> +          printk(KERN_INFO "[%s][%d] Q is empty so we are exiting \n",
> __FUNCTION__, current->pid);
> +#endif
> +          break;
> +        } else {
> +          read_this_page(data.filp, data.page);
> +        }
> +
> +    }
> +
> +}
> +
> +void work_on_queue(struct squashfs_queue *queue)
> +{
> +    squashfs_process_data();
> +}
> +
> +int initialise_threads(int queue_buffer_size)
> +{
> +    unsigned int i = 0;
> +    int processors;
> +
> +    processors = num_online_cpus();
> +
> +#ifdef DEBUG
> +    printk(KERN_INFO "no of active cores %d \n", processors);
> +#endif
> +
> +    /* Initialize the Queue */
> +    to_reader_1 = queue_init(queue_buffer_size);
> +
> +
> +    if ((thread = kmalloc((NOTHR_THREADS + processors) * sizeof(struct
> task_struct *), GFP_KERNEL)) == NULL) {
> +        printk(KERN_INFO "Out of memory allocating thread descriptors\n");
> +        return -ENOMEM;
> +    }
> +
> +
> +    /* Create Number n Number of Deflator threads same as core.*/
> +    for_each_online_cpu(i) {
> +        printk(KERN_INFO "Created %d thread \n", i);
> +        thread[NOTHR_THREADS + i] = kthread_create((void *)squashfs_thread,
> NULL, MODULE_NAME);
> +        if (IS_ERR(thread[NOTHR_THREADS + i])) {
> +            printk(KERN_ERR ": unable to start deflator kernel thread\n");
> +            return -ENOMEM;
> +        } else {
> +            printk(KERN_INFO" ################## \n");
> +            printk(KERN_INFO"Binding cpu %d \n", i);
> +            kthread_bind(thread[NOTHR_THREADS + i], i);
> +            wake_up_process(thread[NOTHR_THREADS + i]);
> +        }
> +    }
> +
> +
> +    return 0;
> +
> +}
> +
> +void exit_threads()
> +{
> +    int i = 0;
> +
> +    /* wake up both threads */
> +    to_reader_1->empty = 0;
> +    to_reader_1->stop = 1;
> +    for_each_online_cpu(i) {
> +        to_reader_1->cpu[i] = 1;
> +    }
> +    wake_up_all(&to_reader_1->wait_queue);
> +
> +#if 0
> +    for (i = NOTHR_THREADS; i < (NOTHR_THREADS + NR_CPUS); i++) {
> +
> +        if (NULL != thread[i])
> +            kthread_stop(thread[i]);
> +
> +    }
> +  if (thread)
> +        kfree(thread);
> +
> +#endif
> +    /* We have only one queue as of now */
> +    if (queue_fini(to_reader_1))
> +        printk(KERN_INFO"ERROR: In queue deallocation \n");
> +
> +
> +}
> +
> diff --git a/fs/squashfs/tegra_mp.h b/fs/squashfs/tegra_mp.h
> new file mode 100644
> index 0000000..ca60c56
> --- /dev/null
> +++ b/fs/squashfs/tegra_mp.h
> @@ -0,0 +1,58 @@
> +/**
> +* @file    tegra_mp.h
> +* @brief   Multi Core support for squashFS
> +* Copyright:  Copyright(C) Samsung India Pvt. Ltd 2011. All Rights
> Reserved.
> +* @author  SISC: manish.s2
> +* @date    2011/03/10
> +* @desc       Added Multi core support in squashfs
> +*/
> +#ifndef __MP_TEGRA__
> +#define __MP_TEGRA__
> +
> +
> +#include <linux/fs.h>
> +#include <linux/vfs.h>
> +#include <linux/wait.h>
> +
> +/* Total number of other threads except if needed */
> +/*#define NOTHR_THREADS        3 // To be used if we additional threads or
> so.*/
> +#define NOTHR_THREADS        0
> +#define MODULE_NAME     "tegra_mpcore"
> +
> +/* Max page pool size 64 and min squashfs block size 4k */
> +#define SQFS_QBUFFER_SIZE (64)
> +
> +/*#define DEBUG*/
> +
> +struct squashfs_qdata{
> +    struct file *filp;
> +    struct page *page;
> +    int index;
> +};
> +
> +
> +/* struct describing queues used to pass data between threads */
> +struct squashfs_queue {
> +    int    size;
> +    int    readp;
> +    int    writep;
> +    wait_queue_head_t    wait_queue;
> +    spinlock_t lock;
> +
> +    int empty;
> +    int full;
> +    int *cpu;
> +    int stop;
> +    struct squashfs_qdata *data;
> +};
> +
> +
> +/* Functions */
> +int initialise_threads(int queue_buffer_size);
> +void exit_threads(void);
> +int queue_put(struct squashfs_queue *queue, void *filp, void *page);
> +int queue_get(struct squashfs_queue *queue, int id, struct squashfs_qdata
> *data);
> +struct squashfs_queue *queue_init(int size);
> +void work_on_queue(struct squashfs_queue *queue);
> +
> +#endif /*__MP_TEGRA__*/
> diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
> index 55d918f..5e8b0a1 100644
> --- a/fs/squashfs/zlib_wrapper.c
> +++ b/fs/squashfs/zlib_wrapper.c
> @@ -19,7 +19,13 @@
>   * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
>   *
>   * zlib_wrapper.c
> - */
> + * manish.s2: added the dual core support for squashfs.
> + *        : Seperate mutex & z_stream for each core.
> + *        : generalized for multicores.
> + *         : Added seperate mutex and zlib stream for Multicore.
> + *        : Replace zlib_init with zlib_reset for performance.
> + *
> +*/
>
>
>  #include <linux/mutex.h>
> @@ -33,6 +39,156 @@
>  #include "squashfs.h"
>  #include "decompressor.h"
>
> +#ifdef CONFIG_SQUASHFS_MPCORE
> +static void *zlib_init(struct squashfs_sb_info *dummy, void *buff, int len)
> +{
> +    unsigned int processors = num_online_cpus();
> +    unsigned int i = 0;
> +    int zlib_err = 0;
> +
> +    z_stream *stream = kmalloc((processors * sizeof(z_stream)),
> GFP_KERNEL);
> +    if (stream == NULL)
> +        goto failed;
> +
> +    for_each_online_cpu(i) {
> +        stream[i].workspace = kmalloc(zlib_inflate_workspacesize(),
> +            GFP_KERNEL);
> +        if (stream[i].workspace == NULL)
> +            goto failed;
> +        zlib_err = zlib_inflateInit(&(stream[i]));
> +        if (zlib_err != Z_OK) {
> +            ERROR("zlib_inflateInit returned unexpected "
> +                "result 0x%x\n",
> +                zlib_err);
> +            goto failed;
> +        }
> +    }
> +    return stream;
> +
> +failed:
> +    ERROR("Failed to allocate zlib workspace\n");
> +    i = 0;
> +    for_each_online_cpu(i) {
> +        if (stream[i].workspace)
> +            kfree(stream[i].workspace);
> +    }
> +    if (stream)
> +        kfree(stream);
> +    return NULL;
> +}
> +
> +
> +static void zlib_free(void *strm)
> +{
> +    z_stream *stream = strm;
> +    unsigned int i = 0;
> +
> +    for_each_online_cpu(i) {
> +        if (stream[i].workspace)
> +            kfree(stream[i].workspace);
> +    }
> +    if (stream)
> +        kfree(stream);
> +    strm = NULL;
> +}
> +
> +
> +static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> +    struct buffer_head **bh, int b, int offset, int length, int srclength,
> +    int pages)
> +{
> +    int zlib_err = 0;
> +    int avail, bytes, k = 0, page = 0;
> +    unsigned int pid = smp_processor_id();
> +    z_stream *stream = msblk->stream;
> +
> +    mutex_lock(&msblk->read_data_mutex[pid]);
> +    /*printk(KERN_INFO "[%s] pid %d \n",__FUNCTION__,pid);*/
> +    /*
> +     * We are resetting zlib stream here so that it avoids the
> +     * overhead of zlib_init again and again for each
> +     * request.
> +    */
> +    zlib_err = zlib_inflateReset(&(stream[pid]));
> +    if (zlib_err != Z_OK) {
> +        ERROR("zlib_Reset returned %d \n", zlib_err);
> +        printk(KERN_EMERG"zlib_Reset returned %d \n", zlib_err);
> +        goto release_mutex;
> +    }
> +
> +    stream[pid].avail_out = 0;
> +    stream[pid].avail_in = 0;
> +
> +    bytes = length;
> +    do {
> +        if (stream[pid].avail_in == 0 && k < b) {
> +            avail = min(bytes, msblk->devblksize - offset);
> +            bytes -= avail;
> +            wait_on_buffer(bh[k]);
> +            if (!buffer_uptodate(bh[k]))
> +                goto release_mutex;
> +
> +            if (avail == 0) {
> +                offset = 0;
> +                put_bh(bh[k++]);
> +                continue;
> +            }
> +
> +            stream[pid].next_in = bh[k]->b_data + offset;
> +            stream[pid].avail_in = avail;
> +            offset = 0;
> +        }
> +
> +        if (stream[pid].avail_out == 0 && page < pages) {
> +            stream[pid].next_out = buffer[page++];
> +            stream[pid].avail_out = PAGE_CACHE_SIZE;
> +        }
> +#if 0
> +        if (!zlib_init) {
> +            zlib_err = zlib_inflateInit(&(stream[pid]));
> +            if (zlib_err != Z_OK) {
> +                ERROR("zlib_inflateInit returned unexpected "
> +                    "result 0x%x, srclength %d\n",
> +                    zlib_err, srclength);
> +                goto release_mutex;
> +            }
> +            zlib_init = 1;
> +        }
> +#endif
> +
> +        zlib_err = zlib_inflate(&(stream[pid]), Z_SYNC_FLUSH);
> +
> +        if (stream[pid].avail_in == 0 && k < b)
> +            put_bh(bh[k++]);
> +    } while (zlib_err == Z_OK);
> +
> +    if (zlib_err != Z_STREAM_END) {
> +        ERROR("zlib_inflate error, data probably corrupt %d \n", zlib_err);
> +        printk(KERN_INFO"avail in %d  avail out %d \n",
> stream[pid].avail_in, stream[pid].avail_out);
> +        goto release_mutex;
> +    }
> +#if 0
> +    zlib_err = zlib_inflateEnd(&(stream[pid]));
> +    if (zlib_err != Z_OK) {
> +        ERROR("zlib_inflate error, data probably corrupt\n");
> +        goto release_mutex;
> +    }
> +#endif
> +    length = stream[pid].total_out;
> +    mutex_unlock(&msblk->read_data_mutex[pid]);
> +    return length;
> +
> +release_mutex:
> +    mutex_unlock(&msblk->read_data_mutex[pid]);
> +
> +    for (; k < b; k++)
> +        put_bh(bh[k]);
> +
> +    return -EIO;
> +}
> +
> +#else /* MPCORE*/
> +
>  static void *zlib_init(struct squashfs_sb_info *dummy, void *buff, int len)
>  {
>      z_stream *stream = kmalloc(sizeof(z_stream), GFP_KERNEL);
> @@ -137,7 +293,7 @@ release_mutex:
>
>      return -EIO;
>  }
> -
> +#endif /* MPCORE*/
>  const struct squashfs_decompressor squashfs_zlib_comp_ops = {
>      .init = zlib_init,
>      .free = zlib_free,
> --
> 1.7.9.5
>
>
>
