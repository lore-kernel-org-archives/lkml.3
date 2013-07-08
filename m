Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3GHJwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:52:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41714 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3GHJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:52:18 -0400
Subject: [PATCH 4/5] page_writeback: get rid of account_size argument in
 cancel_dirty_page()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 13:52:13 +0400
Message-ID: <20130708095213.13810.38211.stgit@zurg>
In-Reply-To: <20130708095202.13810.11659.stgit@zurg>
References: <20130708095202.13810.11659.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirty pages accounting always works with PAGE_CACHE_SIZE granularity.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/buffer.c                |    2 +-
 include/linux/page-flags.h |    2 +-
 mm/truncate.c              |    7 +++----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..37eee33 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3243,7 +3243,7 @@ int try_to_free_buffers(struct page *page)
 	 * dirty bit from being lost.
 	 */
 	if (ret)
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+		cancel_dirty_page(page);
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675..8a88f59 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -314,7 +314,7 @@ static inline void SetPageUptodate(struct page *page)
 
 CLEARPAGEFLAG(Uptodate, uptodate)
 
-extern void cancel_dirty_page(struct page *page, unsigned int account_size);
+extern void cancel_dirty_page(struct page *page);
 
 int test_clear_page_writeback(struct page *page);
 int test_set_page_writeback(struct page *page);
diff --git a/mm/truncate.c b/mm/truncate.c
index 9b4721f..e212252 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -66,7 +66,7 @@ void do_invalidatepage(struct page *page, unsigned int offset,
  * out all the buffers on a page without actually doing it through
  * the VM. Can you say "ext3 is horribly ugly"? Tought you could.
  */
-void cancel_dirty_page(struct page *page, unsigned int account_size)
+void cancel_dirty_page(struct page *page)
 {
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
@@ -74,8 +74,7 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
-			if (account_size)
-				task_io_account_cancelled_write(account_size);
+			task_io_account_cancelled_write(PAGE_CACHE_SIZE);
 		}
 	}
 }
@@ -104,7 +103,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	 * This is final dirty accounting check. Some filesystems may re-dirty
 	 * pages during invalidation, hence it's placed after that.
 	 */
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	cancel_dirty_page(page);
 
 	ClearPageMappedToDisk(page);
 	delete_from_page_cache(page);

