Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaFRUlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:41:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:37522 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbaFRUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:40:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 03/13] mm: memcontrol: reclaim at least once for __GFP_NORETRY
Date: Wed, 18 Jun 2014 16:40:35 -0400
Message-Id: <1403124045-24361-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __GFP_NORETRY tries charging once and gives up before even
trying to reclaim.  Bring the behavior on par with the page allocator
and reclaim at least once before giving up.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e946f7439b16..16f0206696ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2613,13 +2613,13 @@ retry:
 	if (!(gfp_mask & __GFP_WAIT))
 		goto nomem;
 
-	if (gfp_mask & __GFP_NORETRY)
-		goto nomem;
-
 	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= batch)
 		goto retry;
+
+	if (gfp_mask & __GFP_NORETRY)
+		goto nomem;
 	/*
 	 * Even though the limit is exceeded at this point, reclaim
 	 * may have been able to free some pages.  Retry the charge
-- 
2.0.0

