Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaH1Sh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaH1ShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:16 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 85/97] mm: avoid unnecessary atomic operations during end_page_writeback()
Date: Thu, 28 Aug 2014 19:35:33 +0100
Message-Id: <1409250945-30874-86-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 888cf2db475a256fb0cda042140f73d7881f81fe upstream.

If a page is marked for immediate reclaim then it is moved to the tail of
the LRU list.  This occurs when the system is under enough memory pressure
for pages under writeback to reach the end of the LRU but we test for this
using atomic operations on every writeback.  This patch uses an optimistic
non-atomic test first.  It'll miss some pages in rare cases but the
consequences are not severe enough to warrant such a penalty.

While the function does not dominate profiles during a simple dd test the
cost of it is reduced.

73048     0.7428  vmlinux-3.15.0-rc5-mmotm-20140513 end_page_writeback
23740     0.2409  vmlinux-3.15.0-rc5-lessatomic     end_page_writeback

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/filemap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 115c77d..b012dae 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -644,8 +644,17 @@ EXPORT_SYMBOL(unlock_page);
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
-- 
1.8.4.5

