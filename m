Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab3BNT4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:56:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934896Ab3BNTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: [PATCH 6/6] ima: With appraise_type=optional, audit log some messages as info
Date: Thu, 14 Feb 2013 14:55:45 -0500
Message-Id: <1360871745-20616-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if there integrity status is not INTEGRITY_PASS, it is
logged in audit log (as non info). This is fine because we always
deny access to file for anything other than INTEGRITY_PASS.

But with appraise_type=optional, we will allow access to file even
if appraisal status is not INTEGRITY_PASS. For example, in the case
of INTEGRITY_IMA_NOLABEL. And on this system we don't want to log
each and every executed file which is not signed.

In a typical system we are anticipating that only 1-2 files will
be signed.

So don't flood the audit logs if appraise_type=optional and no
IMA label is present. These messages will still show up if somebody
chooses to enable audit info messages.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/ima/ima_appraise.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index af39a08..ddeadc7 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -124,7 +124,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
-	int rc;
+	int rc, audit_info = 0;
 
 	if (!ima_appraise)
 		return 0;
@@ -199,8 +199,16 @@ out:
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		}
+
+		/*
+		 * If appraisal is optional, and if no label is present,
+		 * log it is info. Don't flood audit logs.
+		 */
+		if ((iint->flags & IMA_APPRAISAL_OPT) &&
+		     status == INTEGRITY_IMA_NOLABEL)
+			audit_info = 1;
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
-				    op, cause, rc, 0);
+				    op, cause, rc, audit_info);
 	} else {
 		ima_cache_flags(iint, func);
 	}
-- 
1.7.7.6

