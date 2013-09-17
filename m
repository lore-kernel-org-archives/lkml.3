Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3IQD0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:26:25 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47105 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3IQD0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:26:20 -0400
Date: Tue, 17 Sep 2013 11:26:09 +0800
From: majianpeng <majianpeng@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: "Andi Kleen" <ak@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: [BUG] On x86_32 system, handle block-device which size is larger than 16TB.
References: <5178E4B4.4060308@gmail.com>
X-Priority: 3
X-GUID: FDAA4334-950E-40EC-B3CF-E936E50ABD76
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309171126070266609@gmail.com>
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H3QUo2008963

Hi all,
	This patch has a long long time.How about this patch?

Thanks!
Jianpeng Ma
>Hi all,
>    Some time ago, I mentioned there are some problems on x86-32 system about handling md-block-device which size is larger than 16TB.
>And i send a patch.But there are no concern with it.
>The website of  is:  http://www.spinics.net/lists/linux-fsdevel/msg55672.html.
>
>Except the wrapping problem, recently i found another problem.It will cause infinite loop.At lease i watched one hour, the programs don't end.
>
>On x86-32 system, the version of kernel is 3.9-rc8. Disk is raid0  which size is about 17TB.
>The test program is:
> int main()
>{
>        long long max_size = (4096LL << 32);
>        int fd = open("/dev/md0", O_RDWR);
>        off64_t off;
>        int ret;
>        char *buff = memalign(512, 4096);
>
>        if (buff == NULL) {
>                printf("memalign error %s\n", strerror(errno));
>                exit(-1);
>        }
>        if (fd < 0) {
>                printf("open error %s\n", strerror(errno));
>                return -errno;
>        }
>
>        if ((off = lseek64(fd, max_size - 2000, SEEK_SET)) < 0)
>                printf("lseek64 error %s\n", strerror(errno));
>        else
>                printf("off 0x%llx\n", off);
>        if ((ret = write(fd, buff, 4096)) < 0)
>                printf("write error %s\n",  strerror(errno));
>        else
>                printf("write return %d\n", ret);
>        close(fd);
>        return 0;
>}
>
>If run this problem, it will not be end up.Because the close(fd) operation.
>The reason is:
>close(fd)---->blkdev_close-->sync_blockdev--->filemap_write_and_wait--->__filemap_fdatawrite_range--->do_writepages-->write_cache_pages.
>In function write_cache_pages:
> >               nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
> >                             min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
> >               if (nr_pages == 0)
> >                       break;
>Because there is only on dirty page which index is 0xFFFFFFFF.
>>                for (i = 0; i < nr_pages; i++) {
>                            ..........
>>                            ret = (*writepage)(page, wbc, data);
>So the function blkdev_writepage will be called.
>blkdev_writepage---->block_write_full_page---->block_write_full_page_endio.
>In function block_write_full_page_endio:
>>       struct inode * const inode = page->mapping->host;
>>        loff_t i_size = i_size_read(inode);
>>        const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
>>        unsigned offset;
>
>>        /* Is the page fully inside i_size? */
>>        if (page->index < end_index)
>                return __block_write_full_page(inode, page, get_block, wbc,
>                                               handler);
>Because page->index is 0xfffffff,but the end_index is very litter because the wrapping.
>On x86-32os, pgoff_t is unsigned long .So 17TB >> PAGE_CACHE_SHIFT will be overflow.
>>        /* Is the page fully outside i_size? (truncate in progress) */
>>        offset = i_size & (PAGE_CACHE_SIZE-1);
>>        if (page->index >= end_index+1 || !offset) {
>Because end_index is less than page->index.So it will be return there.So the PAGECACHE_TAG_TOWRITE will not be clear.
>So it will continue to do.
>>                /*
>>                 * The page may have dirty, unmapped buffers.  For example,
>>                 * they may have been added in ext3_writepage().  Make them
>>                 * freeable here, so the page does not leak.
>>                 */
>>                do_invalidatepage(page, 0);
>>                unlock_page(page);
>>                return 0; /* don't care */
>>        }
>
>The infinite loop will cause hung-task because the mutex_lock don't release.
>
>My previous patch is try to resolve this problem by add some judgement on lseek/read/write operation on block-device.
>I think there are some place to deal with.
>So i think we can using LFS rule on this.
>The following is my new patch which adding LFS rule on block device.Because at present MAX_LFS_FILESIZE is equal 8GB -1.
>But at present the pgoff_t is the type of unsigned long.So i update the definition of MAX_LFS_FILESIZE.
>
>diff --git a/fs/block_dev.c b/fs/block_dev.c
>index aae187a..f5ecd64 100644
>--- a/fs/block_dev.c
>+++ b/fs/block_dev.c
>@@ -960,6 +960,8 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
> 
>     disk_size = (loff_t)get_capacity(disk) << 9;
>     bdev_size = i_size_read(bdev->bd_inode);
>+    if (bdev_size > bdev->bd_inode->i_sb->s_maxbytes)
>+        bdev_size = bdev->bd_inode->i_sb->s_maxbytes;
>     if (disk_size != bdev_size) {
>         char name[BDEVNAME_SIZE];
> 
>@@ -1034,6 +1036,8 @@ void bd_set_size(struct block_device *bdev, loff_t size)
> {
>     unsigned bsize = bdev_logical_block_size(bdev);
> 
>+    if (size > bdev->bd_inode->i_sb->s_maxbytes)
>+        size = bdev->bd_inode->i_sb->s_maxbytes;
>     mutex_lock(&bdev->bd_inode->i_mutex);
>     i_size_write(bdev->bd_inode, size);
>     mutex_unlock(&bdev->bd_inode->i_mutex);
>diff --git a/fs/libfs.c b/fs/libfs.c
>index 916da8c..62aab9f 100644
>--- a/fs/libfs.c
>+++ b/fs/libfs.c
>@@ -13,6 +13,7 @@
> #include <linux/exportfs.h>
> #include <linux/writeback.h>
> #include <linux/buffer_head.h> /* sync_mapping_buffers */
>+#include <linux/magic.h>
> 
> #include <asm/uaccess.h>
> 
>@@ -230,8 +231,10 @@ struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
>     s = sget(fs_type, NULL, set_anon_super, MS_NOUSER, NULL);
>     if (IS_ERR(s))
>         return ERR_CAST(s);
>-
>-    s->s_maxbytes = MAX_LFS_FILESIZE;
>+    if (magic == BDEVFS_MAGIC)
>+        s->s_maxbytes = ((MAX_LFS_FILESIZE >> 9) << 9);
>+    else
>+        s->s_maxbytes = MAX_LFS_FILESIZE;
>     s->s_blocksize = PAGE_SIZE;
>     s->s_blocksize_bits = PAGE_SHIFT;
>     s->s_magic = magic;
>diff --git a/include/linux/fs.h b/include/linux/fs.h
>index 2c28271..2888c4e 100644
>--- a/include/linux/fs.h
>+++ b/include/linux/fs.h
>@@ -869,7 +869,7 @@ static inline int file_check_writeable(struct file *filp)
> /* Page cache limit. The filesystems should put that into their s_maxbytes
>    limits, otherwise bad things can happen in VM. */
> #if BITS_PER_LONG==32
>-#define MAX_LFS_FILESIZE    (((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
>+#define MAX_LFS_FILESIZE    (((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG))-1)
> #elif BITS_PER_LONG==64
> #define MAX_LFS_FILESIZE     ((loff_t)0x7fffffffffffffffLL)
> #endif
>
>
>Thanks
>Jianpeng Ma
>
>
>
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
