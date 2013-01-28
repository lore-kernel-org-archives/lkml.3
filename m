Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3A1V4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:56:35 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50342 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3A1V4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:56:31 -0500
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
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCHv3 3/6] mm: break up swap_writepage() for frontswap backends
Date: Mon, 28 Jan 2013 15:49:24 -0600
Message-Id: <1359409767-30092-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012821-7408-0000-0000-00000C4D045F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swap_writepage() is currently where frontswap hooks into the swap
write path to capture pages with the frontswap_store() function.
However, if a frontswap backend wants to "resume" the writeback of
a page to the swap device, it can't call swap_writepage() as
the page will simply reenter the backend.

This patch separates swap_writepage() into a top and bottom half, the
bottom half named __swap_writepage() to allow a frontswap backend,
like zswap, to resume writeback beyond the frontswap_store() hook.

__add_to_swap_cache() is also made non-static so that the page for
which writeback is to be resumed can be added to the swap cache.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 include/linux/swap.h |    2 ++
 mm/page_io.c         |   16 +++++++++++++---
 mm/swap_state.c      |    2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 68df9c1..fc8920d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -321,6 +321,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
+extern int __swap_writepage(struct page *page, struct writeback_control *wbc);
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
@@ -335,6 +336,7 @@ extern struct address_space swapper_space;
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
+extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..1cb382d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -179,15 +179,15 @@ bad_bmap:
 	goto out;
 }
 
+int __swap_writepage(struct page *page, struct writeback_control *wbc);
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct bio *bio;
-	int ret = 0, rw = WRITE;
-	struct swap_info_struct *sis = page_swap_info(page);
+	int ret = 0;
 
 	if (try_to_free_swap(page)) {
 		unlock_page(page);
@@ -199,6 +199,16 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		end_page_writeback(page);
 		goto out;
 	}
+	ret = __swap_writepage(page, wbc);
+out:
+	return ret;
+}
+
+int __swap_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct bio *bio;
+	int ret = 0, rw = WRITE;
+	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
 		struct kiocb kiocb;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0cb36fb..7eded9c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -67,7 +67,7 @@ void show_swap_cache_info(void)
  * __add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
+int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
 	int error;
 
-- 
1.7.9.5

