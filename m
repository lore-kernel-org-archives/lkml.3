Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3GHJwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:52:25 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64710 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3GHJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:52:21 -0400
Subject: [PATCH 5/5] page_writeback: put account_page_redirty() after
 set_page_dirty()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 13:52:17 +0400
Message-ID: <20130708095217.13810.22999.stgit@zurg>
In-Reply-To: <20130708095202.13810.11659.stgit@zurg>
References: <20130708095202.13810.11659.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function account_page_redirty() fixes dirty pages counter for redieried pages.
This patch prevents temporary underflows of dirty pages counters on zone/bdi
and current->nr_dirtied. This puts decrement after increment.

__set_page_dirty_nobuffers() in redirty_page_for_writeback() always returns true
because this page is locked and all ptes are write-protected by previously
called clear_page_dirty_for_io(). Thus nobody can mark it dirty except current
task. This prevents multy-threaded scenarios of taks->nr_dirtied underflows.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/btrfs/extent_io.c |    2 +-
 mm/page-writeback.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6bca947..d17fb9b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1311,8 +1311,8 @@ int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	while (index <= end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
-		account_page_redirty(page);
 		__set_page_dirty_nobuffers(page);
+		account_page_redirty(page);
 		page_cache_release(page);
 		index++;
 	}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4514ad7..a599f38 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2061,6 +2061,8 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
  * counters (NR_WRITTEN, BDI_WRITTEN) in long term. The mismatches will lead to
  * systematic errors in balanced_dirty_ratelimit and the dirty pages position
  * control.
+ *
+ * Must be called after marking page dirty.
  */
 void account_page_redirty(struct page *page)
 {
@@ -2080,9 +2082,12 @@ EXPORT_SYMBOL(account_page_redirty);
  */
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
+	int ret;
+
 	wbc->pages_skipped++;
+	ret = __set_page_dirty_nobuffers(page);
 	account_page_redirty(page);
-	return __set_page_dirty_nobuffers(page);
+	return ret;
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 

