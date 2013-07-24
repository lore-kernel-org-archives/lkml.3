Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3GXIhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:37:36 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31957 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474Ab3GXIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:36:06 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 7/8] staging/lustre/obdclass: use a dummy structure for lu_ref_link
Date: Wed, 24 Jul 2013 16:31:31 +0800
Message-Id: <1374654692-13237-8-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John L. Hammond <john.hammond@intel.com>

Move the definition of struct lu_ref_link to lu_ref.h.  If USE_LU_REF
is not defined then define it to be the empty struct.  Change the
return type of lu_ref_add() and lu_ref_add_atomic() to void.  Add
lu_ref_add_at() taking same arguments as lu_ref_add() togerther with a
pointer to a struct lu_ref_link and returning void.  Adjust all
structures containing a lu_ref_link pointer to contain a struct
lu_ref_link instead.  Use lu_ref_add_at() and lu_ref_del_at() to
handle embedded lu_ref_links.

[Original patch mainly changes lu_ref.[ch] but in upstream client we don't
have lu_ref code in the hope of moving to kobject refcounting. So the patch
only picks the other pieces of original patch, in order to keep code in
sync and make it easier to port future patches.]

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
 drivers/staging/lustre/lustre/include/cl_object.h  |   10 +++++-----
 drivers/staging/lustre/lustre/include/lu_object.h  |   18 +++++++++++++-----
 drivers/staging/lustre/lustre/include/lu_ref.h     |   14 +++++++++++++-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   17 +++++++++--------
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    6 +++---
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    5 +++--
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   15 ++++++++-------
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    8 +++++---
 8 files changed, 59 insertions(+), 34 deletions(-)

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
index 9476048..8077898 100644
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
@@ -873,11 +873,19 @@ static inline __u32 lu_object_attr(const struct lu_object *o)
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
index 624c19b..50a2a7f 100644
--- a/drivers/staging/lustre/lustre/include/lu_ref.h
+++ b/drivers/staging/lustre/lustre/include/lu_ref.h
@@ -108,7 +108,12 @@
  */
 
 
-struct lu_ref  {};
+/*
+ * dummy data structures/functions to pass compile for now.
+ * We need to reimplement them with kref.
+ */
+struct lu_ref {};
+struct lu_ref_link {};
 
 static inline void lu_ref_init(struct lu_ref *ref)
 {
@@ -132,6 +137,13 @@ static inline struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref,
 	return NULL;
 }
 
+static inline void lu_ref_add_at(struct lu_ref *ref,
+				 struct lu_ref_link *link,
+				 const char *scope,
+				 const void *source)
+{
+}
+
 static inline void lu_ref_del(struct lu_ref *ref, const char *scope,
 			      const void *source)
 {
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
index ce0444f..896f24a 100644
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
1.7.1

