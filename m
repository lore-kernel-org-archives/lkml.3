Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3GVQLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49745 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3GVQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:35 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 21/48] staging/lustre/obdclass: use a dummy structure for lu_ref_link
Date: Tue, 23 Jul 2013 00:06:42 +0800
Message-Id: <1374509230-3324-22-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Move the definition of struct lu_ref_link to lu_ref.h.  If USE_LU_REF
is not defined then define it to be the empty struct.  Change the
return type of lu_ref_add() and lu_ref_add_atomic() to void.  Add
lu_ref_add_at() taking same arguments as lu_ref_add() togerther with a
pointer to a struct lu_ref_link and returning void.  Adjust all
structures containing a lu_ref_link pointer to contain a struct
lu_ref_link instead.  Use lu_ref_add_at() and lu_ref_del_at() to
handle embedded lu_ref_links.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3059
Lustre-change: http://review.whamcloud.com/5920
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/cl_object.h  |   10 +--
 drivers/staging/lustre/lustre/include/lu_object.h  |   18 +++--
 drivers/staging/lustre/lustre/include/lu_ref.h     |   77 ++++++++++++--------
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   17 +++--
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    6 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    5 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   15 ++--
 drivers/staging/lustre/lustre/obdclass/lu_ref.c    |   74 +++++++++----------
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    8 +-
 9 files changed, 130 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index 4bb6880..4a47850 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -768,11 +768,11 @@ struct cl_page {
 	/** List of references to this page, for debugging. */
 	struct lu_ref	    cp_reference;
 	/** Link to an object, for debugging. */
-	struct lu_ref_link      *cp_obj_ref;
+	struct lu_ref_link       cp_obj_ref;
 	/** Link to a queue, for debugging. */
-	struct lu_ref_link      *cp_queue_ref;
+	struct lu_ref_link       cp_queue_ref;
 	/** Per-page flags from enum cl_page_flags. Protected by a VM lock. */
-	unsigned		 cp_flags;
+	unsigned                 cp_flags;
 	/** Assigned if doing a sync_io */
 	struct cl_sync_io       *cp_sync_io;
 };
@@ -1625,7 +1625,7 @@ struct cl_lock {
 	/**
 	 * A reference for cl_lock::cll_descr::cld_obj. For debugging.
 	 */
-	struct lu_ref_link   *cll_obj_ref;
+	struct lu_ref_link    cll_obj_ref;
 #ifdef CONFIG_LOCKDEP
 	/* "dep_map" name is assumed by lockdep.h macros. */
 	struct lockdep_map    dep_map;
@@ -2517,7 +2517,7 @@ struct cl_req_obj {
 	/** object itself */
 	struct cl_object   *ro_obj;
 	/** reference to cl_req_obj::ro_obj. For debugging. */
-	struct lu_ref_link *ro_obj_ref;
+	struct lu_ref_link  ro_obj_ref;
 	/* something else? Number of pages for a given object? */
 };
 
diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index d40ad81..f0d6fb1 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -496,7 +496,7 @@ struct lu_object {
 	/**
 	 * Link to the device, for debugging.
 	 */
-	struct lu_ref_link		*lo_dev_ref;
+	struct lu_ref_link                 lo_dev_ref;
 };
 
 enum lu_object_header_flags {
@@ -868,11 +868,19 @@ static inline __u32 lu_object_attr(const struct lu_object *o)
 	return o->lo_header->loh_attr;
 }
 
-static inline struct lu_ref_link *lu_object_ref_add(struct lu_object *o,
-						    const char *scope,
-						    const void *source)
+static inline void lu_object_ref_add(struct lu_object *o,
+				     const char *scope,
+				     const void *source)
 {
-	return lu_ref_add(&o->lo_header->loh_reference, scope, source);
+	lu_ref_add(&o->lo_header->loh_reference, scope, source);
+}
+
+static inline void lu_object_ref_add_at(struct lu_object *o,
+					struct lu_ref_link *link,
+					const char *scope,
+					const void *source)
+{
+	lu_ref_add_at(&o->lo_header->loh_reference, link, scope, source);
 }
 
 static inline void lu_object_ref_del(struct lu_object *o,
diff --git a/drivers/staging/lustre/lustre/include/lu_ref.h b/drivers/staging/lustre/lustre/include/lu_ref.h
index adfbf51..3b0b483 100644
--- a/drivers/staging/lustre/lustre/include/lu_ref.h
+++ b/drivers/staging/lustre/lustre/include/lu_ref.h
@@ -109,9 +109,6 @@
 
 #ifdef CONFIG_LUSTRE_DEBUG_LU_REF_CHECK
 
-/* An incomplete type (defined locally in lu_ref.c) */
-struct lu_ref_link;
-
 /**
  * Data-structure to keep track of references to a given object. This is used
  * for debugging.
@@ -153,31 +150,48 @@ struct lu_ref {
 	struct list_head           lf_linkage;
 };
 
-int lu_ref_global_init(void);
-void lu_ref_global_fini(void);
+struct lu_ref_link {
+	struct lu_ref	*ll_ref;
+	struct list_head	 ll_linkage;
+	const char	*ll_scope;
+	const void	*ll_source;
+};
+
 void lu_ref_init_loc(struct lu_ref *ref, const char *func, const int line);
 void lu_ref_fini    (struct lu_ref *ref);
 #define lu_ref_init(ref) lu_ref_init_loc(ref, __FUNCTION__, __LINE__)
 
-struct lu_ref_link *lu_ref_add       (struct lu_ref *ref, const char *scope,
-				      const void *source);
-struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
-				      const void *source);
-void lu_ref_del                      (struct lu_ref *ref, const char *scope,
-				      const void *source);
-void lu_ref_set_at                   (struct lu_ref *ref,
-				      struct lu_ref_link *link,
-				      const char *scope, const void *source0,
-				      const void *source1);
-void lu_ref_del_at                   (struct lu_ref *ref,
-				      struct lu_ref_link *link,
-				      const char *scope, const void *source);
-void lu_ref_print                    (const struct lu_ref *ref);
-void lu_ref_print_all                (void);
+void lu_ref_add(struct lu_ref *ref, const char *scope, const void *source);
+
+void lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
+		       const void *source);
+
+void lu_ref_add_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope, const void *source);
+
+void lu_ref_del(struct lu_ref *ref, const char *scope, const void *source);
+
+void lu_ref_set_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope, const void *source0, const void *source1);
+
+void lu_ref_del_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope, const void *source);
+
+void lu_ref_print(const struct lu_ref *ref);
+
+void lu_ref_print_all(void);
+
+int lu_ref_global_init(void);
+
+void lu_ref_global_fini(void);
 
 #else /* !CONFIG_LUSTRE_DEBUG_LU_REF_CHECK */
 
-struct lu_ref  {};
+struct lu_ref {
+};
+
+struct lu_ref_link {
+};
 
 static inline void lu_ref_init(struct lu_ref *ref)
 {
@@ -187,18 +201,23 @@ static inline void lu_ref_fini(struct lu_ref *ref)
 {
 }
 
-static inline struct lu_ref_link *lu_ref_add(struct lu_ref *ref,
-					     const char *scope,
-					     const void *source)
+static inline void lu_ref_add(struct lu_ref *ref,
+			      const char *scope,
+			      const void *source)
+{
+}
+
+static inline void lu_ref_add_atomic(struct lu_ref *ref,
+				     const char *scope,
+				     const void *source)
 {
-	return NULL;
 }
 
-static inline struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref,
-						    const char *scope,
-						    const void *source)
+static inline void lu_ref_add_at(struct lu_ref *ref,
+				 struct lu_ref_link *link,
+				 const char *scope,
+				 const void *source)
 {
-	return NULL;
 }
 
 static inline void lu_ref_del(struct lu_ref *ref, const char *scope,
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index 75c9be8..f3f0315 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -1105,7 +1105,7 @@ void cl_page_list_add(struct cl_page_list *plist, struct cl_page *page)
 	LASSERT(list_empty(&page->cp_batch));
 	list_add_tail(&page->cp_batch, &plist->pl_pages);
 	++plist->pl_nr;
-	page->cp_queue_ref = lu_ref_add(&page->cp_reference, "queue", plist);
+	lu_ref_add_at(&page->cp_reference, &page->cp_queue_ref, "queue", plist);
 	cl_page_get(page);
 	EXIT;
 }
@@ -1126,7 +1126,7 @@ void cl_page_list_del(const struct lu_env *env,
 	mutex_unlock(&page->cp_mutex);
 	lockdep_on();
 	--plist->pl_nr;
-	lu_ref_del_at(&page->cp_reference, page->cp_queue_ref, "queue", plist);
+	lu_ref_del_at(&page->cp_reference, &page->cp_queue_ref, "queue", plist);
 	cl_page_put(env, page);
 	EXIT;
 }
@@ -1146,8 +1146,8 @@ void cl_page_list_move(struct cl_page_list *dst, struct cl_page_list *src,
 	list_move_tail(&page->cp_batch, &dst->pl_pages);
 	--src->pl_nr;
 	++dst->pl_nr;
-	lu_ref_set_at(&page->cp_reference,
-		      page->cp_queue_ref, "queue", src, dst);
+	lu_ref_set_at(&page->cp_reference, &page->cp_queue_ref, "queue",
+		      src, dst);
 	EXIT;
 }
 EXPORT_SYMBOL(cl_page_list_move);
@@ -1202,7 +1202,8 @@ void cl_page_list_disown(const struct lu_env *env,
 		 * XXX cl_page_disown0() will fail if page is not locked.
 		 */
 		cl_page_disown0(env, io, page);
-		lu_ref_del(&page->cp_reference, "queue", plist);
+		lu_ref_del_at(&page->cp_reference, &page->cp_queue_ref, "queue",
+			      plist);
 		cl_page_put(env, page);
 	}
 	EXIT;
@@ -1449,7 +1450,7 @@ static void cl_req_free(const struct lu_env *env, struct cl_req *req)
 			struct cl_object *obj = req->crq_o[i].ro_obj;
 			if (obj != NULL) {
 				lu_object_ref_del_at(&obj->co_lu,
-						     req->crq_o[i].ro_obj_ref,
+						     &req->crq_o[i].ro_obj_ref,
 						     "cl_req", req);
 				cl_object_put(env, obj);
 			}
@@ -1570,8 +1571,8 @@ void cl_req_page_add(const struct lu_env *env,
 		if (rqo->ro_obj == NULL) {
 			rqo->ro_obj = obj;
 			cl_object_get(obj);
-			rqo->ro_obj_ref = lu_object_ref_add(&obj->co_lu,
-							    "cl_req", req);
+			lu_object_ref_add_at(&obj->co_lu, &rqo->ro_obj_ref,
+					     "cl_req", req);
 			break;
 		}
 	}
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index d34e044..958c1e5 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -267,7 +267,7 @@ static void cl_lock_free(const struct lu_env *env, struct cl_lock *lock)
 	}
 	CS_LOCK_DEC(obj, total);
 	CS_LOCKSTATE_DEC(obj, lock->cll_state);
-	lu_object_ref_del_at(&obj->co_lu, lock->cll_obj_ref, "cl_lock", lock);
+	lu_object_ref_del_at(&obj->co_lu, &lock->cll_obj_ref, "cl_lock", lock);
 	cl_object_put(env, obj);
 	lu_ref_fini(&lock->cll_reference);
 	lu_ref_fini(&lock->cll_holders);
@@ -373,8 +373,8 @@ static struct cl_lock *cl_lock_alloc(const struct lu_env *env,
 		lock->cll_descr = *descr;
 		lock->cll_state = CLS_NEW;
 		cl_object_get(obj);
-		lock->cll_obj_ref = lu_object_ref_add(&obj->co_lu,
-						      "cl_lock", lock);
+		lu_object_ref_add_at(&obj->co_lu, &lock->cll_obj_ref, "cl_lock",
+				     lock);
 		INIT_LIST_HEAD(&lock->cll_layers);
 		INIT_LIST_HEAD(&lock->cll_linkage);
 		INIT_LIST_HEAD(&lock->cll_inclosure);
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_page.c b/drivers/staging/lustre/lustre/obdclass/cl_page.c
index bb93359..d9ca5d5 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -270,7 +270,7 @@ static void cl_page_free(const struct lu_env *env, struct cl_page *page)
 	}
 	CS_PAGE_DEC(obj, total);
 	CS_PAGESTATE_DEC(obj, page->cp_state);
-	lu_object_ref_del_at(&obj->co_lu, page->cp_obj_ref, "cl_page", page);
+	lu_object_ref_del_at(&obj->co_lu, &page->cp_obj_ref, "cl_page", page);
 	cl_object_put(env, obj);
 	lu_ref_fini(&page->cp_reference);
 	OBD_FREE(page, pagesize);
@@ -305,7 +305,8 @@ static struct cl_page *cl_page_alloc(const struct lu_env *env,
 			atomic_inc(&page->cp_ref);
 		page->cp_obj = o;
 		cl_object_get(o);
-		page->cp_obj_ref = lu_object_ref_add(&o->co_lu, "cl_page",page);
+		lu_object_ref_add_at(&o->co_lu, &page->cp_obj_ref, "cl_page",
+				     page);
 		page->cp_index = ind;
 		cl_page_state_set_trust(page, CPS_CACHED);
 		page->cp_type = type;
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 5559732..2fb65f6 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -1147,15 +1147,16 @@ EXPORT_SYMBOL(lu_device_fini);
  * Initialize object \a o that is part of compound object \a h and was created
  * by device \a d.
  */
-int lu_object_init(struct lu_object *o,
-		   struct lu_object_header *h, struct lu_device *d)
+int lu_object_init(struct lu_object *o, struct lu_object_header *h,
+		   struct lu_device *d)
 {
-	memset(o, 0, sizeof *o);
+	memset(o, 0, sizeof(*o));
 	o->lo_header = h;
-	o->lo_dev    = d;
+	o->lo_dev = d;
 	lu_device_get(d);
-	o->lo_dev_ref = lu_ref_add(&d->ld_reference, "lu_object", o);
+	lu_ref_add_at(&d->ld_reference, &o->lo_dev_ref, "lu_object", o);
 	INIT_LIST_HEAD(&o->lo_linkage);
+
 	return 0;
 }
 EXPORT_SYMBOL(lu_object_init);
@@ -1170,8 +1171,8 @@ void lu_object_fini(struct lu_object *o)
 	LASSERT(list_empty(&o->lo_linkage));
 
 	if (dev != NULL) {
-		lu_ref_del_at(&dev->ld_reference,
-			      o->lo_dev_ref , "lu_object", o);
+		lu_ref_del_at(&dev->ld_reference, &o->lo_dev_ref,
+			      "lu_object", o);
 		lu_device_put(dev);
 		o->lo_dev = NULL;
 	}
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_ref.c b/drivers/staging/lustre/lustre/obdclass/lu_ref.c
index 79d25c5..b5f1bda 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_ref.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_ref.c
@@ -43,7 +43,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/gfp.h>
-#include <linux/libcfs.h>
+#include <linux/libcfs/libcfs.h>
 #include <obd.h>
 #include <obd_class.h>
 #include <obd_support.h>
@@ -65,13 +65,6 @@
 	}								\
 } while (0)
 
-struct lu_ref_link {
-	struct lu_ref    *ll_ref;
-	struct list_head        ll_linkage;
-	const char       *ll_scope;
-	const void       *ll_source;
-};
-
 static struct kmem_cache *lu_ref_link_kmem;
 
 static struct lu_kmem_descr lu_ref_caches[] = {
@@ -93,9 +86,9 @@ static struct lu_kmem_descr lu_ref_caches[] = {
 static LIST_HEAD(lu_ref_refs);
 static spinlock_t lu_ref_refs_guard;
 static struct lu_ref lu_ref_marker = {
-	.lf_guard   = __SPIN_LOCK_UNLOCKED(lu_ref_marker.lf_guard),
-	.lf_list    = LIST_HEAD_INIT(lu_ref_marker.lf_list),
-	.lf_linkage = LIST_HEAD_INIT(lu_ref_marker.lf_linkage)
+	.lf_guard	= __SPIN_LOCK_UNLOCKED(lu_ref_marker.lf_guard),
+	.lf_list	= LIST_HEAD_INIT(lu_ref_marker.lf_list),
+	.lf_linkage	= LIST_HEAD_INIT(lu_ref_marker.lf_linkage)
 };
 
 void lu_ref_print(const struct lu_ref *ref)
@@ -186,21 +179,33 @@ static struct lu_ref_link *lu_ref_add_context(struct lu_ref *ref,
 	return link;
 }
 
-struct lu_ref_link *lu_ref_add(struct lu_ref *ref, const char *scope,
-			       const void *source)
+void lu_ref_add(struct lu_ref *ref, const char *scope, const void *source)
 {
 	might_sleep();
-	return lu_ref_add_context(ref, GFP_IOFS, scope, source);
+	lu_ref_add_context(ref, GFP_IOFS, scope, source);
 }
 EXPORT_SYMBOL(lu_ref_add);
 
+void lu_ref_add_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope, const void *source)
+{
+	link->ll_ref = ref;
+	link->ll_scope = scope;
+	link->ll_source = source;
+	spin_lock(&ref->lf_guard);
+	list_add_tail(&link->ll_linkage, &ref->lf_list);
+	ref->lf_refs++;
+	spin_unlock(&ref->lf_guard);
+}
+EXPORT_SYMBOL(lu_ref_add_at);
+
 /**
  * Version of lu_ref_add() to be used in non-blockable contexts.
  */
-struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
-				      const void *source)
+void lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
+		       const void *source)
 {
-	return lu_ref_add_context(ref, GFP_ATOMIC, scope, source);
+	lu_ref_add_context(ref, GFP_ATOMIC, scope, source);
 }
 EXPORT_SYMBOL(lu_ref_add_atomic);
 
@@ -262,14 +267,12 @@ void lu_ref_set_at(struct lu_ref *ref, struct lu_ref_link *link,
 		   const char *scope,
 		   const void *source0, const void *source1)
 {
+	REFASSERT(ref, link != NULL && !IS_ERR(link));
+
 	spin_lock(&ref->lf_guard);
-	if (link != ERR_PTR(-ENOMEM)) {
-		REFASSERT(ref, link->ll_ref == ref);
-		REFASSERT(ref, lu_ref_link_eq(link, scope, source0));
-		link->ll_source = source1;
-	} else {
-		REFASSERT(ref, ref->lf_failed > 0);
-	}
+	REFASSERT(ref, link->ll_ref == ref);
+	REFASSERT(ref, lu_ref_link_eq(link, scope, source0));
+	link->ll_source = source1;
 	spin_unlock(&ref->lf_guard);
 }
 EXPORT_SYMBOL(lu_ref_set_at);
@@ -277,20 +280,13 @@ EXPORT_SYMBOL(lu_ref_set_at);
 void lu_ref_del_at(struct lu_ref *ref, struct lu_ref_link *link,
 		   const char *scope, const void *source)
 {
-	if (link != ERR_PTR(-ENOMEM)) {
-		spin_lock(&ref->lf_guard);
-		REFASSERT(ref, link->ll_ref == ref);
-		REFASSERT(ref, lu_ref_link_eq(link, scope, source));
-		list_del(&link->ll_linkage);
-		ref->lf_refs--;
-		spin_unlock(&ref->lf_guard);
-		OBD_SLAB_FREE(link, lu_ref_link_kmem, sizeof(*link));
-	} else {
-		spin_lock(&ref->lf_guard);
-		REFASSERT(ref, ref->lf_failed > 0);
-		ref->lf_failed--;
-		spin_unlock(&ref->lf_guard);
-	}
+	REFASSERT(ref, link != NULL && !IS_ERR(link));
+	spin_lock(&ref->lf_guard);
+	REFASSERT(ref, link->ll_ref == ref);
+	REFASSERT(ref, lu_ref_link_eq(link, scope, source));
+	list_del(&link->ll_linkage);
+	ref->lf_refs--;
+	spin_unlock(&ref->lf_guard);
 }
 EXPORT_SYMBOL(lu_ref_del_at);
 
@@ -418,6 +414,8 @@ static struct file_operations lu_ref_dump_fops = {
 	.release = lu_ref_seq_release
 };
 
+#endif
+
 int lu_ref_global_init(void)
 {
 	int result;
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 0a0ec6f..6b0a842 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -2064,7 +2064,7 @@ static void osc_check_rpcs(const struct lu_env *env, struct client_obd *cli,
 
 	while ((osc = osc_next_obj(cli)) != NULL) {
 		struct cl_object *obj = osc2cl(osc);
-		struct lu_ref_link *link;
+		struct lu_ref_link link;
 
 		OSC_IO_DEBUG(osc, "%lu in flight\n", rpcs_in_flight(cli));
 
@@ -2075,7 +2075,8 @@ static void osc_check_rpcs(const struct lu_env *env, struct client_obd *cli,
 
 		cl_object_get(obj);
 		client_obd_list_unlock(&cli->cl_loi_list_lock);
-		link = lu_object_ref_add(&obj->co_lu, "check", current);
+		lu_object_ref_add_at(&obj->co_lu, &link, "check",
+				     current);
 
 		/* attempt some read/write balancing by alternating between
 		 * reads and writes in an object.  The makes_rpc checks here
@@ -2116,7 +2117,8 @@ static void osc_check_rpcs(const struct lu_env *env, struct client_obd *cli,
 		osc_object_unlock(osc);
 
 		osc_list_maint(cli, osc);
-		lu_object_ref_del_at(&obj->co_lu, link, "check", current);
+		lu_object_ref_del_at(&obj->co_lu, &link, "check",
+				     current);
 		cl_object_put(env, obj);
 
 		client_obd_list_lock(&cli->cl_loi_list_lock);
-- 
1.7.9.5

