Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3BFUIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:08:40 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:49752 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab3BFTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:49 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/77] idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()
Date: Wed,  6 Feb 2013 11:39:49 -0800
Message-Id: <1360179649-22465-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move idr_for_each_entry() definition next to other idr related
  definitions.

* Make id[r|a]_get_new() inline wrappers of id[r|a]_get_new_above().

This changes the implementation of idr_get_new() but the new
implementation is trivial.  This patch doesn't introduce any
functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h | 47 +++++++++++++++++++++++++++++++++++------------
 lib/idr.c           | 49 -------------------------------------------------
 2 files changed, 35 insertions(+), 61 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index c78c26d..7c0700c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -99,7 +99,6 @@ struct idr {
 
 void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int idr_get_new(struct idr *idp, void *ptr, int *id);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
@@ -109,6 +108,30 @@ void idr_remove(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+/**
+ * idr_get_new - allocate new idr entry
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @id: pointer to the allocated handle
+ *
+ * Simple wrapper around idr_get_new_above() w/ @starting_id of zero.
+ */
+static inline int idr_get_new(struct idr *idp, void *ptr, int *id)
+{
+	return idr_get_new_above(idp, ptr, 0, id);
+}
+
+/**
+ * idr_for_each_entry - iterate over an idr's elements of a given type
+ * @idp:     idr handle
+ * @entry:   the type * to use as cursor
+ * @id:      id entry's key
+ */
+#define idr_for_each_entry(idp, entry, id)				\
+	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
+	     entry != NULL;                                             \
+	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+
 void __idr_remove_all(struct idr *idp);	/* don't use */
 
 /**
@@ -149,7 +172,6 @@ struct ida {
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id);
-int ida_get_new(struct ida *ida, int *p_id);
 void ida_remove(struct ida *ida, int id);
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
@@ -158,17 +180,18 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask);
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
-void __init idr_init_cache(void);
-
 /**
- * idr_for_each_entry - iterate over an idr's elements of a given type
- * @idp:     idr handle
- * @entry:   the type * to use as cursor
- * @id:      id entry's key
+ * ida_get_new - allocate new ID
+ * @ida:	idr handle
+ * @p_id:	pointer to the allocated handle
+ *
+ * Simple wrapper around ida_get_new_above() w/ @starting_id of zero.
  */
-#define idr_for_each_entry(idp, entry, id)				\
-	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
-	     entry != NULL;                                             \
-	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+static inline int ida_get_new(struct ida *ida, int *p_id)
+{
+	return ida_get_new_above(ida, 0, p_id);
+}
+
+void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index 814c53c..282841b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -317,36 +317,6 @@ int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 }
 EXPORT_SYMBOL(idr_get_new_above);
 
-/**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * If allocation from IDR's private freelist fails, idr_get_new_above() will
- * return %-EAGAIN.  The caller should retry the idr_pre_get() call to refill
- * IDR's preallocation and then retry the idr_get_new_above() call.
- *
- * If the idr is full idr_get_new_above() will return %-ENOSPC.
- *
- * @id returns a value in the range %0 ... %0x7fffffff
- */
-int idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	int rv;
-
-	rv = idr_get_new_above_int(idp, ptr, 0);
-	/*
-	 * This is a cheap hack until the IDR code can be fixed to
-	 * return proper error values.
-	 */
-	if (rv < 0)
-		return _idr_rc_to_errno(rv);
-	*id = rv;
-	return 0;
-}
-EXPORT_SYMBOL(idr_get_new);
-
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
@@ -857,25 +827,6 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 EXPORT_SYMBOL(ida_get_new_above);
 
 /**
- * ida_get_new - allocate new ID
- * @ida:	idr handle
- * @p_id:	pointer to the allocated handle
- *
- * Allocate new ID.  It should be called with any required locks.
- *
- * If memory is required, it will return %-EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return %-ENOSPC.
- *
- * @p_id returns a value in the range %0 ... %0x7fffffff.
- */
-int ida_get_new(struct ida *ida, int *p_id)
-{
-	return ida_get_new_above(ida, 0, p_id);
-}
-EXPORT_SYMBOL(ida_get_new);
-
-/**
  * ida_remove - remove the given ID
  * @ida:	ida handle
  * @id:		ID to free
-- 
1.8.1

