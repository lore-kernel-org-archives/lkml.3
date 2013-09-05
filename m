Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3IEWVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:21:13 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41378 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3IEWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:21:11 -0400
Date: Thu, 5 Sep 2013 18:21:09 -0400
From: David Howells <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] FS-Cache: Add interface to check consistency of a cached
 object
Message-ID: <77fd1777a9c7e502628febe0e08d085846ed084e.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the fscache netfs API so that the netfs can ask as to whether a cache
object is up to date with respect to its corresponding netfs object:

	int fscache_check_consistency(struct fscache_cookie *cookie)

This will call back to the netfs to check whether the auxiliary data associated
with a cookie is correct.  It returns 0 if it is and -ESTALE if it isn't; it
may also return -ENOMEM and -ERESTARTSYS.

The backends now have to implement a mandatory operation pointer:

	int (*check_consistency)(struct fscache_object *object)

that corresponds to the above API call.  FS-Cache takes care of pinning the
object and the cookie in memory and managing this call with respect to the
object state.

Original-author: Hongyi Jia <jiayisuse@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hongyi Jia <jiayisuse@gmail.com>
cc: Milosz Tanski <milosz@adfin.com>
---
 Documentation/filesystems/caching/backend-api.txt |    9 +++
 Documentation/filesystems/caching/netfs-api.txt   |   17 +++--
 fs/fscache/cookie.c                               |   69 +++++++++++++++++++++
 fs/fscache/internal.h                             |    6 ++
 fs/fscache/page.c                                 |   55 +++++++++-------
 include/linux/fscache-cache.h                     |    4 ++
 include/linux/fscache.h                           |   20 ++++++
 7 files changed, 152 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/caching/backend-api.txt b/Documentation/filesystems/caching/backend-api.txt
index d78bab9..277d1e8 100644
--- a/Documentation/filesystems/caching/backend-api.txt
+++ b/Documentation/filesystems/caching/backend-api.txt
@@ -299,6 +299,15 @@ performed on the denizens of the cache.  These are held in a structure of type:
      enough space in the cache to permit this.
 
 
+ (*) Check coherency state of an object [mandatory]:
+
+	int (*check_consistency)(struct fscache_object *object)
+
+     This method is called to have the cache check the saved auxiliary data of
+     the object against the netfs's idea of the state.  0 should be returned
+     if they're consistent and -ESTALE otherwise.  -ENOMEM and -ERESTARTSYS
+     may also be returned.
+
  (*) Update object [mandatory]:
 
 	int (*update_object)(struct fscache_object *object)
diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
index 97e6c0e..12b3442 100644
--- a/Documentation/filesystems/caching/netfs-api.txt
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -32,7 +32,7 @@ This document contains the following sections:
 	 (9) Setting the data file size
 	(10) Page alloc/read/write
 	(11) Page uncaching
-	(12) Index and data file update
+	(12) Index and data file consistency
 	(13) Miscellaneous cookie operations
 	(14) Cookie unregistration
 	(15) Index invalidation
@@ -690,9 +690,18 @@ written to the cache and for the cache to finish with the page generally.  No
 error is returned.
 
 
-==========================
-INDEX AND DATA FILE UPDATE
-==========================
+===============================
+INDEX AND DATA FILE CONSISTENCY
+===============================
+
+To find out whether auxiliary data for an object is up to data within the
+cache, the following function can be called:
+
+	int fscache_check_consistency(struct fscache_cookie *cookie)
+
+This will call back to the netfs to check whether the auxiliary data associated
+with a cookie is correct.  It returns 0 if it is and -ESTALE if it isn't; it
+may also return -ENOMEM and -ERESTARTSYS.
 
 To request an update of the index data for an index or other object, the
 following function should be called:
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 0e91a3c..2ef4c9d 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -558,3 +558,72 @@ void __fscache_cookie_put(struct fscache_cookie *cookie)
 
 	_leave("");
 }
+
+/*
+ * check the consistency between the netfs inode and the backing cache
+ *
+ * NOTE: it only serves no-index type
+ */
+int __fscache_check_consistency(struct fscache_cookie *cookie)
+{
+	struct fscache_operation *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,", cookie);
+
+	ASSERTCMP(cookie->def->type, ==, FSCACHE_COOKIE_TYPE_DATAFILE);
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	if (hlist_empty(&cookie->backing_objects))
+		return 0;
+
+	op = kzalloc(sizeof(*op), GFP_NOIO | __GFP_NOMEMALLOC | __GFP_NORETRY);
+	if (!op)
+		return -ENOMEM;
+
+	fscache_operation_init(op, NULL, NULL);
+	op->flags = FSCACHE_OP_MYTHREAD |
+		(1 << FSCACHE_OP_WAITING);
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto inconsistent;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+		goto inconsistent;
+
+	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+
+	atomic_inc(&cookie->n_active);
+	if (fscache_submit_op(object, op) < 0)
+		goto submit_failed;
+
+	/* the work queue now carries its own ref on the object */
+	spin_unlock(&cookie->lock);
+
+	ret = fscache_wait_for_operation_activation(object, op,
+						    NULL, NULL, NULL);
+	if (ret == 0)
+		/* ask the cache to honour the operation */
+		ret = object->cache->ops->check_consistency(op);
+	else if (ret == -ENOBUFS)
+		ret = 0;
+
+	fscache_put_operation(op);
+	_leave(" = %d", ret);
+	return ret;
+
+submit_failed:
+	atomic_dec(&cookie->n_active);
+inconsistent:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+	_leave(" = -ESTALE");
+	return -ESTALE;
+}
+EXPORT_SYMBOL(__fscache_check_consistency);
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 12d505b..4226f66 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -130,6 +130,12 @@ extern void fscache_operation_gc(struct work_struct *);
 /*
  * page.c
  */
+extern int fscache_wait_for_deferred_lookup(struct fscache_cookie *);
+extern int fscache_wait_for_operation_activation(struct fscache_object *,
+						 struct fscache_operation *,
+						 atomic_t *,
+						 atomic_t *,
+						 void (*)(struct fscache_operation *));
 extern void fscache_invalidate_writes(struct fscache_cookie *);
 
 /*
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index d479ab3..793e3d5 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -278,7 +278,7 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 /*
  * wait for a deferred lookup to complete
  */
-static int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
+int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
 {
 	unsigned long jif;
 
@@ -322,42 +322,46 @@ static void fscache_do_cancel_retrieval(struct fscache_operation *_op)
 /*
  * wait for an object to become active (or dead)
  */
-static int fscache_wait_for_retrieval_activation(struct fscache_object *object,
-						 struct fscache_retrieval *op,
-						 atomic_t *stat_op_waits,
-						 atomic_t *stat_object_dead)
+int fscache_wait_for_operation_activation(struct fscache_object *object,
+					  struct fscache_operation *op,
+					  atomic_t *stat_op_waits,
+					  atomic_t *stat_object_dead,
+					  void (*do_cancel)(struct fscache_operation *))
 {
 	int ret;
 
-	if (!test_bit(FSCACHE_OP_WAITING, &op->op.flags))
+	if (!test_bit(FSCACHE_OP_WAITING, &op->flags))
 		goto check_if_dead;
 
 	_debug(">>> WT");
-	fscache_stat(stat_op_waits);
-	if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+	if (stat_op_waits)
+		fscache_stat(stat_op_waits);
+	if (wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
 			fscache_wait_bit_interruptible,
 			TASK_INTERRUPTIBLE) != 0) {
-		ret = fscache_cancel_op(&op->op, fscache_do_cancel_retrieval);
+		ret = fscache_cancel_op(op, do_cancel);
 		if (ret == 0)
 			return -ERESTARTSYS;
 
 		/* it's been removed from the pending queue by another party,
 		 * so we should get to run shortly */
-		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+		wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
 			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
 	}
 	_debug("<<< GO");
 
 check_if_dead:
-	if (op->op.state == FSCACHE_OP_ST_CANCELLED) {
-		fscache_stat(stat_object_dead);
+	if (op->state == FSCACHE_OP_ST_CANCELLED) {
+		if (stat_object_dead)
+			fscache_stat(stat_object_dead);
 		_leave(" = -ENOBUFS [cancelled]");
 		return -ENOBUFS;
 	}
 	if (unlikely(fscache_object_is_dead(object))) {
-		pr_err("%s() = -ENOBUFS [obj dead %d]\n", __func__, op->op.state);
-		fscache_cancel_op(&op->op, fscache_do_cancel_retrieval);
-		fscache_stat(stat_object_dead);
+		pr_err("%s() = -ENOBUFS [obj dead %d]\n", __func__, op->state);
+		fscache_cancel_op(op, do_cancel);
+		if (stat_object_dead)
+			fscache_stat(stat_object_dead);
 		return -ENOBUFS;
 	}
 	return 0;
@@ -432,10 +436,11 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
-	ret = fscache_wait_for_retrieval_activation(
-		object, op,
+	ret = fscache_wait_for_operation_activation(
+		object, &op->op,
 		__fscache_stat(&fscache_n_retrieval_op_waits),
-		__fscache_stat(&fscache_n_retrievals_object_dead));
+		__fscache_stat(&fscache_n_retrievals_object_dead),
+		fscache_do_cancel_retrieval);
 	if (ret < 0)
 		goto error;
 
@@ -557,10 +562,11 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
-	ret = fscache_wait_for_retrieval_activation(
-		object, op,
+	ret = fscache_wait_for_operation_activation(
+		object, &op->op,
 		__fscache_stat(&fscache_n_retrieval_op_waits),
-		__fscache_stat(&fscache_n_retrievals_object_dead));
+		__fscache_stat(&fscache_n_retrievals_object_dead),
+		fscache_do_cancel_retrieval);
 	if (ret < 0)
 		goto error;
 
@@ -658,10 +664,11 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 	fscache_stat(&fscache_n_alloc_ops);
 
-	ret = fscache_wait_for_retrieval_activation(
-		object, op,
+	ret = fscache_wait_for_operation_activation(
+		object, &op->op,
 		__fscache_stat(&fscache_n_alloc_op_waits),
-		__fscache_stat(&fscache_n_allocs_object_dead));
+		__fscache_stat(&fscache_n_allocs_object_dead),
+		fscache_do_cancel_retrieval);
 	if (ret < 0)
 		goto error;
 
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index a9ff9a3..7823e9e 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -251,6 +251,10 @@ struct fscache_cache_ops {
 	/* unpin an object in the cache */
 	void (*unpin_object)(struct fscache_object *object);
 
+	/* check the consistency between the backing cache and the FS-Cache
+	 * cookie */
+	bool (*check_consistency)(struct fscache_operation *op);
+
 	/* store the updated auxiliary data on an object */
 	void (*update_object)(struct fscache_object *object);
 
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 7a08623..d984aff 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -183,6 +183,7 @@ extern struct fscache_cookie *__fscache_acquire_cookie(
 	const struct fscache_cookie_def *,
 	void *);
 extern void __fscache_relinquish_cookie(struct fscache_cookie *, int);
+extern int __fscache_check_consistency(struct fscache_cookie *);
 extern void __fscache_update_cookie(struct fscache_cookie *);
 extern int __fscache_attr_changed(struct fscache_cookie *);
 extern void __fscache_invalidate(struct fscache_cookie *);
@@ -326,6 +327,25 @@ void fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 }
 
 /**
+ * fscache_check_consistency - Request that if the cache is updated
+ * @cookie: The cookie representing the cache object
+ *
+ * Request an consistency check from fscache, which passes the request
+ * to the backing cache.
+ *
+ * Returns 0 if consistent and -ESTALE if inconsistent.  May also
+ * return -ENOMEM and -ERESTARTSYS.
+ */
+static inline
+int fscache_check_consistency(struct fscache_cookie *cookie)
+{
+	if (fscache_cookie_valid(cookie))
+		return __fscache_check_consistency(cookie);
+	else
+		return 0;
+}
+
+/**
  * fscache_update_cookie - Request that a cache object be updated
  * @cookie: The cookie representing the cache object
  *
-- 
1.7.9.5

