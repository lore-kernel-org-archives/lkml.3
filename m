Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3IJVpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3IJVpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 06/16] ima: export new IMA functions for signature verification
Date: Tue, 10 Sep 2013 17:44:21 -0400
Message-Id: <1378849471-10521-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export IMA functions so that other subsystems can use IMA for file
signature verification.

Why introduce these functions and not use security hooks? Now callers
have new requirements which are not satisfied by the hooks.

a. Caller need to know whether signature verification actually took
   place or not. Based on that caller will set some flags in task.
   security hooks don't give this info. If IMA is disabled or right
   policy is not configured, security hook will still return success.

b. Caller needs to know the signature type. They might just consider
   digital signatures and not rely on hash or hmac type of signatures.
   security hooks don't have any provision where they can enforce what
   kind of signatures need to be present on the file in question.

c. IMA does the caching of appraisal results and does not detect direct
   writes to disk. So it can happen that after initial bprm check one
   can directly write to file on disk and call IMA hook for signature
   verification again after loading executable in memory and verification
   passes as bprm check had passed. But file contents are different as
   a direct write to disk was done and IMA did not detect this file change.

In some previous discussions it was suggested that define a new hook
and always force appraise the file on that hook to avoid caching
related issues (c). Export the type of signature used for appraisal and
allow caller to query it to take care of issue a and b.

I have not taken that approach yet for following reasons.

- Forcing re-appraisal on a particular hook is very odd. What's special
  about that hook that we hard code it.

- Querying type of signature used for appraisal after hook execution
  if racy as same file might have been re-appraised by the time we
  queried the type of signature used for appraisal. I guess this should
  be fixable if done carefully.

- I anyway need to export more functions later to appraise a memory
  buffer (and not file) so for the time being I continued with the approach
  of exporting functions for file appraisal.

I this approach is not acceptable, I can try implementing the other
one. Personally I find this one a cleaner approach.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/ima.h                   |  21 ++++++
 include/linux/integrity.h             |   6 ++
 security/integrity/ima/ima_api.c      |  15 ++++
 security/integrity/ima/ima_appraise.c | 126 ++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h        |   6 --
 5 files changed, 168 insertions(+), 6 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 3c40b5e..60c75bf 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -11,6 +11,8 @@
 #define _LINUX_IMA_H
 
 #include <linux/fs.h>
+#include <linux/integrity.h>
+#include <linux/key.h>
 struct linux_binprm;
 
 #ifdef CONFIG_IMA
@@ -20,6 +22,8 @@ extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_module_check(struct file *file);
 extern bool ima_memlock_file(char *sig, unsigned int siglen);
+extern int ima_file_signature_alloc(struct file *file, char **sig);
+extern int ima_signature_type(char *sig);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -52,6 +56,16 @@ static inline bool ima_memlock_file(char *sig, unsigned int siglen)
 	return false;
 }
 
+static inline int ima_file_signature_alloc(struct file *file, char **sig)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ima_signature_type(char *sig)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_IMA */
 
 #ifdef CONFIG_IMA_APPRAISE
@@ -59,6 +73,7 @@ extern void ima_inode_post_setattr(struct dentry *dentry);
 extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len);
 extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+extern int ima_appraise_file_digsig(struct key *keyring, struct file *file, char *sig, unsigned int siglen);
 #else
 static inline void ima_inode_post_setattr(struct dentry *dentry)
 {
@@ -78,5 +93,11 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
+
+static inline int ima_appraise_file_digsig(struct key *keyring, struct file *file, char *sig, unsigned int siglen)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_IMA_APPRAISE */
 #endif /* _LINUX_IMA_H */
diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 83222ce..b26bd7d 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -20,6 +20,12 @@ enum integrity_status {
 	INTEGRITY_UNKNOWN,
 };
 
+enum evm_ima_xattr_type {
+	IMA_XATTR_DIGEST = 0x01,
+	EVM_XATTR_HMAC,
+	EVM_IMA_XATTR_DIGSIG,
+};
+
 /* List of EVM protected security xattrs */
 #ifdef CONFIG_INTEGRITY
 extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 0f30cf1..95c9412 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -290,3 +290,18 @@ bool ima_memlock_file(char *sig, unsigned int siglen)
 
 	return true;
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
+int ima_signature_type(char *sig)
+{
+	return ((struct evm_ima_xattr_data *)sig)->type;
+}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a9206d1..f8d147a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -15,6 +15,8 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <crypto/public_key.h>
+#include <crypto/hash.h>
 
 #include "ima.h"
 
@@ -107,6 +109,130 @@ static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
 	}
 }
 
+static int ima_get_file_hash(struct file *file, char **_digest,
+				unsigned int *digest_len,
+				enum pkey_hash_algo hash_algo)
+{
+	loff_t i_size, offset = 0;
+	char *rbuf;
+	int ret, read = 0;
+	struct crypto_shash *tfm;
+	size_t desc_size, digest_size;
+	struct shash_desc *desc;
+	char *digest = NULL;
+
+	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rbuf)
+		return -ENOMEM;
+
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[hash_algo], 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	desc->tfm   = tfm;
+	desc->flags = 0;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_desc;
+
+	digest_size = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_size, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	if (!(file->f_mode & FMODE_READ)) {
+		file->f_mode |= FMODE_READ;
+		read = 1;
+	}
+	i_size = i_size_read(file_inode(file));
+	while (offset < i_size) {
+		int rbuf_len;
+
+		rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
+		if (rbuf_len < 0) {
+			ret = rbuf_len;
+			break;
+		}
+		if (rbuf_len == 0)
+			break;
+		offset += rbuf_len;
+
+		ret = crypto_shash_update(desc, rbuf, rbuf_len);
+		if (ret)
+			break;
+	}
+
+	if (!ret) {
+		ret = crypto_shash_final(desc, digest);
+		*_digest = digest;
+		*digest_len = digest_size;
+		digest = NULL;
+	}
+
+	if (read)
+		file->f_mode &= ~FMODE_READ;
+
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	if (digest)
+		kfree(digest);
+	kfree(rbuf);
+	return ret;
+}
+
+/*
+ * Appraise a file with a given digital signature
+ * keyring: keyring to use for appraisal
+ * sig: signature
+ * siglen: length of signature
+ *
+ * Returns 0 on successful appraisal, error otherwise.
+ */
+int ima_appraise_file_digsig(struct key *keyring, struct file *file, char *sig,
+				unsigned int siglen)
+{
+	struct evm_ima_xattr_data *xattr_value;
+	int ret = 0;
+	char *digest = NULL;
+	enum pkey_hash_algo hash_algo;
+	unsigned int digest_len = 0;
+
+	xattr_value = (struct evm_ima_xattr_data*) sig;
+
+	if (xattr_value->type != EVM_IMA_XATTR_DIGSIG)
+		return -EBADMSG;
+
+	ret = integrity_digsig_get_hash_algo(xattr_value->digest);
+	if (ret < 0)
+		return ret;
+
+	hash_algo = (enum pkey_hash_algo)ret;
+	ret = ima_get_file_hash(file, &digest, &digest_len, hash_algo);
+	if (ret)
+		return ret;
+
+	ret = integrity_digsig_verify_keyring(keyring, xattr_value->digest,
+				integrity_get_digsig_size(xattr_value->digest),
+				digest, digest_len);
+	kfree(digest);
+	return ret;
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 284bb8d..f7db589 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -51,12 +51,6 @@
 #define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
 				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
 
-enum evm_ima_xattr_type {
-	IMA_XATTR_DIGEST = 0x01,
-	EVM_XATTR_HMAC,
-	EVM_IMA_XATTR_DIGSIG,
-};
-
 struct evm_ima_xattr_data {
 	u8 type;
 	u8 digest[SHA1_DIGEST_SIZE];
-- 
1.8.3.1

