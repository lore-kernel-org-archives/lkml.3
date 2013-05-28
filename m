Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3E1Dzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758940Ab3E1DyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Brian Behlendorf" <behlendorf1@llnl.gov>,
        "Chris Wedgwood" <cw@f00f.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.153895933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [65/94] drivers/block/brd.c: fix brd_lookup_page() race
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/brd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(stru
 
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

