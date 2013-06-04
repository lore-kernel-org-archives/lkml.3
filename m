Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab3FDWl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35331 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab3FDWly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:54 -0400
Message-Id: <20130604172131.969168887@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 040/184] mempolicy: fix a race in shared_policy_replace()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit b22d127a39ddd10d93deee3d96e643657ad53a49 upstream.

shared_policy_replace() use of sp_alloc() is unsafe.  1) sp_node cannot
be dereferenced if sp->lock is not held and 2) another thread can modify
sp_node between spin_unlock for allocating a new sp node and next
spin_lock.  The bug was introduced before 2.6.12-rc2.

Kosaki's original patch for this problem was to allocate an sp node and
policy within shared_policy_replace and initialise it when the lock is
reacquired.  I was not keen on this approach because it partially
duplicates sp_alloc().  As the paths were sp->lock is taken are not that
performance critical this patch converts sp->lock to sp->mutex so it can
sleep when calling sp_alloc().

[kosaki.motohiro@jp.fujitsu.com: Original patch]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/mempolicy.h |  2 +-
 mm/mempolicy.c            | 37 ++++++++++++++++---------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 085c903..e68b592 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -180,7 +180,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
-	spinlock_t lock;
+	struct mutex mutex;
 };
 
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a6563fb..df6602f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1759,7 +1759,7 @@ int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->lock */
+/* Caller holds sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -1823,13 +1823,13 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 
 	if (!sp->root.rb_node)
 		return NULL;
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	spin_unlock(&sp->lock);
+	mutex_unlock(&sp->mutex);
 	return pol;
 }
 
@@ -1860,10 +1860,10 @@ static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
 static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 				 unsigned long end, struct sp_node *new)
 {
-	struct sp_node *n, *new2 = NULL;
+	struct sp_node *n;
+	int ret = 0;
 
-restart:
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	n = sp_lookup(sp, start, end);
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {
@@ -1876,16 +1876,14 @@ restart:
 		} else {
 			/* Old policy spanning whole new range. */
 			if (n->end > end) {
+				struct sp_node *new2;
+				new2 = sp_alloc(end, n->end, n->policy);
 				if (!new2) {
-					spin_unlock(&sp->lock);
-					new2 = sp_alloc(end, n->end, n->policy);
-					if (!new2)
-						return -ENOMEM;
-					goto restart;
+					ret = -ENOMEM;
+					goto out;
 				}
 				n->end = start;
 				sp_insert(sp, new2);
-				new2 = NULL;
 				break;
 			} else
 				n->end = start;
@@ -1896,12 +1894,9 @@ restart:
 	}
 	if (new)
 		sp_insert(sp, new);
-	spin_unlock(&sp->lock);
-	if (new2) {
-		mpol_put(new2->policy);
-		kmem_cache_free(sn_cache, new2);
-	}
-	return 0;
+out:
+	mutex_unlock(&sp->mutex);
+	return ret;
 }
 
 /**
@@ -1919,7 +1914,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
-	spin_lock_init(&sp->lock);
+	mutex_init(&sp->mutex);
 
 	if (mpol) {
 		struct vm_area_struct pvma;
@@ -1987,7 +1982,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 
 	if (!p->root.rb_node)
 		return;
-	spin_lock(&p->lock);
+	mutex_lock(&p->mutex);
 	next = rb_first(&p->root);
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
@@ -1996,7 +1991,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 		mpol_put(n->policy);
 		kmem_cache_free(sn_cache, n);
 	}
-	spin_unlock(&p->lock);
+	mutex_unlock(&p->mutex);
 }
 
 /* assumes fs == KERNEL_DS */
-- 
1.7.12.2.21.g234cd45.dirty



