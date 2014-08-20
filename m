Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaHTT02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaHTT01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:26:27 -0400
Date: Wed, 20 Aug 2014 21:23:30 +0200
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
Subject: [PATCH 3/4] mempolicy: sanitize the usage of get_task_policy()
Message-ID: <20140820192330.GD8524@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820192207.GA8524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup + preparation. Every user of get_task_policy() calls it
unconditionally, even if it is not going to use the result.

get_task_policy() is cheap but still this does not look clean, plus
the code looks simpler if get_task_policy() is called only when this
is really needed.

Note: I hope this is correct, but it is not clear why vma_policy_mof()
doesn't fall back to get_task_policy() if ->get_policy() returns NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 656db97..b86b08e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1621,14 +1621,11 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulong_t, start, compat_ulong_t, len,
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
-									addr);
-			if (vpol)
-				pol = vpol;
+			pol = vma->vm_ops->get_policy(vma, addr);
 		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
 
@@ -1643,12 +1640,15 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 		}
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1660,11 +1660,14 @@ bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 			mpol_cond_put(pol);
 
 			return ret;
-		} else if (vma->vm_policy) {
-			pol = vma->vm_policy;
 		}
+
+		pol = vma->vm_policy;
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol->flags & MPOL_F_MOF;
 }
 
@@ -2068,12 +2071,12 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = get_task_policy(current);
+	struct mempolicy *pol = &default_policy;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
-	if (in_interrupt() || (gfp & __GFP_THISNODE))
-		pol = &default_policy;
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
 
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
-- 
1.5.5.1


