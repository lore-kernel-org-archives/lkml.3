Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3FEV6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:58:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3FEVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Behlendorf <behlendorf1@llnl.gov>, Chris Wedgwood <cw@f00f.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 053/127] drivers/block/brd.c: fix brd_lookup_page() race
Date: Wed,  5 Jun 2013 14:33:40 -0700
Message-Id: <20130605213224.049232950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


