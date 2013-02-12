Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331Ab3BLPLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:11:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761087Ab3BLPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:11:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ima: Allow appraisal of digitally signed files only
Date: Tue, 12 Feb 2013 10:11:00 -0500
Message-Id: <1360681860-29045-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360681860-29045-1-git-send-email-vgoyal@redhat.com>
References: <1360681860-29045-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ima appraises all the files as specified by the rule. So
if one wants to create a system where only few executables are
signed, that system will not work with IMA.

With secureboot, one needs to disable kexec so that unsigned kernels
can't be booted. To avoid this problem, it was proposed that sign
/sbin/kexec binary and if signatures are verified successfully, give
an special capability to the /sbin/kexec process. And in secureboot
mode processes with that special capability can invoke sys_kexec()
system call.

So there is a need for IMA to allow appraising only signed binaries.
Unsigned binaries will pass the appraisal too, but will not get the
special capability. (Capability patches for that are yet to be written).

This patch adds new option, appraise_type=imasig_optional to allow
appraisal to pass even if no signatures are present on the file. If
signatures are present, then it has to be valid digital signature,
otherwise appraisal will fail.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/ABI/testing/ima_policy  |    2 +-
 security/integrity/ima/ima_appraise.c |   25 ++++++++++++++++++++-----
 security/integrity/ima/ima_policy.c   |    2 ++
 security/integrity/integrity.h        |    1 +
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index de16de3..5ca0c23 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -30,7 +30,7 @@ Description:
 			uid:= decimal value
 			fowner:=decimal value
 		lsm:  	are LSM specific
-		option:	appraise_type:= [imasig]
+		option:	appraise_type:= [imasig] | [imasig_optional]
 
 		default policy:
 			# PROC_SUPER_MAGIC
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3710f44..7b15165 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -124,19 +124,27 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
-	int rc;
+	int rc, audit_info = 0;
+	bool pass_appraisal = false;
 
 	if (!ima_appraise)
 		return 0;
-	if (!inode->i_op->getxattr)
+	if (!inode->i_op->getxattr) {
+		/* getxattr not supported. file couldn't have been signed */
+		if (iint->flags & IMA_DIGSIG_OPTIONAL)
+			pass_appraisal = true;
 		return INTEGRITY_UNKNOWN;
+	}
 
 	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
 				0, GFP_NOFS);
 	if (rc <= 0) {
 		/* File system does not support security xattr */
-		if (rc == -EOPNOTSUPP)
+		if (rc == -EOPNOTSUPP) {
+			if (iint->flags & IMA_DIGSIG_OPTIONAL)
+				pass_appraisal = true;
 			return INTEGRITY_UNKNOWN;
+		}
 
 		if (rc && rc != -ENODATA)
 			goto out;
@@ -158,7 +166,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	}
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST:
-		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+		if (iint->flags & IMA_DIGSIG_REQUIRED ||
+		    iint->flags & IMA_DIGSIG_OPTIONAL) {
 			cause = "IMA signature required";
 			status = INTEGRITY_FAIL;
 			break;
@@ -201,8 +210,14 @@ out:
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		}
+		if (pass_appraisal || (status == INTEGRITY_NOLABEL &&
+		    iint->flags & IMA_DIGSIG_OPTIONAL)) {
+			status = INTEGRITY_PASS;
+			/* Don't flood audit logs with skipped appraise */
+			audit_info = 1;
+		}
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
-				    op, cause, rc, 0);
+				    op, cause, rc, audit_info);
 	} else {
 		ima_cache_flags(iint, func);
 	}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4adcd0f..8b8cd5f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -598,6 +598,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if ((strcmp(args[0].from, "imasig_optional")) == 0)
+				entry->flags |= IMA_DIGSIG_OPTIONAL;
 			else
 				result = -EINVAL;
 			break;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 0ae08fc..f10da74 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -29,6 +29,7 @@
 #define IMA_ACTION_FLAGS	0xff000000
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
+#define IMA_DIGSIG_OPTIONAL	0x04000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
-- 
1.7.7.6

