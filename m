Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaIKNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:14:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Rientjes" <rientjes@google.com>,
        penberg@kernel.org, "Andi Kleen" <ak@linux.intel.com>,
        "David Mackey" <tdmackey@twitter.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, cl@linux.com,
        "Arun Sharma" <asharma@fb.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.543594834@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/131] slab/mempolicy: always use local policy from
 interrupt context
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mempolicy.h | 2 +-
 mm/mempolicy.c            | 8 +++++++-
 mm/slab.c                 | 4 ++--
 mm/slub.c                 | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -205,7 +205,7 @@ extern struct zonelist *huge_zonelist(st
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(struct mempolicy *policy);
+extern unsigned slab_node(void);
 
 extern enum zone_type policy_zone;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1601,8 +1601,14 @@ static unsigned interleave_nodes(struct
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
 
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3270,7 +3270,7 @@ static void *alternate_node_alloc(struct
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc = slab_node(current->mempolicy);
+		nid_alloc = slab_node();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3302,7 +3302,7 @@ static void *fallback_alloc(struct kmem_
 
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+	zonelist = node_zonelist(slab_node(), flags);
 
 retry:
 	/*
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1608,7 +1608,7 @@ static struct page *get_any_partial(stru
 
 	do {
 		cpuset_mems_cookie = get_mems_allowed();
-		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+		zonelist = node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
 

