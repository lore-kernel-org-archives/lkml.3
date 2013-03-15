Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3COUgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab3COUgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:36:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@redhat.com
Subject: [PATCH 2/4] ima: export new IMA functions for signature verification
Date: Fri, 15 Mar 2013 16:35:56 -0400
Message-Id: <1363379758-10071-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export IMA functions so that other subsystems can use IMA for file
signature verification.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/ima.h                   |   24 +++++++++++++++++++-
 include/linux/integrity.h             |    7 ++++++
 security/integrity/ima/ima_api.c      |   16 +++++++++++++
 security/integrity/ima/ima_appraise.c |   39 +++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 86c361e..846e784 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -11,6 +11,7 @@
 #define _LINUX_IMA_H
 
 #include <linux/fs.h>
+#include <linux/integrity.h>
 struct linux_binprm;
 
 #ifdef CONFIG_IMA
@@ -19,7 +20,8 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_module_check(struct file *file);
-
+extern int ima_file_signature_alloc(struct file *file, char **sig);
+extern int ima_signature_type(char *sig, enum evm_ima_xattr_type *sig_type);
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
 {
@@ -46,6 +48,18 @@ static inline int ima_module_check(struct file *file)
 	return 0;
 }
 
+static inline int ima_file_signature_alloc(struct file *file, char **sig)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ima_signature_type(char *sig,
+					enum evm_ima_xattr_type *sig_type)
+{
+	return -EOPNOTSUPP;
+}
+
+
 #endif /* CONFIG_IMA_H */
 
 #ifdef CONFIG_IMA_APPRAISE
@@ -53,6 +67,7 @@ extern void ima_inode_post_setattr(struct dentry *dentry);
 extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len);
 extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+extern int ima_appraise_file(struct file *file, char *sig, unsigned int siglen);
 #else
 static inline void ima_inode_post_setattr(struct dentry *dentry)
 {
@@ -72,5 +87,12 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
+
+static inline int ima_appraise_file(struct file *file, char *sig,
+			unsigned int siglen)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_IMA_APPRAISE_H */
 #endif /* _LINUX_IMA_H */
diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 66c5fe9..0aa1b42 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -20,6 +20,13 @@ enum integrity_status {
 	INTEGRITY_UNKNOWN,
 };
 
+enum evm_ima_xattr_type {
+	IMA_XATTR_DIGEST = 0x01,
+	EVM_XATTR_HMAC,
+	EVM_IMA_XATTR_DIGSIG,
+	EVM_IMA_XATTR_DIGSIG_ASYMMETRIC,
+};
+
 /* List of EVM protected security xattrs */
 #ifdef CONFIG_INTEGRITY
 extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1c03e8f..cb23538 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -254,3 +254,19 @@ const char *ima_d_path(struct path *path, char **pathbuf)
 	}
 	return pathname;
 }
+
+/*
+ * Get ima signature.
+ */
+int ima_file_signature_alloc(struct file *file, char **sig)
+{
+	struct dentry *dentry = file->f_dentry;
+
+	return vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, sig, 0, GFP_NOFS);
+}
+
+int ima_signature_type(char *sig, enum evm_ima_xattr_type *sig_type)
+{
+	*sig_type = ((struct evm_ima_xattr_data *)sig)->type;
+	return 0;
+}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 9bc0723..4e44874 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -108,6 +108,45 @@ static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
 }
 
 /*
+ * Appraise a file with a given signature
+ * sig: signature
+ * siglen: length of signature
+ *
+ * Returns 0 on successful appraisal, error otherwise.
+ */
+int ima_appraise_file(struct file *file, char *sig, unsigned int siglen)
+{
+	struct evm_ima_xattr_data *xattr_value;
+	int ret = 0, rc;
+	/* FIX Me. retrieve hash algo from sig */
+	char digest[SHA1_DIGEST_SIZE];
+
+	xattr_value = (struct evm_ima_xattr_data*) sig;
+	ret = ima_calc_file_hash(file, digest);
+	if (ret)
+		return ret;
+
+	switch (xattr_value->type) {
+	case IMA_XATTR_DIGEST:
+		rc = memcmp(xattr_value->digest, digest, SHA1_DIGEST_SIZE);
+		if (!rc)
+			ret = -EKEYREJECTED;
+		break;
+	case EVM_IMA_XATTR_DIGSIG:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
+		return integrity_digsig_verify(xattr_value->type,
+					     INTEGRITY_KEYRING_IMA,
+					     xattr_value->digest, siglen - 1,
+					     digest, SHA1_DIGEST_SIZE);
+	default:
+		ret = -EBADMSG;
+		break;
+	}
+
+	return ret;
+}
+
+/*
  * ima_appraise_measurement - appraise file measurement
  *
  * Call evm_verifyxattr() to verify the integrity of 'security.ima'.
-- 
1.7.7.6

