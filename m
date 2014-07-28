Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaG1RKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:10:36 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54231 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaG1RKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:10:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: rewrite uncharge API fix - clear page->mapping in migration
Date: Mon, 28 Jul 2014 13:10:23 -0400
Message-Id: <1406567423-8305-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page->mapping reset in migration was conditionalized so that a
later uncharge could use PageAnon() to figure out the page type.  But
after "mm: memcontrol: rewrite uncharge API fix - double migration",
the old page is uncharged directly in mem_cgroup_migrate() and so this
is no longer necessary.

Once all fixups are folded into the "rewrite uncharge API" patch,
there will be no reason and no explanation for this change anymore, so
revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/migrate.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7f5a42403fae..5a46f1ec5f43 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -778,14 +778,12 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
 	if (rc != MIGRATEPAGE_SUCCESS) {
-		if (!PageAnon(newpage))
-			newpage->mapping = NULL;
+		newpage->mapping = NULL;
 	} else {
 		mem_cgroup_migrate(page, newpage, false);
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
-		if (!PageAnon(page))
-			page->mapping = NULL;
+		page->mapping = NULL;
 	}
 
 	unlock_page(newpage);
-- 
2.0.0

