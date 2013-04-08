Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab3DHGBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:01:08 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51436 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761102Ab3DHGBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:01:06 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-d0-51625d203174
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH] mm: remove compressed copy from zram in-memory
Date: Mon,  8 Apr 2013 15:01:02 +0900
Message-Id: <1365400862-9041-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap subsystem does lazy swap slot free with expecting the page
would be swapped out again so we can avoid unnecessary write.

But the problem in in-memory swap(ex, zram) is that it consumes
memory space until vm_swap_full(ie, used half of all of swap device)
condition meet. It could be bad if we use multiple swap device,
small in-memory swap and big storage swap or in-memory swap alone.

This patch makes swap subsystem free swap slot as soon as swap-read
is completed and make the swapcache page dirty so the page should
be written out the swap device to reclaim it.
It means we never lose it.

I tested this patch with kernel compile workload.

1. before

compile time : 9882.42
zram max wasted space by fragmentation: 13471881 byte
memory space consumed by zram: 174227456 byte
the number of slot free notify: 206684

2. after

compile time : 9653.90
zram max wasted space by fragmentation: 11805932 byte
memory space consumed by zram: 154001408 byte
the number of slot free notify: 426972

Cc: Hugh Dickins <hughd@google.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
Fragment ratio is almost same but memory consumption and compile time
is better. I am working to add defragment function of zsmalloc.

 mm/page_io.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..644900a 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
+#include <linux/blkdev.h>
 #include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
@@ -81,8 +82,30 @@ void end_swap_bio_read(struct bio *bio, int err)
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
 	} else {
+		/*
+		 * There is no reason to keep both uncompressed data and
+		 * compressed data in memory.
+		 */
+		struct swap_info_struct *sis;
+
 		SetPageUptodate(page);
+		sis = page_swap_info(page);
+		if (sis->flags & SWP_BLKDEV) {
+			struct gendisk *disk = sis->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify) {
+				swp_entry_t entry;
+				unsigned long offset;
+
+				entry.val = page_private(page);
+				offset = swp_offset(entry);
+
+				SetPageDirty(page);
+				disk->fops->swap_slot_free_notify(sis->bdev,
+						offset);
+			}
+		}
 	}
+
 	unlock_page(page);
 	bio_put(bio);
 }
-- 
1.8.2

