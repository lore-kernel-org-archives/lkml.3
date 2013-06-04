Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3FDRCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:02:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3FDRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:02:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Behlendorf <behlendorf1@llnl.gov>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 54/75] drivers/block/brd.c: fix brd_lookup_page() race
Date: Tue,  4 Jun 2013 09:55:38 -0700
Message-Id: <1370364959-9475-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Behlendorf <behlendorf1@llnl.gov>

commit dfd20b2b174d3a9b258ea3b7a35ead33576587b1 upstream.

The index on the page must be set before it is inserted in the radix
tree.  Otherwise there is a small race which can occur during lookup
where the page can be found with the incorrect index.  This will trigger
the BUG_ON() in brd_lookup_page().

Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>
Reported-by: Chris Wedgwood <cw@f00f.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/brd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..4e8213a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
+	page->index = idx;
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
 		BUG_ON(!page);
 		BUG_ON(page->index != idx);
-	} else
-		page->index = idx;
+	}
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
-- 
1.8.1.2

