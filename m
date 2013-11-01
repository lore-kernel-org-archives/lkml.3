Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3KADj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 23:39:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47523 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3KADj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 23:39:27 -0400
Message-ID: <1383277161.18864.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: [PATCH v2] ima: extend the measurement list to include the file
 signature
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@polito.it>
Date: Thu, 31 Oct 2013 23:39:21 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110103-6688-0000-0000-0000030FA78B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a new template called 'ima-sig', which includes
the file signature in the template data, in addition to the file's
digest and pathname.

A template is composed of a set of fields.  Associated with each
field is an initialization and display function.  This patch defines
a new template field called 'sig', the initialization function
ima_eventsig_init(), and the display function ima_show_template_sig().

This patch modifies the .field_init() function definition to include
the 'security.ima' extended attribute and length.

Changelog:
- remove unused code (Dmitry Kasatkin)
- avoid calling ima_write_template_field_data() unnecesarily (Roberto Sassu)
- rename DATA_FMT_SIG to DATA_FMT_HEX
- cleanup ima_eventsig_init() based on Roberto's comments

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/Kconfig            |  3 +++
 security/integrity/ima/ima.h              | 10 +++++---
 security/integrity/ima/ima_api.c          | 14 ++++++++----
 security/integrity/ima/ima_init.c         |  2 +-
 security/integrity/ima/ima_main.c         |  3 ++-
 security/integrity/ima/ima_template.c     |  3 +++
 security/integrity/ima/ima_template_lib.c | 38 +++++++++++++++++++++++++++++--
 security/integrity/ima/ima_template_lib.h | 12 +++++++++-
 8 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 351a58e..81a2797 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -63,6 +63,8 @@ choice
 		bool "ima"
 	config IMA_NG_TEMPLATE
 		bool "ima-ng (default)"
+	config IMA_SIG_TEMPLATE
+		bool "ima-sig"
 endchoice
 
 config IMA_DEFAULT_TEMPLATE
@@ -70,6 +72,7 @@ config IMA_DEFAULT_TEMPLATE
 	depends on IMA
 	default "ima" if IMA_TEMPLATE
 	default "ima-ng" if IMA_NG_TEMPLATE
+	default "ima-sig" if IMA_SIG_TEMPLATE
 
 choice
 	prompt "Default integrity hash algorithm"
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 72d013e..bf03c6a 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -59,7 +59,8 @@ struct ima_template_field {
 	const char field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN];
 	int (*field_init) (struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename,
-			   struct ima_field_data *field_data);
+			   struct evm_ima_xattr_data *xattr_value,
+			   int xattr_len, struct ima_field_data *field_data);
 	void (*field_show) (struct seq_file *m, enum ima_show_type show,
 			    struct ima_field_data *field_data);
 };
@@ -134,12 +135,15 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct evm_ima_xattr_data **xattr_value,
 			    int *xattr_len);
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
-			   const unsigned char *filename);
+			   const unsigned char *filename,
+			   struct evm_ima_xattr_data *xattr_value,
+			   int xattr_len);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
-			    struct ima_template_entry **entry);
+			    struct evm_ima_xattr_data *xattr_value,
+			    int xattr_len, struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
 const char *ima_d_path(struct path *path, char **pathbuf);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 5fcc806..0e75408 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -26,7 +26,8 @@
  */
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
-			    struct ima_template_entry **entry)
+			    struct evm_ima_xattr_data *xattr_value,
+			    int xattr_len, struct ima_template_entry **entry)
 {
 	struct ima_template_desc *template_desc = ima_template_desc_current();
 	int i, result = 0;
@@ -41,6 +42,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 		u32 len;
 
 		result = field->field_init(iint, file, filename,
+					   xattr_value, xattr_len,
 					   &((*entry)->template_data[i]));
 		if (result != 0)
 			goto out;
@@ -123,7 +125,8 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	/* can overflow, only indicator */
 	atomic_long_inc(&ima_htable.violations);
 
-	result = ima_alloc_init_template(NULL, file, filename, &entry);
+	result = ima_alloc_init_template(NULL, file, filename,
+					 NULL, 0, &entry);
 	if (result < 0) {
 		result = -ENOMEM;
 		goto err_out;
@@ -239,7 +242,9 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
  * Must be called with iint->mutex held.
  */
 void ima_store_measurement(struct integrity_iint_cache *iint,
-			   struct file *file, const unsigned char *filename)
+			   struct file *file, const unsigned char *filename,
+			   struct evm_ima_xattr_data *xattr_value,
+			   int xattr_len)
 {
 	const char *op = "add_template_measure";
 	const char *audit_cause = "ENOMEM";
@@ -251,7 +256,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	if (iint->flags & IMA_MEASURED)
 		return;
 
-	result = ima_alloc_init_template(iint, file, filename, &entry);
+	result = ima_alloc_init_template(iint, file, filename,
+					 xattr_value, xattr_len, &entry);
 	if (result < 0) {
 		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 				    op, audit_cause, result, 0);
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index f84aec5..15f34bd 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -69,7 +69,7 @@ static void __init ima_add_boot_aggregate(void)
 	}
 
 	result = ima_alloc_init_template(iint, NULL, boot_aggregate_name,
-					 &entry);
+					 NULL, 0, &entry);
 	if (result < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 14d4cb5..149ee11 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -225,7 +225,8 @@ static int process_measurement(struct file *file, const char *filename,
 		pathname = (const char *)file->f_dentry->d_name.name;
 
 	if (action & IMA_MEASURE)
-		ima_store_measurement(iint, file, pathname);
+		ima_store_measurement(iint, file, pathname,
+				      xattr_value, xattr_len);
 	if (action & IMA_APPRAISE_SUBMASK)
 		rc = ima_appraise_measurement(_func, iint, file, pathname,
 					      xattr_value, xattr_len);
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 0002214..4e5da99 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -20,6 +20,7 @@
 static struct ima_template_desc defined_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng",.fmt = "d-ng|n-ng"},
+	{.name = "ima-sig",.fmt = "d-ng|n-ng|sig"},
 };
 
 static struct ima_template_field supported_fields[] = {
@@ -31,6 +32,8 @@ static struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_digest_ng},
 	{.field_id = "n-ng",.field_init = ima_eventname_ng_init,
 	 .field_show = ima_show_template_string},
+	{.field_id = "sig",.field_init = ima_eventsig_init,
+	 .field_show = ima_show_template_sig},
 };
 
 static struct ima_template_desc *ima_template;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 7d84144..6d66ad6 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -28,7 +28,8 @@ enum data_formats {
 	DATA_FMT_DIGEST = 0,
 	DATA_FMT_DIGEST_WITH_ALGO,
 	DATA_FMT_EVENT_NAME,
-	DATA_FMT_STRING
+	DATA_FMT_STRING,
+	DATA_FMT_HEX
 };
 
 static int ima_write_template_field_data(const void *data, const u32 datalen,
@@ -90,6 +91,9 @@ static void ima_show_template_data_ascii(struct seq_file *m,
 		buf_ptr += 2;
 		buflen -= buf_ptr - field_data->data;
 	case DATA_FMT_DIGEST:
+	case DATA_FMT_HEX:
+		if (!buflen)
+			break;
 		ima_print_digest(m, buf_ptr, buflen);
 		break;
 	case DATA_FMT_STRING:
@@ -147,6 +151,12 @@ void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 	ima_show_template_field_data(m, show, DATA_FMT_STRING, field_data);
 }
 
+void ima_show_template_sig(struct seq_file *m, enum ima_show_type show,
+			   struct ima_field_data *field_data)
+{
+	ima_show_template_field_data(m, show, DATA_FMT_HEX, field_data);
+}
+
 static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
 				       struct ima_field_data *field_data,
 				       bool size_limit)
@@ -190,6 +200,7 @@ static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
  */
 int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 			 const unsigned char *filename,
+			 struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			 struct ima_field_data *field_data)
 {
 	struct {
@@ -237,7 +248,8 @@ out:
  */
 int ima_eventdigest_ng_init(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
-			    struct ima_field_data *field_data)
+			    struct evm_ima_xattr_data *xattr_value,
+			    int xattr_len, struct ima_field_data *field_data)
 {
 	u8 *cur_digest = NULL, hash_algo = HASH_ALGO__LAST;
 	u32 cur_digestsize = 0;
@@ -295,6 +307,7 @@ out:
  */
 int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
 		       const unsigned char *filename,
+		       struct evm_ima_xattr_data *xattr_value, int xattr_len,
 		       struct ima_field_data *field_data)
 {
 	return ima_eventname_init_common(iint, file, filename,
@@ -306,8 +319,29 @@ int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
  */
 int ima_eventname_ng_init(struct integrity_iint_cache *iint, struct file *file,
 			  const unsigned char *filename,
+			  struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			  struct ima_field_data *field_data)
 {
 	return ima_eventname_init_common(iint, file, filename,
 					 field_data, false);
 }
+
+/*
+ *  ima_eventsig_init - include the file signature as part of the template data
+ */
+int ima_eventsig_init(struct integrity_iint_cache *iint, struct file *file,
+		      const unsigned char *filename,
+		      struct evm_ima_xattr_data *xattr_value, int xattr_len,
+		      struct ima_field_data *field_data)
+{
+	enum data_formats fmt = DATA_FMT_HEX;
+	int rc = 0;
+
+	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+		goto out;
+
+	rc = ima_write_template_field_data(xattr_value, xattr_len, fmt,
+					   field_data);
+out:
+	return rc;
+}
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
index 16c5e78..63f6b52 100644
--- a/security/integrity/ima/ima_template_lib.h
+++ b/security/integrity/ima/ima_template_lib.h
@@ -24,16 +24,26 @@ void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
 				 struct ima_field_data *field_data);
 void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data);
+void ima_show_template_sig(struct seq_file *m, enum ima_show_type show,
+			   struct ima_field_data *field_data);
 int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 			 const unsigned char *filename,
+			 struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			 struct ima_field_data *field_data);
 int ima_eventname_init(struct integrity_iint_cache *iint, struct file *file,
 		       const unsigned char *filename,
+		       struct evm_ima_xattr_data *xattr_value, int xattr_len,
 		       struct ima_field_data *field_data);
 int ima_eventdigest_ng_init(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
-			    struct ima_field_data *field_data);
+			    struct evm_ima_xattr_data *xattr_value,
+			    int xattr_len, struct ima_field_data *field_data);
 int ima_eventname_ng_init(struct integrity_iint_cache *iint, struct file *file,
 			  const unsigned char *filename,
+			  struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			  struct ima_field_data *field_data);
+int ima_eventsig_init(struct integrity_iint_cache *iint, struct file *file,
+		      const unsigned char *filename,
+		      struct evm_ima_xattr_data *xattr_value, int xattr_len,
+		      struct ima_field_data *field_data);
 #endif /* __LINUX_IMA_TEMPLATE_LIB_H */
-- 
1.8.1.4



