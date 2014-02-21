Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaBUMuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaBUMt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/121] mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq
Date: Fri, 21 Feb 2014 12:47:40 +0000
Message-Id: <1392986945-9693-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..a9863a8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -654,14 +654,16 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
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
 
-- 
1.9.0

