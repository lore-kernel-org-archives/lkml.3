Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaDALgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:36:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaDALS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Filipe Brandenburger <filbranden@google.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/144] memcg: reparent charges of children before processing parent
Date: Tue,  1 Apr 2014 12:15:13 +0100
Message-Id: <1396350948-29910-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Brandenburger <filbranden@google.com>

commit 4fb1a86fb5e4209a7d4426d4e586c58e9edc74ac upstream.

Sometimes the cleanup after memcg hierarchy testing gets stuck in
mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.

There may turn out to be several causes, but a major cause is this: the
workitem to offline parent can get run before workitem to offline child;
parent's mem_cgroup_reparent_charges() circles around waiting for the
child's pages to be reparented to its lrus, but it's holding
cgroup_mutex which prevents the child from reaching its
mem_cgroup_reparent_charges().

Further testing showed that an ordered workqueue for cgroup_destroy_wq
is not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched
stage on the way can mess up the order before reaching the workqueue.

Instead, when offlining a memcg, call mem_cgroup_reparent_charges() on
all its children (and grandchildren, in the correct order) to have their
charges reparented first.

Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ Hugh:
  Yes, more differences, and the old mem_cgroup_reparent_charges line
  is intentionally left in for 3.10 whereas it was removed for 3.12+:
  that's because the css/cgroup iterator changed in between, it used
  not to supply the root of the subtree, but nowadays it does. ]
[ luis: backported to 3.11: used Hugh's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bb13089..4e4b328 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6346,11 +6346,25 @@ static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
 static void mem_cgroup_css_offline(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	struct cgroup *iter;
 
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
+
+	/*
+	 * This requires that offlining is serialized.  Right now that is
+	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
+	 */
+	rcu_read_lock();
+	cgroup_for_each_descendant_post(iter, cont) {
+		rcu_read_unlock();
+		mem_cgroup_reparent_charges(mem_cgroup_from_cont(iter));
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
 	mem_cgroup_reparent_charges(memcg);
+
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
-- 
1.9.1

