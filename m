Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaIWCnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:43:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:38571 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbaIWCkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:49 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        penberg@kernel.org, cl@linux.com, David Mackey <tdmackey@twitter.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 38/45] slab/mempolicy: always use local policy from interrupt context
Date: Tue, 23 Sep 2014 10:31:40 +0800
Message-Id: <1411439507-30391-38-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit e7b691b085fda913830e5280ae6f724b2a63c824 upstream.

slab_node() could access current->mempolicy from interrupt context.
However there's a race condition during exit where the mempolicy
is first freed and then the pointer zeroed.

Using this from interrupts seems bogus anyways. The interrupt
will interrupt a random process and therefore get a random
mempolicy. Many times, this will be idle's, which noone can change.

Just disable this here and always use local for slab
from interrupts. I also cleaned up the callers of slab_node a bit
which always passed the same argument.

I believe the original mempolicy code did that in fact,
so it's likely a regression.

v2: send version with correct logic
v3: simplify. fix typo.
Reported-by: Arun Sharma <asharma@fb.com>
Cc: penberg@kernel.org
Cc: cl@linux.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[tdmackey@twitter.com: Rework control flow based on feedback from
cl@linux.com, fix logic, and cleanup current task_struct reference]
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Mackey <tdmackey@twitter.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    8 +++++++-
 mm/slab.c                 |    4 ++--
 mm/slub.c                 |    2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index fe07e5a..cc49b23 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -205,7 +205,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(struct mempolicy *policy);
+extern unsigned slab_node(void);
 
 extern enum zone_type policy_zone;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5cec36b..87a43cc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1609,8 +1609,14 @@ static unsigned interleave_nodes(struct mempolicy *policy)
  * task can change it's policy.  The system default policy requires no
  * such protection.
  */
-unsigned slab_node(struct mempolicy *policy)
+unsigned slab_node(void)
 {
+	struct mempolicy *policy;
+
+	if (in_interrupt())
+		return numa_node_id();
+
+	policy = current->mempolicy;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
 		return numa_node_id();
 
diff --git a/mm/slab.c b/mm/slab.c
index da2bb68..3eb1c38 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3336,7 +3336,7 @@ static void *alternate_node_alloc(struct kmem_cache *cachep, gfp_t flags)
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc = slab_node(current->mempolicy);
+		nid_alloc = slab_node();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3368,7 +3368,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+	zonelist = node_zonelist(slab_node(), flags);
 
 retry:
 	/*
diff --git a/mm/slub.c b/mm/slub.c
index c6f225f..54ac6e9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1617,7 +1617,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
 
 	do {
 		cpuset_mems_cookie = get_mems_allowed();
-		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+		zonelist = node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
 
-- 
1.7.9.5

