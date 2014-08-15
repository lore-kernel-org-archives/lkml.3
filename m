Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaHOQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:53:41 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41307 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaHOQxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:53:39 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Fan Yong <fan.yong@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 04/10] staging/lustre/ldlm: drop redundant ibits lock interoperability check
Date: Fri, 15 Aug 2014 12:48:09 -0400
Message-Id: <1408121295-29115-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

In very old release (older than Lustre-1.8), if the client talks with
the server that does not support ibits lock, then the client needs to
convert it as plain lock. Such interoperability check and convertion
is out of date for a long time. Drop it.

Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-on: http://review.whamcloud.com/11004
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4971
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/lustre/include/obd_support.h    |  1 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     | 50 +++-------------------
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  | 15 +------
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 15 +++++--
 4 files changed, 19 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 92c8992..874606a 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -402,6 +402,7 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_TGT_LAST_REPLAY	 0x710
 #define OBD_FAIL_TGT_CLIENT_ADD	  0x711
 #define OBD_FAIL_TGT_RCVG_FLAG	   0x712
+#define OBD_FAIL_TGT_DELAY_CONDITIONAL	 0x713
 
 #define OBD_FAIL_MDC_REVALIDATE_PAUSE    0x800
 #define OBD_FAIL_MDC_ENQUEUE_PAUSE       0x801
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index d022666..3143222 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -613,50 +613,12 @@ EXPORT_SYMBOL(__ldlm_handle2lock);
  */
 void ldlm_lock2desc(struct ldlm_lock *lock, struct ldlm_lock_desc *desc)
 {
-	struct obd_export *exp = lock->l_export ?: lock->l_conn_export;
-
-	/* INODEBITS_INTEROP: If the other side does not support
-	 * inodebits, reply with a plain lock descriptor. */
-	if ((lock->l_resource->lr_type == LDLM_IBITS) &&
-	    (exp && !(exp_connect_flags(exp) & OBD_CONNECT_IBITS))) {
-		/* Make sure all the right bits are set in this lock we
-		   are going to pass to client */
-		LASSERTF(lock->l_policy_data.l_inodebits.bits ==
-			 (MDS_INODELOCK_LOOKUP | MDS_INODELOCK_UPDATE |
-			  MDS_INODELOCK_LAYOUT),
-			 "Inappropriate inode lock bits during conversion %llu\n",
-			 lock->l_policy_data.l_inodebits.bits);
-
-		ldlm_res2desc(lock->l_resource, &desc->l_resource);
-		desc->l_resource.lr_type = LDLM_PLAIN;
-
-		/* Convert "new" lock mode to something old client can
-		   understand */
-		if ((lock->l_req_mode == LCK_CR) ||
-		    (lock->l_req_mode == LCK_CW))
-			desc->l_req_mode = LCK_PR;
-		else
-			desc->l_req_mode = lock->l_req_mode;
-		if ((lock->l_granted_mode == LCK_CR) ||
-		    (lock->l_granted_mode == LCK_CW)) {
-			desc->l_granted_mode = LCK_PR;
-		} else {
-			/* We never grant PW/EX locks to clients */
-			LASSERT((lock->l_granted_mode != LCK_PW) &&
-				(lock->l_granted_mode != LCK_EX));
-			desc->l_granted_mode = lock->l_granted_mode;
-		}
-
-		/* We do not copy policy here, because there is no
-		   policy for plain locks */
-	} else {
-		ldlm_res2desc(lock->l_resource, &desc->l_resource);
-		desc->l_req_mode = lock->l_req_mode;
-		desc->l_granted_mode = lock->l_granted_mode;
-		ldlm_convert_policy_to_wire(lock->l_resource->lr_type,
-					    &lock->l_policy_data,
-					    &desc->l_policy_data);
-	}
+	ldlm_res2desc(lock->l_resource, &desc->l_resource);
+	desc->l_req_mode = lock->l_req_mode;
+	desc->l_granted_mode = lock->l_granted_mode;
+	ldlm_convert_policy_to_wire(lock->l_resource->lr_type,
+				    &lock->l_policy_data,
+				    &desc->l_policy_data);
 }
 EXPORT_SYMBOL(ldlm_lock2desc);
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 8867dc1..37b8608 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -876,21 +876,8 @@ int ldlm_cli_enqueue(struct obd_export *exp, struct ptlrpc_request **reqp,
 		/* for the local lock, add the reference */
 		ldlm_lock_addref_internal(lock, einfo->ei_mode);
 		ldlm_lock2handle(lock, lockh);
-		if (policy != NULL) {
-			/* INODEBITS_INTEROP: If the server does not support
-			 * inodebits, we will request a plain lock in the
-			 * descriptor (ldlm_lock2desc() below) but use an
-			 * inodebits lock internally with both bits set.
-			 */
-			if (einfo->ei_type == LDLM_IBITS &&
-			    !(exp_connect_flags(exp) &
-			      OBD_CONNECT_IBITS))
-				lock->l_policy_data.l_inodebits.bits =
-					MDS_INODELOCK_LOOKUP |
-					MDS_INODELOCK_UPDATE;
-			else
+		if (policy != NULL)
 				lock->l_policy_data = *policy;
-		}
 
 		if (einfo->ei_type == LDLM_EXTENT)
 			lock->l_req_extent = policy->l_extent;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index f522fc5..771b213 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -1024,10 +1024,17 @@ finish:
 
 		spin_unlock(&imp->imp_lock);
 
-		if (!ocd->ocd_ibits_known &&
-		    ocd->ocd_connect_flags & OBD_CONNECT_IBITS)
-			CERROR("Inodebits aware server returned zero compatible"
-			       " bits?\n");
+		if ((imp->imp_connect_flags_orig & OBD_CONNECT_IBITS) &&
+		    !(ocd->ocd_connect_flags & OBD_CONNECT_IBITS)) {
+			LCONSOLE_WARN("%s: MDS %s does not support ibits "
+				      "lock, either very old or invalid: "
+				      "requested %llx, replied %llx\n",
+				      imp->imp_obd->obd_name,
+				      imp->imp_connection->c_remote_uuid.uuid,
+				      imp->imp_connect_flags_orig,
+				      ocd->ocd_connect_flags);
+			GOTO(out, rc = -EPROTO);
+		}
 
 		if ((ocd->ocd_connect_flags & OBD_CONNECT_VERSION) &&
 		    (ocd->ocd_version > LUSTRE_VERSION_CODE +
-- 
1.9.3

