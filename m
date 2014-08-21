Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaHUTE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaHUTE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:04:58 -0400
Date: Thu, 21 Aug 2014 21:01:58 +0200
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
Subject: [PATCH 4/4] mempolicy: unexport get_vma_policy() and remove its
	"task" arg
Message-ID: <20140821190158.GE8703@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com> <20140821190020.GA8703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821190020.GA8703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- get_vma_policy(task) is not safe if task != current, remove this
  argument.

- get_vma_policy() no longer has callers outside of mempolicy.c,
  make it static.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mempolicy.h |    2 --
 mm/mempolicy.c            |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index e1abe24..3d385c8 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,8 +137,6 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr);
-struct mempolicy *get_vma_policy(struct task_struct *tsk,
-		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9695a9a..008fb32 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1616,27 +1616,24 @@ struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 }
 
 /*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
+ * get_vma_policy(@vma, @addr)
  * @vma: virtual memory area whose policy is sought
  * @addr: address in @vma for shared policy lookup
  *
  * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
+ * Falls back to current->mempolicy or system default policy, as necessary.
  * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
  * count--added by the get_policy() vm_op, as appropriate--to protect against
  * freeing by another task.  It is the caller's responsibility to free the
  * extra reference for shared policies.
  */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = __get_vma_policy(vma, addr);
 
 	if (!pol)
-		pol = get_task_policy(task);
+		pol = get_task_policy(current);
 
 	return pol;
 }
@@ -1864,7 +1861,7 @@ struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 {
 	struct zonelist *zl;
 
-	*mpol = get_vma_policy(current, vma, addr);
+	*mpol = get_vma_policy(vma, addr);
 	*nodemask = NULL;	/* assume !MPOL_BIND */
 
 	if (unlikely((*mpol)->mode == MPOL_INTERLEAVE)) {
@@ -2019,7 +2016,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	unsigned int cpuset_mems_cookie;
 
 retry_cpuset:
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
@@ -2285,7 +2282,7 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 
 	BUG_ON(!vma);
 
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
 
-- 
1.5.5.1


