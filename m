Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3IJVpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3IJVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 09/16] ima: define functions to appraise memory buffer contents
Date: Tue, 10 Sep 2013 17:44:24 -0400
Message-Id: <1378849471-10521-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to provide user space with facility that it can call into kernel
for signature verification of a file. Trying to rely on file based appraisal
has the downside that somebody might write to file after appraisal and it
is racy.

Alternative is that one can copy file contents in memory buffer and pass
buffer and signature to kernel and ask whether signatures are valid.

Hence introduce an IMA function to be able verify signature of meory
buffer. This will in turn be called the keyctl() which will provide
this facility to user space.

This can be used by kexec to verify signature of bzImage being loaded.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/integrity.h   |  19 +++++++-
 security/integrity/digsig.c | 115 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index b26bd7d..36c9a6d 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -11,6 +11,7 @@
 #define _LINUX_INTEGRITY_H
 
 #include <linux/fs.h>
+#include <linux/key.h>
 
 enum integrity_status {
 	INTEGRITY_PASS = 0,
@@ -30,7 +31,6 @@ enum evm_ima_xattr_type {
 #ifdef CONFIG_INTEGRITY
 extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
 extern void integrity_inode_free(struct inode *inode);
-
 #else
 static inline struct integrity_iint_cache *
 				integrity_inode_get(struct inode *inode)
@@ -42,5 +42,22 @@ static inline void integrity_inode_free(struct inode *inode)
 {
 	return;
 }
+
 #endif /* CONFIG_INTEGRITY */
+
+#ifdef CONFIG_INTEGRITY_SIGNATURE
+extern int integrity_verify_user_buffer_digsig(struct key *keyring,
+				const char __user *data,
+				unsigned long data_len,
+				char *sig, unsigned int siglen);
+#else
+static inline int integrity_verify_user_buffer_digsig(struct key *keyring,
+				const char __user *data,
+				unsigned long data_len,
+				char *sig, unsigned int siglen)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_INTEGRITY_SIGNATURE */
+
 #endif /* _LINUX_INTEGRITY_H */
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 153cff4..166a7dd 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -16,6 +16,7 @@
 #include <linux/rbtree.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <linux/sched.h>
 #include <crypto/hash.h>
 #include <crypto/public_key.h>
 
@@ -104,3 +105,117 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return integrity_digsig_verify_keyring(keyring[id], sig, siglen,
 						digest, digestlen);
 }
+
+static int integrity_calc_user_buffer_hash(enum pkey_hash_algo hash_algo,
+					const char __user *data,
+					unsigned long data_len, char **_digest,
+					unsigned int *digest_len)
+{
+	char *buffer, *digest;
+	unsigned long len;
+	struct crypto_shash *tfm;
+	size_t desc_size, digest_size;
+	struct shash_desc *desc;
+	int ret;
+
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	/* TODO: allow different kind of hash */
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[hash_algo], 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
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
+	do {
+		len = min(data_len, PAGE_SIZE - ((size_t)data & ~PAGE_MASK));
+		ret = -EFAULT;
+		if (copy_from_user(buffer, data, len) != 0)
+			goto out_free_digest;
+
+		ret = crypto_shash_update(desc, buffer, len);
+                if (ret)
+                        break;
+
+		data_len -= len;
+		data += len;
+
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+	} while (data_len > 0);
+
+	if (!ret) {
+		ret = crypto_shash_final(desc, digest);
+		*_digest = digest;
+		*digest_len = digest_size;
+		digest = NULL;
+	}
+
+out_free_digest:
+	if (digest)
+		kfree(digest);
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	kfree(buffer);
+	return ret;
+}
+
+/*
+ * Appraise a user buffer with a given digital signature
+ * keyring: keyring to use for appraisal
+ * sig: signature
+ * siglen: length of signature
+ *
+ * Returns 0 on successful appraisal, error otherwise.
+ */
+int integrity_verify_user_buffer_digsig(struct key *keyring,
+				const char __user *data,
+				unsigned long data_len,
+				char *sig, unsigned int siglen)
+{
+	int ret = 0;
+	enum pkey_hash_algo hash_algo;
+	char *digest = NULL;
+	unsigned int digest_len = 0;
+
+	hash_algo = integrity_digsig_get_hash_algo(sig);
+	if (hash_algo < 0)
+		return hash_algo;
+
+	ret = integrity_calc_user_buffer_hash(hash_algo, data, data_len,
+						&digest, &digest_len);
+	if (ret)
+		return ret;
+
+	ret = integrity_digsig_verify_keyring(keyring, sig, siglen, digest,
+					digest_len);
+	kfree(digest);
+	return ret;
+}
-- 
1.8.3.1

