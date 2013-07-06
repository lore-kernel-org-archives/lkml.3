Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3GFFIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:08:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43814 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3GFFIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:08:43 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, nab@linux-iscsi.org, axboe@kernel.dk,
        Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 05/10] idr: Kill old deprecated idr interfaces
Date: Fri,  5 Jul 2013 22:08:16 -0700
Message-Id: <1373087301-23730-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

The deprecated idr interfaces don't have any in kernel users, so let's
delete them as prep work for the idr rewrite.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/idr.h | 63 -----------------------------------------------------
 lib/idr.c           | 36 +++---------------------------
 2 files changed, 3 insertions(+), 96 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index f5b889b..b26f8b1 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -264,69 +264,6 @@ static inline void *idr_find(struct idr *idr, int id)
 #define idr_for_each_entry(idp, entry, id)			\
 	for (id = 0; ((entry) = idr_get_next(idp, &(id))) != NULL; ++id)
 
-/*
- * Don't use the following functions.  These exist only to suppress
- * deprecated warnings on EXPORT_SYMBOL()s.
- */
-int __idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
-void __idr_remove_all(struct idr *idp);
-
-/**
- * idr_pre_get - reserve resources for idr allocation
- * @idp:	idr handle
- * @gfp_mask:	memory allocation flags
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_pre_get(struct idr *idp, gfp_t gfp_mask)
-{
-	return __idr_pre_get(idp, gfp_mask);
-}
-
-/**
- * idr_get_new_above - allocate new idr entry above or equal to a start id
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @starting_id: id to start search at
- * @id: pointer to the allocated handle
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_get_new_above(struct idr *idp, void *ptr,
-						 int starting_id, int *id)
-{
-	return __idr_get_new_above(idp, ptr, starting_id, id);
-}
-
-/**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	return __idr_get_new_above(idp, ptr, 0, id);
-}
-
-/**
- * idr_remove_all - remove all ids from the given idr tree
- * @idp: idr handle
- *
- * If you're trying to destroy @idp, calling idr_destroy() is enough.
- * This is going away.  Don't use.
- */
-static inline void __deprecated idr_remove_all(struct idr *idp)
-{
-	__idr_remove_all(idp);
-}
-
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index 0278e79..f7ba96b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1070,19 +1070,6 @@ static void idr_mark_full(struct idr_layer **pa, int id)
 	}
 }
 
-int __idr_pre_get(struct idr *idp, gfp_t gfp_mask)
-{
-	while (idp->id_free_cnt < MAX_IDR_FREE) {
-		struct idr_layer *new;
-		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
-		if (new == NULL)
-			return (0);
-		move_to_free_list(idp, new);
-	}
-	return 1;
-}
-EXPORT_SYMBOL(__idr_pre_get);
-
 /**
  * sub_alloc - try to allocate an id without growing the tree depth
  * @idp: idr handle
@@ -1248,21 +1235,6 @@ static void idr_fill_slot(struct idr *idr, void *ptr, int id,
 	idr_mark_full(pa, id);
 }
 
-int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
-{
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	int rv;
-
-	rv = idr_get_empty_slot(idp, starting_id, pa, 0, idp);
-	if (rv < 0)
-		return rv == -ENOMEM ? -EAGAIN : rv;
-
-	idr_fill_slot(idp, ptr, rv, pa);
-	*id = rv;
-	return 0;
-}
-EXPORT_SYMBOL(__idr_get_new_above);
-
 /**
  * idr_preload - preload for idr_alloc()
  * @gfp_mask: allocation mask to use for preloading
@@ -1483,7 +1455,7 @@ void idr_remove(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_remove);
 
-void __idr_remove_all(struct idr *idp)
+static void __idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
 	int bt_mask;
@@ -1516,7 +1488,6 @@ void __idr_remove_all(struct idr *idp)
 	}
 	idp->layers = 0;
 }
-EXPORT_SYMBOL(__idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
@@ -1578,13 +1549,12 @@ EXPORT_SYMBOL(idr_find_slowpath);
  * callback function will be called for each pointer currently
  * registered, passing the id, the pointer and the data pointer passed
  * to this function.  It is not safe to modify the idr tree while in
- * the callback, so functions such as idr_get_new and idr_remove are
- * not allowed.
+ * the callback, so functions such as idr_remove are not allowed.
  *
  * We check the return of @fn each time. If it returns anything other
  * than %0, we break out and return that value.
  *
- * The caller must serialize idr_for_each() vs idr_get_new() and idr_remove().
+ * The caller must serialize idr_for_each() vs idr_remove().
  */
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data)
-- 
1.8.3.2

