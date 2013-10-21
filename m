Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3JUWte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:49:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59009 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3JUWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:36 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 13/23] ima: define new function ima_alloc_init_template() to API
Date: Mon, 21 Oct 2013 18:42:58 -0400
Message-Id: <1382395388-8108-14-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-8236-0000-0000-000002F7D1D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

Instead of allocating and initializing the template entry from multiple
places (eg. boot aggregate, violation, and regular measurements), this
patch defines a new function called ima_alloc_init_template().  The new
function allocates and initializes the measurement entry with the inode
digest and the filename.

In respect to the current behavior, it truncates the file name passed
in the 'filename' argument if the latter's size is greater than 255 bytes
and the passed file descriptor is NULL.

Changelog:
- initialize 'hash' variable for non TPM case - Mimi
- conform to expectation for 'iint' to be defined as a pointer. - Mimi
- add missing 'file' dependency for recalculating file hash. - Mimi

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h      |  3 ++
 security/integrity/ima/ima_api.c  | 88 ++++++++++++++++++++++++++-------------
 security/integrity/ima/ima_init.c | 24 ++++++-----
 3 files changed, 76 insertions(+), 39 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 27d2ffb..da03d33 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -107,6 +107,9 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
+int ima_alloc_init_template(struct integrity_iint_cache *iint,
+			    struct file *file, const unsigned char *filename,
+			    struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
 void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index a0fe504..29dd43d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -24,6 +24,62 @@
 static const char *IMA_TEMPLATE_NAME = "ima";
 
 /*
+ * ima_alloc_init_template - create and initialize a new template entry
+ */
+int ima_alloc_init_template(struct integrity_iint_cache *iint,
+			    struct file *file, const unsigned char *filename,
+			    struct ima_template_entry **entry)
+{
+	struct ima_template_entry *e;
+	int result = 0;
+
+	e = kzalloc(sizeof(**entry), GFP_NOFS);
+	if (!e)
+		return -ENOMEM;
+
+	memset(&(e)->template, 0, sizeof(e->template));
+	if (!iint)		/* IMA measurement violation entry */
+		goto out;
+
+	if (iint->ima_hash->algo != ima_hash_algo) {
+		struct inode *inode;
+		struct {
+			struct ima_digest_data hdr;
+			char digest[IMA_MAX_DIGEST_SIZE];
+		} hash;
+
+		if (!file) {
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		inode = file_inode(file);
+		hash.hdr.algo = ima_hash_algo;
+		hash.hdr.length = SHA1_DIGEST_SIZE;
+		result = ima_calc_file_hash(file, &hash.hdr);
+		if (result) {
+			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					    filename, "collect_data",
+					    "failed", result, 0);
+			goto out_free;
+		} else
+			memcpy(e->template.digest, hash.hdr.digest,
+			       hash.hdr.length);
+	} else
+		memcpy(e->template.digest, iint->ima_hash->digest,
+		       iint->ima_hash->length);
+out:
+	strcpy(e->template.file_name,
+	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX && file != NULL) ?
+	       file->f_dentry->d_name.name : filename);
+	*entry = e;
+	return 0;
+out_free:
+	kfree(e);
+	return result;
+}
+
+/*
  * ima_store_template - store ima template measurements
  *
  * Calculate the hash of a template entry, add the template entry
@@ -90,13 +146,11 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	/* can overflow, only indicator */
 	atomic_long_inc(&ima_htable.violations);
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry) {
+	result = ima_alloc_init_template(NULL, file, filename, &entry);
+	if (result < 0) {
 		result = -ENOMEM;
 		goto err_out;
 	}
-	memset(&entry->template, 0, sizeof(entry->template));
-	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
 	result = ima_store_template(entry, violation, inode, filename);
 	if (result < 0)
 		kfree(entry);
@@ -220,34 +274,12 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	if (iint->flags & IMA_MEASURED)
 		return;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry) {
+	result = ima_alloc_init_template(iint, file, filename, &entry);
+	if (result < 0) {
 		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 				    op, audit_cause, result, 0);
 		return;
 	}
-	memset(&entry->template, 0, sizeof(entry->template));
-	if (iint->ima_hash->algo != ima_hash_algo) {
-		struct {
-			struct ima_digest_data hdr;
-			char digest[IMA_MAX_DIGEST_SIZE];
-		} hash;
-
-		hash.hdr.algo = ima_hash_algo;
-		result = ima_calc_file_hash(file, &hash.hdr);
-		if (result)
-			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
-					    filename, "collect_data", "failed",
-					    result, 0);
-		else
-			memcpy(entry->template.digest, hash.hdr.digest,
-			       hash.hdr.length);
-	} else
-		memcpy(entry->template.digest, iint->ima_hash->digest,
-		       iint->ima_hash->length);
-	strcpy(entry->template.file_name,
-	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX) ?
-	       file->f_dentry->d_name.name : filename);
 
 	result = ima_store_template(entry, violation, inode, filename);
 	if (!result || result == -EEXIST)
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index d42fac3..50e15e6 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -43,34 +43,36 @@ int ima_used_chip;
 static void __init ima_add_boot_aggregate(void)
 {
 	struct ima_template_entry *entry;
+	struct integrity_iint_cache tmp_iint, *iint = &tmp_iint;
 	const char *op = "add_boot_aggregate";
 	const char *audit_cause = "ENOMEM";
 	int result = -ENOMEM;
-	int violation = 1;
+	int violation = 0;
 	struct {
 		struct ima_digest_data hdr;
 		char digest[TPM_DIGEST_SIZE];
 	} hash;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		goto err_out;
+	memset(iint, 0, sizeof(*iint));
+	memset(&hash, 0, sizeof(hash));
+	iint->ima_hash = &hash.hdr;
+	iint->ima_hash->algo = HASH_ALGO_SHA1;
+	iint->ima_hash->length = SHA1_DIGEST_SIZE;
 
-	memset(&entry->template, 0, sizeof(entry->template));
-	strncpy(entry->template.file_name, boot_aggregate_name,
-		IMA_EVENT_NAME_LEN_MAX);
 	if (ima_used_chip) {
-		violation = 0;
-		hash.hdr.algo = HASH_ALGO_SHA1;
 		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {
 			audit_cause = "hashing_error";
 			kfree(entry);
 			goto err_out;
 		}
-		memcpy(entry->template.digest, hash.hdr.digest,
-		       hash.hdr.length);
 	}
+
+	result = ima_alloc_init_template(iint, NULL, boot_aggregate_name,
+					 &entry);
+	if (result < 0)
+		return;
+
 	result = ima_store_template(entry, violation, NULL,
 				    boot_aggregate_name);
 	if (result < 0)
-- 
1.8.1.4

