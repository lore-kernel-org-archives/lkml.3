Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3BCBXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:23:41 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:48099 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3BCBXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:18 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 62/62] idr: deprecate idr_pre_get() and idr_get_new[_above]()
Date: Sat,  2 Feb 2013 17:21:03 -0800
Message-Id: <1359854463-2538-63-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all in-kernel users are converted to ues the new alloc
interface, mark the old interface deprecated.  We should be able to
remove these in a few releases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 include/linux/idr.h | 66 ++++++++++++++++++++++++++++++++++++++++-------------
 lib/idr.c           | 41 ++++-----------------------------
 2 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 8d3ffe1..5ee5385 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -92,8 +92,6 @@ struct idr {
  */
 
 void *idr_find(struct idr *idp, int id);
-int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 void idr_preload(gfp_t gfp_mask);
 int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
@@ -117,19 +115,6 @@ static inline void idr_preload_end(void)
 }
 
 /**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * Simple wrapper around idr_get_new_above() w/ @starting_id of zero.
- */
-static inline int idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	return idr_get_new_above(idp, ptr, 0, id);
-}
-
-/**
  * idr_for_each_entry - iterate over an idr's elements of a given type
  * @idp:     idr handle
  * @entry:   the type * to use as cursor
@@ -140,7 +125,56 @@ static inline int idr_get_new(struct idr *idp, void *ptr, int *id)
 	     entry != NULL;                                             \
 	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
 
-void __idr_remove_all(struct idr *idp);	/* don't use */
+/*
+ * Don't use the following functions.  These exist only to suppress
+ * deprecated warnings on EXPORT_SYMBOL()s.
+ */
+int __idr_pre_get(struct idr *idp, gfp_t gfp_mask);
+int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+void __idr_remove_all(struct idr *idp);
+
+/**
+ * idr_pre_get - reserve resources for idr allocation
+ * @idp:	idr handle
+ * @gfp_mask:	memory allocation flags
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_pre_get(struct idr *idp, gfp_t gfp_mask)
+{
+	return __idr_pre_get(idp, gfp_mask);
+}
+
+/**
+ * idr_get_new_above - allocate new idr entry above or equal to a start id
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @starting_id: id to start search at
+ * @id: pointer to the allocated handle
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_get_new_above(struct idr *idp, void *ptr,
+						 int starting_id, int *id)
+{
+	return __idr_get_new_above(idp, ptr, starting_id, id);
+}
+
+/**
+ * idr_get_new - allocate new idr entry
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @id: pointer to the allocated handle
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_get_new(struct idr *idp, void *ptr, int *id)
+{
+	return __idr_get_new_above(idp, ptr, 0, id);
+}
 
 /**
  * idr_remove_all - remove all ids from the given idr tree
diff --git a/lib/idr.c b/lib/idr.c
index 9f8b3e6..94ad36d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -153,20 +153,7 @@ static void idr_mark_full(struct idr_layer **pa, int id)
 	}
 }
 
-/**
- * idr_pre_get - reserve resources for idr allocation
- * @idp:	idr handle
- * @gfp_mask:	memory allocation flags
- *
- * This function should be called prior to calling the idr_get_new* functions.
- * It preallocates enough memory to satisfy the worst possible allocation. The
- * caller should pass in GFP_KERNEL if possible.  This of course requires that
- * no spinning locks be held.
- *
- * If the system is REALLY out of memory this function returns %0,
- * otherwise %1.
- */
-int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
+int __idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
 	while (idp->id_free_cnt < MAX_IDR_FREE) {
 		struct idr_layer *new;
@@ -177,7 +164,7 @@ int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 	}
 	return 1;
 }
-EXPORT_SYMBOL(idr_pre_get);
+EXPORT_SYMBOL(__idr_pre_get);
 
 /**
  * sub_alloc - try to allocate an id without growing the tree depth
@@ -339,25 +326,7 @@ static void idr_fill_slot(void *ptr, int id, struct idr_layer **pa)
 	idr_mark_full(pa, id);
 }
 
-/**
- * idr_get_new_above - allocate new idr entry above or equal to a start id
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @starting_id: id to start search at
- * @id: pointer to the allocated handle
- *
- * This is the allocate id function.  It should be called with any
- * required locks.
- *
- * If allocation from IDR's private freelist fails, idr_get_new_above() will
- * return %-EAGAIN.  The caller should retry the idr_pre_get() call to refill
- * IDR's preallocation and then retry the idr_get_new_above() call.
- *
- * If the idr is full idr_get_new_above() will return %-ENOSPC.
- *
- * @id returns a value in the range @starting_id ... %0x7fffffff
- */
-int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
+int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
 	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int rv;
@@ -370,7 +339,7 @@ int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 	*id = rv;
 	return 0;
 }
-EXPORT_SYMBOL(idr_get_new_above);
+EXPORT_SYMBOL(__idr_get_new_above);
 
 /**
  * idr_preload - preload for idr_alloc()
@@ -877,7 +846,7 @@ static void free_bitmap(struct ida *ida, struct ida_bitmap *bitmap)
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
 	/* allocate idr_layers */
-	if (!idr_pre_get(&ida->idr, gfp_mask))
+	if (!__idr_pre_get(&ida->idr, gfp_mask))
 		return 0;
 
 	/* allocate free_bitmap */
-- 
1.8.1

