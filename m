Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaCACU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:20:26 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42593 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbaCACRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:18 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Alexey Lyashkov <alexey_lyashkov@xyratex.com>,
        Patrick Farrell <paf@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 05/17] lustre/mdc: use ibits_known mask for lock match
Date: Fri, 28 Feb 2014 21:16:34 -0500
Message-Id: <1393640206-20286-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Lyashkov <alexey_lyashkov@xyratex.com>

Before revalidating a lock on the client, mask the lock bits against
the lock bits supported by the server (ibits_known), so newer clients
will find valid locks given by older server versions.

Signed-off-by: Patrick Farrell <paf@cray.com>
Signed-off-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
Reviewed-on: http://review.whamcloud.com/8636
Xyratex-bug-id: MRP-1583
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4405
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_export.h | 8 ++++++++
 drivers/staging/lustre/lustre/mdc/mdc_locks.c         | 8 +++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_export.h b/drivers/staging/lustre/lustre/include/lustre_export.h
index 2feb38b..82a230b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_export.h
+++ b/drivers/staging/lustre/lustre/include/lustre_export.h
@@ -380,6 +380,14 @@ static inline bool imp_connect_lvb_type(struct obd_import *imp)
 		return false;
 }
 
+static inline __u64 exp_connect_ibits(struct obd_export *exp)
+{
+	struct obd_connect_data *ocd;
+
+	ocd = &exp->exp_connect_data;
+	return ocd->ocd_ibits_known;
+}
+
 extern struct obd_export *class_conn2export(struct lustre_handle *conn);
 extern struct obd_device *class_conn2obd(struct lustre_handle *conn);
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index d9017a5..6ef9e28 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -160,6 +160,8 @@ ldlm_mode_t mdc_lock_match(struct obd_export *exp, __u64 flags,
 	ldlm_mode_t rc;
 
 	fid_build_reg_res_name(fid, &res_id);
+	/* LU-4405: Clear bits not supported by server */
+	policy->l_inodebits.bits &= exp_connect_ibits(exp);
 	rc = ldlm_lock_match(class_exp2obd(exp)->obd_namespace, flags,
 			     &res_id, type, policy, mode, lockh, 0);
 	return rc;
@@ -1087,10 +1089,10 @@ int mdc_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
 			break;
 		}
 
-		mode = ldlm_lock_match(exp->exp_obd->obd_namespace,
-				       LDLM_FL_BLOCK_GRANTED, &res_id,
+		mode = mdc_lock_match(exp, LDLM_FL_BLOCK_GRANTED, fid,
 				       LDLM_IBITS, &policy,
-				       LCK_CR|LCK_CW|LCK_PR|LCK_PW, &lockh, 0);
+				      LCK_CR | LCK_CW | LCK_PR | LCK_PW,
+				      &lockh);
 	}
 
 	if (mode) {
-- 
1.8.5.3

