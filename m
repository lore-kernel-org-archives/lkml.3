Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3CEUDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:03:23 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37111 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3CEUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:20 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org,
        jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, vjaquez@igalia.com, rene.sapiens@ti.com,
        x0095078@ti.com, omar.ramirez@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] tidspbridge: convert to idr_alloc()
Date: Tue,  5 Mar 2013 12:02:51 -0800
Message-Id: <1362513772-15174-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362513772-15174-1-git-send-email-tj@kernel.org>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

There are some peculiarities and possible bugs in the converted
functions.  This patch preserves those.

* drv_insert_node_res_element() returns -ENOMEM on alloc failure,
  -EFAULT if id space is exhausted.  -EFAULT is at best misleading.

* drv_proc_insert_strm_res_element() is even weirder.  It returns
  -EFAULT if kzalloc() fails, -ENOMEM if idr preloading fails and
  -EPERM if id space is exhausted.  What's going on here?

* drv_proc_insert_strm_res_element() doesn't free *pstrm_res after
  failure.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
Cc: Rene Sapiens <rene.sapiens@ti.com>
Cc: Armando Uribe <x0095078@ti.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/rmgr/drv.c | 70 +++++++++++++---------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index db1da28..be26917 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -76,37 +76,28 @@ int drv_insert_node_res_element(void *hnode, void *node_resource,
 	struct node_res_object **node_res_obj =
 	    (struct node_res_object **)node_resource;
 	struct process_context *ctxt = (struct process_context *)process_ctxt;
-	int status = 0;
 	int retval;
 
 	*node_res_obj = kzalloc(sizeof(struct node_res_object), GFP_KERNEL);
-	if (!*node_res_obj) {
-		status = -ENOMEM;
-		goto func_end;
-	}
+	if (!*node_res_obj)
+		return -ENOMEM;
 
 	(*node_res_obj)->node = hnode;
-	retval = idr_get_new(ctxt->node_id, *node_res_obj,
-						&(*node_res_obj)->id);
-	if (retval == -EAGAIN) {
-		if (!idr_pre_get(ctxt->node_id, GFP_KERNEL)) {
-			pr_err("%s: OUT OF MEMORY\n", __func__);
-			status = -ENOMEM;
-			goto func_end;
-		}
-
-		retval = idr_get_new(ctxt->node_id, *node_res_obj,
-						&(*node_res_obj)->id);
+	retval = idr_alloc(ctxt->node_id, *node_res_obj, 0, 0, GFP_KERNEL);
+	if (retval >= 0) {
+		(*node_res_obj)->id = retval;
+		return 0;
 	}
-	if (retval) {
+
+	kfree(*node_res_obj);
+
+	if (retval == -ENOSPC) {
 		pr_err("%s: FAILED, IDR is FULL\n", __func__);
-		status = -EFAULT;
+		return -EFAULT;
+	} else {
+		pr_err("%s: OUT OF MEMORY\n", __func__);
+		return -ENOMEM;
 	}
-func_end:
-	if (status)
-		kfree(*node_res_obj);
-
-	return status;
 }
 
 /* Release all Node resources and its context
@@ -201,35 +192,26 @@ int drv_proc_insert_strm_res_element(void *stream_obj,
 	struct strm_res_object **pstrm_res =
 	    (struct strm_res_object **)strm_res;
 	struct process_context *ctxt = (struct process_context *)process_ctxt;
-	int status = 0;
 	int retval;
 
 	*pstrm_res = kzalloc(sizeof(struct strm_res_object), GFP_KERNEL);
-	if (*pstrm_res == NULL) {
-		status = -EFAULT;
-		goto func_end;
-	}
+	if (*pstrm_res == NULL)
+		return -EFAULT;
 
 	(*pstrm_res)->stream = stream_obj;
-	retval = idr_get_new(ctxt->stream_id, *pstrm_res,
-						&(*pstrm_res)->id);
-	if (retval == -EAGAIN) {
-		if (!idr_pre_get(ctxt->stream_id, GFP_KERNEL)) {
-			pr_err("%s: OUT OF MEMORY\n", __func__);
-			status = -ENOMEM;
-			goto func_end;
-		}
-
-		retval = idr_get_new(ctxt->stream_id, *pstrm_res,
-						&(*pstrm_res)->id);
+	retval = idr_alloc(ctxt->stream_id, *pstrm_res, 0, 0, GFP_KERNEL);
+	if (retval >= 0) {
+		(*pstrm_res)->id = retval;
+		return 0;
 	}
-	if (retval) {
+
+	if (retval == -ENOSPC) {
 		pr_err("%s: FAILED, IDR is FULL\n", __func__);
-		status = -EPERM;
+		return -EPERM;
+	} else {
+		pr_err("%s: OUT OF MEMORY\n", __func__);
+		return -ENOMEM;
 	}
-
-func_end:
-	return status;
 }
 
 static int drv_proc_free_strm_res(int id, void *p, void *process_ctxt)
-- 
1.8.1.4

