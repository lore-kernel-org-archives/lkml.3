Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJLCr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:47:29 -0400
Received: from linuxhacker.ru ([217.76.32.60]:38369 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbaJLCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:47:26 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 3/3] staging/lustre/quota: Get rid of compat quota code
Date: Sat, 11 Oct 2014 22:46:54 -0400
Message-Id: <1413082014-10510-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
References: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody should be using any fo the old lustre 1.8 era tools
anymore, so drop compatibility with those.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/llite/dir.c          | 58 ----------------------
 .../staging/lustre/lustre/llite/llite_internal.h   | 18 -------
 2 files changed, 76 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index b0bb709..a9b460d 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1694,64 +1694,6 @@ out_poll:
 		OBD_FREE_PTR(check);
 		return rc;
 	}
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-	case LL_IOC_QUOTACTL_18: {
-		/* copy the old 1.x quota struct for internal use, then copy
-		 * back into old format struct.  For 1.8 compatibility. */
-		struct if_quotactl_18 *qctl_18;
-		struct if_quotactl *qctl_20;
-
-		qctl_18 = kzalloc(sizeof(*qctl_18), GFP_NOFS);
-		if (!qctl_18)
-			return -ENOMEM;
-
-		qctl_20 = kzalloc(sizeof(*qctl_20), GFP_NOFS);
-		if (!qctl_20) {
-			rc = -ENOMEM;
-			goto out_quotactl_18;
-		}
-
-		if (copy_from_user(qctl_18, (void *)arg, sizeof(*qctl_18))) {
-			rc = -ENOMEM;
-			goto out_quotactl_20;
-		}
-
-		QCTL_COPY(qctl_20, qctl_18);
-		qctl_20->qc_idx = 0;
-
-		/* XXX: dqb_valid was borrowed as a flag to mark that
-		 *      only mds quota is wanted */
-		if (qctl_18->qc_cmd == Q_GETQUOTA &&
-		    qctl_18->qc_dqblk.dqb_valid) {
-			qctl_20->qc_valid = QC_MDTIDX;
-			qctl_20->qc_dqblk.dqb_valid = 0;
-		} else if (qctl_18->obd_uuid.uuid[0] != '\0') {
-			qctl_20->qc_valid = QC_UUID;
-			qctl_20->obd_uuid = qctl_18->obd_uuid;
-		} else {
-			qctl_20->qc_valid = QC_GENERAL;
-		}
-
-		rc = quotactl_ioctl(sbi, qctl_20);
-
-		if (rc == 0) {
-			QCTL_COPY(qctl_18, qctl_20);
-			qctl_18->obd_uuid = qctl_20->obd_uuid;
-
-			if (copy_to_user((void *)arg, qctl_18,
-					     sizeof(*qctl_18)))
-				rc = -EFAULT;
-		}
-
-out_quotactl_20:
-		OBD_FREE_PTR(qctl_20);
-out_quotactl_18:
-		OBD_FREE_PTR(qctl_18);
-		return rc;
-	}
-#else
-#warning "remove old LL_IOC_QUOTACTL_18 compatibility code"
-#endif /* LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0) */
 	case LL_IOC_QUOTACTL: {
 		struct if_quotactl *qctl;
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 36aa0fd..2845aab 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -1509,24 +1509,6 @@ static inline void d_lustre_revalidate(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 }
 
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-/* Compatibility for old (1.8) compiled userspace quota code */
-struct if_quotactl_18 {
-	__u32		   qc_cmd;
-	__u32		   qc_type;
-	__u32		   qc_id;
-	__u32		   qc_stat;
-	struct obd_dqinfo       qc_dqinfo;
-	struct obd_dqblk	qc_dqblk;
-	char		    obd_type[16];
-	struct obd_uuid	 obd_uuid;
-};
-#define LL_IOC_QUOTACTL_18	      _IOWR('f', 162, struct if_quotactl_18 *)
-/* End compatibility for old (1.8) compiled userspace quota code */
-#else
-#warning "remove old LL_IOC_QUOTACTL_18 compatibility code"
-#endif /* LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0) */
-
 enum {
 	LL_LAYOUT_GEN_NONE  = ((__u32)-2),	/* layout lock was cancelled */
 	LL_LAYOUT_GEN_EMPTY = ((__u32)-1)	/* for empty layout */
-- 
1.9.3

