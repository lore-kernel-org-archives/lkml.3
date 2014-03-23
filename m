Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaCWTJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:09:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:3672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaCWTIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="478413229"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v2 6/6] brd: Add support for rw_page
Date: Sun, 23 Mar 2014 15:08:28 -0400
Message-Id: <67076223fca0b9ad393699a1fcfe53a95401d492.1395593198.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/brd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index e73b85c..807d3d5 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -360,6 +360,15 @@ out:
 	bio_endio(bio, err);
 }
 
+static int brd_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct brd_device *brd = bdev->bd_disk->private_data;
+	int err = brd_do_bvec(brd, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, err);
+	return err;
+}
+
 #ifdef CONFIG_BLK_DEV_XIP
 static int brd_direct_access(struct block_device *bdev, sector_t sector,
 			void **kaddr, unsigned long *pfn)
@@ -419,6 +428,7 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
+	.rw_page =		brd_rw_page,
 	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
-- 
1.9.0

