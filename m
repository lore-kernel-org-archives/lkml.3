Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbaCED7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:59:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40569 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbaCED7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:59:48 -0500
Date: Tue, 4 Mar 2014 19:59:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [patch 11/11] mm, memcg: allow system oom killer to be disabled
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403041957340.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that system oom conditions can properly be handled from userspace,
allow the oom killer to be disabled.  Otherwise, the kernel will
immediately kill a process and memory will be freed.  The userspace oom
handler may have a different policy.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/memory.txt |  4 ++--
 include/linux/memcontrol.h       |  6 ++++++
 mm/memcontrol.c                  | 11 ++++++++---
 mm/oom_kill.c                    |  3 +++
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -755,8 +755,8 @@ You can disable the OOM-killer by writing "1" to memory.oom_control file, as:
 
 	# echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy and does
-not include the root memcg.
+This operation is only allowed to the top cgroup of a sub-hierarchy.  If
+disabled for the root memcg, the system oom killer is disabled.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -159,6 +159,7 @@ bool mem_cgroup_oom_synchronize(bool wait);
 extern bool mem_cgroup_alloc_use_oom_reserve(void);
 extern u64 mem_cgroup_root_oom_reserve(void);
 extern void mem_cgroup_root_oom_notify(void);
+extern bool mem_cgroup_root_oom_disable(void);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -415,6 +416,11 @@ static inline void mem_cgroup_root_oom_notify(void)
 {
 }
 
+static inline bool mem_cgroup_root_oom_disable(void)
+{
+	return false;
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5976,13 +5976,13 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	/* only 0 and 1 are allowed */
+	if (val != !!val)
 		return -EINVAL;
 
 	mutex_lock(&memcg_create_mutex);
 	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
+	if (parent && (parent->use_hierarchy || memcg_has_children(memcg))) {
 		mutex_unlock(&memcg_create_mutex);
 		return -EINVAL;
 	}
@@ -6062,6 +6062,11 @@ u64 mem_cgroup_root_oom_reserve(void)
 	return root_mem_cgroup->oom_reserve >> PAGE_SHIFT;
 }
 
+bool mem_cgroup_root_oom_disable(void)
+{
+	return root_mem_cgroup->oom_kill_disable;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -656,6 +656,9 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
+	if (mem_cgroup_root_oom_disable())
+		return;
+
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
