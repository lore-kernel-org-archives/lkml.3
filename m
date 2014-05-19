Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaESI5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaESI5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:57:11 -0400
Date: Mon, 19 May 2014 09:57:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] mm: Avoid unnecessary atomic operations during
 end_page_writeback
Message-ID: <20140519085704.GI23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a page is marked for immediate reclaim then it is moved to the tail of
the LRU list. This occurs when the system is under enough memory pressure
for pages under writeback to reach the end of the LRU but we test for
this using atomic operations on every writeback. This patch uses an
optimistic non-atomic test first. It'll miss some pages in rare cases but
the consequences are not severe enough to warrant such a penalty.

While the function does not dominate profiles during a simple dd test the
cost of it is reduced.

73048     0.7428  vmlinux-3.15.0-rc5-mmotm-20140513 end_page_writeback
23740     0.2409  vmlinux-3.15.0-rc5-lessatomic     end_page_writeback

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/filemap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index bec4b9b..dafb06f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -753,8 +753,17 @@ EXPORT_SYMBOL(unlock_page);
  */
 void end_page_writeback(struct page *page)
 {
-	if (TestClearPageReclaim(page))
+	/*
+	 * TestClearPageReclaim could be used here but it is an atomic
+	 * operation and overkill in this particular case. Failing to
+	 * shuffle a page marked for immediate reclaim is too mild to
+	 * justify taking an atomic operation penalty at the end of
+	 * ever page writeback.
+	 */
+	if (PageReclaim(page)) {
+		ClearPageReclaim(page);
 		rotate_reclaimable_page(page);
+	}
 
 	if (!test_clear_page_writeback(page))
 		BUG();
