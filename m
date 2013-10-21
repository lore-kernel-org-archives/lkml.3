Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3JUWo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:44:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47128 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3JUWnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 17/23] ima: switch to new template management mechanism
Date: Mon, 21 Oct 2013 18:43:02 -0400
Message-Id: <1382395388-8108-18-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-0000232916C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

This patch performs the switch to the new template mechanism by modifying
the functions ima_alloc_init_template(), ima_measurements_show() and
ima_ascii_measurements_show(). The old function ima_template_show() was
removed as it is no longer needed. Also, if the template descriptor used
to generate a measurement entry is not 'ima', the whole length of field
data stored for an entry is provided before the data itself through the
binary_runtime_measurement interface.

Changelog:
- unnecessary to use strncmp() (Mimi Zohar)
- create new variable 'field' in ima_alloc_init_template() (Roberto Sassu)
- use GFP_NOFS flag in ima_alloc_init_template() (Roberto Sassu)
- new variable 'num_fields' in ima_store_template() (Roberto Sassu,
  proposed by Mimi Zohar)
- rename ima_calc_buffer_hash/template_hash() to ima_calc_field_array_hash(),
  something more generic (Mimi, requested by Dmitry)
- sparse error fix - Fengguang Wu
- fix lindent warnings
- always include the field length in the template data length
- include the template field length variable size in the template data length
- include both the template field data and field length in the template digest
  calculation. Simplifies verifying the template digest. (Mimi)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h          | 19 ++++-----
 security/integrity/ima/ima_api.c      | 75 ++++++++++++-----------------------
 security/integrity/ima/ima_crypto.c   | 34 ++++++++++++----
 security/integrity/ima/ima_fs.c       | 54 ++++++++++++-------------
 security/integrity/ima/ima_template.c | 22 ++++++++++
 5 files changed, 107 insertions(+), 97 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e1f081d..72d013e 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -72,17 +72,11 @@ struct ima_template_desc {
 	struct ima_template_field **fields;
 };
 
-/* IMA inode template definition */
-struct ima_template_data {
-	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
-	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
-};
-
 struct ima_template_entry {
 	u8 digest[TPM_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
-	const char *template_name;
-	int template_len;
-	struct ima_template_data template;
+	struct ima_template_desc *template_desc; /* template descriptor */
+	u32 template_data_len;
+	struct ima_field_data template_data[0];	/* template related data */
 };
 
 struct ima_queue_entry {
@@ -102,14 +96,16 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
 			   const unsigned char *filename);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
-int ima_calc_buffer_hash(const void *data, int len,
-			 struct ima_digest_data *hash);
+int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+			      struct ima_digest_data *hash);
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause);
 int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, int size);
+struct ima_template_desc *ima_template_desc_current(void);
+int ima_init_template(void);
 
 int ima_init_template(void);
 
@@ -146,7 +142,6 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
-void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show);
 const char *ima_d_path(struct path *path, char **pathbuf);
 
 /* rbtree tree calls to lookup, insert, delete
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 29dd43d..baa3481 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -21,8 +21,6 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
-static const char *IMA_TEMPLATE_NAME = "ima";
-
 /*
  * ima_alloc_init_template - create and initialize a new template entry
  */
@@ -30,52 +28,32 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
 			    struct ima_template_entry **entry)
 {
-	struct ima_template_entry *e;
-	int result = 0;
+	struct ima_template_desc *template_desc = ima_template_desc_current();
+	int i, result = 0;
 
-	e = kzalloc(sizeof(**entry), GFP_NOFS);
-	if (!e)
+	*entry = kzalloc(sizeof(**entry) + template_desc->num_fields *
+			 sizeof(struct ima_field_data), GFP_NOFS);
+	if (!*entry)
 		return -ENOMEM;
 
-	memset(&(e)->template, 0, sizeof(e->template));
-	if (!iint)		/* IMA measurement violation entry */
-		goto out;
-
-	if (iint->ima_hash->algo != ima_hash_algo) {
-		struct inode *inode;
-		struct {
-			struct ima_digest_data hdr;
-			char digest[IMA_MAX_DIGEST_SIZE];
-		} hash;
+	for (i = 0; i < template_desc->num_fields; i++) {
+		struct ima_template_field *field = template_desc->fields[i];
+		u32 len;
 
-		if (!file) {
-			result = -EINVAL;
-			goto out_free;
-		}
+		result = field->field_init(iint, file, filename,
+					   &((*entry)->template_data[i]));
+		if (result != 0)
+			goto out;
 
-		inode = file_inode(file);
-		hash.hdr.algo = ima_hash_algo;
-		hash.hdr.length = SHA1_DIGEST_SIZE;
-		result = ima_calc_file_hash(file, &hash.hdr);
-		if (result) {
-			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
-					    filename, "collect_data",
-					    "failed", result, 0);
-			goto out_free;
-		} else
-			memcpy(e->template.digest, hash.hdr.digest,
-			       hash.hdr.length);
-	} else
-		memcpy(e->template.digest, iint->ima_hash->digest,
-		       iint->ima_hash->length);
-out:
-	strcpy(e->template.file_name,
-	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX && file != NULL) ?
-	       file->f_dentry->d_name.name : filename);
-	*entry = e;
+		len = (*entry)->template_data[i].len;
+		(*entry)->template_data_len += sizeof(len);
+		(*entry)->template_data_len += len;
+	}
+	(*entry)->template_desc = template_desc;
 	return 0;
-out_free:
-	kfree(e);
+out:
+	kfree(*entry);
+	*entry = NULL;
 	return result;
 }
 
@@ -101,24 +79,23 @@ int ima_store_template(struct ima_template_entry *entry,
 {
 	const char *op = "add_template_measure";
 	const char *audit_cause = "hashing_error";
+	char *template_name = entry->template_desc->name;
 	int result;
 	struct {
 		struct ima_digest_data hdr;
 		char digest[TPM_DIGEST_SIZE];
 	} hash;
 
-	memset(entry->digest, 0, sizeof(entry->digest));
-	entry->template_name = IMA_TEMPLATE_NAME;
-	entry->template_len = sizeof(entry->template);
-
 	if (!violation) {
+		int num_fields = entry->template_desc->num_fields;
+
 		/* this function uses default algo */
 		hash.hdr.algo = HASH_ALGO_SHA1;
-		result = ima_calc_buffer_hash(&entry->template,
-					      entry->template_len, &hash.hdr);
+		result = ima_calc_field_array_hash(&entry->template_data[0],
+						   num_fields, &hash.hdr);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
-					    entry->template_name, op,
+					    template_name, op,
 					    audit_cause, result, 0);
 			return result;
 		}
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 22be23f..676e029 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -137,26 +137,46 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 }
 
 /*
- * Calculate the hash of a given buffer
+ * Calculate the hash of template data
  */
-static int ima_calc_buffer_hash_tfm(const void *buf, int len,
-				    struct ima_digest_data *hash,
-				    struct crypto_shash *tfm)
+static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
+					 int num_fields,
+					 struct ima_digest_data *hash,
+					 struct crypto_shash *tfm)
 {
 	struct {
 		struct shash_desc shash;
 		char ctx[crypto_shash_descsize(tfm)];
 	} desc;
+	int rc, i;
 
 	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
-	return crypto_shash_digest(&desc.shash, buf, len, hash->digest);
+	rc = crypto_shash_init(&desc.shash);
+	if (rc != 0)
+		return rc;
+
+	for (i = 0; i < num_fields; i++) {
+		rc = crypto_shash_update(&desc.shash,
+					 (const u8 *) &field_data[i].len,
+					 sizeof(field_data[i].len));
+		rc = crypto_shash_update(&desc.shash, field_data[i].data,
+					 field_data[i].len);
+		if (rc)
+			break;
+	}
+
+	if (!rc)
+		rc = crypto_shash_final(&desc.shash, hash->digest);
+
+	return rc;
 }
 
-int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
+int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+			      struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	int rc;
@@ -165,7 +185,7 @@ int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
-	rc = ima_calc_buffer_hash_tfm(buf, len, hash, tfm);
+	rc = ima_calc_field_array_hash_tfm(field_data, num_fields, hash, tfm);
 
 	ima_free_tfm(tfm);
 
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 414862e..d47a7c8 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -110,6 +110,7 @@ void ima_putc(struct seq_file *m, void *data, int datalen)
  *       char[20]=template digest
  *       32bit-le=template name size
  *       char[n]=template name
+ *       [eventdata length]
  *       eventdata[n]=template specific data
  */
 static int ima_measurements_show(struct seq_file *m, void *v)
@@ -119,6 +120,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	struct ima_template_entry *e;
 	int namelen;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
+	int i;
 
 	/* get entry */
 	e = qe->entry;
@@ -136,15 +138,22 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
-	namelen = strlen(e->template_name);
+	namelen = strlen(e->template_desc->name);
 	ima_putc(m, &namelen, sizeof namelen);
 
 	/* 4th:  template name */
-	ima_putc(m, (void *)e->template_name, namelen);
+	ima_putc(m, e->template_desc->name, namelen);
+
+	/* 5th:  template length (except for 'ima' template) */
+	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
+		ima_putc(m, &e->template_data_len,
+			 sizeof(e->template_data_len));
 
-	/* 5th:  template specific data */
-	ima_template_show(m, (struct ima_template_data *)&e->template,
-			  IMA_SHOW_BINARY);
+	/* 6th:  template specific data */
+	for (i = 0; i < e->template_desc->num_fields; i++) {
+		e->template_desc->fields[i]->field_show(m, IMA_SHOW_BINARY,
+							&e->template_data[i]);
+	}
 	return 0;
 }
 
@@ -175,33 +184,13 @@ void ima_print_digest(struct seq_file *m, u8 *digest, int size)
 		seq_printf(m, "%02x", *(digest + i));
 }
 
-void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show)
-{
-	struct ima_template_data *entry = e;
-	int namelen;
-
-	switch (show) {
-	case IMA_SHOW_ASCII:
-		ima_print_digest(m, entry->digest, IMA_DIGEST_SIZE);
-		seq_printf(m, " %s\n", entry->file_name);
-		break;
-	case IMA_SHOW_BINARY:
-		ima_putc(m, entry->digest, IMA_DIGEST_SIZE);
-
-		namelen = strlen(entry->file_name);
-		ima_putc(m, &namelen, sizeof namelen);
-		ima_putc(m, entry->file_name, namelen);
-	default:
-		break;
-	}
-}
-
 /* print in ascii */
 static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 {
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	int i;
 
 	/* get entry */
 	e = qe->entry;
@@ -215,11 +204,18 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3th:  template name */
-	seq_printf(m, " %s ", e->template_name);
+	seq_printf(m, " %s", e->template_desc->name);
 
 	/* 4th:  template specific data */
-	ima_template_show(m, (struct ima_template_data *)&e->template,
-			  IMA_SHOW_ASCII);
+	for (i = 0; i < e->template_desc->num_fields; i++) {
+		seq_puts(m, " ");
+		if (e->template_data[i].len == 0)
+			continue;
+
+		e->template_desc->fields[i]->field_show(m, IMA_SHOW_ASCII,
+							&e->template_data[i]);
+	}
+	seq_puts(m, "\n");
 	return 0;
 }
 
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index bf38d1a..1c4cf19 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -31,6 +31,20 @@ static struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_string},
 };
 
+static struct ima_template_desc *ima_template;
+
+static struct ima_template_desc *lookup_template_desc(const char *name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
+		if (strcmp(defined_templates[i].name, name) == 0)
+			return defined_templates + i;
+	}
+
+	return NULL;
+}
+
 static struct ima_template_field *lookup_template_field(const char *field_id)
 {
 	int i;
@@ -110,6 +124,14 @@ static int init_defined_templates(void)
 	return result;
 }
 
+struct ima_template_desc *ima_template_desc_current(void)
+{
+	if (!ima_template)
+		ima_template = lookup_template_desc(IMA_TEMPLATE_IMA_NAME);
+
+	return ima_template;
+}
+
 int ima_init_template(void)
 {
 	int result;
-- 
1.8.1.4

