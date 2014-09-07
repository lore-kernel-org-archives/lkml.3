Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaIGQWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:22:31 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44979
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbaIGQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047700"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 1/7] staging: lustre: ptlrpc: expand the GOTO macro
Date: Sun,  7 Sep 2014 18:18:29 +0200
Message-Id: <1410106715-9573-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/staging/lustre/lustre/ptlrpc/client.c        |   32 ++++----
 drivers/staging/lustre/lustre/ptlrpc/connection.c    |    2 
 drivers/staging/lustre/lustre/ptlrpc/import.c        |   46 ++++++-----
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c   |   76 ++++++++++++-------
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c  |   54 +++++++++----
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c        |   16 ++--
 drivers/staging/lustre/lustre/ptlrpc/nrs.c           |   46 ++++++-----
 drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c |   16 ++--
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c       |   26 ++++--
 drivers/staging/lustre/lustre/ptlrpc/recover.c       |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c           |   24 +++---
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c    |   17 ++--
 drivers/staging/lustre/lustre/ptlrpc/service.c       |   43 ++++++----
 13 files changed, 246 insertions(+), 160 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index f1c3522..4519aee 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -578,7 +578,7 @@ static int __ptlrpc_request_bufs_pack(struct ptlrpc_request *request,
 	else {
 		rc = sptlrpc_req_get_ctx(request);
 		if (rc)
-			GOTO(out_free, rc);
+			goto out_free;
 	}
 
 	sptlrpc_req_set_flavor(request, opcode);
@@ -587,7 +587,7 @@ static int __ptlrpc_request_bufs_pack(struct ptlrpc_request *request,
 				 lengths, bufs);
 	if (rc) {
 		LASSERT(!request->rq_pool);
-		GOTO(out_ctx, rc);
+		goto out_ctx;
 	}
 
 	lustre_msg_add_version(request->rq_reqmsg, version);
@@ -1585,7 +1585,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 			continue;
 
 		if (req->rq_phase == RQ_PHASE_INTERPRET)
-			GOTO(interpret, req->rq_status);
+			goto interpret;
 
 		/*
 		 * Note that this also will start async reply unlink.
@@ -1604,7 +1604,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 				if (req->rq_status == 0)
 					req->rq_status = -EIO;
 				ptlrpc_rqphase_move(req, RQ_PHASE_INTERPRET);
-				GOTO(interpret, req->rq_status);
+				goto interpret;
 			} else {
 				continue;
 			}
@@ -1617,7 +1617,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 			if (req->rq_status == 0)
 				req->rq_status = -EIO;
 			ptlrpc_rqphase_move(req, RQ_PHASE_INTERPRET);
-			GOTO(interpret, req->rq_status);
+			goto interpret;
 		}
 
 		/* ptlrpc_set_wait->l_wait_event sets lwi_allow_intr
@@ -1633,7 +1633,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 				     req->rq_wait_ctx)) {
 			req->rq_status = -EINTR;
 			ptlrpc_rqphase_move(req, RQ_PHASE_INTERPRET);
-			GOTO(interpret, req->rq_status);
+			goto interpret;
 		}
 
 		if (req->rq_phase == RQ_PHASE_RPC) {
@@ -1662,7 +1662,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 					ptlrpc_rqphase_move(req,
 						RQ_PHASE_INTERPRET);
 					spin_unlock(&imp->imp_lock);
-					GOTO(interpret, req->rq_status);
+					goto interpret;
 				}
 				if (ptlrpc_no_resend(req) &&
 				    !req->rq_wait_ctx) {
@@ -1670,7 +1670,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 					ptlrpc_rqphase_move(req,
 							    RQ_PHASE_INTERPRET);
 					spin_unlock(&imp->imp_lock);
-					GOTO(interpret, req->rq_status);
+					goto interpret;
 				}
 
 				list_del_init(&req->rq_list);
@@ -1780,7 +1780,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 			 */
 			if (req->rq_bulk == NULL || req->rq_status < 0) {
 				ptlrpc_rqphase_move(req, RQ_PHASE_INTERPRET);
-				GOTO(interpret, req->rq_status);
+				goto interpret;
 			}
 
 			ptlrpc_rqphase_move(req, RQ_PHASE_BULK);
@@ -2491,7 +2491,7 @@ void ptlrpc_free_committed(struct obd_import *imp)
 		}
 		if (req->rq_import_generation < imp->imp_generation) {
 			DEBUG_REQ(D_RPCTRACE, req, "free request with old gen");
-			GOTO(free_req, 0);
+			goto free_req;
 		}
 
 		/* not yet committed */
@@ -2701,13 +2701,16 @@ static int ptlrpc_replay_interpret(const struct lu_env *env,
 
 	if (!ptlrpc_client_replied(req)) {
 		CERROR("request replay timed out, restarting recovery\n");
-		GOTO(out, rc = -ETIMEDOUT);
+		rc = -ETIMEDOUT;
+		goto out;
 	}
 
 	if (lustre_msg_get_type(req->rq_repmsg) == PTL_RPC_MSG_ERR &&
 	    (lustre_msg_get_status(req->rq_repmsg) == -ENOTCONN ||
-	     lustre_msg_get_status(req->rq_repmsg) == -ENODEV))
-		GOTO(out, rc = lustre_msg_get_status(req->rq_repmsg));
+	     lustre_msg_get_status(req->rq_repmsg) == -ENODEV)) {
+		rc = lustre_msg_get_status(req->rq_repmsg);
+		goto out;
+	}
 
 	/** VBR: check version failure */
 	if (lustre_msg_get_status(req->rq_repmsg) == -EOVERFLOW) {
@@ -2742,7 +2745,8 @@ static int ptlrpc_replay_interpret(const struct lu_env *env,
 			  "Reported transno %llu is bigger than the replayed one: %llu",
 			  req->rq_transno,
 			  lustre_msg_get_transno(req->rq_reqmsg));
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	DEBUG_REQ(D_HA, req, "got rep");
diff --git a/drivers/staging/lustre/lustre/ptlrpc/connection.c b/drivers/staging/lustre/lustre/ptlrpc/connection.c
index 6f63333..2a875ab 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/connection.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/connection.c
@@ -52,7 +52,7 @@ ptlrpc_connection_get(lnet_process_id_t peer, lnet_nid_t self,
 
 	conn = cfs_hash_lookup(conn_hash, &peer);
 	if (conn)
-		GOTO(out, conn);
+		goto out;
 
 	OBD_ALLOC_PTR(conn);
 	if (!conn)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index b25fa95..2e7e717 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -669,11 +669,11 @@ int ptlrpc_connect_import(struct obd_import *imp)
 
 	rc = import_select_connection(imp);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	rc = sptlrpc_import_sec_adapt(imp, NULL, NULL);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* Reset connect flags to the originally requested flags, in case
 	 * the server is updated on-the-fly we will get the new features. */
@@ -686,17 +686,19 @@ int ptlrpc_connect_import(struct obd_import *imp)
 	rc = obd_reconnect(NULL, imp->imp_obd->obd_self_export, obd,
 			   &obd->obd_uuid, &imp->imp_connect_data, NULL);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	request = ptlrpc_request_alloc(imp, &RQF_MDS_CONNECT);
-	if (request == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (request == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = ptlrpc_request_bufs_pack(request, LUSTRE_OBD_VERSION,
 				      imp->imp_connect_op, bufs, NULL);
 	if (rc) {
 		ptlrpc_request_free(request);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	/* Report the rpc service time to the server so that it knows how long
@@ -804,7 +806,7 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		imp->imp_force_reconnect = ptlrpc_busy_reconnect(rc);
 		spin_unlock(&imp->imp_lock);
 		ptlrpc_maybe_ping_import_soon(imp);
-		GOTO(out, rc);
+		goto out;
 	}
 	spin_unlock(&imp->imp_lock);
 
@@ -822,7 +824,7 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		CERROR("%s: no connect data from server\n",
 		       imp->imp_obd->obd_name);
 		rc = -EPROTO;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	spin_lock(&imp->imp_lock);
@@ -846,7 +848,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		CERROR("%s: Server didn't granted asked subset of flags: asked=%#llx grranted=%#llx\n",
 		       imp->imp_obd->obd_name, imp->imp_connect_flags_orig,
 		       ocd->ocd_connect_flags);
-		GOTO(out, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out;
 	}
 
 	if (!exp) {
@@ -854,7 +857,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		   connect attempt */
 		CERROR("%s: missing export after connect\n",
 		       imp->imp_obd->obd_name);
-		GOTO(out, rc = -ENODEV);
+		rc = -ENODEV;
+		goto out;
 	}
 	old_connect_flags = exp_connect_flags(exp);
 	exp->exp_connect_data = *ocd;
@@ -893,7 +897,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 			ptlrpc_activate_import(imp);
 		}
 
-		GOTO(finish, rc = 0);
+		rc = 0;
+		goto finish;
 	}
 
 	/* Determine what recovery state to move the import to. */
@@ -905,7 +910,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 				      obd2cli_tgt(imp->imp_obd),
 				      imp->imp_connection->c_remote_uuid.uuid,
 				      imp->imp_dlm_handle.cookie);
-			GOTO(out, rc = -ENOTCONN);
+			rc = -ENOTCONN;
+			goto out;
 		}
 
 		if (memcmp(&imp->imp_remote_handle,
@@ -945,7 +951,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 
 			if (!(MSG_CONNECT_RECOVERING & msg_flags)) {
 				IMPORT_SET_STATE(imp, LUSTRE_IMP_EVICTED);
-				GOTO(finish, rc = 0);
+				rc = 0;
+				goto finish;
 			}
 
 		} else {
@@ -1034,7 +1041,8 @@ finish:
 				      imp->imp_connection->c_remote_uuid.uuid,
 				      imp->imp_connect_flags_orig,
 				      ocd->ocd_connect_flags);
-			GOTO(out, rc = -EPROTO);
+			rc = -EPROTO;
+			goto out;
 		}
 
 		if ((ocd->ocd_connect_flags & OBD_CONNECT_VERSION) &&
@@ -1378,7 +1386,7 @@ int ptlrpc_import_recovery_state_machine(struct obd_import *imp)
 			IMPORT_SET_STATE(imp, LUSTRE_IMP_REPLAY_LOCKS);
 			rc = ldlm_replay_locks(imp);
 			if (rc)
-				GOTO(out, rc);
+				goto out;
 		}
 		rc = 0;
 	}
@@ -1388,7 +1396,7 @@ int ptlrpc_import_recovery_state_machine(struct obd_import *imp)
 			IMPORT_SET_STATE(imp, LUSTRE_IMP_REPLAY_WAIT);
 			rc = signal_completed_replay(imp);
 			if (rc)
-				GOTO(out, rc);
+				goto out;
 		}
 
 	}
@@ -1406,7 +1414,7 @@ int ptlrpc_import_recovery_state_machine(struct obd_import *imp)
 
 		rc = ptlrpc_resend(imp);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 		IMPORT_SET_STATE(imp, LUSTRE_IMP_FULL);
 		ptlrpc_activate_import(imp);
 
@@ -1433,7 +1441,7 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 	int rq_opc, rc = 0;
 
 	if (imp->imp_obd->obd_force)
-		GOTO(set_state, rc);
+		goto set_state;
 
 	switch (imp->imp_connect_op) {
 	case OST_CONNECT:
@@ -1479,7 +1487,7 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 
 	spin_lock(&imp->imp_lock);
 	if (imp->imp_state != LUSTRE_IMP_FULL)
-		GOTO(out, 0);
+		goto out;
 	spin_unlock(&imp->imp_lock);
 
 	req = ptlrpc_request_alloc_pack(imp, &RQF_MDS_DISCONNECT,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
index d068be7..56f825f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
@@ -93,8 +93,10 @@ static int llog_client_open(const struct lu_env *env,
 	LASSERT(lgh);
 
 	req = ptlrpc_request_alloc(imp, &RQF_LLOG_ORIGIN_HANDLE_CREATE);
-	if (req == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	if (name)
 		req_capsule_set_size(&req->rq_pill, &RMF_NAME, RCL_CLIENT,
@@ -105,7 +107,7 @@ static int llog_client_open(const struct lu_env *env,
 	if (rc) {
 		ptlrpc_request_free(req);
 		req = NULL;
-		GOTO(out, rc);
+		goto out;
 	}
 	ptlrpc_request_set_replen(req);
 
@@ -124,11 +126,13 @@ static int llog_client_open(const struct lu_env *env,
 
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_LLOGD_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (body == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	lgh->lgh_id = body->lgd_logid;
 	lgh->lgh_ctxt = ctxt;
@@ -150,8 +154,10 @@ static int llog_client_destroy(const struct lu_env *env,
 	req = ptlrpc_request_alloc_pack(imp, &RQF_LLOG_ORIGIN_HANDLE_DESTROY,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_DESTROY);
-	if (req == NULL)
-		GOTO(err_exit, rc =-ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto err_exit;
+	}
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = loghandle->lgh_id;
@@ -186,8 +192,10 @@ static int llog_client_next_block(const struct lu_env *env,
 	req = ptlrpc_request_alloc_pack(imp, &RQF_LLOG_ORIGIN_HANDLE_NEXT_BLOCK,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_NEXT_BLOCK);
-	if (req == NULL)
-		GOTO(err_exit, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto err_exit;
+	}
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = loghandle->lgh_id;
@@ -202,16 +210,20 @@ static int llog_client_next_block(const struct lu_env *env,
 	ptlrpc_request_set_replen(req);
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_LLOGD_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (body == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	/* The log records are swabbed as they are processed */
 	ptr = req_capsule_server_get(&req->rq_pill, &RMF_EADATA);
-	if (ptr == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (ptr == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	*cur_idx = body->lgd_saved_index;
 	*cur_offset = body->lgd_cur_offset;
@@ -238,8 +250,10 @@ static int llog_client_prev_block(const struct lu_env *env,
 	req = ptlrpc_request_alloc_pack(imp, &RQF_LLOG_ORIGIN_HANDLE_PREV_BLOCK,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_PREV_BLOCK);
-	if (req == NULL)
-		GOTO(err_exit, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto err_exit;
+	}
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = loghandle->lgh_id;
@@ -253,15 +267,19 @@ static int llog_client_prev_block(const struct lu_env *env,
 
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_LLOGD_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (body == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	ptr = req_capsule_server_get(&req->rq_pill, &RMF_EADATA);
-	if (ptr == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (ptr == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	memcpy(buf, ptr, len);
 out:
@@ -285,8 +303,10 @@ static int llog_client_read_header(const struct lu_env *env,
 	req = ptlrpc_request_alloc_pack(imp, &RQF_LLOG_ORIGIN_HANDLE_READ_HEADER,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_READ_HEADER);
-	if (req == NULL)
-		GOTO(err_exit, rc = -ENOMEM);
+	if (req == NULL) {
+		rc = -ENOMEM;
+		goto err_exit;
+	}
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = handle->lgh_id;
@@ -296,11 +316,13 @@ static int llog_client_read_header(const struct lu_env *env,
 	ptlrpc_request_set_replen(req);
 	rc = ptlrpc_queue_wait(req);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	hdr = req_capsule_server_get(&req->rq_pill, &RMF_LLOG_LOG_HDR);
-	if (hdr == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (hdr == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	memcpy(handle->lgh_hdr, hdr, sizeof(*hdr));
 	handle->lgh_last_idx = handle->lgh_hdr->llh_tail.lrt_index;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index ace12e8..87b9764a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -500,8 +500,10 @@ static int ptlrpc_lprocfs_nrs_seq_show(struct seq_file *m, void *n)
 	spin_unlock(&nrs->nrs_lock);
 
 	OBD_ALLOC(infos, num_pols * sizeof(*infos));
-	if (infos == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (infos == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 again:
 
 	ptlrpc_service_for_each_part(svcpt, i, svc) {
@@ -640,26 +642,34 @@ static ssize_t ptlrpc_lprocfs_nrs_seq_write(struct file *file,
 	char			       *token;
 	int				rc = 0;
 
-	if (count >= LPROCFS_NRS_WR_MAX_CMD)
-		GOTO(out, rc = -EINVAL);
+	if (count >= LPROCFS_NRS_WR_MAX_CMD) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	OBD_ALLOC(cmd, LPROCFS_NRS_WR_MAX_CMD);
-	if (cmd == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (cmd == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	/**
 	 * strsep() modifies its argument, so keep a copy
 	 */
 	cmd_copy = cmd;
 
-	if (copy_from_user(cmd, buffer, count))
-		GOTO(out, rc = -EFAULT);
+	if (copy_from_user(cmd, buffer, count)) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	cmd[count] = '\0';
 
 	token = strsep(&cmd, " ");
 
-	if (strlen(token) > NRS_POL_NAME_MAX - 1)
-		GOTO(out, rc = -EINVAL);
+	if (strlen(token) > NRS_POL_NAME_MAX - 1) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	/**
 	 * No [reg|hp] token has been specified
@@ -674,13 +684,17 @@ static ssize_t ptlrpc_lprocfs_nrs_seq_write(struct file *file,
 		queue = PTLRPC_NRS_QUEUE_REG;
 	else if (strcmp(cmd, "hp") == 0)
 		queue = PTLRPC_NRS_QUEUE_HP;
-	else
-		GOTO(out, rc = -EINVAL);
+	else {
+		rc = -EINVAL;
+		goto out;
+	}
 
 default_queue:
 
-	if (queue == PTLRPC_NRS_QUEUE_HP && !nrs_svc_has_hp(svc))
-		GOTO(out, rc = -ENODEV);
+	if (queue == PTLRPC_NRS_QUEUE_HP && !nrs_svc_has_hp(svc)) {
+		rc = -ENODEV;
+		goto out;
+	}
 	else if (queue == PTLRPC_NRS_QUEUE_BOTH && !nrs_svc_has_hp(svc))
 		queue = PTLRPC_NRS_QUEUE_REG;
 
@@ -1258,14 +1272,18 @@ int lprocfs_wr_import(struct file *file, const char *buffer,
 	if (kbuf == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(kbuf, buffer, count))
-		GOTO(out, count = -EFAULT);
+	if (copy_from_user(kbuf, buffer, count)) {
+		count = -EFAULT;
+		goto out;
+	}
 
 	kbuf[count] = 0;
 
 	/* only support connection=uuid::instance now */
-	if (strncmp(prefix, kbuf, prefix_len) != 0)
-		GOTO(out, count = -EINVAL);
+	if (strncmp(prefix, kbuf, prefix_len) != 0) {
+		count = -EINVAL;
+		goto out;
+	}
 
 	uuid = kbuf + prefix_len;
 	ptr = strstr(uuid, "::");
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index 8fb37f0..0067e06 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -537,13 +537,13 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 
 	rc = sptlrpc_cli_wrap_request(request);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* bulk register should be done after wrap_request() */
 	if (request->rq_bulk != NULL) {
 		rc = ptlrpc_register_bulk(request);
 		if (rc != 0)
-			GOTO(out, rc);
+			goto out;
 	}
 
 	if (!noreply) {
@@ -560,7 +560,7 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 				request->rq_err = 1;
 				spin_unlock(&request->rq_lock);
 				request->rq_status = rc;
-				GOTO(cleanup_bulk, rc);
+				goto cleanup_bulk;
 			}
 		} else {
 			request->rq_repdata = NULL;
@@ -573,7 +573,8 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 		if (rc != 0) {
 			CERROR("LNetMEAttach failed: %d\n", rc);
 			LASSERT(rc == -ENOMEM);
-			GOTO(cleanup_bulk, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto cleanup_bulk;
 		}
 	}
 
@@ -616,7 +617,8 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 			/* ...but the MD attach didn't succeed... */
 			request->rq_receiving_reply = 0;
 			spin_unlock(&request->rq_lock);
-			GOTO(cleanup_me, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto cleanup_me;
 		}
 
 		CDEBUG(D_NET, "Setup reply buffer: %u bytes, xid %llu, portal %u\n",
@@ -650,11 +652,11 @@ int ptl_send_rpc(struct ptlrpc_request *request, int noreply)
 			  request->rq_request_portal,
 			  request->rq_xid, 0);
 	if (rc == 0)
-		GOTO(out, rc);
+		goto out;
 
 	ptlrpc_req_finished(request);
 	if (noreply)
-		GOTO(out, rc);
+		goto out;
 
  cleanup_me:
 	/* MEUnlink is safe; the PUT didn't even get off the ground, and
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index af5b987..181301b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -264,7 +264,7 @@ static int nrs_policy_start_locked(struct ptlrpc_nrs_policy *policy)
 				module_put(policy->pol_desc->pd_owner);
 
 			policy->pol_state = NRS_POL_STATE_STOPPED;
-			GOTO(out, rc);
+			goto out;
 		}
 	}
 
@@ -635,8 +635,10 @@ static int nrs_policy_ctl(struct ptlrpc_nrs *nrs, char *name,
 	spin_lock(&nrs->nrs_lock);
 
 	policy = nrs_policy_find_locked(nrs, name);
-	if (policy == NULL)
-		GOTO(out, rc = -ENOENT);
+	if (policy == NULL) {
+		rc = -ENOENT;
+		goto out;
+	}
 
 	switch (opc) {
 		/**
@@ -956,19 +958,21 @@ static int nrs_svcpt_setup_locked(struct ptlrpc_service_part *svcpt)
 	nrs = nrs_svcpt2nrs(svcpt, false);
 	rc = nrs_svcpt_setup_locked0(nrs, svcpt);
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	/**
 	 * Optionally allocate a high-priority NRS head.
 	 */
 	if (svcpt->scp_service->srv_ops.so_hpreq_handler == NULL)
-		GOTO(out, rc);
+		goto out;
 
 	OBD_CPT_ALLOC_PTR(svcpt->scp_nrs_hp,
 			  svcpt->scp_service->srv_cptable,
 			  svcpt->scp_cpt);
-	if (svcpt->scp_nrs_hp == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (svcpt->scp_nrs_hp == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	nrs = nrs_svcpt2nrs(svcpt, true);
 	rc = nrs_svcpt_setup_locked0(nrs, svcpt);
@@ -1154,12 +1158,15 @@ int ptlrpc_nrs_policy_register(struct ptlrpc_nrs_pol_conf *conf)
 		CERROR("NRS: failing to register policy %s which has already "
 		       "been registered with NRS core!\n",
 		       conf->nc_name);
-		GOTO(fail, rc = -EEXIST);
+		rc = -EEXIST;
+		goto fail;
 	}
 
 	OBD_ALLOC_PTR(desc);
-	if (desc == NULL)
-		GOTO(fail, rc = -ENOMEM);
+	if (desc == NULL) {
+		rc = -ENOMEM;
+		goto fail;
+	}
 
 	strncpy(desc->pd_name, conf->nc_name, NRS_POL_NAME_MAX);
 	desc->pd_ops		 = conf->nc_ops;
@@ -1214,7 +1221,7 @@ again:
 				LASSERT(rc2 == 0);
 				mutex_unlock(&ptlrpc_all_services_mutex);
 				OBD_FREE_PTR(desc);
-				GOTO(fail, rc);
+				goto fail;
 			}
 
 			if (!hp && nrs_svc_has_hp(svc)) {
@@ -1237,7 +1244,7 @@ again:
 				LASSERT(rc2 == 0);
 				mutex_unlock(&ptlrpc_all_services_mutex);
 				OBD_FREE_PTR(desc);
-				GOTO(fail, rc);
+				goto fail;
 			}
 		}
 	}
@@ -1288,7 +1295,8 @@ int ptlrpc_nrs_policy_unregister(struct ptlrpc_nrs_pol_conf *conf)
 		CERROR("Failing to unregister NRS policy %s which has "
 		       "not been registered with NRS core!\n",
 		       conf->nc_name);
-		GOTO(not_exist, rc = -ENOENT);
+		rc = -ENOENT;
+		goto not_exist;
 	}
 
 	mutex_lock(&ptlrpc_all_services_mutex);
@@ -1299,7 +1307,7 @@ int ptlrpc_nrs_policy_unregister(struct ptlrpc_nrs_pol_conf *conf)
 			CERROR("Please first stop policy %s on all service "
 			       "partitions and then retry to unregister the "
 			       "policy.\n", conf->nc_name);
-		GOTO(fail, rc);
+		goto fail;
 	}
 
 	CDEBUG(D_INFO, "Unregistering policy %s from NRS core.\n",
@@ -1347,7 +1355,7 @@ int ptlrpc_service_nrs_setup(struct ptlrpc_service *svc)
 	ptlrpc_service_for_each_part(svcpt, i, svc) {
 		rc = nrs_svcpt_setup_locked(svcpt);
 		if (rc != 0)
-			GOTO(failed, rc);
+			goto failed;
 	}
 
 	/**
@@ -1361,7 +1369,7 @@ int ptlrpc_service_nrs_setup(struct ptlrpc_service *svc)
 		if (desc->pd_ops->op_lprocfs_init != NULL) {
 			rc = desc->pd_ops->op_lprocfs_init(svc);
 			if (rc != 0)
-				GOTO(failed, rc);
+				goto failed;
 		}
 	}
 
@@ -1679,7 +1687,7 @@ int ptlrpc_nrs_policy_control(const struct ptlrpc_service *svc,
 					    opc, arg);
 			if (rc != 0 || (queue == PTLRPC_NRS_QUEUE_REG &&
 					single))
-				GOTO(out, rc);
+				goto out;
 		}
 
 		if ((queue & PTLRPC_NRS_QUEUE_HP) != 0) {
@@ -1694,7 +1702,7 @@ int ptlrpc_nrs_policy_control(const struct ptlrpc_service *svc,
 			rc = nrs_policy_ctl(nrs_svcpt2nrs(svcpt, true), name,
 					    opc, arg);
 			if (rc != 0 || single)
-				GOTO(out, rc);
+				goto out;
 		}
 	}
 out:
@@ -1721,7 +1729,7 @@ int ptlrpc_nrs_init(void)
 
 	rc = ptlrpc_nrs_policy_register(&nrs_conf_fifo);
 	if (rc != 0)
-		GOTO(fail, rc);
+		goto fail;
 
 
 	return rc;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
index 6d92a56..5268887 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
@@ -75,45 +75,45 @@ __init int ptlrpc_init(void)
 	cleanup_phase = 1;
 	rc = ptlrpc_request_cache_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 2;
 	rc = ptlrpc_init_portals();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 3;
 
 	rc = ptlrpc_connection_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 4;
 	ptlrpc_put_connection_superhack = ptlrpc_connection_put;
 
 	rc = ptlrpc_start_pinger();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 5;
 	rc = ldlm_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 6;
 	rc = sptlrpc_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 7;
 	rc = ptlrpc_nrs_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 
 	cleanup_phase = 8;
 	rc = tgt_mod_init();
 	if (rc)
-		GOTO(cleanup, rc);
+		goto cleanup;
 	return 0;
 
 cleanup:
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index 9c60e2a..357ea9f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -615,8 +615,10 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	spin_lock_init(&pc->pc_lock);
 	strlcpy(pc->pc_name, name, sizeof(pc->pc_name));
 	pc->pc_set = ptlrpc_prep_set();
-	if (pc->pc_set == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (pc->pc_set == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	/*
 	 * So far only "client" ptlrpcd uses an environment. In the future,
@@ -625,19 +627,21 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	 */
 	rc = lu_context_init(&pc->pc_env.le_ctx, LCT_CL_THREAD|LCT_REMEMBER);
 	if (rc != 0)
-		GOTO(out_set, rc);
+		goto out_set;
 
 	{
 		struct task_struct *task;
 		if (index >= 0) {
 			rc = ptlrpcd_bind(index, max);
 			if (rc < 0)
-				GOTO(out_env, rc);
+				goto out_env;
 		}
 
 		task = kthread_run(ptlrpcd, pc, "%s", pc->pc_name);
-		if (IS_ERR(task))
-			GOTO(out_env, rc = PTR_ERR(task));
+		if (IS_ERR(task)) {
+			rc = PTR_ERR(task);
+			goto out_env;
+		}
 
 		wait_for_completion(&pc->pc_starting);
 	}
@@ -741,14 +745,16 @@ static int ptlrpcd_init(void)
 
 	size = offsetof(struct ptlrpcd, pd_threads[nthreads]);
 	OBD_ALLOC(ptlrpcds, size);
-	if (ptlrpcds == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (ptlrpcds == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	snprintf(name, sizeof(name), "ptlrpcd_rcv");
 	set_bit(LIOD_RECOVERY, &ptlrpcds->pd_thread_rcv.pc_flags);
 	rc = ptlrpcd_start(-1, nthreads, name, &ptlrpcds->pd_thread_rcv);
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	/* XXX: We start nthreads ptlrpc daemons. Each of them can process any
 	 *      non-recovery async RPC to improve overall async RPC efficiency.
@@ -766,7 +772,7 @@ static int ptlrpcd_init(void)
 		snprintf(name, sizeof(name), "ptlrpcd_%d", i);
 		rc = ptlrpcd_start(i, nthreads, name, &ptlrpcds->pd_threads[i]);
 		if (rc < 0)
-			GOTO(out, rc);
+			goto out;
 	}
 
 	ptlrpcds->pd_size = size;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index 5e4a1a5..9d74f24 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -317,7 +317,7 @@ int ptlrpc_recover_import(struct obd_import *imp, char *new_uuid, int async)
 		rc = -EINVAL;
 	spin_unlock(&imp->imp_lock);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* force import to be disconnected. */
 	ptlrpc_set_import_discon(imp, 0);
@@ -329,7 +329,7 @@ int ptlrpc_recover_import(struct obd_import *imp, char *new_uuid, int async)
 		obd_str2uuid(&uuid, new_uuid);
 		rc = import_set_conn_priority(imp, &uuid);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 	}
 
 	/* Check if reconnect is already in progress */
@@ -340,11 +340,11 @@ int ptlrpc_recover_import(struct obd_import *imp, char *new_uuid, int async)
 	}
 	spin_unlock(&imp->imp_lock);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	rc = ptlrpc_connect_import(imp);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	if (!async) {
 		struct l_wait_info lwi;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index bf59f3e..4ce7685 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -1095,15 +1095,18 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 	early_size = req->rq_nob_received;
 	early_bufsz = size_roundup_power2(early_size);
 	OBD_ALLOC_LARGE(early_buf, early_bufsz);
-	if (early_buf == NULL)
-		GOTO(err_req, rc = -ENOMEM);
+	if (early_buf == NULL) {
+		rc = -ENOMEM;
+		goto err_req;
+	}
 
 	/* sanity checkings and copy data out, do it inside spinlock */
 	spin_lock(&req->rq_lock);
 
 	if (req->rq_replied) {
 		spin_unlock(&req->rq_lock);
-		GOTO(err_buf, rc = -EALREADY);
+		rc = -EALREADY;
+		goto err_buf;
 	}
 
 	LASSERT(req->rq_repbuf);
@@ -1113,7 +1116,8 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 	if (req->rq_reply_off != 0) {
 		CERROR("early reply with offset %u\n", req->rq_reply_off);
 		spin_unlock(&req->rq_lock);
-		GOTO(err_buf, rc = -EPROTO);
+		rc = -EPROTO;
+		goto err_buf;
 	}
 
 	if (req->rq_nob_received != early_size) {
@@ -1121,14 +1125,16 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 		CERROR("data size has changed from %u to %u\n",
 		       early_size, req->rq_nob_received);
 		spin_unlock(&req->rq_lock);
-		GOTO(err_buf, rc = -EINVAL);
+		rc = -EINVAL;
+		goto err_buf;
 	}
 
 	if (req->rq_nob_received < sizeof(struct lustre_msg)) {
 		CERROR("early reply length %d too small\n",
 		       req->rq_nob_received);
 		spin_unlock(&req->rq_lock);
-		GOTO(err_buf, rc = -EALREADY);
+		rc = -EALREADY;
+		goto err_buf;
 	}
 
 	memcpy(early_buf, req->rq_repbuf, early_size);
@@ -1148,7 +1154,7 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 	if (rc) {
 		DEBUG_REQ(D_ADAPTTO, early_req,
 			  "error %d unwrap early reply", rc);
-		GOTO(err_ctx, rc);
+		goto err_ctx;
 	}
 
 	LASSERT(early_req->rq_repmsg);
@@ -1434,7 +1440,7 @@ int sptlrpc_import_sec_adapt(struct obd_import *imp,
 		char    str2[24];
 
 		if (flavor_equal(&sf, &sec->ps_flvr))
-			GOTO(out, rc);
+			goto out;
 
 		CDEBUG(D_SEC, "import %s->%s: changing flavor %s -> %s\n",
 		       imp->imp_obd->obd_name,
@@ -1447,7 +1453,7 @@ int sptlrpc_import_sec_adapt(struct obd_import *imp,
 		    SPTLRPC_FLVR_MECH(sf.sf_rpc) ==
 		    SPTLRPC_FLVR_MECH(sec->ps_flvr.sf_rpc)) {
 			sptlrpc_import_sec_adapt_inplace(imp, sec, &sf);
-			GOTO(out, rc);
+			goto out;
 		}
 	} else if (SPTLRPC_FLVR_BASE(sf.sf_rpc) !=
 		   SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_NULL)) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index c9e9da7..10800f9 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -1023,7 +1023,7 @@ int sptlrpc_target_local_copy_conf(struct obd_device *obd,
 		rc = PTR_ERR(dentry);
 		CERROR("cannot lookup %s directory: rc = %d\n",
 		       MOUNT_CONFIGS_DIR, rc);
-		GOTO(out_ctx, rc);
+		goto out_ctx;
 	}
 
 	/* erase the old tmp log */
@@ -1031,16 +1031,16 @@ int sptlrpc_target_local_copy_conf(struct obd_device *obd,
 	if (rc < 0 && rc != -ENOENT) {
 		CERROR("%s: cannot erase temporary sptlrpc log: rc = %d\n",
 		       obd->obd_name, rc);
-		GOTO(out_dput, rc);
+		goto out_dput;
 	}
 
 	/* write temporary log */
 	rc = llog_open_create(NULL, ctxt, &llh, NULL, LOG_SPTLRPC_TMP);
 	if (rc)
-		GOTO(out_dput, rc);
+		goto out_dput;
 	rc = llog_init_handle(NULL, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(out_close, rc);
+		goto out_close;
 
 	rc = sptlrpc_record_rules(llh, conf);
 
@@ -1112,16 +1112,17 @@ int sptlrpc_target_local_read_conf(struct obd_device *obd,
 	if (rc < 0) {
 		if (rc == -ENOENT)
 			rc = 0;
-		GOTO(out_pop, rc);
+		goto out_pop;
 	}
 
 	rc = llog_init_handle(NULL, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(out_close, rc);
+		goto out_close;
 
 	if (llog_get_size(llh) <= 1) {
 		CDEBUG(D_SEC, "no local sptlrpc copy found\n");
-		GOTO(out_close, rc = 0);
+		rc = 0;
+		goto out_close;
 	}
 
 	rc = llog_process(NULL, llh, local_read_handler, (void *)conf, NULL);
@@ -1174,7 +1175,7 @@ int sptlrpc_conf_target_get_rules(struct obd_device *obd,
 	conf = sptlrpc_conf_get(fsname, 0);
 	if (conf == NULL) {
 		CERROR("missing sptlrpc config log\n");
-		GOTO(out, rc);
+		goto out;
 	}
 
 	if (conf->sc_updated  == 0) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 160ec3e..a8df8a7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -781,13 +781,15 @@ ptlrpc_register_service(struct ptlrpc_service_conf *conf,
 			cpt = cpts != NULL ? cpts[i] : i;
 
 		OBD_CPT_ALLOC(svcpt, cptable, cpt, sizeof(*svcpt));
-		if (svcpt == NULL)
-			GOTO(failed, rc = -ENOMEM);
+		if (svcpt == NULL) {
+			rc = -ENOMEM;
+			goto failed;
+		}
 
 		service->srv_parts[i] = svcpt;
 		rc = ptlrpc_service_part_init(service, svcpt, cpt);
 		if (rc != 0)
-			GOTO(failed, rc);
+			goto failed;
 	}
 
 	ptlrpc_server_nthreads_check(service, conf);
@@ -804,7 +806,7 @@ ptlrpc_register_service(struct ptlrpc_service_conf *conf,
 
 	rc = ptlrpc_service_nrs_setup(service);
 	if (rc != 0)
-		GOTO(failed, rc);
+		goto failed;
 
 	CDEBUG(D_NET, "%s: Started, listening on portal %d\n",
 	       service->srv_name, service->srv_req_portal);
@@ -813,7 +815,7 @@ ptlrpc_register_service(struct ptlrpc_service_conf *conf,
 	if (rc != 0) {
 		CERROR("Failed to start threads for service %s: %d\n",
 		       service->srv_name, rc);
-		GOTO(failed, rc);
+		goto failed;
 	}
 
 	return service;
@@ -1308,8 +1310,10 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	if (reqcopy == NULL)
 		return -ENOMEM;
 	OBD_ALLOC_LARGE(reqmsg, req->rq_reqlen);
-	if (!reqmsg)
-		GOTO(out_free, rc = -ENOMEM);
+	if (!reqmsg) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
 
 	*reqcopy = *req;
 	reqcopy->rq_reply_state = NULL;
@@ -1327,24 +1331,29 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	if (atomic_read(&req->rq_refcount) == 1) {
 		DEBUG_REQ(D_ADAPTTO, reqcopy, "Normal reply already sent out, "
 			  "abort sending early reply\n");
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	/* Connection ref */
 	reqcopy->rq_export = class_conn2export(
 				     lustre_msg_get_handle(reqcopy->rq_reqmsg));
-	if (reqcopy->rq_export == NULL)
-		GOTO(out, rc = -ENODEV);
+	if (reqcopy->rq_export == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	/* RPC ref */
 	class_export_rpc_inc(reqcopy->rq_export);
 	if (reqcopy->rq_export->exp_obd &&
-	    reqcopy->rq_export->exp_obd->obd_fail)
-		GOTO(out_put, rc = -ENODEV);
+	    reqcopy->rq_export->exp_obd->obd_fail) {
+		rc = -ENODEV;
+		goto out_put;
+	}
 
 	rc = lustre_pack_reply_flags(reqcopy, 1, NULL, NULL, LPRFL_EARLY_REPLY);
 	if (rc)
-		GOTO(out_put, rc);
+		goto out_put;
 
 	rc = ptlrpc_send_reply(reqcopy, PTLRPC_REPLY_EARLY);
 
@@ -1849,7 +1858,7 @@ ptlrpc_server_handle_req_in(struct ptlrpc_service_part *svcpt,
 	/* Move it over to the request processing queue */
 	rc = ptlrpc_server_request_add(svcpt, req);
 	if (rc)
-		GOTO(err_req, rc);
+		goto err_req;
 
 	wake_up(&svcpt->scp_waitq);
 	return 1;
@@ -2787,8 +2796,10 @@ int ptlrpc_hr_init(void)
 		LASSERT(hrp->hrp_nthrs > 0);
 		OBD_CPT_ALLOC(hrp->hrp_thrs, ptlrpc_hr.hr_cpt_table, i,
 			      hrp->hrp_nthrs * sizeof(*hrt));
-		if (hrp->hrp_thrs == NULL)
-			GOTO(out, rc = -ENOMEM);
+		if (hrp->hrp_thrs == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		for (j = 0; j < hrp->hrp_nthrs; j++) {
 			hrt = &hrp->hrp_thrs[j];
