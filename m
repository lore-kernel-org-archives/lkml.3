Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3LDWpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:45:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44438 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab3LDWph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:45:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/2] mm: memcg: do not allow task about to OOM kill to bypass the limit
Date: Wed,  4 Dec 2013 17:45:14 -0500
Message-Id: <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
References: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully") allowed tasks that already entered a memcg OOM condition
to bypass the memcg limit on subsequent allocation attempts hoping
this would expedite finishing the page fault and executing the kill.

David Rientjes is worried that this breaks memcg isolation guarantees
and since there is no evidence that the bypass actually speeds up
fault processing just change it so that these subsequent charge
attempts fail outright.  The notable exception being __GFP_NOFAIL
charges which are required to bypass the limit regardless.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f6a63f5b3827..bf5e89457149 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2694,7 +2694,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-		goto bypass;
+		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-- 
1.8.4.2

