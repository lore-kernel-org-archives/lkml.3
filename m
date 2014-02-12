Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaBLXEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:04:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37872 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaBLXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:04:44 -0500
Date: Wed, 12 Feb 2014 15:03:31 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/2] memcg: reparent charges of children before processing
 parent
Message-ID: <alpine.LSU.2.11.1402121500070.5029@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Brandenburger <filbranden@google.com>

Sometimes the cleanup after memcg hierarchy testing gets stuck in
mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.

There may turn out to be several causes, but a major cause is this: the
workitem to offline parent can get run before workitem to offline child;
parent's mem_cgroup_reparent_charges() circles around waiting for the
child's pages to be reparented to its lrus, but it's holding cgroup_mutex
which prevents the child from reaching its mem_cgroup_reparent_charges().

Further testing showed that an ordered workqueue for cgroup_destroy_wq
is not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched
stage on the way can mess up the order before reaching the workqueue.

Instead, when offlining a memcg, call mem_cgroup_reparent_charges() on
all its children (and grandchildren, in the correct order) to have their
charges reparented first.

Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # v3.10+ (but will need extra care)
---
Or, you may prefer my alternative cgroup.c approach in 2/2:
there's no need for both.  Please note that neither of these patches
attempts to handle the unlikely case of racy charges made to child
after its offline, but parent's offline coming before child's free:
mem_cgroup_css_free()'s backstop call to mem_cgroup_reparent_charges()
cannot help in that case, with or without these patches.  Fixing that
would have to be a separate effort - Michal's?

 mm/memcontrol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- 3.14-rc2/mm/memcontrol.c	2014-02-02 18:49:07.897302115 -0800
+++ linux/mm/memcontrol.c	2014-02-11 17:48:07.604582963 -0800
@@ -6595,6 +6595,7 @@ static void mem_cgroup_css_offline(struc
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup_event *event, *tmp;
+	struct cgroup_subsys_state *iter;
 
 	/*
 	 * Unregister events and notify userspace.
@@ -6611,7 +6612,14 @@ static void mem_cgroup_css_offline(struc
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
-	mem_cgroup_reparent_charges(memcg);
+
+	/*
+	 * This requires that offlining is serialized.  Right now that is
+	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
+	 */
+	css_for_each_descendant_post(iter, css)
+		mem_cgroup_reparent_charges(mem_cgroup_from_css(iter));
+
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
