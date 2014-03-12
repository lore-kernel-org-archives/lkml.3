Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaCLBaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:30:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33945 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbaCLB25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:28:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 4/8] mm: memcg: push !mm handling out to page cache charge function
Date: Tue, 11 Mar 2014 21:28:30 -0400
Message-Id: <1394587714-6966-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only page cache charges can happen without an mm context, so push this
special case out of the inner core and into the cache charge function.

An ancient comment explains that the mm can also be NULL in case the
task is currently being migrated, but that is not actually true with
the current case, so just remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cfdb9c385d8d..c40186cf22ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2737,15 +2737,6 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!*ptr && !mm)
-		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -4070,6 +4061,12 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		return 0;
 
 	if (!PageSwapCache(page)) {
+		/*
+		 * Page cache insertions can happen without an actual
+		 * task context, e.g. during disk probing on boot.
+		 */
+		if (!mm)
+			memcg = root_mem_cgroup;
 		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
 		if (ret != -ENOMEM)
 			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
-- 
1.9.0

