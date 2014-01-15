Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaAOWYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:24:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAOV6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 057/166] mm: memcg: fix race condition between memcg teardown and swapin
Date: Wed, 15 Jan 2014 13:51:11 -0800
Message-Id: <1389822780-4729-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 96f1c58d853497a757463e0b57fed140d6858f3a upstream.

There is a race condition between a memcg being torn down and a swapin
triggered from a different memcg of a page that was recorded to belong
to the exiting memcg on swapout (with CONFIG_MEMCG_SWAP extension).  The
result is unreclaimable pages pointing to dead memcgs, which can lead to
anything from endless loops in later memcg teardown (the page is charged
to all hierarchical parents but is not on any LRU list) or crashes from
following the dangling memcg pointer.

Memcgs with tasks in them can not be torn down and usually charges don't
show up in memcgs without tasks.  Swapin with the CONFIG_MEMCG_SWAP
extension is the notable exception because it charges the cgroup that
was recorded as owner during swapout, which may be empty and in the
process of being torn down when a task in another memcg triggers the
swapin:

  teardown:                 swapin:

                            lookup_swap_cgroup_id()
                            rcu_read_lock()
                            mem_cgroup_lookup()
                            css_tryget()
                            rcu_read_unlock()
  disable css_tryget()
  call_rcu()
    offline_css()
      reparent_charges()
                            res_counter_charge() (hierarchical!)
                            css_put()
                              css_free()
                            pc->mem_cgroup = dead memcg
                            add page to dead lru

Add a final reparenting step into css_free() to make sure any such raced
charges are moved out of the memcg before it's finally freed.

In the longer term it would be cleaner to have the css_tryget() and the
res_counter charge under the same RCU lock section so that the charge
reparenting is deferred until the last charge whose tryget succeeded is
visible.  But this will require more invasive changes that will be
harder to evaluate and backport into stable, so better defer them to a
separate change set.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memcontrol.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6b7ff19..3e6bb9f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6175,6 +6175,42 @@ static void mem_cgroup_css_offline(struct cgroup *cont)
 static void mem_cgroup_css_free(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	/*
+	 * XXX: css_offline() would be where we should reparent all
+	 * memory to prepare the cgroup for destruction.  However,
+	 * memcg does not do css_tryget() and res_counter charging
+	 * under the same RCU lock region, which means that charging
+	 * could race with offlining.  Offlining only happens to
+	 * cgroups with no tasks in them but charges can show up
+	 * without any tasks from the swapin path when the target
+	 * memcg is looked up from the swapout record and not from the
+	 * current task as it usually is.  A race like this can leak
+	 * charges and put pages with stale cgroup pointers into
+	 * circulation:
+	 *
+	 * #0                        #1
+	 *                           lookup_swap_cgroup_id()
+	 *                           rcu_read_lock()
+	 *                           mem_cgroup_lookup()
+	 *                           css_tryget()
+	 *                           rcu_read_unlock()
+	 * disable css_tryget()
+	 * call_rcu()
+	 *   offline_css()
+	 *     reparent_charges()
+	 *                           res_counter_charge()
+	 *                           css_put()
+	 *                             css_free()
+	 *                           pc->mem_cgroup = dead memcg
+	 *                           add page to lru
+	 *
+	 * The bulk of the charges are still moved in offline_css() to
+	 * avoid pinning a lot of pages in case a long-term reference
+	 * like a swapout record is deferring the css_free() to long
+	 * after offlining.  But this makes sure we catch any charges
+	 * made after offlining:
+	 */
+	mem_cgroup_reparent_charges(memcg);
 
 	kmem_cgroup_destroy(memcg);
 
-- 
1.8.3.2

