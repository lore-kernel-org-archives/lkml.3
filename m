Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3GVQK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49781 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab3GVQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:55 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <green@whamcloud.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 13/48] staging/lustre/ldlm: split client namespaces into active and inactive
Date: Tue, 23 Jul 2013 00:06:34 +0800
Message-Id: <1374509230-3324-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Drokin <green@whamcloud.com>

The main reason behind this is ldlm_poold walks all namespaces currently
no matter if there are any locks or not. On large systems this could take
quite a bit of time, esp. since ldlm_poold is currently woken up once per
second.

Now every time a client namespace loses it's last resource it is placed
into an inactive list that is not touched by ldlm_poold as pointless.
On creation of a first resource in a namespace it is placed back into
the active list.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2924
Lustre-change: http://review.whamcloud.com/5624
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |   46 +++++++++++++--
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   59 ++++++++++++++++----
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   55 +++++++++++++++---
 4 files changed, 135 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 317f928..48cb6f8 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1471,8 +1471,6 @@ void ldlm_namespace_free(struct ldlm_namespace *ns,
 			 struct obd_import *imp, int force);
 void ldlm_namespace_register(struct ldlm_namespace *ns, ldlm_side_t client);
 void ldlm_namespace_unregister(struct ldlm_namespace *ns, ldlm_side_t client);
-void ldlm_namespace_move_locked(struct ldlm_namespace *ns, ldlm_side_t client);
-struct ldlm_namespace *ldlm_namespace_first_locked(ldlm_side_t client);
 void ldlm_namespace_get(struct ldlm_namespace *ns);
 void ldlm_namespace_put(struct ldlm_namespace *ns);
 int ldlm_proc_setup(void);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
index 141a957..785c1a1 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
@@ -36,23 +36,46 @@
 
 #define MAX_STRING_SIZE 128
 
-extern atomic_t ldlm_srv_namespace_nr;
-extern atomic_t ldlm_cli_namespace_nr;
+extern int ldlm_srv_namespace_nr;
+extern int ldlm_cli_namespace_nr;
 extern struct mutex ldlm_srv_namespace_lock;
 extern struct list_head ldlm_srv_namespace_list;
 extern struct mutex ldlm_cli_namespace_lock;
-extern struct list_head ldlm_cli_namespace_list;
+extern struct list_head ldlm_cli_active_namespace_list;
+extern struct list_head ldlm_cli_inactive_namespace_list;
 
-static inline atomic_t *ldlm_namespace_nr(ldlm_side_t client)
+static inline int ldlm_namespace_nr_read(ldlm_side_t client)
 {
 	return client == LDLM_NAMESPACE_SERVER ?
-		&ldlm_srv_namespace_nr : &ldlm_cli_namespace_nr;
+		ldlm_srv_namespace_nr : ldlm_cli_namespace_nr;
+}
+
+static inline void ldlm_namespace_nr_inc(ldlm_side_t client)
+{
+	if (client == LDLM_NAMESPACE_SERVER)
+		ldlm_srv_namespace_nr++;
+	else
+		ldlm_cli_namespace_nr++;
+}
+
+static inline void ldlm_namespace_nr_dec(ldlm_side_t client)
+{
+	if (client == LDLM_NAMESPACE_SERVER)
+		ldlm_srv_namespace_nr--;
+	else
+		ldlm_cli_namespace_nr--;
 }
 
 static inline struct list_head *ldlm_namespace_list(ldlm_side_t client)
 {
 	return client == LDLM_NAMESPACE_SERVER ?
-		&ldlm_srv_namespace_list : &ldlm_cli_namespace_list;
+		&ldlm_srv_namespace_list : &ldlm_cli_active_namespace_list;
+}
+
+static inline struct list_head *ldlm_namespace_inactive_list(ldlm_side_t client)
+{
+	return client == LDLM_NAMESPACE_SERVER ?
+		&ldlm_srv_namespace_list : &ldlm_cli_inactive_namespace_list;
 }
 
 static inline struct mutex *ldlm_namespace_lock(ldlm_side_t client)
@@ -61,6 +84,17 @@ static inline struct mutex *ldlm_namespace_lock(ldlm_side_t client)
 		&ldlm_srv_namespace_lock : &ldlm_cli_namespace_lock;
 }
 
+/* ns_bref is the number of resources in this namespace with the notable
+ * exception of quota namespaces which have their empty refcount at 1 */
+static inline int ldlm_ns_empty(struct ldlm_namespace *ns)
+{
+	return atomic_read(&ns->ns_bref) == 0;
+}
+
+void ldlm_namespace_move_to_active_locked(struct ldlm_namespace *, ldlm_side_t);
+void ldlm_namespace_move_to_inactive_locked(struct ldlm_namespace *, ldlm_side_t);
+struct ldlm_namespace *ldlm_namespace_first_locked(ldlm_side_t);
+
 /* ldlm_request.c */
 /* Cancel lru flag, it indicates we cancel aged locks. */
 enum {
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index b3b6028..1e6802f 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -1039,6 +1039,7 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 {
 	int total = 0, cached = 0, nr_ns;
 	struct ldlm_namespace *ns;
+	struct ldlm_namespace *ns_old = NULL; /* loop detection */
 	void *cookie;
 
 	if (client == LDLM_NAMESPACE_CLIENT && nr != 0 &&
@@ -1053,7 +1054,7 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 	/*
 	 * Find out how many resources we may release.
 	 */
-	for (nr_ns = atomic_read(ldlm_namespace_nr(client));
+	for (nr_ns = ldlm_namespace_nr_read(client);
 	     nr_ns > 0; nr_ns--)
 	{
 		mutex_lock(ldlm_namespace_lock(client));
@@ -1063,8 +1064,23 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 			return 0;
 		}
 		ns = ldlm_namespace_first_locked(client);
+
+		if (ns == ns_old) {
+			mutex_unlock(ldlm_namespace_lock(client));
+			break;
+		}
+
+		if (ldlm_ns_empty(ns)) {
+			ldlm_namespace_move_to_inactive_locked(ns, client);
+			mutex_unlock(ldlm_namespace_lock(client));
+			continue;
+		}
+
+		if (ns_old == NULL)
+			ns_old = ns;
+
 		ldlm_namespace_get(ns);
-		ldlm_namespace_move_locked(ns, client);
+		ldlm_namespace_move_to_active_locked(ns, client);
 		mutex_unlock(ldlm_namespace_lock(client));
 		total += ldlm_pool_shrink(&ns->ns_pool, 0, gfp_mask);
 		ldlm_namespace_put(ns);
@@ -1078,7 +1094,7 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 	/*
 	 * Shrink at least ldlm_namespace_nr(client) namespaces.
 	 */
-	for (nr_ns = atomic_read(ldlm_namespace_nr(client));
+	for (nr_ns = ldlm_namespace_nr_read(client) - nr_ns;
 	     nr_ns > 0; nr_ns--)
 	{
 		int cancel, nr_locks;
@@ -1099,7 +1115,7 @@ static int ldlm_pools_shrink(ldlm_side_t client, int nr,
 		}
 		ns = ldlm_namespace_first_locked(client);
 		ldlm_namespace_get(ns);
-		ldlm_namespace_move_locked(ns, client);
+		ldlm_namespace_move_to_active_locked(ns, client);
 		mutex_unlock(ldlm_namespace_lock(client));
 
 		nr_locks = ldlm_pool_granted(&ns->ns_pool);
@@ -1132,6 +1148,7 @@ void ldlm_pools_recalc(ldlm_side_t client)
 {
 	__u32 nr_l = 0, nr_p = 0, l;
 	struct ldlm_namespace *ns;
+	struct ldlm_namespace *ns_old = NULL;
 	int nr, equal = 0;
 
 	/*
@@ -1190,16 +1207,14 @@ void ldlm_pools_recalc(ldlm_side_t client)
 				 * for _all_ pools.
 				 */
 				l = LDLM_POOL_HOST_L /
-					atomic_read(
-						ldlm_namespace_nr(client));
+					ldlm_namespace_nr_read(client);
 			} else {
 				/*
 				 * All the rest of greedy pools will have
 				 * all locks in equal parts.
 				 */
 				l = (LDLM_POOL_HOST_L - nr_l) /
-					(atomic_read(
-						ldlm_namespace_nr(client)) -
+					(ldlm_namespace_nr_read(client) -
 					 nr_p);
 			}
 			ldlm_pool_setup(&ns->ns_pool, l);
@@ -1210,7 +1225,7 @@ void ldlm_pools_recalc(ldlm_side_t client)
 	/*
 	 * Recalc at least ldlm_namespace_nr(client) namespaces.
 	 */
-	for (nr = atomic_read(ldlm_namespace_nr(client)); nr > 0; nr--) {
+	for (nr = ldlm_namespace_nr_read(client); nr > 0; nr--) {
 		int     skip;
 		/*
 		 * Lock the list, get first @ns in the list, getref, move it
@@ -1226,6 +1241,30 @@ void ldlm_pools_recalc(ldlm_side_t client)
 		}
 		ns = ldlm_namespace_first_locked(client);
 
+		if (ns_old == ns) { /* Full pass complete */
+			mutex_unlock(ldlm_namespace_lock(client));
+			break;
+		}
+
+		/* We got an empty namespace, need to move it back to inactive
+		 * list.
+		 * The race with parallel resource creation is fine:
+		 * - If they do namespace_get before our check, we fail the
+		 *   check and they move this item to the end of the list anyway
+		 * - If we do the check and then they do namespace_get, then
+		 *   we move the namespace to inactive and they will move
+		 *   it back to active (synchronised by the lock, so no clash
+		 *   there).
+		 */
+		if (ldlm_ns_empty(ns)) {
+			ldlm_namespace_move_to_inactive_locked(ns, client);
+			mutex_unlock(ldlm_namespace_lock(client));
+			continue;
+		}
+
+		if (ns_old == NULL)
+			ns_old = ns;
+
 		spin_lock(&ns->ns_lock);
 		/*
 		 * skip ns which is being freed, and we don't want to increase
@@ -1239,7 +1278,7 @@ void ldlm_pools_recalc(ldlm_side_t client)
 		}
 		spin_unlock(&ns->ns_lock);
 
-		ldlm_namespace_move_locked(ns, client);
+		ldlm_namespace_move_to_active_locked(ns, client);
 		mutex_unlock(ldlm_namespace_lock(client));
 
 		/*
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index cb8659f..7162838 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -48,14 +48,19 @@
 
 struct kmem_cache *ldlm_resource_slab, *ldlm_lock_slab;
 
-atomic_t ldlm_srv_namespace_nr = ATOMIC_INIT(0);
-atomic_t ldlm_cli_namespace_nr = ATOMIC_INIT(0);
+int ldlm_srv_namespace_nr = 0;
+int ldlm_cli_namespace_nr = 0;
 
 struct mutex ldlm_srv_namespace_lock;
 LIST_HEAD(ldlm_srv_namespace_list);
 
 struct mutex ldlm_cli_namespace_lock;
-LIST_HEAD(ldlm_cli_namespace_list);
+/* Client Namespaces that have active resources in them.
+ * Once all resources go away, ldlm_poold moves such namespaces to the
+ * inactive list */
+LIST_HEAD(ldlm_cli_active_namespace_list);
+/* Client namespaces that don't have any locks in them */
+LIST_HEAD(ldlm_cli_inactive_namespace_list);
 
 proc_dir_entry_t *ldlm_type_proc_dir = NULL;
 proc_dir_entry_t *ldlm_ns_proc_dir = NULL;
@@ -636,7 +641,7 @@ struct ldlm_namespace *ldlm_namespace_new(struct obd_device *obd, char *name,
 		GOTO(out_hash, rc);
 	}
 
-	idx = atomic_read(ldlm_namespace_nr(client));
+	idx = ldlm_namespace_nr_read(client);
 	rc = ldlm_pool_init(&ns->ns_pool, ns, idx, client);
 	if (rc) {
 		CERROR("Can't initialize lock pool, rc %d\n", rc);
@@ -953,6 +958,12 @@ void ldlm_namespace_get(struct ldlm_namespace *ns)
 }
 EXPORT_SYMBOL(ldlm_namespace_get);
 
+/* This is only for callers that care about refcount */
+int ldlm_namespace_get_return(struct ldlm_namespace *ns)
+{
+	return atomic_inc_return(&ns->ns_bref);
+}
+
 void ldlm_namespace_put(struct ldlm_namespace *ns)
 {
 	if (atomic_dec_and_lock(&ns->ns_bref, &ns->ns_lock)) {
@@ -967,8 +978,8 @@ void ldlm_namespace_register(struct ldlm_namespace *ns, ldlm_side_t client)
 {
 	mutex_lock(ldlm_namespace_lock(client));
 	LASSERT(list_empty(&ns->ns_list_chain));
-	list_add(&ns->ns_list_chain, ldlm_namespace_list(client));
-	atomic_inc(ldlm_namespace_nr(client));
+	list_add(&ns->ns_list_chain, ldlm_namespace_inactive_list(client));
+	ldlm_namespace_nr_inc(client);
 	mutex_unlock(ldlm_namespace_lock(client));
 }
 
@@ -981,12 +992,13 @@ void ldlm_namespace_unregister(struct ldlm_namespace *ns, ldlm_side_t client)
 	 * using list_empty(&ns->ns_list_chain). This is why it is
 	 * important to use list_del_init() here. */
 	list_del_init(&ns->ns_list_chain);
-	atomic_dec(ldlm_namespace_nr(client));
+	ldlm_namespace_nr_dec(client);
 	mutex_unlock(ldlm_namespace_lock(client));
 }
 
 /** Should be called with ldlm_namespace_lock(client) taken. */
-void ldlm_namespace_move_locked(struct ldlm_namespace *ns, ldlm_side_t client)
+void ldlm_namespace_move_to_active_locked(struct ldlm_namespace *ns,
+					  ldlm_side_t client)
 {
 	LASSERT(!list_empty(&ns->ns_list_chain));
 	LASSERT(mutex_is_locked(ldlm_namespace_lock(client)));
@@ -994,6 +1006,16 @@ void ldlm_namespace_move_locked(struct ldlm_namespace *ns, ldlm_side_t client)
 }
 
 /** Should be called with ldlm_namespace_lock(client) taken. */
+void ldlm_namespace_move_to_inactive_locked(struct ldlm_namespace *ns,
+					    ldlm_side_t client)
+{
+	LASSERT(!list_empty(&ns->ns_list_chain));
+	LASSERT(mutex_is_locked(ldlm_namespace_lock(client)));
+	list_move_tail(&ns->ns_list_chain,
+		       ldlm_namespace_inactive_list(client));
+}
+
+/** Should be called with ldlm_namespace_lock(client) taken. */
 struct ldlm_namespace *ldlm_namespace_first_locked(ldlm_side_t client)
 {
 	LASSERT(mutex_is_locked(ldlm_namespace_lock(client)));
@@ -1049,6 +1071,7 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 	struct ldlm_resource *res;
 	cfs_hash_bd_t	 bd;
 	__u64		 version;
+	int		      ns_refcount = 0;
 
 	LASSERT(ns != NULL);
 	LASSERT(parent == NULL);
@@ -1119,7 +1142,7 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 	/* We won! Let's add the resource. */
 	cfs_hash_bd_add_locked(ns->ns_rs_hash, &bd, &res->lr_hash);
 	if (cfs_hash_bd_count_get(&bd) == 1)
-		ldlm_namespace_get(ns);
+		ns_refcount = ldlm_namespace_get_return(ns);
 
 	cfs_hash_bd_unlock(ns->ns_rs_hash, &bd, 1);
 	if (ns->ns_lvbo && ns->ns_lvbo->lvbo_init) {
@@ -1145,6 +1168,20 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 	/* We create resource with locked lr_lvb_mutex. */
 	mutex_unlock(&res->lr_lvb_mutex);
 
+	/* Let's see if we happened to be the very first resource in this
+	 * namespace. If so, and this is a client namespace, we need to move
+	 * the namespace into the active namespaces list to be patrolled by
+	 * the ldlm_poold.
+	 * A notable exception, for quota namespaces qsd_lib.c already took a
+	 * namespace reference, so it won't be participating in all of this,
+	 * but I guess that's ok since we have no business cancelling quota
+	 * locks anyway */
+	if (ns_is_client(ns) && ns_refcount == 1) {
+		mutex_lock(ldlm_namespace_lock(LDLM_NAMESPACE_CLIENT));
+		ldlm_namespace_move_to_active_locked(ns, LDLM_NAMESPACE_CLIENT);
+		mutex_unlock(ldlm_namespace_lock(LDLM_NAMESPACE_CLIENT));
+	}
+
 	return res;
 }
 EXPORT_SYMBOL(ldlm_resource_get);
-- 
1.7.9.5

