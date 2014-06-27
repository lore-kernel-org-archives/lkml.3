Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaF0Hpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:45:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39388 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaF0Hpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:45:34 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53AD2119.2050901@lge.com>
Date: Fri, 27 Jun 2014 16:45:29 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Phillip Lougher <phillip@squashfs.org.uk>,
        squashfs-devel@lists.sourceforge.net,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fabian Frederick <fabf@skynet.be>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        "'Chanho Min'" <chanho.min@lge.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [RFC] squashfs: A possible memory leak in squashfs
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been trying to apply CMA feature to my platform, based on ver. 3.10.
And I am suffering failures of allocation in CMA area.
I made a patch like below (I copied it after kernel log) and found that a buffer-head is not released.
As you know the CMA try to migrate movable pages. If any buffer-head related to a page is not released CMA cannot migrate the page.

I am writing about my problem. Please reply me if you need any information.

Howto generate problem:
1. The chrome is stored in squashfs partition. The size of CMA area is 256MB.
2. start chrome
3. connect any site
4. About 100MB of CMA area is used. The remain of CMA area is free.
5. Try to allocate all memory (256MB) of CMA with dma_alloc_coherent.
6. Some buffer-heads are busy so that allocation is failed.
7. The busy buffer-head was released by squash_read_data and b_count of the buffer-head became 1.
8. The b_count of the busy buffer-head will never become 0. Even-if I turn off platform, it is not released.
9. Is it possible that a buffer-head is not released forever? And why?

Followings are kernel log messages.
At first buffer-head which is located at 0x9499a500 is released by squashfs_read_data.
I think the buffer-head contains a data of squashfs partition.
The referenct count of buffer-head become 1 becauseof the release.
I think the buffer-head must be released again but it is not.
Even-if I turn off the platform I cannot see the message that 0x9499a500 is released.


[  243.909446] BUFFER_INFO: (put_bh) bh 9499a500 count 2 page 0x28e5d   ============> log from free_buffer_head
[  243.909455] CPU: 1 PID: 4444 Comm: chrome Tainted: P           O 3.10.19-32 #67
[  243.909486] [<80013ef0>] (unwind_backtrace+0x0/0xf8) from [<80011d00>] (show_stack+0x10/0x14)
[  243.909510] [<80011d00>] (show_stack+0x10/0x14) from [<801c994c>] (lzo_uncompress+0x110/0x270)
[  243.909524] [<801c994c>] (lzo_uncompress+0x110/0x270) from [<801c618c>] (squashfs_read_data+0x254/0x714)
[  243.909535] [<801c618c>] (squashfs_read_data+0x254/0x714) from [<801c680c>] (squashfs_cache_get+0x1c0/0x3c8)
[  243.909545] [<801c680c>] (squashfs_cache_get+0x1c0/0x3c8) from [<801c7df8>] (squashfs_readpage+0x794/0x8a8)
[  243.909566] [<801c7df8>] (squashfs_readpage+0x794/0x8a8) from [<800b8914>] (__do_page_cache_readahead+0x254/0x264)
[  243.909579] [<800b8914>] (__do_page_cache_readahead+0x254/0x264) from [<800b8c04>] (ra_submit+0x28/0x30)
[  243.909589] [<800b8c04>] (ra_submit+0x28/0x30) from [<800afea8>] (filemap_fault+0x368/0x460)
[  243.909604] [<800afea8>] (filemap_fault+0x368/0x460) from [<800cd864>] (__do_fault+0x6c/0x4dc)
[  243.909615] [<800cd864>] (__do_fault+0x6c/0x4dc) from [<800d0a1c>] (handle_pte_fault+0xb4/0x77c)
[  243.909625] [<800d0a1c>] (handle_pte_fault+0xb4/0x77c) from [<800d1190>] (handle_mm_fault+0xac/0xe8)
[  243.909637] [<800d1190>] (handle_mm_fault+0xac/0xe8) from [<8001889c>] (do_page_fault+0x20c/0x360)
[  243.909648] [<8001889c>] (do_page_fault+0x20c/0x360) from [<80008560>] (do_PrefetchAbort+0x34/0x9c)
[  243.909661] [<80008560>] (do_PrefetchAbort+0x34/0x9c) from [<8000e314>] (ret_from_exception+0x0/0x10)
[  243.909665] Exception stack(0xb1d7dfb0 to 0xb1d7dff8)
[  243.909671] dfa0:                                     6ca7b1e8 00000000 6c393234 7ef8a8f0
[  243.909678] dfc0: 00000001 0000c2a4 0000cf54 6c393220 6c393238 00000003 ffffffff 00000001
[  243.909683] dfe0: 00000000 7ef8a688 752711a4 74bd1fe0 28000110 ffffffff
[  243.909737] busy bh=9499a500, 10029 count=1
[  243.909739] debug=9499a500
[  243.909741] debug=9499a4c0
[  243.909742] debug=9499a480
[  243.909750] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909777] busy bh=9499a500, 10029 count=1                                            ================> 9499a500 buffer-head is not release forever
[  243.909778] debug=9499a500
[  243.909780] debug=9499a4c0
[  243.909781] debug=9499a480
[  243.909787] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909809] busy bh=9499a500, 10029 count=1
[  243.909810] debug=9499a500
[  243.909812] debug=9499a4c0
[  243.909813] debug=9499a480
[  243.909818] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909840] busy bh=9499a500, 10029 count=1
[  243.909841] debug=9499a500
[  243.909843] debug=9499a4c0
[  243.909844] debug=9499a480
[  243.909850] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909872] busy bh=9499a500, 10029 count=1
[  243.909874] debug=9499a500
[  243.909875] debug=9499a4c0
[  243.909876] debug=9499a480
[  243.909882] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909903] busy bh=9499a500, 10029 count=1
[  243.909904] debug=9499a500
[  243.909906] debug=9499a4c0
[  243.909907] debug=9499a480
[  243.909912] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024
[  243.909933] busy bh=9499a500, 10029 count=1
[  243.909935] debug=9499a500
[  243.909936] debug=9499a4c0
[  243.909937] debug=9499a480
[  243.909943] sb-type=squashfs sb-root=/ disk=mmcblk0 first_minor=0 minors=64 partno=0 blocksize=1024


This is my patch to check buffer-head is released correctly.
I add a BH_Debug flag at bh_state_bits. It will be set if the buffer-head is busy (count is 1).
When the busy buffer-head is released it prints log message about released buffer-head.

----------------------------------------- 8< --------------------------------------
diff --git a/fs/buffer.c b/fs/buffer.c
index 7e0240f..4238392 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3134,18 +3134,90 @@ static inline int buffer_busy(struct buffer_head *bh)
                (bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
 }

+static void __evict_bh_lru(void *arg)
+{
+       struct bh_lru *b = &get_cpu_var(bh_lrus);
+       struct buffer_head *bh = arg;
+       int i;
+
+       for (i = 0; i < BH_LRU_SIZE; i++) {
+               if (b->bhs[i] == bh) {
+                       brelse(b->bhs[i]);
+                       printk("released lru-bh:%p->count=%d\n", bh, atomic_read(&bh->b_count));
+                       b->bhs[i] = NULL;
+                       goto out;
+               }
+       }
+out:
+       put_cpu_var(bh_lrus);
+}
+
+static bool bh_exists_in_lru(int cpu, void *arg)
+{
+       struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
+       struct buffer_head *bh = arg;
+       int i;
+
+       for (i = 0; i < BH_LRU_SIZE; i++) {
+               if (b->bhs[i] == bh) {
+                       //printk("exists=%p\n", bh);
+                       return 1;
+               }
+       }
+
+       return 0;
+
+}
+
+void evict_bh_lrus(struct buffer_head *bh)
+{
+       on_each_cpu_cond(bh_exists_in_lru, __evict_bh_lru, bh, 1, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(evict_bh_lrus);
+
 static int
 drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
 {
        struct buffer_head *head = page_buffers(page);
        struct buffer_head *bh;
+       struct file_system_type *fs_type;
+       int wait = 1;

        bh = head;
        do {
+               evict_bh_lrus(bh); //https://lkml.org/lkml/2012/8/31/313
                if (buffer_write_io_error(bh) && page->mapping)
                        set_bit(AS_EIO, &page->mapping->flags);
-               if (buffer_busy(bh))
+               if (buffer_busy(bh)) {
+                       printk(KERN_CRIT "busy bh=%p, %x count=%d\n", bh, bh->b_state,
+                              atomic_read(&bh->b_count));
+
+                       for (bh = head->b_this_page; bh != head; bh = bh->b_this_page) {
+                               printk("debug=%p\n", bh);
+                               set_buffer_debug(bh);
+                       }
+
+
+                       if (bh->b_bdev != NULL && bh->b_bdev->bd_inode != NULL) {
+                               /* struct dentry *d; */
+                               /* struct hlist_head i = bh->b_bdev->bd_inode->i_dentry; */
+                               printk(KERN_CRIT "inode=%d\n", bh->b_bdev->bd_inode->i_ino);
+
+                               if (bh->b_bdev->bd_super != NULL) {
+                                       printk(KERN_CRIT "sb-type=%s sb-root=%s disk=%s first_minor
+                                              bh->b_bdev->bd_super->s_type->name,
+                                              bh->b_bdev->bd_super->s_root->d_iname,
+                                              bh->b_bdev->bd_disk->disk_name,
+                                              bh->b_bdev->bd_disk->first_minor,
+                                              bh->b_bdev->bd_disk->minors,
+                                              bh->b_bdev->bd_disk->part0.partno,
+                                              bh->b_bdev->bd_super->s_blocksize);
+                               }
+
+                       }
+
                        goto failed;
+               }
                bh = bh->b_this_page;
        } while (bh != head);

@@ -3289,6 +3361,12 @@ EXPORT_SYMBOL(alloc_buffer_head);
 void free_buffer_head(struct buffer_head *bh)
 {
        BUG_ON(!list_empty(&bh->b_assoc_buffers));
+
+       if (buffer_debug(bh)) {
+               print_buffer_info(bh, __func__);
+       }
+
+
        kmem_cache_free(bh_cachep, bh);
        preempt_disable();
        __this_cpu_dec(bh_accounting.nr);


diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 9e52b0626..a876439 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -36,6 +36,7 @@ enum bh_state_bits {
        BH_Quiet,       /* Buffer Error Prinks to be quiet */
        BH_Meta,        /* Buffer contains metadata */
        BH_Prio,        /* Buffer should be submitted with REQ_PRIO */
+       BH_Debug,

        BH_PrivateStart,/* not a state bit, but the first bit available
                         * for private allocation by other entities
@@ -128,6 +129,7 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
+BUFFER_FNS(Debug, debug)

 #define bh_offset(bh)          ((unsigned long)(bh)->b_data & ~PAGE_MASK)

@@ -265,15 +267,38 @@ static inline void attach_page_buffers(struct page *page,
        set_page_private(page, (unsigned long)head);
 }

+
+static void print_buffer_info(struct buffer_head *bh, const char *func)
+{
+       int count;
+
+       count = atomic_read(&bh->b_count);
+       printk(KERN_ALERT "\n\nBUFFER_INFO: (%s) bh %p count %d page 0x%lx\n",
+               func, bh, count,
+              (bh->b_page ? page_to_pfn(bh->b_page) : 0));
+       dump_stack();
+
+}
+
 static inline void get_bh(struct buffer_head *bh)
 {
+       if (buffer_debug(bh))
+               print_buffer_info(bh, __func__);
+
         atomic_inc(&bh->b_count);
 }

 static inline void put_bh(struct buffer_head *bh)
 {
+       if (buffer_debug(bh))
+               print_buffer_info(bh, __func__);
+
         smp_mb__before_atomic_dec();
         atomic_dec(&bh->b_count);
+
+       if (buffer_debug(bh) && !atomic_read(&bh->b_count)) {
+               clear_buffer_debug(bh);
+       }
 }

 static inline void brelse(struct buffer_head *bh)
