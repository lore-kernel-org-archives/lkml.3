Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaCACT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:19:58 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42596 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaCACRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:18 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 07/17] lustre/mdc: fix bad ERR_PTR usage in mdc_locks.c
Date: Fri, 28 Feb 2014 21:16:36 -0500
Message-Id: <1393640206-20286-8-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdc_intent_open_pack() return an ERR_PTR() rather than NULL when
ldlm_prep_enqueue_req() fails. In mdc_intent_getattr_async() check the
return value of mdc_intent_getattr_pack() using IS_ERR(). Clean up the
includes in mdc_locks.c.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/7886
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4078
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 6ef9e28..6110943 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -37,15 +37,15 @@
 #define DEBUG_SUBSYSTEM S_MDC
 
 # include <linux/module.h>
-# include <linux/pagemap.h>
-# include <linux/miscdevice.h>
 
-#include <lustre_acl.h>
+#include <linux/lustre_intent.h>
+#include <obd.h>
 #include <obd_class.h>
 #include <lustre_dlm.h>
-/* fid_res_name_eq() */
-#include <lustre_fid.h>
-#include <lprocfs_status.h>
+#include <lustre_fid.h> /* fid_res_name_eq() */
+#include <lustre_mdc.h>
+#include <lustre_net.h>
+#include <lustre_req_layout.h>
 #include "mdc_internal.h"
 
 struct mdc_getattr_args {
@@ -336,9 +336,9 @@ static struct ptlrpc_request *mdc_intent_open_pack(struct obd_export *exp,
 			     max(lmmsize, obddev->u.cli.cl_default_mds_easize));
 
 	rc = ldlm_prep_enqueue_req(exp, req, &cancels, count);
-	if (rc) {
+	if (rc < 0) {
 		ptlrpc_request_free(req);
-		return NULL;
+		return ERR_PTR(rc);
 	}
 
 	spin_lock(&req->rq_lock);
@@ -1281,8 +1281,8 @@ int mdc_intent_getattr_async(struct obd_export *exp,
 
 	fid_build_reg_res_name(&op_data->op_fid1, &res_id);
 	req = mdc_intent_getattr_pack(exp, it, op_data);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 
 	rc = mdc_enter_request(&obddev->u.cli);
 	if (rc != 0) {
-- 
1.8.5.3

