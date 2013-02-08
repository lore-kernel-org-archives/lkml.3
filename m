Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947155Ab3BHVEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:04:09 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:46868 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947103Ab3BHVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:04:07 -0500
Date: Fri, 8 Feb 2013 13:03:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/6] idr: implement lookup hint
Message-ID: <20130208210358.GF26660@mtj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208210050.GA26660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While idr lookup isn't a particularly heavy operation, it still is too
substantial to use in hot paths without worrying about the performance
implications.  With recent changes, each idr_layer covers 256 slots
which should be enough to cover most use cases with single idr_layer
making lookup hint very attractive.

This patch adds idr->hint which points to the idr_layer which
allocated an ID most recently and the fast path lookup becomes

	if (look up target's prefix matches that of the hinted layer)
		return hint->ary[ID's offset in the leaf layer];

which can be inlined.

idr->hint is set to the leaf node on idr_fill_slot() and cleared from
free_layer().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |   25 ++++++++++++++++++++++++-
 lib/idr.c           |   38 ++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 23 deletions(-)

--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -37,6 +37,7 @@ struct idr_layer {
 };
 
 struct idr {
+	struct idr_layer __rcu	*hint;	/* the last layer allocated from */
 	struct idr_layer __rcu	*top;
 	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
@@ -71,7 +72,7 @@ struct idr {
  * This is what we export.
  */
 
-void *idr_find(struct idr *idp, int id);
+void *idr_find_slowpath(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 void idr_preload(gfp_t gfp_mask);
@@ -97,6 +98,28 @@ static inline void idr_preload_end(void)
 }
 
 /**
+ * idr_find - return pointer for given id
+ * @idp: idr handle
+ * @id: lookup key
+ *
+ * Return the pointer given the id it has been registered with.  A %NULL
+ * return indicates that @id is not valid or you passed %NULL in
+ * idr_get_new().
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
+ */
+static inline void *idr_find(struct idr *idr, int id)
+{
+	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
+
+	if ((id & ~IDR_MASK) == hint->prefix)
+		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
+
+	return idr_find_slowpath(idr, id);
+}
+
+/**
  * idr_get_new - allocate new idr entry
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -137,8 +137,10 @@ static void idr_layer_rcu_free(struct rc
 	kmem_cache_free(idr_layer_cache, layer);
 }
 
-static inline void free_layer(struct idr_layer *p)
+static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
+	if (idr->hint == p)
+		RCU_INIT_POINTER(idr->hint, NULL);
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
 
@@ -363,8 +365,12 @@ build_up:
  * @id and @pa are from a successful allocation from idr_get_empty_slot().
  * Install the user pointer @ptr and mark the slot full.
  */
-static void idr_fill_slot(void *ptr, int id, struct idr_layer **pa)
+static void idr_fill_slot(struct idr *idr, void *ptr, int id,
+			  struct idr_layer **pa)
 {
+	/* update hint used for lookup, cleared from free_layer() */
+	rcu_assign_pointer(idr->hint, pa[0]);
+
 	rcu_assign_pointer(pa[0]->ary[id & IDR_MASK], (struct idr_layer *)ptr);
 	pa[0]->count++;
 	idr_mark_full(pa, id);
@@ -397,7 +403,7 @@ int idr_get_new_above(struct idr *idp, v
 	if (rv < 0)
 		return rv == -ENOMEM ? -EAGAIN : rv;
 
-	idr_fill_slot(ptr, rv, pa);
+	idr_fill_slot(idp, ptr, rv, pa);
 	*id = rv;
 	return 0;
 }
@@ -501,7 +507,7 @@ int idr_alloc(struct idr *idr, void *ptr
 	if (unlikely(id > max))
 		return -ENOSPC;
 
-	idr_fill_slot(ptr, id, pa);
+	idr_fill_slot(idr, ptr, id, pa);
 	return id;
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
@@ -538,14 +544,14 @@ static void sub_remove(struct idr *idp,
 		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
 			if (to_free)
-				free_layer(to_free);
+				free_layer(idp, to_free);
 			to_free = **paa;
 			**paa-- = NULL;
 		}
 		if (!*paa)
 			idp->layers = 0;
 		if (to_free)
-			free_layer(to_free);
+			free_layer(idp, to_free);
 	} else
 		idr_remove_warning(id);
 }
@@ -578,7 +584,7 @@ void idr_remove(struct idr *idp, int id)
 		--idp->layers;
 		to_free->count = 0;
 		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
-		free_layer(to_free);
+		free_layer(idp, to_free);
 	}
 	while (idp->id_free_cnt >= MAX_IDR_FREE) {
 		p = get_from_free_list(idp);
@@ -619,7 +625,7 @@ void __idr_remove_all(struct idr *idp)
 		/* Get the highest bit that the above add changed from 0->1. */
 		while (n < fls(id ^ bt_mask)) {
 			if (p)
-				free_layer(p);
+				free_layer(idp, p);
 			n += IDR_BITS;
 			p = *--paa;
 		}
@@ -652,19 +658,7 @@ void idr_destroy(struct idr *idp)
 }
 EXPORT_SYMBOL(idr_destroy);
 
-/**
- * idr_find - return pointer for given id
- * @idp: idr handle
- * @id: lookup key
- *
- * Return the pointer given the id it has been registered with.  A %NULL
- * return indicates that @id is not valid or you passed %NULL in
- * idr_get_new().
- *
- * This function can be called under rcu_read_lock(), given that the leaf
- * pointers lifetimes are correctly managed.
- */
-void *idr_find(struct idr *idp, int id)
+void *idr_find_slowpath(struct idr *idp, int id)
 {
 	int n;
 	struct idr_layer *p;
@@ -688,7 +682,7 @@ void *idr_find(struct idr *idp, int id)
 	}
 	return((void *)p);
 }
-EXPORT_SYMBOL(idr_find);
+EXPORT_SYMBOL(idr_find_slowpath);
 
 /**
  * idr_for_each - iterate through all stored pointers
