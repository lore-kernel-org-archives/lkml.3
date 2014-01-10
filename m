Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaAJCkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:40:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:56944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAJCkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="462953186"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 4/6] brd: Add support for rw_page
Date: Thu,  9 Jan 2014 21:39:49 -0500
Message-Id: <1389321591-25455-4-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748522.git.matthew.r.wilcox@intel.com>
References: <cover.1387748522.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/brd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index d91f1a5..320d041 100644
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
1.8.5.2

