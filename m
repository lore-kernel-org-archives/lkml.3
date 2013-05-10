Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3EJQ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:57:50 -0400
Received: from prdiron-1.llnl.gov ([128.15.143.171]:63986 "EHLO
	prdiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3EJQ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:57:49 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 12:57:49 EDT
X-Attachments: 
Message-ID: <518D24C4.703@llnl.gov>
Date: Fri, 10 May 2013 09:48:04 -0700
From: Brian Behlendorf <behlendorf1@llnl.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] brd: Fix brd_lookup_page() race
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index on the page must be set before it is inserted in the
radix tree.  Otherwise there is a small race which can occur
during lookup where the page can be found with the incorrect
index.  This will trigger the BUG_ON() in brd_lookup_page().

Reported-by: Chris Wedgwood <cw@f00f.org>
Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>

---
  drivers/block/brd.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index f1a29f8..9bf4371 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(struct 
brd_device *b, sector_t sector)

         spin_lock(&brd->brd_lock);
         idx = sector >> PAGE_SECTORS_SHIFT;
+       page->index = idx;
         if (radix_tree_insert(&brd->brd_pages, idx, page)) {
                 __free_page(page);
                 page = radix_tree_lookup(&brd->brd_pages, idx);
                 BUG_ON(!page);
                 BUG_ON(page->index != idx);
-       } else
-               page->index = idx;
+       }
         spin_unlock(&brd->brd_lock);

         radix_tree_preload_end();
-- 
1.7.4.1
