Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbaCUAGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:06:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799AbaCUAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 149/149] memcg: reparent charges of children before processing parent
Date: Thu, 20 Mar 2014 17:05:12 -0700
Message-Id: <20140321000442.129914482@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/memcontrol.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6360,11 +6360,24 @@ static void mem_cgroup_invalidate_reclai
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct cgroup_subsys_state *iter;
 
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
-	mem_cgroup_reparent_charges(memcg);
+
+	/*
+	 * This requires that offlining is serialized.  Right now that is
+	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
+	 */
+	rcu_read_lock();
+	css_for_each_descendant_post(iter, css) {
+		rcu_read_unlock();
+		mem_cgroup_reparent_charges(mem_cgroup_from_css(iter));
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }


