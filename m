Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3JUWvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:51:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33888 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3JUWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:29 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 06/23] ima: use dynamically allocated hash storage
Date: Mon, 21 Oct 2013 18:42:51 -0400
Message-Id: <1382395388-8108-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-1542-0000-0000-0000027C6A2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

For each inode in the IMA policy, an iint is allocated.  To support
larger hash digests, the iint digest size changed from 20 bytes to
the maximum supported hash digest size.  Instead of allocating the
maximum size, which most likely is not needed, this patch dynamically
allocates the needed hash storage.

Changelog:
- fix krealloc bug

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/iint.c             |  2 ++
 security/integrity/ima/ima_api.c      | 57 +++++++++++++++++++++++------------
 security/integrity/ima/ima_appraise.c | 16 +++++-----
 security/integrity/integrity.h        |  4 +--
 4 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index 74522db..c49d3f1 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -70,6 +70,8 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode)
 
 static void iint_free(struct integrity_iint_cache *iint)
 {
+	kfree(iint->ima_hash);
+	iint->ima_hash = NULL;
 	iint->version = 0;
 	iint->flags = 0UL;
 	iint->ima_file_status = INTEGRITY_UNKNOWN;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1dba98e..5a7942e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -44,7 +44,10 @@ int ima_store_template(struct ima_template_entry *entry,
 	const char *op = "add_template_measure";
 	const char *audit_cause = "hashing_error";
 	int result;
-	struct ima_digest_data hash;
+	struct {
+		struct ima_digest_data hdr;
+		char digest[IMA_MAX_DIGEST_SIZE];
+	} hash;
 
 	memset(entry->digest, 0, sizeof(entry->digest));
 	entry->template_name = IMA_TEMPLATE_NAME;
@@ -52,14 +55,14 @@ int ima_store_template(struct ima_template_entry *entry,
 
 	if (!violation) {
 		result = ima_calc_buffer_hash(&entry->template,
-					      entry->template_len, &hash);
+					      entry->template_len, &hash.hdr);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
 					    entry->template_name, op,
 					    audit_cause, result, 0);
 			return result;
 		}
-		memcpy(entry->digest, hash.digest, hash.length);
+		memcpy(entry->digest, hash.hdr.digest, hash.hdr.length);
 	}
 	result = ima_add_template_entry(entry, violation, op, inode);
 	return result;
@@ -146,6 +149,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_dentry->d_name.name;
 	int result = 0;
+	struct {
+		struct ima_digest_data hdr;
+		char digest[IMA_MAX_DIGEST_SIZE];
+	} hash;
 
 	if (xattr_value)
 		*xattr_len = ima_read_xattr(file->f_dentry, xattr_value);
@@ -154,16 +161,23 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 		u64 i_version = file_inode(file)->i_version;
 
 		/* use default hash algorithm */
-		iint->ima_hash.algo = ima_hash_algo;
+		hash.hdr.algo = ima_hash_algo;
 
 		if (xattr_value)
-			ima_get_hash_algo(*xattr_value, *xattr_len,
-					  &iint->ima_hash);
+			ima_get_hash_algo(*xattr_value, *xattr_len, &hash.hdr);
 
-		result = ima_calc_file_hash(file, &iint->ima_hash);
+		result = ima_calc_file_hash(file, &hash.hdr);
 		if (!result) {
-			iint->version = i_version;
-			iint->flags |= IMA_COLLECTED;
+			int length = sizeof(hash.hdr) + hash.hdr.length;
+			void *tmpbuf = krealloc(iint->ima_hash, length,
+						GFP_NOFS);
+			if (tmpbuf) {
+				iint->ima_hash = tmpbuf;
+				memcpy(iint->ima_hash, &hash, length);
+				iint->version = i_version;
+				iint->flags |= IMA_COLLECTED;
+			} else
+				result = -ENOMEM;
 		}
 	}
 	if (result)
@@ -208,21 +222,24 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		return;
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
-	if (iint->ima_hash.algo != ima_hash_algo) {
-		struct ima_digest_data hash;
+	if (iint->ima_hash->algo != ima_hash_algo) {
+		struct {
+			struct ima_digest_data hdr;
+			char digest[IMA_MAX_DIGEST_SIZE];
+		} hash;
 
-		hash.algo = ima_hash_algo;
-		result = ima_calc_file_hash(file, &hash);
+		hash.hdr.algo = ima_hash_algo;
+		result = ima_calc_file_hash(file, &hash.hdr);
 		if (result)
 			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
 					    filename, "collect_data", "failed",
 					    result, 0);
 		else
-			memcpy(entry->template.digest, hash.digest,
-			       hash.length);
+			memcpy(entry->template.digest, hash.hdr.digest,
+			       hash.hdr.length);
 	} else
-		memcpy(entry->template.digest, iint->ima_hash.digest,
-		       iint->ima_hash.length);
+		memcpy(entry->template.digest, iint->ima_hash->digest,
+		       iint->ima_hash->length);
 	strcpy(entry->template.file_name,
 	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX) ?
 	       file->f_dentry->d_name.name : filename);
@@ -238,14 +255,14 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename)
 {
 	struct audit_buffer *ab;
-	char hash[(iint->ima_hash.length * 2) + 1];
+	char hash[(iint->ima_hash->length * 2) + 1];
 	int i;
 
 	if (iint->flags & IMA_AUDITED)
 		return;
 
-	for (i = 0; i < iint->ima_hash.length; i++)
-		hex_byte_pack(hash + (i * 2), iint->ima_hash.digest[i]);
+	for (i = 0; i < iint->ima_hash->length; i++)
+		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
 	hash[i * 2] = '\0';
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index e1865a6..116630c 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -45,10 +45,10 @@ int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func)
 static int ima_fix_xattr(struct dentry *dentry,
 			 struct integrity_iint_cache *iint)
 {
-	iint->ima_hash.type = IMA_XATTR_DIGEST;
+	iint->ima_hash->type = IMA_XATTR_DIGEST;
 	return __vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
-				     &iint->ima_hash.type,
-				     1 + iint->ima_hash.length, 0);
+				     &iint->ima_hash->type,
+				     1 + iint->ima_hash->length, 0);
 }
 
 /* Return specific func appraised cached result */
@@ -186,13 +186,13 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			status = INTEGRITY_FAIL;
 			break;
 		}
-		if (xattr_len - 1 >= iint->ima_hash.length)
+		if (xattr_len - 1 >= iint->ima_hash->length)
 			/* xattr length may be longer. md5 hash in previous
 			   version occupied 20 bytes in xattr, instead of 16
 			 */
 			rc = memcmp(xattr_value->digest,
-				    iint->ima_hash.digest,
-				    iint->ima_hash.length);
+				    iint->ima_hash->digest,
+				    iint->ima_hash->length);
 		else
 			rc = -EINVAL;
 		if (rc) {
@@ -206,8 +206,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		iint->flags |= IMA_DIGSIG;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
 					     (const char *)xattr_value, rc,
-					     iint->ima_hash.digest,
-					     iint->ima_hash.length);
+					     iint->ima_hash->digest,
+					     iint->ima_hash->length);
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
 		} else if (rc) {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index aead6b2..5429ca5 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -67,7 +67,7 @@ struct ima_digest_data {
 	u8 algo;
 	u8 length;
 	u8 type;
-	u8 digest[IMA_MAX_DIGEST_SIZE];
+	u8 digest[0];
 } __packed;
 
 /*
@@ -93,7 +93,7 @@ struct integrity_iint_cache {
 	enum integrity_status ima_bprm_status:4;
 	enum integrity_status ima_module_status:4;
 	enum integrity_status evm_status:4;
-	struct ima_digest_data ima_hash;
+	struct ima_digest_data *ima_hash;
 };
 
 /* rbtree tree calls to lookup, insert, delete
-- 
1.8.1.4

