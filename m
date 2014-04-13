Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaDMXA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:00:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:28935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaDMXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:00:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="512366915"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v3 7/7] brd: Return -ENOSPC rather than -ENOMEM on page allocation failure
Date: Sun, 13 Apr 2014 18:59:56 -0400
Message-Id: <f79dcaa7a00de26924c563f91e22418896904167.1397429628.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

brd is effectively a thinly provisioned device.  Thinly provisioned
devices return -ENOSPC when they can't write a new block.  -ENOMEM is
an implementation detail that callers shouldn't know.

Acked-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/brd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 807d3d5..c7d138e 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -200,11 +200,11 @@ static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	if (!brd_insert_page(brd, sector))
-		return -ENOMEM;
+		return -ENOSPC;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
 		if (!brd_insert_page(brd, sector))
-			return -ENOMEM;
+			return -ENOSPC;
 	}
 	return 0;
 }
@@ -384,7 +384,7 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
 		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
-		return -ENOMEM;
+		return -ENOSPC;
 	*kaddr = page_address(page);
 	*pfn = page_to_pfn(page);
 
-- 
1.9.1

