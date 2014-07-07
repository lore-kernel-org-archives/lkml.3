Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaGGSwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:52:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54122 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbaGGSwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:52:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 2/3] mm: memcontrol: rewrite uncharge API fix - double migration
Date: Mon,  7 Jul 2014 14:52:12 -0400
Message-Id: <1404759133-29218-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org>
References: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh reports:

VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM))
mm/memcontrol.c:6680!
page had count 1 mapcount 0 mapping anon index 0x196
flags locked uptodate reclaim swapbacked, pcflags 1, memcg not root
mem_cgroup_migrate < move_to_new_page < migrate_pages < compact_zone <
compact_zone_order < try_to_compact_pages < __alloc_pages_direct_compact <
__alloc_pages_nodemask < alloc_pages_vma < do_huge_pmd_anonymous_page <
handle_mm_fault < __do_page_fault

mem_cgroup_migrate() assumes that a page is only migrated once and
then freed immediately after.

However, putting the page back on the LRU list and dropping the
isolation refcount is not done atomically.  This allows a PFN-based
migrator like compaction to isolate the page, see the expected
anonymous page refcount of 1, and migrate the page once more.

Catch pages that have already been migrated and abort migration
gracefully.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e3b27f8dc2f..e4afdbdda0a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6653,7 +6653,10 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
+	/* Already migrated */
+	if (!(pc->flags & PCG_MEM))
+		return;
+
 	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
-- 
2.0.0

