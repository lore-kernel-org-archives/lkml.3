Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaD0RIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:42 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48132 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaD0RIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:37 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: wang di <di.wang@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 40/47] staging/lustre/mdc: use cl_max_mds_md to pack getattr RPC
Date: Sun, 27 Apr 2014 13:07:04 -0400
Message-Id: <1398618431-29757-41-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

In some cases, cl_default_mds_easize might be zero, especially for
MDC connected to non-MDT0, then mdc might pack getattr RPC with
zero eadatasize.

If client is trying to access remote striped directory with
zero eadatasize, MDT will not return layout information of the
striped direcotry, which will be mis-regarded as non-striped
directory.

So we should use cl_max_mds_easize if cl_default_mds_easize is zero.

Signed-off-by: wang di <di.wang@intel.com>
Reviewed-on: http://review.whamcloud.com/9862
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4847
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 41a18f5..1a8cd98 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -462,6 +462,7 @@ static struct ptlrpc_request *mdc_intent_getattr_pack(struct obd_export *exp,
 					       OBD_MD_FLRMTPERM : OBD_MD_FLACL);
 	struct ldlm_intent    *lit;
 	int		    rc;
+	int		    easize;
 
 	req = ptlrpc_request_alloc(class_exp2cliimp(exp),
 				   &RQF_LDLM_INTENT_GETATTR);
@@ -482,12 +483,15 @@ static struct ptlrpc_request *mdc_intent_getattr_pack(struct obd_export *exp,
 	lit = req_capsule_client_get(&req->rq_pill, &RMF_LDLM_INTENT);
 	lit->opc = (__u64)it->it_op;
 
+	if (obddev->u.cli.cl_default_mds_easize > 0)
+		easize = obddev->u.cli.cl_default_mds_easize;
+	else
+		easize = obddev->u.cli.cl_max_mds_easize;
+
 	/* pack the intended request */
-	mdc_getattr_pack(req, valid, it->it_flags, op_data,
-			 obddev->u.cli.cl_default_mds_easize);
+	mdc_getattr_pack(req, valid, it->it_flags, op_data, easize);
 
-	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obddev->u.cli.cl_default_mds_easize);
+	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER, easize);
 	if (client_is_remote(exp))
 		req_capsule_set_size(&req->rq_pill, &RMF_ACL, RCL_SERVER,
 				     sizeof(struct mdt_remote_perm));
-- 
1.8.5.3

