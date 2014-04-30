Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbaD3U0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:26:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59950 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552AbaD3UZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:25:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/9] mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
Date: Wed, 30 Apr 2014 16:25:37 -0400
Message-Id: <1398889543-23671-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason why oom-disabled and __GFP_NOFAIL charges should
try to reclaim only once when every other charge tries several times
before giving up.  Make them all retry the same number of times.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6ce59146fec7..c431a30280ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2589,7 +2589,7 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
 				 bool oom)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
-	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct res_counter *fail_res;
 	unsigned long nr_reclaimed;
@@ -2660,6 +2660,9 @@ retry:
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		goto retry;
 
+	if (nr_retries--)
+		goto retry;
+
 	if (gfp_mask & __GFP_NOFAIL)
 		goto bypass;
 
@@ -2669,9 +2672,6 @@ retry:
 	if (!oom)
 		goto nomem;
 
-	if (nr_oom_retries--)
-		goto retry;
-
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
-- 
1.9.2

