Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab3BFTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:05:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54426 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3BFTFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:05:21 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ima: rename hash calculation functions
Date: Wed,  6 Feb 2013 14:04:14 -0500
Message-Id: <1360177454-5233-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1360177454-5233-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1360177454-5233-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020619-9360-0000-0000-0000103C5ABE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Rename hash calculation functions to reflect meaning
and change argument order in conventional way.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        | 4 ++--
 security/integrity/ima/ima_api.c    | 6 +++---
 security/integrity/ima/ima_crypto.c | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 5a94f9c..6e69697 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -84,8 +84,8 @@ void ima_fs_cleanup(void);
 int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode);
-int ima_calc_hash(struct file *file, char *digest);
-int ima_calc_template_hash(int template_len, void *template, char *digest);
+int ima_calc_file_hash(struct file *file, char *digest);
+int ima_calc_buffer_hash(const void *data, int len, char *digest);
 int ima_calc_boot_aggregate(char *digest);
 void ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 9382a4c..d9030b2 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -50,8 +50,8 @@ int ima_store_template(struct ima_template_entry *entry,
 	entry->template_len = sizeof(entry->template);
 
 	if (!violation) {
-		result = ima_calc_template_hash(entry->template_len,
-						&entry->template,
+		result = ima_calc_buffer_hash(&entry->template,
+						entry->template_len,
 						entry->digest);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
@@ -148,7 +148,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 		u64 i_version = file->f_dentry->d_inode->i_version;
 
 		iint->ima_xattr.type = IMA_XATTR_DIGEST;
-		result = ima_calc_hash(file, iint->ima_xattr.digest);
+		result = ima_calc_file_hash(file, iint->ima_xattr.digest);
 		if (!result) {
 			iint->version = i_version;
 			iint->flags |= IMA_COLLECTED;
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 920f49c..b691e0f 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -40,7 +40,7 @@ int ima_init_crypto(void)
 /*
  * Calculate the MD5/SHA1 file digest
  */
-int ima_calc_hash(struct file *file, char *digest)
+int ima_calc_file_hash(struct file *file, char *digest)
 {
 	loff_t i_size, offset = 0;
 	char *rbuf;
@@ -93,9 +93,9 @@ out:
 }
 
 /*
- * Calculate the hash of a given template
+ * Calculate the hash of a given buffer
  */
-int ima_calc_template_hash(int template_len, void *template, char *digest)
+int ima_calc_buffer_hash(const void *data, int len, char *digest)
 {
 	struct {
 		struct shash_desc shash;
@@ -105,7 +105,7 @@ int ima_calc_template_hash(int template_len, void *template, char *digest)
 	desc.shash.tfm = ima_shash_tfm;
 	desc.shash.flags = 0;
 
-	return crypto_shash_digest(&desc.shash, template, template_len, digest);
+	return crypto_shash_digest(&desc.shash, data, len, digest);
 }
 
 static void __init ima_pcrread(int idx, u8 *pcr)
-- 
1.8.1.rc3

