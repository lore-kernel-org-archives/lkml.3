Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaCWTIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:08:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:3667 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaCWTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="478413216"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v2 1/6] Factor clean_buffers() out of __mpage_writepage()
Date: Sun, 23 Mar 2014 15:08:23 -0400
Message-Id: <9d7d6d37b52a6e13bd8162ecd5e5e4325a722e2e.1395593198.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__mpage_writepage() is over 200 lines long, has 20 local variables,
four goto labels and could desperately use simplification.  Splitting
clean_buffers() into a helper function improves matters a little,
removing 20+ lines from it.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/mpage.c | 54 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 4979ffa..4cc9c5d 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -439,6 +439,35 @@ struct mpage_data {
 	unsigned use_writepage;
 };
 
+/*
+ * We have our BIO, so we can now mark the buffers clean.  Make
+ * sure to only clean buffers which we know we'll be writing.
+ */
+static void clean_buffers(struct page *page, unsigned first_unmapped)
+{
+	unsigned buffer_counter = 0;
+	struct buffer_head *bh, *head;
+	if (!page_has_buffers(page))
+		return;
+	head = page_buffers(page);
+	bh = head;
+
+	do {
+		if (buffer_counter++ == first_unmapped)
+			break;
+		clear_buffer_dirty(bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	/*
+	 * we cannot drop the bh if the page is not uptodate or a concurrent
+	 * readpage would fail to serialize with the bh and it would read from
+	 * disk before we reach the platter.
+	 */
+	if (buffer_heads_over_limit && PageUptodate(page))
+		try_to_free_buffers(page);
+}
+
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
@@ -591,30 +620,7 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	/*
-	 * OK, we have our BIO, so we can now mark the buffers clean.  Make
-	 * sure to only clean buffers which we know we'll be writing.
-	 */
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-		unsigned buffer_counter = 0;
-
-		do {
-			if (buffer_counter++ == first_unmapped)
-				break;
-			clear_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
-
-		/*
-		 * we cannot drop the bh if the page is not uptodate
-		 * or a concurrent readpage would fail to serialize with the bh
-		 * and it would read from disk before we reach the platter.
-		 */
-		if (buffer_heads_over_limit && PageUptodate(page))
-			try_to_free_buffers(page);
-	}
+	clean_buffers(page, first_unmapped);
 
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
-- 
1.9.0

