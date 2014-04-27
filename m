Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaD0RXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:23:43 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47988 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaD0RHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Niu Yawei <yawei.niu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 11/47] staging/lustre/ptlrpc: add rpc_cache
Date: Sun, 27 Apr 2014 13:06:35 -0400
Message-Id: <1398618431-29757-12-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Add rpc_cache for allocating ptlrpc_requests.

Xyratex-bug-id: MRP-689
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-on: http://review.whamcloud.com/6874
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2424
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 42 ++++++++++++++++++----
 drivers/staging/lustre/lustre/ptlrpc/events.c      |  2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |  4 +++
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   | 32 ++++++++++++-----
 drivers/staging/lustre/lustre/ptlrpc/sec.c         | 10 +++---
 drivers/staging/lustre/lustre/ptlrpc/service.c     | 13 ++++---
 6 files changed, 75 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 4c9e006..5bee820 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -379,6 +379,34 @@ static int ptlrpc_at_recv_early_reply(struct ptlrpc_request *req)
 	return rc;
 }
 
+struct kmem_cache *request_cache;
+
+int ptlrpc_request_cache_init(void)
+{
+	request_cache = kmem_cache_create("ptlrpc_cache",
+					  sizeof(struct ptlrpc_request),
+					  0, SLAB_HWCACHE_ALIGN, NULL);
+	return request_cache == NULL ? -ENOMEM : 0;
+}
+
+void ptlrpc_request_cache_fini(void)
+{
+	kmem_cache_destroy(request_cache);
+}
+
+struct ptlrpc_request *ptlrpc_request_cache_alloc(int flags)
+{
+	struct ptlrpc_request *req;
+
+	OBD_SLAB_ALLOC_PTR_GFP(req, request_cache, flags);
+	return req;
+}
+
+void ptlrpc_request_cache_free(struct ptlrpc_request *req)
+{
+	OBD_SLAB_FREE_PTR(req, request_cache);
+}
+
 /**
  * Wind down request pool \a pool.
  * Frees all requests from the pool too
@@ -397,7 +425,7 @@ void ptlrpc_free_rq_pool(struct ptlrpc_request_pool *pool)
 		LASSERT(req->rq_reqbuf);
 		LASSERT(req->rq_reqbuf_len == pool->prp_rq_size);
 		OBD_FREE_LARGE(req->rq_reqbuf, pool->prp_rq_size);
-		OBD_FREE(req, sizeof(*req));
+		ptlrpc_request_cache_free(req);
 	}
 	spin_unlock(&pool->prp_lock);
 	OBD_FREE(pool, sizeof(*pool));
@@ -427,12 +455,12 @@ void ptlrpc_add_rqs_to_pool(struct ptlrpc_request_pool *pool, int num_rq)
 		struct lustre_msg *msg;
 
 		spin_unlock(&pool->prp_lock);
-		OBD_ALLOC(req, sizeof(struct ptlrpc_request));
+		req = ptlrpc_request_cache_alloc(__GFP_IO);
 		if (!req)
 			return;
 		OBD_ALLOC_LARGE(msg, size);
 		if (!msg) {
-			OBD_FREE(req, sizeof(struct ptlrpc_request));
+			ptlrpc_request_cache_free(req);
 			return;
 		}
 		req->rq_reqbuf = msg;
@@ -668,7 +696,7 @@ struct ptlrpc_request *__ptlrpc_request_alloc(struct obd_import *imp,
 		request = ptlrpc_prep_req_from_pool(pool);
 
 	if (!request)
-		OBD_ALLOC_PTR(request);
+		request = ptlrpc_request_cache_alloc(__GFP_IO);
 
 	if (request) {
 		LASSERTF((unsigned long)imp > 0x1000, "%p", imp);
@@ -739,7 +767,7 @@ void ptlrpc_request_free(struct ptlrpc_request *request)
 	if (request->rq_pool)
 		__ptlrpc_free_req_to_pool(request);
 	else
-		OBD_FREE_PTR(request);
+		ptlrpc_request_cache_free(request);
 }
 EXPORT_SYMBOL(ptlrpc_request_free);
 
@@ -2233,7 +2261,7 @@ static void __ptlrpc_free_req(struct ptlrpc_request *request, int locked)
 	if (request->rq_pool)
 		__ptlrpc_free_req_to_pool(request);
 	else
-		OBD_FREE(request, sizeof(*request));
+		ptlrpc_request_cache_free(request);
 }
 
 static int __ptlrpc_req_finished(struct ptlrpc_request *request, int locked);
@@ -3023,7 +3051,7 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 		return ERR_PTR(-EINVAL);
 
 	/* copy some code from deprecated fakereq. */
-	OBD_ALLOC_PTR(req);
+	req = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (req == NULL) {
 		CERROR("ptlrpc: run out of memory!\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index 6ea0a49..aa85239 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -307,7 +307,7 @@ void request_in_callback(lnet_event_t *ev)
 			/* We moaned above already... */
 			return;
 		}
-		OBD_ALLOC_GFP(req, sizeof(*req), ALLOC_ATOMIC_TRY);
+		req = ptlrpc_request_cache_alloc(ALLOC_ATOMIC_TRY);
 		if (req == NULL) {
 			CERROR("Can't allocate incoming request descriptor: "
 			       "Dropping %s RPC from %s\n",
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
index e3b5a92..7c94055 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
@@ -55,6 +55,10 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc);
 /* client.c */
 struct ptlrpc_bulk_desc *ptlrpc_new_bulk(unsigned npages, unsigned max_brw,
 					 unsigned type, unsigned portal);
+int ptlrpc_request_cache_init(void);
+void ptlrpc_request_cache_fini(void);
+struct ptlrpc_request *ptlrpc_request_cache_alloc(int flags);
+void ptlrpc_request_cache_free(struct ptlrpc_request *req);
 void ptlrpc_init_xid(void);
 
 /* events.c */
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
index 0efd358..251ae75 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
@@ -73,29 +73,34 @@ __init int ptlrpc_init(void)
 		return rc;
 
 	cleanup_phase = 1;
+	rc = ptlrpc_request_cache_init();
+	if (rc)
+		GOTO(cleanup, rc);
 
+	cleanup_phase = 2;
 	rc = ptlrpc_init_portals();
 	if (rc)
 		GOTO(cleanup, rc);
-	cleanup_phase = 2;
+
+	cleanup_phase = 3;
 
 	rc = ptlrpc_connection_init();
 	if (rc)
 		GOTO(cleanup, rc);
-	cleanup_phase = 3;
 
+	cleanup_phase = 4;
 	ptlrpc_put_connection_superhack = ptlrpc_connection_put;
 
 	rc = ptlrpc_start_pinger();
 	if (rc)
 		GOTO(cleanup, rc);
-	cleanup_phase = 4;
 
+	cleanup_phase = 5;
 	rc = ldlm_init();
 	if (rc)
 		GOTO(cleanup, rc);
-	cleanup_phase = 5;
 
+	cleanup_phase = 6;
 	rc = sptlrpc_init();
 	if (rc)
 		GOTO(cleanup, rc);
@@ -115,19 +120,29 @@ cleanup:
 	switch (cleanup_phase) {
 	case 8:
 		ptlrpc_nrs_fini();
+		/* Fall through */
 	case 7:
 		sptlrpc_fini();
-	case 5:
+		/* Fall through */
+	case 6:
 		ldlm_exit();
-	case 4:
+		/* Fall through */
+	case 5:
 		ptlrpc_stop_pinger();
-	case 3:
+		/* Fall through */
+	case 4:
 		ptlrpc_connection_fini();
-	case 2:
+		/* Fall through */
+	case 3:
 		ptlrpc_exit_portals();
+		/* Fall through */
+	case 2:
+		ptlrpc_request_cache_fini();
+		/* Fall through */
 	case 1:
 		ptlrpc_hr_fini();
 		req_layout_fini();
+		/* Fall through */
 	default: ;
 	}
 
@@ -142,6 +157,7 @@ static void __exit ptlrpc_exit(void)
 	ldlm_exit();
 	ptlrpc_stop_pinger();
 	ptlrpc_exit_portals();
+	ptlrpc_request_cache_fini();
 	ptlrpc_hr_fini();
 	ptlrpc_connection_fini();
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index a6d0f73..e383493 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -916,7 +916,7 @@ int sptlrpc_import_check_ctx(struct obd_import *imp)
 		return -EACCES;
 	}
 
-	OBD_ALLOC_PTR(req);
+	req = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (!req)
 		return -ENOMEM;
 
@@ -932,7 +932,7 @@ int sptlrpc_import_check_ctx(struct obd_import *imp)
 	rc = sptlrpc_req_refresh_ctx(req, 0);
 	LASSERT(list_empty(&req->rq_ctx_chain));
 	sptlrpc_cli_ctx_put(req->rq_cli_ctx, 1);
-	OBD_FREE_PTR(req);
+	ptlrpc_request_cache_free(req);
 
 	return rc;
 }
@@ -1100,7 +1100,7 @@ int sptlrpc_cli_unwrap_early_reply(struct ptlrpc_request *req,
 	int		     early_bufsz, early_size;
 	int		     rc;
 
-	OBD_ALLOC_PTR(early_req);
+	early_req = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (early_req == NULL)
 		return -ENOMEM;
 
@@ -1172,7 +1172,7 @@ err_ctx:
 err_buf:
 	OBD_FREE_LARGE(early_buf, early_bufsz);
 err_req:
-	OBD_FREE_PTR(early_req);
+	ptlrpc_request_cache_free(early_req);
 	return rc;
 }
 
@@ -1189,7 +1189,7 @@ void sptlrpc_cli_finish_early_reply(struct ptlrpc_request *early_req)
 
 	sptlrpc_cli_ctx_put(early_req->rq_cli_ctx, 1);
 	OBD_FREE_LARGE(early_req->rq_repbuf, early_req->rq_repbuf_len);
-	OBD_FREE_PTR(early_req);
+	ptlrpc_request_cache_free(early_req);
 }
 
 /**************************************************
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 5873c03..4dd2bcb 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -842,7 +842,7 @@ static void ptlrpc_server_free_request(struct ptlrpc_request *req)
 		/* NB request buffers use an embedded
 		 * req if the incoming req unlinked the
 		 * MD; this isn't one of them! */
-		OBD_FREE(req, sizeof(*req));
+		ptlrpc_request_cache_free(req);
 	}
 }
 
@@ -1305,14 +1305,12 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	}
 	newdl = cfs_time_current_sec() + at_get(&svcpt->scp_at_estimate);
 
-	OBD_ALLOC(reqcopy, sizeof(*reqcopy));
+	reqcopy = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (reqcopy == NULL)
 		return -ENOMEM;
 	OBD_ALLOC_LARGE(reqmsg, req->rq_reqlen);
-	if (!reqmsg) {
-		OBD_FREE(reqcopy, sizeof(*reqcopy));
-		return -ENOMEM;
-	}
+	if (!reqmsg)
+		GOTO(out_free, rc = -ENOMEM);
 
 	*reqcopy = *req;
 	reqcopy->rq_reply_state = NULL;
@@ -1369,7 +1367,8 @@ out_put:
 out:
 	sptlrpc_svc_ctx_decref(reqcopy);
 	OBD_FREE_LARGE(reqmsg, req->rq_reqlen);
-	OBD_FREE(reqcopy, sizeof(*reqcopy));
+out_free:
+	ptlrpc_request_cache_free(reqcopy);
 	return rc;
 }
 
-- 
1.8.5.3

