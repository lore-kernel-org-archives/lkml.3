Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaD0RIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:07 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48010 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaD0RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:56 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ann Koehler <amk@cray.com>, Emoly Liu <emoly.liu@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 12/47] staging/lustre: restore __GFP_WAIT flag to memalloc calls
Date: Sun, 27 Apr 2014 13:06:36 -0400
Message-Id: <1398618431-29757-13-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ann Koehler <amk@cray.com>

In Lustre 2.4, the flags passed to the memory allocation functions are
translated from CFS enumeration values types to the kernel GFP
values by calling cfs_alloc_flags_to_gfp(). This function adds
__GFP_WAIT to all flags except CFS_ALLOC_ATOMIC. In 2.5, when
the cfs wrappers were dropped, cfs_alloc_flags_to_gfp() was
removed and the CFS_ALLOC_xxxx was simply replaced with __GFP_xxxx.
This means that most memory allocation calls are missing the
__GFP_WAIT flag. The result is that Lustre experiences more ENOMEM
errors, many of which the higher levels of Lustre do not handle
robustly.
Notes GFP_NOFS = __GFP_WAIT | __GFP_IO. So the patch replaces
__GFP_IO with GFP_NOFS.
Patch does not add __GFP_WAIT to GFP_IOFS. GFP_IOFS was not used in
Lustre 2.4 so it has never been used with __GFP_WAIT.

Signed-off-by: Ann Koehler <amk@cray.com>
Signed-off-by: Emoly Liu <emoly.liu@intel.com>
Reviewed-on: http://review.whamcloud.com/9223
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4357
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/include/linux/libcfs/libcfs_private.h    |  4 ++--
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c         |  2 +-
 drivers/staging/lustre/lustre/include/obd_class.h           |  2 +-
 drivers/staging/lustre/lustre/include/obd_support.h         | 10 +++++-----
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c          | 13 ++++++-------
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c            |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c              |  6 +++---
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c          |  2 +-
 drivers/staging/lustre/lustre/llite/file.c                  |  2 +-
 drivers/staging/lustre/lustre/llite/super25.c               |  2 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c               |  4 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c           |  2 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c                 |  6 +++---
 drivers/staging/lustre/lustre/lov/lov_ea.c                  |  2 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c                |  6 +++---
 drivers/staging/lustre/lustre/lov/lov_object.c              |  2 +-
 drivers/staging/lustre/lustre/lov/lovsub_dev.c              |  2 +-
 drivers/staging/lustre/lustre/lov/lovsub_lock.c             |  2 +-
 drivers/staging/lustre/lustre/lov/lovsub_object.c           |  2 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c            |  2 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c          |  2 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c            |  2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c             |  2 +-
 drivers/staging/lustre/lustre/obdecho/echo_client.c         |  8 ++++----
 drivers/staging/lustre/lustre/osc/osc_dev.c                 |  4 ++--
 drivers/staging/lustre/lustre/osc/osc_io.c                  |  2 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c                |  2 +-
 drivers/staging/lustre/lustre/osc/osc_object.c              |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c               |  6 +++---
 drivers/staging/lustre/lustre/ptlrpc/nrs.c                  |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c                  |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c             |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c              |  2 +-
 33 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
index dddccca1..740bfcd 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -153,7 +153,7 @@ do {									    \
  * default allocator
  */
 #define LIBCFS_ALLOC(ptr, size) \
-	LIBCFS_ALLOC_GFP(ptr, size, __GFP_IO)
+	LIBCFS_ALLOC_GFP(ptr, size, GFP_NOFS)
 
 /**
  * non-sleeping allocator
@@ -177,7 +177,7 @@ do {									    \
 
 /** default numa allocator */
 #define LIBCFS_CPT_ALLOC(ptr, cptab, cpt, size)				    \
-	LIBCFS_CPT_ALLOC_GFP(ptr, cptab, cpt, size, __GFP_IO)
+	LIBCFS_CPT_ALLOC_GFP(ptr, cptab, cpt, size, GFP_NOFS)
 
 #define LIBCFS_FREE(ptr, size)					  \
 do {								    \
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 0061c8a..892c419 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -1141,7 +1141,7 @@ kiblnd_alloc_pages(kib_pages_t **pp, int cpt, int npages)
 	for (i = 0; i < npages; i++) {
 		p->ibp_pages[i] = alloc_pages_node(
 				    cfs_cpt_spread_node(lnet_cpt_table(), cpt),
-				    __GFP_IO, 0);
+				    GFP_NOFS, 0);
 		if (p->ibp_pages[i] == NULL) {
 			CERROR("Can't allocate page %d of %d\n", i, npages);
 			kiblnd_free_pages(p);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 9d1f266..6c8e1ab 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -2133,7 +2133,7 @@ extern struct kmem_cache *obdo_cachep;
 
 #define OBDO_ALLOC(ptr)						       \
 do {									  \
-	OBD_SLAB_ALLOC_PTR_GFP((ptr), obdo_cachep, __GFP_IO);	     \
+	OBD_SLAB_ALLOC_PTR_GFP((ptr), obdo_cachep, GFP_NOFS);             \
 } while(0)
 
 #define OBDO_FREE(ptr)							\
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 5ec3369..cc5af50 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -641,8 +641,8 @@ do {									      \
 #define OBD_ALLOC_GFP(ptr, size, gfp_mask)				      \
 	__OBD_MALLOC_VERBOSE(ptr, NULL, 0, size, gfp_mask)
 
-#define OBD_ALLOC(ptr, size) OBD_ALLOC_GFP(ptr, size, __GFP_IO)
-#define OBD_ALLOC_WAIT(ptr, size) OBD_ALLOC_GFP(ptr, size, GFP_IOFS)
+#define OBD_ALLOC(ptr, size) OBD_ALLOC_GFP(ptr, size, GFP_NOFS)
+#define OBD_ALLOC_WAIT(ptr, size) OBD_ALLOC_GFP(ptr, size, GFP_KERNEL)
 #define OBD_ALLOC_PTR(ptr) OBD_ALLOC(ptr, sizeof(*(ptr)))
 #define OBD_ALLOC_PTR_WAIT(ptr) OBD_ALLOC_WAIT(ptr, sizeof(*(ptr)))
 
@@ -650,7 +650,7 @@ do {									      \
 	__OBD_MALLOC_VERBOSE(ptr, cptab, cpt, size, gfp_mask)
 
 #define OBD_CPT_ALLOC(ptr, cptab, cpt, size)				      \
-	OBD_CPT_ALLOC_GFP(ptr, cptab, cpt, size, __GFP_IO)
+	OBD_CPT_ALLOC_GFP(ptr, cptab, cpt, size, GFP_NOFS)
 
 #define OBD_CPT_ALLOC_PTR(ptr, cptab, cpt)				      \
 	OBD_CPT_ALLOC(ptr, cptab, cpt, sizeof(*(ptr)))
@@ -793,10 +793,10 @@ do {									  \
 } while(0)
 
 #define OBD_SLAB_ALLOC(ptr, slab, size)					      \
-	OBD_SLAB_ALLOC_GFP(ptr, slab, size, __GFP_IO)
+	OBD_SLAB_ALLOC_GFP(ptr, slab, size, GFP_NOFS)
 
 #define OBD_SLAB_CPT_ALLOC(ptr, slab, cptab, cpt, size)			      \
-	OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, size, __GFP_IO)
+	OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, size, GFP_NOFS)
 
 #define OBD_SLAB_ALLOC_PTR(ptr, slab)					      \
 	OBD_SLAB_ALLOC(ptr, slab, sizeof(*(ptr)))
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 6907a16..12812fc 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -112,12 +112,11 @@ static struct lu_kmem_descr ccc_caches[] = {
  *
  */
 
-void *ccc_key_init(const struct lu_context *ctx,
-			  struct lu_context_key *key)
+void *ccc_key_init(const struct lu_context *ctx, struct lu_context_key *key)
 {
 	struct ccc_thread_info *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, ccc_thread_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, ccc_thread_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
@@ -135,7 +134,7 @@ void *ccc_session_key_init(const struct lu_context *ctx,
 {
 	struct ccc_session *session;
 
-	OBD_SLAB_ALLOC_PTR_GFP(session, ccc_session_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(session, ccc_session_kmem, GFP_NOFS);
 	if (session == NULL)
 		session = ERR_PTR(-ENOMEM);
 	return session;
@@ -251,7 +250,7 @@ int ccc_req_init(const struct lu_env *env, struct cl_device *dev,
 	struct ccc_req *vrq;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(vrq, ccc_req_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(vrq, ccc_req_kmem, GFP_NOFS);
 	if (vrq != NULL) {
 		cl_req_slice_add(req, &vrq->crq_cl, dev, &ccc_req_ops);
 		result = 0;
@@ -327,7 +326,7 @@ struct lu_object *ccc_object_alloc(const struct lu_env *env,
 	struct ccc_object *vob;
 	struct lu_object  *obj;
 
-	OBD_SLAB_ALLOC_PTR_GFP(vob, ccc_object_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(vob, ccc_object_kmem, GFP_NOFS);
 	if (vob != NULL) {
 		struct cl_object_header *hdr;
 
@@ -396,7 +395,7 @@ int ccc_lock_init(const struct lu_env *env,
 
 	CLOBINVRNT(env, obj, ccc_object_invariant(obj));
 
-	OBD_SLAB_ALLOC_PTR_GFP(clk, ccc_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(clk, ccc_lock_kmem, GFP_NOFS);
 	if (clk != NULL) {
 		cl_lock_slice_add(lock, &clk->clk_cl, obj, lkops);
 		result = 0;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
index ac5d66a..bde3a82 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
@@ -104,7 +104,7 @@ struct ldlm_interval *ldlm_interval_alloc(struct ldlm_lock *lock)
 	struct ldlm_interval *node;
 
 	LASSERT(lock->l_resource->lr_type == LDLM_EXTENT);
-	OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, GFP_NOFS);
 	if (node == NULL)
 		return NULL;
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 1066e00..1b3f5c1 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -437,7 +437,7 @@ static struct ldlm_lock *ldlm_lock_new(struct ldlm_resource *resource)
 	if (resource == NULL)
 		LBUG();
 
-	OBD_SLAB_ALLOC_PTR_GFP(lock, ldlm_lock_slab, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lock, ldlm_lock_slab, GFP_NOFS);
 	if (lock == NULL)
 		return NULL;
 
@@ -1624,7 +1624,7 @@ ldlm_error_t ldlm_lock_enqueue(struct ldlm_namespace *ns,
 	 * have to allocate the interval node early otherwise we can't regrant
 	 * this lock in the future. - jay */
 	if (!local && (*flags & LDLM_FL_REPLAY) && res->lr_type == LDLM_EXTENT)
-		OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, __GFP_IO);
+		OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, GFP_NOFS);
 
 	lock_res_and_lock(lock);
 	if (local && lock->l_req_mode == lock->l_granted_mode) {
@@ -2146,7 +2146,7 @@ struct ldlm_resource *ldlm_lock_convert(struct ldlm_lock *lock, int new_mode,
 
 	/* I can't check the type of lock here because the bitlock of lock
 	 * is not held here, so do the allocation blindly. -jay */
-	OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, GFP_NOFS);
 	if (node == NULL)
 		/* Actually, this causes EDEADLOCK to be returned */
 		return NULL;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 2824d4a..a4cec5e 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -1014,7 +1014,7 @@ static struct ldlm_resource *ldlm_resource_new(void)
 	struct ldlm_resource *res;
 	int idx;
 
-	OBD_SLAB_ALLOC_PTR_GFP(res, ldlm_resource_slab, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(res, ldlm_resource_slab, GFP_NOFS);
 	if (res == NULL)
 		return NULL;
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 8e844a6..d01c864 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -54,7 +54,7 @@ struct ll_file_data *ll_file_data_get(void)
 {
 	struct ll_file_data *fd;
 
-	OBD_SLAB_ALLOC_PTR_GFP(fd, ll_file_data_slab, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(fd, ll_file_data_slab, GFP_NOFS);
 	if (fd == NULL)
 		return NULL;
 	fd->fd_write_failed = false;
diff --git a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
index e21e1c7..58bb8f2 100644
--- a/drivers/staging/lustre/lustre/llite/super25.c
+++ b/drivers/staging/lustre/lustre/llite/super25.c
@@ -52,7 +52,7 @@ static struct inode *ll_alloc_inode(struct super_block *sb)
 {
 	struct ll_inode_info *lli;
 	ll_stats_ops_tally(ll_s2sbi(sb), LPROC_LL_ALLOC_INODE, 1);
-	OBD_SLAB_ALLOC_PTR_GFP(lli, ll_inode_cachep, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lli, ll_inode_cachep, GFP_NOFS);
 	if (lli == NULL)
 		return NULL;
 
diff --git a/drivers/staging/lustre/lustre/llite/vvp_dev.c b/drivers/staging/lustre/lustre/llite/vvp_dev.c
index c4d1580..a9778b8 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_dev.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_dev.c
@@ -80,7 +80,7 @@ static void *vvp_key_init(const struct lu_context *ctx,
 {
 	struct vvp_thread_info *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, vvp_thread_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, vvp_thread_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
@@ -98,7 +98,7 @@ static void *vvp_session_key_init(const struct lu_context *ctx,
 {
 	struct vvp_session *session;
 
-	OBD_SLAB_ALLOC_PTR_GFP(session, vvp_session_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(session, vvp_session_kmem, GFP_NOFS);
 	if (session == NULL)
 		session = ERR_PTR(-ENOMEM);
 	return session;
diff --git a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
index 4defa2f..dfd19f8 100644
--- a/drivers/staging/lustre/lustre/llite/xattr_cache.c
+++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
@@ -120,7 +120,7 @@ static int ll_xattr_cache_add(struct list_head *cache,
 		return -EPROTO;
 	}
 
-	OBD_SLAB_ALLOC_PTR_GFP(xattr, xattr_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(xattr, xattr_kmem, GFP_NOFS);
 	if (xattr == NULL) {
 		CDEBUG(D_CACHE, "failed to allocate xattr\n");
 		return -ENOMEM;
diff --git a/drivers/staging/lustre/lustre/lov/lov_dev.c b/drivers/staging/lustre/lustre/lov/lov_dev.c
index 1f33b04..53e5781 100644
--- a/drivers/staging/lustre/lustre/lov/lov_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lov_dev.c
@@ -143,7 +143,7 @@ static void *lov_key_init(const struct lu_context *ctx,
 {
 	struct lov_thread_info *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, lov_thread_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, lov_thread_kmem, GFP_NOFS);
 	if (info != NULL)
 		INIT_LIST_HEAD(&info->lti_closure.clc_list);
 	else
@@ -170,7 +170,7 @@ static void *lov_session_key_init(const struct lu_context *ctx,
 {
 	struct lov_session *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, lov_session_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, lov_session_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
@@ -260,7 +260,7 @@ static int lov_req_init(const struct lu_env *env, struct cl_device *dev,
 	struct lov_req *lr;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lr, lov_req_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lr, lov_req_kmem, GFP_NOFS);
 	if (lr != NULL) {
 		cl_req_slice_add(req, &lr->lr_cl, dev, &lov_req_ops);
 		result = 0;
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index 6f356e0..b91cb2a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -101,7 +101,7 @@ struct lov_stripe_md *lsm_alloc_plain(__u16 stripe_count, int *size)
 		return NULL;
 
 	for (i = 0; i < stripe_count; i++) {
-		OBD_SLAB_ALLOC_PTR_GFP(loi, lov_oinfo_slab, __GFP_IO);
+		OBD_SLAB_ALLOC_PTR_GFP(loi, lov_oinfo_slab, GFP_NOFS);
 		if (loi == NULL)
 			goto err;
 		lsm->lsm_oinfo[i] = loi;
diff --git a/drivers/staging/lustre/lustre/lov/lov_lock.c b/drivers/staging/lustre/lustre/lov/lov_lock.c
index ed2726e..0bbe141 100644
--- a/drivers/staging/lustre/lustre/lov/lov_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lov_lock.c
@@ -144,7 +144,7 @@ static struct cl_lock *lov_sublock_alloc(const struct lu_env *env,
 
 	LASSERT(idx < lck->lls_nr);
 
-	OBD_SLAB_ALLOC_PTR_GFP(link, lov_lock_link_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(link, lov_lock_link_kmem, GFP_NOFS);
 	if (link != NULL) {
 		struct lov_sublock_env *subenv;
 		struct lov_lock_sub  *lls;
@@ -1159,7 +1159,7 @@ int lov_lock_init_raid0(const struct lu_env *env, struct cl_object *obj,
 	struct lov_lock *lck;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lck, lov_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lck, lov_lock_kmem, GFP_NOFS);
 	if (lck != NULL) {
 		cl_lock_slice_add(lock, &lck->lls_cl, obj, &lov_lock_ops);
 		result = lov_lock_sub_init(env, lck, io);
@@ -1194,7 +1194,7 @@ int lov_lock_init_empty(const struct lu_env *env, struct cl_object *obj,
 	struct lov_lock *lck;
 	int result = -ENOMEM;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lck, lov_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lck, lov_lock_kmem, GFP_NOFS);
 	if (lck != NULL) {
 		cl_lock_slice_add(lock, &lck->lls_cl, obj, &lov_empty_lock_ops);
 		lck->lls_orig = lock->cll_descr;
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index d6b2cb4..f20e497 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -885,7 +885,7 @@ struct lu_object *lov_object_alloc(const struct lu_env *env,
 	struct lov_object *lov;
 	struct lu_object  *obj;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lov, lov_object_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lov, lov_object_kmem, GFP_NOFS);
 	if (lov != NULL) {
 		obj = lov2lu(lov);
 		lu_object_init(obj, NULL, dev);
diff --git a/drivers/staging/lustre/lustre/lov/lovsub_dev.c b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
index 926c35a..52fb6c1 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
@@ -146,7 +146,7 @@ static int lovsub_req_init(const struct lu_env *env, struct cl_device *dev,
 	struct lovsub_req *lsr;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lsr, lovsub_req_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lsr, lovsub_req_kmem, GFP_NOFS);
 	if (lsr != NULL) {
 		cl_req_slice_add(req, &lsr->lsrq_cl, dev, &lovsub_req_ops);
 		result = 0;
diff --git a/drivers/staging/lustre/lustre/lov/lovsub_lock.c b/drivers/staging/lustre/lustre/lov/lovsub_lock.c
index 80305aa..62b696d 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_lock.c
@@ -453,7 +453,7 @@ int lovsub_lock_init(const struct lu_env *env, struct cl_object *obj,
 	struct lovsub_lock *lsk;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lsk, lovsub_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lsk, lovsub_lock_kmem, GFP_NOFS);
 	if (lsk != NULL) {
 		INIT_LIST_HEAD(&lsk->lss_parents);
 		cl_lock_slice_add(lock, &lsk->lss_cl, obj, &lovsub_lock_ops);
diff --git a/drivers/staging/lustre/lustre/lov/lovsub_object.c b/drivers/staging/lustre/lustre/lov/lovsub_object.c
index 89760b3..57e3629 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_object.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_object.c
@@ -145,7 +145,7 @@ struct lu_object *lovsub_object_alloc(const struct lu_env *env,
 	struct lovsub_object *los;
 	struct lu_object     *obj;
 
-	OBD_SLAB_ALLOC_PTR_GFP(los, lovsub_object_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(los, lovsub_object_kmem, GFP_NOFS);
 	if (los != NULL) {
 		struct cl_object_header *hdr;
 
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index 8eb1785..918f433 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -360,7 +360,7 @@ static struct cl_lock *cl_lock_alloc(const struct lu_env *env,
 	struct cl_lock	  *lock;
 	struct lu_object_header *head;
 
-	OBD_SLAB_ALLOC_PTR_GFP(lock, cl_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(lock, cl_lock_kmem, GFP_NOFS);
 	if (lock != NULL) {
 		atomic_set(&lock->cll_ref, 1);
 		lock->cll_descr = *descr;
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index 0fc256f..2837cbc 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -684,7 +684,7 @@ static struct lu_env *cl_env_new(__u32 ctx_tags, __u32 ses_tags, void *debug)
 	struct lu_env *env;
 	struct cl_env *cle;
 
-	OBD_SLAB_ALLOC_PTR_GFP(cle, cl_env_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(cle, cl_env_kmem, GFP_NOFS);
 	if (cle != NULL) {
 		int rc;
 
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_page.c b/drivers/staging/lustre/lustre/obdclass/cl_page.c
index 2a5ce37..a4b04cb 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -292,7 +292,7 @@ static struct cl_page *cl_page_alloc(const struct lu_env *env,
 	struct lu_object_header *head;
 
 	OBD_ALLOC_GFP(page, cl_object_header(o)->coh_page_bufsize,
-			__GFP_IO);
+			GFP_NOFS);
 	if (page != NULL) {
 		int result = 0;
 		atomic_set(&page->cp_ref, 1);
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index 350b6f0..3210ad8 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -72,7 +72,7 @@ static struct obd_device *obd_device_alloc(void)
 {
 	struct obd_device *obd;
 
-	OBD_SLAB_ALLOC_PTR_GFP(obd, obd_device_cachep, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(obd, obd_device_cachep, GFP_NOFS);
 	if (obd != NULL) {
 		obd->obd_magic = OBD_DEVICE_MAGIC;
 	}
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index a7f5e41..0eb39f2 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -428,7 +428,7 @@ static int echo_lock_init(const struct lu_env *env,
 {
 	struct echo_lock *el;
 
-	OBD_SLAB_ALLOC_PTR_GFP(el, echo_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(el, echo_lock_kmem, GFP_NOFS);
 	if (el != NULL) {
 		cl_lock_slice_add(lock, &el->el_cl, obj, &echo_lock_ops);
 		el->el_object = cl2echo_obj(obj);
@@ -599,7 +599,7 @@ static struct lu_object *echo_object_alloc(const struct lu_env *env,
 
 	/* we're the top dev. */
 	LASSERT(hdr == NULL);
-	OBD_SLAB_ALLOC_PTR_GFP(eco, echo_object_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(eco, echo_object_kmem, GFP_NOFS);
 	if (eco != NULL) {
 		struct cl_object_header *hdr = &eco->eo_hdr;
 
@@ -663,7 +663,7 @@ static void *echo_thread_key_init(const struct lu_context *ctx,
 {
 	struct echo_thread_info *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, echo_thread_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, echo_thread_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
@@ -693,7 +693,7 @@ static void *echo_session_key_init(const struct lu_context *ctx,
 {
 	struct echo_session_info *session;
 
-	OBD_SLAB_ALLOC_PTR_GFP(session, echo_session_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(session, echo_session_kmem, GFP_NOFS);
 	if (session == NULL)
 		session = ERR_PTR(-ENOMEM);
 	return session;
diff --git a/drivers/staging/lustre/lustre/osc/osc_dev.c b/drivers/staging/lustre/lustre/osc/osc_dev.c
index 35f2578..6a64839 100644
--- a/drivers/staging/lustre/lustre/osc/osc_dev.c
+++ b/drivers/staging/lustre/lustre/osc/osc_dev.c
@@ -122,7 +122,7 @@ static void *osc_key_init(const struct lu_context *ctx,
 {
 	struct osc_thread_info *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, osc_thread_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, osc_thread_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
@@ -146,7 +146,7 @@ static void *osc_session_init(const struct lu_context *ctx,
 {
 	struct osc_session *info;
 
-	OBD_SLAB_ALLOC_PTR_GFP(info, osc_session_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(info, osc_session_kmem, GFP_NOFS);
 	if (info == NULL)
 		info = ERR_PTR(-ENOMEM);
 	return info;
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 5f3c545..6744dc6 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -812,7 +812,7 @@ int osc_req_init(const struct lu_env *env, struct cl_device *dev,
 	struct osc_req *or;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(or, osc_req_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(or, osc_req_kmem, GFP_NOFS);
 	if (or != NULL) {
 		cl_req_slice_add(req, &or->or_cl, dev, &osc_req_ops);
 		result = 0;
diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index 1c6cafa..a46129b 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -1559,7 +1559,7 @@ int osc_lock_init(const struct lu_env *env,
 	struct osc_lock *clk;
 	int result;
 
-	OBD_SLAB_ALLOC_PTR_GFP(clk, osc_lock_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(clk, osc_lock_kmem, GFP_NOFS);
 	if (clk != NULL) {
 		__u32 enqflags = lock->cll_descr.cld_enq_flags;
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_object.c b/drivers/staging/lustre/lustre/osc/osc_object.c
index 9d34de8..f9bfdc8 100644
--- a/drivers/staging/lustre/lustre/osc/osc_object.c
+++ b/drivers/staging/lustre/lustre/osc/osc_object.c
@@ -260,7 +260,7 @@ struct lu_object *osc_object_alloc(const struct lu_env *env,
 	struct osc_object *osc;
 	struct lu_object  *obj;
 
-	OBD_SLAB_ALLOC_PTR_GFP(osc, osc_object_kmem, __GFP_IO);
+	OBD_SLAB_ALLOC_PTR_GFP(osc, osc_object_kmem, GFP_NOFS);
 	if (osc != NULL) {
 		obj = osc2lu(osc);
 		lu_object_init(obj, NULL, dev);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 5bee820..2098772 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -455,7 +455,7 @@ void ptlrpc_add_rqs_to_pool(struct ptlrpc_request_pool *pool, int num_rq)
 		struct lustre_msg *msg;
 
 		spin_unlock(&pool->prp_lock);
-		req = ptlrpc_request_cache_alloc(__GFP_IO);
+		req = ptlrpc_request_cache_alloc(GFP_NOFS);
 		if (!req)
 			return;
 		OBD_ALLOC_LARGE(msg, size);
@@ -696,7 +696,7 @@ struct ptlrpc_request *__ptlrpc_request_alloc(struct obd_import *imp,
 		request = ptlrpc_prep_req_from_pool(pool);
 
 	if (!request)
-		request = ptlrpc_request_cache_alloc(__GFP_IO);
+		request = ptlrpc_request_cache_alloc(GFP_NOFS);
 
 	if (request) {
 		LASSERTF((unsigned long)imp > 0x1000, "%p", imp);
@@ -3051,7 +3051,7 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 		return ERR_PTR(-EINVAL);
 
 	/* copy some code from deprecated fakereq. */
-	req = ptlrpc_request_cache_alloc(__GFP_IO);
+	req = ptlrpc_request_cache_alloc(GFP_NOFS);
 	if (req == NULL) {
 		CERROR("ptlrpc: run out of memory!\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index bcba1c8e..12151aa 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -746,7 +746,7 @@ static int nrs_policy_register(struct ptlrpc_nrs *nrs,
 	LASSERT(desc->pd_compat != NULL);
 
 	OBD_CPT_ALLOC_GFP(policy, svcpt->scp_service->srv_cptable,
-			  svcpt->scp_cpt, sizeof(*policy), __GFP_IO);
+			  svcpt->scp_cpt, sizeof(*policy), GFP_NOFS);
 	if (policy == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index e383493..8d71e4e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -916,7 +916,7 @@ int sptlrpc_import_check_ctx(struct obd_import *imp)
 		return -EACCES;
 	}
 
-	req = ptlrpc_request_cache_alloc(__GFP_IO);
+	req = ptlrpc_request_cache_alloc(GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
 
@@ -1100,7 +1100,7 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 	int		     early_bufsz, early_size;
 	int		     rc;
 
-	early_req = ptlrpc_request_cache_alloc(__GFP_IO);
+	early_req = ptlrpc_request_cache_alloc(GFP_NOFS);
 	if (early_req == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 9656681..1d46b5e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -421,7 +421,7 @@ static int enc_pools_add_pages(int npages)
 			goto out_pools;
 
 		for (j = 0; j < PAGES_PER_POOL && alloced < npages; j++) {
-			pools[i][j] = alloc_page(__GFP_IO |
+			pools[i][j] = alloc_page(GFP_NOFS |
 						     __GFP_HIGHMEM);
 			if (pools[i][j] == NULL)
 				goto out_pools;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 4dd2bcb..5d0eb6c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1305,7 +1305,7 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	}
 	newdl = cfs_time_current_sec() + at_get(&svcpt->scp_at_estimate);
 
-	reqcopy = ptlrpc_request_cache_alloc(__GFP_IO);
+	reqcopy = ptlrpc_request_cache_alloc(GFP_NOFS);
 	if (reqcopy == NULL)
 		return -ENOMEM;
 	OBD_ALLOC_LARGE(reqmsg, req->rq_reqlen);
-- 
1.8.5.3

