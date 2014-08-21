Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaHUTDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbaHUTDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:03:47 -0400
Date: Thu, 21 Aug 2014 21:00:51 +0200
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
Subject: [PATCH 1/4] mempolicy: introduce __get_vma_policy(), export
	get_task_policy()
Message-ID: <20140821190051.GB8703@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com> <20140821190020.GA8703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821190020.GA8703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the code which looks for vma's policy from get_vma_policy()
into the new helper, __get_vma_policy(). Export get_task_policy().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mempolicy.h |    3 +++
 mm/mempolicy.c            |   44 ++++++++++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 5e4bfce..e1abe24 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -134,6 +134,9 @@ void mpol_free_shared_policy(struct shared_policy *p);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    unsigned long idx);
 
+struct mempolicy *get_task_policy(struct task_struct *p);
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+		unsigned long addr);
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ad27bbc..4378c33 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -123,7 +123,7 @@ static struct mempolicy default_policy = {
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
-static struct mempolicy *get_task_policy(struct task_struct *p)
+struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
 	int node;
@@ -1603,23 +1603,8 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulong_t, start, compat_ulong_t, len,
 
 #endif
 
-/*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
- * @vma: virtual memory area whose policy is sought
- * @addr: address in @vma for shared policy lookup
- *
- * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
- * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
- * count--added by the get_policy() vm_op, as appropriate--to protect against
- * freeing by another task.  It is the caller's responsibility to free the
- * extra reference for shared policies.
- */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = NULL;
 
@@ -1640,6 +1625,29 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 		}
 	}
 
+	return pol;
+}
+
+/*
+ * get_vma_policy(@task, @vma, @addr)
+ * @task: task for fallback if vma policy == default
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
+ *
+ * Returns effective policy for a VMA at specified address.
+ * Falls back to @task or system default policy, as necessary.
+ * Current or other task's task mempolicy and non-shared vma policies must be
+ * protected by task_lock(task) by the caller.
+ * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
+ * count--added by the get_policy() vm_op, as appropriate--to protect against
+ * freeing by another task.  It is the caller's responsibility to free the
+ * extra reference for shared policies.
+ */
+struct mempolicy *get_vma_policy(struct task_struct *task,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol = __get_vma_policy(vma, addr);
+
 	if (!pol)
 		pol = get_task_policy(task);
 
-- 
1.5.5.1


