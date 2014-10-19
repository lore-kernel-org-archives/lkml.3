Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJSPbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:31:55 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42274 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaJSPbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:31:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: clarify migration where old page is uncharged
Date: Sun, 19 Oct 2014 11:30:47 -0400
Message-Id: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better explain re-entrant migration when compaction races with
reclaim, and also mention swapcache readahead pages as possible
uncharged migration sources.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fc1d7ca96b9d..76892eb89d26 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6166,7 +6166,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 	if (PageCgroupUsed(pc))
 		return;
 
-	/* Re-entrant migration: old page already uncharged? */
+	/*
+	 * Swapcache readahead pages can get migrated before being
+	 * charged, and migration from compaction can happen to an
+	 * uncharged page when the PFN walker finds a page that
+	 * reclaim just put back on the LRU but has not released yet.
+	 */
 	pc = lookup_page_cgroup(oldpage);
 	if (!PageCgroupUsed(pc))
 		return;
-- 
2.1.2

