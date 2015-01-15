Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbbAOQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:00:04 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:44659 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbbAOQAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:00:02 -0500
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Subject: [PATCH] page_writeback: put account_page_redirty() after
 set_page_dirty()
From: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: koct9i@gmail.com
Date: Thu, 15 Jan 2015 18:52:38 +0300
Message-ID: <20150115155238.31251.41331.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper account_page_redirty() fixes dirty pages counter for redirtied pages.
This patch puts it after dirtying and prevents temporary underflows of
dirtied pages counters on zone/bdi and current->nr_dirtied.

Signed-off-by: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
---
 fs/btrfs/extent_io.c |    2 +-
 mm/page-writeback.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ebabd2..281bc7e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1407,8 +1407,8 @@ int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
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
index 6f43352..4da3cd5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2168,9 +2168,12 @@ EXPORT_SYMBOL(account_page_redirty);
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
 

