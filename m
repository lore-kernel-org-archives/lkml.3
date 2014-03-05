Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaCENEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:04:44 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:52822 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaCENEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:04:42 -0500
From: "Maxin B. John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        josh@joshtriplett.org, bergwolf@gmail.com,
        dulshani.gunawardhana89@gmail.com, jinshan.xiong@intel.com,
        alexey.zhuravlev@intel.com, "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH 1/2] lustre/mdc_lib: fix possible null pointer dereference
Date: Wed,  5 Mar 2014 14:04:35 +0100
Message-Id: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

cppcheck reported possible null pointer dereference in mdc_lib.c

[lustre/lustre/mdc/mdc_lib.c:233]: (error) Possible null pointer dereference
: op_data - otherwise it is redundant to check if op_data is null at line 226

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c |   41 ++++++++++++++-------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 91f6876..594e07c 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -223,29 +223,30 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	rec->cr_fsuid    = from_kuid(&init_user_ns, current_fsuid());
 	rec->cr_fsgid    = from_kgid(&init_user_ns, current_fsgid());
 	rec->cr_cap      = cfs_curproc_cap_pack();
+
 	if (op_data != NULL) {
 		rec->cr_fid1 = op_data->op_fid1;
 		rec->cr_fid2 = op_data->op_fid2;
-	}
-	rec->cr_mode     = mode;
-	cr_flags = mds_pack_open_flags(flags, mode);
-	rec->cr_rdev     = rdev;
-	rec->cr_time     = op_data->op_mod_time;
-	rec->cr_suppgid1 = op_data->op_suppgids[0];
-	rec->cr_suppgid2 = op_data->op_suppgids[1];
-	rec->cr_bias     = op_data->op_bias;
-	rec->cr_umask    = current_umask();
-	rec->cr_old_handle = op_data->op_handle;
-
-	mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
-	/* the next buffer is child capa, which is used for replay,
-	 * will be packed from the data in reply message. */
-
-	if (op_data->op_name) {
-		tmp = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
-		LOGL0(op_data->op_name, op_data->op_namelen, tmp);
-		if (op_data->op_bias & MDS_CREATE_VOLATILE)
-			cr_flags |= MDS_OPEN_VOLATILE;
+		rec->cr_mode     = mode;
+		cr_flags = mds_pack_open_flags(flags, mode);
+		rec->cr_rdev     = rdev;
+		rec->cr_time     = op_data->op_mod_time;
+		rec->cr_suppgid1 = op_data->op_suppgids[0];
+		rec->cr_suppgid2 = op_data->op_suppgids[1];
+		rec->cr_bias     = op_data->op_bias;
+		rec->cr_umask    = current_umask();
+		rec->cr_old_handle = op_data->op_handle;
+
+		mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
+		/* the next buffer is child capa, which is used for replay,
+		* will be packed from the data in reply message. */
+
+		if (op_data->op_name) {
+			tmp = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
+			LOGL0(op_data->op_name, op_data->op_namelen, tmp);
+			if (op_data->op_bias & MDS_CREATE_VOLATILE)
+				cr_flags |= MDS_OPEN_VOLATILE;
+		}
 	}
 
 	if (lmm) {
-- 
1.7.10.4

