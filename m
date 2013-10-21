Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3JUWnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47119 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3JUWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:48 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 16/23] ima: define new template ima-ng and template fields d-ng and n-ng
Date: Mon, 21 Oct 2013 18:43:01 -0400
Message-Id: <1382395388-8108-17-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-0000232916BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

This patch adds support for the new template 'ima-ng', whose format
is defined as 'd-ng|n-ng'.  These new field definitions remove the
size limitations of the original 'ima' template.  Further, the 'd-ng'
field prefixes the inode digest with the hash algorithim, when
displaying the new larger digest sizes.

Change log:
- scripts/Lindent fixes  - Mimi
- "always true comparison" - reported by Fengguang Wu, resolved Dmitry
- initialize hash_algo variable to HASH_ALGO__LAST
- always prefix digest with hash algorithm - Mimi

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_template.c     |   7 +-
 security/integrity/ima/ima_template_lib.c | 152 ++++++++++++++++++++++++++----
 security/integrity/ima/ima_template_lib.h |   8 ++
 3 files changed, 150 insertions(+), 17 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 8100422..bf38d1a 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -16,7 +16,8 @@
 #include "ima_template_lib.h"
 
 static struct ima_template_desc defined_templates[] = {
-	{.name = IMA_TEMPLATE_IMA_NAME,.fmt = IMA_TEMPLATE_IMA_FMT},
+	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
+	{.name = "ima-ng",.fmt = "d-ng|n-ng"},
 };
 
 static struct ima_template_field supported_fields[] = {
@@ -24,6 +25,10 @@ static struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_digest},
 	{.field_id = "n",.field_init = ima_eventname_init,
 	 .field_show = ima_show_template_string},
+	{.field_id = "d-ng",.field_init = ima_eventdigest_ng_init,
+	 .field_show = ima_show_template_digest_ng},
+	{.field_id = "n-ng",.field_init = ima_eventname_ng_init,
+	 .field_show = ima_show_template_string},
 };
 
 static struct ima_template_field *lookup_template_field(const char *field_id)
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index e13fc7c..7d84144 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -12,9 +12,25 @@
  * File: ima_template_lib.c
  *      Library of supported template fields.
  */
+#include <crypto/hash_info.h>
+
 #include "ima_template_lib.h"
 
-enum data_formats { DATA_FMT_DIGEST = 0, DATA_FMT_EVENT_NAME, DATA_FMT_STRING };
+static bool ima_template_hash_algo_allowed(u8 algo)
+{
+	if (algo == HASH_ALGO_SHA1 || algo == HASH_ALGO_MD5)
+		return true;
+
+	return false;
+}
+
+enum data_formats {
+	DATA_FMT_DIGEST = 0,
+	DATA_FMT_DIGEST_WITH_ALGO,
+	DATA_FMT_EVENT_NAME,
+	DATA_FMT_STRING
+};
+
 static int ima_write_template_field_data(const void *data, const u32 datalen,
 					 enum data_formats datafmt,
 					 struct ima_field_data *field_data)
@@ -62,12 +78,22 @@ static void ima_show_template_data_ascii(struct seq_file *m,
 					 enum data_formats datafmt,
 					 struct ima_field_data *field_data)
 {
+	u8 *buf_ptr = field_data->data, buflen = field_data->len;
+
 	switch (datafmt) {
+	case DATA_FMT_DIGEST_WITH_ALGO:
+		buf_ptr = strnchr(field_data->data, buflen, ':');
+		if (buf_ptr != field_data->data)
+			seq_printf(m, "%s", field_data->data);
+
+		/* skip ':' and '\0' */
+		buf_ptr += 2;
+		buflen -= buf_ptr - field_data->data;
 	case DATA_FMT_DIGEST:
-		ima_print_digest(m, field_data->data, field_data->len);
+		ima_print_digest(m, buf_ptr, buflen);
 		break;
 	case DATA_FMT_STRING:
-		seq_printf(m, "%s", field_data->data);
+		seq_printf(m, "%s", buf_ptr);
 		break;
 	default:
 		break;
@@ -108,14 +134,59 @@ void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
 	ima_show_template_field_data(m, show, DATA_FMT_DIGEST, field_data);
 }
 
+void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
+				 struct ima_field_data *field_data)
+{
+	ima_show_template_field_data(m, show, DATA_FMT_DIGEST_WITH_ALGO,
+				     field_data);
+}
+
 void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data)
 {
 	ima_show_template_field_data(m, show, DATA_FMT_STRING, field_data);
 }
 
+static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
+				       struct ima_field_data *field_data,
+				       bool size_limit)
+{
+	/*
+	 * digest formats:
+	 *  - DATA_FMT_DIGEST: digest
+	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
+	 *    where <hash algo> is provided if the hash algoritm is not
+	 *    SHA1 or MD5
+	 */
+	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
+	enum data_formats fmt = DATA_FMT_DIGEST;
+	u32 offset = 0;
+
+	if (!size_limit) {
+		fmt = DATA_FMT_DIGEST_WITH_ALGO;
+		if (hash_algo < HASH_ALGO__LAST)
+			offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1,
+					   "%s", hash_algo_name[hash_algo]);
+		buffer[offset] = ':';
+		offset += 2;
+	}
+
+	if (digest)
+		memcpy(buffer + offset, digest, digestsize);
+	else
+		/*
+		 * If digest is NULL, the event being recorded is a violation.
+		 * Make room for the digest by increasing the offset of
+		 * IMA_DIGEST_SIZE.
+		 */
+		offset += IMA_DIGEST_SIZE;
+
+	return ima_write_template_field_data(buffer, offset + digestsize,
+					     fmt, field_data);
+}
+
 /*
- * This function writes the digest of an event.
+ * This function writes the digest of an event (with size limit).
  */
 int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 			 const unsigned char *filename,
@@ -125,8 +196,8 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 		struct ima_digest_data hdr;
 		char digest[IMA_MAX_DIGEST_SIZE];
 	} hash;
-	u8 *cur_digest = hash.hdr.digest;
-	u32 cur_digestsize = IMA_DIGEST_SIZE;
+	u8 *cur_digest = NULL;
+	u32 cur_digestsize = 0;
 	struct inode *inode;
 	int result;
 
@@ -135,7 +206,7 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 	if (!iint)		/* recording a violation. */
 		goto out;
 
-	if (iint->ima_hash->algo == ima_hash_algo) {
+	if (ima_template_hash_algo_allowed(iint->ima_hash->algo)) {
 		cur_digest = iint->ima_hash->digest;
 		cur_digestsize = iint->ima_hash->length;
 		goto out;
@@ -145,7 +216,8 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 		return -EINVAL;
 
 	inode = file_inode(file);
-	hash.hdr.algo = ima_hash_algo;
+	hash.hdr.algo = ima_template_hash_algo_allowed(ima_hash_algo) ?
+	    ima_hash_algo : HASH_ALGO_SHA1;
 	result = ima_calc_file_hash(file, &hash.hdr);
 	if (result) {
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
@@ -153,20 +225,46 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 				    "failed", result, 0);
 		return result;
 	}
+	cur_digest = hash.hdr.digest;
+	cur_digestsize = hash.hdr.length;
 out:
-	return ima_write_template_field_data(cur_digest, cur_digestsize,
-					     DATA_FMT_DIGEST, field_data);
+	return ima_eventdigest_init_common(cur_digest, cur_digestsize, -1,
+					   field_data, true);
 }
 
 /*
- * This function writes the name of an event.
+ * This function writes the digest of an event (without size limit).
  */
-int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
-		       const unsigned char *filename,
-		       struct ima_field_data *field_data)
+int ima_eventdigest_ng_init(struct integrity_iint_cache *iint,
+			    struct file *file, const unsigned char *filename,
+			    struct ima_field_data *field_data)
+{
+	u8 *cur_digest = NULL, hash_algo = HASH_ALGO__LAST;
+	u32 cur_digestsize = 0;
+
+	/* If iint is NULL, we are recording a violation. */
+	if (!iint)
+		goto out;
+
+	cur_digest = iint->ima_hash->digest;
+	cur_digestsize = iint->ima_hash->length;
+
+	hash_algo = iint->ima_hash->algo;
+out:
+	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
+					   hash_algo, field_data, false);
+}
+
+static int ima_eventname_init_common(struct integrity_iint_cache *iint,
+				     struct file *file,
+				     const unsigned char *filename,
+				     struct ima_field_data *field_data,
+				     bool size_limit)
 {
 	const char *cur_filename = NULL;
 	u32 cur_filename_len = 0;
+	enum data_formats fmt = size_limit ?
+	    DATA_FMT_EVENT_NAME : DATA_FMT_STRING;
 
 	BUG_ON(filename == NULL && file == NULL);
 
@@ -174,7 +272,7 @@ int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
 		cur_filename = filename;
 		cur_filename_len = strlen(filename);
 
-		if (cur_filename_len <= IMA_EVENT_NAME_LEN_MAX)
+		if (!size_limit || cur_filename_len <= IMA_EVENT_NAME_LEN_MAX)
 			goto out;
 	}
 
@@ -189,5 +287,27 @@ int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
 		cur_filename_len = IMA_EVENT_NAME_LEN_MAX;
 out:
 	return ima_write_template_field_data(cur_filename, cur_filename_len,
-					     DATA_FMT_EVENT_NAME, field_data);
+					     fmt, field_data);
+}
+
+/*
+ * This function writes the name of an event (with size limit).
+ */
+int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
+		       const unsigned char *filename,
+		       struct ima_field_data *field_data)
+{
+	return ima_eventname_init_common(iint, file, filename,
+					 field_data, true);
+}
+
+/*
+ * This function writes the name of an event (without size limit).
+ */
+int ima_eventname_ng_init(struct integrity_iint_cache *iint, struct file *file,
+			  const unsigned char *filename,
+			  struct ima_field_data *field_data)
+{
+	return ima_eventname_init_common(iint, file, filename,
+					 field_data, false);
 }
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
index 2cecc83..16c5e78 100644
--- a/security/integrity/ima/ima_template_lib.h
+++ b/security/integrity/ima/ima_template_lib.h
@@ -20,6 +20,8 @@
 
 void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data);
+void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
+				 struct ima_field_data *field_data);
 void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data);
 int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
@@ -28,4 +30,10 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
 		       const unsigned char *filename,
 		       struct ima_field_data *field_data);
+int ima_eventdigest_ng_init(struct integrity_iint_cache *iint,
+			    struct file *file, const unsigned char *filename,
+			    struct ima_field_data *field_data);
+int ima_eventname_ng_init(struct integrity_iint_cache *iint, struct file *file,
+			  const unsigned char *filename,
+			  struct ima_field_data *field_data);
 #endif /* __LINUX_IMA_TEMPLATE_LIB_H */
-- 
1.8.1.4

