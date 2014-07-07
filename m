Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaGGSwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:52:31 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54127 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaGGSw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:52:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 3/3] mm: memcontrol: rewrite uncharge API fix - migrate before re-mapping
Date: Mon,  7 Jul 2014 14:52:13 -0400
Message-Id: <1404759133-29218-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org>
References: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mapped file accounting depends on the the page being charged already,
or it won't get accounted properly, and the mapped file counter will
underflow during unmap later on.

Move mem_cgroup_migrate() before remove_migration_ptes().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ab43fbfff8ba..7f5a42403fae 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -781,11 +781,11 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		if (!PageAnon(newpage))
 			newpage->mapping = NULL;
 	} else {
+		mem_cgroup_migrate(page, newpage, false);
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
 		if (!PageAnon(page))
 			page->mapping = NULL;
-		mem_cgroup_migrate(page, newpage, false);
 	}
 
 	unlock_page(newpage);
-- 
2.0.0

