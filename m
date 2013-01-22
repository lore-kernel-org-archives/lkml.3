Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3AVWIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:08:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41631 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3AVWHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:07:55 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH v2 3/4] ima: per hook cache integrity appraisal status
Date: Tue, 22 Jan 2013 17:07:33 -0500
Message-Id: <1358892454-25045-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012222-9360-0000-0000-00000F8F95E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new IMA policy 'appraise_type=' option, different hooks
can require different methods for appraising a file's integrity.

For example, the existing 'ima_appraise_tcb' policy defines a
generic rule, requiring all root files to be appraised, without
specfying the appraisal method.  A more specific rule could require
all kernel modules, for example, to be signed.

appraise fowner=0 func=MODULE_CHECK appraise_type=imasig
appraise fowner=0

As a result, the integrity appraisal results for the same inode, but
for different hooks, could differ.  This patch caches the integrity
appraisal results on a per hook basis.

Changelog v2:
- Rename ima_cache_status() to ima_set_cache_status()
- Rename and move get_appraise_status() to ima_get_cache_status()
Changelog v0:
- include IMA_APPRAISE/APPRAISED_SUBMASK in IMA_DO/DONE_MASK (Dmitry)
- Support independent MODULE_CHECK appraise status.
- fixed IMA_XXXX_APPRAISE/APPRAISED flags

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/iint.c             | 10 ++++-
 security/integrity/ima/ima.h          | 13 ++++++-
 security/integrity/ima/ima_appraise.c | 71 ++++++++++++++++++++++++++++++-----
 security/integrity/ima/ima_main.c     | 19 ++++++----
 security/integrity/ima/ima_policy.c   | 22 +++++++++++
 security/integrity/integrity.h        | 26 +++++++++++--
 6 files changed, 136 insertions(+), 25 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index d82a5a1..74522db 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -72,7 +72,10 @@ static void iint_free(struct integrity_iint_cache *iint)
 {
 	iint->version = 0;
 	iint->flags = 0UL;
-	iint->ima_status = INTEGRITY_UNKNOWN;
+	iint->ima_file_status = INTEGRITY_UNKNOWN;
+	iint->ima_mmap_status = INTEGRITY_UNKNOWN;
+	iint->ima_bprm_status = INTEGRITY_UNKNOWN;
+	iint->ima_module_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
 	kmem_cache_free(iint_cache, iint);
 }
@@ -149,7 +152,10 @@ static void init_once(void *foo)
 	memset(iint, 0, sizeof *iint);
 	iint->version = 0;
 	iint->flags = 0UL;
-	iint->ima_status = INTEGRITY_UNKNOWN;
+	iint->ima_file_status = INTEGRITY_UNKNOWN;
+	iint->ima_mmap_status = INTEGRITY_UNKNOWN;
+	iint->ima_bprm_status = INTEGRITY_UNKNOWN;
+	iint->ima_module_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
 }
 
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 991844d..ab68bed 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -142,13 +142,16 @@ void ima_delete_rules(void);
 #define IMA_APPRAISE_FIX	0x02
 
 #ifdef CONFIG_IMA_APPRAISE
-int ima_appraise_measurement(struct integrity_iint_cache *iint,
+int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			     struct file *file, const unsigned char *filename);
 int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
+enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
+					   int func);
 
 #else
-static inline int ima_appraise_measurement(struct integrity_iint_cache *iint,
+static inline int ima_appraise_measurement(int func,
+					   struct integrity_iint_cache *iint,
 					   struct file *file,
 					   const unsigned char *filename)
 {
@@ -165,6 +168,12 @@ static inline void ima_update_xattr(struct integrity_iint_cache *iint,
 				    struct file *file)
 {
 }
+
+static inline enum integrity_status ima_get_cache_status(struct integrity_iint_cache
+							 *iint, int func)
+{
+	return INTEGRITY_UNKNOWN;
+}
 #endif
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 8004332..2d4beca 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -51,6 +51,62 @@ static int ima_fix_xattr(struct dentry *dentry,
 				      sizeof(iint->ima_xattr), 0);
 }
 
+/* Return specific func appraised cached result */
+enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
+					   int func)
+{
+	switch(func) {
+	case MMAP_CHECK:
+		return iint->ima_mmap_status;
+	case BPRM_CHECK:
+		return iint->ima_bprm_status;
+	case MODULE_CHECK:
+		return iint->ima_module_status;
+	case FILE_CHECK:
+	default:
+		return iint->ima_file_status;
+	}
+}
+
+static void ima_set_cache_status(struct integrity_iint_cache *iint,
+				 int func, enum integrity_status status)
+{
+	switch(func) {
+	case MMAP_CHECK:
+		iint->ima_mmap_status = status;
+		break;
+	case BPRM_CHECK:
+		iint->ima_bprm_status = status;
+		break;
+	case MODULE_CHECK:
+		iint->ima_module_status = status;
+		break;
+	case FILE_CHECK:
+	default:
+		iint->ima_file_status = status;
+		break;
+	}
+}
+
+static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
+{
+	switch(func) {
+	case MMAP_CHECK:
+		iint->flags |= (IMA_MMAP_APPRAISED | IMA_APPRAISED);
+		break;
+	case BPRM_CHECK:
+		iint->flags |= (IMA_BPRM_APPRAISED | IMA_APPRAISED);
+		break;
+	case MODULE_CHECK:
+		iint->flags |= (IMA_MODULE_APPRAISED | IMA_APPRAISED);
+		break;
+	case FILE_CHECK:
+	default:
+		iint->flags |= (IMA_FILE_APPRAISED | IMA_APPRAISED);
+		break;
+	}
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -59,7 +115,7 @@ static int ima_fix_xattr(struct dentry *dentry,
  *
  * Return 0 on success, error code otherwise
  */
-int ima_appraise_measurement(struct integrity_iint_cache *iint,
+int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			     struct file *file, const unsigned char *filename)
 {
 	struct dentry *dentry = file->f_dentry;
@@ -75,9 +131,6 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 	if (!inode->i_op->getxattr)
 		return INTEGRITY_UNKNOWN;
 
-	if (iint->flags & IMA_APPRAISED)
-		return iint->ima_status;
-
 	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
 				0, GFP_NOFS);
 	if (rc <= 0) {
@@ -99,7 +152,6 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 			cause = "invalid-HMAC";
 		goto out;
 	}
-
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST:
 		if (iint->flags & IMA_DIGSIG_REQUIRED) {
@@ -148,9 +200,9 @@ out:
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
 				    op, cause, rc, 0);
 	} else {
-		iint->flags |= IMA_APPRAISED;
+		ima_cache_flags(iint, func);
 	}
-	iint->ima_status = status;
+	ima_set_cache_status(iint, func, status);
 	kfree(xattr_value);
 	return status;
 }
@@ -196,10 +248,11 @@ void ima_inode_post_setattr(struct dentry *dentry)
 	must_appraise = ima_must_appraise(inode, MAY_ACCESS, POST_SETATTR);
 	iint = integrity_iint_find(inode);
 	if (iint) {
+		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
+				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK |
+				 IMA_ACTION_FLAGS);
 		if (must_appraise)
 			iint->flags |= IMA_APPRAISE;
-		else
-			iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED);
 	}
 	if (!must_appraise)
 		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 3cdd787..66b7f40 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -151,8 +151,10 @@ static int process_measurement(struct file *file, const char *filename,
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
 
-	/* Determine if in appraise/audit/measurement policy,
-	 * returns IMA_MEASURE, IMA_APPRAISE, IMA_AUDIT bitmask.  */
+	/* Return an IMA_MEASURE, IMA_APPRAISE, IMA_AUDIT action
+	 * bitmask based on the appraise/audit/measurement policy.
+	 * Included is the appraise submask.
+	 */
 	action = ima_get_action(inode, mask, function);
 	if (!action)
 		return 0;
@@ -166,16 +168,17 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out;
 
 	/* Determine if already appraised/measured based on bitmask
-	 * (IMA_MEASURE, IMA_MEASURED, IMA_APPRAISE, IMA_APPRAISED,
-	 *  IMA_AUDIT, IMA_AUDITED) */
+	 * (IMA_MEASURE, IMA_MEASURED, IMA_XXXX_APPRAISE, IMA_XXXX_APPRAISED,
+	 *  IMA_AUDIT, IMA_AUDITED)
+	 */
 	iint->flags |= action;
 	action &= IMA_DO_MASK;
 	action &= ~((iint->flags & IMA_DONE_MASK) >> 1);
 
 	/* Nothing to do, just return existing appraised status */
 	if (!action) {
-		if (iint->flags & IMA_APPRAISED)
-			rc = iint->ima_status;
+		if (must_appraise)
+			rc = ima_get_cache_status(iint, function);
 		goto out_digsig;
 	}
 
@@ -191,8 +194,8 @@ static int process_measurement(struct file *file, const char *filename,
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname);
-	if (action & IMA_APPRAISE)
-		rc = ima_appraise_measurement(iint, file, pathname);
+	if (action & IMA_APPRAISE_SUBMASK)
+		rc = ima_appraise_measurement(function, iint, file, pathname);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
 	kfree(pathbuf);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 1a2543a..4d7c0ae 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -218,6 +218,25 @@ retry:
 	return true;
 }
 
+/*
+ * In addition to knowing that we need to appraise the file in general,
+ * we need to differentiate between calling hooks.
+ */
+static int get_subaction(int func)
+{
+	switch(func) {
+	case MMAP_CHECK:
+		return IMA_MMAP_APPRAISE;
+	case BPRM_CHECK:
+		return IMA_BPRM_APPRAISE;
+	case MODULE_CHECK:
+		return IMA_MODULE_APPRAISE;
+	case FILE_CHECK:
+	default:
+		return IMA_FILE_APPRAISE;
+	}
+}
+
 /**
  * ima_match_policy - decision based on LSM and other conditions
  * @inode: pointer to an inode for which the policy decision is being made
@@ -248,6 +267,9 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		action |= entry->flags & IMA_ACTION_FLAGS;
 
 		action |= entry->action & IMA_DO_MASK;
+		if (entry->action & IMA_APPRAISE)
+			action |= get_subaction(func);
+
 		if (entry->action & IMA_DO_MASK)
 			actmask &= ~(entry->action | entry->action << 1);
 		else
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 329ad26..0ae08fc 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -30,9 +30,24 @@
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
 
-#define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT)
-#define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED \
-				 | IMA_COLLECTED)
+#define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
+				 IMA_APPRAISE_SUBMASK)
+#define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED | \
+				 IMA_COLLECTED | IMA_APPRAISED_SUBMASK)
+
+/* iint subaction appraise cache flags */
+#define IMA_FILE_APPRAISE	0x00000100
+#define IMA_FILE_APPRAISED	0x00000200
+#define IMA_MMAP_APPRAISE	0x00000400
+#define IMA_MMAP_APPRAISED	0x00000800
+#define IMA_BPRM_APPRAISE	0x00001000
+#define IMA_BPRM_APPRAISED	0x00002000
+#define IMA_MODULE_APPRAISE	0x00004000
+#define IMA_MODULE_APPRAISED	0x00008000
+#define IMA_APPRAISE_SUBMASK	(IMA_FILE_APPRAISE | IMA_MMAP_APPRAISE | \
+				 IMA_BPRM_APPRAISE | IMA_MODULE_APPRAISE)
+#define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
+				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
@@ -52,7 +67,10 @@ struct integrity_iint_cache {
 	u64 version;		/* track inode changes */
 	unsigned long flags;
 	struct evm_ima_xattr_data ima_xattr;
-	enum integrity_status ima_status:4;
+	enum integrity_status ima_file_status:4;
+	enum integrity_status ima_mmap_status:4;
+	enum integrity_status ima_bprm_status:4;
+	enum integrity_status ima_module_status:4;
 	enum integrity_status evm_status:4;
 };
 
-- 
1.8.1.rc3

