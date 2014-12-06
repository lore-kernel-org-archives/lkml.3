Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaLFPN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:13:57 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47750 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752273AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 44/66] aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer
Date: Sat,  6 Dec 2014 16:07:36 +0100
Message-Id: <cab86d8c6534900243994bb0558e66a41fcbc39d.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 835f252c6debd204fcd607c79975089b1ecd3472 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=86831

Markus reported that when shutting down mysqld (with AIO support,
on a ext3 formatted Harddrive) leads to a negative number of dirty pages
(underrun to the counter). The negative number results in a drastic reduction
of the write performance because the page cache is not used, because the kernel
thinks it is still 2 ^ 32 dirty pages open.

Add a warn trace in __dec_zone_state will catch this easily:

static inline void __dec_zone_state(struct zone *zone, enum
	zone_stat_item item)
{
     atomic_long_dec(&zone->vm_stat[item]);
+    WARN_ON_ONCE(item == NR_FILE_DIRTY &&
	atomic_long_read(&zone->vm_stat[item]) < 0);
     atomic_long_dec(&vm_stat[item]);
}

[   21.341632] ------------[ cut here ]------------
[   21.346294] WARNING: CPU: 0 PID: 309 at include/linux/vmstat.h:242
cancel_dirty_page+0x164/0x224()
[   21.355296] Modules linked in: wutbox_cp sata_mv
[   21.359968] CPU: 0 PID: 309 Comm: kworker/0:1 Not tainted 3.14.21-WuT #80
[   21.366793] Workqueue: events free_ioctx
[   21.370760] [<c0016a64>] (unwind_backtrace) from [<c0012f88>]
(show_stack+0x20/0x24)
[   21.378562] [<c0012f88>] (show_stack) from [<c03f8ccc>]
(dump_stack+0x24/0x28)
[   21.385840] [<c03f8ccc>] (dump_stack) from [<c0023ae4>]
(warn_slowpath_common+0x84/0x9c)
[   21.393976] [<c0023ae4>] (warn_slowpath_common) from [<c0023bb8>]
(warn_slowpath_null+0x2c/0x34)
[   21.402800] [<c0023bb8>] (warn_slowpath_null) from [<c00c0688>]
(cancel_dirty_page+0x164/0x224)
[   21.411524] [<c00c0688>] (cancel_dirty_page) from [<c00c080c>]
(truncate_inode_page+0x8c/0x158)
[   21.420272] [<c00c080c>] (truncate_inode_page) from [<c00c0a94>]
(truncate_inode_pages_range+0x11c/0x53c)
[   21.429890] [<c00c0a94>] (truncate_inode_pages_range) from
[<c00c0f6c>] (truncate_pagecache+0x88/0xac)
[   21.439252] [<c00c0f6c>] (truncate_pagecache) from [<c00c0fec>]
(truncate_setsize+0x5c/0x74)
[   21.447731] [<c00c0fec>] (truncate_setsize) from [<c013b3a8>]
(put_aio_ring_file.isra.14+0x34/0x90)
[   21.456826] [<c013b3a8>] (put_aio_ring_file.isra.14) from
[<c013b424>] (aio_free_ring+0x20/0xcc)
[   21.465660] [<c013b424>] (aio_free_ring) from [<c013b4f4>]
(free_ioctx+0x24/0x44)
[   21.473190] [<c013b4f4>] (free_ioctx) from [<c003d8d8>]
(process_one_work+0x134/0x47c)
[   21.481132] [<c003d8d8>] (process_one_work) from [<c003e988>]
(worker_thread+0x130/0x414)
[   21.489350] [<c003e988>] (worker_thread) from [<c00448ac>]
(kthread+0xd4/0xec)
[   21.496621] [<c00448ac>] (kthread) from [<c000ec18>]
(ret_from_fork+0x14/0x20)
[   21.503884] ---[ end trace 79c4bf42c038c9a1 ]---

The cause is that we set the aio ring file pages as *DIRTY* via SetPageDirty
(bypasses the VFS dirty pages increment) when init, and aio fs uses
*default_backing_dev_info* as the backing dev, which does not disable
the dirty pages accounting capability.
So truncating aio ring file will contribute to accounting dirty pages (VFS
dirty pages decrement), then error occurs.

The original goal is keeping these pages in memory (can not be reclaimed
or swapped) in life-time via marking it dirty. But thinking more, we have
already pinned pages via elevating the page's refcount, which can already
achieve the goal, so the SetPageDirty seems unnecessary.

In order to fix the issue, using the __set_page_dirty_no_writeback instead
of the nop .set_page_dirty, and dropped the SetPageDirty (don't manually
set the dirty flags, don't disable set_page_dirty(), rely on default behaviour).

With the above change, the dirty pages accounting can work well. But as we
known, aio fs is an anonymous one, which should never cause any real write-back,
we can ignore the dirty pages (write back) accounting by disabling the dirty
pages (write back) accounting capability. So we introduce an aio private
backing dev info (disabled the ACCT_DIRTY/WRITEBACK/ACCT_WB capabilities) to
replace the default one.

Reported-by: Markus Königshaus <m.koenigshaus@wut.de>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 66bd7e4447ad..307d7708dc00 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -164,6 +164,15 @@ static struct vfsmount *aio_mnt;
 static const struct file_operations aio_ring_fops;
 static const struct address_space_operations aio_ctx_aops;
 
+/* Backing dev info for aio fs.
+ * -no dirty page accounting or writeback happens
+ */
+static struct backing_dev_info aio_fs_backing_dev_info = {
+	.name           = "aiofs",
+	.state          = 0,
+	.capabilities   = BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_MAP_COPY,
+};
+
 static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 {
 	struct qstr this = QSTR_INIT("[aio]", 5);
@@ -175,6 +184,7 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 
 	inode->i_mapping->a_ops = &aio_ctx_aops;
 	inode->i_mapping->private_data = ctx;
+	inode->i_mapping->backing_dev_info = &aio_fs_backing_dev_info;
 	inode->i_size = PAGE_SIZE * nr_pages;
 
 	path.dentry = d_alloc_pseudo(aio_mnt->mnt_sb, &this);
@@ -220,6 +230,9 @@ static int __init aio_setup(void)
 	if (IS_ERR(aio_mnt))
 		panic("Failed to create aio fs mount.");
 
+	if (bdi_init(&aio_fs_backing_dev_info))
+		panic("Failed to init aio fs backing dev info.");
+
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
@@ -281,11 +294,6 @@ static const struct file_operations aio_ring_fops = {
 	.mmap = aio_ring_mmap,
 };
 
-static int aio_set_page_dirty(struct page *page)
-{
-	return 0;
-}
-
 #if IS_ENABLED(CONFIG_MIGRATION)
 static int aio_migratepage(struct address_space *mapping, struct page *new,
 			struct page *old, enum migrate_mode mode)
@@ -357,7 +365,7 @@ out:
 #endif
 
 static const struct address_space_operations aio_ctx_aops = {
-	.set_page_dirty = aio_set_page_dirty,
+	.set_page_dirty = __set_page_dirty_no_writeback,
 #if IS_ENABLED(CONFIG_MIGRATION)
 	.migratepage	= aio_migratepage,
 #endif
@@ -412,7 +420,6 @@ static int aio_setup_ring(struct kioctx *ctx)
 		pr_debug("pid(%d) page[%d]->count=%d\n",
 			 current->pid, i, page_count(page));
 		SetPageUptodate(page);
-		SetPageDirty(page);
 		unlock_page(page);
 
 		ctx->ring_pages[i] = page;
-- 
2.1.3

