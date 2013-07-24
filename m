Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3GXIfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:35:54 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31838 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:35:50 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Leibovici <thomas.leibovici@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/8] staging/lustre/lmv: support DNE with HSM.
Date: Wed, 24 Jul 2013 16:31:25 +0800
Message-Id: <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Leibovici <thomas.leibovici@cea.fr>

Send HSM requests to the appropriate MDT. Split lists of fids of HSM
actions into one list per MDT.
Move kuc registration/unregistration from MDC to LMV as this is not
MDT related.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3365
Lustre-change: http://review.whamcloud.com/6714
Signed-off-by: Thomas Leibovici <thomas.leibovici@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c     |  200 ++++++++++++++++++++++-
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   18 +--
 2 files changed, 205 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 5bd952a..11c8d64 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -44,6 +44,7 @@
 #include <asm/div64.h>
 #include <linux/seq_file.h>
 #include <linux/namei.h>
+#include <asm/uaccess.h>
 
 #include <lustre/lustre_idl.h>
 #include <obd_support.h>
@@ -783,6 +784,125 @@ out_fid2path:
 	RETURN(rc);
 }
 
+static int lmv_hsm_req_count(struct lmv_obd *lmv,
+			     const struct hsm_user_request *hur,
+			     const struct lmv_tgt_desc *tgt_mds)
+{
+	int			i, nr = 0;
+	struct lmv_tgt_desc    *curr_tgt;
+
+	/* count how many requests must be sent to the given target */
+	for (i = 0; i < hur->hur_request.hr_itemcount; i++) {
+		curr_tgt = lmv_find_target(lmv, &hur->hur_user_item[i].hui_fid);
+		if (obd_uuid_equals(&curr_tgt->ltd_uuid, &tgt_mds->ltd_uuid))
+			nr++;
+	}
+	return nr;
+}
+
+static void lmv_hsm_req_build(struct lmv_obd *lmv,
+			      struct hsm_user_request *hur_in,
+			      const struct lmv_tgt_desc *tgt_mds,
+			      struct hsm_user_request *hur_out)
+{
+	int			i, nr_out;
+	struct lmv_tgt_desc    *curr_tgt;
+
+	/* build the hsm_user_request for the given target */
+	hur_out->hur_request = hur_in->hur_request;
+	nr_out = 0;
+	for (i = 0; i < hur_in->hur_request.hr_itemcount; i++) {
+		curr_tgt = lmv_find_target(lmv,
+					&hur_in->hur_user_item[i].hui_fid);
+		if (obd_uuid_equals(&curr_tgt->ltd_uuid, &tgt_mds->ltd_uuid)) {
+			hur_out->hur_user_item[nr_out] =
+				hur_in->hur_user_item[i];
+			nr_out++;
+		}
+	}
+	hur_out->hur_request.hr_itemcount = nr_out;
+	memcpy(hur_data(hur_out), hur_data(hur_in),
+	       hur_in->hur_request.hr_data_len);
+}
+
+static int lmv_hsm_ct_unregister(struct lmv_obd *lmv, unsigned int cmd, int len,
+				 struct lustre_kernelcomm *lk, void *uarg)
+{
+	int	i, rc = 0;
+	ENTRY;
+
+	/* unregister request (call from llapi_hsm_copytool_fini) */
+	for (i = 0; i < lmv->desc.ld_tgt_count; i++) {
+		/* best effort: try to clean as much as possible
+		 * (continue on error) */
+		obd_iocontrol(cmd, lmv->tgts[i]->ltd_exp, len, lk, uarg);
+	}
+
+	/* Whatever the result, remove copytool from kuc groups.
+	 * Unreached coordinators will get EPIPE on next requests
+	 * and will unregister automatically.
+	 */
+	rc = libcfs_kkuc_group_rem(lk->lk_uid, lk->lk_group);
+	RETURN(rc);
+}
+
+static int lmv_hsm_ct_register(struct lmv_obd *lmv, unsigned int cmd, int len,
+			       struct lustre_kernelcomm *lk, void *uarg)
+{
+	struct file	*filp;
+	int		 i, j, err;
+	int		 rc = 0;
+	bool		 any_set = false;
+	ENTRY;
+
+	/* All or nothing: try to register to all MDS.
+	 * In case of failure, unregister from previous MDS,
+	 * except if it because of inactive target. */
+	for (i = 0; i < lmv->desc.ld_tgt_count; i++) {
+		err = obd_iocontrol(cmd, lmv->tgts[i]->ltd_exp,
+				   len, lk, uarg);
+		if (err) {
+			if (lmv->tgts[i]->ltd_active) {
+				/* permanent error */
+				CERROR("error: iocontrol MDC %s on MDT"
+				       "idx %d cmd %x: err = %d\n",
+					lmv->tgts[i]->ltd_uuid.uuid,
+					i, cmd, err);
+				rc = err;
+				lk->lk_flags |= LK_FLG_STOP;
+				/* unregister from previous MDS */
+				for (j = 0; j < i; j++)
+					obd_iocontrol(cmd,
+						  lmv->tgts[j]->ltd_exp,
+						  len, lk, uarg);
+				RETURN(rc);
+			}
+			/* else: transient error.
+			 * kuc will register to the missing MDT
+			 * when it is back */
+		} else {
+			any_set = true;
+		}
+	}
+
+	if (!any_set)
+		/* no registration done: return error */
+		RETURN(-ENOTCONN);
+
+	/* at least one registration done, with no failure */
+	filp = fget(lk->lk_wfd);
+	if (filp == NULL) {
+		RETURN(-EBADF);
+	}
+	rc = libcfs_kkuc_group_add(filp, lk->lk_uid, lk->lk_group, lk->lk_data);
+	if (rc != 0 && filp != NULL)
+		fput(filp);
+	RETURN(rc);
+}
+
+
+
+
 static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 			 int len, void *karg, void *uarg)
 {
@@ -908,7 +1028,77 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 	}
 	case LL_IOC_HSM_STATE_GET:
 	case LL_IOC_HSM_STATE_SET:
-	case LL_IOC_HSM_ACTION:
+	case LL_IOC_HSM_ACTION: {
+		struct md_op_data	*op_data = karg;
+		struct lmv_tgt_desc	*tgt;
+
+		tgt = lmv_find_target(lmv, &op_data->op_fid1);
+		if (IS_ERR(tgt))
+				RETURN(PTR_ERR(tgt));
+
+		if (tgt->ltd_exp == NULL)
+				RETURN(-EINVAL);
+
+		rc = obd_iocontrol(cmd, tgt->ltd_exp, len, karg, uarg);
+		break;
+	}
+	case LL_IOC_HSM_PROGRESS: {
+		const struct hsm_progress_kernel *hpk = karg;
+		struct lmv_tgt_desc	*tgt;
+
+		tgt = lmv_find_target(lmv, &hpk->hpk_fid);
+		if (IS_ERR(tgt))
+			RETURN(PTR_ERR(tgt));
+		rc = obd_iocontrol(cmd, tgt->ltd_exp, len, karg, uarg);
+		break;
+	}
+	case LL_IOC_HSM_REQUEST: {
+		struct hsm_user_request *hur = karg;
+		struct lmv_tgt_desc	*tgt;
+		unsigned int reqcount = hur->hur_request.hr_itemcount;
+
+		if (reqcount == 0)
+			RETURN(0);
+
+		/* if the request is about a single fid
+		 * or if there is a single MDS, no need to split
+		 * the request. */
+		if (reqcount == 1 || count == 1) {
+			tgt = lmv_find_target(lmv,
+					      &hur->hur_user_item[0].hui_fid);
+			if (IS_ERR(tgt))
+				RETURN(PTR_ERR(tgt));
+			rc = obd_iocontrol(cmd, tgt->ltd_exp, len, karg, uarg);
+		} else {
+			/* split fid list to their respective MDS */
+			for (i = 0; i < count; i++) {
+				unsigned int		nr, reqlen;
+				int			rc1;
+				struct hsm_user_request *req;
+
+				nr = lmv_hsm_req_count(lmv, hur, lmv->tgts[i]);
+				if (nr == 0) /* nothing for this MDS */
+					continue;
+
+				/* build a request with fids for this MDS */
+				reqlen = offsetof(typeof(*hur),
+						  hur_user_item[nr])
+					 + hur->hur_request.hr_data_len;
+				OBD_ALLOC_LARGE(req, reqlen);
+				if (req == NULL)
+					RETURN(-ENOMEM);
+
+				lmv_hsm_req_build(lmv, hur, lmv->tgts[i], req);
+
+				rc1 = obd_iocontrol(cmd, lmv->tgts[i]->ltd_exp,
+						    reqlen, req, uarg);
+				if (rc1 != 0 && rc == 0)
+					rc = rc1;
+				OBD_FREE_LARGE(req, reqlen);
+			}
+		}
+		break;
+	}
 	case LL_IOC_LOV_SWAP_LAYOUTS: {
 		struct md_op_data	*op_data = karg;
 		struct lmv_tgt_desc	*tgt1, *tgt2;
@@ -931,6 +1121,14 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 		rc = obd_iocontrol(cmd, tgt1->ltd_exp, len, karg, uarg);
 		break;
 	}
+	case LL_IOC_HSM_CT_START: {
+		struct lustre_kernelcomm *lk = karg;
+		if (lk->lk_flags & LK_FLG_STOP)
+			rc = lmv_hsm_ct_unregister(lmv, cmd, len, lk, uarg);
+		else
+			rc = lmv_hsm_ct_register(lmv, cmd, len, lk, uarg);
+		break;
+	}
 	default:
 		for (i = 0; i < count; i++) {
 			struct obd_device *mdc_obd;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index b8bf2dc..191edc6 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1771,6 +1771,9 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 	case LL_IOC_HSM_CT_START:
 		rc = mdc_ioc_hsm_ct_start(exp, karg);
+		/* ignore if it was already registered on this MDS. */
+		if (rc == -EEXIST)
+			rc = 0;
 		GOTO(out, rc);
 	case LL_IOC_HSM_PROGRESS:
 		rc = mdc_ioc_hsm_progress(exp, karg);
@@ -1988,19 +1991,10 @@ static int mdc_ioc_hsm_ct_start(struct obd_export *exp,
 	       lk->lk_uid, lk->lk_group, lk->lk_flags);
 
 	if (lk->lk_flags & LK_FLG_STOP) {
-		rc = libcfs_kkuc_group_rem(lk->lk_uid, lk->lk_group);
 		/* Unregister with the coordinator */
-		if (rc == 0)
-			rc = mdc_ioc_hsm_ct_unregister(imp);
+		rc = mdc_ioc_hsm_ct_unregister(imp);
 	} else {
-		struct file *fp = fget(lk->lk_wfd);
-
-		rc = libcfs_kkuc_group_add(fp, lk->lk_uid, lk->lk_group,
-					   lk->lk_data);
-		if (rc && fp)
-			fput(fp);
-		if (rc == 0)
-			rc = mdc_ioc_hsm_ct_register(imp, archive);
+		rc = mdc_ioc_hsm_ct_register(imp, archive);
 	}
 
 	return rc;
@@ -2325,7 +2319,7 @@ static int mdc_import_event(struct obd_device *obd, struct obd_import *imp,
 	}
 	case IMP_EVENT_ACTIVE:
 		rc = obd_notify_observer(obd, obd, OBD_NOTIFY_ACTIVE, NULL);
-		/* restore re-establish kuc registration after reconnecting */
+		/* redo the kuc registration after reconnecting */
 		if (rc == 0)
 			rc = mdc_kuc_reregister(imp);
 		break;
-- 
1.7.1

