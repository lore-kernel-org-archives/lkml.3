Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3GJRHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab3GJRHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:07:06 -0400
Date: Wed, 10 Jul 2013 19:02:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: mempolicy: turn vma_set_policy() into vma_dup_policy()
Message-ID: <20130710170205.GA26425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple cleanup. Every user of vma_set_policy() does the same work,
this looks a bit annoying imho. And the new trivial helper which
does mpol_dup() + vma_set_policy() to simplify the callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mempolicy.h |    9 +++++++--
 kernel/fork.c             |    9 +++------
 mm/mempolicy.c            |   10 ++++++++++
 mm/mmap.c                 |   17 +++++------------
 4 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0d7df39..b2f8977 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -91,7 +91,6 @@ static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 }
 
 #define vma_policy(vma) ((vma)->vm_policy)
-#define vma_set_policy(vma, pol) ((vma)->vm_policy = (pol))
 
 static inline void mpol_get(struct mempolicy *pol)
 {
@@ -126,6 +125,7 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
+int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
@@ -240,7 +240,12 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 }
 
 #define vma_policy(vma) NULL
-#define vma_set_policy(vma, pol) do {} while(0)
+
+static inline int
+vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
+{
+	return 0;
+}
 
 static inline void numa_policy_init(void)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 987b28a..1c214fe 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -351,7 +351,6 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
 	unsigned long charge;
-	struct mempolicy *pol;
 
 	uprobe_start_dup_mmap();
 	down_write(&oldmm->mmap_sem);
@@ -402,11 +401,9 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			goto fail_nomem;
 		*tmp = *mpnt;
 		INIT_LIST_HEAD(&tmp->anon_vma_chain);
-		pol = mpol_dup(vma_policy(mpnt));
-		retval = PTR_ERR(pol);
-		if (IS_ERR(pol))
+		retval = vma_dup_policy(mpnt, tmp);
+		if (retval)
 			goto fail_nomem_policy;
-		vma_set_policy(tmp, pol);
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
@@ -474,7 +471,7 @@ out:
 	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
-	mpol_put(pol);
+	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
 	kmem_cache_free(vm_area_cachep, tmp);
 fail_nomem:
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4baf12e..6b1d426 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2065,6 +2065,16 @@ retry_cpuset:
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
+int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
+{
+	struct mempolicy *pol = mpol_dup(vma_policy(src));
+
+	if (IS_ERR(pol))
+		return PTR_ERR(pol);
+	dst->vm_policy = pol;
+	return 0;
+}
+
 /*
  * If mpol_dup() sees current->cpuset == cpuset_being_rebound, then it
  * rebinds the mempolicy its copying by calling mpol_rebind_policy()
diff --git a/mm/mmap.c b/mm/mmap.c
index 7a1ba76..d8a310b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2481,7 +2481,6 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
 static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
 {
-	struct mempolicy *pol;
 	struct vm_area_struct *new;
 	int err = -ENOMEM;
 
@@ -2505,12 +2504,9 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
-	pol = mpol_dup(vma_policy(vma));
-	if (IS_ERR(pol)) {
-		err = PTR_ERR(pol);
+	err = vma_dup_policy(vma, new);
+	if (err)
 		goto out_free_vma;
-	}
-	vma_set_policy(new, pol);
 
 	if (anon_vma_clone(new, vma))
 		goto out_free_mpol;
@@ -2538,7 +2534,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 		fput(new->vm_file);
 	unlink_anon_vmas(new);
  out_free_mpol:
-	mpol_put(pol);
+	mpol_put(vma_policy(new));
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
  out_err:
@@ -2881,7 +2877,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
-	struct mempolicy *pol;
 	bool faulted_in_anon_vma = true;
 
 	/*
@@ -2926,10 +2921,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			pol = mpol_dup(vma_policy(vma));
-			if (IS_ERR(pol))
+			if (vma_dup_policy(vma, new_vma))
 				goto out_free_vma;
-			vma_set_policy(new_vma, pol);
 			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
 			if (anon_vma_clone(new_vma, vma))
 				goto out_free_mempol;
@@ -2944,7 +2937,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	return new_vma;
 
  out_free_mempol:
-	mpol_put(pol);
+	mpol_put(vma_policy(new_vma));
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
 	return NULL;
-- 
1.5.5.1


