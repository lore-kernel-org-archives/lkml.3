Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaCACRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:16 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42574 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaCACRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:12 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>,
        Alexey Lyashkov <alexey_lyashkov@xyratex.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 02/17] lustre/mdc: Check for all attributes validity in revalidate
Date: Fri, 28 Feb 2014 21:16:31 -0500
Message-Id: <1393640206-20286-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GETATTR needs to return attributes protected by different bits, so
we need to ensure all we have locks with all of those bits, not
just UPDATE bit

Signed-off-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/6460
Xyratex-bug-id: MRP-1052
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3240
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 288a41e..1336d47 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -1061,7 +1061,20 @@ int mdc_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
 		fid_build_reg_res_name(fid, &res_id);
 		switch (it->it_op) {
 		case IT_GETATTR:
-			policy.l_inodebits.bits = MDS_INODELOCK_UPDATE;
+			/* File attributes are held under multiple bits:
+			 * nlink is under lookup lock, size and times are
+			 * under UPDATE lock and recently we've also got
+			 * a separate permissions lock for owner/group/acl that
+			 * were protected by lookup lock before.
+			 * Getattr must provide all of that information,
+			 * so we need to ensure we have all of those locks.
+			 * Unfortunately, if the bits are split across multiple
+			 * locks, there's no easy way to match all of them here,
+			 * so an extra RPC would be performed to fetch all
+			 * of those bits at once for now. */
+			policy.l_inodebits.bits = MDS_INODELOCK_UPDATE |
+						  MDS_INODELOCK_LOOKUP |
+						  MDS_INODELOCK_PERM;
 			break;
 		case IT_LAYOUT:
 			policy.l_inodebits.bits = MDS_INODELOCK_LAYOUT;
@@ -1070,6 +1083,7 @@ int mdc_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
 			policy.l_inodebits.bits = MDS_INODELOCK_LOOKUP;
 			break;
 		}
+
 		mode = ldlm_lock_match(exp->exp_obd->obd_namespace,
 				       LDLM_FL_BLOCK_GRANTED, &res_id,
 				       LDLM_IBITS, &policy,
-- 
1.8.5.3

