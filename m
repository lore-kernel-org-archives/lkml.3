Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaCACRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:22 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42598 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaCACRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:19 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Hongchao Zhang <hongchao.zhang@intel.com>, Niu Yawei <yawei.niu@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 08/17] lustre/recovery: free open/close request promptly
Date: Fri, 28 Feb 2014 21:16:37 -0500
Message-Id: <1393640206-20286-9-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongchao Zhang <hongchao.zhang@intel.com>

- For the non-create open or committed open, the open request
  should be freed along with the close request as soon as the
  close done, despite that the transno of open/close is
  greater than the last committed transno known by client or not.

- Move the committed open request into another dedicated list,
  that will avoid scanning a huge replay list on receiving each
  reply (when there are many open files).

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Hongchao Zhang <hongchao.zhang@intel.com>
Reviewed-on: http://review.whamcloud.com/6665
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2613
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |  6 +-
 .../staging/lustre/lustre/include/lustre_export.h  |  9 +++
 .../staging/lustre/lustre/include/lustre_import.h  | 11 +++
 drivers/staging/lustre/lustre/include/lustre_net.h |  2 +
 drivers/staging/lustre/lustre/include/obd.h        |  5 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  4 +-
 drivers/staging/lustre/lustre/llite/file.c         |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  3 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  4 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |  1 +
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 27 +++++++-
 drivers/staging/lustre/lustre/obdclass/genops.c    |  2 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |  1 +
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 78 +++++++++++++++++-----
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 33 ++++++---
 drivers/staging/lustre/lustre/ptlrpc/recover.c     | 57 +++++++++++++---
 18 files changed, 198 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 4c70c06..a55eebf 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1305,6 +1305,7 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 #define OBD_CONNECT_SHORTIO     0x2000000000000ULL/* short io */
 #define OBD_CONNECT_PINGLESS	0x4000000000000ULL/* pings not required */
 #define OBD_CONNECT_FLOCK_DEAD	0x8000000000000ULL/* flock deadlock detection */
+#define OBD_CONNECT_DISP_STRIPE 0x10000000000000ULL/*create stripe disposition*/
 
 /* XXX README XXX:
  * Please DO NOT add flag values here before first ensuring that this same
@@ -1344,7 +1345,9 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 				OBD_CONNECT_LIGHTWEIGHT | OBD_CONNECT_UMASK | \
 				OBD_CONNECT_LVB_TYPE | OBD_CONNECT_LAYOUTLOCK |\
 				OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE |\
-				OBD_CONNECT_FLOCK_DEAD)
+				OBD_CONNECT_FLOCK_DEAD | \
+				OBD_CONNECT_DISP_STRIPE)
+
 #define OST_CONNECT_SUPPORTED  (OBD_CONNECT_SRVLOCK | OBD_CONNECT_GRANT | \
 				OBD_CONNECT_REQPORTAL | OBD_CONNECT_VERSION | \
 				OBD_CONNECT_TRUNCLOCK | OBD_CONNECT_INDEX | \
@@ -2114,6 +2117,7 @@ extern void lustre_swab_generic_32s (__u32 *val);
 #define DISP_ENQ_CREATE_REF  0x01000000
 #define DISP_OPEN_LOCK       0x02000000
 #define DISP_OPEN_LEASE      0x04000000
+#define DISP_OPEN_STRIPE     0x08000000
 
 /* INODE LOCK PARTS */
 #define MDS_INODELOCK_LOOKUP 0x000001	/* For namespace, dentry etc, and also
diff --git a/drivers/staging/lustre/lustre/include/lustre_export.h b/drivers/staging/lustre/lustre/include/lustre_export.h
index 82a230b..6f7f48c 100644
--- a/drivers/staging/lustre/lustre/include/lustre_export.h
+++ b/drivers/staging/lustre/lustre/include/lustre_export.h
@@ -388,6 +388,15 @@ static inline __u64 exp_connect_ibits(struct obd_export *exp)
 	return ocd->ocd_ibits_known;
 }
 
+static inline bool imp_connect_disp_stripe(struct obd_import *imp)
+{
+	struct obd_connect_data *ocd;
+
+	LASSERT(imp != NULL);
+	ocd = &imp->imp_connect_data;
+	return ocd->ocd_connect_flags & OBD_CONNECT_DISP_STRIPE;
+}
+
 extern struct obd_export *class_conn2export(struct lustre_handle *conn);
 extern struct obd_device *class_conn2obd(struct lustre_handle *conn);
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index 67259eb..e9833ae 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -180,6 +180,17 @@ struct obd_import {
 	struct list_head		imp_delayed_list;
 	/** @} */
 
+	/**
+	 * List of requests that are retained for committed open replay. Once
+	 * open is committed, open replay request will be moved from the
+	 * imp_replay_list into the imp_committed_list.
+	 * The imp_replay_cursor is for accelerating searching during replay.
+	 * @{
+	 */
+	struct list_head		imp_committed_list;
+	struct list_head	       *imp_replay_cursor;
+	/** @} */
+
 	/** obd device for this import */
 	struct obd_device	*imp_obd;
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d8d0880..11382ab 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -2621,6 +2621,8 @@ int ptlrpc_register_rqbd(struct ptlrpc_request_buffer_desc *rqbd);
  * request queues, request management, etc.
  * @{
  */
+void ptlrpc_request_committed(struct ptlrpc_request *req, int force);
+
 void ptlrpc_init_client(int req_portal, int rep_portal, char *name,
 			struct ptlrpc_client *);
 void ptlrpc_cleanup_client(struct obd_import *imp);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index c3470ce..1b38695 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1323,7 +1323,8 @@ struct md_open_data {
 	struct obd_client_handle *mod_och;
 	struct ptlrpc_request    *mod_open_req;
 	struct ptlrpc_request    *mod_close_req;
-	atomic_t	      mod_refcount;
+	atomic_t		  mod_refcount;
+	bool			  mod_is_create;
 };
 
 struct lookup_intent;
@@ -1392,7 +1393,7 @@ struct md_ops {
 
 	int (*m_set_open_replay_data)(struct obd_export *,
 				      struct obd_client_handle *,
-				      struct ptlrpc_request *);
+				      struct lookup_intent *);
 	int (*m_clear_open_replay_data)(struct obd_export *,
 					struct obd_client_handle *);
 	int (*m_set_lock_data)(struct obd_export *, __u64 *, void *, __u64 *);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 1c2ba19..0a18820 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -2001,11 +2001,11 @@ static inline int md_getxattr(struct obd_export *exp,
 
 static inline int md_set_open_replay_data(struct obd_export *exp,
 					  struct obd_client_handle *och,
-					  struct ptlrpc_request *open_req)
+					  struct lookup_intent *it)
 {
 	EXP_CHECK_MD_OP(exp, set_open_replay_data);
 	EXP_MD_COUNTER_INCREMENT(exp, set_open_replay_data);
-	return MDP(exp->exp_obd, set_open_replay_data)(exp, och, open_req);
+	return MDP(exp->exp_obd, set_open_replay_data)(exp, och, it);
 }
 
 static inline int md_clear_open_replay_data(struct obd_export *exp,
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 362f5ec..7ceec74 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -480,7 +480,7 @@ static int ll_och_fill(struct obd_export *md_exp, struct lookup_intent *it,
 	och->och_magic = OBD_CLIENT_HANDLE_MAGIC;
 	och->och_flags = it->it_flags;
 
-	return md_set_open_replay_data(md_exp, och, req);
+	return md_set_open_replay_data(md_exp, och, it);
 }
 
 int ll_local_open(struct file *file, struct lookup_intent *it,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 85c01e1..7427f69 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -208,7 +208,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				  OBD_CONNECT_LAYOUTLOCK |
 				  OBD_CONNECT_PINGLESS |
 				  OBD_CONNECT_MAX_EASIZE |
-				  OBD_CONNECT_FLOCK_DEAD;
+				  OBD_CONNECT_FLOCK_DEAD |
+				  OBD_CONNECT_DISP_STRIPE;
 
 	if (sbi->ll_flags & LL_SBI_SOM_PREVIEW)
 		data->ocd_connect_flags |= OBD_CONNECT_SOM;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 1bddd8f..40fbd44 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -2593,7 +2593,7 @@ int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
 
 int lmv_set_open_replay_data(struct obd_export *exp,
 			     struct obd_client_handle *och,
-			     struct ptlrpc_request *open_req)
+			     struct lookup_intent *it)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2603,7 +2603,7 @@ int lmv_set_open_replay_data(struct obd_export *exp,
 	if (IS_ERR(tgt))
 		return PTR_ERR(tgt);
 
-	return md_set_open_replay_data(tgt->ltd_exp, och, open_req);
+	return md_set_open_replay_data(tgt->ltd_exp, och, it);
 }
 
 int lmv_clear_open_replay_data(struct obd_export *exp,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index fc21777..c78bf00 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -122,7 +122,7 @@ int mdc_free_lustre_md(struct obd_export *exp, struct lustre_md *md);
 
 int mdc_set_open_replay_data(struct obd_export *exp,
 			     struct obd_client_handle *och,
-			     struct ptlrpc_request *open_req);
+			     struct lookup_intent *it);
 
 int mdc_clear_open_replay_data(struct obd_export *exp,
 			       struct obd_client_handle *och);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 6110943..20706e7 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -641,7 +641,7 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 			 * happens immediately after swabbing below, new reply
 			 * is swabbed by that handler correctly.
 			 */
-			mdc_set_open_replay_data(NULL, NULL, req);
+			mdc_set_open_replay_data(NULL, NULL, it);
 		}
 
 		if ((body->valid & (OBD_MD_FLDIREA | OBD_MD_FLEASIZE)) != 0) {
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index 1aea154..d79aa16 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -165,6 +165,7 @@ int mdc_setattr(struct obd_export *exp, struct md_op_data *op_data,
 			req->rq_cb_data = *mod;
 			(*mod)->mod_open_req = req;
 			req->rq_commit_cb = mdc_commit_open;
+			(*mod)->mod_is_create = true;
 			/**
 			 * Take an extra reference on \var mod, it protects \var
 			 * mod from being freed on eviction (commit callback is
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 17c8e14..d9ddb39 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -722,11 +722,12 @@ void mdc_commit_open(struct ptlrpc_request *req)
 
 int mdc_set_open_replay_data(struct obd_export *exp,
 			     struct obd_client_handle *och,
-			     struct ptlrpc_request *open_req)
+			     struct lookup_intent *it)
 {
 	struct md_open_data   *mod;
 	struct mdt_rec_create *rec;
 	struct mdt_body       *body;
+	struct ptlrpc_request *open_req = it->d.lustre.it_data;
 	struct obd_import     *imp = open_req->rq_import;
 
 	if (!open_req->rq_replay)
@@ -760,6 +761,8 @@ int mdc_set_open_replay_data(struct obd_export *exp,
 		spin_lock(&open_req->rq_lock);
 		och->och_mod = mod;
 		mod->mod_och = och;
+		mod->mod_is_create = it_disposition(it, DISP_OPEN_CREATE) ||
+				     it_disposition(it, DISP_OPEN_STRIPE);
 		mod->mod_open_req = open_req;
 		open_req->rq_cb_data = mod;
 		open_req->rq_commit_cb = mdc_commit_open;
@@ -780,6 +783,23 @@ int mdc_set_open_replay_data(struct obd_export *exp,
 	return 0;
 }
 
+static void mdc_free_open(struct md_open_data *mod)
+{
+	int committed = 0;
+
+	if (mod->mod_is_create == 0 &&
+	    imp_connect_disp_stripe(mod->mod_open_req->rq_import))
+		committed = 1;
+
+	LASSERT(mod->mod_open_req->rq_replay == 0);
+
+	DEBUG_REQ(D_RPCTRACE, mod->mod_open_req, "free open request\n");
+
+	ptlrpc_request_committed(mod->mod_open_req, committed);
+	if (mod->mod_close_req)
+		ptlrpc_request_committed(mod->mod_close_req, committed);
+}
+
 int mdc_clear_open_replay_data(struct obd_export *exp,
 			       struct obd_client_handle *och)
 {
@@ -793,6 +813,8 @@ int mdc_clear_open_replay_data(struct obd_export *exp,
 		return 0;
 
 	LASSERT(mod != LP_POISON);
+	LASSERT(mod->mod_open_req != NULL);
+	mdc_free_open(mod);
 
 	mod->mod_och = NULL;
 	och->och_mod = NULL;
@@ -991,6 +1013,9 @@ int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
 	if (mod) {
 		if (rc != 0)
 			mod->mod_close_req = NULL;
+		LASSERT(mod->mod_open_req != NULL);
+		mdc_free_open(mod);
+
 		/* Since now, mod is accessed through setattr req only,
 		 * thus DW req does not keep a reference on mod anymore. */
 		obd_mod_put(mod);
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index d27f041..169c9ed 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -1010,6 +1010,8 @@ struct obd_import *class_new_import(struct obd_device *obd)
 	INIT_LIST_HEAD(&imp->imp_replay_list);
 	INIT_LIST_HEAD(&imp->imp_sending_list);
 	INIT_LIST_HEAD(&imp->imp_delayed_list);
+	INIT_LIST_HEAD(&imp->imp_committed_list);
+	imp->imp_replay_cursor = &imp->imp_committed_list;
 	spin_lock_init(&imp->imp_lock);
 	imp->imp_last_success_conn = 0;
 	imp->imp_state = LUSTRE_IMP_NEW;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 6e7d2e5..1432dd7 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -99,6 +99,7 @@ static const char * const obd_connect_names[] = {
 	"short_io",
 	"pingless",
 	"flock_deadlock",
+	"disp_stripe",
 	"unknown",
 	NULL
 };
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index eb33bb7..a32b722 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2360,6 +2360,39 @@ int ptlrpc_unregister_reply(struct ptlrpc_request *request, int async)
 }
 EXPORT_SYMBOL(ptlrpc_unregister_reply);
 
+static void ptlrpc_free_request(struct ptlrpc_request *req)
+{
+	spin_lock(&req->rq_lock);
+	req->rq_replay = 0;
+	spin_unlock(&req->rq_lock);
+
+	if (req->rq_commit_cb != NULL)
+		req->rq_commit_cb(req);
+	list_del_init(&req->rq_replay_list);
+
+	__ptlrpc_req_finished(req, 1);
+}
+
+/**
+ * the request is committed and dropped from the replay list of its import
+ */
+void ptlrpc_request_committed(struct ptlrpc_request *req, int force)
+{
+	struct obd_import	*imp = req->rq_import;
+
+	spin_lock(&imp->imp_lock);
+	if (list_empty(&req->rq_replay_list)) {
+		spin_unlock(&imp->imp_lock);
+		return;
+	}
+
+	if (force || req->rq_transno <= imp->imp_peer_committed_transno)
+		ptlrpc_free_request(req);
+
+	spin_unlock(&imp->imp_lock);
+}
+EXPORT_SYMBOL(ptlrpc_request_committed);
+
 /**
  * Iterates through replay_list on import and prunes
  * all requests have transno smaller than last_committed for the
@@ -2370,9 +2403,9 @@ EXPORT_SYMBOL(ptlrpc_unregister_reply);
  */
 void ptlrpc_free_committed(struct obd_import *imp)
 {
-	struct list_head *tmp, *saved;
-	struct ptlrpc_request *req;
+	struct ptlrpc_request *req, *saved;
 	struct ptlrpc_request *last_req = NULL; /* temporary fire escape */
+	bool		       skip_committed_list = true;
 
 	LASSERT(imp != NULL);
 
@@ -2388,13 +2421,15 @@ void ptlrpc_free_committed(struct obd_import *imp)
 	CDEBUG(D_RPCTRACE, "%s: committing for last_committed "LPU64" gen %d\n",
 	       imp->imp_obd->obd_name, imp->imp_peer_committed_transno,
 	       imp->imp_generation);
+
+	if (imp->imp_generation != imp->imp_last_generation_checked)
+		skip_committed_list = false;
+
 	imp->imp_last_transno_checked = imp->imp_peer_committed_transno;
 	imp->imp_last_generation_checked = imp->imp_generation;
 
-	list_for_each_safe(tmp, saved, &imp->imp_replay_list) {
-		req = list_entry(tmp, struct ptlrpc_request,
-				     rq_replay_list);
-
+	list_for_each_entry_safe(req, saved, &imp->imp_replay_list,
+				 rq_replay_list) {
 		/* XXX ok to remove when 1357 resolved - rread 05/29/03  */
 		LASSERT(req != last_req);
 		last_req = req;
@@ -2408,27 +2443,34 @@ void ptlrpc_free_committed(struct obd_import *imp)
 			GOTO(free_req, 0);
 		}
 
-		if (req->rq_replay) {
-			DEBUG_REQ(D_RPCTRACE, req, "keeping (FL_REPLAY)");
-			continue;
-		}
-
 		/* not yet committed */
 		if (req->rq_transno > imp->imp_peer_committed_transno) {
 			DEBUG_REQ(D_RPCTRACE, req, "stopping search");
 			break;
 		}
 
+		if (req->rq_replay) {
+			DEBUG_REQ(D_RPCTRACE, req, "keeping (FL_REPLAY)");
+			list_move_tail(&req->rq_replay_list,
+				       &imp->imp_committed_list);
+			continue;
+		}
+
 		DEBUG_REQ(D_INFO, req, "commit (last_committed "LPU64")",
 			  imp->imp_peer_committed_transno);
 free_req:
-		spin_lock(&req->rq_lock);
-		req->rq_replay = 0;
-		spin_unlock(&req->rq_lock);
-		if (req->rq_commit_cb != NULL)
-			req->rq_commit_cb(req);
-		list_del_init(&req->rq_replay_list);
-		__ptlrpc_req_finished(req, 1);
+		ptlrpc_free_request(req);
+	}
+	if (skip_committed_list)
+		return;
+
+	list_for_each_entry_safe(req, saved, &imp->imp_committed_list,
+				 rq_replay_list) {
+		LASSERT(req->rq_transno != 0);
+		if (req->rq_import_generation < imp->imp_generation) {
+			DEBUG_REQ(D_RPCTRACE, req, "free stale open request");
+			ptlrpc_free_request(req);
+		}
 	}
 }
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 82db0ed..537aa62 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -560,17 +560,30 @@ static int ptlrpc_first_transno(struct obd_import *imp, __u64 *transno)
 	struct ptlrpc_request *req;
 	struct list_head *tmp;
 
-	if (list_empty(&imp->imp_replay_list))
-		return 0;
-	tmp = imp->imp_replay_list.next;
-	req = list_entry(tmp, struct ptlrpc_request, rq_replay_list);
-	*transno = req->rq_transno;
-	if (req->rq_transno == 0) {
-		DEBUG_REQ(D_ERROR, req, "zero transno in replay");
-		LBUG();
+	/* The requests in committed_list always have smaller transnos than
+	 * the requests in replay_list */
+	if (!list_empty(&imp->imp_committed_list)) {
+		tmp = imp->imp_committed_list.next;
+		req = list_entry(tmp, struct ptlrpc_request, rq_replay_list);
+		*transno = req->rq_transno;
+		if (req->rq_transno == 0) {
+			DEBUG_REQ(D_ERROR, req,
+				  "zero transno in committed_list");
+			LBUG();
+		}
+		return 1;
 	}
-
-	return 1;
+	if (!list_empty(&imp->imp_replay_list)) {
+		tmp = imp->imp_replay_list.next;
+		req = list_entry(tmp, struct ptlrpc_request, rq_replay_list);
+		*transno = req->rq_transno;
+		if (req->rq_transno == 0) {
+			DEBUG_REQ(D_ERROR, req, "zero transno in replay_list");
+			LBUG();
+		}
+		return 1;
+	}
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index 84c39e0..48ae328 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -105,24 +105,59 @@ int ptlrpc_replay_next(struct obd_import *imp, int *inflight)
 	 * imp_lock is being held by ptlrpc_replay, but it's not. it's
 	 * just a little race...
 	 */
-	list_for_each_safe(tmp, pos, &imp->imp_replay_list) {
+
+	/* Replay all the committed open requests on committed_list first */
+	if (!list_empty(&imp->imp_committed_list)) {
+		tmp = imp->imp_committed_list.prev;
 		req = list_entry(tmp, struct ptlrpc_request,
 				     rq_replay_list);
 
-		/* If need to resend the last sent transno (because a
-		   reconnect has occurred), then stop on the matching
-		   req and send it again. If, however, the last sent
-		   transno has been committed then we continue replay
-		   from the next request. */
+		/* The last request on committed_list hasn't been replayed */
 		if (req->rq_transno > last_transno) {
-			if (imp->imp_resend_replay)
-				lustre_msg_add_flags(req->rq_reqmsg,
-						     MSG_RESENT);
-			break;
+			/* Since the imp_committed_list is immutable before
+			 * all of it's requests being replayed, it's safe to
+			 * use a cursor to accelerate the search */
+			imp->imp_replay_cursor = imp->imp_replay_cursor->next;
+
+			while (imp->imp_replay_cursor !=
+			       &imp->imp_committed_list) {
+				req = list_entry(imp->imp_replay_cursor,
+						 struct ptlrpc_request,
+						 rq_replay_list);
+				if (req->rq_transno > last_transno)
+					break;
+
+				req = NULL;
+				imp->imp_replay_cursor =
+					imp->imp_replay_cursor->next;
+			}
+		} else {
+			/* All requests on committed_list have been replayed */
+			imp->imp_replay_cursor = &imp->imp_committed_list;
+			req = NULL;
+		}
+	}
+
+	/* All the requests in committed list have been replayed, let's replay
+	 * the imp_replay_list */
+	if (req == NULL) {
+		list_for_each_safe(tmp, pos, &imp->imp_replay_list) {
+			req = list_entry(tmp, struct ptlrpc_request,
+					 rq_replay_list);
+
+			if (req->rq_transno > last_transno)
+				break;
+			req = NULL;
 		}
-		req = NULL;
 	}
 
+	/* If need to resend the last sent transno (because a reconnect
+	 * has occurred), then stop on the matching req and send it again.
+	 * If, however, the last sent transno has been committed then we
+	 * continue replay from the next request. */
+	if (req != NULL && imp->imp_resend_replay)
+		lustre_msg_add_flags(req->rq_reqmsg, MSG_RESENT);
+
 	spin_lock(&imp->imp_lock);
 	imp->imp_resend_replay = 0;
 	spin_unlock(&imp->imp_lock);
-- 
1.8.5.3

