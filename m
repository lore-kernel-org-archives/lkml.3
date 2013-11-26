Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3KZCGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:06:07 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44447 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3KZCGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:06:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/16] staging/lustre/mdc: prevent fall through in mdc_iocontrol()
Date: Tue, 26 Nov 2013 10:04:59 +0800
Message-Id: <1385431510-18988-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdc_iocontrol() add a goto to the end of the LL_IOC_HSM_STATE_SET
case, preventing fall through into the next case. In the same
function, replace the return statement in OBD_IOC_QUOTACTL with a
goto, so that a reference to the module is not leaked.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3576
Lustre-change: http://review.whamcloud.com/6962
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   27 +++++++++++------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index ed3a7a0..a09a5c3 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1743,6 +1743,7 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 	case LL_IOC_HSM_STATE_SET:
 		rc = mdc_ioc_hsm_state_set(exp, karg);
+		GOTO(out, rc);
 	case LL_IOC_HSM_ACTION:
 		rc = mdc_ioc_hsm_current_action(exp, karg);
 		GOTO(out, rc);
@@ -1814,8 +1815,8 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		struct obd_quotactl *oqctl;
 
 		OBD_ALLOC_PTR(oqctl);
-		if (!oqctl)
-			return -ENOMEM;
+		if (oqctl == NULL)
+			GOTO(out, rc = -ENOMEM);
 
 		QCTL_COPY(oqctl, qctl);
 		rc = obd_quotactl(exp, oqctl);
@@ -1824,23 +1825,21 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 			qctl->qc_valid = QC_MDTIDX;
 			qctl->obd_uuid = obd->u.cli.cl_target_uuid;
 		}
+
 		OBD_FREE_PTR(oqctl);
-		break;
+		GOTO(out, rc);
 	}
-	case LL_IOC_GET_CONNECT_FLAGS: {
-		if (copy_to_user(uarg,
-				     exp_connect_flags_ptr(exp),
-				     sizeof(__u64)))
+	case LL_IOC_GET_CONNECT_FLAGS:
+		if (copy_to_user(uarg, exp_connect_flags_ptr(exp),
+				 sizeof(*exp_connect_flags_ptr(exp))))
 			GOTO(out, rc = -EFAULT);
-		else
-			GOTO(out, rc = 0);
-	}
-	case LL_IOC_LOV_SWAP_LAYOUTS: {
+
+		GOTO(out, rc = 0);
+	case LL_IOC_LOV_SWAP_LAYOUTS:
 		rc = mdc_ioc_swap_layouts(exp, karg);
-		break;
-	}
+		GOTO(out, rc);
 	default:
-		CERROR("mdc_ioctl(): unrecognised ioctl %#x\n", cmd);
+		CERROR("unrecognised ioctl: cmd = %#x\n", cmd);
 		GOTO(out, rc = -ENOTTY);
 	}
 out:
-- 
1.7.9.5

