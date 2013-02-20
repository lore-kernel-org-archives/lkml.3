Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3BTWlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:41:50 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40867 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3BTWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:41:47 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCHv6 6/8] mm: allow for outstanding swap writeback accounting
Date: Wed, 20 Feb 2013 16:04:46 -0600
Message-Id: <1361397888-14863-7-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022022-7606-0000-0000-000008A07BE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent flooding the swap device with writebacks, frontswap
backends need to count and limit the number of outstanding
writebacks.  The incrementing of the counter can be done before
the call to __swap_writepage().  However, the caller must receive
a notification when the writeback completes in order to decrement
the counter.

To achieve this functionality, this patch modifies
__swap_writepage() to take the bio completion callback function
as an argument.

end_swap_bio_write(), the normal bio completion function, is also
made non-static so that code doing the accounting can call it
after the accounting is done.

Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 include/linux/swap.h |  4 +++-
 mm/page_io.c         | 12 +++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index fc8920d..98981f0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -321,7 +321,9 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern int __swap_writepage(struct page *page, struct writeback_control *wbc);
+extern void end_swap_bio_write(struct bio *bio, int err);
+extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
+	void (*end_write_func)(struct bio *, int));
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 1cb382d..56276fe 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -42,7 +42,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 	return bio;
 }
 
-static void end_swap_bio_write(struct bio *bio, int err)
+void end_swap_bio_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -179,7 +179,8 @@ bad_bmap:
 	goto out;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc);
+int __swap_writepage(struct page *page, struct writeback_control *wbc,
+	void (*end_write_func)(struct bio *, int));
 
 /*
  * We may have stale swap cache pages in memory: notice
@@ -199,12 +200,13 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		end_page_writeback(page);
 		goto out;
 	}
-	ret = __swap_writepage(page, wbc);
+	ret = __swap_writepage(page, wbc, end_swap_bio_write);
 out:
 	return ret;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc)
+int __swap_writepage(struct page *page, struct writeback_control *wbc,
+	void (*end_write_func)(struct bio *, int))
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
@@ -236,7 +238,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc)
 		return ret;
 	}
 
-	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
+	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
-- 
1.8.1.1

