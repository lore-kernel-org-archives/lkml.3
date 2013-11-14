Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3KNQjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:54 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44886 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3KNQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:50 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Niu Yawei <yawei.niu@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/39] staging/lustre/ptlrpc: add rpc_cache
Date: Fri, 15 Nov 2013 00:32:28 +0800
Message-Id: <1384446782-13741-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Add rpc_cache for allocating ptlrpc_requests.

Lustre-change: http://review.whamcloud.com/6874
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2424
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   42 ++++++++++++++++----
 drivers/staging/lustre/lustre/ptlrpc/events.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    4 ++
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |   24 +++++++----
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |    6 +--
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   13 +++---
 6 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index faa982a..9cdee5e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -378,6 +378,34 @@ static int ptlrpc_at_recv_early_reply(struct ptlrpc_request *req)
 	return rc;
 }
 
+struct kmem_cache *request_cache;
+
+int ptlrpc_request_cache_init()
+{
+	request_cache = kmem_cache_create("ptlrpc_cache",
+					  sizeof(struct ptlrpc_request),
+					  0, SLAB_HWCACHE_ALIGN, NULL);
+	return request_cache == NULL ? -ENOMEM : 0;
+}
+
+void ptlrpc_request_cache_fini()
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
@@ -396,7 +424,7 @@ void ptlrpc_free_rq_pool(struct ptlrpc_request_pool *pool)
 		LASSERT(req->rq_reqbuf);
 		LASSERT(req->rq_reqbuf_len == pool->prp_rq_size);
 		OBD_FREE_LARGE(req->rq_reqbuf, pool->prp_rq_size);
-		OBD_FREE(req, sizeof(*req));
+		ptlrpc_request_cache_free(req);
 	}
 	spin_unlock(&pool->prp_lock);
 	OBD_FREE(pool, sizeof(*pool));
@@ -426,12 +454,12 @@ void ptlrpc_add_rqs_to_pool(struct ptlrpc_request_pool *pool, int num_rq)
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
@@ -667,7 +695,7 @@ struct ptlrpc_request *__ptlrpc_request_alloc(struct obd_import *imp,
 		request = ptlrpc_prep_req_from_pool(pool);
 
 	if (!request)
-		OBD_ALLOC_PTR(request);
+		request = ptlrpc_request_cache_alloc(__GFP_IO);
 
 	if (request) {
 		LASSERTF((unsigned long)imp > 0x1000, "%p", imp);
@@ -738,7 +766,7 @@ void ptlrpc_request_free(struct ptlrpc_request *request)
 	if (request->rq_pool)
 		__ptlrpc_free_req_to_pool(request);
 	else
-		OBD_FREE_PTR(request);
+		ptlrpc_request_cache_free(request);
 }
 EXPORT_SYMBOL(ptlrpc_request_free);
 
@@ -2216,7 +2244,7 @@ static void __ptlrpc_free_req(struct ptlrpc_request *request, int locked)
 	if (request->rq_pool)
 		__ptlrpc_free_req_to_pool(request);
 	else
-		OBD_FREE(request, sizeof(*request));
+		ptlrpc_request_cache_free(request);
 }
 
 static int __ptlrpc_req_finished(struct ptlrpc_request *request, int locked);
@@ -2934,7 +2962,7 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 		return ERR_PTR(-EINVAL);
 
 	/* copy some code from deprecated fakereq. */
-	OBD_ALLOC_PTR(req);
+	req = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (req == NULL) {
 		CERROR("ptlrpc: run out of memory!\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index 58d089c..f5e0d31 100644
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
index ab36347..fa54c5a 100644
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
index 419e634..938aaed 100644
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
@@ -117,14 +122,16 @@ cleanup:
 		ptlrpc_nrs_fini();
 	case 7:
 		sptlrpc_fini();
-	case 5:
+	case 6:
 		ldlm_exit();
-	case 4:
+	case 5:
 		ptlrpc_stop_pinger();
-	case 3:
+	case 4:
 		ptlrpc_connection_fini();
-	case 2:
+	case 3:
 		ptlrpc_exit_portals();
+	case 2:
+		ptlrpc_request_cache_fini();
 	case 1:
 		ptlrpc_hr_fini();
 		req_layout_fini();
@@ -142,6 +149,7 @@ static void __exit ptlrpc_exit(void)
 	ldlm_exit();
 	ptlrpc_stop_pinger();
 	ptlrpc_exit_portals();
+	ptlrpc_request_cache_fini();
 	ptlrpc_hr_fini();
 	ptlrpc_connection_fini();
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 962b31d..7a10f73 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -904,7 +904,7 @@ int sptlrpc_import_check_ctx(struct obd_import *imp)
 		return -EACCES;
 	}
 
-	OBD_ALLOC_PTR(req);
+	req = ptlrpc_request_cache_alloc(__GFP_IO);
 	if (!req)
 		return -ENOMEM;
 
@@ -920,7 +920,7 @@ int sptlrpc_import_check_ctx(struct obd_import *imp)
 	rc = sptlrpc_req_refresh_ctx(req, 0);
 	LASSERT(list_empty(&req->rq_ctx_chain));
 	sptlrpc_cli_ctx_put(req->rq_cli_ctx, 1);
-	OBD_FREE_PTR(req);
+	ptlrpc_request_cache_free(req);
 
 	return rc;
 }
@@ -1177,7 +1177,7 @@ void sptlrpc_cli_finish_early_reply(struct ptlrpc_request *early_req)
 
 	sptlrpc_cli_ctx_put(early_req->rq_cli_ctx, 1);
 	OBD_FREE_LARGE(early_req->rq_repbuf, early_req->rq_repbuf_len);
-	OBD_FREE_PTR(early_req);
+	ptlrpc_request_cache_free(early_req);
 }
 
 /**************************************************
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 21de868..abd0b8d 100644
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
 
@@ -1306,14 +1306,12 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
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
@@ -1370,7 +1368,8 @@ out_put:
 out:
 	sptlrpc_svc_ctx_decref(reqcopy);
 	OBD_FREE_LARGE(reqmsg, req->rq_reqlen);
-	OBD_FREE(reqcopy, sizeof(*reqcopy));
+out_free:
+	ptlrpc_request_cache_free(reqcopy);
 	return rc;
 }
 
-- 
1.7.9.5

