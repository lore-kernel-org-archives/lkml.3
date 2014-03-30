Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaCaAku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:40:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37641 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbaCaAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:40:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.329803739@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 091/200] mm: __set_page_dirty uses spin_lock_irqsave
 instead of spin_lock_irq
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 227d53b397a32a7614667b3ecaf1d89902fb6c12 upstream.

To use spin_{un}lock_irq is dangerous if caller disabled interrupt.
During aio buffer migration, we have a possibility to see the following
call stack.

aio_migratepage  [disable interrupt]
  migrate_page_copy
    clear_page_dirty_for_io
      set_page_dirty
        __set_page_dirty_buffers
          __set_page_dirty
            spin_lock_irq

This mean, current aio migration is a deadlockable.  spin_lock_irqsave
is a safer alternative and we should use it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: David Rientjes rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -663,14 +663,16 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static void __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
-	spin_lock_irq(&mapping->tree_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mapping->tree_lock, flags);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
-	spin_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 }
 

