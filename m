Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaGVW2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:28:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbaGVW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:27:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 053/116] mm: fix sleeping function warning from __put_anon_vma
Date: Tue, 22 Jul 2014 15:21:04 -0700
Message-Id: <1406067727-19683-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/rmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 770320b..f350f9f 100644
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
1.9.1

