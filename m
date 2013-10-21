Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3JUWv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:51:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47058 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab3JUWn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:26 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 03/23] ima: provide support for arbitrary hash algorithms
Date: Mon, 21 Oct 2013 18:42:48 -0400
Message-Id: <1382395388-8108-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-000023291692
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

In preparation of supporting more hash algorithms with larger hash sizes
needed for signature verification, this patch replaces the 20 byte sized
digest, with a more flexible structure.  The new structure includes the
hash algorithm, digest size, and digest.

Changelog:
- recalculate filedata hash for the measurement list, if the signature
  hash digest size is greater than 20 bytes.
- use generic HASH_ALGO_
- make ima_calc_file_hash static
- scripts lindent and checkpatch fixes

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 crypto/asymmetric_keys/x509_parser.h     |  2 --
 crypto/asymmetric_keys/x509_public_key.c |  3 +-
 security/integrity/ima/Kconfig           |  1 +
 security/integrity/ima/ima.h             |  7 +++--
 security/integrity/ima/ima_api.c         | 32 +++++++++++++++------
 security/integrity/ima/ima_appraise.c    | 20 +++++++------
 security/integrity/ima/ima_crypto.c      | 49 ++++++++++++++++++++++++++------
 security/integrity/ima/ima_main.c        |  6 ++--
 security/integrity/integrity.h           | 15 ++++++++--
 9 files changed, 100 insertions(+), 35 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 04c81bd..87d9cc2 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -21,8 +21,6 @@ struct x509_certificate {
 	char		*authority;		/* Authority key fingerprint as hex */
 	struct tm	valid_from;
 	struct tm	valid_to;
-	enum pkey_algo	pkey_algo : 8;		/* Public key algorithm */
-	enum hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
 	const void	*tbs;			/* Signed data */
 	unsigned	tbs_size;		/* Size of signed data */
 	unsigned	raw_sig_size;		/* Size of sigature */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 0a6bfad..f83300b 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -213,7 +213,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 cert->valid_to.tm_year + 1900, cert->valid_to.tm_mon + 1,
 		 cert->valid_to.tm_mday, cert->valid_to.tm_hour,
 		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
-	pr_devel("Cert Signature: %s\n",
+	pr_devel("Cert Signature: %s + %s\n",
+		 pkey_algo_name[cert->sig.pkey_algo],
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
 	if (!cert->fingerprint) {
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 39196ab..e6628e7 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -9,6 +9,7 @@ config IMA
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
+	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM && X86
 	select TCG_IBMVTPM if TCG_TPM && PPC64
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index b3dd616..eb86032 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -39,7 +39,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 /* set during initialization */
 extern int ima_initialized;
 extern int ima_used_chip;
-extern char *ima_hash;
+extern int ima_hash_algo;
 extern int ima_appraise;
 
 /* IMA inode template definition */
@@ -70,8 +70,9 @@ void ima_fs_cleanup(void);
 int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode);
-int ima_calc_file_hash(struct file *file, char *digest);
-int ima_calc_buffer_hash(const void *data, int len, char *digest);
+int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
+int ima_calc_buffer_hash(const void *data, int len,
+			 struct ima_digest_data *hash);
 int ima_calc_boot_aggregate(char *digest);
 void ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1c03e8f1..e531fe2 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -44,6 +44,7 @@ int ima_store_template(struct ima_template_entry *entry,
 	const char *op = "add_template_measure";
 	const char *audit_cause = "hashing_error";
 	int result;
+	struct ima_digest_data hash;
 
 	memset(entry->digest, 0, sizeof(entry->digest));
 	entry->template_name = IMA_TEMPLATE_NAME;
@@ -51,14 +52,14 @@ int ima_store_template(struct ima_template_entry *entry,
 
 	if (!violation) {
 		result = ima_calc_buffer_hash(&entry->template,
-						entry->template_len,
-						entry->digest);
+					      entry->template_len, &hash);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
 					    entry->template_name, op,
 					    audit_cause, result, 0);
 			return result;
 		}
+		memcpy(entry->digest, hash.digest, hash.length);
 	}
 	result = ima_add_template_entry(entry, violation, op, inode);
 	return result;
@@ -147,8 +148,9 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file_inode(file)->i_version;
 
-		iint->ima_xattr.type = IMA_XATTR_DIGEST;
-		result = ima_calc_file_hash(file, iint->ima_xattr.digest);
+		/* use default hash algorithm */
+		iint->ima_hash.algo = ima_hash_algo;
+		result = ima_calc_file_hash(file, &iint->ima_hash);
 		if (!result) {
 			iint->version = i_version;
 			iint->flags |= IMA_COLLECTED;
@@ -196,7 +198,21 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		return;
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
-	memcpy(entry->template.digest, iint->ima_xattr.digest, IMA_DIGEST_SIZE);
+	if (iint->ima_hash.algo != ima_hash_algo) {
+		struct ima_digest_data hash;
+
+		hash.algo = ima_hash_algo;
+		result = ima_calc_file_hash(file, &hash);
+		if (result)
+			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					    filename, "collect_data", "failed",
+					    result, 0);
+		else
+			memcpy(entry->template.digest, hash.digest,
+			       hash.length);
+	} else
+		memcpy(entry->template.digest, iint->ima_hash.digest,
+		       iint->ima_hash.length);
 	strcpy(entry->template.file_name,
 	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX) ?
 	       file->f_dentry->d_name.name : filename);
@@ -212,14 +228,14 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename)
 {
 	struct audit_buffer *ab;
-	char hash[(IMA_DIGEST_SIZE * 2) + 1];
+	char hash[(iint->ima_hash.length * 2) + 1];
 	int i;
 
 	if (iint->flags & IMA_AUDITED)
 		return;
 
-	for (i = 0; i < IMA_DIGEST_SIZE; i++)
-		hex_byte_pack(hash + (i * 2), iint->ima_xattr.digest[i]);
+	for (i = 0; i < iint->ima_hash.length; i++)
+		hex_byte_pack(hash + (i * 2), iint->ima_hash.digest[i]);
 	hash[i * 2] = '\0';
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index e3230d6..3833b0fa 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -43,12 +43,12 @@ int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func)
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
-			  struct integrity_iint_cache *iint)
+			 struct integrity_iint_cache *iint)
 {
-	iint->ima_xattr.type = IMA_XATTR_DIGEST;
+	iint->ima_hash.type = IMA_XATTR_DIGEST;
 	return __vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
-				     (u8 *)&iint->ima_xattr,
-				      sizeof(iint->ima_xattr), 0);
+				     &iint->ima_hash.type,
+				     1 + iint->ima_hash.length, 0);
 }
 
 /* Return specific func appraised cached result */
@@ -159,8 +159,12 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			status = INTEGRITY_FAIL;
 			break;
 		}
-		rc = memcmp(xattr_value->digest, iint->ima_xattr.digest,
-			    IMA_DIGEST_SIZE);
+		if (rc - 1 == iint->ima_hash.length)
+			rc = memcmp(xattr_value->digest,
+				    iint->ima_hash.digest,
+				    iint->ima_hash.length);
+		else
+			rc = -EINVAL;
 		if (rc) {
 			cause = "invalid-hash";
 			status = INTEGRITY_FAIL;
@@ -172,8 +176,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		iint->flags |= IMA_DIGSIG;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
 					     xattr_value->digest, rc - 1,
-					     iint->ima_xattr.digest,
-					     IMA_DIGEST_SIZE);
+					     iint->ima_hash.digest,
+					     iint->ima_hash.length);
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
 		} else if (rc) {
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index a02e079..2fd1786 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <crypto/hash.h>
+#include <crypto/hash_info.h>
 #include "ima.h"
 
 static struct crypto_shash *ima_shash_tfm;
@@ -28,10 +29,11 @@ int ima_init_crypto(void)
 {
 	long rc;
 
-	ima_shash_tfm = crypto_alloc_shash(ima_hash, 0, 0);
+	ima_shash_tfm = crypto_alloc_shash(hash_algo_name[ima_hash_algo], 0, 0);
 	if (IS_ERR(ima_shash_tfm)) {
 		rc = PTR_ERR(ima_shash_tfm);
-		pr_err("Can not allocate %s (reason: %ld)\n", ima_hash, rc);
+		pr_err("Can not allocate %s (reason: %ld)\n",
+		       hash_algo_name[ima_hash_algo], rc);
 		return rc;
 	}
 	return 0;
@@ -40,17 +42,19 @@ int ima_init_crypto(void)
 /*
  * Calculate the MD5/SHA1 file digest
  */
-int ima_calc_file_hash(struct file *file, char *digest)
+static int ima_calc_file_hash_tfm(struct file *file,
+				  struct ima_digest_data *hash,
+				  struct crypto_shash *tfm)
 {
 	loff_t i_size, offset = 0;
 	char *rbuf;
 	int rc, read = 0;
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+		char ctx[crypto_shash_descsize(tfm)];
 	} desc;
 
-	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
 	rc = crypto_shash_init(&desc.shash);
@@ -85,17 +89,42 @@ int ima_calc_file_hash(struct file *file, char *digest)
 	}
 	kfree(rbuf);
 	if (!rc)
-		rc = crypto_shash_final(&desc.shash, digest);
+		rc = crypto_shash_final(&desc.shash, hash->digest);
 	if (read)
 		file->f_mode &= ~FMODE_READ;
 out:
 	return rc;
 }
 
+int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+{
+	struct crypto_shash *tfm = ima_shash_tfm;
+	int rc;
+
+	if (hash->algo != ima_hash_algo && hash->algo < HASH_ALGO__LAST) {
+		tfm = crypto_alloc_shash(hash_algo_name[hash->algo], 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			pr_err("Can not allocate %s (reason: %d)\n",
+			       hash_algo_name[hash->algo], rc);
+			return rc;
+		}
+	}
+
+	hash->length = crypto_shash_digestsize(tfm);
+
+	rc = ima_calc_file_hash_tfm(file, hash, tfm);
+
+	if (tfm != ima_shash_tfm)
+		crypto_free_shash(tfm);
+
+	return rc;
+}
+
 /*
  * Calculate the hash of a given buffer
  */
-int ima_calc_buffer_hash(const void *data, int len, char *digest)
+int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
 {
 	struct {
 		struct shash_desc shash;
@@ -105,7 +134,11 @@ int ima_calc_buffer_hash(const void *data, int len, char *digest)
 	desc.shash.tfm = ima_shash_tfm;
 	desc.shash.flags = 0;
 
-	return crypto_shash_digest(&desc.shash, data, len, digest);
+	/* this function uses default algo */
+	hash->algo = ima_hash_algo;
+	hash->length = crypto_shash_digestsize(ima_shash_tfm);
+
+	return crypto_shash_digest(&desc.shash, buf, len, hash->digest);
 }
 
 static void __init ima_pcrread(int idx, u8 *pcr)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 0f359df..7708c21 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/ima.h>
+#include <crypto/hash_info.h>
 
 #include "ima.h"
 
@@ -35,11 +36,12 @@ int ima_appraise = IMA_APPRAISE_ENFORCE;
 int ima_appraise;
 #endif
 
-char *ima_hash = "sha1";
+int ima_hash_algo = HASH_ALGO_SHA1;
+
 static int __init hash_setup(char *str)
 {
 	if (strncmp(str, "md5", 3) == 0)
-		ima_hash = "md5";
+		ima_hash_algo = HASH_ALGO_MD5;
 	return 1;
 }
 __setup("ima_hash=", hash_setup);
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index f867316..0b02ea8 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -59,20 +59,29 @@ enum evm_ima_xattr_type {
 struct evm_ima_xattr_data {
 	u8 type;
 	u8 digest[SHA1_DIGEST_SIZE];
-}  __attribute__((packed));
+} __packed;
+
+#define IMA_MAX_DIGEST_SIZE	64
+
+struct ima_digest_data {
+	u8 algo;
+	u8 length;
+	u8 type;
+	u8 digest[IMA_MAX_DIGEST_SIZE];
+} __packed;
 
 /* integrity data associated with an inode */
 struct integrity_iint_cache {
-	struct rb_node rb_node; /* rooted in integrity_iint_tree */
+	struct rb_node rb_node;	/* rooted in integrity_iint_tree */
 	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
 	unsigned long flags;
-	struct evm_ima_xattr_data ima_xattr;
 	enum integrity_status ima_file_status:4;
 	enum integrity_status ima_mmap_status:4;
 	enum integrity_status ima_bprm_status:4;
 	enum integrity_status ima_module_status:4;
 	enum integrity_status evm_status:4;
+	struct ima_digest_data ima_hash;
 };
 
 /* rbtree tree calls to lookup, insert, delete
-- 
1.8.1.4

