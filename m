Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3I0Nef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:34:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3I0N2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:35 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 45/63] mm: numa: copy cpupid on page migration
Date: Fri, 27 Sep 2013 14:27:30 +0100
Message-Id: <1380288468-5551-46-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

After page migration, the new page has the nidpid unset. This makes
every fault on a recently migrated page look like a first numa fault,
leading to another page migration.

Copying over the nidpid at page migration time should prevent erroneous
migrations of recently migrated pages.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 6ff845f..1e1dbc9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -439,6 +439,8 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
  */
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
+	int cpupid;
+
 	if (PageHuge(page) || PageTransHuge(page))
 		copy_huge_page(newpage, page);
 	else
@@ -475,6 +477,13 @@ void migrate_page_copy(struct page *newpage, struct page *page)
 			__set_page_dirty_nobuffers(newpage);
  	}
 
+	/*
+	 * Copy NUMA information to the new page, to prevent over-eager
+	 * future migrations of this same page.
+	 */
+	cpupid = page_cpupid_xchg_last(page, -1);
+	page_cpupid_xchg_last(newpage, cpupid);
+
 	mlock_migrate_page(newpage, page);
 	ksm_migrate_page(newpage, page);
 	/*
-- 
1.8.1.4

