Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbaGPQ3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:29:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60997 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934546AbaGPQ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:28:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: use page lists for uncharge batching fix - hugetlb page->lru
Date: Wed, 16 Jul 2014 12:28:53 -0400
Message-Id: <1405528133-3054-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya-san reports that page->lru of hugetlb pages gets corrupted when
they hit the uncharge path from put_page().

Add a preliminary check for whether the page is even a valid memcg
page before messing with it's ->lru list.

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2f924359e79..0eb1eaa2f1ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6606,9 +6606,16 @@ static void uncharge_list(struct list_head *page_list)
  */
 void mem_cgroup_uncharge(struct page *page)
 {
+	struct page_cgroup *pc;
+
 	if (mem_cgroup_disabled())
 		return;
 
+	/* Don't touch page->lru of any random page, pre-check: */
+	pc = lookup_page_cgroup(page);
+	if (!PageCgroupUsed(pc))
+		return;
+
 	INIT_LIST_HEAD(&page->lru);
 	uncharge_list(&page->lru);
 }
-- 
2.0.0

