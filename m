Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaCACRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:30 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42627 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaCACR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:29 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Liang Zhen <liang.zhen@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 14/17] lustre/ptlrpc: re-enqueue ptlrpcd worker
Date: Fri, 28 Feb 2014 21:16:43 -0500
Message-Id: <1393640206-20286-15-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Zhen <liang.zhen@intel.com>

osc_extent_wait can be stuck in scenario like this:

1) thread-1 held an active extent
2) thread-2 called flush cache, and marked this extent as "urgent"
   and "sync_wait"
3) thread-3 wants to write to the same extent, osc_extent_find will
   get "conflict" because this extent is "sync_wait", so it starts
   to wait...
4) cl_writeback_work has been scheduled by thread-4 to write some
   other extents, it has sent RPCs but not returned yet.
5) thread-1 finished his work, and called osc_extent_release()->
   osc_io_unplug_async()->ptlrpcd_queue_work(), but found
   cl_writeback_work is still running, so it's ignored (-EBUSY)
6) thread-3 is stuck because nobody will wake him up.

This patch allows ptlrpcd_work to be rescheduled, so it will not
miss request anymore

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-on: http://review.whamcloud.com/8922
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4509
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 64 +++++++++++++++++----------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 7b97c64..4c9e006 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -48,6 +48,7 @@
 #include "ptlrpc_internal.h"
 
 static int ptlrpc_send_new_req(struct ptlrpc_request *req);
+static int ptlrpcd_check_work(struct ptlrpc_request *req);
 
 /**
  * Initialize passed in client structure \a cl.
@@ -1784,6 +1785,10 @@ interpret:
 
 		ptlrpc_req_interpret(env, req, req->rq_status);
 
+		if (ptlrpcd_check_work(req)) {
+			atomic_dec(&set->set_remaining);
+			continue;
+		}
 		ptlrpc_rqphase_move(req, RQ_PHASE_COMPLETE);
 
 		CDEBUG(req->rq_reqmsg != NULL ? D_RPCTRACE : 0,
@@ -2957,22 +2962,50 @@ EXPORT_SYMBOL(ptlrpc_sample_next_xid);
  *    have delay before it really runs by ptlrpcd thread.
  */
 struct ptlrpc_work_async_args {
-	__u64   magic;
 	int   (*cb)(const struct lu_env *, void *);
 	void   *cbdata;
 };
 
-#define PTLRPC_WORK_MAGIC 0x6655436b676f4f44ULL /* magic code */
+static void ptlrpcd_add_work_req(struct ptlrpc_request *req)
+{
+	/* re-initialize the req */
+	req->rq_timeout		= obd_timeout;
+	req->rq_sent		= cfs_time_current_sec();
+	req->rq_deadline	= req->rq_sent + req->rq_timeout;
+	req->rq_reply_deadline	= req->rq_deadline;
+	req->rq_phase		= RQ_PHASE_INTERPRET;
+	req->rq_next_phase	= RQ_PHASE_COMPLETE;
+	req->rq_xid		= ptlrpc_next_xid();
+	req->rq_import_generation = req->rq_import->imp_generation;
+
+	ptlrpcd_add_req(req, PDL_POLICY_ROUND, -1);
+}
 
 static int work_interpreter(const struct lu_env *env,
 			    struct ptlrpc_request *req, void *data, int rc)
 {
 	struct ptlrpc_work_async_args *arg = data;
 
-	LASSERT(arg->magic == PTLRPC_WORK_MAGIC);
+	LASSERT(ptlrpcd_check_work(req));
 	LASSERT(arg->cb != NULL);
 
-	return arg->cb(env, arg->cbdata);
+	rc = arg->cb(env, arg->cbdata);
+
+	list_del_init(&req->rq_set_chain);
+	req->rq_set = NULL;
+
+	if (atomic_dec_return(&req->rq_refcount) > 1) {
+		atomic_set(&req->rq_refcount, 2);
+		ptlrpcd_add_work_req(req);
+	}
+	return rc;
+}
+
+static int worker_format;
+
+static int ptlrpcd_check_work(struct ptlrpc_request *req)
+{
+	return req->rq_pill.rc_fmt == (void *)&worker_format;
 }
 
 /**
@@ -3005,6 +3038,7 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 	req->rq_receiving_reply = 0;
 	req->rq_must_unlink = 0;
 	req->rq_no_delay = req->rq_no_resend = 1;
+	req->rq_pill.rc_fmt = (void *)&worker_format;
 
 	spin_lock_init(&req->rq_lock);
 	INIT_LIST_HEAD(&req->rq_list);
@@ -3018,7 +3052,6 @@ void *ptlrpcd_alloc_work(struct obd_import *imp,
 
 	CLASSERT(sizeof(*args) <= sizeof(req->rq_async_args));
 	args = ptlrpc_req_async_args(req);
-	args->magic  = PTLRPC_WORK_MAGIC;
 	args->cb     = cb;
 	args->cbdata = cbdata;
 
@@ -3048,25 +3081,8 @@ int ptlrpcd_queue_work(void *handler)
 	 * req as opaque data. - Jinshan
 	 */
 	LASSERT(atomic_read(&req->rq_refcount) > 0);
-	if (atomic_read(&req->rq_refcount) > 1)
-		return -EBUSY;
-
-	if (atomic_inc_return(&req->rq_refcount) > 2) { /* race */
-		atomic_dec(&req->rq_refcount);
-		return -EBUSY;
-	}
-
-	/* re-initialize the req */
-	req->rq_timeout	= obd_timeout;
-	req->rq_sent	   = cfs_time_current_sec();
-	req->rq_deadline       = req->rq_sent + req->rq_timeout;
-	req->rq_reply_deadline = req->rq_deadline;
-	req->rq_phase	  = RQ_PHASE_INTERPRET;
-	req->rq_next_phase     = RQ_PHASE_COMPLETE;
-	req->rq_xid	    = ptlrpc_next_xid();
-	req->rq_import_generation = req->rq_import->imp_generation;
-
-	ptlrpcd_add_req(req, PDL_POLICY_ROUND, -1);
+	if (atomic_inc_return(&req->rq_refcount) == 2)
+		ptlrpcd_add_work_req(req);
 	return 0;
 }
 EXPORT_SYMBOL(ptlrpcd_queue_work);
-- 
1.8.5.3

