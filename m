Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaH0Ejp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:39:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:53691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731AbaH0Eef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377469245"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v10 21/21] brd: Rename XIP to DAX
Date: Tue, 26 Aug 2014 23:45:41 -0400
Message-Id: <b1ac8977533b9c83bc3e3711567997df130b25ec.1409110741.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Since this is relating to FS_XIP, not KERNEL_XIP, it should be called
DAX instead of XIP.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/Kconfig | 13 +++++++------
 drivers/block/brd.c   | 14 +++++++-------
 fs/Kconfig            |  4 ++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..1b8094d 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -393,14 +393,15 @@ config BLK_DEV_RAM_SIZE
 	  The default value is 4096 kilobytes. Only change this if you know
 	  what you are doing.
 
-config BLK_DEV_XIP
-	bool "Support XIP filesystems on RAM block device"
-	depends on BLK_DEV_RAM
+config BLK_DEV_RAM_DAX
+	bool "Support Direct Access (DAX) to RAM block devices"
+	depends on BLK_DEV_RAM && FS_DAX
 	default n
 	help
-	  Support XIP filesystems (such as ext2 with XIP support on) on
-	  top of block ram device. This will slightly enlarge the kernel, and
-	  will prevent RAM block device backing store memory from being
+	  Support filesystems using DAX to access RAM block devices.  This
+	  avoids double-buffering data in the page cache before copying it
+	  to the block device.  Answering Y will slightly enlarge the kernel,
+	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
 config CDROM_PKTCDVD
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index fee10bf..344681a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -97,13 +97,13 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	 * Must use NOIO because we don't want to recurse back into the
 	 * block or filesystem layers from page reclaim.
 	 *
-	 * Cannot support XIP and highmem, because our ->direct_access
-	 * routine for XIP must return memory that is always addressable.
-	 * If XIP was reworked to use pfns and kmap throughout, this
+	 * Cannot support DAX and highmem, because our ->direct_access
+	 * routine for DAX must return memory that is always addressable.
+	 * If DAX was reworked to use pfns and kmap throughout, this
 	 * restriction might be able to be lifted.
 	 */
 	gfp_flags = GFP_NOIO | __GFP_ZERO;
-#ifndef CONFIG_BLK_DEV_XIP
+#ifndef CONFIG_BLK_DEV_RAM_DAX
 	gfp_flags |= __GFP_HIGHMEM;
 #endif
 	page = alloc_page(gfp_flags);
@@ -369,7 +369,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 	return err;
 }
 
-#ifdef CONFIG_BLK_DEV_XIP
+#ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
 			void **kaddr, unsigned long *pfn, long size)
 {
@@ -388,6 +388,8 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	 * file happens to be mapped to the next page of physical RAM */
 	return PAGE_SIZE;
 }
+#else
+#define brd_direct_access NULL
 #endif
 
 static int brd_ioctl(struct block_device *bdev, fmode_t mode,
@@ -428,9 +430,7 @@ static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
 	.ioctl =		brd_ioctl,
-#ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
-#endif
 };
 
 /*
diff --git a/fs/Kconfig b/fs/Kconfig
index a9eb53d..117900f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -34,7 +34,7 @@ source "fs/btrfs/Kconfig"
 source "fs/nilfs2/Kconfig"
 
 config FS_DAX
-	bool "Direct Access support"
+	bool "Direct Access (DAX) support"
 	depends on MMU
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
@@ -45,7 +45,7 @@ config FS_DAX
 
 	  If you do not have a block device that is capable of using this,
 	  or if unsure, say N.  Saying Y will increase the size of the kernel
-	  by about 2kB.
+	  by about 5kB.
 
 endif # BLOCK
 
-- 
2.0.0

