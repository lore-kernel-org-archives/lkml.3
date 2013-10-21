Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3JUWrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:47:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47103 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab3JUWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:40 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 14/23] ima: new templates management mechanism
Date: Mon, 21 Oct 2013 18:42:59 -0400
Message-Id: <1382395388-8108-15-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-0000232916B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

The original 'ima' template is fixed length, containing the filedata hash
and pathname.  The filedata hash is limited to 20 bytes (md5/sha1).  The
pathname is a null terminated string, limited to 255 characters.  To
overcome these limitations and to add additional file metadata, it is
necessary to extend the current version of IMA by defining additional
templates.

The main reason to introduce this feature is that, each time a new
template is defined, the functions that generate and display the
measurement list would include the code for handling a new format and,
thus, would significantly grow over time.

This patch set solves this problem by separating the template management
from the remaining IMA code. The core of this solution is the definition
of two new data structures: a template descriptor, to determine which
information should be included in the measurement list, and a template
field, to generate and display data of a given type.

To define a new template field, developers define the field identifier
and implement two functions, init() and show(), respectively to generate
and display measurement entries.  Initially, this patch set defines the
following template fields (support for additional data types will be
added later):
 - 'd': the digest of the event (i.e. the digest of a measured file),
        calculated with the SHA1 or MD5 hash algorithm;
 - 'n': the name of the event (i.e. the file name), with size up to
        255 bytes;
 - 'd-ng': the digest of the event, calculated with an arbitrary hash
           algorithm (field format: [<hash algo>:]digest, where the digest
           prefix is shown only if the hash algorithm is not SHA1 or MD5);
 - 'n-ng': the name of the event, without size limitations.

Defining a new template descriptor requires specifying the template format,
a string of field identifiers separated by the '|' character.  This patch
set defines the following template descriptors:
 - "ima": its format is 'd|n';
 - "ima-ng" (default): its format is 'd-ng|n-ng'

Further details about the new template architecture can be found in
Documentation/security/IMA-templates.txt.

Changelog:
- don't defer calling ima_init_template() - Mimi
- don't define ima_lookup_template_desc() until used - Mimi
- squashed with documentation patch - Mimi

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/security/00-INDEX          |   2 +
 Documentation/security/IMA-templates.txt |  87 ++++++++++++++++++++++++
 security/integrity/ima/Makefile          |   2 +-
 security/integrity/ima/ima.h             |  29 ++++++++
 security/integrity/ima/ima_init.c        |   4 ++
 security/integrity/ima/ima_template.c    | 112 +++++++++++++++++++++++++++++++
 6 files changed, 235 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/security/IMA-templates.txt
 create mode 100644 security/integrity/ima/ima_template.c

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index 414235c..45c82fd 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -22,3 +22,5 @@ keys.txt
 	- description of the kernel key retention service.
 tomoyo.txt
 	- documentation on the TOMOYO Linux Security Module.
+IMA-templates.txt
+	- documentation on the template management mechanism for IMA.
diff --git a/Documentation/security/IMA-templates.txt b/Documentation/security/IMA-templates.txt
new file mode 100644
index 0000000..a777e5f
--- /dev/null
+++ b/Documentation/security/IMA-templates.txt
@@ -0,0 +1,87 @@
+                       IMA Template Management Mechanism
+
+
+==== INTRODUCTION ====
+
+The original 'ima' template is fixed length, containing the filedata hash
+and pathname. The filedata hash is limited to 20 bytes (md5/sha1).
+The pathname is a null terminated string, limited to 255 characters.
+To overcome these limitations and to add additional file metadata, it is
+necessary to extend the current version of IMA by defining additional
+templates. For example, information that could be possibly reported are
+the inode UID/GID or the LSM labels either of the inode and of the process
+that is accessing it.
+
+However, the main problem to introduce this feature is that, each time
+a new template is defined, the functions that generate and display
+the measurements list would include the code for handling a new format
+and, thus, would significantly grow over the time.
+
+The proposed solution solves this problem by separating the template
+management from the remaining IMA code. The core of this solution is the
+definition of two new data structures: a template descriptor, to determine
+which information should be included in the measurement list; a template
+field, to generate and display data of a given type.
+
+Managing templates with these structures is very simple. To support
+a new data type, developers define the field identifier and implement
+two functions, init() and show(), respectively to generate and display
+measurement entries. Defining a new template descriptor requires
+specifying the template format, a string of field identifiers separated
+by the '|' character. While in the current implementation it is possible
+to define new template descriptors only by adding their definition in the
+template specific code (ima_template.c), in a future version it will be
+possible to register a new template on a running kernel by supplying to IMA
+the desired format string. In this version, IMA initializes at boot time
+all defined template descriptors by translating the format into an array
+of template fields structures taken from the set of the supported ones.
+
+After the initialization step, IMA will call ima_alloc_init_template()
+(new function defined within the patches for the new template management
+mechanism) to generate a new measurement entry by using the template
+descriptor chosen through the kernel configuration or through the newly
+introduced 'ima_template=' kernel command line parameter. It is during this
+phase that the advantages of the new architecture are clearly shown:
+the latter function will not contain specific code to handle a given template
+but, instead, it simply calls the init() method of the template fields
+associated to the chosen template descriptor and store the result (pointer
+to allocated data and data length) in the measurement entry structure.
+
+The same mechanism is employed to display measurements entries.
+The functions ima[_ascii]_measurements_show() retrieve, for each entry,
+the template descriptor used to produce that entry and call the show()
+method for each item of the array of template fields structures.
+
+
+
+==== SUPPORTED TEMPLATE FIELDS AND DESCRIPTORS ====
+
+In the following, there is the list of supported template fields
+('<identifier>': description), that can be used to define new template
+descriptors by adding their identifier to the format string
+(support for more data types will be added later):
+
+ - 'd': the digest of the event (i.e. the digest of a measured file),
+        calculated with the SHA1 or MD5 hash algorithm;
+ - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
+ - 'd-ng': the digest of the event, calculated with an arbitrary hash
+           algorithm (field format: [<hash algo>:]digest, where the digest
+           prefix is shown only if the hash algorithm is not SHA1 or MD5);
+ - 'n-ng': the name of the event, without size limitations.
+
+
+Below, there is the list of defined template descriptors:
+ - "ima": its format is 'd|n';
+ - "ima-ng" (default): its format is 'd-ng|n-ng'.
+
+
+
+==== USE ====
+
+To specify the template descriptor to be used to generate measurement entries,
+currently the following methods are supported:
+
+ - select a template descriptor among those supported in the kernel
+   configuration ('ima-ng' is the default choice);
+ - specify a template descriptor name from the kernel command line through
+   the 'ima_template=' parameter.
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 56dfee7..7fe4ae3 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o
+	 ima_policy.o ima_template.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index da03d33..c85718f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -36,12 +36,39 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_HASH_BITS 9
 #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
 
+#define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
+#define IMA_TEMPLATE_NUM_FIELDS_MAX	15
+
 /* set during initialization */
 extern int ima_initialized;
 extern int ima_used_chip;
 extern int ima_hash_algo;
 extern int ima_appraise;
 
+/* IMA template field data definition */
+struct ima_field_data {
+	u8 *data;
+	u32 len;
+};
+
+/* IMA template field definition */
+struct ima_template_field {
+	const char field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN];
+	int (*field_init) (struct integrity_iint_cache *iint, struct file *file,
+			   const unsigned char *filename,
+			   struct ima_field_data *field_data);
+	void (*field_show) (struct seq_file *m, enum ima_show_type show,
+			    struct ima_field_data *field_data);
+};
+
+/* IMA template descriptor definition */
+struct ima_template_desc {
+	char *name;
+	char *fmt;
+	int num_fields;
+	struct ima_template_field **fields;
+};
+
 /* IMA inode template definition */
 struct ima_template_data {
 	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
@@ -79,6 +106,8 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause);
 int ima_init_crypto(void);
 
+int ima_init_template(void);
+
 /*
  * used to protect h_table and sha_table
  */
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 50e15e6..f84aec5 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -99,6 +99,10 @@ int __init ima_init(void)
 	rc = ima_init_crypto();
 	if (rc)
 		return rc;
+	rc = ima_init_template();
+	if (rc != 0)
+		return rc;
+
 	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	ima_init_policy();
 
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
new file mode 100644
index 0000000..7e86783
--- /dev/null
+++ b/security/integrity/ima/ima_template.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (C) 2013 Politecnico di Torino, Italy
+ *                    TORSEC group -- http://security.polito.it
+ *
+ * Author: Roberto Sassu <roberto.sassu@polito.it>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_template.c
+ *      Helpers to manage template descriptors.
+ */
+#include "ima.h"
+
+static struct ima_template_desc defined_templates[] = {
+};
+
+static struct ima_template_field supported_fields[] = {
+};
+
+static struct ima_template_field *ima_lookup_template_field(
+							const char *field_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(supported_fields); i++)
+		if (strncmp(supported_fields[i].field_id, field_id,
+			    IMA_TEMPLATE_FIELD_ID_MAX_LEN) == 0)
+			return &supported_fields[i];
+	return NULL;
+}
+
+static int ima_template_fmt_size(char *template_fmt)
+{
+	char c;
+	int template_fmt_len = strlen(template_fmt);
+	int i = 0, j = 0;
+
+	while (i < template_fmt_len) {
+		c = template_fmt[i];
+		if (c == '|')
+			j++;
+		i++;
+	}
+
+	return j + 1;
+}
+
+static int template_desc_init_fields(char *template_fmt,
+				     struct ima_template_field ***fields,
+				     int *num_fields)
+{
+	char *c, *template_fmt_ptr = template_fmt;
+	int template_num_fields = ima_template_fmt_size(template_fmt);
+	int i, result = 0;
+
+	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
+		return -EINVAL;
+
+	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
+	if (*fields == NULL) {
+		result = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
+	     i < template_num_fields; i++) {
+		struct ima_template_field *f = ima_lookup_template_field(c);
+
+		if (!f) {
+			result = -ENOENT;
+			goto out;
+		}
+		(*fields)[i] = f;
+	}
+	*num_fields = i;
+	return 0;
+out:
+	kfree(*fields);
+	*fields = NULL;
+	return result;
+}
+
+static int init_defined_templates(void)
+{
+	int i = 0;
+	int result = 0;
+
+	/* Init defined templates. */
+	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
+		struct ima_template_desc *template = &defined_templates[i];
+
+		result = template_desc_init_fields(template->fmt,
+						   &(template->fields),
+						   &(template->num_fields));
+		if (result < 0)
+			return result;
+	}
+	return result;
+}
+
+int ima_init_template(void)
+{
+	int result;
+
+	result = init_defined_templates();
+	if (result < 0)
+		return result;
+
+	return 0;
+}
-- 
1.8.1.4

