Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbaE2QQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:16:48 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33619 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbaE2QQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:16:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 04/10] mm: memcontrol: reclaim at least once for __GFP_NORETRY
Date: Thu, 29 May 2014 12:15:56 -0400
Message-Id: <1401380162-24121-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __GFP_NORETRY tries charging once and gives up before even
trying to reclaim.  Bring the behavior on par with the page allocator
and reclaim at least once before giving up.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8d5075c081f..8957d6c945b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2614,13 +2614,13 @@ retry:
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
1.9.3

