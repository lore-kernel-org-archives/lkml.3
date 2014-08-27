Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124AbaH0VND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:13:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:43979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935855AbaH0VMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377843165"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@ml01.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/4] pmem: Add support for rw_page()
Date: Wed, 27 Aug 2014 15:12:01 -0600
Message-Id: <1409173922-7484-4-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on commit a72132c31d58 ("brd: add support for rw_page()")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/block/pmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 60bbe0d..0be3669 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -183,8 +183,19 @@ out:
 	bio_endio(bio, err);
 }
 
+static int pmem_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+
+	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, 0);
+	return 0;
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
+	.rw_page =		pmem_rw_page,
 	.getgeo =		pmem_getgeo,
 };
 
-- 
1.9.3

