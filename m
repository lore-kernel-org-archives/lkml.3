Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaIAUY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:24:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51896
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaIAUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:24:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,444,1406584800"; 
   d="scan'208";a="77358103"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 1/2] staging: lustre: ldlm: expand the GOTO macro
Date: Mon,  1 Sep 2014 22:21:09 +0200
Message-Id: <1409602870-4642-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
identifier rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   51 +++++++-----
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   49 +++++++----
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   34 ++++----
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   11 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   88 +++++++++++++--------
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   18 ++--
 6 files changed, 154 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 8307896..7701b2d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -74,8 +74,10 @@ static int import_set_conn(struct obd_import *imp, struct obd_uuid *uuid,
 
 	if (create) {
 		OBD_ALLOC(imp_conn, sizeof(*imp_conn));
-		if (!imp_conn)
-			GOTO(out_put, rc = -ENOMEM);
+		if (!imp_conn) {
+			rc = -ENOMEM;
+			goto out_put;
+		}
 	}
 
 	spin_lock(&imp->imp_lock);
@@ -91,7 +93,8 @@ static int import_set_conn(struct obd_import *imp, struct obd_uuid *uuid,
 			       imp, imp->imp_obd->obd_name, uuid->uuid,
 			       (priority ? ", moved to head" : ""));
 			spin_unlock(&imp->imp_lock);
-			GOTO(out_free, rc = 0);
+			rc = 0;
+			goto out_free;
 		}
 	}
 	/* No existing import connection found for \a uuid. */
@@ -109,7 +112,8 @@ static int import_set_conn(struct obd_import *imp, struct obd_uuid *uuid,
 		       (priority ? "head" : "tail"));
 	} else {
 		spin_unlock(&imp->imp_lock);
-		GOTO(out_free, rc = -ENOENT);
+		rc = -ENOENT;
+		goto out_free;
 	}
 
 	spin_unlock(&imp->imp_lock);
@@ -143,7 +147,7 @@ int client_import_del_conn(struct obd_import *imp, struct obd_uuid *uuid)
 	spin_lock(&imp->imp_lock);
 	if (list_empty(&imp->imp_conn_list)) {
 		LASSERT(!imp->imp_connection);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	list_for_each_entry(imp_conn, &imp->imp_conn_list, oic_item) {
@@ -157,7 +161,8 @@ int client_import_del_conn(struct obd_import *imp, struct obd_uuid *uuid)
 			if (imp->imp_state != LUSTRE_IMP_CLOSED &&
 			    imp->imp_state != LUSTRE_IMP_DISCON) {
 				CERROR("can't remove current connection\n");
-				GOTO(out, rc = -EBUSY);
+				rc = -EBUSY;
+				goto out;
 			}
 
 			ptlrpc_connection_put(imp->imp_connection);
@@ -398,15 +403,17 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	rc = ldlm_get_ref();
 	if (rc) {
 		CERROR("ldlm_get_ref failed: %d\n", rc);
-		GOTO(err, rc);
+		goto err;
 	}
 
 	ptlrpc_init_client(rq_portal, rp_portal, name,
 			   &obddev->obd_ldlm_client);
 
 	imp = class_new_import(obddev);
-	if (imp == NULL)
-		GOTO(err_ldlm, rc = -ENOENT);
+	if (imp == NULL) {
+		rc = -ENOENT;
+		goto err_ldlm;
+	}
 	imp->imp_client = &obddev->obd_ldlm_client;
 	imp->imp_connect_op = connect_op;
 	memcpy(cli->cl_target_uuid.uuid, lustre_cfg_buf(lcfg, 1),
@@ -416,7 +423,7 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	rc = client_import_add_conn(imp, &server_uuid, 1);
 	if (rc) {
 		CERROR("can't add initial connection\n");
-		GOTO(err_import, rc);
+		goto err_import;
 	}
 
 	cli->cl_import = imp;
@@ -442,7 +449,8 @@ int client_obd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg)
 	if (obddev->obd_namespace == NULL) {
 		CERROR("Unable to create client namespace - %s\n",
 		       obddev->obd_name);
-		GOTO(err_import, rc = -ENOMEM);
+		rc = -ENOMEM;
+		goto err_import;
 	}
 
 	cli->cl_qchk_stat = CL_NOT_QUOTACHECKED;
@@ -485,12 +493,14 @@ int client_connect_import(const struct lu_env *env,
 
 	*exp = NULL;
 	down_write(&cli->cl_sem);
-	if (cli->cl_conn_count > 0 )
-		GOTO(out_sem, rc = -EALREADY);
+	if (cli->cl_conn_count > 0) {
+		rc = -EALREADY;
+		goto out_sem;
+	}
 
 	rc = class_connect(&conn, obd, cluuid);
 	if (rc)
-		GOTO(out_sem, rc);
+		goto out_sem;
 
 	cli->cl_conn_count++;
 	*exp = class_conn2export(&conn);
@@ -500,7 +510,7 @@ int client_connect_import(const struct lu_env *env,
 	imp->imp_dlm_handle = conn;
 	rc = ptlrpc_init_import(imp);
 	if (rc != 0)
-		GOTO(out_ldlm, rc);
+		goto out_ldlm;
 
 	ocd = &imp->imp_connect_data;
 	if (data) {
@@ -511,7 +521,7 @@ int client_connect_import(const struct lu_env *env,
 	rc = ptlrpc_connect_import(imp);
 	if (rc != 0) {
 		LASSERT(imp->imp_state == LUSTRE_IMP_DISCON);
-		GOTO(out_ldlm, rc);
+		goto out_ldlm;
 	}
 	LASSERT(*exp != NULL && (*exp)->exp_connection);
 
@@ -560,12 +570,15 @@ int client_disconnect_export(struct obd_export *exp)
 	if (!cli->cl_conn_count) {
 		CERROR("disconnecting disconnected device (%s)\n",
 		       obd->obd_name);
-		GOTO(out_disconnect, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_disconnect;
 	}
 
 	cli->cl_conn_count--;
-	if (cli->cl_conn_count)
-		GOTO(out_disconnect, rc = 0);
+	if (cli->cl_conn_count) {
+		rc = 0;
+		goto out_disconnect;
+	}
 
 	/* Mark import deactivated now, so we don't try to reconnect if any
 	 * of the cleanup RPCs fails (e.g. LDLM cancel, etc).  We don't
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 7fa5d43..6140130 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -1254,18 +1254,26 @@ ldlm_mode_t ldlm_lock_match(struct ldlm_namespace *ns, __u64 flags,
 
 	lock = search_queue(&res->lr_granted, &mode, policy, old_lock,
 			    flags, unref);
-	if (lock != NULL)
-		GOTO(out, rc = 1);
-	if (flags & LDLM_FL_BLOCK_GRANTED)
-		GOTO(out, rc = 0);
+	if (lock != NULL) {
+		rc = 1;
+		goto out;
+	}
+	if (flags & LDLM_FL_BLOCK_GRANTED) {
+		rc = 0;
+		goto out;
+	}
 	lock = search_queue(&res->lr_converting, &mode, policy, old_lock,
 			    flags, unref);
-	if (lock != NULL)
-		GOTO(out, rc = 1);
+	if (lock != NULL) {
+		rc = 1;
+		goto out;
+	}
 	lock = search_queue(&res->lr_waiting, &mode, policy, old_lock,
 			    flags, unref);
-	if (lock != NULL)
-		GOTO(out, rc = 1);
+	if (lock != NULL) {
+		rc = 1;
+		goto out;
+	}
 
  out:
 	unlock_res(res);
@@ -1355,11 +1363,11 @@ ldlm_mode_t ldlm_revalidate_lock_handle(struct lustre_handle *lockh,
 	if (lock != NULL) {
 		lock_res_and_lock(lock);
 		if (lock->l_flags & LDLM_FL_GONE_MASK)
-			GOTO(out, mode);
+			goto out;
 
 		if (lock->l_flags & LDLM_FL_CBPENDING &&
 		    lock->l_readers == 0 && lock->l_writers == 0)
-			GOTO(out, mode);
+			goto out;
 
 		if (bits)
 			*bits = lock->l_policy_data.l_inodebits.bits;
@@ -1513,19 +1521,19 @@ struct ldlm_lock *ldlm_lock_create(struct ldlm_namespace *ns,
 	/* if this is the extent lock, allocate the interval tree node */
 	if (type == LDLM_EXTENT) {
 		if (ldlm_interval_alloc(lock) == NULL)
-			GOTO(out, 0);
+			goto out;
 	}
 
 	if (lvb_len) {
 		lock->l_lvb_len = lvb_len;
 		OBD_ALLOC(lock->l_lvb_data, lvb_len);
 		if (lock->l_lvb_data == NULL)
-			GOTO(out, 0);
+			goto out;
 	}
 
 	lock->l_lvb_type = lvb_type;
 	if (OBD_FAIL_CHECK(OBD_FAIL_LDLM_NEW_LOCK))
-		GOTO(out, 0);
+		goto out;
 
 	return lock;
 
@@ -1593,14 +1601,15 @@ ldlm_error_t ldlm_lock_enqueue(struct ldlm_namespace *ns,
 		 * need to do anything else. */
 		*flags &= ~(LDLM_FL_BLOCK_GRANTED |
 			    LDLM_FL_BLOCK_CONV | LDLM_FL_BLOCK_WAIT);
-		GOTO(out, ELDLM_OK);
+		goto out;
 	}
 
 	ldlm_resource_unlink_lock(lock);
 	if (res->lr_type == LDLM_EXTENT && lock->l_tree_node == NULL) {
 		if (node == NULL) {
 			ldlm_lock_destroy_nolock(lock);
-			GOTO(out, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto out;
 		}
 
 		INIT_LIST_HEAD(&node->li_group);
@@ -1630,7 +1639,7 @@ ldlm_error_t ldlm_lock_enqueue(struct ldlm_namespace *ns,
 			ldlm_resource_add_lock(res, &res->lr_waiting, lock);
 		else
 			ldlm_grant_lock(lock, NULL);
-		GOTO(out, ELDLM_OK);
+		goto out;
 	} else {
 		CERROR("This is client-side-only module, cannot handle "
 		       "LDLM_NAMESPACE_SERVER resource type lock.\n");
@@ -1837,14 +1846,16 @@ int ldlm_run_ast_work(struct ldlm_namespace *ns, struct list_head *rpc_list,
 	 * to keep the number of requests in flight to ns_max_parallel_ast */
 	arg->set = ptlrpc_prep_fcset(ns->ns_max_parallel_ast ? : UINT_MAX,
 				     work_ast_lock, arg);
-	if (arg->set == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (arg->set == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	ptlrpc_set_wait(arg->set);
 	ptlrpc_set_destroy(arg->set);
 
 	rc = atomic_read(&arg->restart) ? -ERESTART : 0;
-	GOTO(out, rc);
+	goto out;
 out:
 	OBD_FREE_PTR(arg);
 	return rc;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 952e10e..91cf7eb 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -202,7 +202,8 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 	lvb_len = req_capsule_get_size(&req->rq_pill, &RMF_DLM_LVB, RCL_CLIENT);
 	if (lvb_len < 0) {
 		LDLM_ERROR(lock, "Fail to get lvb_len, rc = %d", lvb_len);
-		GOTO(out, rc = lvb_len);
+		rc = lvb_len;
+		goto out;
 	} else if (lvb_len > 0) {
 		if (lock->l_lvb_len > 0) {
 			/* for extent lock, lvb contains ost_lvb{}. */
@@ -213,7 +214,8 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 					   "expectation, expected = %d, "
 					   "replied = %d",
 					   lock->l_lvb_len, lvb_len);
-				GOTO(out, rc = -EINVAL);
+				rc = -EINVAL;
+				goto out;
 			}
 		} else if (ldlm_has_layout(lock)) { /* for layout lock, lvb has
 						     * variable length */
@@ -222,7 +224,8 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 			OBD_ALLOC(lvb_data, lvb_len);
 			if (lvb_data == NULL) {
 				LDLM_ERROR(lock, "No memory: %d.\n", lvb_len);
-				GOTO(out, rc = -ENOMEM);
+				rc = -ENOMEM;
+				goto out;
 			}
 
 			lock_res_and_lock(lock);
@@ -240,7 +243,8 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 		/* bug 11300: the lock has already been granted */
 		unlock_res_and_lock(lock);
 		LDLM_DEBUG(lock, "Double grant race happened");
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	/* If we receive the completion AST before the actual enqueue returned,
@@ -267,7 +271,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 				&dlm_req->lock_desc.l_resource.lr_name);
 		if (rc < 0) {
 			LDLM_ERROR(lock, "Failed to allocate resource");
-			GOTO(out, rc);
+			goto out;
 		}
 		LDLM_DEBUG(lock, "completion AST, new resource");
 		CERROR("change resource!\n");
@@ -287,7 +291,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 				   lock->l_lvb_data, lvb_len);
 		if (rc < 0) {
 			unlock_res_and_lock(lock);
-			GOTO(out, rc);
+			goto out;
 		}
 	}
 
@@ -304,7 +308,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 
 	LDLM_DEBUG_NOLOCK("client completion callback handler END (lock %p)",
 			  lock);
-	GOTO(out, rc);
+	goto out;
 
 out:
 	if (rc < 0) {
@@ -980,7 +984,7 @@ int ldlm_init_export(struct obd_export *exp)
 
 	rc = ldlm_init_flock_export(exp);
 	if (rc)
-		GOTO(err, rc);
+		goto err;
 
 	return 0;
 err:
@@ -1014,7 +1018,7 @@ static int ldlm_setup(void)
 
 	rc = ldlm_proc_setup();
 	if (rc != 0)
-		GOTO(out, rc);
+		goto out;
 
 	memset(&conf, 0, sizeof(conf));
 	conf = (typeof(conf)) {
@@ -1051,13 +1055,15 @@ static int ldlm_setup(void)
 		CERROR("failed to start service\n");
 		rc = PTR_ERR(ldlm_state->ldlm_cb_service);
 		ldlm_state->ldlm_cb_service = NULL;
-		GOTO(out, rc);
+		goto out;
 	}
 
 
 	OBD_ALLOC(blp, sizeof(*blp));
-	if (blp == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (blp == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	ldlm_state->ldlm_bl_pool = blp;
 
 	spin_lock_init(&blp->blp_lock);
@@ -1079,14 +1085,14 @@ static int ldlm_setup(void)
 	for (i = 0; i < blp->blp_min_threads; i++) {
 		rc = ldlm_bl_thread_start(blp);
 		if (rc < 0)
-			GOTO(out, rc);
+			goto out;
 	}
 
 
 	rc = ldlm_pools_init();
 	if (rc) {
 		CERROR("Failed to initialize LDLM pools: %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 	return 0;
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 150b44d..37f1973 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -735,7 +735,8 @@ static int ldlm_pool_proc_init(struct ldlm_pool *pl)
 	if (parent_ns_proc == NULL) {
 		CERROR("%s: proc entry is not initialized\n",
 		       ldlm_ns_name(ns));
-		GOTO(out_free_name, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_free_name;
 	}
 	pl->pl_proc_dir = lprocfs_register("pool", parent_ns_proc,
 					   NULL, NULL);
@@ -743,7 +744,7 @@ static int ldlm_pool_proc_init(struct ldlm_pool *pl)
 		CERROR("LProcFS failed in ldlm-pool-init\n");
 		rc = PTR_ERR(pl->pl_proc_dir);
 		pl->pl_proc_dir = NULL;
-		GOTO(out_free_name, rc);
+		goto out_free_name;
 	}
 
 	var_name[MAX_STRING_SIZE] = '\0';
@@ -767,8 +768,10 @@ static int ldlm_pool_proc_init(struct ldlm_pool *pl)
 
 	pl->pl_stats = lprocfs_alloc_stats(LDLM_POOL_LAST_STAT -
 					   LDLM_POOL_FIRST_STAT, 0);
-	if (!pl->pl_stats)
-		GOTO(out_free_name, rc = -ENOMEM);
+	if (!pl->pl_stats) {
+		rc = -ENOMEM;
+		goto out_free_name;
+	}
 
 	lprocfs_counter_init(pl->pl_stats, LDLM_POOL_GRANTED_STAT,
 			     LPROCFS_CNTR_AVGMINMAX | LPROCFS_CNTR_STDDEV,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 07de715..655a1c7 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -423,8 +423,10 @@ int ldlm_cli_enqueue_local(struct ldlm_namespace *ns,
 
 	lock = ldlm_lock_create(ns, res_id, type, mode, &cbs, data, lvb_len,
 				lvb_type);
-	if (unlikely(!lock))
-		GOTO(out_nolock, err = -ENOMEM);
+	if (unlikely(!lock)) {
+		err = -ENOMEM;
+		goto out_nolock;
+	}
 
 	ldlm_lock2handle(lock, lockh);
 
@@ -444,7 +446,7 @@ int ldlm_cli_enqueue_local(struct ldlm_namespace *ns,
 
 	err = ldlm_lock_enqueue(ns, &lock, policy, flags);
 	if (unlikely(err != ELDLM_OK))
-		GOTO(out, err);
+		goto out;
 
 	if (policy != NULL)
 		*policy = lock->l_policy_data;
@@ -535,13 +537,15 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 			   rc == ELDLM_LOCK_ABORTED ? "ABORTED" : "FAILED");
 
 		if (rc != ELDLM_LOCK_ABORTED)
-			GOTO(cleanup, rc);
+			goto cleanup;
 	}
 
 	/* Before we return, swab the reply */
 	reply = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
-	if (reply == NULL)
-		GOTO(cleanup, rc = -EPROTO);
+	if (reply == NULL) {
+		rc = -EPROTO;
+		goto cleanup;
+	}
 
 	if (lvb_len != 0) {
 		LASSERT(lvb != NULL);
@@ -550,12 +554,14 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 					    RCL_SERVER);
 		if (size < 0) {
 			LDLM_ERROR(lock, "Fail to get lvb_len, rc = %d", size);
-			GOTO(cleanup, rc = size);
+			rc = size;
+			goto cleanup;
 		} else if (unlikely(size > lvb_len)) {
 			LDLM_ERROR(lock, "Replied LVB is larger than "
 				   "expectation, expected = %d, replied = %d",
 				   lvb_len, size);
-			GOTO(cleanup, rc = -EINVAL);
+			rc = -EINVAL;
+			goto cleanup;
 		}
 	}
 
@@ -563,7 +569,8 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 		if (lvb_len != 0)
 			rc = ldlm_fill_lvb(lock, &req->rq_pill, RCL_SERVER,
 					   lvb, size);
-		GOTO(cleanup, rc = (rc != 0 ? rc : ELDLM_LOCK_ABORTED));
+		rc = (rc != 0 ? rc : ELDLM_LOCK_ABORTED);
+		goto cleanup;
 	}
 
 	/* lock enqueued on the server */
@@ -616,8 +623,10 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 
 			rc = ldlm_lock_change_resource(ns, lock,
 					&reply->lock_desc.l_resource.lr_name);
-			if (rc || lock->l_resource == NULL)
-				GOTO(cleanup, rc = -ENOMEM);
+			if (rc || lock->l_resource == NULL) {
+				rc = -ENOMEM;
+				goto cleanup;
+			}
 			LDLM_DEBUG(lock, "client-side enqueue, new resource");
 		}
 		if (with_policy)
@@ -658,7 +667,7 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 		unlock_res_and_lock(lock);
 		if (rc < 0) {
 			cleanup_phase = 1;
-			GOTO(cleanup, rc);
+			goto cleanup;
 		}
 	}
 
@@ -1037,14 +1046,18 @@ int ldlm_cli_convert(struct lustre_handle *lockh, int new_mode, __u32 *flags)
 	ptlrpc_request_set_replen(req);
 	rc = ptlrpc_queue_wait(req);
 	if (rc != ELDLM_OK)
-		GOTO(out, rc);
+		goto out;
 
 	reply = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
-	if (reply == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (reply == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
-	if (req->rq_status)
-		GOTO(out, rc = req->rq_status);
+	if (req->rq_status) {
+		rc = req->rq_status;
+		goto out;
+	}
 
 	res = ldlm_lock_convert(lock, new_mode, &reply->lock_flags);
 	if (res != NULL) {
@@ -1055,7 +1068,7 @@ int ldlm_cli_convert(struct lustre_handle *lockh, int new_mode, __u32 *flags)
 			rc = lock->l_completion_ast(lock, LDLM_FL_WAIT_NOREPROC,
 						    NULL);
 			if (rc)
-				GOTO(out, rc);
+				goto out;
 		}
 	} else {
 		rc = LUSTRE_EDEADLK;
@@ -1179,8 +1192,10 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 		}
 
 		req = ptlrpc_request_alloc(imp, &RQF_LDLM_CANCEL);
-		if (req == NULL)
-			GOTO(out, rc = -ENOMEM);
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		req_capsule_filled_sizes(&req->rq_pill, RCL_CLIENT);
 		req_capsule_set_size(&req->rq_pill, &RMF_DLM_REQ, RCL_CLIENT,
@@ -1189,7 +1204,7 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 		rc = ptlrpc_request_pack(req, LUSTRE_DLM_VERSION, LDLM_CANCEL);
 		if (rc) {
 			ptlrpc_request_free(req);
-			GOTO(out, rc);
+			goto out;
 		}
 
 		req->rq_request_portal = LDLM_CANCEL_REQUEST_PORTAL;
@@ -1202,7 +1217,7 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 		if (flags & LCF_ASYNC) {
 			ptlrpcd_add_req(req, PDL_POLICY_LOCAL, -1);
 			sent = count;
-			GOTO(out, 0);
+			goto out;
 		} else {
 			rc = ptlrpc_queue_wait(req);
 		}
@@ -1961,22 +1976,28 @@ int ldlm_resource_foreach(struct ldlm_resource *res, ldlm_iterator_t iter,
 	list_for_each_safe(tmp, next, &res->lr_granted) {
 		lock = list_entry(tmp, struct ldlm_lock, l_res_link);
 
-		if (iter(lock, closure) == LDLM_ITER_STOP)
-			GOTO(out, rc = LDLM_ITER_STOP);
+		if (iter(lock, closure) == LDLM_ITER_STOP) {
+			rc = LDLM_ITER_STOP;
+			goto out;
+		}
 	}
 
 	list_for_each_safe(tmp, next, &res->lr_converting) {
 		lock = list_entry(tmp, struct ldlm_lock, l_res_link);
 
-		if (iter(lock, closure) == LDLM_ITER_STOP)
-			GOTO(out, rc = LDLM_ITER_STOP);
+		if (iter(lock, closure) == LDLM_ITER_STOP) {
+			rc = LDLM_ITER_STOP;
+			goto out;
+		}
 	}
 
 	list_for_each_safe(tmp, next, &res->lr_waiting) {
 		lock = list_entry(tmp, struct ldlm_lock, l_res_link);
 
-		if (iter(lock, closure) == LDLM_ITER_STOP)
-			GOTO(out, rc = LDLM_ITER_STOP);
+		if (iter(lock, closure) == LDLM_ITER_STOP) {
+			rc = LDLM_ITER_STOP;
+			goto out;
+		}
 	}
  out:
 	unlock_res(res);
@@ -2081,12 +2102,14 @@ static int replay_lock_interpret(const struct lu_env *env,
 
 	atomic_dec(&req->rq_import->imp_replay_inflight);
 	if (rc != ELDLM_OK)
-		GOTO(out, rc);
+		goto out;
 
 
 	reply = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
-	if (reply == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (reply == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	lock = ldlm_handle2lock(&aa->lock_handle);
 	if (!lock) {
@@ -2095,7 +2118,8 @@ static int replay_lock_interpret(const struct lu_env *env,
 		       aa->lock_handle.cookie, reply->lock_handle.cookie,
 		       req->rq_export->exp_client_uuid.uuid,
 		       libcfs_id2str(req->rq_peer));
-		GOTO(out, rc = -ESTALE);
+		rc = -ESTALE;
+		goto out;
 	}
 
 	/* Key change rehash lock in per-export hash with new key */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 8fec984..a785b7a 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -102,7 +102,7 @@ int ldlm_proc_setup(void)
 	if (IS_ERR(ldlm_type_proc_dir)) {
 		CERROR("LProcFS failed in ldlm-init\n");
 		rc = PTR_ERR(ldlm_type_proc_dir);
-		GOTO(err, rc);
+		goto err;
 	}
 
 	ldlm_ns_proc_dir = lprocfs_register("namespaces",
@@ -111,7 +111,7 @@ int ldlm_proc_setup(void)
 	if (IS_ERR(ldlm_ns_proc_dir)) {
 		CERROR("LProcFS failed in ldlm-init\n");
 		rc = PTR_ERR(ldlm_ns_proc_dir);
-		GOTO(err_type, rc);
+		goto err_type;
 	}
 
 	ldlm_svc_proc_dir = lprocfs_register("services",
@@ -120,7 +120,7 @@ int ldlm_proc_setup(void)
 	if (IS_ERR(ldlm_svc_proc_dir)) {
 		CERROR("LProcFS failed in ldlm-init\n");
 		rc = PTR_ERR(ldlm_svc_proc_dir);
-		GOTO(err_ns, rc);
+		goto err_ns;
 	}
 
 	rc = lprocfs_add_vars(ldlm_type_proc_dir, list, NULL);
@@ -580,7 +580,7 @@ struct ldlm_namespace *ldlm_namespace_new(struct obd_device *obd, char *name,
 		nsd = &ldlm_ns_hash_defs[idx];
 		if (nsd->nsd_type == LDLM_NS_TYPE_UNKNOWN) {
 			CERROR("Unknown type %d for ns %s\n", ns_type, name);
-			GOTO(out_ref, NULL);
+			goto out_ref;
 		}
 
 		if (nsd->nsd_type == ns_type)
@@ -589,7 +589,7 @@ struct ldlm_namespace *ldlm_namespace_new(struct obd_device *obd, char *name,
 
 	OBD_ALLOC_PTR(ns);
 	if (!ns)
-		GOTO(out_ref, NULL);
+		goto out_ref;
 
 	ns->ns_rs_hash = cfs_hash_create(name,
 					 nsd->nsd_all_bits, nsd->nsd_all_bits,
@@ -602,7 +602,7 @@ struct ldlm_namespace *ldlm_namespace_new(struct obd_device *obd, char *name,
 					 CFS_HASH_SPIN_BKTLOCK |
 					 CFS_HASH_NO_ITEMREF);
 	if (ns->ns_rs_hash == NULL)
-		GOTO(out_ns, NULL);
+		goto out_ns;
 
 	cfs_hash_for_each_bucket(ns->ns_rs_hash, &bd, idx) {
 		nsb = cfs_hash_bd_extra_get(ns->ns_rs_hash, &bd);
@@ -636,14 +636,14 @@ struct ldlm_namespace *ldlm_namespace_new(struct obd_device *obd, char *name,
 	rc = ldlm_namespace_proc_register(ns);
 	if (rc != 0) {
 		CERROR("Can't initialize ns proc, rc %d\n", rc);
-		GOTO(out_hash, rc);
+		goto out_hash;
 	}
 
 	idx = ldlm_namespace_nr_read(client);
 	rc = ldlm_pool_init(&ns->ns_pool, ns, idx, client);
 	if (rc) {
 		CERROR("Can't initialize lock pool, rc %d\n", rc);
-		GOTO(out_proc, rc);
+		goto out_proc;
 	}
 
 	ldlm_namespace_register(ns, client);
@@ -822,7 +822,7 @@ force_wait:
 				       "namespace with %d resources in use, "
 				       "(rc=%d)\n", ldlm_ns_name(ns),
 				       atomic_read(&ns->ns_bref), rc);
-			GOTO(force_wait, rc);
+			goto force_wait;
 		}
 
 		if (atomic_read(&ns->ns_bref)) {

