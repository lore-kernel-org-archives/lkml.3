Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaHTT0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:26:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaHTT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:26:33 -0400
Date: Wed, 20 Aug 2014 21:23:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mempolicy: change get_task_policy() to return
	default_policy rather than NULL
Message-ID: <20140820192309.GC8524@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820192207.GA8524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every caller of get_task_policy() falls back to default_policy if it
returns NULL. Change get_task_policy() to do this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c0c5d38..656db97 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -126,22 +126,20 @@ static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
+	int node;
 
-	if (!pol) {
-		int node = numa_node_id();
+	if (pol)
+		return pol;
 
-		if (node != NUMA_NO_NODE) {
-			pol = &preferred_node_policy[node];
-			/*
-			 * preferred_node_policy is not initialised early in
-			 * boot
-			 */
-			if (!pol->mode)
-				pol = NULL;
-		}
+	node = numa_node_id();
+	if (node != NUMA_NO_NODE) {
+		pol = &preferred_node_policy[node];
+		/* preferred_node_policy is not initialised early in boot */
+		if (pol->mode)
+			return pol;
 	}
 
-	return pol;
+	return &default_policy;
 }
 
 static const struct mempolicy_operations {
@@ -1644,14 +1642,14 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 				mpol_get(pol);
 		}
 	}
-	if (!pol)
-		pol = &default_policy;
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
 	struct mempolicy *pol = get_task_policy(task);
+
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			bool ret = false;
@@ -1667,9 +1665,6 @@ bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 		}
 	}
 
-	if (!pol)
-		return default_policy.flags & MPOL_F_MOF;
-
 	return pol->flags & MPOL_F_MOF;
 }
 
@@ -2077,7 +2072,7 @@ struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
-	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
+	if (in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
 
 retry_cpuset:
-- 
1.5.5.1


