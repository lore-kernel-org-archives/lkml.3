Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaHMQ6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:58:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56221 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHMQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:58:18 -0400
Message-ID: <53EB9928.1030601@adfin.com>
Date: Wed, 13 Aug 2014 12:58:16 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 1/3] FS-Cache: Timeout for releasepage()
References: <cover.1407948737.git.milosz@adfin.com>
In-Reply-To: <cover.1407948737.git.milosz@adfin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is meant to avoid a recusive hang caused by underlying filesystem trying
to grab a free page and causing a write-out.

INFO: task kworker/u30:7:28375 blocked for more than 120 seconds.
      Not tainted 3.15.0-virtual #74
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u30:7   D 0000000000000000     0 28375      2 0x00000000
Workqueue: fscache_operation fscache_op_work_func [fscache]
 ffff88000b147148 0000000000000046 0000000000000000 ffff88000b1471c8
 ffff8807aa031820 0000000000014040 ffff88000b147fd8 0000000000014040
 ffff880f0c50c860 ffff8807aa031820 ffff88000b147158 ffff88007be59cd0
Call Trace:
 [<ffffffff815930e9>] schedule+0x29/0x70
 [<ffffffffa018bed5>] __fscache_wait_on_page_write+0x55/0x90 [fscache]
 [<ffffffff810a4350>] ? __wake_up_sync+0x20/0x20
 [<ffffffffa018c135>] __fscache_maybe_release_page+0x65/0x1e0 [fscache]
 [<ffffffffa02ad813>] ceph_releasepage+0x83/0x100 [ceph]
 [<ffffffff811635b0>] ? anon_vma_fork+0x130/0x130
 [<ffffffff8112cdd2>] try_to_release_page+0x32/0x50
 [<ffffffff81140096>] shrink_page_list+0x7e6/0x9d0
 [<ffffffff8113f278>] ? isolate_lru_pages.isra.73+0x78/0x1e0
 [<ffffffff81140932>] shrink_inactive_list+0x252/0x4c0
 [<ffffffff811412b1>] shrink_lruvec+0x3e1/0x670
 [<ffffffff8114157f>] shrink_zone+0x3f/0x110
 [<ffffffff81141b06>] do_try_to_free_pages+0x1d6/0x450
 [<ffffffff8114a939>] ? zone_statistics+0x99/0xc0
 [<ffffffff81141e44>] try_to_free_pages+0xc4/0x180
 [<ffffffff81136982>] __alloc_pages_nodemask+0x6b2/0xa60
 [<ffffffff811c1d4e>] ? __find_get_block+0xbe/0x250
 [<ffffffff810a405e>] ? wake_up_bit+0x2e/0x40
 [<ffffffff811740c3>] alloc_pages_current+0xb3/0x180
 [<ffffffff8112cf07>] __page_cache_alloc+0xb7/0xd0
 [<ffffffff8112da6c>] grab_cache_page_write_begin+0x7c/0xe0
 [<ffffffff81214072>] ? ext4_mark_inode_dirty+0x82/0x220
 [<ffffffff81214a89>] ext4_da_write_begin+0x89/0x2d0
 [<ffffffff8112c6ee>] generic_perform_write+0xbe/0x1d0
 [<ffffffff811a96b1>] ? update_time+0x81/0xc0
 [<ffffffff811ad4c2>] ? mnt_clone_write+0x12/0x30
 [<ffffffff8112e80e>] __generic_file_aio_write+0x1ce/0x3f0
 [<ffffffff8112ea8e>] generic_file_aio_write+0x5e/0xe0
 [<ffffffff8120b94f>] ext4_file_write+0x9f/0x410
 [<ffffffff8120af56>] ? ext4_file_open+0x66/0x180
 [<ffffffff8118f0da>] do_sync_write+0x5a/0x90
 [<ffffffffa025c6c9>] cachefiles_write_page+0x149/0x430 [cachefiles]
 [<ffffffff812cf439>] ? radix_tree_gang_lookup_tag+0x89/0xd0
 [<ffffffffa018c512>] fscache_write_op+0x222/0x3b0 [fscache]
 [<ffffffffa018b35a>] fscache_op_work_func+0x3a/0x100 [fscache]
 [<ffffffff8107bfe9>] process_one_work+0x179/0x4a0
 [<ffffffff8107d47b>] worker_thread+0x11b/0x370
 [<ffffffff8107d360>] ? manage_workers.isra.21+0x2e0/0x2e0
 [<ffffffff81083d69>] kthread+0xc9/0xe0
 [<ffffffff81010000>] ? ftrace_raw_event_xen_mmu_release_ptpage+0x70/0x90
 [<ffffffff81083ca0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8159eefc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81083ca0>] ? flush_kthread_worker+0xb0/0xb0

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/fscache/page.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 7f5c658..4911f2cf 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -44,6 +44,19 @@ void __fscache_wait_on_page_write(struct fscache_cookie *cookie, struct page *pa
 EXPORT_SYMBOL(__fscache_wait_on_page_write);
 
 /*
+ * wait for a page to finish being written to the cache. Put a timeout here
+ * since we might be called recusively via parent fs.
+ */
+static
+bool relase_page_wait_timeout(struct fscache_cookie *cookie, struct page *page)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&cookie->flags, 0);
+
+	return wait_event_timeout(*wq, !__fscache_check_page_write(cookie, page),
+				  HZ);
+}
+
+/*
  * decide whether a page can be released, possibly by cancelling a store to it
  * - we're allowed to sleep if __GFP_WAIT is flagged
  */
@@ -115,7 +128,11 @@ page_busy:
 	}
 
 	fscache_stat(&fscache_n_store_vmscan_wait);
-	__fscache_wait_on_page_write(cookie, page);
+	if (!relase_page_wait_timeout(cookie, page)) {
+		_debug("fscache writeout timeout page: %p{%lx}",
+			page, page->index);
+	}
+
 	gfp &= ~__GFP_WAIT;
 	goto try_again;
 }
-- 
1.7.9.5


