Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3LQPqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:46:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3LQPpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:45:53 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC 4/5] memcg: make sure that memcg is not offline when charging
Date: Tue, 17 Dec 2013 16:45:29 +0100
Message-Id: <1387295130-19771-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1387295130-19771-1-git-send-email-mhocko@suse.cz>
References: <1387295130-19771-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current charge path might race with memcg offlining because holding
css reference doesn't stop css offline. As a result res counter might be
charged after mem_cgroup_reparent_charges (called from memcg css_offline
callback) and so the charge would never be freed. This has been worked
around by 96f1c58d8534 (mm: memcg: fix race condition between memcg
teardown and swapin) which tries to catch such a leaked charges later
during css_free. It is more optimal to heal this race in the long term
though.

In order to make this raceless we would need to hold rcu_read_lock since
css_tryget until res_counter_charge. This is not so easy unfortunately
because mem_cgroup_do_charge might sleep so we would need to do drop rcu
lock and do css_tryget tricks after each reclaim.

This patch addresses the issue by introducing memcg->offline flag
which is set from mem_cgroup_css_offline callback before the pages are
reparented. mem_cgroup_do_charge checks the flag before res_counter
is charged inside rcu read section. mem_cgroup_css_offline uses
synchronize_rcu to let all preceding chargers finish while all the new
ones will see the group offline already and back out.

Callers are then updated to retry with a new memcg which is fallback to
mem_cgroup_from_task(current).

The only exception is mem_cgroup_do_precharge which should never see
this race because it is called from cgroup {can_}attach callbacks and so
the whole cgroup cannot go away.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a122fde6cd54..2904b2a6805a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -324,6 +324,9 @@ struct mem_cgroup {
 	int kmemcg_id;
 #endif
 
+	/* Is memcg marked for offlining? */
+	bool 		offline;
+
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
 	nodemask_t	scan_nodes;
@@ -2587,6 +2590,9 @@ enum {
 	CHARGE_RETRY,		/* need to retry but retry is not bad */
 	CHARGE_NOMEM,		/* we can't do more. return -ENOMEM */
 	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
+	CHARGE_OFFLINE,		/* memcg is offline already so no further
+				 * charges are allowed
+				 */
 };
 
 static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
@@ -2599,20 +2605,36 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long flags = 0;
 	int ret;
 
+	/*
+	 * Although the holder keeps a css reference for memcg this doesn't
+	 * prevent it from being offlined in the meantime. We have to make sure
+	 * that res counter is charged before css_offline reparents its pages
+	 * otherwise the charge might leak.
+	 */
+	rcu_read_lock();
+	if (memcg->offline) {
+		rcu_read_unlock();
+		return CHARGE_OFFLINE;
+	}
 	ret = res_counter_charge(&memcg->res, csize, &fail_res);
-
 	if (likely(!ret)) {
-		if (!do_swap_account)
+		if (!do_swap_account) {
+			rcu_read_unlock();
 			return CHARGE_OK;
+		}
 		ret = res_counter_charge(&memcg->memsw, csize, &fail_res);
-		if (likely(!ret))
+		if (likely(!ret)) {
+			rcu_read_unlock();
 			return CHARGE_OK;
+		}
 
 		res_counter_uncharge(&memcg->res, csize);
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
+	rcu_read_unlock();
+
 	/*
 	 * Never reclaim on behalf of optional batching, retry with a
 	 * single page instead.
@@ -2704,6 +2726,12 @@ static int __mem_cgroup_try_charge_memcg(gfp_t gfp_mask,
 				goto nomem;
 			nr_oom_retries--;
 			break;
+		/*
+		 * memcg went offline, the caller should fallback to
+		 * a different group.
+		 */
+		case CHARGE_OFFLINE:
+			return -EAGAIN;
 		}
 	} while (ret != CHARGE_OK);
 
@@ -2747,6 +2775,7 @@ static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
 
 	VM_BUG_ON(!mm);
 
+again:
 	do {
 		if (mem_cgroup_bypass_charge())
 			goto bypass;
@@ -2778,6 +2807,8 @@ static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
 		goto bypass;
 	else if (ret == -ENOMEM)
 		memcg = NULL;
+	else if (ret == -EAGAIN)
+		goto again;
 
 	return memcg;
 bypass:
@@ -3666,6 +3697,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	if (!current->mm || current->memcg_kmem_skip_account)
 		return true;
 
+again:
 	memcg = try_get_mem_cgroup_from_mm(current->mm);
 
 	/*
@@ -3684,6 +3716,8 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	ret = memcg_charge_kmem(memcg, gfp, PAGE_SIZE << order);
 	if (!ret)
 		*_memcg = memcg;
+	else if (ret == -EAGAIN)
+		goto again;
 
 	css_put(&memcg->css);
 	return (ret == 0);
@@ -4008,6 +4042,8 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 	if (ret == -EINTR) {
 		*memcgp = root_mem_cgroup;
 		ret = 0;
+	} else if (ret == -EAGAIN) {
+		goto charge_cur_mm;
 	}
 	return ret;
 charge_cur_mm:
@@ -6340,6 +6376,14 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	/*
+	 * Mark the memcg offline and wait for the charger which uses
+	 * RCU read lock to make sure no charges will leak.
+	 * See mem_cgroup_do_charge for more details.
+	 */
+	memcg->offline = true;
+	synchronize_rcu();
+
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
@@ -6437,6 +6481,14 @@ one_by_one:
 			cond_resched();
 		}
 		ret = mem_cgroup_try_charge_memcg(GFP_KERNEL, 1, memcg, false);
+
+		/*
+		 * The target memcg cannot go offline because we are in
+		 * move path and cgroup core doesn't allow to offline
+		 * such groups.
+		 */
+		BUG_ON(ret == -EAGAIN);
+
 		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
-- 
1.8.4.4

