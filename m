Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbaF3Mdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:33:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbaF3McD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/181] mm: fix sleeping function warning from __put_anon_vma
Date: Mon, 30 Jun 2014 13:52:17 +0200
Message-Id: <dc3838a076dc9f6cfac74cf27d9e2b6b2b3d9031.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7f39dda9d86fb4f4f17af0de170decf125726f8c upstream.

Trinity reports BUG:

  sleeping function called from invalid context at kernel/locking/rwsem.c:47
  in_atomic(): 0, irqs_disabled(): 0, pid: 5787, name: trinity-c27

__might_sleep < down_write < __put_anon_vma < page_get_anon_vma <
migrate_pages < compact_zone < compact_zone_order < try_to_compact_pages ..

Right, since conversion to mutex then rwsem, we should not put_anon_vma()
from inside an rcu_read_lock()ed section: fix the two places that did so.
And add might_sleep() to anon_vma_free(), as suggested by Peter Zijlstra.

Fixes: 88c22088bf23 ("mm: optimize page_lock_anon_vma() fast-path")
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/rmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 91ab22878103..4271107aa46e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -103,6 +103,7 @@ static inline void anon_vma_free(struct anon_vma *anon_vma)
 	 * LOCK should suffice since the actual taking of the lock must
 	 * happen _before_ what follows.
 	 */
+	might_sleep();
 	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
@@ -426,8 +427,9 @@ struct anon_vma *page_get_anon_vma(struct page *page)
 	 * above cannot corrupt).
 	 */
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
+		return NULL;
 	}
 out:
 	rcu_read_unlock();
@@ -477,9 +479,9 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 	}
 
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto out;
+		return NULL;
 	}
 
 	/* we pinned the anon_vma, its safe to sleep */
-- 
2.0.0

