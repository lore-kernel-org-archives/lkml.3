Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbaGPQUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:20:19 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60985 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934554AbaGPQUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:20:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch v2] mm: memcontrol: rewrite uncharge API fix - double migration
Date: Wed, 16 Jul 2014 12:19:56 -0400
Message-Id: <1405527596-7267-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
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

Properly uncharge the page after it's been migrated, including the
clearing of PCG_USED, so that a subsequent charge migration attempt
will be able to detect it and bail out.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Andrew, this replaces the patch of the same name in -mm.  As Hugh
points out, we really have to clear PCG_USED of migrated pages, as
they are no longer pinning the memcg and so their pc->mem_cgroup can
no longer be trusted.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e3b27f8dc2f..1439537fe7c9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6655,7 +6655,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
 	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
-	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
 	if (PageTransHuge(oldpage)) {
 		nr_pages <<= compound_order(oldpage);
@@ -6663,6 +6662,13 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
 	}
 
+	pc->flags = 0;
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
+	memcg_check_events(pc->mem_cgroup, oldpage);
+	local_irq_enable();
+
 	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
 }
 
-- 
2.0.0

